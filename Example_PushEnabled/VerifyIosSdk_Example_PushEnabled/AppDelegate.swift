//
//  AppDelegate.swift
//  Test Push
//
//  Created by Dorian Peake on 09/10/2015.
//  Copyright © 2015 Nexmo Inc. All rights reserved.
//

import UIKit
import VerifyIosSdk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GGLInstanceIDDelegate {

    var window: UIWindow?
    var pageViewController : VerifyPageViewController!

    // Your parameters go here!
    private var gcmSenderId = "SENDER_ID"
    private var applicationId = "YOUR_APP_KEY"
    private var sharedSecretKey = "YOUR_SECRET_KEY"
    
    var registrationOptions : [ String : AnyObject ]!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Register for Push Notitications
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()

        // Start Nexmo Client
        NexmoClient.start(applicationId: applicationId, sharedSecretKey: sharedSecretKey)
        return true
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        // Initialise GCM
        let instanceIDConfig = GGLInstanceIDConfig.defaultConfig()
        instanceIDConfig.delegate = self

        // Start the GGLInstanceID shared instance with that config and request a registration
        // token to enable reception of notifications
        GGLInstanceID.sharedInstance().startWithConfig(instanceIDConfig)
        registrationOptions = [kGGLInstanceIDRegisterAPNSOption:deviceToken,
          kGGLInstanceIDAPNSServerTypeSandboxOption:true]
        GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity(gcmSenderId,
          scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: self.handleGcmToken)
        print("registered for push notifications")
    }

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        if (VerifyClient.handleNotification(userInfo, performSilentCheck: false)) {
            // verification handled successfully
            return
        }
    }

    func onTokenRefresh() {
        // A rotation of the registration tokens is happening, so the app needs to request a new token.
        print("The GCM registration token needs to be changed.")
        GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity(gcmSenderId,
          scope: kGGLInstanceIDScopeGCM, options: registrationOptions, handler: self.handleGcmToken)
    }

    func handleGcmToken(token: String!, error: NSError!) {
        if let error = error {
            print("failed to get gcm token with error \(error.localizedDescription)")
        } else {
            print("gcm token:\n\(token)")

            // provide nexmo client with gcm token
            NexmoClient.setGcmToken(token)
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

