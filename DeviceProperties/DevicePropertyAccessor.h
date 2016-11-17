//
//  DevicePropertyAccessor.h
//  NexmoVerify
//
//  Created by Dorian Peake on 13/08/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

@protocol DevicePropertyAccessor

-(NSString*)getIpAddress;
-(NSString*)getUniqueDeviceIdentifierAsString;
-(bool)deleteUniqueDeviceIdentifier;
-(NSString*)addUniqueDeviceIdentifierToKeychain;
-(bool)addIpAddressToParams:(NSMutableDictionary*)params withKey:(NSString*)key;
-(bool)addDeviceIdentifierToParams:(NSMutableDictionary*)params withKey:(NSString*)key;

@end
