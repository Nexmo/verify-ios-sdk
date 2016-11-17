//
//  RequestSigning.m
//  NexmoVerify
//
//  Created by Dorian Peake on 03/06/2015.
//  Copyright (c) 2015 Nexmo. All rights reserved.
//

@import Foundation;

#import <CommonCrypto/CommonCrypto.h>
#import "SDKRequestSigner.h"
#import "RequestSigner.h"

/// Collection of static methods for signing requests to Nexmo Servers
@implementation SDKRequestSigner

static SDKRequestSigner *instance;
NSString *PARAM_SIGNATURE = @"sig";
int MAX_ALLOWABLE_TIME_DELTA = 5 * 60; // 5 mins

+(SDKRequestSigner*)sharedInstance {
    if (instance == nil) {
        instance = [[SDKRequestSigner alloc] init];
    }
    
    return instance;
}

/// Create hex encoded MD5 hash of data
-(NSString*)md5HashWithData:(NSData*)data {
    unsigned char digestData[CC_MD5_DIGEST_LENGTH];
    NSMutableString *digest = [[NSMutableString alloc] init];
    CC_MD5(data.bytes, (int32_t)data.length, digestData);
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", digestData[i]];
    }
    
    return [NSString stringWithString:digest];
}

/// Create a request signature with the provided parameters
-(NSString*)generateSignatureWithParams:(NSDictionary*)params sharedSecretKey:(NSString*)secretKey {
    NSString *md5String = [self generateSignatureMessageWithParams:params sharedSecretKey:secretKey];
    NSString *digest = [self md5HashWithData:[md5String dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"signature digest = %@", digest);
    return digest;
}

/// Generate a request signature message (without applying MD5 hash)
-(NSString*)generateSignatureMessageWithParams:(NSDictionary*)params sharedSecretKey:(NSString*)secretKey {
    NSMutableDictionary *mutableParams = [params mutableCopy];
    [mutableParams removeObjectForKey:PARAM_SIGNATURE];
    NSMutableString *result = [[NSMutableString alloc] init];
    [mutableParams removeObjectForKey:PARAM_SIGNATURE];
    for (NSString* key in [[mutableParams allKeys] sortedArrayUsingSelector:@selector(compare:)]) {
        NSString *value = (NSString*)[mutableParams valueForKey:key];
        [result appendFormat:@"&%@=%@", [self cleanParam:key], [self cleanParam:value]];
    }
    
    [result appendString:secretKey];
    NSString *md5String = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"signature message = %@", md5String);
    
    return md5String;
}

/// Validate a signature was generated with the passed parameters
-(bool)validateSignatureWithSignature:(NSString*)signature params:(NSDictionary*)params sharedSecretKey:(NSString*)secretKey {
    NSString *sig = [self generateSignatureWithParams:params sharedSecretKey:secretKey];
    return ([sig isEqualToString:signature]);
}

/// Remove invalid characters from a query string key/value
-(NSString*)cleanParam:(NSString*)param {
    NSError *error;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"[&=]" options:0 error:&error];
    return [regex stringByReplacingMatchesInString:param options:0 range:NSMakeRange(0, [param length]) withTemplate:@"_"];
}

/// Check if timestamp is still valid
-(bool)allowedTimestamp:(NSString*)timestamp {
    NSTimeInterval delta = [[[NSDate alloc] init] timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:[timestamp integerValue]]];
    
    if(fabs(delta) < MAX_ALLOWABLE_TIME_DELTA) {
        return true;
    }
    
    NSLog(@"SECURITY-KEY-VERIFICATION -- BAD-TIMESTAMP ... Timestamp [ %@ ] delta [ %f ] max allowed delta [ %d ]", timestamp, delta, MAX_ALLOWABLE_TIME_DELTA);
    return false;
}

@end
