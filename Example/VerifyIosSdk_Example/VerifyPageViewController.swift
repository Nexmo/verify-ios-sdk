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
    
    private var currentControllerIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        pages.append(StartViewController(parent: self))
        pages.append(CheckViewController(parent: self))
        
        self.setViewControllers([pages[VerifyPageViewController.START_CONTROLLER_INDEX]], direction: .Forward, animated: true, completion: nil)
        
        self.view.layer.backgroundColor = Colors.nexmoBlue.CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func onVerifyInProgress() {
        print("verify progress")
        toCheckPage()
    }
    
    private func onUserVerified() {
        toCheckPage()
        UIView.animateWithDuration(0.5) {
        (self.pages[VerifyPageViewController.CHECK_CONTROLLER_INDEX] as! CheckViewController).statusImage.alpha = 1
        }
    }
    
    private func onError(verifyError: VerifyError) {
        let okAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
        switch (verifyError) {
            case .INVALID_NUMBER:
                let controller = UIAlertController(title: "Invalid Phone Number", message: "The phone number you entered is invalid", preferredStyle: .Alert)
                controller.addAction(okAction)
                self.presentViewController(controller, animated: true, completion: nil)
            case .INVALID_PIN_CODE:
            let controller = UIAlertController(title: "Wrong Pin Code", message: "The pin code you entered is invalid.", preferredStyle: .Alert)
                controller.addAction(okAction)
                self.presentViewController(controller, animated: true, completion: nil)
            case .INVALID_CODE_TOO_MANY_TIMES:
                let controller = UIAlertController(title: "Invalid code too many times", message: "You have entered an invalid code too many times, verification process has stopped..", preferredStyle: .Alert)
                controller.addAction(okAction)
                self.presentViewController(controller, animated: true, completion: nil)
            case .INVALID_CREDENTIALS:
                let controller = UIAlertController(title: "Invalid Credentials", message: "Having trouble connecting to your account. Please check your app key and secret.", preferredStyle: .Alert)
                controller.addAction(okAction)
                self.presentViewController(controller, animated: true, completion: nil)
            case .USER_EXPIRED:
                let controller = UIAlertController(title: "User Expired", message: "Verification for current use expired (usually due to timeout), please start verification again.", preferredStyle: .Alert)
                controller.addAction(okAction)
                self.presentViewController(controller, animated: true, completion: nil)
            case .USER_BLACKLISTED:
                let controller = UIAlertController(title: "User Blacklisted", message: "Unable to verify this user due to blacklisting!", preferredStyle: .Alert)
                controller.addAction(okAction)
                self.presentViewController(controller, animated: true, completion: nil)
            case .QUOTA_EXCEEDED:
                let controller = UIAlertController(title: "Quota Exceeded", message: "You do not have enough credit to complete the verification.", preferredStyle: .Alert)
                controller.addAction(okAction)
                self.presentViewController(controller, animated: true, completion: nil)
            case .SDK_REVISION_NOT_SUPPORTED:
                let controller = UIAlertController(title: "SDK Revision too old", message: "This SDK revision is not supported anymore!", preferredStyle: .Alert)
                controller.addAction(okAction)
                self.presentViewController(controller, animated: true, completion: nil)
            case .OS_NOT_SUPPORTED:
                let controller = UIAlertController(title: "iOS version not supported", message: "This iOS version is not supported", preferredStyle: .Alert)
                controller.addAction(okAction)
                self.presentViewController(controller, animated: true, completion: nil)
            case .VERIFICATION_ALREADY_STARTED:
                let controller = UIAlertController(title: "Verification already started", message: "A verification is already in progress!", preferredStyle: .Alert)
                controller.addAction(okAction)
                self.presentViewController(controller, animated: true, completion: nil)                        
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
    
    
    func checkPinCode() {
        VerifyClient.checkPinCode((pages[1] as! CheckViewController).pinField.text!)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let index = viewController as! PageIndexable
        
        if (index.index == 0) {
            return nil
        }
        
        currentControllerIndex = index.index - 1
        return pages[index.index - 1]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    
        let index = viewController as! PageIndexable
        
        if (index.index + 1 == pages.count) {
            return nil
        }
        
        currentControllerIndex = index.index + 1
        return pages[index.index+1]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return currentControllerIndex
    }
    
    func toCheckPage() {
        if (currentControllerIndex != 1) {
            currentControllerIndex = 1
            setViewControllers([pages[1]], direction: .Forward, animated: true, completion: nil)
        }
    }
    
    func toStartPage() {
        if (currentControllerIndex != 0) {
            currentControllerIndex = 0
            setViewControllers([pages[VerifyPageViewController.START_CONTROLLER_INDEX]], direction: .Forward, animated: true, completion: nil)
        }
    }
}