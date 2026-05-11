# PaperShaders

<p>
  <img alt="Swift 6" src="https://img.shields.io/badge/Swift-6-orange.svg" />
  <img alt="iOS 17+" src="https://img.shields.io/badge/iOS-17%2B-0A84FF.svg" />
  <img alt="macOS 14+" src="https://img.shields.io/badge/macOS-14%2B-0A84FF.svg" />
  <img alt="tvOS 17+" src="https://img.shields.io/badge/tvOS-17%2B-0A84FF.svg" />
  <img alt="visionOS 1+" src="https://img.shields.io/badge/visionOS-1%2B-0A84FF.svg" />
  <br>
  <a href="https://x.com/rafa_b_g">
    <img alt="X/Twitter" src="https://img.shields.io/badge/X%2FTwitter-%40rafa__b__g-111111.svg" />
  </a>
</p>

A SwiftUI library that adds paper-like visual effects to views using Metal shaders.

<img alt="Banner" src="https://github.com/user-attachments/assets/64368017-f56c-4d3b-b046-60a568a57d8d" />

## Installation

Add this package to your Xcode project (File > Add Package Dependencies), using this URL: "https://github.com/rafael-b-g/PaperShaders.git".

## Usage

Start by importing the package: `import PaperShaders`

### Paper texture (grain)

You can add paper grain using this modifier:

```swift
YourView()
    .paperTexture()
```

### Paper distortion (ink effect)

You can add print distortion (simulating ink printed on paper) using this modifier:

```swift
YourView()
    .paperDistortion()
```

> [!TIP]
> You can adjust the effects with optional parameters inside each modifier.
