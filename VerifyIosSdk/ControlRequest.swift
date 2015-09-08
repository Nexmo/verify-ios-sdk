//
//  ControlRequest.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 07/08/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation

class ControlRequest : Equatable {

    let command : String
    let phoneNumber : String
    let countryCode : String?
    
    init(_ command: ControlCommand, verifyTask: VerifyTask) {
        self.command = command.rawValue
        self.phoneNumber = verifyTask.phoneNumber
        self.countryCode = verifyTask.countryCode
    }
    
    enum ControlCommand : String {
        case Cancel = "cancel"
        case NextEvent = "trigger_next_event"
    }
}

func ==(lhs: ControlRequest, rhs: ControlRequest) -> Bool {
    return (lhs.command == rhs.command &&
            lhs.phoneNumber == rhs.phoneNumber &&
            lhs.countryCode == rhs.countryCode)
}