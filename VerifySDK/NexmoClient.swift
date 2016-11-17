//
//  NexmoClient.swift
//  verify-ios-sdk
//
//  Created by Dorian Peake on 13/05/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

import Foundation

/**
    Nexmo Client more information
*/
@objc open class NexmoClient: NSObject {

    /// Application Id
    public var applicationId: String
    
    /// Application Secret Key
    public var sharedSecretKey: String
    
    /// SDK Token
    internal var sdkToken: String!
    
    /// Device token
    public var pushToken: String?
    
    // MARK:
    // MARK: Static
    
    /// Nexmo client shared instance
    public static let sharedInstance = NexmoClient(applicationId: Config.APP_ID ?? "", sharedSecretKey: Config.SECRET_KEY ?? "")
    
    // MARK:
    // MARK: Init
    
    private init(applicationId: String, sharedSecretKey: String, pushToken: String?) {
        self.applicationId = applicationId
        self.sharedSecretKey = sharedSecretKey
        self.pushToken = pushToken
       
        super.init()
    }
    
    private convenience init(applicationId: String, sharedSecretKey: String) {
        self.init(applicationId: applicationId, sharedSecretKey: sharedSecretKey, pushToken: nil)
    }
    
    // MARK:
    // MARK: Start
    
    /**
        Start the NexmoClient. This is required for all other Nexmo Clients, e.g. VerifyClient
        
        - parameter applicationId: your application id/key

        - parameter sharedSecretKey: your shared secret key
    */
    @objc(startWithApplicationId:sharedSecretKey:)
    open static func start(applicationId: String, sharedSecretKey: String) {
        let instance = NexmoClient.sharedInstance
    
        instance.applicationId = applicationId
        instance.sharedSecretKey = sharedSecretKey
    }
    
    /**
        Start the NexmoClient. This is required for all other Nexmo Clients, e.g. VerifyClient
        
        - parameter applicationId: your application id/key

        - parameter sharedSecretKey: your shared secret key
        
        - parameter pushToken: Push notification registration token of the device. Used for Verification via push notification.
    */
    @objc(startWithApplicationId:sharedSecretKey:pushToken:)
    open static func start(applicationId: String, sharedSecretKey: String, pushToken: String) {
        let instance = NexmoClient.sharedInstance
        
        instance.applicationId = applicationId
        instance.sharedSecretKey = sharedSecretKey
        instance.pushToken = pushToken
    }
    
    // MARK:
    // MARK: Push Notification
    
    /**
        Set the Push notification token in the Nexmo Client to enable verification via push notification.
        
        - parameter pushToken: Push notification registration token
    */
    @objc(setPushToken:)
    open static func setPushToken(_ pushToken: Data) {
        NexmoClient.sharedInstance.pushToken = pushToken.hexString
    }
}
