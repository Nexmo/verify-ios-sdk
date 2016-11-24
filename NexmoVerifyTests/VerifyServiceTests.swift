//
//  VerifyServiceTests.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 02/09/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation
import XCTest
@testable import NexmoVerify

class VerifyServiceTests : XCTestCase {

    func testVerifyServiceCallsServiceExecutorWithCorrectParams() {
        let deviceProperties = DevicePropertiesMock()
        let params = [ServiceExecutor.PARAM_NUMBER : VerifyIosSdkTests.TEST_NUMBER,
                      ServiceExecutor.PARAM_COUNTRY_CODE : VerifyIosSdkTests.TEST_COUNTRY_CODE,
                      ServiceExecutor.PARAM_SOURCE_IP : deviceProperties.getIpAddress()!,
                      ServiceExecutor.PARAM_DEVICE_ID : deviceProperties.getUniqueDeviceIdentifierAsString()!]
        let serviceExecutor = ServiceExecutorMock(expectedParams: params, httpRequest: HttpRequest(request: URLRequest(url: Config.ENDPOINT_PRODUCTION_URL), encoding: String.Encoding.utf8))
        let verifyService = SDKVerifyService(nexmoClient: VerifyIosSdkTests.nexmoClient, serviceExecutor: serviceExecutor, deviceProperties: deviceProperties)
        let verifyRequest = VerifyRequest(countryCode: VerifyIosSdkTests.TEST_COUNTRY_CODE, phoneNumber: VerifyIosSdkTests.TEST_NUMBER, standalone: false)
        let verifyExpectation = expectation(description: "verify response received")
        verifyService.start(request: verifyRequest) { response, error in
            verifyExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(serviceExecutor.performHttpRequestForServiceCalled, "Generate Http Request not called correctly!")
    }
    
    func testVerifyServiceCallsServiceExecutorWithCorrectParamsWithPushToken() {
        let deviceProperties = DevicePropertiesMock()
        let params = [ServiceExecutor.PARAM_COUNTRY_CODE : VerifyIosSdkTests.TEST_COUNTRY_CODE,
                      ServiceExecutor.PARAM_NUMBER : VerifyIosSdkTests.TEST_NUMBER,
                      ServiceExecutor.PARAM_PUSH_TOKEN : VerifyIosSdkTests.TEST_PUSH_TOKEN,
                      ServiceExecutor.PARAM_DEVICE_ID : deviceProperties.getUniqueDeviceIdentifierAsString()!,
                      ServiceExecutor.PARAM_SOURCE_IP : deviceProperties.getIpAddress()!]
        let serviceExecutor = ServiceExecutorMock(expectedParams: params, httpRequest: HttpRequest(request: URLRequest(url: Config.ENDPOINT_PRODUCTION_URL), encoding: String.Encoding.utf8))
        let verifyService = SDKVerifyService(nexmoClient: VerifyIosSdkTests.nexmoClient, serviceExecutor: serviceExecutor, deviceProperties: deviceProperties)
        let verifyRequest = VerifyRequest(countryCode: VerifyIosSdkTests.TEST_COUNTRY_CODE, phoneNumber: VerifyIosSdkTests.TEST_NUMBER, standalone: false , pushToken: VerifyIosSdkTests.TEST_PUSH_TOKEN)
        let verifyExpectation = expectation(description: "verify response received")
        verifyService.start(request: verifyRequest) { response, error in
            verifyExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(serviceExecutor.performHttpRequestForServiceCalled, "Generate Http Request not called correctly!")
    }
}
