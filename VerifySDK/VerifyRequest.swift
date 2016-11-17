//
//  VerifyRequest.swift
//  NexmoVerify
//
//  Created by Dorian Peake on 13/05/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

import Foundation

/**
    Contains information required by the verify service to begin a request, such as a mobile number
*/
open class VerifyRequest {

    let countryCode : String?
    let phoneNumber : String
    let standalone : Bool
    let pushToken : String?
    
    init(countryCode: String?, phoneNumber: String, standalone: Bool, pushToken: String?) {
        self.countryCode = countryCode
        self.phoneNumber = phoneNumber
        self.standalone = standalone
        self.pushToken = pushToken
    }
    
    convenience init(countryCode: String?, phoneNumber: String, standalone: Bool) {
        self.init(countryCode: countryCode, phoneNumber: phoneNumber, standalone: standalone, pushToken: nil)
    }
}

/// Validate verify request are the same
///
/// - Parameters:
///   - lhs: lhs
///   - rhs: rhs
/// - Returns: result
public func ==(lhs: VerifyRequest, rhs: VerifyRequest) -> Bool {
    return (lhs.countryCode == rhs.countryCode &&
            lhs.phoneNumber == rhs.phoneNumber &&
            lhs.pushToken == rhs.pushToken)
}
