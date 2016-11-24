//
//  VerifyServiceMock.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 29/08/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation
@testable import NexmoVerify

class VerifyServiceMock : VerifyService {

    private var expectedRequest : VerifyRequest!
    private var callbackResponse : VerifyResponse?
    private var callbackError : NSError?
    
    private(set) var startCalled = false
    
    // initiate as a stub
    init() {}
    
    init(expectedRequest: VerifyRequest) {
        self.expectedRequest = expectedRequest
    }
    
    init(expectedRequest: VerifyRequest?, callbackResponse: VerifyResponse?, callbackError: NSError?) {
        self.expectedRequest = expectedRequest
        self.callbackResponse = callbackResponse
        self.callbackError = callbackError
    }
    
    func start(request: VerifyRequest, onResponse: @escaping (_ response: VerifyResponse?, _ error: NSError?) -> ()) {
        if (expectedRequest == nil) {
            startCalled = true
        } else if (request == expectedRequest) {
            startCalled = true
        }
        if (startCalled && (callbackResponse != nil || callbackError != nil)) {
            onResponse(callbackResponse, callbackError)
        }
    }
}
