//
//  RequestSigner.h
//  NexmoVerify
//
//  Created by Dorian Peake on 13/08/2015.
//  Copyright (c) 2015 Nexmo Inc. All rights reserved.
//

@protocol RequestSigner <NSObject>

-(NSString*)md5HashWithData:(NSData*)data;
-(NSString*)generateSignatureWithParams:(NSDictionary*)params sharedSecretKey:(NSString*)secretKey;
-(bool)validateSignatureWithSignature:(NSString*)signature params:(NSDictionary*)params sharedSecretKey:(NSString*)secretKey;
-(bool)allowedTimestamp:(NSString*)timestamp;

@end
