//
//  NexmoClient.swift
//  verify-ios-sdk
//
//  Created by Dorian Peake on 13/05/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

import Foundation

/**
    Contains core information relevant to all Nexmo services
*/
@objc public class NexmoClient : NSObject {

    private static var instance : NexmoClient?
    
    let applicationId : String
    let sharedSecretKey : String
    var sdkToken : String!
    var gcmToken : String?
    
    static var sharedInstance : NexmoClient {
        get {
            if let instance = instance {
                return instance
            }
            
            instance = NexmoClient(applicationId: Config.APP_ID ?? "", sharedSecretKey: Config.SECRET_KEY ?? "")
            return instance!
        }
    }
    
    init(applicationId: String, sharedSecretKey: String, gcmToken: String?) {
        self.applicationId = applicationId
        self.sharedSecretKey = sharedSecretKey
        self.gcmToken = gcmToken
        super.init()
    }
    
    convenience init(applicationId: String, sharedSecretKey: String) {
        self.init(applicationId: applicationId, sharedSecretKey: sharedSecretKey, gcmToken: nil)
    }
    
    /**
        Start the NexmoClient. This is required for all other Nexmo Clients, e.g. VerifyClient
        
        - parameter applicationId: your application id/key

        - parameter sharedSecretKey: your shared secret key
    */
    @objc(startWithApplicationId:sharedSecretKey:)
    public static func start(applicationId applicationId: String, sharedSecretKey: String) {
        NexmoClient.instance = NexmoClient(applicationId: applicationId, sharedSecretKey: sharedSecretKey)
    }
    
    /**
        Start the NexmoClient. This is required for all other Nexmo Clients, e.g. VerifyClient
        
        - parameter applicationId: your application id/key

        - parameter sharedSecretKey: your shared secret key
        
        - parameter gcmToken: Google Cloud Messaging registration token of the device. Used for Verification via push notification.
    */
    @objc(startWithApplicationId:sharedSecretKey:gcmToken:)
    public static func start(applicationId applicationId: String, sharedSecretKey: String, gcmToken: String) {
        NexmoClient.instance = NexmoClient(applicationId: applicationId, sharedSecretKey: sharedSecretKey, gcmToken: gcmToken)
    }
    
    /**
        Set the Google Cloud Messaging registration token in the Nexmo Client to enable verification via push notification.
        
        - parameter gcmToken: The Google Cloud Messaging registration token
    */
    @objc(setGcmToken:)
    public static func setGcmToken(gcmToken: String) {
        NexmoClient.sharedInstance.gcmToken = gcmToken
    }
}
