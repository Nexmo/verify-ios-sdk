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

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

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

-(NSString*)getIpAddress:(BOOL)preferIPv4 {
    NSArray *searchArray = preferIPv4 ?
    @[ /*IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6,*/ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ /*IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4,*/ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    
    __block NSString *address;
    
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        address = addresses[key];
        
        if (address) {
            *stop = YES;
        }
     }];
    
    return address ? address : nil;
}

- (NSDictionary *)getIPAddresses {
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    
    if(!getifaddrs(&interfaces)) {
        struct ifaddrs *interface;
        
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        
        // Free memory
        freeifaddrs(interfaces);
    }
    
    return [addresses count] ? addresses : nil;
}

/**
    Add Device IP Address to a dictionary of parameters
    
    @param params An NSMutableDictionary to store the parameter
    
    @param key The key value which the IP Address will be stored under
    
    @return true if success, false otherwise
*/
-(bool)addIpAddressToParams:(NSMutableDictionary*)params withKey:(NSString*)key {
    NSString *ipAddress = [self getIpAddress:true];
    
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
NSString *NSStringFromOSStatus(OSStatus errCode) {
    if (errCode == noErr) {
        return @"noErr";
    }
    
    char message[5] = {0};
    *(UInt32*) message = CFSwapInt32HostToBig(errCode);
    
    return [NSString stringWithCString:message encoding:NSASCIIStringEncoding];
}

@end
