//
//  DevicePropertiesTests.m
//  DevicePropertiesTests
//
//  Created by Dorian Peake on 28/07/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <arpa/inet.h>

@import NexmoDeviceProperties;

@interface DevicePropertiesTests : XCTestCase

@end

@implementation DevicePropertiesTests

#pragma mark -
#pragma mark - Setup

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark -
#pragma mark - Test

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

- (void)testAddDeviceIdentifierToKeychain {
    id <DevicePropertyAccessor> deviceProperties = [[SDKDeviceProperties alloc] init];
    NSString *deviceId = [deviceProperties addUniqueDeviceIdentifierToKeychain];
    
    XCTAssertTrue([deviceProperties deleteUniqueDeviceIdentifier], @"Error resetting keychain...");
    XCTAssertNotNil(deviceId, "Device identifier came back nil!");
}

- (void)testGetDeviceIdentifierFromKeychain {
    id <DevicePropertyAccessor> deviceProperties = [[SDKDeviceProperties alloc] init];
    XCTAssertTrue([deviceProperties deleteUniqueDeviceIdentifier], @"Error resetting keychain...");
    NSString *deviceId = [deviceProperties addUniqueDeviceIdentifierToKeychain];
    NSString *deviceId2 = [deviceProperties getUniqueDeviceIdentifierAsString];

    XCTAssertEqualObjects(deviceId, deviceId2, @"Device ID's didn't match!");
}

- (void)testDeleteDeviceIdentifierFromKeychain {
    id <DevicePropertyAccessor> deviceProperties = [[SDKDeviceProperties alloc] init];
    [deviceProperties addUniqueDeviceIdentifierToKeychain];
    
    XCTAssertTrue([deviceProperties deleteUniqueDeviceIdentifier], @"Error resetting keychain...");
    XCTAssertTrue([deviceProperties deleteUniqueDeviceIdentifier], @"Error resetting keychain...");
    XCTAssertNotNil([deviceProperties getUniqueDeviceIdentifierAsString]);
}

@end
