//
//  LogoutRequest.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 13/08/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation

class LogoutRequest {

    let token : String
    let number : String
    let countryCode : String?
    
    init(token: String, number: String, countryCode: String?) {
        self.token = token
        self.number = number
        self.countryCode = countryCode
    }
}