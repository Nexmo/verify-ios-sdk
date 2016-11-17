//
//  VerifyUIDelegate.swift
//  NexmoVerify
//
//  Created by Dorian Peake on 09/11/2015.
//  Copyright © 2015 Nexmo Inc. All rights reserved.
//

import Foundation

/// Callback from Nexmo verification view controller
@objc public protocol VerifyUIDelegate {
    
    /**
        Variable holds the outcome of a verification attempt once completed
    */
    var verificationSuccessful : Bool { get set }
    
    /**
        Called once a verification attempt has terminated, with the result of the verification
    */
    @objc optional func userVerified(_ verified: Bool)
}
