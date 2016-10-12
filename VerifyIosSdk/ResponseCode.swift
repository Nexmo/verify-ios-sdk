//
//  ResponseCode.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 16/05/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

import Foundation

open class ResponseCode {

    enum Code : Int {
        /** The request was successfully accepted by Nexmo. */
        case result_CODE_OK = 0
        
        /** Exceeded maximum throughput - response has been throttled */
        case response_THROTTLE = 1
        
        /** Missing or invalid App ID */
        case invalid_APP_ID = 2
        
        /** Invalid token. Expired token needs to be re-generated. */
        case invalid_TOKEN = 3
        
        /** Invalid app_id. Supplied app_id is not listed under your accepted application list. */
        case invalid_CREDENTIALS = 4
        
        /** Internal error occurred */
        case internal_ERROR = 5
        
        /** Unable to route your verify request! */
        case unroutable_REQUEST = 6
        
        /** Number blacklisted from verification */
        case number_BLACKLISTED = 7
        
        /** This account has been barred from sending messages */
        case account_BARRED = 8
        
        /** Your account does not have sufficient credit to process this request. */
        case quota_EXCEEDED = 9
        
        /** Concurrent verifications are not allowed - this error should never occur */
        case concurrent_VERIFICATIONS_NOT_ALLOWED = 10
        
        /////////** Invalid signature (usually related to bad secret) **/
        case invalid_SIGNATURE = 14
        
        /** Destination number does not reside within a supported network */
        case destination_NUMBER_NOT_SUPPORTED = 15

        /** Missing or invalid PIN code supplied. */
        case invalid_PIN_CODE = 16

        /** A wrong PIN code was provided too many times. */
        case invalid_CODE_TOO_MANY_TIMES = 17
        
        /** Too many request_ids provided - this error should never occur */
        case too_MANY_REQUEST_IDS = 18
        
        /** Control command could not be executed */
        case cannot_EXECUTE_COMMAND = 19

        /** Device ID was missing or invalid */
        case invalid_DEVICE_ID = 50
        
        /** Source IP Address was missing or invalid */
        case invalid_SOURCE_IP_ADDRESS = 51
        
        /** Source IP differs from previous communication with sdk service */
        case source_IP_MISMATCH = 52

        /** Missing or invalid phone number. */
        case invalid_NUMBER = 53

        /** Missing or invalid PIN code. */
        case invalid_CODE = 54

        /** User must be in pending status to be able to perform a PIN check. */
        case cannot_PERFORM_CHECK = 55

        /** User verified with another phone number - we will verify again. */
        case verification_RESTARTED = 56

        /** Verified User returning after too long a duration - we will verify again. */
        case verification_EXPIRED_RESTARTED = 57

        /** This Number SDK revision is not supported anymore. Please upgrade the SDK version to be able to perform verifications. */
        case sdk_NOT_SUPPORTED = 58

        /** The device  iOS version is not supported. */
        case os_NOT_SUPPORTED = 59

        /** Throttled. Too many failed requests. */
        case request_REJECTED = 60
        
        /** Command missing or invalid */
        case invalid_COMMAND = 61
        
        /** User status invalid for this Control request - user's should be in pending status */
        case invalid_USER_STATUS_FOR_COMMAND = 62
    }
    
    static let responseCodeToVerifyError : [ Code : VerifyError ] =
        [.response_THROTTLE     :   .throttled,
         .invalid_APP_ID        :   .invalid_CREDENTIALS,
         .invalid_TOKEN         :   .internal_ERROR,
         .internal_ERROR        :   .internal_ERROR,
         .unroutable_REQUEST    :   .invalid_NUMBER,
         .number_BLACKLISTED    :   .user_BLACKLISTED,
         .account_BARRED        :   .account_BARRED,
         .quota_EXCEEDED        :   .quota_EXCEEDED,
         .concurrent_VERIFICATIONS_NOT_ALLOWED  : .internal_ERROR,
         .invalid_SIGNATURE     :   .invalid_CREDENTIALS,
         .destination_NUMBER_NOT_SUPPORTED  :   .invalid_NUMBER,
         .invalid_PIN_CODE      :   .invalid_PIN_CODE,
         .invalid_CODE_TOO_MANY_TIMES   :   .invalid_CODE_TOO_MANY_TIMES,
         .too_MANY_REQUEST_IDS  :   .internal_ERROR,
         .invalid_DEVICE_ID     :   .internal_ERROR,
         .invalid_SOURCE_IP_ADDRESS     :   .internal_ERROR,
         .source_IP_MISMATCH    :   .internal_ERROR,
         .invalid_NUMBER        :   .invalid_NUMBER,
         .invalid_CODE          :   .invalid_PIN_CODE,
         .cannot_PERFORM_CHECK  :   .cannot_PERFORM_CHECK,
         .sdk_NOT_SUPPORTED     :   .sdk_REVISION_NOT_SUPPORTED,
         .os_NOT_SUPPORTED      :   .os_NOT_SUPPORTED,
         .request_REJECTED      :   .throttled,
         .invalid_COMMAND       :   .internal_ERROR
        ]
}
