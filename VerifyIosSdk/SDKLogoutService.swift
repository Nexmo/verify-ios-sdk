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

    private static let Log = Logger(toString(SDKLogoutService))

    private let nexmoClient : NexmoClient
    private let serviceHelper : ServiceHelper
    private let requestSigner : RequestSigner
    private let deviceProperties : DevicePropertyAccessor
    
    init() {
        self.nexmoClient = NexmoClient.sharedInstance
        self.serviceHelper = ServiceHelper.sharedInstance
        self.requestSigner = SDKRequestSigner.sharedInstance()
        self.deviceProperties = SDKDeviceProperties.sharedInstance()
    }
    
    init(nexmoClient: NexmoClient, serviceHelper: ServiceHelper, requestSigner: RequestSigner, deviceProperties: DevicePropertyAccessor) {
        self.nexmoClient = nexmoClient
        self.serviceHelper = serviceHelper
        self.requestSigner = requestSigner
        self.deviceProperties = deviceProperties
    }
    
    func start(#request: LogoutRequest, onResponse: (response: LogoutResponse?, error: NSError?) -> ()) {
        var params = NSMutableDictionary()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            if (!self.deviceProperties.addDeviceIdentifierToParams(params, withKey: ServiceHelper.PARAM_DEVICE_ID)) {
                let error = NSError(domain: "SDKLogoutService", code: 1, userInfo: [NSLocalizedDescriptionKey : "Failed to get duid!"])
                SDKLogoutService.Log.error(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                    onResponse(response: nil, error: error)
                }
                
                return
            }
            
            if (!self.deviceProperties.addIpAddressToParams(params, withKey: ServiceHelper.PARAM_SOURCE_IP)) {
                let error = NSError(domain: "SDKLogoutService", code: 2, userInfo: [NSLocalizedDescriptionKey : "Failed to get duid!"])
                SDKLogoutService.Log.error(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                    onResponse(response: nil, error: error)
                }
                
                return
            }
            
            params[ServiceHelper.PARAM_TOKEN] = request.token
            params[ServiceHelper.PARAM_NUMBER] = request.number
            
            if let countryCode = request.countryCode {
                params[ServiceHelper.PARAM_COUNTRY_CODE] = countryCode
            }
            
            let swiftParams = params.copy() as! [String:String]
            if let httpRequest = self.serviceHelper.generateHttpRequestForService(self.nexmoClient, path: ServiceHelper.METHOD_LOGOUT, timestamp: NSDate(), params: swiftParams) {
                httpRequest.execute() { httpResponse, error in
                    SDKLogoutService.Log.info("httpResponse callback")
                    if let error = error {
                        SDKLogoutService.Log.error(error.localizedDescription)
                        dispatch_async(dispatch_get_main_queue()) {
                            onResponse(response: nil, error: error)
                        }
                    } else if let logoutResponse = LogoutResponse(httpResponse!) {
                        dispatch_async(dispatch_get_main_queue()) {
                            onResponse(response: logoutResponse, error: nil)
                        }
                    } else {
                        let error = NSError(domain: "SDKLogoutService", code: 3, userInfo: [NSLocalizedDescriptionKey : "Failed to create LogoutResponse object!"])
                        SDKLogoutService.Log.error(error.localizedDescription)
                        dispatch_async(dispatch_get_main_queue()) {
                            onResponse(response: nil, error: error)
                        }
                    }
                    
                    return
                }
            } else {
                let error = NSError(domain: "SDKLogoutService", code: 4, userInfo: [NSLocalizedDescriptionKey : "Failed to create HttpRequest object!"])
                SDKLogoutService.Log.error(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                    onResponse(response: nil, error: error)
                }
            }
            return
        }
    }
}