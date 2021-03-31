NSString-Email ![License MIT](https://go-shields.herokuapp.com/license-MIT-blue.png)
==============

A category on NSString for checking if a string is an email address.

<p align="center">
  <img src="http://s24.postimg.org/amuiafe51/NSString_Email.png" alt="NSString-Email" title="NSString-Email" width="469" height="343">
</p>

[![Build Status](https://api.travis-ci.org/NZN/NSString-Email.png)](https://api.travis-ci.org/NZN/NSString-Email.png)
[![Cocoapods](https://cocoapod-badges.herokuapp.com/v/NSString-Email/badge.png)](http://beta.cocoapods.org/?q=name%3Ansstring%20name%3Aemail%2A)
[![Cocoapods](https://cocoapod-badges.herokuapp.com/p/NSString-Email/badge.png)](http://beta.cocoapods.org/?q=name%3Ansstring%20name%3Aemail%2A)
[![Analytics](https://ga-beacon.appspot.com/UA-48753665-1/NZN/NSString-Email/README.md)](https://github.com/igrigorik/ga-beacon)

## Adding NSString-Email to your project

### Cocoapods

[CocoaPods](http://cocoapods.org) is the recommended way to add `NSString-Email` to your project.

* Add a pod entry for NSString-Email to your Podfile `pod 'NSString-Email', '~> 0.0.2'`
* Install the pod(s) by running `pod install`.

### Source files

Alternatively you can directly add source files to your project.

1. Download the [latest code version](https://github.com/NZN/NSString-Email/archive/master.zip) or add the repository as a git submodule to your git-tracked project.
2. Open your project in Xcode, then drag and drop all files at `NSString-Email` folder onto your project (use the "Product Navigator view"). Make sure to select Copy items when asked if you extracted the code archive outside of your project.

## Usage

```objective-c
NSString *string = @"user@example.com";
BOOL isEmail = [string isEmail];
```

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).

## Change-log

A brief summary of each NSString-Email release can be found on the [wiki](https://github.com/NZN/NSString-Email/wiki/Change-log).
