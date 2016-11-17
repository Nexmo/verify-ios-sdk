//
//  AppDelegate.swift
//  verify-ios-test-app
//
//  Created by Dorian Peake on 23/06/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

import UIKit
import NexmoVerify

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // Your parameters go here! see https://dashboard.nexmo.com/verify
    private let applicationId = "YOUR_APP_KEY"
    private let sharedSecretKey = "YOUR_SECRET_KEY"
    
    // MARK:
    // MARK: UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        NexmoClient.start(applicationId: applicationId, sharedSecretKey: sharedSecretKey)
 
        return true
    }
}
