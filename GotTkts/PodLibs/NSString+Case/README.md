NSString+Case
=============

Helper methods for modifying string case

Demo
====

The demo/ folder contains a demo project showing NSString+Case in use. Open and run it.

Usage
=====

Just import "NSString+Case.h", and then use any of the following methods on any NSString:

* -(NSString *)uppercaseFirstString;
* -(NSString *)lowercaseFirstString;

Compatibility
=============

This class has been tested back to iOS 6.0.

Implementation
==============

This class is implemented by removing the first character from the string, uppercasing or lowercasing that, and prepending it back on the string.

License
=======

This code is released under the MIT License. See the LICENSE file for details.
