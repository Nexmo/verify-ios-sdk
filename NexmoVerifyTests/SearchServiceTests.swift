//
//  SearchServiceTests.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 02/09/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation
import XCTest
@testable import NexmoVerify

class SearchServiceTests : XCTestCase {
    func testSearchServiceCallsServiceExecutorWithCorrectParams() {
        let deviceProperties = DevicePropertiesMock()
        let params = [ServiceExecutor.PARAM_NUMBER : VerifyIosSdkTests.TEST_NUMBER,
                      ServiceExecutor.PARAM_DEVICE_ID : deviceProperties.getUniqueDeviceIdentifierAsString()!,
                      ServiceExecutor.PARAM_SOURCE_IP : deviceProperties.getIpAddress()!,
                      ServiceExecutor.PARAM_COUNTRY_CODE : VerifyIosSdkTests.TEST_COUNTRY_CODE]
        let serviceExecutor = ServiceExecutorMock(expectedParams: params, httpRequest: HttpRequest(request: URLRequest(url: Config.ENDPOINT_PRODUCTION_URL), encoding: String.Encoding.utf8))
        let searchRequest = SearchRequest(number: VerifyIosSdkTests.TEST_NUMBER, countryCode: VerifyIosSdkTests.TEST_COUNTRY_CODE)
        let searchService = SDKSearchService(nexmoClient: VerifyIosSdkTests.nexmoClient, deviceProperties: deviceProperties, serviceExecutor: serviceExecutor)
        let searchExpectation = expectation(description: "Search response received")
        searchService.start(request: searchRequest) {response, error in
            searchExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(serviceExecutor.performHttpRequestForServiceCalled, "Generate Http Request not called correctly!")
    }
    
    func testSearchServiceCallsCallbackWithSearchResponseOnSuccess() {
        class ServiceExecutorSearchServiceMock : ServiceExecutorMock {
            
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
                    let logoutResponse = SearchResponse(userStatus: "verified", signature: VerifyIosSdkTests.TEST_SIGNATURE, resultCode: 0, resultMessage: "user logged out", timestamp: timestamp, messageBody: "some message body")
                    callback(logoutResponse as BaseResponse, nil)
                } else {
                    callback(nil, NSError(domain: "ServiceExecutorLogoutServiceMock", code: 1, userInfo: [NSLocalizedDescriptionKey : "Some generic error"]))
                }
                
                return
            }
        }
        
        let deviceProperties = DevicePropertiesMock()
        let params = [ServiceExecutor.PARAM_NUMBER : VerifyIosSdkTests.TEST_NUMBER,
                      ServiceExecutor.PARAM_DEVICE_ID : deviceProperties.getUniqueDeviceIdentifierAsString()!,
                      ServiceExecutor.PARAM_SOURCE_IP : deviceProperties.getIpAddress()!,
                      ServiceExecutor.PARAM_COUNTRY_CODE : VerifyIosSdkTests.TEST_COUNTRY_CODE]
        let serviceExecutor = ServiceExecutorSearchServiceMock(expectedParams: params)
        let searchService = SDKSearchService(nexmoClient: VerifyIosSdkTests.nexmoClient, deviceProperties: deviceProperties, serviceExecutor: serviceExecutor)
        var callbackCalled = false
        let serviceExpectation = expectation(description: "service expectation")
        let searchRequest = SearchRequest(number: VerifyIosSdkTests.TEST_NUMBER, countryCode: VerifyIosSdkTests.TEST_COUNTRY_CODE)
        searchService.start(request: searchRequest) { response, error in
            if let _ = response {
                callbackCalled = true
            }
            serviceExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(callbackCalled, "Callback not called with SarchResponse object")
    }
    
    func testSearchServiceCallsCallbackWithErrorOnFailure() {
    
        class ServiceExecutorSearchServiceMock : ServiceExecutorMock {
            
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

        var callbackCalled = false
        let deviceProperties = DevicePropertiesMock()
        let serviceExecutor = ServiceExecutorSearchServiceMock(expectedParams: nil)
        let searchService = SDKSearchService(nexmoClient: VerifyIosSdkTests.nexmoClient, deviceProperties: deviceProperties, serviceExecutor: serviceExecutor)
        let serviceExpectation = expectation(description: "service expectation")
        let searchRequest = SearchRequest(number: VerifyIosSdkTests.TEST_NUMBER, countryCode: VerifyIosSdkTests.TEST_COUNTRY_CODE)
        searchService.start(request: searchRequest) { response, error in
            if let _ = error {
                callbackCalled = true
            }
            serviceExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssert(callbackCalled, "Callback not called with error object")
    }
}
