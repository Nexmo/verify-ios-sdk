//
//  ControlRequest.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 07/08/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation

class ControlRequest {

    let command : String
    let token : String
    let phoneNumber : String
    let countryCode : String?
    
    init(_ command: ControlCommand, verifyTask: VerifyTask) {
        self.command = command.rawValue
        self.phoneNumber = verifyTask.phoneNumber
        self.countryCode = verifyTask.countryCode
        self.token = verifyTask.token
    }
    
    enum ControlCommand : String {
        case Cancel = "cancel"
        case NextEvent = "trigger_next_event"
    }
}