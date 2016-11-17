//
//  Countries.swift
//  NexmoVerify
//
//  Created by Dorian Peake on 23/11/2015.
//  Copyright © 2015 Nexmo Inc. All rights reserved.
//

import Foundation

open class Countries {

    open static let list = (NSDictionary(contentsOfFile: Bundle(for: VerifyClient.self).path(forResource: "Countries", ofType: "plist")!) as! [String : AnyObject])["country_list"] as! [[String: AnyObject]]
}
