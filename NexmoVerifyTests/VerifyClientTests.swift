//
//  VerifyClientTests.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 01/09/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation
import XCTest
@testable import NexmoVerify

class VerifyClientTests : XCTestCase {

    func testLogoutUserCallsLogoutService() {
        let serviceExecutor = ServiceExecutorMock()
        let verifyService = VerifyServiceMock()
        let checkService = CheckServiceMock()
        let controlService = ControlServiceMock()
        let logoutRequest = LogoutRequest(number: VerifyIosSdkTests.TEST_NUMBER, countryCode: VerifyIosSdkTests.TEST_COUNTRY_CODE)
        let logoutService = LogoutServiceMock(expectedRequest: logoutRequest)
        let searchService = SearchServiceMock()
        let verifyClient = VerifyClient(nexmoClient: VerifyIosSdkTests.nexmoClient, serviceExecutor: serviceExecutor, verifyService: verifyService, checkService: checkService, controlService: controlService, logoutService: logoutService, searchService: searchService)
        verifyClient.logoutUser(countryCode: VerifyIosSdkTests.TEST_COUNTRY_CODE, number:  VerifyIosSdkTests.TEST_NUMBER, completionBlock: { error in
            // nothing to do here, stub
        })
        
        XCTAssertTrue(logoutService.startCalled, "Logout Service not being called")
    }
    
    func testLogoutUserCallsFinalCallback() {
        let serviceExecutor = ServiceExecutorMock()
        let verifyService = VerifyServiceMock()
        let checkService = CheckServiceMock()
        let controlService = ControlServiceMock()
        let timestamp = "\(Int(Date().timeIntervalSince1970))"
        let logoutRequest = LogoutRequest(number: VerifyIosSdkTests.TEST_NUMBER, countryCode: VerifyIosSdkTests.TEST_COUNTRY_CODE)
        let response = LogoutResponse(signature: VerifyIosSdkTests.TEST_SIGNATURE, resultCode: 0, resultMessage: VerifyIosSdkTests.TEST_RESULT_MESSAGE, timestamp: timestamp, messageBody: VerifyIosSdkTests.TEST_MESSAGE_BODY)
        let logoutService = LogoutServiceMock(expectedRequest: logoutRequest, callbackResponse: response, callbackError: nil)
        let searchService = SearchServiceMock()
        let verifyClient = VerifyClient(nexmoClient: VerifyIosSdkTests.nexmoClient, serviceExecutor: serviceExecutor, verifyService: verifyService, checkService: checkService, controlService: controlService, logoutService: logoutService, searchService: searchService)
        var callbackCalled = false
        verifyClient.logoutUser(countryCode: VerifyIosSdkTests.TEST_COUNTRY_CODE, number:  VerifyIosSdkTests.TEST_NUMBER, completionBlock: { error in
            // nothing to do here, stub
            callbackCalled = true
        })
        XCTAssertTrue(callbackCalled, "final logout callback not being called")
    }
    
    func testGetUserStatusCallsSearchService() {
        let searchRequest = SearchRequest(number: VerifyIosSdkTests.TEST_NUMBER, countryCode: VerifyIosSdkTests.TEST_COUNTRY_CODE)
        let searchService = SearchServiceMock(expectedRequest: searchRequest)
        let serviceExecutor = ServiceExecutorMock()
        let verifyService = VerifyServiceMock()
        let checkService = CheckServiceMock()
        let controlService = ControlServiceMock()
        let logoutService = LogoutServiceMock()
        let verifyClient = VerifyClient(nexmoClient: VerifyIosSdkTests.nexmoClient, serviceExecutor: serviceExecutor, verifyService: verifyService, checkService: checkService, controlService: controlService, logoutService: logoutService, searchService: searchService)
        verifyClient.getUserStatus(countryCode: VerifyIosSdkTests.TEST_COUNTRY_CODE, number: VerifyIosSdkTests.TEST_NUMBER) { response, error in
            // nothing to do, stub
        }
        XCTAssert(searchService.startCalled, "Search service was not called")
    }
    
    func testGetUserStatusCallsFinalCallback() {
        let searchRequest = SearchRequest(number: VerifyIosSdkTests.TEST_NUMBER, countryCode: VerifyIosSdkTests.TEST_COUNTRY_CODE)
        let timestamp = Date()
        let response = SearchResponse(userStatus: VerifyIosSdkTests.TEST_USER_STATUS, signature: VerifyIosSdkTests.TEST_SIGNATURE, resultCode: 0, resultMessage: VerifyIosSdkTests.TEST_RESULT_MESSAGE, timestamp: timestamp, messageBody: VerifyIosSdkTests.TEST_MESSAGE_BODY)
        let searchService = SearchServiceMock(expectedRequest: searchRequest, callbackResponse: response, callbackError: nil)
        let serviceExecutor = ServiceExecutorMock()
        let verifyService = VerifyServiceMock()
        let checkService = CheckServiceMock()
        let controlService = ControlServiceMock()
        let logoutService = LogoutServiceMock()
        let verifyClient = VerifyClient(nexmoClient: VerifyIosSdkTests.nexmoClient, serviceExecutor: serviceExecutor, verifyService: verifyService, checkService: checkService, controlService: controlService, logoutService: logoutService, searchService: searchService)
        var callbackCalled = false
        verifyClient.getUserStatus(countryCode: VerifyIosSdkTests.TEST_COUNTRY_CODE, number: VerifyIosSdkTests.TEST_NUMBER) { response, error in
            callbackCalled = true
        }
        XCTAssert(callbackCalled, "Search service was not called")
    }
    
    func testGetVerifiedUserCallsVerifyService() {
        let serviceExecutor = ServiceExecutorMock()
        let verifyRequest = VerifyRequest(countryCode: VerifyIosSdkTests.TEST_COUNTRY_CODE, phoneNumber: VerifyIosSdkTests.TEST_NUMBER, standalone: false)
        let verifyService = VerifyServiceMock(expectedRequest: verifyRequest)
        let checkService = CheckServiceMock()
        let controlService = ControlServiceMock()
        let logoutService = LogoutServiceMock()
        let searchService = SearchServiceMock()
        let verifyClient = VerifyClient(nexmoClient: VerifyIosSdkTests.nexmoClient, serviceExecutor: serviceExecutor, verifyService: verifyService, checkService: checkService, controlService: controlService, logoutService: logoutService, searchService: searchService)
        verifyClient.getVerifiedUser(countryCode: VerifyIosSdkTests.TEST_COUNTRY_CODE, phoneNumber: VerifyIosSdkTests.TEST_NUMBER,
            onVerifyInProgress: {
                // nothing to do, stub
            },
            onUserVerified: {
                // nothing to do, stub
            },
            onError: {error in
                // nothing to do, stub
            })
        XCTAssert(verifyService.startCalled, "Verify service was not called")
    }
    
    func testGetVerifiedUserCallsVerifyServiceWithPushToken() {
        let serviceExecutor = ServiceExecutorMock()
        let verifyRequest = VerifyRequest(countryCode: VerifyIosSdkTests.TEST_COUNTRY_CODE, phoneNumber: VerifyIosSdkTests.TEST_NUMBER, standalone: false, pushToken: VerifyIosSdkTests.TEST_PUSH_TOKEN)
        let verifyService = VerifyServiceMock(expectedRequest: verifyRequest)
        let checkService = CheckServiceMock()
        let controlService = ControlServiceMock()
        let logoutService = LogoutServiceMock()
        let searchService = SearchServiceMock()
        let verifyClient = VerifyClient(nexmoClient: VerifyIosSdkTests.nexmoClient, serviceExecutor: serviceExecutor, verifyService: verifyService, checkService: checkService, controlService: controlService, logoutService: logoutService, searchService: searchService)
        verifyClient.getVerifiedUser(countryCode: VerifyIosSdkTests.TEST_COUNTRY_CODE, phoneNumber: VerifyIosSdkTests.TEST_NUMBER,
            onVerifyInProgress: {
                // nothing to do, stub
            },
            onUserVerified: {
                // nothing to do, stub
            },
            onError: {error in
                // nothing to do, stub
            })
        XCTAssert(verifyService.startCalled, "Verify service was not called")
    }
    
    func testCheckPinCodeCallsCheckService() {
        let checkRequest = CheckRequest(pinCode: VerifyIosSdkTests.TEST_PIN_CODE, countryCode: VerifyIosSdkTests.TEST_COUNTRY_CODE, phoneNumber: VerifyIosSdkTests.TEST_NUMBER)
        let checkService = CheckServiceMock(expectedRequest: checkRequest)
        let serviceExecutor = ServiceExecutorMock()
        let verifyResponse = VerifyResponse(userStatus: "pending", signature: "lol", resultCode: 0, resultMessage: "lol", timestamp: "\(Int(Date().timeIntervalSince1970))", messageBody: "nil")
        let verifyService = VerifyServiceMock(expectedRequest: nil, callbackResponse: verifyResponse, callbackError: nil)
        let controlService = ControlServiceMock()
        let logoutService = LogoutServiceMock()
        let searchService = SearchServiceMock()
        let verifyClient = VerifyClient(nexmoClient: VerifyIosSdkTests.nexmoClient, serviceExecutor: serviceExecutor, verifyService: verifyService, checkService: checkService, controlService: controlService, logoutService: logoutService, searchService: searchService)
        verifyClient.getVerifiedUser(countryCode: VerifyIosSdkTests.TEST_COUNTRY_CODE, phoneNumber: VerifyIosSdkTests.TEST_NUMBER,
        onVerifyInProgress: {
            // nothing to do, stub
        }, onUserVerified: {
            // nothing to do, stub
        }, onError: { error in
            // nothing to do, stub
        })
        verifyClient.checkPinCode(VerifyIosSdkTests.TEST_PIN_CODE)
        XCTAssert(checkService.startCalled, "Check service was not called")
    }
    
    func testCheckPinCodeWithCountryCodeWithNumberCallsCheckService() {
        let checkRequest = CheckRequest(pinCode: VerifyIosSdkTests.TEST_PIN_CODE, countryCode: VerifyIosSdkTests.TEST_COUNTRY_CODE, phoneNumber: VerifyIosSdkTests.TEST_NUMBER)
        let checkService = CheckServiceMock(expectedRequest: checkRequest)
        let serviceExecutor = ServiceExecutorMock()
        let verifyResponse = VerifyResponse(userStatus: "pending", signature: "lol", resultCode: 0, resultMessage: "lol", timestamp: "\(Int(Date().timeIntervalSince1970))", messageBody: "nil")
        let verifyService = VerifyServiceMock(expectedRequest: nil, callbackResponse: verifyResponse, callbackError: nil)
        let controlService = ControlServiceMock()
        let logoutService = LogoutServiceMock()
        let searchService = SearchServiceMock()
        let verifyClient = VerifyClient(nexmoClient: VerifyIosSdkTests.nexmoClient, serviceExecutor: serviceExecutor, verifyService: verifyService, checkService: checkService, controlService: controlService, logoutService: logoutService, searchService: searchService)
        verifyClient.getVerifiedUser(countryCode: VerifyIosSdkTests.TEST_COUNTRY_CODE, phoneNumber: VerifyIosSdkTests.TEST_NUMBER,
        onVerifyInProgress: {
            // nothing to do, stub
        }, onUserVerified: {
            // nothing to do, stub
        }, onError: { _ in
            // nothing to do, stub
        })
        verifyClient.checkPinCode(VerifyIosSdkTests.TEST_PIN_CODE, countryCode: VerifyIosSdkTests.TEST_COUNTRY_CODE, number: VerifyIosSdkTests.TEST_NUMBER,
        onUserVerified: {
            // nothing to do, stub
        }, onError: { _ in
            // nothing to do, stub
        })
        XCTAssert(checkService.startCalled, "Check service was not called")
    }

    func testHandleNotificationWithFalseDoesntCallCheck() {
        let checkService = CheckServiceMock()
        let serviceExecutor = ServiceExecutorMock()
        let verifyClient = VerifyClient(nexmoClient: VerifyIosSdkTests.nexmoClient, serviceExecutor: serviceExecutor, verifyService: VerifyServiceMock(), checkService: checkService, controlService: ControlServiceMock(), logoutService: LogoutServiceMock(), searchService: SearchServiceMock())
        let userInfo = [ "pin" : VerifyIosSdkTests.TEST_PIN_CODE ]
        verifyClient.getVerifiedUser(countryCode: VerifyIosSdkTests.TEST_COUNTRY_CODE, phoneNumber: VerifyIosSdkTests.TEST_NUMBER, onVerifyInProgress: {}, onUserVerified: {}, onError: {error in })
        _ = verifyClient.handleNotification(userInfo, performSilentCheck: false)
        XCTAssertFalse(checkService.startCalled, "Check service was called")
    }
    
    func testHandleNotificationReturnsWithPinTrue() {
        let serviceExecutor = ServiceExecutorMock()
        let verifyClient = VerifyClient(nexmoClient: VerifyIosSdkTests.nexmoClient, serviceExecutor: serviceExecutor, verifyService: VerifyServiceMock(), checkService: CheckServiceMock(), controlService: ControlServiceMock(), logoutService: LogoutServiceMock(), searchService: SearchServiceMock())
        let userInfo = [ "pin" : VerifyIosSdkTests.TEST_PIN_CODE ]
        XCTAssert(verifyClient.handleNotification(userInfo, performSilentCheck: false), "handleNotification returned false")
    }
    
    func testHandleNotificationReturnsWithNoTrue() {
        let serviceExecutor = ServiceExecutorMock()
        let verifyClient = VerifyClient(nexmoClient: VerifyIosSdkTests.nexmoClient, serviceExecutor: serviceExecutor, verifyService: VerifyServiceMock(), checkService: CheckServiceMock(), controlService: ControlServiceMock(), logoutService: LogoutServiceMock(), searchService: SearchServiceMock())
        let userInfo = [ "not_a_pin" : VerifyIosSdkTests.TEST_PIN_CODE ]
        XCTAssertFalse(verifyClient.handleNotification(userInfo, performSilentCheck: false), "handleNotificationReturnedTrue")
    }
}
