//
//  SDKControlService.swift
//  NexmoVerify
//
//  Created by Dorian Peake on 07/08/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation

class SDKControlService : ControlService {
    typealias RequestType = ControlRequest
    typealias ResponseType = ControlResponse
    
    fileprivate static let Log = Logger(String(describing: SDKControlService.self))
    
    fileprivate let nexmoClient : NexmoClient
    fileprivate let serviceExecutor : ServiceExecutor
    fileprivate let deviceProperties : DevicePropertyAccessor
    
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
    
    func start(request: ControlRequest, onResponse: @escaping (_ response: ControlResponse?, _ error: NSError?) -> ()) {
    
        DispatchQueue.global().async{
            let params = NSMutableDictionary()
            if (!self.deviceProperties.addIpAddress(toParams: params, withKey: ServiceExecutor.PARAM_SOURCE_IP)) {
                let error = NSError(domain: "SDKControlService", code: 1, userInfo: [NSLocalizedDescriptionKey : "Failed to get ip address!"])
               
                DispatchQueue.main.async {
                    onResponse(nil, error)
                }
                
                return
            }
            
            if (!self.deviceProperties.addDeviceIdentifier(toParams: params, withKey: ServiceExecutor.PARAM_DEVICE_ID)) {
                let error = NSError(domain: "SDKControlService", code: 2, userInfo: [NSLocalizedDescriptionKey : "Failed to get duid!"])
                SDKControlService.Log.error(error.localizedDescription)
                DispatchQueue.main.async {
                    onResponse(nil, error)
                }
                
                return
            }
            
            params[ServiceExecutor.PARAM_COMMAND] = request.command
            params[ServiceExecutor.PARAM_NUMBER] = request.phoneNumber
            
            if let countryCode = request.countryCode {
                params[ServiceExecutor.PARAM_COUNTRY_CODE] = countryCode
            }
            
            let swiftParams = params.copy() as! [String:String]
            self.serviceExecutor.performHttpRequestForService(ControlResponseFactory(), nexmoClient: self.nexmoClient, path: ServiceExecutor.METHOD_CONTROL, timestamp: Date(), params: swiftParams, isPost: false) { response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        onResponse(nil, error)
                    }
                } else {
                    DispatchQueue.main.async {
                        onResponse((response as! ControlResponse), nil)
                    }
                }
            }
        }
    }
}
