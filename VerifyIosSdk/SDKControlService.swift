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
    
    private static let Log = Logger(String(SDKControlService))
    
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
    
    func start(request request: ControlRequest, onResponse: (response: ControlResponse?, error: NSError?) -> ()) {
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let params = NSMutableDictionary()
            if (!self.deviceProperties.addIpAddressToParams(params, withKey: ServiceExecutor.PARAM_SOURCE_IP)) {
                let error = NSError(domain: "SDKControlService", code: 1, userInfo: [NSLocalizedDescriptionKey : "Failed to get ip address!"])
                SDKControlService.Log.error(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                    onResponse(response: nil, error: error)
                }
                
                return
            }
            
            if (!self.deviceProperties.addDeviceIdentifierToParams(params, withKey: ServiceExecutor.PARAM_DEVICE_ID)) {
                let error = NSError(domain: "SDKControlService", code: 2, userInfo: [NSLocalizedDescriptionKey : "Failed to get duid!"])
                SDKControlService.Log.error(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                    onResponse(response: nil, error: error)
                }
                
                return
            }
            
            params[ServiceExecutor.PARAM_COMMAND] = request.command
            params[ServiceExecutor.PARAM_NUMBER] = request.phoneNumber
            
            if let countryCode = request.countryCode {
                params[ServiceExecutor.PARAM_COUNTRY_CODE] = countryCode
            }
            
            let swiftParams = params.copy() as! [String:String]
            self.serviceExecutor.performHttpRequestForService(ControlResponseFactory(), nexmoClient: self.nexmoClient, path: ServiceExecutor.METHOD_CONTROL, timestamp: NSDate(), params: swiftParams, isPost: false) { response, error in
                if let error = error {
                    dispatch_async(dispatch_get_main_queue()) {
                        onResponse(response: nil, error: error)
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        onResponse(response: (response as! ControlResponse), error: nil)
                    }
                }
            }
        }
    }
}