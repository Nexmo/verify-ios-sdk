//
//  File.swift
//  NexmoVerify
//
//  Created by Dorian Peake on 05/06/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

import Foundation

/**
    The Base response class for all Nexmo services.
*/
class BaseResponse {

    fileprivate static let Log = Logger(String(describing: ServiceExecutor.self))
    
    fileprivate(set) var signature : String?
    let resultCode : Int
    let resultMessage : String
    let timestamp : String
    let messageBody : String
    
    /// message body parsed as json
    fileprivate(set) var json : [String:AnyObject]
    
    /// on failure, this variable returns the error code
    var verifyError : VerifyError? {
        get {
            if let response = ResponseCode.Code(rawValue: resultCode) {
                if (response == .resultCodeOK) {
                    return nil
                }
                
                if let error = ResponseCode.responseCodeToVerifyError[response] {
                    return error
                } else {
                    return .internalError
                }
            }
            return .internalError
        }
    }
    
    init(signature: String?, resultCode: Int, resultMessage: String, timestamp: String, messageBody: String) {
        self.signature = signature
        self.resultCode = resultCode
        self.resultMessage = resultMessage
        self.timestamp = timestamp
        self.messageBody = messageBody
        self.json = [:]
    }
    
    required init?(_ httpResponse: HttpResponse) {
        if let body = httpResponse.body {
            if let messageData = body.data(using: String.Encoding.utf8, allowLossyConversion: false),
                    let json = (try? JSONSerialization.jsonObject(with: messageData, options: JSONSerialization.ReadingOptions())) as? [String:AnyObject],
                    let resultCode = json[ServiceExecutor.PARAM_RESULT_CODE] as? Int,
                    let resultMessage = json[ServiceExecutor.PARAM_RESULT_MESSAGE] as? String,
                    let timestamp = json[ServiceExecutor.PARAM_TIMESTAMP] as? String {
                self.messageBody = body
                self.resultCode = resultCode
                self.resultMessage = resultMessage
                self.timestamp = timestamp
                self.json = [:]

                if let signature = httpResponse.headers[ServiceExecutor.RESPONSE_SIG] as? String {
                    if (isSignatureValid(signature, nexmoClient: NexmoClient.sharedInstance, messageBody: body)) {
                        self.signature = signature
                    } else {
                        BaseResponse.Log.error("Signature from server was invalid.")
                        return nil
                    }
                }
                self.json = json
                return
            }
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
    func isSignatureValid(_ signature: String, nexmoClient: NexmoClient, messageBody: String) -> Bool {
        let sigMessage = "\(messageBody)\(nexmoClient.sharedSecretKey)"
        let digest = SDKRequestSigner.sharedInstance().md5Hash(with: sigMessage.data(using: String.Encoding.utf8, allowLossyConversion: false))
        
        if (digest == signature) {
            return true
        } else {
            BaseResponse.Log.error("Generated signature [ \(digest) ] didn't match response signature [ \(signature) ]")
            return false
        }
    }
    
    func isSignatureValid(_ nexmoClient: NexmoClient) -> Bool {
        let sigMessage = "\(messageBody)\(nexmoClient.sharedSecretKey)"
        let digest = SDKRequestSigner.sharedInstance().md5Hash(with: sigMessage.data(using: String.Encoding.utf8, allowLossyConversion: false))
        
        if (digest == signature) {
            return true
        } else {
            BaseResponse.Log.error("Generated signature [ \(digest) ] didn't match response signature [ \(signature) ]")
            return false
        }
    }
}
