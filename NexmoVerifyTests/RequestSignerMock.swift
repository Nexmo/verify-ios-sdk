//
//  RequestSignerMock.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 30/08/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation
@testable import NexmoVerify

class RequestSignerMock : NSObject, RequestSigner {
    private(set) var generateSignatureWithParamsCalled = false
    private(set) var md5HashWithDataCalled = false
    private(set) var validateSignatureWithSignatureCalled = false
    private(set) var allowedTimestampCalled = false
    
    func generateSignature(withParams params: [AnyHashable: Any]!, sharedSecretKey secretKey: String!) -> String! {
        generateSignatureWithParamsCalled = true
        return "stub"
    }
    
    func md5Hash(with data: Data!) -> String! {
        md5HashWithDataCalled = true
        return "stub"
    }
    
    func validateSignature(withSignature signature: String!, params: [AnyHashable: Any]!, sharedSecretKey secretKey: String!) -> Bool {
        validateSignatureWithSignatureCalled = true
        return true
    }
    
    func allowedTimestamp(_ timestamp: String!) -> Bool {
        allowedTimestampCalled = true
        return true
    }
}
