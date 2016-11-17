//
//  SDKSearchService.swift
//  NexmoVerify
//
//  Created by Dorian Peake on 16/08/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation

class SDKSearchService : SearchService {

    fileprivate static let Log = Logger(String(describing: SDKSearchService.self))
    
    fileprivate let nexmoClient : NexmoClient
    fileprivate let serviceExecutor : ServiceExecutor
    fileprivate let deviceProperties : DevicePropertyAccessor

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
    
    func start(request: SearchRequest, onResponse: @escaping (_ response: SearchResponse?, _ error: NSError?) -> ()) {
        DispatchQueue.global().async {
            let params = NSMutableDictionary()

            if (!self.deviceProperties.addIpAddress(toParams: params, withKey: ServiceExecutor.PARAM_SOURCE_IP)) {
                let error = NSError(domain: "SDKSearchService", code: 1, userInfo: [NSLocalizedDescriptionKey : "Failed to get ip address!"])
                
                DispatchQueue.main.async {
                    onResponse(nil, error)
                }
                
                return
            }
            
            if (!self.deviceProperties.addDeviceIdentifier(toParams: params, withKey: ServiceExecutor.PARAM_DEVICE_ID)) {
                let error = NSError(domain: "SDKSearchService", code: 2, userInfo: [NSLocalizedDescriptionKey : "Failed to get duid!"])
                
                DispatchQueue.main.async {
                    onResponse(nil, error)
                }
                
                return
            }
            
            params[ServiceExecutor.PARAM_NUMBER] = request.number

            if let countryCode = request.countryCode {
                params[ServiceExecutor.PARAM_COUNTRY_CODE] = countryCode
            }
            
            let swiftParams = params.copy() as! [String:String]
            self.serviceExecutor.performHttpRequestForService(SearchResponseFactory(), nexmoClient: self.nexmoClient, path: ServiceExecutor.METHOD_SEARCH, timestamp: Date(), params: swiftParams, isPost: false) { response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        onResponse(nil, error)
                    }
                } else {
                    DispatchQueue.main.async {
                        onResponse((response as! SearchResponse), nil)
                    }
                }
            }
        }
    }
}
