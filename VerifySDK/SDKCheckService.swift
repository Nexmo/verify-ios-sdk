//
//  SDKCheckService.swift
//  NexmoVerify
//
//  Created by Dorian Peake on 10/06/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

import Foundation

/**
    Class which performs requests to the Check service
*/
class SDKCheckService : CheckService {

    typealias RequestType = CheckRequest
    typealias ResponseType = CheckResponse
    
    fileprivate static let Log = Logger(String(describing: SDKCheckService.self))
    
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
    
    /**
        Begin a check request
        
        - parameter #request: the CheckRequest object, which contains the pin code to be checked
        
        - parameter onResponse: callback for completion or failure of the current check request.
        Contains a response from the server or an NSError if something wen't catastrophically wrong.
        Note: The response object may be negative and therefore the resultCode parameter should be checked.
    */
    func start(request: CheckRequest, onResponse: @escaping (_ response: CheckResponse?, _ error: NSError?) -> ()) {
        DispatchQueue.global().async {
            let params = NSMutableDictionary()
            if (!self.deviceProperties.addIpAddress(toParams: params, withKey: ServiceExecutor.PARAM_SOURCE_IP)) {
                let error = NSError(domain: "SDKCheckService", code: 1, userInfo: [NSLocalizedDescriptionKey : "Failed to get ip address!"])
               
                DispatchQueue.main.async {
                    onResponse(nil, error)
                }
                
                return
            }
            
            if (!self.deviceProperties.addDeviceIdentifier(toParams: params, withKey: ServiceExecutor.PARAM_DEVICE_ID)) {
                let error = NSError(domain: "SDKCheckService", code: 2, userInfo: [NSLocalizedDescriptionKey : "Failed to get duid!"])
                
                DispatchQueue.main.async {
                    onResponse(nil, error)
                }
                
                return
            }
            params[ServiceExecutor.PARAM_CODE] = request.pinCode
            params[ServiceExecutor.PARAM_NUMBER] = request.phoneNumber
            
            if let countryCode = request.countryCode {
                params[ServiceExecutor.PARAM_COUNTRY_CODE] = countryCode
            }
            
            let swiftParams = params.copy() as! [String:String]
            
            self.serviceExecutor.performHttpRequestForService(CheckResponseFactory(), nexmoClient: self.nexmoClient, path: ServiceExecutor.METHOD_CHECK, timestamp: Date(), params: swiftParams, isPost: false) { response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        onResponse(nil, error)
                    }
                } else {
                    DispatchQueue.main.async {
                        onResponse((response as! CheckResponse), nil)
                    }
                }
            }
        }
    }
}
