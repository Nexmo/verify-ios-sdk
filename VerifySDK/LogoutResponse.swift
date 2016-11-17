//
//  LogoutResponse.swift
//  NexmoVerify
//
//  Created by Dorian Peake on 12/08/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation

class LogoutResponse : BaseResponse {

    override init(signature: String?, resultCode: Int, resultMessage: String, timestamp: String, messageBody: String) {
        super.init(signature: signature, resultCode: resultCode, resultMessage: resultMessage, timestamp: timestamp, messageBody: messageBody)
    }

    required init?(_ httpResponse: HttpResponse) {
        super.init(httpResponse)
    }
}
