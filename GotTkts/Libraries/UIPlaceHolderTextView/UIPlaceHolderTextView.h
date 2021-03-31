//
//  UIPlaceHolderTextView.h
//  Oncam
//
//  Created by IOS7 on 4/11/14.
//  Copyright (c) 2014 Oncam Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
