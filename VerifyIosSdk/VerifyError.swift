//
//  VerifyError.swift
//  VerifyIosSdk
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
    case verification_ALREADY_STARTED = 1
    
    /** Number is invalid. Either:
        1. Number is missing or not a real number (in international or local format).
        2. Cannot route any verification messages to this number.
    */
    case invalid_NUMBER
    
    /* Number not provided in verify request */
    case number_REQUIRED
    
    /** User must be in pending status to be able to perform a PIN check. */
    case cannot_PERFORM_CHECK
    
    /** Missing or invalid PIN code supplied. */
    case invalid_PIN_CODE
    
    /** Ongoing verification has failed. A wrong PIN code was provided too many times. */
    case invalid_CODE_TOO_MANY_TIMES
    
    /** Ongoing verification expired. Need to start verify again. */
    case user_EXPIRED
    
    /** Ongoing verification rejected. User blacklisted for verification. */
    case user_BLACKLISTED
    
    /** Throttled. Too many failed requests. */
    case throttled
    
    /** Your account does not have sufficient credit to process this request. */
    case quota_EXCEEDED
    
    /**
        Invalid Credentials. Either:
        1. Supplied Application ID may not be listed under your accepted application list.
        2. Shared secret key is invalid.
    */
    case invalid_CREDENTIALS
    
    /** The SDK revision is not supported anymore. */
    case sdk_REVISION_NOT_SUPPORTED
    
    /** Current iOS OS version is not supported. */
    case os_NOT_SUPPORTED
    
    /** Generic internal error, the service might be down for the moment. Please try again later. */
    case internal_ERROR
    
    /** This Nexmo Account has been barred from sending messages */
    case account_BARRED
    
    /** Having problems accessing the network */
    case network_ERROR
}
