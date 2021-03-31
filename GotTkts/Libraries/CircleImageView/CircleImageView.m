//
//  CircleImageView.m
//  SportWorldPassport
//
//  Created by star on 12/2/15.
//  Copyright (c) 2015 UWP. All rights reserved.
//

#import "CircleImageView.h"

@implementation CircleImageView

- (id)init {
    self = [super init];
    if (self) {
        [self setUISettings];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUISettings];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUISettings];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setUISettings];
}

- (void)setUISettings {
    //    NSLog(@"image Size : %.2f, %.2f", self.frame.size.width, self.frame.size.height);
    self.layer.cornerRadius = self.frame.size.width / 2.0;
    self.clipsToBounds = YES;
    [self setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [gesture setEnabled:YES];
    [gesture setNumberOfTapsRequired:1];
    
    [self addGestureRecognizer:gesture];
}

- (void)onTap:(UIGestureRecognizer *)recognizer {
    if (self.delegate) {
        [self.delegate tapCircleImageView];
    }
}

@end
