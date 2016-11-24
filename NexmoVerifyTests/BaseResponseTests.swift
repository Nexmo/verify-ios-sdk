//
//  BaseResponseTests.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 08/09/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation
import XCTest
@testable import NexmoVerify

class BaseResponseTests : XCTestCase {
    
    func testBaseResponseCallsIsSignatureInvalid() {
        class BaseResponseMock : BaseResponse {
            
            var called = false
            
            override func isSignatureValid(_ signature: String, nexmoClient: NexmoClient, messageBody: String) -> Bool {
                called = true
                return true
            }
        }
        let resultCode = 0
        let resultMessage = "some result message"
        let timestamp = "\(Int(Date().timeIntervalSince1970))"
        let params = [ServiceExecutor.PARAM_RESULT_CODE : resultCode,
                      ServiceExecutor.PARAM_RESULT_MESSAGE : resultMessage,
                      ServiceExecutor.PARAM_TIMESTAMP : timestamp] as [String : Any]
        let jsonData = try! JSONSerialization.data(withJSONObject: params, options: [])
        
        guard let url = URL(string: "www.example.com") else { return XCTFail("") }
        
        let httpResponse = HttpResponse(data: jsonData, response: HTTPURLResponse(url: url, statusCode: 0, httpVersion: "1.1", headerFields: [ServiceExecutor.RESPONSE_SIG : "some_sig" ])!, encoding: String.Encoding.utf8, timestamp: timestamp)
        let baseResponse = BaseResponseMock(httpResponse)
        
        XCTAssert(baseResponse!.called, "isSignatureValid is was not called")
    }
}
