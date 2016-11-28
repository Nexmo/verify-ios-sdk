//
//  DevicePropertiesMock.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 30/08/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import Foundation
@testable import NexmoVerify

class DevicePropertiesMock : NSObject, DevicePropertyAccessor {

    func getIpAddress() -> String! {
        return "1.1.1.1"
    }
    
    func getUniqueDeviceIdentifierAsString() -> String! {
        return "some_duid"
    }
    
    func deleteUniqueDeviceIdentifier() -> Bool {
        return true
    }
    
    func addIpAddress(toParams params: NSMutableDictionary!, withKey key: String!) -> Bool {
        params.setObject("1.1.1.1", forKey: key as NSCopying)
        return true
    }
    
    func addDeviceIdentifier(toParams params: NSMutableDictionary!, withKey key: String!) -> Bool {
        params.setObject("some_duid", forKey: key as NSCopying)
        return true
    }

    func addUniqueDeviceIdentifierToKeychain() -> String! {
        return ""
    }
}
