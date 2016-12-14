//
//  AppConfigurator.swift
//  VerifyIosSdk_Example_PushEnabled
//
//  Created by Shams Ahmed on 14/11/2016.
//  Copyright © 2016 Nexmo Inc. All rights reserved.
//

import UIKit

struct AppConfigurator {

    internal enum AppError: Error {
        case invalidClientSetup
    }
    
    // MARK:
    // MARK: Notification
    
    internal func registerPushNotitications() {
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        
        UIApplication.shared.registerUserNotificationSettings(settings)
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    // MARK:
    // MARK: Validation
    
    internal func isClientSetup(applicationId: String, secretKey: String) throws {
        guard applicationId != "YOUR_APP_KEY",
            secretKey != "YOUR_SECRET_KEY",
            !applicationId.isEmpty,
            !secretKey.isEmpty else {
                throw AppError.invalidClientSetup
        }
    }
}
