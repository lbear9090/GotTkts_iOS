//
//  MessageModel.h
//  Partner
//
//  Created by star on 3/30/16.
//  Copyright © 2016 zapporoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSQMessage.h"
#import <Parse/Parse.h>

@interface MessageModel : JSQMessage

@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) PFFile *video;

@end
