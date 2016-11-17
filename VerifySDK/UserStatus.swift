//
//  UserStatus.swift
//  NexmoVerify
//
//  Created by Dorian Peake on 13/05/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

import Foundation

/**
    Status of current user in verification process
*/
@objc
open class UserStatus: NSObject {

    /// User not found
    open static var USER_UNKNOWN = "unknown"
    
    /// Something wrong occurred whilst operating on this user
    open static var USER_ERROR = "error"
    
    /// User just created
    open static var USER_NEW = "new"
    
    /// Verification request is underway for this user
    open static var USER_PENDING = "pending"
    
    /// User has successfully been verified
    open static var USER_VERIFIED = "verified"
    
    /// User failed the last verification attempt
    open static var USER_FAILED = "failed"
    
    /// Previous verification attempt for the user expired
    open static var USER_EXPIRED = "expired"
    
    /// Blacklisted user cannot be verified
    open static var USER_BLACKLISTED = "blacklisted"
    
    /// User has been logged out
    open static var USER_UNVERIFIED = "unverified"
}
