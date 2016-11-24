//
//  ServiceExecutorTests.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 31/08/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation
import XCTest
@testable import NexmoVerify

class ServiceExecutorTests : XCTestCase {
    
    class ServiceExecutorTokenServiceMock : ServiceExecutor {
        var getTokenCalled = false
        override func getToken(_ nexmoClient: NexmoClient, onResponse: @escaping (_ response: TokenResponse?, _ error: NSError?) -> ()) {
            getTokenCalled = true
        }
    }
    
    /*func testPerformHttpRequestForService {
        // no idea how to do this
    }*/
    
    func testPerformHttpRequestCallsTokenServiceWhenNoToken() {
        class ServiceExecutorMock : ServiceExecutor {
            var startCalled = true
            override func getToken(_ nexmoClient: NexmoClient, onResponse: @escaping (_ response: TokenResponse?, _ error: NSError?) -> ()) {
                startCalled = true
            }
        }
        
        let requestSigner = RequestSignerMock()
        
        let nexmoClient = NexmoClient.sharedInstance
        nexmoClient.applicationId = VerifyIosSdkTests.APP_KEY
        nexmoClient.sharedSecretKey = VerifyIosSdkTests.APP_SECRET
        nexmoClient.sdkToken = VerifyIosSdkTests.TEST_TOKEN
        
        let deviceProperties = DevicePropertiesMock()
        let serviceExecutor = ServiceExecutorMock(requestSigner: requestSigner, deviceProperties: deviceProperties)
        let responseFactory = BaseResponseFactoryMock()
        let path = "some_path"
        let timestamp = Date()
        let params : [String : String] = [:]
        
        serviceExecutor.performHttpRequestForService(responseFactory, nexmoClient: nexmoClient, path: path, timestamp: timestamp, params: params, isPost: false) { response, error in
            // nothing to do, stub
        }
        
        XCTAssert(serviceExecutor.startCalled, "Token service was not called")
    }
    
    func testServiceExecutorAppendsParamsToUrl() {
        let params = ["key1" : "value1",
                      "key2" : "value2",
                      "key3" : "value3"]
        
        let path = "mypath"
        let timestamp = Date()
        let requestSigner = RequestSignerMock()
        let deviceProperties = DevicePropertiesMock()
        let serviceExecutor = ServiceExecutor(requestSigner: requestSigner, deviceProperties: deviceProperties)
        let request = serviceExecutor.generateHttpRequestForService(VerifyIosSdkTests.nexmoClient, path: path, timestamp: timestamp, params: params, isPost: false)
        XCTAssertNotNil(request, "Request did not generate the expected URL")
        let url = request!.url.absoluteString
        for (key,value) in params {
            let range = url.range(of: "\(key)=\(value)")
            if (range == nil) {
                XCTFail("could not find [ \(key)=\(value) ] in query string [ \(url) ]")
            }
        }
    }
    
    func testServiceExecutorAppendsTimestampToUrl() {
        let path = "mypath"
        let timestamp = Date()
        let requestSigner = RequestSignerMock()
        let deviceProperties = DevicePropertiesMock()
        let serviceExecutor = ServiceExecutor(requestSigner: requestSigner, deviceProperties: deviceProperties)
        let request = serviceExecutor.generateHttpRequestForService(VerifyIosSdkTests.nexmoClient, path: path, timestamp: timestamp, params: nil, isPost: false)
        if (request == nil) {
            XCTFail("request came back nil!")
            return
        }
        let url = request!.url.absoluteString
        let timestampParam = "\(ServiceExecutor.PARAM_TIMESTAMP)=\(Int(timestamp.timeIntervalSince1970))"
        let range = url.range(of: timestampParam)
        if (range == nil) {
            XCTFail("could not find [ \(timestampParam) ] in [ \(url) ]")
        }
    }
    
    func testServiceExecutorAppendsSignatureToUrl() {
        let path = "mypath"
        let timestamp = Date()
        let secretKey = "123"
        let requestSigner = RequestSignerMock()
        let deviceProperties = DevicePropertiesMock()
        let serviceExecutor = ServiceExecutor(requestSigner: requestSigner, deviceProperties: deviceProperties)
        let request = serviceExecutor.generateHttpRequestForService(VerifyIosSdkTests.nexmoClient, path: path, timestamp: timestamp, params: nil, isPost: false)
        if (request == nil) {
            XCTFail("request came back nil!")
            return
        }
        let url = request!.url.absoluteString
        
        guard let signature = requestSigner.generateSignature(withParams: [:], sharedSecretKey: secretKey)
            else { return XCTFail("") }
        
        let signatureParam = "\(ServiceExecutor.PARAM_SIGNATURE)=\(signature)"
        
        let range = url.range(of: signatureParam)
        
        if (range == nil) {
            XCTFail("could not find [ \(signatureParam) ] in [ \(url) ]")
        }
    }
    
    func testServiceExecutorAppendsTokenToUrl() {
        let nexmoClient = NexmoClient.sharedInstance
        nexmoClient.applicationId = VerifyIosSdkTests.APP_KEY
        nexmoClient.sharedSecretKey = VerifyIosSdkTests.APP_SECRET
        nexmoClient.sdkToken = VerifyIosSdkTests.TEST_TOKEN
        
        let requestSigner = RequestSignerMock()
        let tokenParam = "\(ServiceExecutor.PARAM_TOKEN)=\(VerifyIosSdkTests.TEST_TOKEN)"
        let timestamp = Date()
        let path = "some_path"
        let deviceProperties = DevicePropertiesMock()
        let serviceExecutor = ServiceExecutor(requestSigner: requestSigner, deviceProperties: deviceProperties)
        let request = serviceExecutor.generateHttpRequestForService(nexmoClient, path: path, timestamp: timestamp, params: nil, isPost: false)
        if (request == nil) {
            XCTFail("request came back nil!")
            return
        }
        let url = request!.url.absoluteString
        let range = url.range(of: tokenParam)
        if (range == nil) {
            XCTFail("could not find [ \(tokenParam) ] in [ \(url) ]")
        }
    }
    
    func testEmptyParametersRemovedFromQueryStringInServiceRequest() {
        if let httpRequest = ServiceExecutor.sharedInstance.generateHttpRequestForService(
            VerifyIosSdkTests.nexmoClient, path: "http://www.example.com", timestamp: Date(),
            params: ["param_1" : "param_1_val",
                     "param_2" : "param_2_val",
                     "null_var" : ""],
            isPost: false) {
            let queryString = httpRequest.url.absoluteString
            print("got back url: \(queryString)")
            XCTAssert(queryString.range(of: "null_var") == nil, "null_var still found in query string!")
        } else {
            XCTFail("Failed to create httpRequest!")
        }
    }
    
    func testGenerateHttpRequestCallsGenerateSignatureWithParams() {
        let requestSigner = RequestSignerMock()
        let deviceProperties = DevicePropertiesMock()
        let serviceExecutor = ServiceExecutor(requestSigner: requestSigner, deviceProperties: deviceProperties)
        let params = ["key1" : "value1",
                      "key2" : "value2",
                      "key3" : "value3"]
            
        _ = serviceExecutor.generateHttpRequestForService(VerifyIosSdkTests.nexmoClient, path: "some_path", timestamp: Date(), params: params, isPost: false)
        XCTAssert(requestSigner.generateSignatureWithParamsCalled, "generateHttpRequest did not call GenerateSignatureWithParams");
    }
    
    func testPerformHttpRequestForServiceCallsTokenServiceWhenNoToken() {
        let exp = expectation(description: "")
        
        let serviceExecutor = ServiceExecutorTokenServiceMock()
        let responseFactory = ResponseFactoryMock()

        let nexmoClient = NexmoClient.sharedInstance
        nexmoClient.applicationId = VerifyIosSdkTests.APP_KEY
        nexmoClient.sharedSecretKey = VerifyIosSdkTests.APP_SECRET
        
        let timestamp = Date()
        let path = "some_path"
        let params : [String : String] = [:]
        serviceExecutor.performHttpRequestForService(responseFactory, nexmoClient: nexmoClient, path: path, timestamp: timestamp, params: params, isPost: true) { response, error in
            
            XCTAssert(serviceExecutor.getTokenCalled, "Token service was never called")
            exp.fulfill()
        }
    }
    
    func testPerformHttpRequestForServiceDoesntCallTokenServiceWhenToken() {
        let serviceExecutor = ServiceExecutorTokenServiceMock()
        let responseFactory = ResponseFactoryMock()
        
        let nexmoClient = NexmoClient.sharedInstance
        nexmoClient.applicationId = VerifyIosSdkTests.APP_KEY
        nexmoClient.sharedSecretKey = VerifyIosSdkTests.APP_SECRET
        nexmoClient.sdkToken = VerifyIosSdkTests.TEST_TOKEN
        
        let timestamp = Date()
        let path = "some_path"
        let params : [String : String] = [:]
        serviceExecutor.performHttpRequestForService(responseFactory, nexmoClient: nexmoClient, path: path, timestamp: timestamp, params: params, isPost: true) { response, error in
        
        }
        XCTAssertFalse(serviceExecutor.getTokenCalled, "Token service was called")
    }
    
    func testPerformHttpRequestForServiceCallsTokenServiceWhenInvalidToken() {
        class HttpInvalidTokenRequest : HttpRequest {
            init() {
                super.init(request: URLRequest(url: Config.ENDPOINT_PRODUCTION_URL), encoding: String.Encoding.utf8)
            }
            
            override func execute(_ completionHandler: @escaping (_ httpResponse: HttpResponse?, _ error: NSError?) -> Void) {
                let timestamp = "\(Int(Date().timeIntervalSince1970))"
                let resultCode = ResponseCode.Code.invalidToken.rawValue
                let resultMessage = "Invalid Token"
                let json_body: [String : Any] = [ServiceExecutor.PARAM_RESULT_CODE : resultCode,
                                 ServiceExecutor.PARAM_RESULT_MESSAGE : resultMessage,
                                 ServiceExecutor.PARAM_TIMESTAMP : timestamp]
                let messageBody = try! JSONSerialization.data(withJSONObject: json_body, options: [])
                
                let httpResponse = HttpResponse(data: messageBody, response: HTTPURLResponse(url: Config.ENDPOINT_PRODUCTION_URL, statusCode: 0, httpVersion: "1.1", headerFields: [:])!, encoding: String.Encoding.utf8, timestamp: timestamp)
                
                completionHandler(httpResponse, nil)
            }
        }
        
        class HttpRequestBuilderInvalidToken : HttpRequestBuilder {
        
            init() {
                super.init(Config.ENDPOINT_PRODUCTION_URL)
            }
            
            override func build() -> HttpRequest? {
                return HttpInvalidTokenRequest()
            }
        }

        class ServiceExecutorInvalidTokenMock : ServiceExecutor {
            var getTokenCalled = false
            override func getToken(_ nexmoClient: NexmoClient, onResponse: @escaping (_ response: TokenResponse?, _ error: NSError?) -> ()) {
                getTokenCalled = true
            }
            
            override func makeHttpRequestBuilder(_ url: String) -> HttpRequestBuilder? {
                return HttpRequestBuilderInvalidToken()
            }
        }
        
        class ResponseFactoryFailMock : ResponseFactory {
            func createResponse(_ httpResponse: HttpResponse) -> BaseResponse? {
                return BaseResponse(signature: nil, resultCode: 0, resultMessage: "", timestamp: "", messageBody: "")
            }
        }
        
        let serviceExecutor = ServiceExecutorInvalidTokenMock()
        let responseFactory = ResponseFactoryFailMock()
        let nexmoClient = NexmoClient.sharedInstance
        nexmoClient.applicationId = VerifyIosSdkTests.APP_KEY
        nexmoClient.sharedSecretKey = VerifyIosSdkTests.APP_SECRET

        nexmoClient.sdkToken = VerifyIosSdkTests.TEST_TOKEN
        let path = "some_path"
        let timestamp = Date()
        let params : [String : String] = [:]
        serviceExecutor.performHttpRequestForService(responseFactory, nexmoClient: nexmoClient, path: path, timestamp: timestamp, params: params, isPost: false) { response, error in
        
        }
        XCTAssert(serviceExecutor.getTokenCalled, "Token service was not called")
    }
    
    func testPerformHttpRequestForServiceInvokesCallbackOnSuccess() {
        
        class SuccessResponseFactoryMock : ResponseFactory {
            func createResponse(_ httpResponse: HttpResponse) -> BaseResponse? {
                if (httpResponse.statusCode == ResponseCode.Code.resultCodeOK.rawValue) {
                    return MockResponse()
                }
                
                return nil
            }
        }
        
        class SuccessHttpRequest : HttpRequest {
            init() {
                super.init(request: URLRequest(url: Config.ENDPOINT_PRODUCTION_URL), encoding: String.Encoding.utf8)
            }
            
            override func execute(_ completionHandler: @escaping (_ httpResponse: HttpResponse?, _ error: NSError?) -> Void) {
                let timestamp = "\(Int(Date().timeIntervalSince1970))"
                let resultCode = ResponseCode.Code.resultCodeOK.rawValue
                let resultMessage = "some great success!"
                let json_body: [String : Any] = [ServiceExecutor.PARAM_RESULT_CODE : resultCode,
                                 ServiceExecutor.PARAM_RESULT_MESSAGE : resultMessage,
                                 ServiceExecutor.PARAM_TIMESTAMP : timestamp]
                let messageBody = try! JSONSerialization.data(withJSONObject: json_body, options: [])
                
                let httpResponse = HttpResponse(data: messageBody, response: HTTPURLResponse(url: Config.ENDPOINT_PRODUCTION_URL, statusCode: 0, httpVersion: "1.1", headerFields: [:])!, encoding: String.Encoding.utf8, timestamp: timestamp)
                
                completionHandler(httpResponse, nil)
            }
        }
        
        class SuccessHttpRequestBuilder : HttpRequestBuilder {
        
            init() {
                super.init(Config.ENDPOINT_PRODUCTION_URL)
            }
            
            override func  build() -> HttpRequest? {
                return SuccessHttpRequest()
            }
        }
        
        class ServiceExecutorSuccessMock : ServiceExecutor {
            override func  makeHttpRequestBuilder(_ url: String) -> HttpRequestBuilder? {
                return SuccessHttpRequestBuilder()
            }
        }
        
        var callbackCalled = false
        let serviceExecutor = ServiceExecutorSuccessMock()
        let responseFactory = SuccessResponseFactoryMock()
        let path = "some_path"
        let timestamp = Date()
        let params : [String : String] = [:]
        let nexmoClientSdkToken = NexmoClient.sharedInstance
        nexmoClientSdkToken.applicationId = VerifyIosSdkTests.APP_KEY
        nexmoClientSdkToken.sharedSecretKey = VerifyIosSdkTests.APP_SECRET
        nexmoClientSdkToken.sdkToken = VerifyIosSdkTests.TEST_TOKEN
        
        serviceExecutor.performHttpRequestForService(responseFactory, nexmoClient: nexmoClientSdkToken, path: path, timestamp: timestamp, params: params, isPost: false) { response, error in
            if let _ = response {
                callbackCalled = true
            }
        }
        XCTAssert(callbackCalled, "callback wasn't called")
    }
    
    func testPerformHttpRequestForServiceInvokesCallbackOnError() {
        class FailureResponseFactoryMock : ResponseFactory {
            func createResponse(_ httpResponse: HttpResponse) -> BaseResponse? {
                return nil
            }
        }
        
        class FailureHttpRequest : HttpRequest {
            init() {
                super.init(request: URLRequest(url: Config.ENDPOINT_PRODUCTION_URL), encoding: String.Encoding.utf8)
            }
            
            override func execute(_ completionHandler: @escaping (_ httpResponse: HttpResponse?, _ error: NSError?) -> Void) {
                let timestamp = "\(Int(Date().timeIntervalSince1970))"
                let resultCode = ResponseCode.Code.invalidCode.rawValue
                let resultMessage = "some generic error..."
                let json_body: [String : Any] = [ServiceExecutor.PARAM_RESULT_CODE : resultCode,
                                 ServiceExecutor.PARAM_RESULT_MESSAGE : resultMessage,
                                 ServiceExecutor.PARAM_TIMESTAMP : timestamp]
                let messageBody = try! JSONSerialization.data(withJSONObject: json_body, options: [])
                
                let httpResponse = HttpResponse(data: messageBody, response: HTTPURLResponse(url: Config.ENDPOINT_PRODUCTION_URL, statusCode: 0, httpVersion: "1.1", headerFields: [:])!, encoding: String.Encoding.utf8, timestamp: timestamp)
                
                completionHandler(httpResponse, nil)
            }
        }
        
        class FailureHttpRequestBuilder : HttpRequestBuilder {

            init() {
                super.init(Config.ENDPOINT_PRODUCTION_URL)
            }

            override func  build() -> HttpRequest? {
                return FailureHttpRequest()
            }
        }

        class ServiceExecutorFailureMock : ServiceExecutor {
            override func  makeHttpRequestBuilder(_ url: String) -> HttpRequestBuilder? {
                return FailureHttpRequestBuilder()
            }
        }

        var callbackCalled = false
        let serviceExecutor = ServiceExecutorFailureMock()
        let responseFactory = FailureResponseFactoryMock()
        let path = "some_path"
        let timestamp = Date()
        let params : [String : String] = [:]
        
        let nexmoClientSdkToken = NexmoClient.sharedInstance
        nexmoClientSdkToken.applicationId = VerifyIosSdkTests.APP_KEY
        nexmoClientSdkToken.sharedSecretKey = VerifyIosSdkTests.APP_SECRET
        
        nexmoClientSdkToken.sdkToken = VerifyIosSdkTests.TEST_TOKEN
        serviceExecutor.performHttpRequestForService(responseFactory, nexmoClient: nexmoClientSdkToken, path: path, timestamp: timestamp, params: params, isPost: false) { response, error in
            if let _ = error {
                callbackCalled = true
            }
        }
        XCTAssert(callbackCalled, "callback with error not called")
    }

    func testServiceExecutorCallsErrorWhenCantRequestToken() {
        class ServiceExecutorBadTokenMock : ServiceExecutor {
            override fileprivate func getToken(_ nexmoClient: NexmoClient, onResponse: @escaping (_ response: TokenResponse?, _ error: NSError?) -> ()) {
                onResponse(TokenResponse(token: nil, signature: nil, resultCode: 56567, resultMessage: "no_token", timestamp: "some_timestamp_wont_be_read", messageBody: "some_body_wont_be_read"), nil)
            }
        }
        var callbackCalled = false
        let requestSigner = RequestSignerMock()
        let deviceProperties = DevicePropertiesMock()
        let nexmoClient = VerifyIosSdkTests.nexmoClient
        let responseFactory = ResponseFactoryMock()
        let path = "path"
        let timestamp = Date()
        let params = [ String : String ]()
        let serviceExecutor = ServiceExecutorBadTokenMock(requestSigner: requestSigner, deviceProperties: deviceProperties)
        serviceExecutor.performHttpRequestForService(responseFactory, nexmoClient: nexmoClient, path: path, timestamp: timestamp, params: params) { _, error in
            guard let error = error else {
                XCTFail("didn't receive an error!")
                return
            }

            if (error.code == 56567) {
                callbackCalled = true
            }
        }
        XCTAssert(callbackCalled, "Callback not called with the correct error")
    }
}
