//
//  RequestSigning.h
//  NexmoRequestSigning
//
//  Created by Dorian Peake on 28/07/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

@import Foundation;
@import UIKit;

#import "RequestSigner.h"

@interface SDKRequestSigner : NSObject <RequestSigner>

+(SDKRequestSigner*)sharedInstance;

-(NSString*)md5HashWithData:(NSData*)data;
-(NSString*)generateSignatureWithParams:(NSDictionary*)params sharedSecretKey:(NSString*)secretKey;
-(bool)validateSignatureWithSignature:(NSString*)signature params:(NSDictionary*)params sharedSecretKey:(NSString*)secretKey;
-(bool)allowedTimestamp:(NSString*)timestamp;

@end
