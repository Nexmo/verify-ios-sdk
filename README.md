The Nexmo Verify SDK for iOS
============

You use Nexmo Verify to check that a person has access to a specific phone number.

To complete phone verification:

1. Verify sends a PIN in an SMS and/or Text-to-speech (TTS) call to your user.

    > You can also enable Google Cloud Messaging (GCM) in order to send a PIN using push notifications.

2. The user enters this PIN into your app or website.
3. You use Verify to check that the PIN entered by your user is the one you sent.

Using Verify SDK for iOS you easily integrate Verify functionality into your iOS app. With the Verify SDK for iOS, you enter the user's phone number and the SDK completes verification for you.

In order to integrate the Verify SDK for iOS in your app, see:
* [Setting up your environment](https://docs.nexmo.com/sdks/verify-sdk/verify-sdk-for-iOS/prerequisites): before you start coding, create a Verify SDK app in the Dashboard and configure Android Studio.
* [Integrate Verify SDK for iOS](https://docs.nexmo.com/sdks/verify-sdk/verify-sdk-for-iOS/integration): create and run your first app.
* [Verify SDK for iOS sample app](https://docs.nexmo.com/sdks/verify-sdk/verify-sdk-for-iOS/verify-sample): integrate and run a more complete app.
* [Configuring GCM push](https://docs.nexmo.com/sdks/verify-sdk/verify-sdk-for-iOS/integrating-gcm-push): create and use a GCM token in your app.
* [Verify SDK for iOS push enabled sample app](https://docs.nexmo.com/sdks/verify-sdk/verify-sdk-for-iOS/verify-push-sample): integrate and run a more complete app with GCM.
* [Verify SDK for iOS, advanced use](https://docs.nexmo.com/sdks/verify-sdk/verify-sdk-for-iOS/advanced): use the advanced features in Verify SDK for iOS.
* [Example configurations](https://docs.nexmo.com/sdks/verify-sdk/verify-sdk-for-iOS/example-configurations): configurations for different types of app.

Feel free to checkout the [Verify iOS SDK codebase] (https://github.com/Nexmo/verify-ios-sdk/blob/master/VerifyIosSdk) if you wish to contribute to our open source library.

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
