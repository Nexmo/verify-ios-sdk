//
//  BaseResponseFactoryMock.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 31/08/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation
@testable import NexmoVerify

class BaseResponseFactoryMock : ResponseFactory {

    typealias ResponseType = BaseResponse
    
    func createResponse(_ httpResponse: HttpResponse) -> ResponseType? {
        return BaseResponse(signature: "stub", resultCode: 0, resultMessage: "stub", timestamp: "stub", messageBody: "stub")
    }
}
