//
//  MessageModel.m
//  Partner
//
//  Created by star on 3/30/16.
//  Copyright © 2016 zapporoo. All rights reserved.
//

#import "Event.h"

@implementation Event
- (instancetype) initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        self.status = dictionary[@"status"];
    }
    return self;
}

@end
