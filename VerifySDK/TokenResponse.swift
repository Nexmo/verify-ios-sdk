//
//  TokenResponse.swift
//  NexmoVerify
//
//  Created by Dorian Peake on 20/05/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

import Foundation

/**
    Contains response information from a token request
*/
final class TokenResponse : BaseResponse {

    fileprivate static var Log = Logger(String(describing: TokenResponse.self))
    fileprivate(set) var token : String?
    
    init(token: String?, signature: String?, resultCode: Int, resultMessage: String, timestamp: String, messageBody: String) {
        self.token = token
        super.init(signature: signature, resultCode: resultCode, resultMessage: resultMessage, timestamp: timestamp, messageBody: messageBody)
    }
    
    required init?(_ httpResponse: HttpResponse) {
        super.init(httpResponse)
        
        if let token = self.json[ServiceExecutor.PARAM_TOKEN] as? String {
            self.token = token
        }
    }
}
