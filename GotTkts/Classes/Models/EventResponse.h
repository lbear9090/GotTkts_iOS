//
//  MessageModel.h
//  Partner
//
//  Created by star on 3/30/16.
//  Copyright © 2016 zapporoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
#import "Response.h"
#import "Status.h"

@interface EventResponse : Response

@property (nonatomic, strong) NSMutableArray *result;
@property (nonatomic, strong) Status *status;

@end
