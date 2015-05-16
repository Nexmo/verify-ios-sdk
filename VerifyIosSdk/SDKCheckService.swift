//
//  SDKCheckService.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 10/06/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

import Foundation
import DeviceProperties

/**
    Class which performs requests to the Check service
*/
class SDKCheckService : CheckService {

    typealias RequestType = CheckRequest
    typealias ResponseType = CheckResponse
    
    private static let Log = Logger(toString(SDKCheckService))
    
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
        Begin a check request
        
        :param: #request the CheckRequest object, which contains the pin code to be checked
        
        :param: onResponse callback for completion or failure of the current check request.
        Contains a response from the server or an NSError if something wen't catastrophically wrong.
        Note: The response object may be negative and therefore the resultCode parameter should be checked.
    */
    func start(#request: CheckRequest, onResponse: (response: CheckResponse?, error: NSError?) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            var params = NSMutableDictionary()
            if (!self.deviceProperties.addIpAddressToParams(params, withKey: ServiceHelper.PARAM_SOURCE_IP)) {
                let error = NSError(domain: "SDKCheckService", code: 1, userInfo: [NSLocalizedDescriptionKey : "Failed to get ip address!"])
                SDKCheckService.Log.error(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                    onResponse(response: nil, error: error)
                }
                
                return
            }
            
            if (!self.deviceProperties.addDeviceIdentifierToParams(params, withKey: ServiceHelper.PARAM_DEVICE_ID)) {
                let error = NSError(domain: "SDKCheckService", code: 2, userInfo: [NSLocalizedDescriptionKey : "Failed to get duid!"])
                SDKCheckService.Log.error(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                    onResponse(response: nil, error: error)
                }
                
                return
            }
            
            params.setObject(request.pinCode, forKey: ServiceHelper.PARAM_CODE)
            params.setObject(request.phoneNumber, forKey: ServiceHelper.PARAM_NUMBER)
            params.setObject(request.token, forKey: ServiceHelper.PARAM_TOKEN)
            
            if let countryCode = request.countryCode {
                params.setObject(countryCode, forKey: ServiceHelper.PARAM_COUNTRY_CODE)
            }
            
            let swiftParams = params.copy() as! [String:String]
            if let httpRequest = self.serviceHelper.generateHttpRequestForService(self.nexmoClient, path: ServiceHelper.METHOD_CHECK, timestamp: NSDate(), params: swiftParams) {
                httpRequest.execute() { httpResponse, error in
                    SDKCheckService.Log.info("httpResponse callback")
                    if let error = error {
                        SDKCheckService.Log.error(error.localizedDescription)
                        dispatch_async(dispatch_get_main_queue()) {
                            onResponse(response: nil, error: error)
                        }
                    } else if let checkResponse = CheckResponse(httpResponse!) {
                        dispatch_async(dispatch_get_main_queue()) {
                            onResponse(response: checkResponse, error: nil)
                        }
                    } else {
                        let error = NSError(domain: "SDKCheckService", code: 3, userInfo: [NSLocalizedDescriptionKey : "Failed to create CheckResponse object!"])
                        SDKCheckService.Log.error(error.localizedDescription)
                        dispatch_async(dispatch_get_main_queue()) {
                            onResponse(response: nil, error: error)
                        }
                    }
                }
            // if let httpRequest
            } else {
                let error = NSError(domain: "SDKCheckService", code: 4, userInfo: [NSLocalizedDescriptionKey : "Failed to create HttpRequest object!"])
                SDKCheckService.Log.error(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                    onResponse(response: nil, error: error)
                }
            }
        }
    }
}
