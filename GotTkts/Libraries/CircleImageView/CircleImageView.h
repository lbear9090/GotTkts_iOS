//
//  CircleImageView.h
//  SportWorldPassport
//
//  Created by star on 12/2/15.
//  Copyright (c) 2015 UWP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CircleImageAddDelegate <NSObject>

- (void)tapCircleImageView;

@end

@interface CircleImageView : UIImageView

@property (nonatomic, strong) id<CircleImageAddDelegate> delegate;

@end