//
//  CheckServiceTests.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 02/09/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation
import XCTest
@testable import NexmoVerify

class CheckServiceTests : XCTestCase {

    func testCheckServiceCallsServiceExecutorWithCorrectParams() {
        let deviceProperties = DevicePropertiesMock()
        let nexmoClient = VerifyIosSdkTests.nexmoClient

        let params: [String : String] = [ServiceExecutor.PARAM_NUMBER : VerifyIosSdkTests.TEST_NUMBER,
                      ServiceExecutor.PARAM_DEVICE_ID : deviceProperties.getUniqueDeviceIdentifierAsString()!,
                      ServiceExecutor.PARAM_SOURCE_IP : deviceProperties.getIpAddress()!,
                      ServiceExecutor.PARAM_COUNTRY_CODE : VerifyIosSdkTests.TEST_COUNTRY_CODE,
                      ServiceExecutor.PARAM_CODE : VerifyIosSdkTests.TEST_PIN_CODE]

        let serviceExecutor = ServiceExecutorMock(expectedParams: params, httpRequest: HttpRequest(request: URLRequest(url: Config.ENDPOINT_PRODUCTION_URL), encoding: String.Encoding.utf8))
        let checkService = SDKCheckService(nexmoClient: nexmoClient, serviceExecutor: serviceExecutor, deviceProperties: deviceProperties)
        let checkRequest = CheckRequest(pinCode: VerifyIosSdkTests.TEST_PIN_CODE, countryCode: VerifyIosSdkTests.TEST_COUNTRY_CODE, phoneNumber: VerifyIosSdkTests.TEST_NUMBER)
        let checkExpectation = expectation(description: "check response called")
        checkService.start(request: checkRequest) { response, error in
            checkExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(serviceExecutor.performHttpRequestForServiceCalled, "service executor not called with correct parameters!")
    }
}
