//
//  VerifyUIController.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 09/11/2015.
//  Copyright © 2015 Nexmo Inc. All rights reserved.
//

import Foundation
import UIKit

class VerifyUIController : UIViewController, CountryPickerDelegate, UIAlertViewDelegate {
    enum State {
        case VERIFY
        case CHECK
        case TRYAGAIN
    }
    
    @IBOutlet weak var infoText: UILabel!
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var intPrefixText: UILabel!
    @IBOutlet weak var numberField: UITextField!
    
    @IBOutlet weak var checkCodeField: UITextField!
    @IBOutlet weak var sendCodeButton: UIButton!
    @IBOutlet weak var checkCodeSpinner: UIActivityIndicatorView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var callInsteadButton: UIButton!
    
    @IBOutlet weak var cancelButtonHighConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelButtonLowConstraint: NSLayoutConstraint!
    @IBOutlet weak var tryAgainHiddenConstraint: NSLayoutConstraint!
    @IBOutlet weak var tryAgainVisibleConstraint: NSLayoutConstraint!
    
    var message : String = "Enter your number to begin verification."
    var delegate : VerifyUIDelegate?
    
    private let countryController = CountryPickerController()
    private var currentCountry = Countries.list[2] as [String : AnyObject]
    private var verificationSuccessful = false
    private var pinTry = 0
    private var called = false
    private var state : State = .VERIFY {
        didSet {
            switch(state) {
                case .VERIFY:
                // change the function of the send code button
                sendCodeButton.removeTarget(self, action: "checkCode:", forControlEvents: .TouchUpInside)
                sendCodeButton.addTarget(self, action: "sendCode:", forControlEvents: .TouchUpInside)
                sendCodeButton.setTitle("CONTINUE", forState: .Normal)
                
                // change function of cancel button
                cancelButton.removeTarget(self, action: "cancelCheck:", forControlEvents: .TouchUpInside)
                cancelButton.addTarget(self, action: "cancelVerify:", forControlEvents: .TouchUpInside)


                // do some nice animations
                UIView.animateWithDuration(0.5) {
                    self.countryField.alpha = 1
                    self.numberField.alpha = 1
                    self.intPrefixText.alpha = 1
                    
                    self.infoText.text! = self.message
                    
                    self.checkCodeField.alpha = 0
                    self.checkCodeSpinner.alpha = 0
                    
                    self.cancelButtonLowConstraint.priority = UILayoutPriorityDefaultHigh
                    self.cancelButtonHighConstraint.priority =
                        UILayoutPriorityDefaultLow
                    
                    self.tryAgainHiddenConstraint.priority = UILayoutPriorityDefaultHigh
                    self.tryAgainVisibleConstraint.priority = UILayoutPriorityDefaultLow
                    
                    self.tryAgainButton.alpha = 0
                    self.callInsteadButton.alpha = 0
                    
                    self.view.layoutIfNeeded()
                }
                
                case .CHECK:
                // change the function of the send code button
                sendCodeButton.removeTarget(self, action: "sendCode:", forControlEvents: .TouchUpInside)
                sendCodeButton.addTarget(self, action: "checkCode:", forControlEvents: .TouchUpInside)
                sendCodeButton.setTitle("CONTINUE", forState: .Normal)
                
                // change function of cancel button
                cancelButton.removeTarget(self, action: "cancelVerify:", forControlEvents: .TouchUpInside)
                cancelButton.addTarget(self, action: "cancelCheck:", forControlEvents: .TouchUpInside)

                // do some nice animations
                UIView.animateWithDuration(0.5) {
                    self.countryField.alpha = 0
                    self.numberField.alpha = 0
                    self.intPrefixText.alpha = 0
                    
                    self.infoText.text! = "We sent a code to \(self.intPrefixText.text!) \(self.numberField.text!)"
                    
                    self.checkCodeField.alpha = 1
                    self.checkCodeSpinner.alpha = 1
                    
                    self.cancelButtonLowConstraint.priority = UILayoutPriorityDefaultLow
                    self.cancelButtonHighConstraint.priority =
                        UILayoutPriorityDefaultHigh-1
                    
                    self.tryAgainHiddenConstraint.priority = UILayoutPriorityDefaultHigh
                    self.tryAgainVisibleConstraint.priority = UILayoutPriorityDefaultLow
                    
                    self.tryAgainButton.alpha = 0
                    self.callInsteadButton.alpha = 0
                    self.view.layoutIfNeeded()
                }
                
                case .TRYAGAIN:
                // change the function of the send code button
                sendCodeButton.removeTarget(self, action: "sendCode:", forControlEvents: .TouchUpInside)
                sendCodeButton.addTarget(self, action: "checkCode:", forControlEvents: .TouchUpInside)
                sendCodeButton.setTitle("CONTINUE", forState: .Normal)
                
                // change function of cancel button
                cancelButton.removeTarget(self, action: "cancelVerify:", forControlEvents: .TouchUpInside)
                cancelButton.addTarget(self, action: "cancelCheck:", forControlEvents: .TouchUpInside)

                // do some nice animations
                UIView.animateWithDuration(0.5) {
                    self.countryField.alpha = 0
                    self.numberField.alpha = 0
                    self.intPrefixText.alpha = 0
                    
                    self.infoText.text! = "We sent a code to \(self.intPrefixText.text!) \(self.numberField.text!)"
                    
                    self.checkCodeField.alpha = 1
                    self.checkCodeSpinner.alpha = 1
                    
                    self.cancelButtonLowConstraint.priority = UILayoutPriorityDefaultLow
                    self.cancelButtonHighConstraint.priority =
                        UILayoutPriorityDefaultHigh-1
                    
                    self.tryAgainHiddenConstraint.priority = UILayoutPriorityDefaultLow
                    self.tryAgainVisibleConstraint.priority = UILayoutPriorityDefaultHigh
                    
                    self.tryAgainButton.alpha = 1
                    self.callInsteadButton.alpha = 1
                    self.view.layoutIfNeeded()
                }

            }
        }
    }
    
    override func viewDidLoad() {
    
        // setup country picker
        countryController.delegate = self
        countryField.inputView = countryController.view
        
        let lightGray = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
        
        // add borders to textboxes
        var bounds = countryField.bounds
        var rect = CGRectMake(0, countryField.frame.height-1, countryField.frame.width, 1)
        var border = CALayer()
        border.backgroundColor = lightGray.CGColor
        border.frame = rect
        countryField.layer.addSublayer(border)
        
        bounds = numberField.bounds
        rect = CGRectMake(0, bounds.height-1, bounds.width, 1)
        border = CALayer()
        border.backgroundColor = lightGray.CGColor
        border.frame = rect
        numberField.layer.addSublayer(border)
        
        bounds = checkCodeField.bounds
        rect = CGRectMake(0, bounds.height-1, bounds.width, 1)
        border = CALayer()
        border.backgroundColor = lightGray.CGColor
        border.frame = rect
        checkCodeField.layer.addSublayer(border)
        
        // move keyboard when tapped
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: "hideKeyboard:")
        self.view.addGestureRecognizer(hideKeyboardGesture)
        
        // select UK as first country
        didSelectCountry(currentCountry)
        
        // set up send code button
        sendCodeButton.addTarget(self, action: "sendCode:", forControlEvents: .TouchUpInside)
        
        // set up cancel button
        cancelButton.addTarget(self, action: "cancelVerify:", forControlEvents: .TouchUpInside)
        
        // set up message text
        infoText.text = message
    }
    
    func hideKeyboard(gesture: UITapGestureRecognizer) {
        countryField.resignFirstResponder()
        numberField.resignFirstResponder()
        checkCodeField.resignFirstResponder()
    }
    
    func didSelectCountry(country: [String : AnyObject]) {
        print("selected country \(country["country"] as! String)")
        
        currentCountry = country
        countryField.text = (country["country"] as! String)
        intPrefixText.text = "+\((country["int_prefix"] as! NSArray)[0])"
    }
    
    func onVerifyInProgressCallback() {
        self.state = .CHECK
    }
    
    func onUserVerifiedCallback() {
        self.verificationSuccessful = true
        self.delegate?.verificationSuccessful = true
        
        let action = UIAlertAction(title: "Okay", style: .Default) { _ in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        let controller = UIAlertController(title: "Verification Successful.", message: "You have been successfully verified.", preferredStyle: .Alert)
        controller.addAction(action)
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func onErrorCallback(error: VerifyError) {
        let action = UIAlertAction(title: "Okay", style: .Default, handler: nil)
        switch (error) {
            case .INVALID_NUMBER:
                let controller = UIAlertController(title: "Invalid Phone Number", message: "The phone number you entered is invalid.", preferredStyle: .Alert)
                controller.addAction(action)
                self.presentViewController(controller, animated: true, completion: nil)
            
            case .INVALID_PIN_CODE:
                let controller = UIAlertController(title: "Wrong Pin Code", message: "The pin code you entered is invalid.", preferredStyle: .Alert)
                controller.addAction(action)
                self.presentViewController(controller, animated: true, completion: nil)
    
                self.pinTry++
    
                if (self.pinTry == 3) {
                    self.state = .TRYAGAIN
                }
    
            case .INVALID_CODE_TOO_MANY_TIMES:
                let controller = UIAlertController(title: "Invalid code too many times", message: "You have entered an invalid code too many times, verification process has stopped..", preferredStyle: .Alert)
                controller.addAction(action)
                self.presentViewController(controller, animated: true, completion: nil)
            case .INVALID_CREDENTIALS:
                let controller = UIAlertController(title: "Invalid Credentials", message: "Having trouble connecting to your account. Please check your app key and secret.", preferredStyle: .Alert)
                controller.addAction(action)
                self.presentViewController(controller, animated: true, completion: nil)
            case .USER_EXPIRED:
                let controller = UIAlertController(title: "User Expired", message: "Verification for current use expired (usually due to timeout), please start verification again.", preferredStyle: .Alert)
                controller.addAction(action)
                self.presentViewController(controller, animated: true, completion: nil)
            case .USER_BLACKLISTED:
                let controller = UIAlertController(title: "User Blacklisted", message: "Unable to verify this user due to blacklisting!", preferredStyle: .Alert)
                controller.addAction(action)
                self.presentViewController(controller, animated: true, completion: nil)
            case .QUOTA_EXCEEDED:
                let controller = UIAlertController(title: "Quota Exceeded", message: "You do not have enough credit to complete the verification.", preferredStyle: .Alert)
                controller.addAction(action)
                self.presentViewController(controller, animated: true, completion: nil)
            case .SDK_REVISION_NOT_SUPPORTED:
                let controller = UIAlertController(title: "SDK Revision too old", message: "This SDK revision is not supported anymore!", preferredStyle: .Alert)
                controller.addAction(action)
                self.presentViewController(controller, animated: true, completion: nil)
            case .OS_NOT_SUPPORTED:
                let controller = UIAlertController(title: "iOS version not supported", message: "This iOS version is not supported", preferredStyle: .Alert)
                controller.addAction(action)
                self.presentViewController(controller, animated: true, completion: nil)
            case .NETWORK_ERROR:
                let controller = UIAlertController(title: "Network Error", message: "Having trouble accessing the network.", preferredStyle: .Alert)
                controller.addAction(action)
                self.presentViewController(controller, animated: true, completion: nil)
            case .VERIFICATION_ALREADY_STARTED:
                let controller = UIAlertController(title: "Verification already started", message: "A verification is already in progress!", preferredStyle: .Alert)
                controller.addAction(action)
                self.presentViewController(controller, animated: true, completion: nil)
                
            default: break
        }
    }
    
    func sendCode(sender: AnyObject) {
        VerifyClient.getVerifiedUser(countryCode: (currentCountry["country_code"] as! String), phoneNumber: numberField.text!,
        onVerifyInProgress: onVerifyInProgressCallback,
        onUserVerified: onUserVerifiedCallback,
        onError: onErrorCallback)
    }
    
    override func viewWillDisappear(animated: Bool) {
        delegate?.verificationSuccessful = verificationSuccessful
        delegate?.userVerified?(verificationSuccessful)
    }
    
    func checkCode(sender: AnyObject) {
        // check for no pin code
        if (checkCodeField.text?.characters.count == 0) {
            let action = UIAlertAction(title: "Okay", style: .Default, handler: nil)
            let controller = UIAlertController(title: "No Pin Code Entered", message: "Please enter your pin code first.", preferredStyle: .Alert)
            controller.addAction(action)
            presentViewController(controller, animated: true, completion: nil)
            return
        }
    
        // check for pin < 4
        if (checkCodeField.text?.characters.count < 4) {
            let action = UIAlertAction(title: "Okay", style: .Default, handler: nil)
            let controller = UIAlertController(title: "Invalid length", message: "Your pin code is too short.", preferredStyle: .Alert)
            controller.addAction(action)
            presentViewController(controller, animated: true, completion: nil)
            return
        }
        
        // check for pin > 6
        if (checkCodeField.text?.characters.count > 6) {
            let action = UIAlertAction(title: "Okay", style: .Default, handler: nil)
            let controller = UIAlertController(title: "Invalid length", message: "Your pin code is too long.", preferredStyle: .Alert)
            controller.addAction(action)
            presentViewController(controller, animated: true, completion: nil)
            return
        }
        
        // finally if all is good, perform the verification
        VerifyClient.checkPinCode(checkCodeField.text!)
    }
    
    func cancelVerify(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cancelCheck(sender: AnyObject) {
        // set up state correctly
        state = .VERIFY
        pinTry = 0
        called = false
        
        // cancel the ongoing verification
        VerifyClient.cancelVerification({ error in
            if let error = error {
                print("failed to cancel verification with error: \(error.localizedDescription)")
            }
        })
    }
    
    @IBAction func tryAgain(sender: AnyObject) {
        VerifyClient.cancelVerification() { error in
            if let error = error {
                let action = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                let controller = UIAlertController(title: "Failed retrying verification", message: error.localizedDescription, preferredStyle: .Alert)
                controller.addAction(action)
                self.presentViewController(controller, animated: true, completion: nil)
                return
            }
            
            self.pinTry = 0
            self.called = false
            VerifyClient.getVerifiedUser(countryCode: (self.currentCountry["country_code"] as! String), phoneNumber: self.numberField.text!,
            onVerifyInProgress: self.onVerifyInProgressCallback,
            onUserVerified: self.onUserVerifiedCallback,
            onError: self.onErrorCallback)
        }
    }
    @IBAction func callInstead(sender: AnyObject) {
        if (called) {
            let action = UIAlertAction(title: "Okay", style: .Default, handler: nil)
            let controller = UIAlertController(title: "Call already in progress.", message: "A is currently scheduled for this number.", preferredStyle: .Alert)
            controller.addAction(action)
            self.presentViewController(controller, animated: true, completion: nil)
            return
        }

        VerifyClient.triggerNextEvent() { error in
            if let error = error {
                let action = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                let controller = UIAlertController(title: "Failed to schedule call.", message: error.localizedDescription, preferredStyle: .Alert)
                controller.addAction(action)
                self.presentViewController(controller, animated: true, completion: nil)
                return
            }
            
            self.called = true
            self.infoText.text = "We are calling \(self.intPrefixText.text!) \(self.numberField.text!)"
        }
    }
}