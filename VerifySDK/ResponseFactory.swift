//
//  ResponseFactory.swift
//  NexmoVerify
//
//  Created by Dorian Peake on 31/08/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation

protocol ResponseFactory {
    
    // Create a response from a HttpResponse object
    // may actually returns some sub-class of BaseResponse, but swift restrictions
    // do not allow generic protocols or typaliased protocols to be used like normal types
    func createResponse(_ httpResponse: HttpResponse) -> BaseResponse?
}
