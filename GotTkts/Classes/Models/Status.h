//
//  MessageModel.h
//  Partner
//
//  Created by star on 3/30/16.
//  Copyright © 2016 zapporoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Response.h"

@interface Status : Response

@property (nonatomic) NSInteger code;
@property (nonatomic, strong) NSString *msg;

@end
