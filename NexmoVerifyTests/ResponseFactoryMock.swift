//
//  ResponseFactoryMock.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 31/08/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation
@testable import NexmoVerify

class ResponseFactoryMock : ResponseFactory {
    func createResponse(_ httpResponse: HttpResponse) -> BaseResponse? {
        return MockResponse()
    }
}
