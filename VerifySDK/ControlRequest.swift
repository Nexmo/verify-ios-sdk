//
//  ControlRequest.swift
//  NexmoVerify
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
        case cancel = "cancel"
        case nextEvent = "trigger_next_event"
    }
}

/// Validate control request is the same
///
/// - Parameters:
///   - lhs: lhs
///   - rhs: rhs
/// - Returns: result
func ==(lhs: ControlRequest, rhs: ControlRequest) -> Bool {
    return (lhs.command == rhs.command &&
            lhs.phoneNumber == rhs.phoneNumber &&
            lhs.countryCode == rhs.countryCode)
}
