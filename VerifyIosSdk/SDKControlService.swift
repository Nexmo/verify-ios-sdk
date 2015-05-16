//
//  SDKControlService.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 07/08/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation
import DeviceProperties

class SDKControlService : ControlService {
    typealias RequestType = ControlRequest
    typealias ResponseType = ControlResponse
    
    private static let Log = Logger(toString(SDKControlService))
    
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
    
    func start(#request: ControlRequest, onResponse: (response: ControlResponse?, error: NSError?) -> ()) {
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            var params = NSMutableDictionary()
            if (!self.deviceProperties.addIpAddressToParams(params, withKey: ServiceHelper.PARAM_SOURCE_IP)) {
                let error = NSError(domain: "SDKControlService", code: 1, userInfo: [NSLocalizedDescriptionKey : "Failed to get ip address!"])
                SDKControlService.Log.error(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                    onResponse(response: nil, error: error)
                }
                
                return
            }
            
            if (!self.deviceProperties.addDeviceIdentifierToParams(params, withKey: ServiceHelper.PARAM_DEVICE_ID)) {
                let error = NSError(domain: "SDKControlService", code: 2, userInfo: [NSLocalizedDescriptionKey : "Failed to get duid!"])
                SDKControlService.Log.error(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                    onResponse(response: nil, error: error)
                }
                
                return
            }
            
            params.setObject(request.command, forKey: ServiceHelper.PARAM_COMMAND)
            params.setObject(request.phoneNumber, forKey: ServiceHelper.PARAM_NUMBER)
            params.setObject(request.token, forKey: ServiceHelper.PARAM_TOKEN)
            
            if let countryCode = request.countryCode {
                params.setObject(countryCode, forKey: ServiceHelper.PARAM_COUNTRY_CODE)
            }
            
            let swiftParams = params.copy() as! [String:String]
            if let httpRequest = self.serviceHelper.generateHttpRequestForService(self.nexmoClient, path: ServiceHelper.METHOD_CONTROL, timestamp: NSDate(), params: swiftParams) {
                httpRequest.execute() { httpResponse, error in
                    SDKControlService.Log.info("httpResponse callback")
                    if let error = error {
                        SDKControlService.Log.error(error.localizedDescription)
                        dispatch_async(dispatch_get_main_queue()) {
                            onResponse(response: nil, error: error)
                        }
                    } else if let controlResponse = ControlResponse(httpResponse!) {
                        dispatch_async(dispatch_get_main_queue()) {
                            onResponse(response: controlResponse, error: nil)
                        }
                    } else {
                        let error = NSError(domain: "SDKControlService", code: 3, userInfo: [NSLocalizedDescriptionKey : "Failed to create ControlResponse object!"])
                        SDKControlService.Log.error(error.localizedDescription)
                        dispatch_async(dispatch_get_main_queue()) {
                            onResponse(response: nil, error: error)
                        }
                    }
                }
            // if let httpRequest
            } else {
                let error = NSError(domain: "SDKControlService", code: 4, userInfo: [NSLocalizedDescriptionKey : "Failed to create HttpRequest object!"])
                SDKControlService.Log.error(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                    onResponse(response: nil, error: error)
                }
            }
        }
    }
}