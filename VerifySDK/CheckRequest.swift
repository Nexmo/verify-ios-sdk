//
//  CheckRequest.swift
//  NexmoVerify
//
//  Created by Dorian Peake on 10/06/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

import Foundation

/**
    Contains information required by the check service to begin a request, such as a pin code
*/
class CheckRequest : Equatable {

    let pinCode : String
    let countryCode : String?
    let phoneNumber : String
    
    init(pinCode: String, countryCode: String?, phoneNumber: String) {
        self.pinCode = pinCode
        self.countryCode = countryCode
        self.phoneNumber = phoneNumber
    }
    
    convenience init(verifyTask: VerifyTask, pinCode: String) {
        self.init(pinCode: pinCode, countryCode: verifyTask.countryCode, phoneNumber: verifyTask.phoneNumber)
    }
}

/// Validate check request is the same
///
/// - Parameters:
///   - lhs: lhs
///   - rhs: rhs
/// - Returns: result
func ==(lhs: CheckRequest, rhs: CheckRequest) -> Bool {
    return (lhs.pinCode == rhs.pinCode &&
            lhs.countryCode == rhs.countryCode &&
            lhs.phoneNumber == rhs.phoneNumber)
}
