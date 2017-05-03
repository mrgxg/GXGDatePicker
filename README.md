# GXGDatePicker

[![CI Status](http://img.shields.io/travis/龚雪刚/GXGDatePicker.svg?style=flat)](https://travis-ci.org/龚雪刚/GXGDatePicker)
[![Version](https://img.shields.io/cocoapods/v/GXGDatePicker.svg?style=flat)](http://cocoapods.org/pods/GXGDatePicker)
[![License](https://img.shields.io/cocoapods/l/GXGDatePicker.svg?style=flat)](http://cocoapods.org/pods/GXGDatePicker)
[![Platform](https://img.shields.io/cocoapods/p/GXGDatePicker.svg?style=flat)](http://cocoapods.org/pods/GXGDatePicker)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

![image](https://github.com/mrgxg/GXGDatePicker/blob/master/gxgdatepicker.gif) 

## Requirements

## Installation

GXGDatePicker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "GXGDatePicker"
```

```

GXGDatePicker *picker = [[GXGDatePicker alloc] init];
[picker showDatePicker:^(NSDate * _Nullable selectedDate) {
    NSLog(@"slectDate = %@",selectedDate);
}];

```


## Author

mrgxg, gxg0619@gmail.com

## License

GXGDatePicker is available under the MIT license. See the LICENSE file for more info.
