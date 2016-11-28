//
//  NexmoClientTests.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 02/09/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation
import XCTest
@testable import NexmoVerify

class NexmoClientTests : XCTestCase {
    
    func testCreateNexmoClientCreatedWithAppKeyAndSharedSecret() {
        NexmoClient.start(applicationId: VerifyIosSdkTests.APP_KEY, sharedSecretKey: VerifyIosSdkTests.APP_SECRET)
        
        XCTAssertNotNil(NexmoClient.sharedInstance)
        XCTAssertEqual(VerifyIosSdkTests.APP_KEY, NexmoClient.sharedInstance.applicationId, "App keys aren't equal")
        XCTAssertEqual(VerifyIosSdkTests.APP_SECRET, NexmoClient.sharedInstance.sharedSecretKey, "App shared secret keys aren't equal")
    }
    
    func testCreateNexmoClientCreatedWithAppKeyAndSharedSecretAndPushToken() {
        NexmoClient.start(applicationId: VerifyIosSdkTests.APP_KEY, sharedSecretKey: VerifyIosSdkTests.APP_SECRET, pushToken: VerifyIosSdkTests.PUSH_TOKEN)
        
        XCTAssertNotNil(NexmoClient.sharedInstance)
        XCTAssertEqual(VerifyIosSdkTests.APP_KEY, NexmoClient.sharedInstance.applicationId, "App keys aren't equal")
        XCTAssertEqual(VerifyIosSdkTests.APP_SECRET, NexmoClient.sharedInstance.sharedSecretKey, "App shared secret keys aren't equal")
        if let pushToken = NexmoClient.sharedInstance.pushToken {
            XCTAssertEqual(VerifyIosSdkTests.PUSH_TOKEN, pushToken, "Push Token was not stored correctly!")
        } else {
            XCTFail("Push Token was nil in nexmo client")
        }
    }
    
    func testNexmoClientSetPushTokenSetsPushTokenVariable() {
        NexmoClient.start(applicationId: VerifyIosSdkTests.APP_KEY, sharedSecretKey: VerifyIosSdkTests.APP_SECRET)
        guard let token = "devicetoken".data(using: .utf8) else { return XCTFail("") }
        
        NexmoClient.setPushToken(token)
        
        if let pushToken = NexmoClient.sharedInstance.pushToken {
            XCTAssertEqual(token.hexString, pushToken, "Push Token was not stored correctly!")
        } else {
            XCTFail("Token was nil in nexmo client")
        }
    }
    
    func testNexmoClientSetsSdkToken() {
        let nexmoClient = NexmoClient.sharedInstance

        nexmoClient.sdkToken = VerifyIosSdkTests.TEST_TOKEN
        XCTAssertEqual(nexmoClient.sdkToken, VerifyIosSdkTests.TEST_TOKEN, "token was not set correctly")
    }
}
