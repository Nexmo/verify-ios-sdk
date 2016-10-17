//
//  VerifyPageViewController.swift
//  verify-ios-test-app
//
//  Created by Dorian Peake on 24/06/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation
import UIKit
import VerifyIosSdk

class VerifyPageViewController : UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    static let START_CONTROLLER_INDEX = 0
    static let CHECK_CONTROLLER_INDEX = 1

    // only two view controllers, one to begin verification, one to check pin
    var pages = [ UIViewController ]()
    
    fileprivate var currentControllerIndex = 0
    fileprivate var controller : UIAlertController!
    
    func initialise() {
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.dataSource = self
        self.delegate = self
        
        pages.append(StartViewController(parent: self))
        pages.append(CheckViewController(parent: self))
        
        self.setViewControllers([pages[VerifyPageViewController.START_CONTROLLER_INDEX]], direction: .forward, animated: true, completion: nil)
        
        self.view.layer.backgroundColor = Colors.nexmoBlue.cgColor
        (UIApplication.shared.delegate as! AppDelegate).pageViewController = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func onVerifyInProgress() {
        print("verify progress")
        toCheckPage()
    }
    
    fileprivate func onUserVerified() {
        toCheckPage()
        UIView.animate(withDuration: 0.5, animations: {
        (self.pages[VerifyPageViewController.CHECK_CONTROLLER_INDEX] as! CheckViewController).statusImage.alpha = 1
        }) 
    }
    
    fileprivate func onError(_ verifyError: VerifyError) {
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        switch (verifyError) {
        case .invalidNumber:
            let controller = UIAlertController(title: "Invalid Phone Number", message: "The phone number you entered is invalid", preferredStyle: .alert)
            controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)
        case .invalidPinCode:
            let controller = UIAlertController(title: "Wrong Pin Code", message: "The pin code you entered is invalid.", preferredStyle: .alert)
            controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)
        case .invalidCodeTooManyTimes:
            let controller = UIAlertController(title: "Invalid code too many times", message: "You have entered an invalid code too many times, verification process has stopped..", preferredStyle: .alert)
            controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)
        case .invalidCredentials:
            let controller = UIAlertController(title: "Invalid Credentials", message: "Having trouble connecting to your account. Please check your app key and secret.", preferredStyle: .alert)
            controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)
        case .userExpired:
            let controller = UIAlertController(title: "User Expired", message: "Verification for current use expired (usually due to timeout), please start verification again.", preferredStyle: .alert)
            controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)
        case .userBlacklisted:
            let controller = UIAlertController(title: "User Blacklisted", message: "Unable to verify this user due to blacklisting!", preferredStyle: .alert)
            controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)
        case .quotaExceeded:
            let controller = UIAlertController(title: "Quota Exceeded", message: "You do not have enough credit to complete the verification.", preferredStyle: .alert)
            controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)
        case .sdkRevisionNotSupported:
            let controller = UIAlertController(title: "SDK Revision too old", message: "This SDK revision is not supported anymore!", preferredStyle: .alert)
            controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)
        case .osNotSupported:
            let controller = UIAlertController(title: "iOS version not supported", message: "This iOS version is not supported", preferredStyle: .alert)
            controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)
        case .verificationAlreadyStarted:
            let controller = UIAlertController(title: "Verification already started", message: "A verification is already in progress!", preferredStyle: .alert)
            controller.addAction(okAction)
            self.present(controller, animated: true, completion: nil)
        default: break
        }
        
        // other errors can be silenced for the test app
        print("some error \(verifyError.rawValue)")
    }
    
    func beginVerification() {
        VerifyClient.getVerifiedUser(countryCode: (pages[VerifyPageViewController.START_CONTROLLER_INDEX] as! StartViewController).currentCountry["country_code"] as? String, phoneNumber: (pages[VerifyPageViewController.START_CONTROLLER_INDEX] as! StartViewController).phoneNumberField.text!, onVerifyInProgress: onVerifyInProgress,
            onUserVerified: onUserVerified,
            onError: onError)
    }
    
    func logoutUser() {
        let startViewController = pages[VerifyPageViewController.START_CONTROLLER_INDEX] as! StartViewController
        let countryCode = startViewController.currentCountry["country_code"] as! String
        let number = startViewController.phoneNumberField.text!
        VerifyClient.logoutUser(countryCode: countryCode, number: number) { error in
            let action = UIAlertAction(title: "Okay", style: .Default, handler: nil)
            if let error = error {
                let errMsg = "Failed to log out user with error: \(error.localizedDescription)"
                print(errMsg)
                
                self.controller = UIAlertController(title: "Failed to logout user", message: errMsg, preferredStyle: .Alert)
                self.controller.addAction(action)
                UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(self.controller, animated: true, completion: nil)
                return
            }
            
            self.controller = UIAlertController(title: "Successfully logged out user", message: "User was successfully logged out", preferredStyle: .Alert)
            self.controller.addAction(action)
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(self.controller, animated: true, completion: nil)
            
        }
    }
    
    func checkPinCode() {
        VerifyClient.checkPinCode((pages[VerifyPageViewController.CHECK_CONTROLLER_INDEX] as! CheckViewController).pinField.text!)
    }

    func standaloneVerification() {
        VerifyClient.verifyStandalone(countryCode: (pages[VerifyPageViewController.START_CONTROLLER_INDEX] as! StartViewController).currentCountry["country_code"] as? String, phoneNumber: (pages[VerifyPageViewController.START_CONTROLLER_INDEX] as! StartViewController).phoneNumberField.text!, onVerifyInProgress: onVerifyInProgress,
            onUserVerified: onUserVerified,
            onError: onError)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = viewController as! PageIndexable
        
        if (index.index == 0) {
            return nil
        }
        
        currentControllerIndex = index.index - 1
        return pages[index.index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    
        let index = viewController as! PageIndexable
        
        if (index.index + 1 == pages.count) {
            return nil
        }
        
        currentControllerIndex = index.index + 1
        return pages[index.index+1]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentControllerIndex
    }
    
    func toCheckPage() {
        if (currentControllerIndex != 1) {
            currentControllerIndex = 1
            setViewControllers([pages[VerifyPageViewController.CHECK_CONTROLLER_INDEX]], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func toStartPage() {
        if (currentControllerIndex != 0) {
            currentControllerIndex = 0
            setViewControllers([pages[VerifyPageViewController.START_CONTROLLER_INDEX]], direction: .forward, animated: true, completion: nil)
        }
    }
}
