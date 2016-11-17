//
//  VerifyClient.swift
//  NexmoVerify
//
//  Created by Dorian Peake on 13/05/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

import Foundation
import UIKit

/**
    Contains all verification commands available within the Nexmo Verify Service
*/
@objc open class VerifyClient : NSObject {
    
    fileprivate static var Log = Logger(String(describing: VerifyClient.self))
    fileprivate static var instance : VerifyClient?
    
    static var sharedInstance : VerifyClient {
        get {
            if let instance = instance {
                return instance
            }
    
            instance = VerifyClient(nexmoClient: NexmoClient.sharedInstance)
            return instance!
        }
    }
    
    // nexmo sdk services
    fileprivate let nexmoClient : NexmoClient
    fileprivate let serviceExecutor : ServiceExecutor
    fileprivate let verifyService : VerifyService
    fileprivate let checkService : CheckService
    fileprivate let controlService : ControlService
    fileprivate let logoutService : LogoutService
    fileprivate let searchService : SearchService
    
    fileprivate var currentVerifyTask : VerifyTask?

    init(nexmoClient: NexmoClient, serviceExecutor: ServiceExecutor, verifyService: VerifyService, checkService: CheckService, controlService: ControlService, logoutService: LogoutService, searchService: SearchService) {
            self.nexmoClient = nexmoClient
            self.serviceExecutor = serviceExecutor
            self.verifyService = verifyService
            self.checkService = checkService
            self.controlService = controlService
            self.logoutService = logoutService
            self.searchService = searchService
    }
    
    convenience init(nexmoClient: NexmoClient) {
        self.init(nexmoClient: nexmoClient,
                  serviceExecutor: ServiceExecutor(),
                  verifyService: SDKVerifyService(),
                  checkService: SDKCheckService(),
                  controlService: SDKControlService(),
                  logoutService: SDKLogoutService(),
                  searchService: SDKSearchService())
    }
    
    /**
        Attempt to verify a user using Nexmo's Verify Service.
        Once the verification process has been started, updates on its progress
        will be relayed through the callbacks provided.
        
        To check if a user's verification pin code is correct, a subsequent call to checkPinCode should be
        initiated, along with the code provided by the user.
        
        - parameter countryCode: the ISO 3166-1 alpha-2 two-letter country code
        
        - parameter phoneNumber: the local phone number/msisdn of the mobile to verify
        
        - parameter onVerifyInProgress: callback triggered when a verification process has been successfully triggered
        
        - parameter onUserVerified: callback triggered when a user has been successfully verified
        
        - parameter onError: callback triggered when some error has occurred, e.g. wrong pin entered
    */
    @objc(getVerifiedUserWithCountryCode:phoneNumber:verifyInProgressBlock:userVerifiedBlock:errorBlock:)
    open static func getVerifiedUser(countryCode: String?, phoneNumber: String,
                                        onVerifyInProgress: @escaping () -> (),
                                        onUserVerified: @escaping () -> (),
                                        onError: @escaping (_ error: VerifyError) -> ()) {
        sharedInstance.getVerifiedUser(countryCode: countryCode, phoneNumber: phoneNumber, onVerifyInProgress: onVerifyInProgress, onUserVerified: onUserVerified, onError: onError)
    }
    
    func getVerifiedUser(countryCode: String?, phoneNumber: String,
                                        onVerifyInProgress: @escaping () -> (),
                                        onUserVerified: @escaping () -> (),
                                        onError: @escaping (_ error: VerifyError) -> ()) {
        
        if (self.currentVerifyTask?.userStatus == UserStatus.USER_PENDING) {
            VerifyClient.Log.info("Verification attempted but one is already in progress.")
            onError(VerifyError.verificationAlreadyStarted)
            return
        }
        
        // acquire new token for this verification attempt
        let verifyTask = VerifyTask(countryCode: countryCode, phoneNumber: phoneNumber, standalone: false, pushToken: self.nexmoClient.pushToken, onVerifyInProgress: onVerifyInProgress, onUserVerified: onUserVerified, onError: onError)
        self.currentVerifyTask = verifyTask
        
        // begin verification process
        self.verifyService.start(request: self.currentVerifyTask!.createVerifyRequest()) { response, error in
            if let error = error {
                if (error.code == 1000) {
                    onError(.networkError)
                } else {
                onError(.internalError)
                }
                return
            }
            
            if let response = response {
                if let responseCode =  ResponseCode.Code(rawValue: response.resultCode) ,
                        (responseCode == .resultCodeOK ||
                        responseCode == .verificationRestarted ||
                        responseCode == .verificationExpiredRestarted) {
                    
                    verifyTask.setUserState(response.userStatus!)
                    
                    switch (response.userStatus!) {
                        case UserStatus.USER_PENDING:
                            verifyTask.onVerifyInProgress()
                        
                        case UserStatus.USER_VERIFIED:
                            verifyTask.onUserVerified()
                        
                        case UserStatus.USER_EXPIRED:
                            verifyTask.onError(.userExpired)
                        
                        case UserStatus.USER_BLACKLISTED:
                            verifyTask.onError(.userBlacklisted)
                        
                        default:
                            verifyTask.onError(.internalError)
                    }
                } else if let responseCode = ResponseCode.Code(rawValue: response.resultCode),
                          let error = ResponseCode.responseCodeToVerifyError[responseCode] {
                    verifyTask.onError(error)
                } else {
                    verifyTask.onError(.internalError)
                }
            }
        }
    }
    
    /**
        Check whether a pin code (ususally entered by the user) is the correct verification code.
        
        Note: This command is only useful if a verification request is in progress, otherwise the command
        will simply quit and no callbacks will be triggered. If a verification request *is currently in progress*,
        either the onError or onUserVerified callbacks will be triggered, depending on whether the code is correct.
        
        - parameter pinCode: a string containing the pin code to check.
    */
    @objc(checkPinCode:)
    open static func checkPinCode(_ pinCode: String) {
        sharedInstance.checkPinCode(pinCode)
    }
    
    func checkPinCode(_ pinCode: String) {
        if let verifyTask = currentVerifyTask , verifyTask.userStatus == UserStatus.USER_PENDING || verifyTask.standalone {
            checkService.start(request: CheckRequest(verifyTask: verifyTask, pinCode: pinCode)) { response, error in
                if let _ = error {
                    verifyTask.onError(.internalError)
                    return
                }
                
                if let response = response,
                        let responseCode = ResponseCode.Code(rawValue: response.resultCode) {
                    switch (responseCode) {
                        case .resultCodeOK:
                            if (response.userStatus! == UserStatus.USER_VERIFIED) {
                                self.currentVerifyTask?.setUserState(UserStatus.USER_VERIFIED)
                                self.currentVerifyTask?.onUserVerified()
                            }
                        
                        default:
                            if let error = ResponseCode.responseCodeToVerifyError[responseCode] {
                                verifyTask.onError(error)
                            } else {
                                verifyTask.onError(.internalError)
                            }
                    }
                } else {
                    verifyTask.onError(.internalError)
                }
            }
        }
    }
    
    /**
        Check whether a pin code (ususally entered by the user) is the correct verification code.
        A verification attempt does not need to be in progress to call this command. This is useful in the
        case that an App is restarted before the verification is complete.
        
        Note: This version of the command should only be used in cases where an app may restart before verification is complete. Then you have the opportunity to continue with the verification process by calling this function with the appropriate parameters.
        
        - parameter pinCode: a string containing the pin code to check.
    
        - parameter countryCode: The ISO 3166 alpha-2 country code for the specified number
    
        - parameter number: Mobile number to verify
    
        - parameter onUserVerified: Callback which is executed when a user is verified
        
        - parameter onError: Callback which is executed when an error occurs
    */
    @objc(checkPinCode:WithCountryCode:WithNumber:verifyInProgressBlock:errorBlock:)
    open static func checkPinCode(_ pinCode: String, countryCode: String?, number: String, onUserVerified: @escaping () -> (), onError: @escaping (VerifyError) -> ()) {
        sharedInstance.checkPinCode(pinCode, countryCode: countryCode, number: number, onUserVerified: onUserVerified, onError: onError)
    }
    
    func checkPinCode(_ pinCode: String, countryCode: String?, number: String, onUserVerified: @escaping () -> (), onError: @escaping (VerifyError) -> ()) {
        let verifyTask = VerifyTask(countryCode: countryCode,
                                    phoneNumber: number,
                                    standalone: false, /* doesn't mean anything here */
                                    pushToken: nil,
                                    onVerifyInProgress: {},
                                    onUserVerified: onUserVerified,
                                    onError: onError)
        self.currentVerifyTask = verifyTask
        checkService.start(request: CheckRequest(verifyTask: verifyTask, pinCode: pinCode)) { response, error in
            if let _ = error {
                verifyTask.onError(.internalError)
                return
            }
            
            if let response = response,
                    let responseCode = ResponseCode.Code(rawValue: response.resultCode) {
                switch (responseCode) {
                    case .resultCodeOK:
                        if (response.userStatus! == UserStatus.USER_VERIFIED) {
                            self.currentVerifyTask?.setUserState(UserStatus.USER_VERIFIED)
                            self.currentVerifyTask?.onUserVerified()
                        }
                    
                    default:
                        if let error = ResponseCode.responseCodeToVerifyError[responseCode] {
                            verifyTask.onError(error)
                        } else {
                            verifyTask.onError(.internalError)
                        }
                }
            } else {
                verifyTask.onError(.internalError)
            }
        }
    }
    
    /**
        Cancel the ongoing verification request - if one exists
        
        - parameter completionBlock: A callback which is invoked when the cancel request completes or fails (with an NSError)
    */
    @objc(cancelVerificationWithBlock:)
    open static func cancelVerification(_ completionBlock: @escaping (_ error: NSError?) -> ()) {
        sharedInstance.cancelVerification(completionBlock)
    }
    
    func cancelVerification(_ completionBlock: @escaping (_ error: NSError?) -> ()) {
        if let currentVerifyTask = currentVerifyTask {
            controlService.start(request: ControlRequest(.cancel, verifyTask: currentVerifyTask)) { response, error in
                if let error = error {
                    completionBlock(error)
                } else {
                    self.currentVerifyTask = nil
                    completionBlock(nil)
                }
            }
        } else {
            completionBlock(NSError(domain: "VerifyClient", code: 1, userInfo: [NSLocalizedDescriptionKey : "No verification attempt in progress"]))
        }
    }
    
    /**
        Begins the next stage of the verification workflow.
    
        For example having an (SMS)->TTS->TTS and being in the SMS stage,
        invoking this function will move the verification stage onto the first TTS stage:
        SMS->(TTS)->TTS.
        
        - parameter completionBlock: A callback which is invoked when the 'next event'
                request completes or fails (with an NSError)
    */
    @objc(triggerNextEventWithBlock:)
    open static func triggerNextEvent(_ completionBlock: @escaping (_ error: NSError?) -> ()) {
        sharedInstance.triggerNextEvent(completionBlock)
    }
    
    func triggerNextEvent(_ completionBlock: @escaping (_ error: NSError?) -> ()) {
        if let currentVerifyTask = currentVerifyTask {
            controlService.start(request: ControlRequest(.nextEvent, verifyTask: currentVerifyTask)) { response, error in
                if let error = error {
                    completionBlock(error)
                } else {
                    completionBlock(nil)
                }
            }
        } else {
            completionBlock(NSError(domain: "VerifyClient", code: 1, userInfo: [NSLocalizedDescriptionKey : "No verification attempt in progress"]))
        }
    }
    
    /**
        Log's out the current user - if they have already been verified.
        To log out a user is to assume them unverified again.
        
        - parameter number: The user's phone number
        
        - parameter completionBlock: A callback which is invoked when the logout
                request completes of fails (with an NSError)
    */
    @objc(logoutUserWithCountryCode:WithNumber:WithBlock:)
    open static func logoutUser(countryCode: String?, number: String, completionBlock: @escaping (_ error: NSError?) -> ()) {
        sharedInstance.logoutUser(countryCode: countryCode, number: number, completionBlock: completionBlock)
    }
    
    func logoutUser(countryCode: String?, number: String, completionBlock: @escaping (_ error: NSError?) -> ()) {

        let logoutRequest = LogoutRequest(number: number, countryCode: countryCode)
        self.logoutService.start(request: logoutRequest) { response, error in
            if let error = error {
                completionBlock(error)
            } else {
                completionBlock(nil)
            }
        }
    }
    
    /**
        Returns the verification status of a given user. 
        
        This can be one of:
        
            *verified*
                The user has been successfully verified.
    
            *pending*
                A verification request for this user 
                is currently in progress.

            *new*
                This user just been created on the SDK service
            
            *failed*
                A previous verification request for this
                user has failed.
            
            *expired*
                A previous verification request for this
                user expired.
            
            *unverified*
                A user's verified status has been revoked,
                possibly due to timeout.
            
            *blacklisted*
                This user has failed too many verification
                requests and is therefore blacklisted.

            *error*
                An error ocurred during the last verification
                attempt for this user.

            *unknown*
                The user is unknown to the SDK service.
        
        - parameter completionBlock: A callback which is invoked when the logout request
                completes or fails (with an NSError)
    */
    @objc(getUserStatusWithCountryCode:WithNumber:WithBlock:)
    open static func getUserStatus(countryCode: String?, number: String, completionBlock: @escaping (_ status: String?, _ error: NSError?) -> ()) {
        VerifyClient.sharedInstance.getUserStatus(countryCode: countryCode, number: number, completionBlock: completionBlock)
    }
    
    func getUserStatus(countryCode: String?, number: String, completionBlock: @escaping (_ status: String?, _ error: NSError?) -> ()) {
        let searchRequest = SearchRequest(number: number, countryCode: countryCode)
        self.searchService.start(request: searchRequest) { response, error in
            if let error = error {
                completionBlock(nil, error)
            } else {
                completionBlock(response!.userStatus, nil)
            }
        }
        return
    }
    
    /**
        Filters Nexmo Verify push notifications and returns the verify pin code where possible.
        
        - parameter userInfo: The push data passed in through UIApplicationDelegate's
                application:didReceiveRemoteNotification: function.
        
        - parameter performSilentCheck: if true, Nexmo Verify SDK will complete the verification request
                automatically, which verifies the user.
    */
    @objc(handleNotificationWithUserInfo:performSilentCheck:)
    open static func handleNotification(_ userInfo: [AnyHashable: Any], performSilentCheck: Bool = false) -> Bool {
        return VerifyClient.sharedInstance.handleNotification(userInfo, performSilentCheck: performSilentCheck)
    }
    
    func handleNotification(_ userInfo: [AnyHashable: Any], performSilentCheck: Bool) -> Bool {
        guard let payload = (userInfo["NexmoVerify"] as? [AnyHashable: String] ?? userInfo["data"] as? [AnyHashable: String]),
            let pin = payload["pin"] else { return false }
        
        if performSilentCheck {
            checkPinCode(pin)
            
            return true
        }
        
        let controller = UIAlertController(title: "Verify Pin", message: "Your verification pin is \(pin)", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            var topViewController = rootViewController
            
            while topViewController.presentedViewController != nil {
                topViewController = topViewController.presentedViewController!
            }

            topViewController.present(controller, animated: true, completion: nil)
        } else {
            VerifyClient.Log.error("Unable to find root view controller! Cannot present pin [ \(pin) ]")
        }
        
        return true
    }
    
    /// Validate standalone verification
    @objc(verifyStandaloneWithCountryCode:phoneNumber:verifyInProgressBlock:userVerifiedBlock:errorBlock:)
    open static func verifyStandalone(countryCode: String?, phoneNumber: String,
                                        onVerifyInProgress: @escaping () -> (),
                                        onUserVerified:  @escaping () -> (),
                                        onError: @escaping (_ error: VerifyError) -> ()) {
        sharedInstance.verifyStandalone(countryCode: countryCode, phoneNumber: phoneNumber, onVerifyInProgress: onVerifyInProgress, onUserVerified: onUserVerified, onError: onError)
    }
    
    func verifyStandalone(countryCode: String?, phoneNumber: String,
                                        onVerifyInProgress: @escaping () -> (),
                                        onUserVerified: @escaping () -> (),
                                        onError: @escaping (_ error: VerifyError) -> ()) {
        
        if (self.currentVerifyTask?.userStatus == UserStatus.USER_PENDING) {
            VerifyClient.Log.info("Verification attempted but one is already in progress.")
            onError(VerifyError.verificationAlreadyStarted)
            return
        }
        
        // acquire new token for this verification attempt
        let verifyTask = VerifyTask(countryCode: countryCode, phoneNumber: phoneNumber, standalone: true, pushToken: self.nexmoClient.pushToken, onVerifyInProgress: onVerifyInProgress, onUserVerified: onUserVerified, onError: onError)
        self.currentVerifyTask = verifyTask
        
        // begin verification process
        self.verifyService.start(request: self.currentVerifyTask!.createVerifyRequest()) { response, error in
            if let _ = error {
                onError(.internalError)
                return
            }
            
            if let response = response {
                if let responseCode =  ResponseCode.Code(rawValue: response.resultCode) ,
                        (responseCode == .resultCodeOK ||
                        responseCode == .verificationRestarted ||
                        responseCode == .verificationExpiredRestarted) {
                            
                    switch (response.userStatus!) {
                        case UserStatus.USER_VERIFIED:
                            verifyTask.onVerifyInProgress()
                        
                        case UserStatus.USER_EXPIRED:
                            verifyTask.onError(.userExpired)
                        
                        case UserStatus.USER_BLACKLISTED:
                            verifyTask.onError(.userBlacklisted)
                        
                        default:
                            verifyTask.onError(.internalError)
                    }
                } else if let responseCode = ResponseCode.Code(rawValue: response.resultCode),
                          let error = ResponseCode.responseCodeToVerifyError[responseCode] {
                    verifyTask.onError(error)
                } else {
                    verifyTask.onError(.internalError)
                }
            }
        }
    }

    /// Display verification view controller
    @objc(beginManagedVerificationWithMessage:withDelegate:)
    open static func beginManagedVerification(_ message: String, delegate: VerifyUIDelegate) {
        sharedInstance.beginManagedVerification(message, delegate: delegate)
    }
    
    func beginManagedVerification(_ message: String, delegate: VerifyUIDelegate) {
        let bundle = Bundle(for: VerifyClient.self)
        let storyBoard = UIStoryboard(name: "VerifyUI", bundle: bundle)
        let verifyController = storyBoard.instantiateInitialViewController() as! VerifyUIController
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
            print("unable to find root view controller!")
            return
        }
        
        //verifyController.view.frame = rootViewController.view.bounds
        verifyController.delegate = delegate
        verifyController.message = message
        rootViewController.present(verifyController, animated: true, completion: nil)
        
    }
}
