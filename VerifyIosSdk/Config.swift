//
//  Config.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 04/06/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

import Foundation
import UIKit

/**
    Contains global information relevant to the SDK, such as version number of the SDK
    and the device
*/
class Config {
    // Device and SDK information 
    static let sdkVersion = "0.1"
    static let osFamily = UIDevice.currentDevice().systemName
    static let osRevision = UIDevice.currentDevice().systemVersion
    
    /** Endpoint for all sdk services */
    static let ENDPOINT_PRODUCTION = "https://api.nexmo.com/sdk"
}
