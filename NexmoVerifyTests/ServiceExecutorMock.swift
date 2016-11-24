//
//  ServiceExecutorMock.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 30/08/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation
@testable import NexmoVerify

class ServiceExecutorMock : ServiceExecutor {

    private(set) var generateHttpRequestForServiceCalled = false
    private(set) var performHttpRequestForServiceCalled = false
    private(set) var startCalled = false
    
    private var callbackResponse : TokenResponse?
    private var callbackError : NSError?
    private var expectedParams : [String : String]?
    private var httpRequest : HttpRequest?
    
    override init() {
        super.init()
    }
    
    init(expectedParams: [String : String]?, httpRequest: HttpRequest?) {
        self.expectedParams = expectedParams
        self.httpRequest = httpRequest
        super.init()
    }
    
    init(callbackResponse: TokenResponse, callbackError: NSError) {
        self.callbackResponse = callbackResponse
        self.callbackError = callbackError
        super.init()
    }
    
    override func generateHttpRequestForService(_ nexmoClient: NexmoClient, path: String, timestamp: Date, params: [String : String]?, isPost: Bool) -> HttpRequest? {
        if let params = params,
               let expectedParams = expectedParams {
            if (params == expectedParams) {
                generateHttpRequestForServiceCalled = true
            }
        } else if (params == nil && expectedParams == nil) {
            generateHttpRequestForServiceCalled = true
        }
        
        if (generateHttpRequestForServiceCalled) {
            return httpRequest
        }
        
        return nil
    }
    
    override func performHttpRequestForService(_ responseFactory: ResponseFactory, nexmoClient: NexmoClient, path: String, timestamp: Date, params: [String : String]?, isPost: Bool, callback: @escaping (_ response: BaseResponse?, _ error: NSError?) -> ()) {
        if let params = params,
               let expectedParams = expectedParams {
            if (params == expectedParams) {
                performHttpRequestForServiceCalled = true
            }
        } else if (params == nil && expectedParams == nil) {
            performHttpRequestForServiceCalled = true
        }
        
        // provide some sort of feedback that the service has been called
        callback(nil, NSError(domain: "ServiceExecutor", code: 1, userInfo: [NSLocalizedDescriptionKey : "Some generic error"]))
        
        return
    }
    
    override func getToken(_ nexmoClient: NexmoClient, onResponse: @escaping (_ response: TokenResponse?, _ error: NSError?) -> ()) {
        startCalled = true
        if (startCalled && (callbackResponse != nil || callbackError != nil)) {
            onResponse(callbackResponse, callbackError)
        }
    }
}
