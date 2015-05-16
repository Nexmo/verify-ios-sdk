//
//  SearchRequest.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 16/08/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation

class SearchRequest {

    var number : String
    var token : String
    var countryCode : String?
    
    init(number: String, token: String, countryCode: String?) {
        self.number = number
        self.token = token
        self.countryCode = countryCode
    }
}