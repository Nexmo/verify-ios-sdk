//
//  VerifyClient.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 13/05/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

import Foundation
import DeviceProperties

/**
    Contains all verification commands available within the Nexmo Verify Service
*/
@objc public class VerifyClient : NSObject {
    
    private static var Log = Logger(toString(VerifyClient))
    private static var instance : VerifyClient?
    static var PARAM_PIN = "pin"
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
    private let nexmoClient : NexmoClient
    private let serviceExecutor : ServiceExecutor
    private let verifyService : VerifyService
    private let checkService : CheckService
    private let controlService : ControlService
    private let logoutService : LogoutService
    private let searchService : SearchService
    
    private var currentVerifyTask : VerifyTask?

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
        
        :param: countryCode the ISO 3166-1 alpha-2 two-letter country code
        
        :param: phoneNumber the local phone number/msisdn of the mobile to verify
        
        :param: onVerifyInProgress callback triggered when a verification process has been successfully triggered
        
        :param: onUserVerified callback triggered when a user has been successfully verified
        
        :param: onError callback triggered when some error has occurred, e.g. wrong pin entered
    */
    @objc(getVerifiedUserWithCountryCode:phoneNumber:verifyInProgressBlock:userVerifiedBlock:errorBlock:)
    public static func getVerifiedUser(#countryCode: String?, phoneNumber: String,
                                        onVerifyInProgress: () -> (),
                                        onUserVerified: () -> (),
                                        onError: (error: VerifyError) -> ()) {
        sharedInstance.getVerifiedUser(countryCode: countryCode, phoneNumber: phoneNumber, onVerifyInProgress: onVerifyInProgress, onUserVerified: onUserVerified, onError: onError)
    }
    
    func getVerifiedUser(#countryCode: String?, phoneNumber: String,
                                        onVerifyInProgress: () -> (),
                                        onUserVerified: () -> (),
                                        onError: (error: VerifyError) -> ()) {
        
        if (self.currentVerifyTask?.userStatus == UserStatus.USER_PENDING) {
            VerifyClient.Log.info("Verification attempted but one is already in progress.")
            onError(error: VerifyError.VERIFICATION_ALREADY_STARTED)
            return
        }
        
        // acquire new token for this verification attempt
        let verifyTask = VerifyTask(countryCode: countryCode, phoneNumber: phoneNumber, gcmToken: self.nexmoClient.gcmToken, onVerifyInProgress: onVerifyInProgress, onUserVerified: onUserVerified, onError: onError)
        self.currentVerifyTask = verifyTask
        
        // begin verification process
        self.verifyService.start(request: self.currentVerifyTask!.createVerifyRequest()) { response, error in
            if let error = error {
                onError(error: .INTERNAL_ERROR)
                return
            }
            
            if let response = response {
                if let responseCode =  ResponseCode.Code(rawValue: response.resultCode) where
                        (responseCode == .RESULT_CODE_OK ||
                        responseCode == .VERIFICATION_RESTARTED ||
                        responseCode == .VERIFICATION_EXPIRED_RESTARTED) {
                    
                    verifyTask.setUserState(response.userStatus!)
                    
                    switch (response.userStatus!) {
                        case UserStatus.USER_PENDING:
                            verifyTask.onVerifyInProgress()
                        
                        case UserStatus.USER_VERIFIED:
                            verifyTask.onUserVerified()
                        
                        case UserStatus.USER_EXPIRED:
                            verifyTask.onError(error: .USER_EXPIRED)
                        
                        case UserStatus.USER_BLACKLISTED:
                            verifyTask.onError(error: .USER_BLACKLISTED)
                        
                        default:
                            verifyTask.onError(error: .INTERNAL_ERROR)
                    }
                } else if let responseCode = ResponseCode.Code(rawValue: response.resultCode),
                          let error = ResponseCode.responseCodeToVerifyError[responseCode] {
                    verifyTask.onError(error: error)
                } else {
                    verifyTask.onError(error: .INTERNAL_ERROR)
                }
            }
        }
    }
    
    /**
        Check whether a pin code (ususally entered by the user) is the correct verification code.
        
        Note: This command is only useful if a verification request is in progress, otherwise the command
        will simply quit and no callbacks will be triggered. If a verification request *is currently in progress*,
        either the onError or onUserVerified callbacks will be triggered, depending on whether the code is correct.
        
        :param: pinCode a string containing the pin code to check.
    */
    @objc(checkPinCode:)
    public static func checkPinCode(pinCode: String) {
        sharedInstance.checkPinCode(pinCode)
    }
    
    func checkPinCode(pinCode: String) {
        VerifyClient.Log.info("checkPinCode called")
        if let verifyTask = currentVerifyTask where verifyTask.userStatus == UserStatus.USER_PENDING {
            checkService.start(request: CheckRequest(verifyTask: verifyTask, pinCode: pinCode),
                onResponse: { response, error in
                    if let error = error {
                        verifyTask.onError(error: .INTERNAL_ERROR)
                        return
                    }
                    
                    if let response = response,
                            let responseCode = ResponseCode.Code(rawValue: response.resultCode) {
                        switch (responseCode) {
                            case .RESULT_CODE_OK:
                                if (response.userStatus! == UserStatus.USER_VERIFIED) {
                                    self.currentVerifyTask?.setUserState(UserStatus.USER_VERIFIED)
                                    self.currentVerifyTask?.onUserVerified()
                                }
                            
                            default:
                                if let error = ResponseCode.responseCodeToVerifyError[responseCode] {
                                    verifyTask.onError(error: error)
                                } else {
                                    verifyTask.onError(error: .INTERNAL_ERROR)
                                }
                        }
                    } else {
                        verifyTask.onError(error: .INTERNAL_ERROR)
                    }
                })
        } else {
            VerifyClient.Log.error("no verify task currently in progress")
        }
    }
    /**
        Cancel the ongoing verification request - if one exists
        
        :param: completionBlock A callback which is invoked when the cancel request completes or fails (with an NSError)
    */
    @objc(cancelVerificationWithBlock:)
    public static func cancelVerification(completionBlock: (error: NSError?) -> ()) {
        sharedInstance.cancelVerification(completionBlock)
    }
    
    func cancelVerification(completionBlock: (error: NSError?) -> ()) {
        if let currentVerifyTask = currentVerifyTask {
            controlService.start(request: ControlRequest(.Cancel, verifyTask: currentVerifyTask)) { response, error in
                if let error = error {
                    completionBlock(error: error)
                } else {
                    completionBlock(error: nil)
                    self.currentVerifyTask = nil
                }
            }
        } else {
            completionBlock(error: NSError(domain: "VerifyClient", code: 1, userInfo: [NSLocalizedDescriptionKey : "No verification attempt in progress"]))
        }
    }
    
    /**
        Begins the next stage of the verification workflow.
    
        For example having an (SMS)->TTS->TTS and being in the SMS stage,
        invoking this function will move the verification stage onto the first TTS stage:
        SMS->(TTS)->TTS.
        
        :param: completionBlock A callback which is invoked when the 'next event'
                request completes or fails (with an NSError)
    */
    @objc(triggerNextEventWithBlock:)
    public static func triggerNextEvent(completionBlock: (error: NSError?) -> ()) {
        sharedInstance.triggerNextEvent(completionBlock)
    }
    
    func triggerNextEvent(completionBlock: (error: NSError?) -> ()) {
        if let currentVerifyTask = currentVerifyTask {
            controlService.start(request: ControlRequest(.NextEvent, verifyTask: currentVerifyTask)) { response, error in
                if let error = error {
                    completionBlock(error: error)
                } else {
                    completionBlock(error: nil)
                }
            }
        } else {
            completionBlock(error: NSError(domain: "VerifyClient", code: 1, userInfo: [NSLocalizedDescriptionKey : "No verification attempt in progress"]))
        }
    }
    
    /**
        Log's out the current user - if they have already been verified.
        To log out a user is to assume them unverified again.
        
        :param: number The user's phone number
        
        :param: completionBlock A callback which is invoked when the logout
                request completes of fails (with an NSError)
    */
    @objc(logoutUserWithCountryCode:WithNumber:WithBlock:)
    public static func logoutUser(#countryCode: String?, number: String, completionBlock: (error: NSError?) -> ()) {
        sharedInstance.logoutUser(countryCode: countryCode, number: number, completionBlock: completionBlock)
    }
    
    func logoutUser(#countryCode: String?, number: String, completionBlock: (error: NSError?) -> ()) {

        var logoutRequest = LogoutRequest(number: number, countryCode: countryCode)
        self.logoutService.start(request: logoutRequest) { response, error in
            if let error = error {
                completionBlock(error: error)
            } else {
                completionBlock(error: nil)
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
        
        :param: completionBlock A callback which is invoked when the logout request
                completes or fails (with an NSError)
    */
    @objc(getUserStatusWithCountryCode:WithNumber:WithBlock:)
    public static func getUserStatus(#countryCode: String?, number: String, completionBlock: (status: String?, error: NSError?) -> ()) {
        VerifyClient.sharedInstance.getUserStatus(countryCode: countryCode, number: number, completionBlock: completionBlock)
    }
    
    func getUserStatus(#countryCode: String?, number: String, completionBlock: (status: String?, error: NSError?) -> ()) {
        let searchRequest = SearchRequest(number: number, countryCode: countryCode)
        self.searchService.start(request: searchRequest) { response, error in
            if let error = error {
                completionBlock(status: nil, error: error)
            } else {
                completionBlock(status: response!.userStatus, error: nil)
            }
        }
        return
    }
    
    /**
        Filters Nexmo Verify push notifications and returns the verify pin code where possible.
        
        :param: userInfo The push data passed in through UIApplicationDelegate's
                application:didReceiveRemoteNotification: function.
        
        :param: performSilentCheck if true, Nexmo Verify SDK will complete the verification request
                automatically, which verifies the user.
    */
    static func handleNotification(userInfo: [String : String], performSilentCheck: Bool) -> Bool {
        return VerifyClient.sharedInstance.handleNotification(userInfo, performSilentCheck: performSilentCheck)
    }
    
    func handleNotification(userInfo: [String : String], performSilentCheck: Bool) -> Bool {
        if let pin = userInfo[VerifyClient.PARAM_PIN] {
            if (performSilentCheck) {
                checkPinCode(pin)
            } else {
                UIAlertView(title: "Verify Pin", message: "Your verification pin is \(pin)", delegate: nil, cancelButtonTitle: "Okay").show()
            }
            return true
        }
        return false
    }
}
