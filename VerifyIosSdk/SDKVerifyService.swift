//
//  SDKVerifyService.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 16/05/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

import Foundation
import DeviceProperties

/**
    Class which performs requests to the verify service
*/
class SDKVerifyService : VerifyService {

    typealias RequestType = VerifyRequest
    typealias ResponseType = VerifyResponse
    
    static private let Log = Logger(String(SDKVerifyService))
    private let nexmoClient : NexmoClient
    private let serviceExecutor : ServiceExecutor
    private let deviceProperties : DevicePropertyAccessor
    
    init(nexmoClient: NexmoClient, serviceExecutor: ServiceExecutor, deviceProperties: DevicePropertyAccessor) {
        self.nexmoClient = nexmoClient
        self.serviceExecutor = serviceExecutor
        self.deviceProperties = deviceProperties
    }
    
    init() {
        self.nexmoClient = NexmoClient.sharedInstance
        self.serviceExecutor = ServiceExecutor.sharedInstance
        self.deviceProperties = SDKDeviceProperties.sharedInstance()
    }
    
    
    /**
        Begin a verification request
        
        - parameter #request: the VerifyRequest object, created from a VerifyTask
        
        - parameter onResponse: callback for completion or failure of the current verify request.
        Contains a response from the server or an NSError if something wen't catastrophically wrong.
        Note: The response object may be negative and therefore the resultCode parameter should be checked.
    */
    func start(request request: VerifyRequest, onResponse: (response: VerifyResponse?, error: NSError?) -> ()) {
        SDKVerifyService.Log.info("Beginning verify request")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let params = NSMutableDictionary()
            if (!self.deviceProperties.addIpAddressToParams(params, withKey: ServiceExecutor.PARAM_SOURCE_IP)) {
                let error = NSError(domain: "SDKVerifyService", code: 1000, userInfo: [NSLocalizedDescriptionKey : "Failed to get ip address!"])
                SDKVerifyService.Log.error(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                    onResponse(response: nil, error: error)
                }
                
                return
            }
            
            if (!self.deviceProperties.addDeviceIdentifierToParams(params, withKey: ServiceExecutor.PARAM_DEVICE_ID)) {
                let error = NSError(domain: "SDKVerifyService", code: 2000, userInfo: [NSLocalizedDescriptionKey : "Failed to get duid!"])
                SDKVerifyService.Log.error(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                    onResponse(response: nil, error: error)
                }
                
                return
            }
            
            params[ServiceExecutor.PARAM_NUMBER] = request.phoneNumber
            if let countryCode = request.countryCode {
                params[ServiceExecutor.PARAM_COUNTRY_CODE] = countryCode
            }
            
            if let gcmToken = request.gcmToken {
                params[ServiceExecutor.PARAM_GCM_TOKEN] = gcmToken
            }
            
            let swiftParams = params.copy() as! [String:String]
            var path : String
            if request.standalone {
                path = ServiceExecutor.METHOD_ONESHOT_VERIFY
            } else {
                path = ServiceExecutor.METHOD_VERIFY
            }
            self.serviceExecutor.performHttpRequestForService(VerifyResponseFactory(), nexmoClient: self.nexmoClient, path: path, timestamp: NSDate(), params: swiftParams, isPost: false) { response, error in
                if let error = error {
                    dispatch_async(dispatch_get_main_queue()) {
                        onResponse(response: nil, error: error)
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        onResponse(response: (response as! VerifyResponse), error: nil)
                    }
                }
            }
        }
    }
}
