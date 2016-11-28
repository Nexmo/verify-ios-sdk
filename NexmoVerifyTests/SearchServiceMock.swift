//
//  SearchServiceMock.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 01/09/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation
@testable import NexmoVerify

class SearchServiceMock : SearchService {

    private var expectedRequest : SearchRequest!
    private var callbackResponse : SearchResponse?
    private var callbackError : NSError?
    
    private(set) var startCalled = false
    
    // initiate as a stub
    init() {}
    
    init(expectedRequest: SearchRequest) {
        self.expectedRequest = expectedRequest
    }
    
    init(expectedRequest: SearchRequest, callbackResponse: SearchResponse?, callbackError: NSError?) {
        self.expectedRequest = expectedRequest
        self.callbackResponse = callbackResponse
        self.callbackError = callbackError
    }
    
    func start(request: SearchRequest, onResponse: @escaping (_ response: SearchResponse?, _ error: NSError?) -> ()) {
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
