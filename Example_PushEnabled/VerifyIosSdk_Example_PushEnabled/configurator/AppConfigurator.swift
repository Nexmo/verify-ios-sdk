//
//  AppConfigurator.swift
//  VerifyIosSdk_Example_PushEnabled
//
//  Created by Shams Ahmed on 14/11/2016.
//  Copyright © 2016 Nexmo Inc. All rights reserved.
//

import UIKit

struct AppConfigurator {

    // MARK:
    // MARK: Notification
    
    func registerPushNotitications() {
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        
        UIApplication.shared.registerUserNotificationSettings(settings)
        UIApplication.shared.registerForRemoteNotifications()
    }
}
