//
//  MessageModel.m
//  Partner
//
//  Created by star on 3/30/16.
//  Copyright © 2016 zapporoo. All rights reserved.
//

#import "Status.h"

@implementation Status

- (instancetype) initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        self.code = [dictionary[@"code"] integerValue];
        self.msg = dictionary[@"msg"];
    }
    return self;
}

@end
