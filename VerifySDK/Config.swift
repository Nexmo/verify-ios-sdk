//
//  Config.swift
//  NexmoVerify
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
    static let sdkVersion = "1.0"
    static let osFamily = UIDevice.current.systemName
    static let osRevision = UIDevice.current.systemVersion
    
    /** Load properties from plist file */
    static let properties = NSDictionary(contentsOfFile: Bundle(for: NexmoClient.self).path(forResource: "SDKProperties", ofType: "plist")!) as! [String : AnyObject]

    static let ENDPOINT_PRODUCTION = Config.properties["ENDPOINT_PRODUCTION"] as! String
    
    static var ENDPOINT_PRODUCTION_URL: URL = {
        guard let url = URL(string: Config.ENDPOINT_PRODUCTION) else { fatalError("NEXMO SDK URL not found") }
        
        return url
    }()
    
    static let APP_ID : String! = Config.properties["APP_ID"] as? String
    static let SECRET_KEY : String! = Config.properties["SECRET_KEY"] as? String
    
    static let TEST_APP_ID : String! = Config.properties["TEST_APP_ID"] as? String
    static let TEST_SECRET_KEY : String! = Config.properties["TEST_SECRET_KEY"] as? String

    
}
