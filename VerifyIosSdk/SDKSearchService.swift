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

    private static let Log = Logger(String(SDKSearchService))
    
    private let nexmoClient : NexmoClient
    private let serviceExecutor : ServiceExecutor
    private let deviceProperties : DevicePropertyAccessor

    init(nexmoClient: NexmoClient, deviceProperties: DevicePropertyAccessor, serviceExecutor: ServiceExecutor) {
        self.nexmoClient = nexmoClient
        self.serviceExecutor = serviceExecutor
        self.deviceProperties = deviceProperties
    }
    
    init() {
        self.nexmoClient = NexmoClient.sharedInstance
        self.serviceExecutor = ServiceExecutor.sharedInstance
        self.deviceProperties = SDKDeviceProperties.sharedInstance()
    }
    
    func start(request request: SearchRequest, onResponse: (response: SearchResponse?, error: NSError?) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let params = NSMutableDictionary()

            if (!self.deviceProperties.addIpAddressToParams(params, withKey: ServiceExecutor.PARAM_SOURCE_IP)) {
                let error = NSError(domain: "SDKSearchService", code: 1, userInfo: [NSLocalizedDescriptionKey : "Failed to get ip address!"])
                SDKSearchService.Log.error(error.localizedDescription)
                dispatch_async(dispatch_get_main_queue()) {
                    onResponse(response: nil, error: error)
                }
                
                return
            }
            
            if (!self.deviceProperties.addDeviceIdentifierToParams(params, withKey: ServiceExecutor.PARAM_DEVICE_ID)) {
                let error = NSError(domain: "SDKSearchService", code: 2, userInfo: [NSLocalizedDescriptionKey : "Failed to get duid!"])
                SDKSearchService.Log.error(error.localizedDescription)
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
            self.serviceExecutor.performHttpRequestForService(SearchResponseFactory(), nexmoClient: self.nexmoClient, path: ServiceExecutor.METHOD_SEARCH, timestamp: NSDate(), params: swiftParams, isPost: false) { response, error in
                if let error = error {
                    dispatch_async(dispatch_get_main_queue()) {
                        onResponse(response: nil, error: error)
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        onResponse(response: (response as! SearchResponse), error: nil)
                    }
                }
            }
        }
    }
}