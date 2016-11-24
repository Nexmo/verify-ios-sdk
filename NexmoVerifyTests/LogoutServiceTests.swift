//
//  LogoutServiceTests.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 30/08/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation
import XCTest
@testable import NexmoVerify

class LogoutServiceTests : XCTestCase {
    func testLogoutServiceCallsServiceExecutorWithCorrectParams() {
        let deviceProperties = DevicePropertiesMock()
        let params = [ServiceExecutor.PARAM_NUMBER : VerifyIosSdkTests.TEST_NUMBER,
                      ServiceExecutor.PARAM_DEVICE_ID : deviceProperties.getUniqueDeviceIdentifierAsString()!,
                      ServiceExecutor.PARAM_SOURCE_IP : deviceProperties.getIpAddress()!,
                      ServiceExecutor.PARAM_COUNTRY_CODE : VerifyIosSdkTests.TEST_COUNTRY_CODE]
        let serviceExecutor = ServiceExecutorMock(expectedParams: params, httpRequest: HttpRequest(request: URLRequest(url: Config.ENDPOINT_PRODUCTION_URL), encoding: String.Encoding.utf8))
        let requestSigner = RequestSignerMock()
        let logoutRequest = LogoutRequest(number: VerifyIosSdkTests.TEST_NUMBER, countryCode: VerifyIosSdkTests.TEST_COUNTRY_CODE)
        let logoutService = SDKLogoutService(nexmoClient: VerifyIosSdkTests.nexmoClient, serviceExecutor: serviceExecutor, requestSigner: requestSigner, deviceProperties: deviceProperties)
        let logoutExpectation = expectation(description: "logout finished")
        logoutService.start(request: logoutRequest) { response, error in
            // nothing to do here
            logoutExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(serviceExecutor.performHttpRequestForServiceCalled, "logout service not called with correct parameters!")
    }
    
    func testLogoutServiceCallsCallbackResponseOnSuccess() {
        class ServiceExecutorLogoutServiceMock : ServiceExecutorMock {
            
            init(expectedParams: [String : String]?) {
                self.expectedParams = expectedParams
                super.init(expectedParams: expectedParams, httpRequest: nil)
            }
            
            fileprivate var called = false
            fileprivate let expectedParams : [String : String]?
            
            override func performHttpRequestForService(_ responseFactory: ResponseFactory, nexmoClient: NexmoClient, path: String, timestamp: Date, params: [String : String]?, isPost: Bool, callback: @escaping (_ response: BaseResponse?, _ error: NSError?) -> ()) {
                if let params = params,
                       let expectedParams = expectedParams {
                    if (params == expectedParams) {
                        called = true
                    }
                } else if (params == nil && expectedParams == nil) {
                    called = true
                }
                
                if (called) {
                    let timestamp = "\(Int(Date().timeIntervalSince1970))"
                    let logoutResponse = LogoutResponse(signature: VerifyIosSdkTests.TEST_SIGNATURE, resultCode: 0, resultMessage: "user logged out", timestamp: timestamp, messageBody: "some message body")
                    callback(logoutResponse as BaseResponse, nil)
                } else {
                    callback(nil, NSError(domain: "ServiceExecutorLogoutServiceMock", code: 1, userInfo: [NSLocalizedDescriptionKey : "Some generic error"]))
                }
                
                return
            }
        }
    
        let logoutRequest = LogoutRequest(number: VerifyIosSdkTests.TEST_NUMBER, countryCode: VerifyIosSdkTests.TEST_COUNTRY_CODE)
        let deviceProperties = DevicePropertiesMock()
        let params = [ServiceExecutor.PARAM_NUMBER : VerifyIosSdkTests.TEST_NUMBER,
                      ServiceExecutor.PARAM_DEVICE_ID : deviceProperties.getUniqueDeviceIdentifierAsString()!,
                      ServiceExecutor.PARAM_SOURCE_IP : deviceProperties.getIpAddress()!,
                      ServiceExecutor.PARAM_COUNTRY_CODE : VerifyIosSdkTests.TEST_COUNTRY_CODE]
        let serviceExecutor = ServiceExecutorLogoutServiceMock(expectedParams: params)
        let requestSigner = RequestSignerMock()
        let logoutService = SDKLogoutService(nexmoClient: VerifyIosSdkTests.nexmoClient, serviceExecutor: serviceExecutor, requestSigner: requestSigner, deviceProperties: deviceProperties)
        let serviceExpectation = expectation(description: "service expectation")
        var callbackCalled = false
        logoutService.start(request: logoutRequest) { response, error in
            if let _ = response {
                callbackCalled = true
            }
            serviceExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(callbackCalled, "Callback not called with LogoutResponse")

    }
    
    func testLogoutServiceCallsCallbackWithErrorOnFailure() {
        class ServiceExecutorLogoutServiceMock : ServiceExecutorMock {
            
            init(expectedParams: [String : String]?) {
                self.expectedParams = expectedParams
                super.init(expectedParams: expectedParams, httpRequest: nil)
            }
            
            fileprivate var called = false
            fileprivate let expectedParams : [String : String]?
            
            override func performHttpRequestForService(_ responseFactory: ResponseFactory, nexmoClient: NexmoClient, path: String, timestamp: Date, params: [String : String]?, isPost: Bool, callback: @escaping (_ response: BaseResponse?, _ error: NSError?) -> ()) {
                callback(nil, NSError(domain: "ServiceExecutorLogoutServiceMock", code: 1, userInfo: [NSLocalizedDescriptionKey : "Some generic error"]))
                
                return
            }
        }
    
        let logoutRequest = LogoutRequest(number: VerifyIosSdkTests.TEST_NUMBER, countryCode: VerifyIosSdkTests.TEST_COUNTRY_CODE)
        let deviceProperties = DevicePropertiesMock()
        let serviceExecutor = ServiceExecutorLogoutServiceMock(expectedParams: nil)
        let requestSigner = RequestSignerMock()
        let logoutService = SDKLogoutService(nexmoClient: VerifyIosSdkTests.nexmoClient, serviceExecutor: serviceExecutor, requestSigner: requestSigner, deviceProperties: deviceProperties)
        let serviceExpectation = expectation(description: "service expectation")
        var callbackCalled = false
        logoutService.start(request: logoutRequest) { response, error in
            if let _ = error {
                callbackCalled = true
            }
            serviceExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(callbackCalled, "Callback not called with LogoutResponse")

    }
}
