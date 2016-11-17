//
//  SDKVerifyService.swift
//  NexmoVerify
//
//  Created by Dorian Peake on 16/05/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

import Foundation

/**
    Class which performs requests to the verify service
*/
class SDKVerifyService : VerifyService {

    typealias RequestType = VerifyRequest
    typealias ResponseType = VerifyResponse
    
    static fileprivate let Log = Logger(String(describing: SDKVerifyService.self))
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
        Begin a verification request
        
        - parameter #request: the VerifyRequest object, created from a VerifyTask
        
        - parameter onResponse: callback for completion or failure of the current verify request.
        Contains a response from the server or an NSError if something wen't catastrophically wrong.
        Note: The response object may be negative and therefore the resultCode parameter should be checked.
    */
    func start(request: VerifyRequest, onResponse: @escaping (_ response: VerifyResponse?, _ error: NSError?) -> ()) {
        DispatchQueue.global().async {
            let params = NSMutableDictionary()
            if (!self.deviceProperties.addIpAddress(toParams: params, withKey: ServiceExecutor.PARAM_SOURCE_IP)) {
                let error = NSError(domain: "SDKVerifyService", code: 1000, userInfo: [NSLocalizedDescriptionKey : "Failed to get ip address!"])
                
                DispatchQueue.main.async {
                    onResponse(nil, error)
                }
                
                return
            }
            
            if (!self.deviceProperties.addDeviceIdentifier(toParams: params, withKey: ServiceExecutor.PARAM_DEVICE_ID)) {
                let error = NSError(domain: "SDKVerifyService", code: 2000, userInfo: [NSLocalizedDescriptionKey : "Failed to get duid!"])
                
                DispatchQueue.main.async {
                    onResponse(nil, error)
                }
                
                return
            }
            
            params[ServiceExecutor.PARAM_NUMBER] = request.phoneNumber
            if let countryCode = request.countryCode {
                params[ServiceExecutor.PARAM_COUNTRY_CODE] = countryCode
            }
            
            if let pushToken = request.pushToken {
                params[ServiceExecutor.PARAM_PUSH_TOKEN] = pushToken
            }
            
            let swiftParams = params.copy() as! [String:String]
            var path : String
            if request.standalone {
                path = ServiceExecutor.METHOD_ONESHOT_VERIFY
            } else {
                path = ServiceExecutor.METHOD_VERIFY
            }
            self.serviceExecutor.performHttpRequestForService(VerifyResponseFactory(), nexmoClient: self.nexmoClient, path: path, timestamp: Date(), params: swiftParams, isPost: false) { response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        onResponse(nil, error)
                    }
                } else {
                    DispatchQueue.main.async {
                        onResponse((response as! VerifyResponse), nil)
                    }
                }
            }
        }
    }
}
