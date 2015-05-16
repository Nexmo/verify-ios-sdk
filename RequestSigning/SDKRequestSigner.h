//
//  RequestSigning.h
//  RequestSigning
//
//  Created by Dorian Peake on 28/07/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for RequestSigning.
FOUNDATION_EXPORT double RequestSigningVersionNumber;

//! Project version string for RequestSigning.
FOUNDATION_EXPORT const unsigned char RequestSigningVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <RequestSigning/PublicHeader.h>

#ifndef VerifyIosSdk_CommonCrypto_h
#define VerifyIosSdk_CommonCrypto_h

@import Foundation;
#import "RequestSigner.h"

@interface SDKRequestSigner : NSObject <RequestSigner>

+(SDKRequestSigner*)sharedInstance;

-(NSString*)md5HashWithData:(NSData*)data;
-(NSString*)generateSignatureWithParams:(NSDictionary*)params sharedSecretKey:(NSString*)secretKey;
-(bool)validateSignatureWithSignature:(NSString*)signature params:(NSDictionary*)params sharedSecretKey:(NSString*)secretKey;
-(bool)allowedTimestamp:(NSString*)timestamp;

@end

#endif
