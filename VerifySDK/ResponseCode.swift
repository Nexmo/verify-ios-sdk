//
//  ResponseCode.swift
//  NexmoVerify
//
//  Created by Dorian Peake on 16/05/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

import Foundation

/// Response code from Verfiy
open class ResponseCode {

    enum Code : Int {
        /** The request was successfully accepted by Nexmo. */
        case resultCodeOK = 0
        
        /** Exceeded maximum throughput - response has been throttled */
        case responseThrottle = 1
        
        /** Missing or invalid App ID */
        case invalidAppID = 2
        
        /** Invalid token. Expired token needs to be re-generated. */
        case invalidToken = 3
        
        /** Invalid app_id. Supplied app_id is not listed under your accepted application list. */
        case invalidCredentials = 4
        
        /** Internal error occurred */
        case internalError = 5
        
        /** Unable to route your verify request! */
        case unroutableRequest = 6
        
        /** Number blacklisted from verification */
        case numberBlacklisted = 7
        
        /** This account has been barred from sending messages */
        case accountBarred = 8
        
        /** Your account does not have sufficient credit to process this request. */
        case quotaExceeded = 9
        
        /** Concurrent verifications are not allowed - this error should never occur */
        case concurrentVerificationsNotAllowed = 10
        
        /////////** Invalid signature (usually related to bad secret) **/
        case invalidSignature = 14
        
        /** Destination number does not reside within a supported network */
        case destinationNumberNotSupported = 15

        /** Missing or invalid PIN code supplied. */
        case invalidPinCode = 16

        /** A wrong PIN code was provided too many times. */
        case invalidCodeTooManyTimes = 17
        
        /** Too many request_ids provided - this error should never occur */
        case tooManyRequestIDs = 18
        
        /** Control command could not be executed */
        case cannotExecuteCommand = 19

        /** Device ID was missing or invalid */
        case invalidDeviceID = 50
        
        /** Source IP Address was missing or invalid */
        case invalidSourceIPAdress = 51
        
        /** Source IP differs from previous communication with sdk service */
        case sourceIPMismatch = 52

        /** Missing or invalid phone number. */
        case invalidNumber = 53

        /** Missing or invalid PIN code. */
        case invalidCode = 54

        /** User must be in pending status to be able to perform a PIN check. */
        case cannotPerformCheck = 55

        /** User verified with another phone number - we will verify again. */
        case verificationRestarted = 56

        /** Verified User returning after too long a duration - we will verify again. */
        case verificationExpiredRestarted = 57

        /** This Number SDK revision is not supported anymore. Please upgrade the SDK version to be able to perform verifications. */
        case sdkNotSupported = 58

        /** The device  iOS version is not supported. */
        case osNotSupported = 59

        /** Throttled. Too many failed requests. */
        case requestRejected = 60
        
        /** Command missing or invalid */
        case invalidCommand = 61
        
        /** User status invalid for this Control request - user's should be in pending status */
        case invalidUserStatusForCommand = 62
    }
    
    static let responseCodeToVerifyError : [ Code : VerifyError ] =
        [.responseThrottle      :   .throttled,
         .invalidAppID          :   .invalidCredentials,
         .invalidToken          :   .internalError,
         .internalError         :   .internalError,
         .unroutableRequest     :   .invalidNumber,
         .numberBlacklisted     :   .userBlacklisted,
         .accountBarred         :   .accountBarred,
         .quotaExceeded         :   .quotaExceeded,
         .concurrentVerificationsNotAllowed  : .internalError,
         .invalidSignature      :   .invalidCredentials,
         .destinationNumberNotSupported  :   .invalidNumber,
         .invalidPinCode        :   .invalidPinCode,
         .invalidCodeTooManyTimes   :   .invalidCodeTooManyTimes,
         .tooManyRequestIDs     :   .internalError,
         .invalidDeviceID       :   .internalError,
         .invalidSourceIPAdress :   .internalError,
         .sourceIPMismatch      :   .internalError,
         .invalidNumber         :   .invalidNumber,
         .invalidCode           :   .invalidPinCode,
         .cannotPerformCheck    :   .cannotPerformCheck,
         .sdkNotSupported       :   .sdkRevisionNotSupported,
         .osNotSupported        :   .osNotSupported,
         .requestRejected       :   .throttled,
         .invalidCommand        :   .internalError
        ]
}
