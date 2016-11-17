NexmoVerify iOS
============

[![BuddyBuild](https://dashboard.buddybuild.com/api/statusImage?appID=582daf0a4204e80100cde7d5&branch=master&build=latest)](https://dashboard.buddybuild.com/apps/582daf0a4204e80100cde7d5/build/latest)
[![CocoaPods](https://img.shields.io/cocoapods/v/NexmoVerify.svg)]() 
[![CocoaPods](https://img.shields.io/cocoapods/l/NexmoVerify.svg)]() 
[![CocoaPods](https://img.shields.io/cocoapods/p/NexmoVerify.svg)]() 
[![CocoaPods](https://img.shields.io/cocoapods/metrics/doc-percent/NexmoVerify.svg)]() 
[![Swift](https://img.shields.io/badge/Swift-3.0.X-orange.svg)]()
[![Carthage compatible](https://img.shields.io/badge/Carthage-soon-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) 
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-soon-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Twitter](https://img.shields.io/badge/twitter-@Nexmo-blue.svg?style=flat)](https://twitter.com/Nexmo)

You use Nexmo Verify to check that a person has access to a specific phone number.

To complete phone verification:

1. Verify sends a PIN in an SMS and/or Text-to-speech (TTS) call to your user.
2. The user enters this PIN into your app or website.
3. You use Verify to check that the PIN entered by your user is the one you sent.

Using Verify SDK for iOS you easily integrate Verify functionality into your iOS app. With the NexmoVerify for iOS, you enter the user's phone number and the SDK completes verification for you.

In order to integrate the NexmoVerify for iOS in your app, see:
* [Setting up your environment](https://docs.nexmo.com/verify/verify-sdk-for-iOS/prerequisites): before you start coding, create a Verify SDK app in the Dashboard and configure Xcode.
* [Integrate Verify SDK for iOS](https://docs.nexmo.com/verify/verify-sdk-for-iOS/integration): create and run your first app.
* [Verify SDK for iOS sample app](https://docs.nexmo.com/verify/verify-sdk-for-iOS/verify-sample): integrate and run a more complete app.
* [Verify SDK for iOS push enabled sample app](https://docs.nexmo.com/verify/verify-sdk-for-iOS/verify-push-sample): integrate and run a more complete app with APNS.
* [Verify SDK for iOS, advanced use](https://docs.nexmo.com/verify/verify-sdk-for-iOS/advanced): use the advanced features in Verify SDK for iOS.
* [Example configurations](https://docs.nexmo.com/verify/verify-sdk-for-iOS/example-configurations): configurations for different types of app.

Feel free to checkout the [NexmoVerify codebase] (https://github.com/Nexmo/verify-ios-sdk/blob/master/VerifySDK) if you wish to contribute to our open source library.

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1.0+ is required to build NexmoVerify 1.0.0+

To integrate NexmoVerify into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'NexmoVerify'
end
```

Then, run the following command:

```bash
$ pod install
```

License
=======

Copyright (c) 2015 Nexmo, Inc.
All rights reserved.
Licensed only under the NexmoVerify License Agreement (the "License") located at

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
