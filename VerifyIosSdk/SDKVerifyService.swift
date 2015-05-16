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
    
    static private let Log = Logger(toString(SDKVerifyService))
    private let nexmoClient : NexmoClient
    private let serviceHelper : ServiceHelper
    private let deviceProperties : DevicePropertyAccessor
    
    init(nexmoClient: NexmoClient, serviceHelper: ServiceHelper, deviceProperties: DevicePropertyAccessor) {
        self.nexmoClient = nexmoClient
        self.serviceHelper = serviceHelper
        self.deviceProperties = deviceProperties
    }
    
    init() {
        self.nexmoClient = NexmoClient.sharedInstance
        self.serviceHelper = ServiceHelper.sharedInstance
        self.deviceProperties = SDKDeviceProperties.sharedInstance()
    }
    
    
    /**
        Begin a verification request
        
        :param: #request the VerifyRequest object, created from a VerifyTask
        
        :param: onResponse callback for completion or failure of the current verify request.
        Contains a response from the server or an NSError if something wen't catastrophically wrong.
        Note: The response object may be negative and therefore the resultCode parameter should be checked.
    */
    func start(#request: VerifyRequest, onResponse: (response: VerifyResponse?, error: NSError?) -> ()) {
        SDKVerifyService.Log.info("Beginning verify request")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            var params = NSMutableDictionary()
            if (!self.deviceProperties.addIpAddressToParams(params, withKey: ServiceHelper.PARAM_SOURCE_IP)) {
                let error = NSError(domain: "SDKVerifyService", code: 1, userInfo: [NSLocalizedDescriptionKey : "Failed to get ip address!"])
                SDKVerifyService.Log.error(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                    onResponse(response: nil, error: error)
                }
                
                return
            }
            
            if (!self.deviceProperties.addDeviceIdentifierToParams(params, withKey: ServiceHelper.PARAM_DEVICE_ID)) {
                let error = NSError(domain: "SDKVerifyService", code: 2, userInfo: [NSLocalizedDescriptionKey : "Failed to get duid!"])
                SDKVerifyService.Log.error(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                    onResponse(response: nil, error: error)
                }
                
                return
            }
            
            params.setObject(request.token, forKey: ServiceHelper.PARAM_TOKEN)
            params.setObject(request.phoneNumber, forKey: ServiceHelper.PARAM_NUMBER)
            if let countryCode = request.countryCode {
                params.setObject(countryCode, forKey: ServiceHelper.PARAM_COUNTRY_CODE)
            }
            
            if let gcmToken = request.gcmToken {
                params.setObject(gcmToken, forKey: ServiceHelper.PARAM_GCM_TOKEN)
            }
            
            let swiftParams = params.copy() as! [String:String]
            if let httpRequest = self.serviceHelper.generateHttpRequestForService(self.nexmoClient, path: ServiceHelper.METHOD_VERIFY, timestamp: NSDate(), params: swiftParams) {
                httpRequest.execute() {httpResponse, error in
                    if let error = error {
                        SDKVerifyService.Log.error(error.localizedDescription)
                        dispatch_async(dispatch_get_main_queue()) {
                            onResponse(response: nil, error: error)
                        }
                    } else if let verifyResponse = VerifyResponse(httpResponse!) {
                        dispatch_async(dispatch_get_main_queue()) {
                            onResponse(response: verifyResponse, error: nil)
                        }
                    } else {
                        let error = NSError(domain: "SDKVerifyService", code: 3, userInfo: [NSLocalizedDescriptionKey : "Failed to create VerifyResponse object!"])
                        SDKVerifyService.Log.error(error.localizedDescription)
                        dispatch_async(dispatch_get_main_queue()) {
                            onResponse(response: nil, error: error)
                        }
                    }
                }
            // if let httpRequest
            } else {
                let error = NSError(domain: "SDKVerifyService", code: 4, userInfo: [NSLocalizedDescriptionKey : "Failed to create HttpRequest object!"])
                SDKVerifyService.Log.error(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                    onResponse(response: nil, error: error)
                }
            }
        }
    }
}
