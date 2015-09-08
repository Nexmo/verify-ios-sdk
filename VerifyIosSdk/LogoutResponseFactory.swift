//
//  LogoutResponseFactory.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 07/09/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation

class LogoutResponseFactory : ResponseFactory {
    func createResponse(httpResponse: HttpResponse) -> BaseResponse? {
        return LogoutResponse(httpResponse)
    }
}