//
//  DevicePropertiesTests.m
//  DevicePropertiesTests
//
//  Created by Dorian Peake on 28/07/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SDKDeviceProperties.h"
#import <arpa/inet.h>

@interface DevicePropertiesTests : XCTestCase

@end

@implementation DevicePropertiesTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAddsIpAddressToParameters {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *key = @"source_ip";
    id <DevicePropertyAccessor> deviceProperties = [[SDKDeviceProperties alloc] init];
    [deviceProperties addIpAddressToParams: params withKey:key];
    XCTAssert(([params objectForKey:key] != nil), "IP Address not added");
}

- (void)testAddsDeviceIdentifierToParameters {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *key = @"key";
    id <DevicePropertyAccessor> deviceProperties = [[SDKDeviceProperties alloc] init];
    [deviceProperties addDeviceIdentifierToParams:params withKey:key];
    XCTAssert(([params objectForKey:key] != nil), "Device Identifier not added");
}

@end
