//
//  RequestSigningTests.m
//  RequestSigningTests
//
//  Created by Dorian Peake on 28/07/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SDKRequestSigner.h"
@interface RequestSigningTests : XCTestCase

@end

@implementation RequestSigningTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testMd5HashWithDataGeneratesCorrectMd5Hash {
    NSDictionary *md5HashPairs = [NSDictionary dictionaryWithObjectsAndKeys:
        @"900150983cd24fb0d6963f7d28e17f72", @"abc",
        @"8215ef0796a20bcaaae116d3876c664a", @"abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
        @"7707d6ae4e027c70eea2a935c2296f21", [@"" stringByPaddingToLength:1000000 withString:@"a" startingAtIndex:0], nil];
    id<RequestSigner> requestSigner = [[SDKRequestSigner alloc] init];
    
    for (NSString* key in md5HashPairs) {
        NSString *digest = [requestSigner md5HashWithData:[key dataUsingEncoding:NSUTF8StringEncoding]];
        XCTAssertEqualObjects(digest, (NSString*)[md5HashPairs objectForKey: key], "Wrong digest generated");
    }
}

-(void)testSdkRequestSignerGeneratesCorrectSignature {
    NSString *appSecret = @"12345";
    NSString *expectedSignature = @"20e40bd8db26b1685c9fa3920e89ae90";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
        @"value1", @"key1",
        @"value&=2", @"key2",
        @"value3+lives+here%2f", @"key_3",
        @"mysignature  ", @"sig", nil];
    id<RequestSigner> requestSigner = [[SDKRequestSigner alloc] init];
    NSString *signature = [requestSigner generateSignatureWithParams:params sharedSecretKey:appSecret];
    XCTAssertEqualObjects(expectedSignature, signature, "Wrong signaure generated");
}

@end
