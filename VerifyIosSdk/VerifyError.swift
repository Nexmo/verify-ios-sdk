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
    case VERIFICATION_ALREADY_STARTED = 1
    
    /** Number is invalid. Either:
        1. Number is missing or not a real number (in international or local format).
        2. Cannot route any verification messages to this number.
    */
    case INVALID_NUMBER
    
    /* Number not provided in verify request */
    case NUMBER_REQUIRED
    
    /** User must be in pending status to be able to perform a PIN check. */
    case CANNOT_PERFORM_CHECK
    
    /** Missing or invalid PIN code supplied. */
    case INVALID_PIN_CODE
    
    /** Ongoing verification has failed. A wrong PIN code was provided too many times. */
    case INVALID_CODE_TOO_MANY_TIMES
    
    /** Ongoing verification expired. Need to start verify again. */
    case USER_EXPIRED
    
    /** Ongoing verification rejected. User blacklisted for verification. */
    case USER_BLACKLISTED
    
    /** Throttled. Too many failed requests. */
    case THROTTLED
    
    /** Your account does not have sufficient credit to process this request. */
    case QUOTA_EXCEEDED
    
    /**
        Invalid Credentials. Either:
        1. Supplied Application ID may not be listed under your accepted application list.
        2. Shared secret key is invalid.
    */
    case INVALID_CREDENTIALS
    
    /** The SDK revision is not supported anymore. */
    case SDK_REVISION_NOT_SUPPORTED
    
    /** Current iOS OS version is not supported. */
    case OS_NOT_SUPPORTED
    
    /** Generic internal error, the service might be down for the moment. Please try again later. */
    case INTERNAL_ERROR
    
    /** This Nexmo Account has been barred from sending messages */
    case ACCOUNT_BARRED
    
    /** Having problems accessing the network */
    case NETWORK_ERROR
}
