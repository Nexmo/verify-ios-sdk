//
//  ControlServiceMock.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 01/09/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation
@testable import NexmoVerify

class ControlServiceMock : ControlService {

    private var expectedRequest : ControlRequest!
    private var callbackResponse : ControlResponse?
    private var callbackError : NSError?
    
    private(set) var startCalled = false
    
    // initiate as a stub
    init() {}
    
    init(expectedRequest: ControlRequest) {
        self.expectedRequest = expectedRequest
    }
    
    init(expectedRequest: ControlRequest, callbackResponse: ControlResponse, callbackError: NSError) {
        self.expectedRequest = expectedRequest
        self.callbackResponse = callbackResponse
        self.callbackError = callbackError
    }
    
    func start(request: ControlRequest, onResponse: @escaping (_ response: ControlResponse?, _ error: NSError?) -> ()) {
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
