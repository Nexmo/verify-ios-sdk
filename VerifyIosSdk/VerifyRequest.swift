//
//  VerifyRequest.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 13/05/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

import Foundation

/**
    Contains information required by the verify service to begin a request, such as a mobile number
*/
public class VerifyRequest {

    let countryCode : String?
    let phoneNumber : String
    let standalone : Bool
    let gcmToken : String?
    
    init(countryCode: String?, phoneNumber: String, standalone: Bool, gcmToken: String?) {
        self.countryCode = countryCode
        self.phoneNumber = phoneNumber
        self.standalone = standalone
        self.gcmToken = gcmToken
    }
    
    convenience init(countryCode: String?, phoneNumber: String, standalone: Bool) {
        self.init(countryCode: countryCode, phoneNumber: phoneNumber, standalone: standalone, gcmToken: nil)
    }
}

public func ==(lhs: VerifyRequest, rhs: VerifyRequest) -> Bool {
    return (lhs.countryCode == rhs.countryCode &&
            lhs.phoneNumber == rhs.phoneNumber &&
            lhs.gcmToken == rhs.gcmToken)
}