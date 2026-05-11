# PaperShaders

A SwiftUI library that adds paper-like visual effects to views using Metal shaders.

<img alt="Banner" src="https://github.com/user-attachments/assets/64368017-f56c-4d3b-b046-60a568a57d8d" />

## Requirements

- iOS 17+
- macOS 14+
- tvOS 17+
- visionOS 1+
- Swift 6

## Installation

Add this package to your Xcode project (File > Add Package Dependencies), using this URL: "https://github.com/rafael-b-g/PaperShaders.git".

## Usage

Import the package:

```swift
import PaperShaders
```

#### Paper texture (grain)
Add paper grain using this modifier:

```swift
YourView()
    .paperTexture()
```

#### Paper distortion (ink effect)
Add print distortion (simulating ink printed on paper) using this modifier:

```swift
YourView()
    .paperDistortion()
```

You can adjust the effects with optional parameters inside each modifier.
