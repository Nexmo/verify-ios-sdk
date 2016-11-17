//
//  SearchService.swift
//  NexmoVerify
//
//  Created by Dorian Peake on 16/08/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation

/**
    Protocol describes the base functionality for a nexmo service.
    
    Currently this only consists of a request to a service
*/
protocol SearchService {
    
    /**
        Begin a service operation
        
        - parameter request: The request object a service will use to make the request
        
        - parameter onResponse: A callback containing either a valid response or an error if something went wrong.
        Only one of these variables will be nil at a time.
    */
    func start(request: SearchRequest,
               onResponse: @escaping (_ response: SearchResponse?, _ error: NSError?) -> ())
}
