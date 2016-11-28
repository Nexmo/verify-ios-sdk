//
//  ConfigTests.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 15/11/2015.
//  Copyright © 2015 Nexmo Inc. All rights reserved.
//

import Foundation
import XCTest
@testable import NexmoVerify

class ConfigTests : XCTestCase {

    func testAppIdLoadedFromPropertiesFile() {
        XCTAssertNotNil(Config.APP_ID, "App Id was not loaded!")
    }
    
    func testProductionEndpointLoadedFromPropertiesFile() {
        XCTAssertNotNil(Config.ENDPOINT_PRODUCTION, "Production endpoint not loaded!")
    }
    
    func testSecretKeyLoadedFromPropertiesFile() {
        XCTAssertNotNil(Config.SECRET_KEY, "Secret key was not loaded!")
    }
}
