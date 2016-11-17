//
//  DeviceProperties.h
//  DeviceProperties
//
//  Created by Dorian Peake on 28/07/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

@import UIKit;

#import "DevicePropertyAccessor.h"

@interface SDKDeviceProperties : NSObject <DevicePropertyAccessor>

+(SDKDeviceProperties*)sharedInstance;
-(NSString*)getIpAddress;
-(NSString*)getUniqueDeviceIdentifierAsString;
-(bool)deleteUniqueDeviceIdentifier;
-(bool)addIpAddressToParams:(NSMutableDictionary*)params withKey:(NSString*)key;
-(bool)addDeviceIdentifierToParams:(NSMutableDictionary*)params withKey:(NSString*)key;

@end
