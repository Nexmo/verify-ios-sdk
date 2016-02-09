//
//  Countries.swift
//  VerifyIosSdk
//
//  Created by Dorian Peake on 23/11/2015.
//  Copyright © 2015 Nexmo Inc. All rights reserved.
//

import Foundation

public class Countries {

    public static let list = (NSDictionary(contentsOfFile: NSBundle(forClass: VerifyClient.self).pathForResource("Countries", ofType: "plist")!) as! [String : AnyObject])["country_list"] as! [[String: AnyObject]]
}