//
//  MessageModel.m
//  Partner
//
//  Created by star on 3/30/16.
//  Copyright © 2016 zapporoo. All rights reserved.
//

#import "Response.h"

@implementation Response

- (instancetype) initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        self.errMsg = dictionary[@"error"];
        self.isSuccess = ([dictionary[@"success"] integerValue] == 1);        
    }
    return self;
}
@end
