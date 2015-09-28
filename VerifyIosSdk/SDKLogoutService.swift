//
//  SDKLogoutService.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 12/08/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation
import RequestSigning
import DeviceProperties

class SDKLogoutService : LogoutService {

    private static let Log = Logger(String(SDKLogoutService))

    private let nexmoClient : NexmoClient
    private let serviceExecutor : ServiceExecutor
    private let requestSigner : RequestSigner
    private let deviceProperties : DevicePropertyAccessor
    
    init() {
        self.nexmoClient = NexmoClient.sharedInstance
        self.serviceExecutor = ServiceExecutor.sharedInstance
        self.requestSigner = SDKRequestSigner.sharedInstance()
        self.deviceProperties = SDKDeviceProperties.sharedInstance()
    }
    
    init(nexmoClient: NexmoClient, serviceExecutor: ServiceExecutor, requestSigner: RequestSigner, deviceProperties: DevicePropertyAccessor) {
        self.nexmoClient = nexmoClient
        self.serviceExecutor = serviceExecutor
        self.requestSigner = requestSigner
        self.deviceProperties = deviceProperties
    }
    
    func start(request request: LogoutRequest, onResponse: (response: LogoutResponse?, error: NSError?) -> ()) {
        let params = NSMutableDictionary()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            if (!self.deviceProperties.addDeviceIdentifierToParams(params, withKey: ServiceExecutor.PARAM_DEVICE_ID)) {
                let error = NSError(domain: "SDKLogoutService", code: 1, userInfo: [NSLocalizedDescriptionKey : "Failed to get duid!"])
                SDKLogoutService.Log.error(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                    onResponse(response: nil, error: error)
                }
                
                return
            }
            
            if (!self.deviceProperties.addIpAddressToParams(params, withKey: ServiceExecutor.PARAM_SOURCE_IP)) {
                let error = NSError(domain: "SDKLogoutService", code: 2, userInfo: [NSLocalizedDescriptionKey : "Failed to get duid!"])
                SDKLogoutService.Log.error(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                    onResponse(response: nil, error: error)
                }
                
                return
            }
            
            params[ServiceExecutor.PARAM_NUMBER] = request.number
            
            if let countryCode = request.countryCode {
                params[ServiceExecutor.PARAM_COUNTRY_CODE] = countryCode
            }
            
            let swiftParams = params.copy() as! [String:String]
            self.serviceExecutor.performHttpRequestForService(LogoutResponseFactory(), nexmoClient: self.nexmoClient, path: ServiceExecutor.METHOD_LOGOUT, timestamp: NSDate(), params: swiftParams, isPost: false) { response, error in
                if let error = error {
                    dispatch_async(dispatch_get_main_queue()) {
                        onResponse(response: nil, error: error)
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        onResponse(response: (response as! LogoutResponse), error: nil)
                    }
                }
            }
            return
        }
    }
}