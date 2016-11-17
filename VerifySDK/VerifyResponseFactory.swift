//
//  VerifyResponseFactory.swift
//  NexmoVerify
//
//  Created by Dorian Peake on 08/09/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation

class VerifyResponseFactory : ResponseFactory {
    func createResponse(_ httpResponse: HttpResponse) -> BaseResponse? {
        return VerifyResponse(httpResponse)
    }
}
