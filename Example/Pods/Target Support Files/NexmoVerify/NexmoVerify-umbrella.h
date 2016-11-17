#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NexmoVerify.h"
#import "DevicePropertyAccessor.h"
#import "NexmoDeviceProperties.h"
#import "SDKDeviceProperties.h"
#import "NexmoRequestSigning.h"
#import "RequestSigner.h"
#import "SDKRequestSigner.h"

FOUNDATION_EXPORT double NexmoVerifyVersionNumber;
FOUNDATION_EXPORT const unsigned char NexmoVerifyVersionString[];

