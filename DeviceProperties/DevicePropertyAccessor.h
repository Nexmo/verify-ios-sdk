//
//  DevicePropertyAccessor.h
//  VerifyIosSdk
//
//  Created by Dorian Peake on 13/08/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

#ifndef VerifyIosSdk_DevicePropertyAccessor_h
#define VerifyIosSdk_DevicePropertyAccessor_h

@protocol DevicePropertyAccessor

-(NSString*)getIpAddress;
-(NSString*)getUniqueDeviceIdentifierAsString;
-(bool)deleteUniqueDeviceIdentifier;
-(NSString*)addUniqueDeviceIdentifierToKeychain;
-(bool)addIpAddressToParams:(NSMutableDictionary*)params withKey:(NSString*)key;
-(bool)addDeviceIdentifierToParams:(NSMutableDictionary*)params withKey:(NSString*)key;

@end

#endif
