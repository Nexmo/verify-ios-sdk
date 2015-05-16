//
//  CheckRequest.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 10/06/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

import Foundation

/**
    Contains information required by the check service to begin a request, such as a pin code
*/
class CheckRequest {

    let token : String
    let pinCode : String
    let countryCode : String?
    let phoneNumber : String
    
    init(token: String, pinCode: String, countryCode: String?, phoneNumber: String) {
        self.token = token
        self.pinCode = pinCode
        self.countryCode = countryCode
        self.phoneNumber = phoneNumber
    }
    
    convenience init(verifyTask: VerifyTask, pinCode: String) {
        self.init(token: verifyTask.token, pinCode: pinCode, countryCode: verifyTask.countryCode, phoneNumber: verifyTask.phoneNumber)
    }
}