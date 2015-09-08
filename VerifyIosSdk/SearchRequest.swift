//
//  SearchRequest.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 16/08/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation

class SearchRequest : Equatable {

    var number : String
    var countryCode : String?
    
    init(number: String, countryCode: String?) {
        self.number = number
        self.countryCode = countryCode
    }
}

func ==(lhs: SearchRequest, rhs: SearchRequest) -> Bool {
    return (lhs.number == rhs.number &&
            lhs.countryCode == rhs.countryCode)
}