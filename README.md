VerifyIosSdk
============

    Nexmo Verify SDK(beta version) for iOS.
Nexmo Verify enables you to verify whether one of your end users has access to a specific phone number by challenging them with a PIN code to enter into your application or website. This PIN code is delivered by Nexmo via SMS and/or Text-To-Speech call. Your end users then enter this code into your application and subsequently, you can check through Verify if the code entered matches the one which was sent to the user. This completes a phone verification successfully.

The Nexmo Verify SDK for iOS enables you to build Verify into your mobile Application by simplifying this integration. If you import this framework into your application, you simply need the user's phone number and the SDK will take care of the various steps required to verify your users.

## Installation

### Embedded Framework

- Add VerifyIosSdk as a submodule by opening the Terminal, `cd`-ing into your top-level project directory, and entering the following command:

```bash
$ git submodule add https://github.com/nexmo/verify-ios-sdk.git
```

- Open the new `verify-ios-sdk` folder, and drag the `VerifyIosSdk.xcodeproj` into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your applications blue project icon. Whether it is above or below all the other Xcode groups does not matter.

- Select the `VerifyIosSdk.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the `Targets` heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- You will two different `VerifyIosSdk.xcodeproj` each containing the files `VerifyIosSdk.framework`, `DeviceProperties.framework` and `RequestSigning.framework`, nested inside a `Products` folder.

    > It does not matter which `Products` folder you choose from.

- Select each of the three files listed above.

    > If you are importing the SDK into an Objective-C based application you must also navigate to your target's Build Settings and enable `Embedded Content Contains Swift Code` under `Build Options`.

- And that's it!

    > The framework files are automagically added as a target dependencies, linked frameworks and embedded frameworks in a copy files build phase which is all you need to build on the simulator and a device.

## Getting Started

1. You need a Nexmo account to use the SDK. Register for one (if you don't have it already) at https://dashboard.nexmo.com/register
2. In order to safeguard your Nexmo credentials, all interaction between your application and Nexmo services requires an Application Key and Shared Secret to be configured per application that you are building the SDK into. As we are in the early stages of the Beta, please send us an email at: productfeedback@nexmo.com and we will set up an application ID and a Shared Secret Key for your application.  We're working to allow you to setup a new Application using the Customer Dashboard where you will be able to obtain an ApplicationId and SharedSecretKey - Watch out for it in an upcoming update.
3. Download the Nexmo Verify SDK (as instructed above).

Creating a new Nexmo Client:

**Swift**
```swift
import VerifyIosSdk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Start up the NexmoClient with your application key(id) and your shared secret key
        NexmoClient.start(applicationId: "abcde", sharedSecretKey: "12345")

        // ..
    }

    // ..
}

// ..
```

**Objective-C**
```objective-c
import VerifyIosSdk;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Start up the NexmoClient with your application key(id) and your shared secret key
    [NexmoClient startWithApplicationId:@"abcde" sharedSecretKey:@"12345"];

    // ..
}

// ..
```

Now we're ready to begin making verification requests. A new verification is initiated using a supplied country code and phone number and some callbacks for verification progress updates.

**Swift**
```swift
VerifyClient.getVerifiedUser(countryCode: "GB", phoneNumber: "07000000000",
    onVerifyInProgress: {
        // called when the verification process begins
    },
    onUserVerified: {
        // called when the user has been successfully verified
    },
    onError: { (error: VerifyError) in
        // called when some error occurrs during verification, e.g. wrong pin entered.
        // see the VerifyError class for details on what to expect
    }
)
```

**Objective-C**
```objective-c
[VerifyClient getVerifiedUserWithCountryCode:@"GB" phoneNumber:@"07000000000"
    verifyInProgressBlock:^{
        // called when the verification process begins
    }
    userVerifiedBlock:^{
        // called when the user has been successfully verified
    }
    errorBlock:^(VerifyError error) {
        // called when some error occurrs during verification, e.g. wrong pin entered.
        // see the VerifyError class for details on what to expect
    }
];
```

The phone number provided may be in national or international format, however a country code must be specified for the former.

Once the verification has successfully started `onVerifyInProgress()`(Swift) or `verifyInProgressBlock()`(Obj-C) is invoked.

If the verification cannot be started or some other error occurs during verification, `onError(errorCode)`(Swift) or `errorBlock(errorCode)`(Obj-C) is invoked describing the error. You can have a look the VerifyError class and Swiftdocs for the kind of errors you may encounter.

Once the PIN has been suplied to the end user, it may be checked using the VerifyClient:
**Swift**
```swift
VerifyClient.checkPinCode("1234")
```

**Objective-C**
```objective-c
[VerifyClient checkPinCode:@"1234"];
```

A successful verification is completed once the `onUserVerified`(Swift) or `userVerifiedBlock`(Obj-C) has been invoked.

Verify SDK generates an SMS to verify a user if the user has not yet been verified. Once users are verified, Verify maintains this state on the server. By default, any change in the combination - Device ID + Application ID + Phone Number is considered a new user and will be explicitly verified by 2FA. Once verified, users remain verified on the server for 30 days. We're working on enabling the following customisations in a future version of the library:
- If we should disregard either or both of Device ID and Application ID 
- if a user should be reverified every time, never, or a custom duration (other than 30 days) in between
- Query the state of a user on the server
- Change the state of the user object from Verified to Unverified, Blacklisted etc.

Please note that sensitive user details, like the phone number will NOT be stored locally at any time.

## Advanced

### Cancel Verification

An ongoing verification can be cancelled, for example if a user no longer wishes to perform the verification. A cancelled verification will not send any further verification SMS or TTS requests to the device.

To cancel a verification request, call the `cancelVerification`(Swift) or `cancelVerificationWithBlock`(Obj-C) function:

**Swift**
```swift
VerifyClient.cancelVerification() { error in
    if let error = error {
        // something wen't wrong whilst attempting to cancel the current verification request
        return
    }

    // verification request successfully cancelled
}
```

**Objective-C**
```objective-c
[VerifyClient cancelVerificationWithBlock:^(NSError *error) {
    if (error != nil) {
        // something wen't wrong whilst attempting to cancel the current verification request
        return;
    }

    // verification request successfully cancelled
}];
```

### Trigger Next Verification Event

The verification workflow may be sped-up by triggering the next workflow event early. For instance in an `SMS -> TTS -> TTS` workflow, at the SMS stage, the `TTS` event may be triggered early by calling the `triggerNextEvent`(Swift) or `triggerNextEventWithBlock`(Obj-C) function:

**Swift**
```swift
VerifyClient.triggerNextEvent() { error in
    if let error = error {
        // unable to trigger next event
        return
    }

    // successfully triggered next event
}
```

**Objective-C**
```objective-c
[VerifyClient triggerNextEventWithBlock:^(NSError *error) {
    if (error != nil) {
        // unable to trigger next event
        return;
    }

    // successfully triggered next event
}];
```

### Logout

A user can be logged out to reset their verification status. Subsequent verification requests will no longer return a `verified` response directly, but instead will execute the entire verification workflow again. A logout request may be triggered by calling `logoutUser`(Swift) or `logoutUserWithBlock`(Objective-C):

**Swift**
```swift
VerifyClient.logoutUser() { error in
    if let error = error {
        // unable to logout user
        return
    }

    // successfully logged out user
}
```

**Objective-C**
```objective-c
[VerifyClient triggerNextEventWithBlock:^(NSError *error) {
    if (error != nil) {
        // unable to logout user
        return;
    }

    // successfully logged out user
}];
```

### Search User Status

A user's current verification status may be queried by calling the `getUserStatus`(Swift) or `getUserStatusWithNumber:WithBlock:`(Objective-C) function. The user status function takes into account the current device the function is being executed on, therefore you may only query the status of the user associated with the current (device ID, phone number) pair.

```swift
VerifyClient.getUserStatus(countryCode: "GB", number: "447777777777") { status, error in
    if let error = error {
        // unable to get user status for given device + phone number pair
        return
    }

    switch (status!) {
        case "pending":
    }
}
```

**Objective-C**
```objective-c
[VerifyClient getUserStatusWithCountryCode:@"GB" withNumber:@"447777777777" withBlock:^(NSString *status, NSError *error) {
    if (error != nil) {
        // unable to get user status
        return;
    }

    if ([status isEqualToString:UserStatus.USER_UNKNOWN]) {
        // user has never before been verified
        // ..

    } else if (status isEqualToString:UserStatus.USER_PENDING) {
        // a verification request is currently in progress for this user
        // ..

    }

    // other user statuses can be found in the UserStatus class
    //..
}];
```

All the user statuses are stored within the `UserStatus` class so you can test against any value in that class with a similar `if`/`switch` statement as shown above.

License
=======

Copyright (c) 2015 Nexmo, Inc.
All rights reserved.
Licensed only under the Nexmo Verify SDK License Agreement (the "License") located at

	https://www.nexmo.com/terms-use/verify-sdk/

By downloading or otherwise using our software or services, you acknowledge
that you have read, understand and agree to be bound by the 
[Nexmo Verify SDK License Agreement][1] and [Privacy Policy][2].
    
You may not use, exercise any rights with respect to or exploit this SDK,
or any modifications or derivative works thereof, except in accordance with the License.

 [1]: https://www.nexmo.com/terms-use/verify-sdk/
 [2]: https://www.nexmo.com/privacy-policy/

## Author

Dorian Peake, dorian@nexmo.com
