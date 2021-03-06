//
// Constants.swift
// Iconizer
// https://github.com/raphaelhanneken/iconizer
//
// The MIT License (MIT)
//
// Copyright (c) 2016 Raphael Hanneken
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

///  Nicely wrap up the integers from NSSegmentedControl.
///
///  - kAppIconViewControllerTag:     Represents the tag for the AppIconView.
///  - kLaunchImageViewControllerTag: Represents the tag for the LaunchImageView.
///  - kImageSetViewControllerTag:    Represents the tag for the ImageSetView.
enum ViewControllerTag: Int {
  case appIconViewControllerTag     = 0
  case launchImageViewControllerTag = 1
  case imageSetViewControllerTag    = 2
}

// MARK: - Platform names

/// Platform: Apple Watch
let kAppleWatchPlatformName = "Watch"
/// Platform: iPad
let kIPadPlatformName       = "iPad"
/// Platform: iPhone
let kIPhonePlatformName     = "iPhone"
/// Platform: OS X
let kOSXPlatformName        = "Mac"
/// Platform: Car Play
let kCarPlayPlatformName    = "Car"

// MARK: - Image Orientation names

///  Possible image orientations.
///
///  - Portrait:  Portrait image.
///  - Landscape: Landscape image.
enum ImageOrientation: String {
  case Portrait  = "portrait"
  case Landscape = "landscape"
}

// MARK: - Directory names

/// Default url for app icons.
let appIconDir     = "Iconizer Assets/App Icons"
/// Default url for launch images.
let launchImageDir = "Iconizer Assets/Launch Images"
/// Default url for image sets.
let imageSetDir    = "Iconizer Assets/Image Sets"

// MARK: - Asset Types

///  Wrap the different asset catalog types into an enum, for nicer code.
///
///  - AppIcon:     Represents the AppIcon model
///  - ImageSet:    Represents the ImageSet model
///  - LaunchImage: Represents the LaunchImage model
enum AssetType: Int {
  case appIcon     = 0
  case imageSet    = 1
  case launchImage = 2
}

// MARK: - Keys to access the user defaults

/// Generate an AppIcon for the Apple Watch.
let generateAppIconForAppleWatchKey = "generateAppIconForAppleWatch"
/// Generate an AppIcon for the iPhone.
let generateAppIconForIPhoneKey     = "generateAppIconForIPhone"
/// Generate an AppIcon for the iPad.
let generateAppIconForIPadKey       = "generateAppIconForIPad"
/// Generate an AppIcon for OS X.
let generateAppIconForMacKey        = "generateAppIconForMac"
/// Generate an AppIcon for CarPlay
let generateAppIconForCarKey        = "generateAppIconForCar"
/// Generate an AppIcon with multiple platforms (combined asset)
let combinedAppIconAssetKey         = "combinedAppIconAsset"
/// Selected ExportTypeViewController (NSSegmentedControl)
let selectedExportTypeKey           = "selectedExportType"
/// Generate a LaunchImage for the iPhone.
let generateLaunchImageForIPhoneKey = "generateLaunchImageForIPhone"
/// Generate a LaunchImage for the iPad.
let generateLaunchImageForIPadKey   = "generateLaunchImageForIPad"
