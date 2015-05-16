//
//  SDKTokenService.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 19/05/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

import Foundation
import DeviceProperties

/**
    Class which performs requests to the verify service
*/
class SDKTokenService : TokenService {

    typealias RequestType = ()
    typealias ResponseType = TokenResponse
    
    private static let Log = Logger(toString(SDKTokenService))
    
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
        Begin a token request
        
        :param: #request unused. Must be `()`.
        
        :param: onResponse callback for completion or failure of the current toke request.
        Contains a response from the server or an NSError if something wen't catastrophically wrong.
        Note: The response object may be negative and therefore the resultCode parameter should be checked.
    */
    func start(#request: (), onResponse: (response: TokenResponse?, error: NSError?) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            var params = NSMutableDictionary()
            if (!self.deviceProperties.addIpAddressToParams(params, withKey: ServiceHelper.PARAM_SOURCE_IP)) {
                let error = NSError(domain: "SDKTokenService", code: 1, userInfo: [NSLocalizedDescriptionKey : "Failed to get ip address!"])
                SDKTokenService.Log.error(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                    onResponse(response: nil, error: error)
                }
                
                return
            }
            
            if (!self.deviceProperties.addDeviceIdentifierToParams(params, withKey: ServiceHelper.PARAM_DEVICE_ID)) {
                let error = NSError(domain: "SDKTokenService", code: 2, userInfo: [NSLocalizedDescriptionKey : "Failed to get duid!"])
                SDKTokenService.Log.error(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                    onResponse(response: nil, error: error)
                }
                
                return
            }
            SDKTokenService.Log.info("ipAddress = \(params[ServiceHelper.PARAM_DEVICE_ID])")
            
            let swiftParams = params.copy() as! [String:String]
            if let httpRequest = self.serviceHelper.generateHttpRequestForService(self.nexmoClient, path: ServiceHelper.METHOD_TOKEN, timestamp: NSDate(), params: swiftParams) {
                httpRequest.execute() { httpResponse, error in
                    SDKTokenService.Log.info("httpResponse callback")
                    if let error = error {
                        SDKTokenService.Log.error(error.localizedDescription)
                        dispatch_async(dispatch_get_main_queue()) {
                            onResponse(response: nil, error: error)
                        }
                    } else if let tokenResponse = TokenResponse(httpResponse!) {
                        dispatch_async(dispatch_get_main_queue()) {
                            onResponse(response: tokenResponse, error: nil)
                        }
                    } else {
                        let error = NSError(domain: "SDKTokenService", code: 3, userInfo: [NSLocalizedDescriptionKey : "Failed to create TokenResponse object!"])
                        SDKTokenService.Log.error(error.localizedDescription)
                        dispatch_async(dispatch_get_main_queue()) {
                            onResponse(response: nil, error: error)
                        }
                    }
                }
            // if let httpRequest
            } else {
                let error = NSError(domain: "SDKTokenService", code: 4, userInfo: [NSLocalizedDescriptionKey : "Failed to create HttpRequest object!"])
                SDKTokenService.Log.error(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                    onResponse(response: nil, error: error)
                }
            }
        }
    }
}
