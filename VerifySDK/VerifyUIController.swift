//
//  VerifyUIController.swift
//  NexmoVerify
//
//  Created by Dorian Peake on 09/11/2015.
//  Copyright © 2015 Nexmo Inc. All rights reserved.
//

import Foundation
import UIKit

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class VerifyUIController : UIViewController, CountryPickerDelegate, UIAlertViewDelegate {
    enum State {
        case verify
        case check
        case tryagain
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
    
    fileprivate let countryController = CountryPickerController()
    fileprivate var currentCountry = Countries.list[2] as [String : AnyObject]
    fileprivate var verificationSuccessful = false
    fileprivate var pinTry = 0
    fileprivate var called = false
    fileprivate var state : State = .verify {
        didSet {
            switch(state) {
                case .verify:
                // change the function of the send code button
                sendCodeButton.removeTarget(self, action: #selector(VerifyUIController.checkCode(_:)), for: .touchUpInside)
                sendCodeButton.addTarget(self, action: #selector(VerifyUIController.sendCode(_:)), for: .touchUpInside)
                sendCodeButton.setTitle("CONTINUE", for: UIControlState())
                
                // change function of cancel button
                cancelButton.removeTarget(self, action: #selector(VerifyUIController.cancelCheck(_:)), for: .touchUpInside)
                cancelButton.addTarget(self, action: #selector(VerifyUIController.cancelVerify(_:)), for: .touchUpInside)


                // do some nice animations
                UIView.animate(withDuration: 0.5, animations: {
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
                }) 
                
                case .check:
                // change the function of the send code button
                sendCodeButton.removeTarget(self, action: #selector(VerifyUIController.sendCode(_:)), for: .touchUpInside)
                sendCodeButton.addTarget(self, action: #selector(VerifyUIController.checkCode(_:)), for: .touchUpInside)
                sendCodeButton.setTitle("CONTINUE", for: UIControlState())
                
                // change function of cancel button
                cancelButton.removeTarget(self, action: #selector(VerifyUIController.cancelVerify(_:)), for: .touchUpInside)
                cancelButton.addTarget(self, action: #selector(VerifyUIController.cancelCheck(_:)), for: .touchUpInside)

                // do some nice animations
                UIView.animate(withDuration: 0.5, animations: {
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
                }) 
                
                case .tryagain:
                // change the function of the send code button
                sendCodeButton.removeTarget(self, action: #selector(VerifyUIController.sendCode(_:)), for: .touchUpInside)
                sendCodeButton.addTarget(self, action: #selector(VerifyUIController.checkCode(_:)), for: .touchUpInside)
                sendCodeButton.setTitle("CONTINUE", for: UIControlState())
                
                // change function of cancel button
                cancelButton.removeTarget(self, action: #selector(VerifyUIController.cancelVerify(_:)), for: .touchUpInside)
                cancelButton.addTarget(self, action: #selector(VerifyUIController.cancelCheck(_:)), for: .touchUpInside)

                // do some nice animations
                UIView.animate(withDuration: 0.5, animations: {
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
                }) 

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
        var rect = CGRect(x: 0, y: countryField.frame.height-1, width: countryField.frame.width, height: 1)
        var border = CALayer()
        border.backgroundColor = lightGray.cgColor
        border.frame = rect
        countryField.layer.addSublayer(border)
        
        bounds = numberField.bounds
        rect = CGRect(x: 0, y: bounds.height-1, width: bounds.width, height: 1)
        border = CALayer()
        border.backgroundColor = lightGray.cgColor
        border.frame = rect
        numberField.layer.addSublayer(border)
        
        bounds = checkCodeField.bounds
        rect = CGRect(x: 0, y: bounds.height-1, width: bounds.width, height: 1)
        border = CALayer()
        border.backgroundColor = lightGray.cgColor
        border.frame = rect
        checkCodeField.layer.addSublayer(border)
        
        // move keyboard when tapped
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(VerifyUIController.hideKeyboard(_:)))
        self.view.addGestureRecognizer(hideKeyboardGesture)
        
        // select UK as first country
        didSelectCountry(currentCountry)
        
        // set up send code button
        sendCodeButton.addTarget(self, action: #selector(VerifyUIController.sendCode(_:)), for: .touchUpInside)
        
        // set up cancel button
        cancelButton.addTarget(self, action: #selector(VerifyUIController.cancelVerify(_:)), for: .touchUpInside)
        
        // set up message text
        infoText.text = message
    }
    
    func hideKeyboard(_ gesture: UITapGestureRecognizer) {
        countryField.resignFirstResponder()
        numberField.resignFirstResponder()
        checkCodeField.resignFirstResponder()
    }
    
    func didSelectCountry(_ country: [String : AnyObject]) {
        currentCountry = country
        countryField.text = (country["country"] as! String)
        intPrefixText.text = "+\((country["int_prefix"] as! NSArray)[0])"
    }
    
    func onVerifyInProgressCallback() {
        self.state = .check
    }
    
    func onUserVerifiedCallback() {
        self.verificationSuccessful = true
        self.delegate?.verificationSuccessful = true
        
        let action = UIAlertAction(title: "Okay", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        let controller = UIAlertController(title: "Verification Successful.", message: "You have been successfully verified.", preferredStyle: .alert)
        controller.addAction(action)
        self.present(controller, animated: true, completion: nil)
    }
    
    func onErrorCallback(_ error: VerifyError) {
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        switch (error) {
            case .invalidNumber:
                let controller = UIAlertController(title: "Invalid Phone Number", message: "The phone number you entered is invalid.", preferredStyle: .alert)
                controller.addAction(action)
                self.present(controller, animated: true, completion: nil)
            
            case .invalidPinCode:
                let controller = UIAlertController(title: "Wrong Pin Code", message: "The pin code you entered is invalid.", preferredStyle: .alert)
                controller.addAction(action)
                self.present(controller, animated: true, completion: nil)
    
                self.pinTry += 1
    
                if (self.pinTry == 3) {
                    self.state = .tryagain
                }
    
            case .invalidCodeTooManyTimes:
                let controller = UIAlertController(title: "Invalid code too many times", message: "You have entered an invalid code too many times, verification process has stopped..", preferredStyle: .alert)
                controller.addAction(action)
                self.present(controller, animated: true, completion: nil)
            case .invalidCredentials:
                let controller = UIAlertController(title: "Invalid Credentials", message: "Having trouble connecting to your account. Please check your app key and secret.", preferredStyle: .alert)
                controller.addAction(action)
                self.present(controller, animated: true, completion: nil)
            case .userExpired:
                let controller = UIAlertController(title: "User Expired", message: "Verification for current use expired (usually due to timeout), please start verification again.", preferredStyle: .alert)
                controller.addAction(action)
                self.present(controller, animated: true, completion: nil)
            case .userBlacklisted:
                let controller = UIAlertController(title: "User Blacklisted", message: "Unable to verify this user due to blacklisting!", preferredStyle: .alert)
                controller.addAction(action)
                self.present(controller, animated: true, completion: nil)
            case .quotaExceeded:
                let controller = UIAlertController(title: "Quota Exceeded", message: "You do not have enough credit to complete the verification.", preferredStyle: .alert)
                controller.addAction(action)
                self.present(controller, animated: true, completion: nil)
            case .sdkRevisionNotSupported:
                let controller = UIAlertController(title: "SDK Revision too old", message: "This SDK revision is not supported anymore!", preferredStyle: .alert)
                controller.addAction(action)
                self.present(controller, animated: true, completion: nil)
            case .osNotSupported:
                let controller = UIAlertController(title: "iOS version not supported", message: "This iOS version is not supported", preferredStyle: .alert)
                controller.addAction(action)
                self.present(controller, animated: true, completion: nil)
            case .networkError:
                let controller = UIAlertController(title: "Network Error", message: "Having trouble accessing the network.", preferredStyle: .alert)
                controller.addAction(action)
                self.present(controller, animated: true, completion: nil)
            case .verificationAlreadyStarted:
                let controller = UIAlertController(title: "Verification already started", message: "A verification is already in progress!", preferredStyle: .alert)
                controller.addAction(action)
                self.present(controller, animated: true, completion: nil)
                
            default: break
        }
    }
    
    func sendCode(_ sender: AnyObject) {
        VerifyClient.getVerifiedUser(countryCode: (currentCountry["country_code"] as! String), phoneNumber: numberField.text!,
        onVerifyInProgress: onVerifyInProgressCallback,
        onUserVerified: onUserVerifiedCallback,
        onError: onErrorCallback)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.verificationSuccessful = verificationSuccessful
        delegate?.userVerified?(verificationSuccessful)
    }
    
    func checkCode(_ sender: AnyObject) {
        // check for no pin code
        if (checkCodeField.text?.characters.count == 0) {
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            let controller = UIAlertController(title: "No Pin Code Entered", message: "Please enter your pin code first.", preferredStyle: .alert)
            controller.addAction(action)
            present(controller, animated: true, completion: nil)
            return
        }
    
        // check for pin < 4
        if (checkCodeField.text?.characters.count < 4) {
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            let controller = UIAlertController(title: "Invalid length", message: "Your pin code is too short.", preferredStyle: .alert)
            controller.addAction(action)
            present(controller, animated: true, completion: nil)
            return
        }
        
        // check for pin > 6
        if (checkCodeField.text?.characters.count > 6) {
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            let controller = UIAlertController(title: "Invalid length", message: "Your pin code is too long.", preferredStyle: .alert)
            controller.addAction(action)
            present(controller, animated: true, completion: nil)
            return
        }
        
        // finally if all is good, perform the verification
        VerifyClient.checkPinCode(checkCodeField.text!)
    }
    
    func cancelVerify(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func cancelCheck(_ sender: AnyObject) {
        // set up state correctly
        state = .verify
        pinTry = 0
        called = false
        
        // cancel the ongoing verification
        VerifyClient.cancelVerification({ _ in
            
        })
    }
    
    @IBAction func tryAgain(_ sender: AnyObject) {
        VerifyClient.cancelVerification() { error in
            if let error = error {
                let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
                let controller = UIAlertController(title: "Failed retrying verification", message: error.localizedDescription, preferredStyle: .alert)
                controller.addAction(action)
                self.present(controller, animated: true, completion: nil)
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
    @IBAction func callInstead(_ sender: AnyObject) {
        if (called) {
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            let controller = UIAlertController(title: "Call already in progress.", message: "A is currently scheduled for this number.", preferredStyle: .alert)
            controller.addAction(action)
            self.present(controller, animated: true, completion: nil)
            return
        }

        VerifyClient.triggerNextEvent() { error in
            if let error = error {
                let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
                let controller = UIAlertController(title: "Failed to schedule call.", message: error.localizedDescription, preferredStyle: .alert)
                controller.addAction(action)
                self.present(controller, animated: true, completion: nil)
                return
            }
            
            self.called = true
            self.infoText.text = "We are calling \(self.intPrefixText.text!) \(self.numberField.text!)"
        }
    }
}
