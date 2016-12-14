//
//  AppDelegate.swift
//  Test Push
//
//  Created by Dorian Peake on 09/10/2015.
//  Copyright © 2015 Nexmo Inc. All rights reserved.
//

import UIKit
import NexmoVerify

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let configurator = AppConfigurator()

    // Your parameters go here, see https://dashboard.nexmo.com/verify/sdk/your-apps
    private let applicationId = "YOUR_APP_KEY"
    private let secretKey = "YOUR_SECRET_KEY"
    
    // MARK:
    // MARK: UIApplicationDelegate - Launch
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        configurator.registerPushNotitications()
        
        guard let _ = try? configurator.isClientSetup(applicationId: applicationId, secretKey: secretKey) else {
            fatalError("Client not setup, pleae enter your application id and secret key above!")
        }
        
        NexmoClient.start(applicationId: applicationId, sharedSecretKey: secretKey)
        
        return true
    }

    // MARK:
    // MARK: UIApplicationDelegate - Notification
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        NexmoClient.setPushToken(deviceToken)
        print("device token: \(NexmoClient.sharedInstance.pushToken)")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed register notifications: \(error)")
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if VerifyClient.handleNotification(userInfo) {
            // Verification handled successfully
        }
    }
}
