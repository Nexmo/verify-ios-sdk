//
//  ControlResponse.swift
//  NexmoVerify
//
//  Created by Dorian Peake on 07/08/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation

class ControlResponse : BaseResponse {

    fileprivate(set) var errorText : String?
    
    required init?(_ httpResponse: HttpResponse) {
        super.init(httpResponse)
        
        if let errorText = self.json["error_text"] as? String {
            self.errorText = errorText
        }
    }
    
    init(errorText: String, signature: String, resultCode: Int, resultMessage: String, timestamp: String, messageBody: String) {
        self.errorText = errorText
        super.init(signature: signature, resultCode: resultCode, resultMessage: resultMessage, timestamp: timestamp, messageBody: messageBody)
    }
}
