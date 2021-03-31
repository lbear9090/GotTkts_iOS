//
//  MessageModel.m
//  Partner
//
//  Created by star on 3/30/16.
//  Copyright © 2016 zapporoo. All rights reserved.
//

#import "UpdateProfile.h"

@implementation UpdateProfile
- (instancetype) initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        self.firstname = dictionary[@"firstname"];
        self.lastname = dictionary[@"lastname"];
        self.profile_picture = dictionary[@"profile_pic"];
        self.success = ([dictionary[@"success"] integerValue] == 1);
    }
    return self;
}
@end
