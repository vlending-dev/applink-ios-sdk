# Vlending AppLink for iOS
Distribute the SDK of the deep link service provided by Vlending.

## Requirements

 * iOS 13+
 * Xcode 15+
 * Swift 5.10+

## Features

Provides the following features:
 * Shortened URL
 * Apple
    * [Universal Links](https://developer.apple.com/ios/universal-links/)
    * [Custom URL scheme](https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app)
 * Android
    * [App Links & Custom URL scheme](https://developer.android.com/training/app-links)
    * [Intent scheme](https://developer.chrome.com/docs/android/intents)
 * Link's preview webpage and OGTAG
 * Webpage for management

Analysis functions will also be provided in the future.

To use the above functions, you must obtain a subdomain and API key.
Learn more about the provided documentation, integrating the SDK into your app, and more at [here](https://www.notion.so/vlending/Vlending-AppLink-Docs-42018af2e9bf46a6af73e9bbf76c18c9)

## Installation

### CocoaPods

```ruby
platform :ios, '13.0'
use_frameworks!
source 'https://github.com/CocoaPods/Specs.git'

pod 'AppLinkSDK-iOS'
```

### Swift Package Manager

To add AppLink SDK to a [Swift Package Manager](https://www.swift.org/documentation/package-manager/) based project, add:
```swift
dependencies: [
    .package(url: "https://github.com/vlending-dev/applink-ios-sdk.git", .upToNextMajor(from: "0.5.2"))
]
```

## License

See the [LICENSE](https://github.com/vlending-dev/applink-ios-sdk/blob/master/LICENSE.txt) file.
Copyright © Vlending Co., Ltd.

## Contact

For usage and development inquiries, please contact [here](mailto:applink@vlending.co.kr).