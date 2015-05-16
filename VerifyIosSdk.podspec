#
# Be sure to run `pod lib lint VerifyIosSdk.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "VerifyIosSdk"
  s.version          = "0.1"
  s.summary          = "Verify any number, hassle-free."
  s.description      = <<-DESC
                       VerifySDK allows you to easily register users,
                       verify transactions, and implement two-factor
                       authentication (2FA). VerifySDK can be used for
                       identity verification, phone verification,
                       mobile verification, and one-time PIN.
                       DESC
  s.homepage         = "http://www.nexmo.com/verify"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = { :type => 'Nexmo Verify SDK', :file => 'LICENSE' }
  s.author           = { "Dorian Peake" => "dorian@nexmo.com" }
  s.source           = { :git => "https://bitbucket.org/dozzman/VerifyIosSdk.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'VerifyIosSdk/*.{swift}', 'VerifyIosSdk/**/*.{h,m}'
  s.private_header_files = 'VerifyIosSdk/**/*.h'
  s.preserve_path = 'VerifyIosSdk/module.modulemap'

  s.xcconfig = { "SWIFT_INCLUDE_PATHS" => "$(SRCROOT)/VerifyIosSdk/VerifyIosSdk/RequestSigning $(SRCROOT)/VerifyIosSdk/VerifyIosSdk/DeviceProperties $(SRCROOT)/VerifyIosSdk/VerifyIosSdk" }

  s.resource_bundles = {
    'VerifyIosSdk' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
