//
//  NetworkTools.m
//  NexmoVerify
//
//  Created by Dorian Peake on 02/06/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

@import Foundation;
@import UIKit;

#import "ifaddrs.h"
#import "arpa/inet.h"
#import <net/if.h>
#import <netdb.h>

#import "SDKDeviceProperties.h"

@implementation SDKDeviceProperties

/// Identifier for Nexmo keychain
static NSString *NEXMO_UID_NAME = @"NexmoUniqueDeviceIdentifier";
static SDKDeviceProperties *instance;

+(SDKDeviceProperties*)sharedInstance {
    if (instance == nil) {
        instance = [[SDKDeviceProperties alloc] init];
    }
    
    return instance;
}

/**
    Get an IP Address for the current device
    
    @return NSString containing dot notation IP address
*/
-(NSString*)getIpAddress {
    NSString *address = NULL;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET &&
                temp_addr->ifa_flags & IFF_RUNNING &&
                temp_addr->ifa_flags & IFF_UP &&
                !(temp_addr->ifa_flags & IFF_LOOPBACK)) {
                // Get NSString from C String
                address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                break;
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

/**
    Add Device IP Address to a dictionary of parameters
    
    @param params An NSMutableDictionary to store the parameter
    
    @param key The key value which the IP Address will be stored under
    
    @return true if success, false otherwise
*/
-(bool)addIpAddressToParams:(NSMutableDictionary*)params withKey:(NSString*)key {
    NSString *ipAddress = [self getIpAddress];
    if (ipAddress == nil) {
        return false;
    }
    
    [params setObject:ipAddress forKey:key];
    return true;
}

/** 
    Get current unique device identifier, or create a new one.
 
    Note from Keychain Services Programming Guide:

    iOS: The iOS gives an application access to only its own keychain items. The keychain access controls discussed in this section do not apply to iOS.

    This could mean two things:
 
    1. The duid provided is specific to this app, therefore different apps using Nexmo verification will turn up as different devices.
 
    2. The duid provided is specific to this framework, therefore different apps using Nexmo verification will turn up as the same device, using this linked framework (assuming it is deployed as a cocoa touch framework).
    
    I am almost 99% confident it is number 1.
    
    @return NSString* containing a unique device identifier
*/
-(NSString*)getUniqueDeviceIdentifierAsString {
    
    NSMutableDictionary *queryDict = [[NSMutableDictionary alloc] init];
    [queryDict setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [queryDict setObject:[NEXMO_UID_NAME dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecAttrService];
    [queryDict setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [queryDict setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
    CFDataRef idResult = nil;
    OSStatus keychainError = noErr;
    
    keychainError = SecItemCopyMatching((__bridge CFDictionaryRef)queryDict, (CFTypeRef *)&idResult);
        
    if (keychainError == errSecSuccess) {
        NSString *identifier = [[NSString alloc] initWithBytes:[(__bridge_transfer NSData*)idResult bytes] length:[(__bridge NSData*)idResult length] encoding:NSUTF8StringEncoding];
        return identifier;
    } else if (keychainError == errSecItemNotFound) {
        // generate new identifier
        NSString *deviceId = [self addUniqueDeviceIdentifierToKeychain];
        
        return deviceId;
        
    } else {
        return nil;
    }
}

-(NSString*)addUniqueDeviceIdentifierToKeychain {
    NSUUID *newId = [[UIDevice currentDevice] identifierForVendor];
    NSData *newIdData = [[newId UUIDString] dataUsingEncoding:NSUTF8StringEncoding];

    NSMutableDictionary *keychainData = [[NSMutableDictionary alloc] init];
    [keychainData setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [keychainData setObject:@"Nexmo UID" forKey:(__bridge id)kSecAttrLabel];
    [keychainData setObject:@"Unique Identifier for Nexmo Services" forKey:(__bridge id)kSecAttrDescription];
    [keychainData setObject:@"-no-data-" forKey:(__bridge id)kSecAttrAccount];
    [keychainData setObject:[NEXMO_UID_NAME dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecAttrService];
    [keychainData setObject:@"-no-data-" forKey:(__bridge id)kSecAttrComment];
    [keychainData setObject:newIdData forKey:(__bridge id)kSecValueData];

    OSStatus keychainError = SecItemAdd((__bridge CFDictionaryRef)keychainData, NULL);

    if (keychainError == noErr) {
        return [newId UUIDString];
    } else {
        return nil;
    }
}

/**
    Add Device Identifier to a dictionary of parameters
    
    @param params An NSMutableDictionary to store the parameter
    
    @param key The key value which the Device Identifier will be stored under
    
    @return true if success, false otherwise
*/
-(bool)addDeviceIdentifierToParams:(NSMutableDictionary*)params withKey:(NSString*)key {
    NSString *deviceIdentifier = [self getUniqueDeviceIdentifierAsString];
    if (deviceIdentifier == nil) {
        return false;
    }
    
    [params setObject:deviceIdentifier forKey:key];
    return true;
}

/**
    Delete unique device identifier from keychain
    
    @return bool specifying whether the key was successfully deleted
*/
-(bool)deleteUniqueDeviceIdentifier {
    NSMutableDictionary *queryDict = [[NSMutableDictionary alloc] init];
    [queryDict setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [queryDict setObject:[NEXMO_UID_NAME dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecAttrService];
    
    OSStatus keychainError = SecItemDelete((__bridge CFDictionaryRef)queryDict);
    
    if (keychainError == noErr) {
        return true;
    } else if (keychainError == errSecItemNotFound) {
        return true;
    }
    
    return false;
}

/**
    Convert OSStatus to NSString
    
    Useful for debugging
    
    @return An NSString representation of the OSStatus
*/
NSString *NSStringFromOSStatus(OSStatus errCode)
{
    if (errCode == noErr)
        return @"noErr";
    char message[5] = {0};
    *(UInt32*) message = CFSwapInt32HostToBig(errCode);
    return [NSString stringWithCString:message encoding:NSASCIIStringEncoding];
}

@end
