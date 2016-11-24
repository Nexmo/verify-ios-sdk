//
//  MockResponse.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 02/09/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation
@testable import NexmoVerify

class MockResponse : BaseResponse {
    init() {
        super.init(signature: nil, resultCode: 0, resultMessage: "some message", timestamp: "\(Int(Date().timeIntervalSince1970))", messageBody: "fake body")
    }

    required init?(_ httpResponse: HttpResponse) {
        super.init(httpResponse)
    }
}
