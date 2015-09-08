//
//  ResponseCode.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 16/05/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

import Foundation

public class ResponseCode {

    enum Code : Int {
        /** The request was successfully accepted by Nexmo. */
        case RESULT_CODE_OK = 0
        
        /** Exceeded maximum throughput - response has been throttled */
        case RESPONSE_THROTTLE = 1
        
        /** Missing or invalid App ID */
        case INVALID_APP_ID = 2
        
        /** Invalid token. Expired token needs to be re-generated. */
        case INVALID_TOKEN = 3
        
        /** Invalid app_id. Supplied app_id is not listed under your accepted application list. */
        case INVALID_CREDENTIALS = 4
        
        /** Internal error occurred */
        case INTERNAL_ERROR = 5
        
        /** Unable to route your verify request! */
        case UNROUTABLE_REQUEST = 6
        
        /** Number blacklisted from verification */
        case NUMBER_BLACKLISTED = 7
        
        /** This account has been barred from sending messages */
        case ACCOUNT_BARRED = 8
        
        /** Your account does not have sufficient credit to process this request. */
        case QUOTA_EXCEEDED = 9
        
        /** Concurrent verifications are not allowed - this error should never occur */
        case CONCURRENT_VERIFICATIONS_NOT_ALLOWED = 10
        
        /////////** Invalid signature (usually related to bad secret) **/
        case INVALID_SIGNATURE = 14
        
        /** Destination number does not reside within a supported network */
        case DESTINATION_NUMBER_NOT_SUPPORTED = 15

        /** Missing or invalid PIN code supplied. */
        case INVALID_PIN_CODE = 16

        /** A wrong PIN code was provided too many times. */
        case INVALID_CODE_TOO_MANY_TIMES = 17
        
        /** Too many request_ids provided - this error should never occur */
        case TOO_MANY_REQUEST_IDS = 18
        
        /** Control command could not be executed */
        case CANNOT_EXECUTE_COMMAND = 19

        /** Device ID was missing or invalid */
        case INVALID_DEVICE_ID = 50
        
        /** Source IP Address was missing or invalid */
        case INVALID_SOURCE_IP_ADDRESS = 51
        
        /** Source IP differs from previous communication with sdk service */
        case SOURCE_IP_MISMATCH = 52

        /** Missing or invalid phone number. */
        case INVALID_NUMBER = 53

        /** Missing or invalid PIN code. */
        case INVALID_CODE = 54

        /** User must be in pending status to be able to perform a PIN check. */
        case CANNOT_PERFORM_CHECK = 55

        /** User verified with another phone number - we will verify again. */
        case VERIFICATION_RESTARTED = 56

        /** Verified User returning after too long a duration - we will verify again. */
        case VERIFICATION_EXPIRED_RESTARTED = 57

        /** This Number SDK revision is not supported anymore. Please upgrade the SDK version to be able to perform verifications. */
        case SDK_NOT_SUPPORTED = 58

        /** The device  iOS version is not supported. */
        case OS_NOT_SUPPORTED = 59

        /** Throttled. Too many failed requests. */
        case REQUEST_REJECTED = 60
        
        /** Command missing or invalid */
        case INVALID_COMMAND = 61
        
        /** User status invalid for this Control request - user's should be in pending status */
        case INVALID_USER_STATUS_FOR_COMMAND = 62
    }
    
    static let responseCodeToVerifyError : [ Code : VerifyError ] =
        [.RESPONSE_THROTTLE     :   .THROTTLED,
         .INVALID_APP_ID        :   .INVALID_CREDENTIALS,
         .INVALID_TOKEN         :   .INTERNAL_ERROR,
         .INTERNAL_ERROR        :   .INTERNAL_ERROR,
         .UNROUTABLE_REQUEST    :   .INVALID_NUMBER,
         .NUMBER_BLACKLISTED    :   .USER_BLACKLISTED,
         .ACCOUNT_BARRED        :   .ACCOUNT_BARRED,
         .QUOTA_EXCEEDED        :   .QUOTA_EXCEEDED,
         .CONCURRENT_VERIFICATIONS_NOT_ALLOWED  : .INTERNAL_ERROR,
         .INVALID_SIGNATURE     :   .INVALID_CREDENTIALS,
         .DESTINATION_NUMBER_NOT_SUPPORTED  :   .INVALID_NUMBER,
         .INVALID_PIN_CODE      :   .INVALID_PIN_CODE,
         .INVALID_CODE_TOO_MANY_TIMES   :   .INVALID_CODE_TOO_MANY_TIMES,
         .TOO_MANY_REQUEST_IDS  :   .INTERNAL_ERROR,
         .INVALID_DEVICE_ID     :   .INTERNAL_ERROR,
         .INVALID_SOURCE_IP_ADDRESS     :   .INTERNAL_ERROR,
         .SOURCE_IP_MISMATCH    :   .INTERNAL_ERROR,
         .INVALID_NUMBER        :   .INVALID_NUMBER,
         .INVALID_CODE          :   .INVALID_PIN_CODE,
         .CANNOT_PERFORM_CHECK  :   .CANNOT_PERFORM_CHECK,
         .SDK_NOT_SUPPORTED     :   .SDK_REVISION_NOT_SUPPORTED,
         .OS_NOT_SUPPORTED      :   .OS_NOT_SUPPORTED,
         .REQUEST_REJECTED      :   .THROTTLED,
         .INVALID_COMMAND       :   .INTERNAL_ERROR
        ]
}