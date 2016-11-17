//
//  VerifyError.swift
//  NexmoVerify
//
//  Created by Dorian Peake on 18/05/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

import Foundation

/**
    Possible error responses which may be returned from verify services
*/
@objc public enum VerifyError : Int {

    /** There is already a pending verification in progress. Handle {@link VerifyClientListener} events to check the progress. */
    case verificationAlreadyStarted = 1
    
    /** Number is invalid. Either:
        1. Number is missing or not a real number (in international or local format).
        2. Cannot route any verification messages to this number.
    */
    case invalidNumber
    
    /** Number not provided in verify request */
    case numberRequired
    
    /** User must be in pending status to be able to perform a PIN check. */
    case cannotPerformCheck
    
    /** Missing or invalid PIN code supplied. */
    case invalidPinCode
    
    /** Ongoing verification has failed. A wrong PIN code was provided too many times. */
    case invalidCodeTooManyTimes
    
    /** Ongoing verification expired. Need to start verify again. */
    case userExpired
    
    /** Ongoing verification rejected. User blacklisted for verification. */
    case userBlacklisted
    
    /** Throttled. Too many failed requests. */
    case throttled
    
    /** Your account does not have sufficient credit to process this request. */
    case quotaExceeded
    
    /**
        Invalid Credentials. Either:
        1. Supplied Application ID may not be listed under your accepted application list.
        2. Shared secret key is invalid.
    */
    case invalidCredentials
    
    /** The SDK revision is not supported anymore. */
    case sdkRevisionNotSupported
    
    /** Current iOS OS version is not supported. */
    case osNotSupported
    
    /** Generic internal error, the service might be down for the moment. Please try again later. */
    case internalError
    
    /** This Nexmo Account has been barred from sending messages */
    case accountBarred
    
    /** Having problems accessing the network */
    case networkError
}
