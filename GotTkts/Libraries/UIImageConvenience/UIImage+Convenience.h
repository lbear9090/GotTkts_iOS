//
//  UIImage+Convenience.h
//  Race It Home
//
//  Created by star on 1/19/15.
//  Copyright (c) 2015 Race It Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIImage (Convenience)

- (UIImage *)getCroppedImage:(int)width height:(int)height;
- (UIImage *)squareImageWithImage:(CGSize)newSize;
- (UIImage *)getRotatedImage:(int)angle;

+ (UIImage *)imageWithView:(UIView *)view;

@end
