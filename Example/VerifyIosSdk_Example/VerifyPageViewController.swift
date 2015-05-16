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
    
    func beginVerification() {
        VerifyClient.getVerifiedUser(countryCode: (pages[VerifyPageViewController.START_CONTROLLER_INDEX] as! StartViewController).currentCountry.countryCode, phoneNumber: (pages[VerifyPageViewController.START_CONTROLLER_INDEX] as! StartViewController).phoneNumberField.text, onVerifyInProgress: {
                println("verify progress")
                self.toCheckPage()
            },
            onUserVerified: {
                    self.toCheckPage()
                    UIView.animateWithDuration(0.5) {
                    (self.pages[VerifyPageViewController.CHECK_CONTROLLER_INDEX] as! CheckViewController).statusImage.alpha = 1
                }
            },
            onError: { verifyError in
                switch (verifyError) {
                    case .INVALID_NUMBER:
                        UIAlertView(title: "Invalid Phone Number", message: "The phone number you entered is invalid.", delegate: nil, cancelButtonTitle: "Oh, gosh darnit!").show()
                    
                    case .INVALID_PIN_CODE:
                        UIAlertView(title: "Wrong Pin Code", message: "The pin code you entered is invalid.", delegate: nil, cancelButtonTitle: "Whoops!").show()
                    case .INVALID_CODE_TOO_MANY_TIMES:
                        UIAlertView(title: "Invalid code too many times", message: "You have entered an invalid code too many times, verification process has stopped..", delegate: nil, cancelButtonTitle: "Okay").show()
                    case .INVALID_CREDENTIALS:
                        UIAlertView(title: "Invalid Credentials", message: "Having trouble connecting to your account. Please check your app key and secret.", delegate: nil, cancelButtonTitle: "Sure thing.").show()
                    case .USER_EXPIRED:
                        UIAlertView(title: "User Expired", message: "Verification for current use expired (usually due to timeout), please start verification again.", delegate: nil, cancelButtonTitle: "Okay").show()
                    case .USER_BLACKLISTED:
                        UIAlertView(title: "User Blacklisted", message: "Unable to verify this user due to blacklisting!", delegate: nil, cancelButtonTitle: "Whoa...").show()
                    case .QUOTA_EXCEEDED:
                        UIAlertView(title: "Quota Exceeded", message: "You do not have enough credit to complete the verification.", delegate: nil, cancelButtonTitle: "Okay").show()
                    case .SDK_REVISION_NOT_SUPPORTED:
                        UIAlertView(title: "SDK Revision too old", message: "This SDK revision is not supported anymore!", delegate: nil, cancelButtonTitle: "Okay").show()
                    case .OS_NOT_SUPPORTED:
                        UIAlertView(title: "iOS version not supported", message: "This iOS version is not supported", delegate: nil, cancelButtonTitle: "Okay").show()
                    
                    case .VERIFICATION_ALREADY_STARTED:
                        UIAlertView(title: "Verification already started", message: "A verification is already in progress!", delegate: nil, cancelButtonTitle: "Oh, okay")
                        
                    default: break
                }
                
                // other errors can be silenced for the test app
                println("some error \(verifyError.rawValue)")
            })
    }
    
    func checkPinCode() {
        VerifyClient.checkPinCode((pages[1] as! CheckViewController).pinField.text)
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
            setViewControllers([pages[1]], direction: .Forward, animated: true, completion: nil)
            currentControllerIndex = 1
        }
    }
    
    func toStartPage() {
        if (currentControllerIndex != 0) {
            setViewControllers([pages[VerifyPageViewController.START_CONTROLLER_INDEX]], direction: .Forward, animated: true, completion: nil)
            currentControllerIndex = 0
        }
    }
}