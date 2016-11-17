//
//  CheckResponse.swift
//  NexmoVerify
//
//  Created by Dorian Peake on 10/06/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

import Foundation

/**
    Contains response information from a check request
*/
class CheckResponse : BaseResponse {

    fileprivate(set) var userStatus : String?
    
    required init?(_ httpResponse: HttpResponse) {
        super.init(httpResponse)
        
        if let userStatus = self.json[ServiceExecutor.PARAM_RESULT_USER_STATUS] as? String {
                self.userStatus = userStatus
        }
    }
    
    init(userStatus: String, signature: String, resultCode: Int, resultMessage: String, timestamp: String, messageBody: String) {
        self.userStatus = userStatus
        super.init(signature: signature, resultCode: resultCode, resultMessage: resultMessage, timestamp: timestamp, messageBody: messageBody)
    }
}
