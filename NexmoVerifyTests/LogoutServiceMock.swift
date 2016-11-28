//
//  LogoutServiceMock.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 30/08/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation
@testable import NexmoVerify

class LogoutServiceMock : LogoutService {

    private var expectedRequest : LogoutRequest!
    private var callbackResponse : LogoutResponse?
    private var callbackError : NSError?
    
    private(set) var startCalled = false
    
    // initiate as a stub
    init() {}
    
    init(expectedRequest: LogoutRequest) {
        self.expectedRequest = expectedRequest
    }
    
    init(expectedRequest: LogoutRequest?, callbackResponse: LogoutResponse?, callbackError: NSError?) {
        self.expectedRequest = expectedRequest
        self.callbackResponse = callbackResponse
        self.callbackError = callbackError
    }
    
    // no expected request => accept any request
    // if request accepted, then invoke callback if a response exists
    func start(request: LogoutRequest, onResponse: @escaping (_ response: LogoutResponse?, _ error: NSError?) -> ()) {
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
