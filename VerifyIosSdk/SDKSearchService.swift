//
//  SDKSearchService.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 16/08/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation
import DeviceProperties

class SDKSearchService : SearchService {

    private static let Log = Logger(toString(SDKSearchService))
    
    private let nexmoClient : NexmoClient
    private let serviceHelper : ServiceHelper
    private let deviceProperties : DevicePropertyAccessor

    init(nexmoClient: NexmoClient, deviceProperties: DevicePropertyAccessor, serviceHelper: ServiceHelper) {
        self.nexmoClient = nexmoClient
        self.serviceHelper = serviceHelper
        self.deviceProperties = deviceProperties
    }
    
    init() {
        self.nexmoClient = NexmoClient.sharedInstance
        self.serviceHelper = ServiceHelper.sharedInstance
        self.deviceProperties = SDKDeviceProperties.sharedInstance()
    }
    
    func start(#request: SearchRequest, onResponse: (response: SearchResponse?, error: NSError?) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            var params = NSMutableDictionary()

            if (!self.deviceProperties.addIpAddressToParams(params, withKey: ServiceHelper.PARAM_SOURCE_IP)) {
                let error = NSError(domain: "SDKSearchService", code: 1, userInfo: [NSLocalizedDescriptionKey : "Failed to get ip address!"])
                SDKSearchService.Log.error(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                    onResponse(response: nil, error: error)
                }
                
                return
            }
            
            if (!self.deviceProperties.addDeviceIdentifierToParams(params, withKey: ServiceHelper.PARAM_DEVICE_ID)) {
                let error = NSError(domain: "SDKSearchService", code: 2, userInfo: [NSLocalizedDescriptionKey : "Failed to get duid!"])
                SDKSearchService.Log.error(error.localizedDescription)
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
            if let httpRequest = self.serviceHelper.generateHttpRequestForService(self.nexmoClient, path: ServiceHelper.METHOD_SEARCH, timestamp: NSDate(), params: swiftParams) {
                httpRequest.execute() {httpResponse, error in
                    if let error = error {
                        SDKSearchService.Log.error(error.localizedDescription)
                        dispatch_async(dispatch_get_main_queue()) {
                            onResponse(response: nil, error: error)
                        }
                    } else if let searchResponse = SearchResponse(httpResponse!) {
                        dispatch_async(dispatch_get_main_queue()) {
                            onResponse(response: searchResponse, error: nil)
                        }
                    } else {
                        let error = NSError(domain: "SDKSearchService", code: 3, userInfo: [NSLocalizedDescriptionKey : "Failed to create VerifyResponse object!"])
                        SDKSearchService.Log.error(error.localizedDescription)
                        dispatch_async(dispatch_get_main_queue()) {
                            onResponse(response: nil, error: error)
                        }
                    }
                }
            // if let httpRequest
            } else {
                let error = NSError(domain: "SDKSearchService", code: 4, userInfo: [NSLocalizedDescriptionKey : "Failed to create HttpRequest object!"])
                SDKSearchService.Log.error(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                    onResponse(response: nil, error: error)
                }
            }

            
        }
    }
}