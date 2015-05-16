//
//  ServiceHelper.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 19/05/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

import Foundation
import RequestSigning

/**
    Base class for all nexmo services, which contains a lot of helper methods for
    creating requests, such as generating signatures.
*/

class ServiceHelper {
        
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

    /** Custom HTTP header fields. */
    static let OS_FAMILY = "X-NEXMO-SDK-OS-FAMILY"
    static let OS_REVISION = "X-NEXMO-SDK-OS-REVISION"
    static let SDK_REVISION = "X-NEXMO-SDK-REVISION"
    static let RESPONSE_SIG = "X-NEXMO-RESPONSE-SIGNATURE"

    /// Google Cloud Messaging Registration Token parameter
    static let PARAM_GCM_TOKEN = "push_token"

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
    static private let Log = Logger(toString(ServiceHelper))
    
    private var requestSigner : RequestSigner
    private static var instance : ServiceHelper?
    static var sharedInstance : ServiceHelper {
        get {
            if let sharedInstance = ServiceHelper.instance {
                return sharedInstance
            }
            
            ServiceHelper.instance = ServiceHelper()
            return ServiceHelper.instance!
        }
    }
    
    init() {
        requestSigner = SDKRequestSigner.sharedInstance()
    }
    
    init(requestSigner: RequestSigner) {
        self.requestSigner = requestSigner
    }
    
    /**
        Create HTTP Request for Nexmo service with parameters
        
        :param: path the url path of the service
        
        :param: params query string parameters that will be sent to the service
        
        :param: isPost should be POST or GET request
        
        :returns: HttpRequest Object which is constructed to call the service
    */
    func generateHttpRequestForService(nexmoClient: NexmoClient, path: String, timestamp: NSDate, var params: [String:String]?, isPost: Bool = false) -> HttpRequest? {
        if (params == nil) {
            params = [String:String]()
        }
        
        var mutableParams = (params! as NSDictionary).mutableCopy() as! [String:String]
        
        // remove empty values from query parameters
        for (key, value) in params! {
            if (count(value) == 0) {
                mutableParams.removeValueForKey(key)
            }
        }
        
        var timestamp = "\(Int(timestamp.timeIntervalSince1970))"
        if (mutableParams.count != 0) {
            mutableParams.updateValue(nexmoClient.applicationId, forKey: ServiceHelper.PARAM_APP_ID)
        }
        mutableParams.updateValue(timestamp, forKey: ServiceHelper.PARAM_TIMESTAMP)
        if let signature = requestSigner.generateSignatureWithParams(mutableParams, sharedSecretKey: nexmoClient.sharedSecretKey) {
            mutableParams.updateValue(signature, forKey: ServiceHelper.PARAM_SIGNATURE)
        } else {
            ServiceHelper.Log.error("unable to generate signature")
            return nil
        }
        
        var requestBuilder = HttpRequestBuilder("\(Config.ENDPOINT_PRODUCTION)/\(path)")?
                          .setCharset(NSUTF8StringEncoding)
                          .setContentType(HttpRequest.ContentType.TEXT)
                          .setHeaders(ServiceHelper.headers)
                          .setPost(isPost)
                          
        if (mutableParams.count != 0) {
            requestBuilder?.setParams(mutableParams)
        }
        return requestBuilder?.build()
    }
    
    /**
        Get the result code from a HttpResponse
        
        :param: httpResponse the HttpResponse object
        
        :returns: Optional ResponseCode enum if the code exists and is recognised.
    */
    func getResultCode(httpResponse: HttpResponse) -> ResponseCode.Code? {
        let error = NSErrorPointer()
        if let body = httpResponse.body,
                messageData = body.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false),
                json = NSJSONSerialization.JSONObjectWithData(messageData, options: NSJSONReadingOptions.allZeros, error: error) as? [String:AnyObject],
                resultCode = json[ServiceHelper.PARAM_RESULT_CODE] as? Int {
            return ResponseCode.Code(rawValue: resultCode)
        }
        
        return nil
    }
    
    /**
        Get the result message froma HttpResponse
        
        :param: httpResponse tht HttpResponse object
        
        :returns: Optional String of the response message if it exists
    */
    func getResultMessage(httpResponse: HttpResponse) -> String? {
        let error = NSErrorPointer()
        if let body = httpResponse.body,
                messageData = body.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false),
                json = NSJSONSerialization.JSONObjectWithData(messageData, options: NSJSONReadingOptions.allZeros, error: error) as? [String:AnyObject],
                resultMessage = json[ServiceHelper.PARAM_RESULT_MESSAGE] as? String {
            return resultMessage
        }

        return nil
    }
}
