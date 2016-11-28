//
//  ServiceExecutor.swift
//  NexmoVerify
//
//  Created by Dorian Peake on 19/05/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

import Foundation

/**
    Base class for all nexmo services, which contains a lot of helper methods for
    creating requests, such as generating signatures.
*/

class ServiceExecutor {

    private enum ErrorCode : Int {
        case cannotGenerateSignature = 1
        case cannotParseResponse
        case cannotBuildHttpRequest
        case cannotGetIPAddress
    }
        
    /// Path for token sdk service
    static let METHOD_TOKEN = "token/json"
    
    /// Path for verify sdk service
    static let METHOD_VERIFY = "verify/json"
    
    /// Path for check sdk service
    static let METHOD_CHECK = "verify/check/json"
    
    /// Path for control sdk service
    static let METHOD_CONTROL = "verify/control/json"
    
    /// Path for logout sdk service
    static let METHOD_LOGOUT = "verify/logout/json"
    
    /// Path for search sdk service
    static let METHOD_SEARCH = "verify/search/json"
    
    /// Path for one shot verification sdk service
    static let METHOD_ONESHOT_VERIFY = "verify/oneshot/json"
    
    /// Path for one shot check sdk service
    static let METHOD_ONESHOT_CHECK = "verify/oneshot/json"

    /** Custom HTTP header fields. */
    static let OS_FAMILY = "X-NEXMO-SDK-OS-FAMILY"
    static let OS_REVISION = "X-NEXMO-SDK-OS-REVISION"
    static let SDK_REVISION = "X-NEXMO-SDK-REVISION"
    static let RESPONSE_SIG = "X-NEXMO-RESPONSE-SIGNATURE"

    /// Push Notification
    static let PARAM_PUSH_TOKEN = "push_token"

    /// Device ID parameter
    static let PARAM_DEVICE_ID = "device_id"
    
    /// Source IP address parameter
    static let PARAM_SOURCE_IP = "source_ip_address"
    
    /// Application Key parameter
    static let PARAM_APP_ID = "app_id"
    
    /// Phone number/msisdn field
    static let PARAM_NUMBER = "number"
    
    /// iso-3166 alpha-2 country code field
    static let PARAM_COUNTRY_CODE = "country"
    
    /// timestap (in seconds since Unix epoch) field
    static let PARAM_TIMESTAMP = "timestamp"
    
    /// IETF Lanugate tag parameter
    static let PARAM_LANGUAGE = "lg"
    
    /// Signature parameter
    static let PARAM_SIGNATURE = "sig"
    
    /// Verify token parameter
    static let PARAM_TOKEN = "token"
    
    /// Pin code parameter
    static let PARAM_CODE = "code"
    
    /// Command (for control service) parameter
    static let PARAM_COMMAND = "cmd"

    /// Result code key for json object
    static let PARAM_RESULT_CODE = "result_code"
    
    /// result message key for json object
    static let PARAM_RESULT_MESSAGE = "result_message"
    
    /// user status key for json object
    static let PARAM_RESULT_USER_STATUS = "user_status"
    
    /// neccessary headers for all service requests
    static let headers = [OS_FAMILY : Config.osFamily,
                          OS_REVISION : Config.osRevision,
                          SDK_REVISION : Config.sdkVersion]
    
    /// The current class logger
    static fileprivate let Log = Logger(String(describing: ServiceExecutor.self))
    
    fileprivate var requestSigner : RequestSigner
    fileprivate var deviceProperties : DevicePropertyAccessor
    fileprivate static var instance : ServiceExecutor?
    static var sharedInstance : ServiceExecutor {
        get {
            if let sharedInstance = ServiceExecutor.instance {
                return sharedInstance
            }
            
            ServiceExecutor.instance = ServiceExecutor()
            return ServiceExecutor.instance!
        }
    }
    
    init() {
        requestSigner = SDKRequestSigner.sharedInstance()
        deviceProperties = SDKDeviceProperties.sharedInstance()
    }
    
    init(requestSigner: RequestSigner, deviceProperties: DevicePropertyAccessor) {
        self.requestSigner = requestSigner
        self.deviceProperties = deviceProperties
    }
    
    /**
        Create HTTP Request for Nexmo service with parameters
        
        - parameter path: the url path of the service
        
        - parameter params: query string parameters that will be sent to the service
        
        - parameter isPost: should be POST or GET request
        
        - returns: HttpRequest Object which is constructed to call the service
    */
    func generateHttpRequestForService(_ nexmoClient: NexmoClient, path: String, timestamp: Date, params: [String:String]?, isPost: Bool = false) -> HttpRequest? {
        var mutableParams : [String : String]
        if let params = params {
            mutableParams = params
            
            // remove empty values from query parameters
            for (key, value) in params {
                if (value.characters.count == 0) {
                    mutableParams[key] = nil
                }
            }
        } else {
            mutableParams = [:]
        }
        
        let timestamp = "\(Int(timestamp.timeIntervalSince1970))"
        if (mutableParams.count != 0) {
            mutableParams[ServiceExecutor.PARAM_APP_ID] = nexmoClient.applicationId
        }
        mutableParams[ServiceExecutor.PARAM_TIMESTAMP] = timestamp
        if let token = nexmoClient.sdkToken {
            mutableParams[ServiceExecutor.PARAM_TOKEN] = token
        } else {
            // TODO: need to acquire new token here... but for now do nothing
            //return nil
        }
        if let signature = requestSigner.generateSignature(withParams: mutableParams, sharedSecretKey: nexmoClient.sharedSecretKey) {
            mutableParams[ServiceExecutor.PARAM_SIGNATURE] = signature
        } else {
            ServiceExecutor.Log.error("unable to generate signature")
            return nil
        }
        
        let requestBuilder = HttpRequestBuilder("\(Config.ENDPOINT_PRODUCTION)/\(path)")?
                          .setCharset(String.Encoding.utf8)
                          .setContentType(HttpRequest.ContentType.text)
                          .setHeaders(ServiceExecutor.headers)
                          .setPost(isPost)
                          
        if (mutableParams.count != 0) {
            requestBuilder?.setParams(mutableParams)
        }
        return requestBuilder?.build()
    }
    
    fileprivate func redispatchRequest(_ responseFactory: ResponseFactory, nexmoClient: NexmoClient, path: String, timestamp: Date, params: [String : String]?, isPost : Bool = false, callback: @escaping (_ response: BaseResponse?, _ error: NSError?) -> ()) {
        getToken(nexmoClient) { response, error in
            if let error = error {
                callback(nil, error)
            } else if (response!.resultCode == ResponseCode.Code.resultCodeOK.rawValue) {
                nexmoClient.sdkToken = response!.token!
                DispatchQueue.global().async {
                    self.performHttpRequestForService(responseFactory, nexmoClient: nexmoClient, path: path, timestamp: timestamp, params: params, isPost: isPost, callback: callback)
                }
            } else {
                let error = NSError(domain: "ServiceExecutor", code: response!.resultCode, userInfo: [NSLocalizedDescriptionKey : "Failed to get token with error \(response!.resultCode): \(response!.resultMessage)"])
                callback(nil, error)
            }
        }
    }
    
    func performHttpRequestForService(_ responseFactory: ResponseFactory, nexmoClient: NexmoClient, path: String, timestamp: Date, params: [String : String]?, isPost : Bool = false, callback: @escaping (_ response: BaseResponse?, _ error: NSError?) -> ()) {
        
        // if no token, then get a new one and restart the request
        if  (nexmoClient.sdkToken == nil) {
            redispatchRequest(responseFactory, nexmoClient: nexmoClient, path: path, timestamp: timestamp, params: params, isPost: isPost, callback: callback)
            return
        }
        
        let token = nexmoClient.sdkToken!
        var mutableParams : [String : String]
        if let params = params {
            mutableParams = params
            
            // remove empty values from query parameters
            for (key, value) in params {
                if (value.characters.count == 0) {
                    mutableParams[key] = nil
                }
            }
        } else {
            mutableParams = [:]
        }
        
        let timestampString = "\(Int(timestamp.timeIntervalSince1970))"
        if (mutableParams.count != 0) {
            mutableParams[ServiceExecutor.PARAM_APP_ID] = nexmoClient.applicationId
        }
        mutableParams[ServiceExecutor.PARAM_TIMESTAMP] = timestampString
        mutableParams[ServiceExecutor.PARAM_TOKEN] = token
        if let signature = requestSigner.generateSignature(withParams: mutableParams, sharedSecretKey: nexmoClient.sharedSecretKey) {
            mutableParams[ServiceExecutor.PARAM_SIGNATURE] = signature
        } else {
            ServiceExecutor.Log.error("unable to generate signature")
            callback(nil, NSError(domain: "ServiceExecutor", code: ErrorCode.cannotGenerateSignature.rawValue, userInfo: [NSLocalizedDescriptionKey : "unable to generate signature"]))
            return
        }
        
        if let request = makeHttpRequestBuilder("\(Config.ENDPOINT_PRODUCTION)/\(path)")?
                          .setCharset(String.Encoding.utf8)
                          .setContentType(HttpRequest.ContentType.text)
                          .setHeaders(ServiceExecutor.headers)
                          .setPost(isPost)
                          .setParams(mutableParams)
                          .build() {
            
            request.execute() { httpResponse, error in
                if let error = error {
                    callback(nil, error)
                } else if let resultCode = self.getResultCode(httpResponse!),
                              let resultMessage = self.getResultMessage(httpResponse!) {
                    ServiceExecutor.Log.warn("error code was '\(resultCode.rawValue)' and message was '\(resultMessage)'")
                    if (resultCode == ResponseCode.Code.invalidToken) {
                        ServiceExecutor.Log.info("received invalid token request - attempting to acquire new token")
                        self.redispatchRequest(responseFactory, nexmoClient: nexmoClient, path: path, timestamp: timestamp, params: params, isPost: isPost, callback: callback)
                    } else if let customResponse = responseFactory.createResponse(httpResponse!) {
                        callback(customResponse, nil)
                    } else {
                        ServiceExecutor.Log.warn("unable to create response object using factory, could be an error from sdk service")
                        callback(nil, NSError(domain: "ServiceExecutor", code: resultCode.rawValue, userInfo: [NSLocalizedDescriptionKey : resultMessage]))
                    }
                // if let resultCode, resultMessage
                } else {
                    callback(nil, NSError(domain: "ServiceExecutor", code: ErrorCode.cannotParseResponse.rawValue, userInfo: [NSLocalizedDescriptionKey : "Un-parseable response returned from server!"]))
                }
            }
        } else {
            callback(nil, NSError(domain: "ServiceExecutor", code: ErrorCode.cannotBuildHttpRequest.rawValue, userInfo: [NSLocalizedDescriptionKey : "unable to build http request"]))
        }
    }
    
    func makeHttpRequestBuilder(_ url: String) -> HttpRequestBuilder? {
        return HttpRequestBuilder(url)
    }
    
    /**
        Get the result code from a HttpResponse
        
        - parameter httpResponse: the HttpResponse object
        
        - returns: Optional ResponseCode enum if the code exists and is recognised.
    */ 
    func getResultCode(_ httpResponse: HttpResponse) -> ResponseCode.Code? {
        if let body = httpResponse.body,
                let messageData = body.data(using: String.Encoding.utf8, allowLossyConversion: false),
                let json = (try? JSONSerialization.jsonObject(with: messageData, options: JSONSerialization.ReadingOptions())) as? [String:AnyObject],
                let resultCode = json[ServiceExecutor.PARAM_RESULT_CODE] as? Int {
            return ResponseCode.Code(rawValue: resultCode)
        }
        
        return nil
    }
    
    /**
        Get the result message froma HttpResponse
        
        - parameter httpResponse: tht HttpResponse object
        
        - returns: Optional String of the response message if it exists
    */
    func getResultMessage(_ httpResponse: HttpResponse) -> String? {
        if let body = httpResponse.body,
                let messageData = body.data(using: String.Encoding.utf8, allowLossyConversion: false),
                let json = (try? JSONSerialization.jsonObject(with: messageData, options: JSONSerialization.ReadingOptions())) as? [String:AnyObject],
                let resultMessage = json[ServiceExecutor.PARAM_RESULT_MESSAGE] as? String {
            return resultMessage
        }

        return nil
    }
        
    func getToken(_ nexmoClient: NexmoClient, onResponse: @escaping (_ response: TokenResponse?, _ error: NSError?) -> ()) {
        DispatchQueue.global().async {
            let params = NSMutableDictionary()
            if (!self.deviceProperties.addIpAddress(toParams: params, withKey: ServiceExecutor.PARAM_SOURCE_IP)) {
                let error = NSError(domain: "ServiceExecutor", code: ErrorCode.cannotGetIPAddress.rawValue, userInfo: [NSLocalizedDescriptionKey : "Failed to get ip address!"])
                
                DispatchQueue.main.async {
                    onResponse(nil, error)
                }
                
                return
            }
            
            if (!self.deviceProperties.addDeviceIdentifier(toParams: params, withKey: ServiceExecutor.PARAM_DEVICE_ID)) {
                let error = NSError(domain: "ServiceExecutor", code: 2, userInfo: [NSLocalizedDescriptionKey : "Failed to get duid!"])
                
                DispatchQueue.main.async {
                    onResponse(nil, error)
                }
                
                return
            }
            
            let swiftParams = params.copy() as! [String:String]
            
            if let httpRequest = self.generateHttpRequestForService(nexmoClient, path: ServiceExecutor.METHOD_TOKEN, timestamp: Date(), params: swiftParams) {
                httpRequest.execute() { httpResponse, error in
                    if let error = error {
                        DispatchQueue.main.async {
                            onResponse(nil, error)
                        }
                    } else if let tokenResponse = TokenResponse(httpResponse!) {
                        DispatchQueue.main.async {
                            onResponse(tokenResponse, nil)
                        }
                    } else {
                        let error = NSError(domain: "ServiceExecutor", code: 3, userInfo: [NSLocalizedDescriptionKey : "Failed to create TokenResponse object!"])
                        ServiceExecutor.Log.error(error.localizedDescription)
                        DispatchQueue.main.async {
                            onResponse(nil, error)
                        }
                    }
                }
            
            // if let httpRequest
            } else {
                let error = NSError(domain: "ServiceExecutor", code: 4, userInfo: [NSLocalizedDescriptionKey : "Failed to create HttpRequest object!"])
                
                DispatchQueue.main.async {
                    onResponse(nil, error)
                }
            }
        }
    }
}
