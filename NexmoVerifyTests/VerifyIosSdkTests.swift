//
//  VerifyIosSdkTests.swift
//  VerifyIosSdkTests
//
//  Created by Dorian Peake on 13/05/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

import UIKit
import XCTest
import SystemConfiguration
import Foundation
@testable import NexmoVerify

class VerifyIosSdkTests: XCTestCase {
   
    private enum VariableKey: String {
        case nexmo = "Nexmo"
        case applicationId = "Verify_Application_Id"
        case applicationSecret = "Verify_Application_Secret"
        case phoneNumber = "Verify_Phone_Number"
    }
    
    static let APP_KEY: String = {
        guard let id = UserDefaults.standard.dictionary(forKey: VariableKey.nexmo.rawValue)?[VariableKey.applicationId.rawValue] as? String,
            !id.isEmpty else {
            XCTFail("Variable not set in info.plist")
            
            fatalError("Variable not set in info.plist")
        }
        
        return id
    }()
    
    static let APP_SECRET: String = {
        guard let secret = UserDefaults.standard.dictionary(forKey: VariableKey.nexmo.rawValue)?[VariableKey.applicationSecret.rawValue] as? String,
            !secret.isEmpty else {
            XCTFail("Variable not set in info.plist")
            
            fatalError("Variable not set in info.plist")
        }
        
        return secret
    }()
    
    static let TEST_NUMBER: String = {
        guard let number = UserDefaults.standard.dictionary(forKey: VariableKey.nexmo.rawValue)?[VariableKey.phoneNumber.rawValue] as? String,
            !number.isEmpty else {
                XCTFail("Variable not set in info.plist")
                
                fatalError("Variable not set in info.plist")
        }
        
        return number
    }()
    
    static let TEST_TOKEN = "some_test_token"
    static let TEST_PIN_CODE = "1010"
    static let TEST_SIGNATURE = "some_test_signature"
    static let TEST_RESULT_MESSAGE = "some_result_message"
    static let TEST_MESSAGE_BODY = "some_message_body"
    static let TEST_USER_STATUS = "pending"
    static let TEST_COUNTRY_CODE = "GB"
    static let TEST_PUSH_TOKEN = "ljdbwpYvXV8:APA91bHwPw5sk8zoHNTE7iZy58ufdMHULVMYMYuI8UazbnqLqW0uPKyykr62F69RKjsFEj0bNDUHhtmMTk_7wUvCoA6C-UO0AV3w_a_ES7qossgfJu7sJ6Z0mTPDC0AX_Ck5TyG8vUxX"
    static let PUSH_TOKEN = "ljdbwpYvXV8:APA91bHwPw5sk8zoHNTE7iZy58ufdMHULVMYMYuI8UazbnqLqW0uPKyykr62F69RKjsFEj0bNDUHhtmMTk_7wUvCoA6C-UO0AV3w_a_ES7qossgfJu7sJ6Z0mTPDC0AX_Ck5TyG8vUxX"
   
    static var nexmoClient: NexmoClient = {
        let nexmo = NexmoClient.sharedInstance
        nexmo.applicationId = VerifyIosSdkTests.APP_KEY
        nexmo.sharedSecretKey = VerifyIosSdkTests.APP_SECRET
        
        return nexmo
    }()
 
    private static let Log = Logger(String(describing: VerifyIosSdkTests()))

    // MOCK CLASSES
    
    class VerifyPendingHttpRequest : HttpRequest {
    
        init() {
            super.init(request: URLRequest(url: Config.ENDPOINT_PRODUCTION_URL), encoding: String.Encoding.utf8)
        }
        
        override func execute(_ completionHandler: @escaping (HttpResponse?, NSError?) -> Void) {
            let response = HttpResponse(statusCode: 0, body: "{\"result_code\":0,\"result_message\":\"OK\",\"timestamp\":\"1440018175\",\"user_status\":\"pending\"}", timestamp: Date(), headers: [:])
            completionHandler(response, nil)
        }
    }
    
    class VerifyVerifiedHttpRequest : HttpRequest {
    
        init() {
            super.init(request: URLRequest(url: Config.ENDPOINT_PRODUCTION_URL), encoding: String.Encoding.utf8)
        }
        
        override func execute(_ completionHandler: @escaping (HttpResponse?, NSError?) -> Void) {
            let response = HttpResponse(statusCode: 0, body: "{\"result_code\":0,\"result_message\":\"user already verified\",\"timestamp\":\"1440018175\",\"user_status\":\"verified\"}", timestamp: Date(), headers: [:])
            completionHandler(response, nil)
        }
    }
    
    class VerifyErrorHttpRequest : HttpRequest {
    
        init() {
            super.init(request: URLRequest(url: Config.ENDPOINT_PRODUCTION_URL), encoding: String.Encoding.utf8)
        }
        
        override func execute(_ completionHandler: @escaping (HttpResponse?, NSError?) -> Void) {
            let response = HttpResponse(statusCode: 0, body: "{\"result_code\":120,\"result_message\":\"some generic error\",\"timestamp\":\"1440018175\"}", timestamp: Date(), headers: [:])
            completionHandler(response, nil)
        }
    }
    
    class TokenSuccessHttpRequest : HttpRequest {
    
        init() {
            super.init(request: URLRequest(url: Config.ENDPOINT_PRODUCTION_URL), encoding: String.Encoding.utf8)
        }
        
        override func execute(_ completionHandler: @escaping (HttpResponse?, NSError?) -> Void) {
            let response = HttpResponse(statusCode: 0, body: "{\"result_code\":0,\"result_message\":\"your token is here lolol\",\"token\":\"some_token_here\",\"timestamp\":\"1440018175\"}", timestamp: Date(), headers: [:])
            completionHandler(response, nil)
        }
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func generateRandomPin() -> String {
        let pin = arc4random() % 10000
        let pinString : String
        if (pin < 1000) {
            pinString = "0\(pin)"
        } else {
            pinString = "\(pin)"
        }
        
        return pinString
    }

    // ------------------- Integration Tests ---------------------
    
    /** Test HttpBuilder, HttpRequest and HttpResponse classes in GET request
    */
    func testHttpGetRequest() {
        let requestFinished = expectation(description: "Finished get request")
        let url = "https://test.nexmoinc.net/sdk/token/json"
        var builder = HttpRequestBuilder(url)
        var request : HttpRequest?
        XCTAssertNotNil(builder,
                        "RequestBuilder with URL [ \(url) ] is nil");
        
        builder = builder!.setCharset(String.Encoding.utf8)
        XCTAssertNotNil(builder, "builder nil after 'setCharset'")
        
        
        builder = builder!.setContentType(HttpRequest.ContentType.text)
        XCTAssertNotNil(builder, "builder nil after 'setContentType'")
        
        builder = builder!.setPost(false)
        XCTAssertNotNil(builder, "builder nil after 'setPost'")
        
        builder = builder!.setParams(["test_param_1": "1234",
                                     "test_param_2" : "testing one, two, three"])
        XCTAssertNotNil(builder, "builder nil after 'setParams'")
        
        request = builder!.build()
        XCTAssertNotNil(request, "builder produced nil HttpRequest object")
        
        request!.execute() { (response: HttpResponse?, error: NSError?) in
            if (error != nil) {
                XCTFail("testHttpGetRequest failed with error: \(error!.localizedDescription)")
                requestFinished.fulfill()
                return
            }
                
            XCTAssertEqual(200, response!.statusCode, "HttpRequest returned status code [ \(response!.statusCode)")
            VerifyIosSdkTests.Log.info("Response body = \(response!.body)")
            
            requestFinished.fulfill()
        }
        
        self.waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    /** Test HttpBuilder, HttpRequest and HttpResponse classes in POST request
    */
    func testHttpPostRequest() {
        let requestFinished = expectation(description: "Finished http request")
        let url = "http://requestb.in/api/v1/bins"
        //let url = "http://www.example.com"
        var builder = HttpRequestBuilder(url)
        var request : HttpRequest?
        
        XCTAssertNotNil(builder,
                        "RequestBuilder with URL [ \(url) ] is nil");
        
        builder = builder!.setCharset(String.Encoding.utf8)
        XCTAssertNotNil(builder, "builder nil after 'setCharset'")
        
        
        builder = builder!.setContentType(HttpRequest.ContentType.form)
        XCTAssertNotNil(builder, "builder nil after 'setContentType'")
        
        builder = builder!.setPost(true)
        XCTAssertNotNil(builder, "builder nil after 'setPost'")
        
        builder = builder!.setParams(["private": "false"])
        XCTAssertNotNil(builder, "builder nil after 'setParams'")
        
        request = builder!.build()
        XCTAssertNotNil(request, "builder produced nil HttpRequest object")
        
        request!.execute() { (response: HttpResponse?, error: NSError?) in
            if (error != nil) {
                XCTFail("testHttpPostRequest failed with error \(error!.localizedDescription)")
                requestFinished.fulfill()
                return
            }

            XCTAssertEqual(200, response!.statusCode, "HttpRequest returned status code [ \(response!.statusCode)")
            VerifyIosSdkTests.Log.info("Response body = \(response!.body)")
            
            if let body = response!.body,
            let json = (try? JSONSerialization.jsonObject(with: body.data(using: .utf8, allowLossyConversion: false)!, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: AnyObject] {
                
                if let result = json["private"] as? Bool {
                    XCTAssertFalse(result, "Private variable came back as \(result)")
                } else {
                    XCTFail("couldn't find 'private' key in returned json")
                }
            }
            
            requestFinished.fulfill()
        }
        
        self.waitForExpectations(timeout: 10.0, handler: nil)
    }

    /** Test retrieving the device IP address
    */
    func testGetIpAddress() {
        guard let url = "www.example.com".cString(using: .utf8) else { return XCTFail("") }
        
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, url) else {
            XCTFail("couldn't create reachability object")
            return
        }
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability, &flags)
        let canReach = flags.contains(SCNetworkReachabilityFlags.reachable) &&
                        !flags.contains(SCNetworkReachabilityFlags.connectionRequired)
        
        XCTAssertTrue(canReach, "No internet connection detected")
        VerifyIosSdkTests.Log.info("Successfully connected to internet")
        let ipAddress = SDKDeviceProperties.sharedInstance().getIpAddress()
        XCTAssertNotNil(ipAddress, "IP Address returned null")
        VerifyIosSdkTests.Log.info("IP Address returned = \(ipAddress)")
    }
    
    /** Test retrieving or creating the unique device identifier */
    func testGetUid() {
        let uid = SDKDeviceProperties.sharedInstance().getUniqueDeviceIdentifierAsString()
        XCTAssertNotNil(uid, "Uid returned was nil!")
        VerifyIosSdkTests.Log.info("Returned UID = \(uid)")
    }

    func testVerifySuccess() {
        NexmoClient.start(applicationId: Config.APP_ID, sharedSecretKey: Config.SECRET_KEY)
        
        let verifySucceeded = expectation(description: "Verify succeeded!")
        VerifyClient.getVerifiedUser(countryCode: "GB", phoneNumber: VerifyIosSdkTests.TEST_NUMBER,
            onVerifyInProgress: {
                print("\n\n pin code > ", terminator: "")
                let stdin = FileHandle.standardInput
                let input = NSString(data: stdin.availableData, encoding: String.Encoding.utf8.rawValue)
                if let input = input?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) as String? {
                    VerifyClient.checkPinCode(input)
                }
            },
            onUserVerified: {
                verifySucceeded.fulfill()
            },
            onError: { error in
                XCTFail("Verification failed with error [ \(error.rawValue) ]")
            })
        
        waitForExpectations(timeout: 60, handler: nil)
    }
    
    func testOneShotVerification() {
        NexmoClient.start(applicationId: Config.APP_ID, sharedSecretKey: Config.SECRET_KEY)
        
        let verifySucceeded = expectation(description: "Verify succeeded!")
        VerifyClient.verifyStandalone(countryCode: "GB", phoneNumber: VerifyIosSdkTests.TEST_NUMBER,
            onVerifyInProgress: {
                print("\n\n pin code > ", terminator: "")
                let stdin = FileHandle.standardInput
                let input = NSString(data: stdin.availableData, encoding: String.Encoding.utf8.rawValue)
                if let input = input?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) as String? {
                    VerifyClient.checkPinCode(input)
                }
            },
            onUserVerified: {
                verifySucceeded.fulfill()
            },
            onError: { error in
                XCTFail("Verification failed with error [ \(error.rawValue) ]")
            })
        
        waitForExpectations(timeout: 60, handler: nil)
    }
    
    func testVerifyAlreadyPending() {
        NexmoClient.start(applicationId: VerifyIosSdkTests.APP_KEY, sharedSecretKey: VerifyIosSdkTests.APP_SECRET)
        
        let verifyPending = expectation(description: "Verification pending")
        let verificationAlreadyStarted = expectation(description: "Verification already started")
        VerifyClient.getVerifiedUser(countryCode: "GB", phoneNumber: VerifyIosSdkTests.TEST_NUMBER,
            onVerifyInProgress: {
                verifyPending.fulfill()
                VerifyClient.getVerifiedUser(countryCode: "GB", phoneNumber: VerifyIosSdkTests.TEST_NUMBER,
                    onVerifyInProgress: {
                        XCTFail("Verification should be recognised as already in progress!")
                    },
                    onUserVerified: {
                        XCTFail("Verification hasn't actually been verified!")
                    },
                    onError: { error in
                        if (error == .verificationAlreadyStarted) {
                            verificationAlreadyStarted.fulfill()
                        }
                    })
            },
            onUserVerified: {
                XCTFail("User already verified! User needs to be new...")
            },
            onError: { error in
                XCTFail("Failed with error code \(error.rawValue)")
            })
        
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testGetToken() {
        var failed = false
        let requestSigner = SDKRequestSigner()
        let serviceExecutor = ServiceExecutor(requestSigner: requestSigner, deviceProperties: SDKDeviceProperties())
        for _ in 1...10 {
            let tokenRequestFinished = expectation(description: "get token request finished")
            serviceExecutor.getToken(VerifyIosSdkTests.nexmoClient) { (response: TokenResponse?, error: NSError?) in
                if let _ = error {
                    failed = true
                    XCTFail("error came back non nil")
                }
                if (response == nil) {
                    failed = true
                    XCTFail("Response object was nil!")
                    return
                }
                if (!response!.isSignatureValid(VerifyIosSdkTests.nexmoClient)) {
                    failed = true
                    XCTFail("Returned message signature did not match generated!")
                }
                
                if (response!.token == nil) {
                    failed = true
                    XCTFail("Token was nil")
                }
                VerifyIosSdkTests.Log.info("response Message = \(response!.resultMessage)")
                tokenRequestFinished.fulfill()
            }
            
            waitForExpectations(timeout: 10.0, handler: nil)
            if (failed) {
                break
            }
            sleep(1)
        }
    }
    
    func testVerifyClientPerformsCancelRequest() {
        NexmoClient.start(applicationId: VerifyIosSdkTests.APP_KEY, sharedSecretKey: VerifyIosSdkTests.APP_SECRET)
        let cancelExpectation = expectation(description: "received cancel response")
        VerifyClient.sharedInstance.getVerifiedUser(countryCode: nil, phoneNumber: VerifyIosSdkTests.TEST_NUMBER, onVerifyInProgress: {
                sleep(30)
                VerifyClient.cancelVerification() { error in
                    XCTAssertNil(error, "Cancel request returned error: \(error)")
                    cancelExpectation.fulfill()
                }
            }, onUserVerified: {
                XCTFail("User shouldn't be verified")
            }, onError: { error in
                XCTFail("Failed with some error \(error.rawValue)")
            }
        )
        waitForExpectations(timeout: 60, handler: nil)
    }
    
    func testVerifyClientPerformsLogoutRequest() {
        NexmoClient.start(applicationId: VerifyIosSdkTests.APP_KEY, sharedSecretKey: VerifyIosSdkTests.APP_SECRET)
        let logoutExpectation = expectation(description: "Received logout response")
        VerifyClient.logoutUser(countryCode: VerifyIosSdkTests.TEST_COUNTRY_CODE, number: VerifyIosSdkTests.TEST_NUMBER) { error in
            if let _ = error {
                print("something went wrong")
            }
            
            logoutExpectation.fulfill()
        }
        waitForExpectations(timeout: 30, handler: nil)
    }

    func testVerifyClientPerformsTriggerNextEventRequest() {
        NexmoClient.start(applicationId: VerifyIosSdkTests.APP_KEY, sharedSecretKey: VerifyIosSdkTests.APP_SECRET)
        let nextEventExpetation = expectation(description: "trigger next event callback")
        VerifyClient.getVerifiedUser(countryCode: nil, phoneNumber: VerifyIosSdkTests.TEST_NUMBER, onVerifyInProgress: {
                VerifyClient.triggerNextEvent() { error in
                    XCTAssertNil(error, "triggerNextEvent request returned error: \(error)")
                    nextEventExpetation.fulfill()
                }
            }, onUserVerified: {
                XCTFail("User shouldn't be verified")
            }, onError: { error in
                XCTFail("Failed with some error \(error.rawValue)")
            }
        )
        
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testVerifyClientPerformsTriggerSearchRequest() {
        NexmoClient.start(applicationId: VerifyIosSdkTests.APP_KEY, sharedSecretKey: VerifyIosSdkTests.APP_SECRET)
        let searchExpectation = expectation(description: "search callback")
        VerifyClient.getUserStatus(countryCode: VerifyIosSdkTests.TEST_COUNTRY_CODE, number: VerifyIosSdkTests.TEST_NUMBER) { status, error in
            XCTAssertNil(error, "search request returned error: \(error)")
            if let status = status {
                print("search returned user status: \(status)")
            }
            searchExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 30, handler: nil)
    }

    func testCheckServiceAddsCountryCode() {
        NexmoClient.start(applicationId: VerifyIosSdkTests.APP_KEY, sharedSecretKey: VerifyIosSdkTests.APP_SECRET)

        let checkExpectation = expectation(description: "check request finished")
        VerifyClient.checkPinCode("1234", countryCode: "GB", number: VerifyIosSdkTests.TEST_NUMBER,
        onUserVerified: {
            checkExpectation.fulfill()
            print("verified")
        }, onError: { error in
            checkExpectation.fulfill()
            print("error occurred!")
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
}
