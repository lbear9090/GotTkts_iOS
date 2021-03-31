# NSString+VTContainsSubstring

_`NSString` category to test the presence of a given substring._

[![Build Status](https://travis-ci.org/vtourraine/NSString-VTContainsSubstring.svg?branch=master)](https://travis-ci.org/vtourraine/NSString-VTContainsSubstring)

## How to install

Available on CocoaPods. ![CocoaPods version badge](https://cocoapod-badges.herokuapp.com/v/NSString+VTContainsSubstring/badge.png) 
![CocoaPods platform badge](https://cocoapod-badges.herokuapp.com/p/NSString+VTContainsSubstring/badge.png)

``` ruby
pod 'NSString+VTContainsSubstring'
```

## How to use

``` objc
NSString *string = @"I like cakes.";
[string vt_containsSubstring:@"cake"]; // = YES
[string vt_containsSubstring:@"Cake" options:NSCaseInsensitiveSearch]; // = YES
```

## Credits

NSString+VTContainsSubstring was created by [Vincent Tourraine](http://www.vtourraine.net).

## License

NSString+VTContainsSubstring is available under the MIT license. See the LICENSE file for more info.

