//
//  MessageModel.m
//  Partner
//
//  Created by star on 3/30/16.
//  Copyright © 2016 zapporoo. All rights reserved.
//

#import "AccountResponse.h"

@implementation AccountResponse

- (instancetype) initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        int successvalue = [dictionary[@"success"] intValue];
        self.success = (successvalue == 1);
        self.accountId = dictionary[@"account_id"];
    }
    return self;
}

@end
