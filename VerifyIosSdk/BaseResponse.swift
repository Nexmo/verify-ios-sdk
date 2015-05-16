//
//  File.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 05/06/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

import Foundation
import RequestSigning

/**
    The Base response class for all Nexmo services.
*/
class BaseResponse {

    private static let Log = Logger(toString(ServiceHelper))
    
    private(set) var signature : String?
    let resultCode : Int
    let resultMessage : String
    let timestamp : String
    let messageBody : String
    
    /// message body parsed as json
    let json : [String:AnyObject]
    
    /// on failure, this variable returns the error code
    var verifyError : VerifyError? {
        get {
            if let response = ResponseCode.Code(rawValue: resultCode) {
                if (response == .RESULT_CODE_OK) {
                    return nil
                }
                
                if let error = ResponseCode.responseCodeToVerifyError[response] {
                    return error
                } else {
                    return .INTERNAL_ERROR
                }
            }
            return .INTERNAL_ERROR
        }
    }
    
    init(signature: String, resultCode: Int, resultMessage: String, timestamp: String, messageBody: String) {
        self.signature = signature
        self.resultCode = resultCode
        self.resultMessage = resultMessage
        self.timestamp = timestamp
        self.messageBody = messageBody
        self.json = [:]
    }
    
    required init?(_ httpResponse: HttpResponse) {
        if let body = httpResponse.body {
            let error = NSErrorPointer()
            if let messageData = body.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false),
                    json = NSJSONSerialization.JSONObjectWithData(messageData, options: NSJSONReadingOptions.allZeros, error: error) as? [String:AnyObject],
                    resultCode = json[ServiceHelper.PARAM_RESULT_CODE] as? Int,
                    resultMessage = json[ServiceHelper.PARAM_RESULT_MESSAGE] as? String,
                    timestamp = json[ServiceHelper.PARAM_TIMESTAMP] as? String {
                self.messageBody = body
                self.resultCode = resultCode
                self.resultMessage = resultMessage
                self.timestamp = timestamp
                if let signature = httpResponse.headers[ServiceHelper.RESPONSE_SIG] as? String {
                    self.signature = signature
                }
                self.json = json
                return
            } else {
                BaseResponse.Log.error("Unable to parse BaseResponse from HttpResponse, should never happen.")
            }
        } else {
            BaseResponse.Log.error("No message body exists in HttpResponse")
        }
        
        self.signature = ""
        self.resultCode = 0
        self.resultMessage = ""
        self.timestamp = ""
        self.messageBody = ""
        self.json = [:]
        return nil
    }
    
    /**
        Determine whether the provided signature is valid
    */
    func isSignatureValid() -> Bool {
        let nexmoClient = NexmoClient.sharedInstance
        let sigMessage = "\(self.messageBody)\(nexmoClient.sharedSecretKey)"
        let digest = SDKRequestSigner.sharedInstance().md5HashWithData(sigMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))
        
        if (digest == self.signature) {
            return true
        } else {
            BaseResponse.Log.error("Generated signature [ \(digest) ] didn't match response signature [ \(self.signature) ]")
            return false
        }
    }
}
