//
//  CheckServiceMock.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 01/09/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation
@testable import NexmoVerify

class CheckServiceMock : CheckService {

    private var expectedRequest : CheckRequest!
    private var callbackResponse : CheckResponse?
    private var callbackError : NSError?
    
    private(set) var startCalled = false
    
    // initiate as a stub
    init() {}
    
    init(expectedRequest: CheckRequest) {
        self.expectedRequest = expectedRequest
    }
    
    init(expectedRequest: CheckRequest, callbackResponse: CheckResponse, callbackError: NSError) {
        self.expectedRequest = expectedRequest
        self.callbackResponse = callbackResponse
        self.callbackError = callbackError
    }
    
    func start(request: CheckRequest, onResponse: @escaping (_ response: CheckResponse?, _ error: NSError?) -> ()) {
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
