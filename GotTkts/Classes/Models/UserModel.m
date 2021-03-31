//
//  MessageModel.m
//  Partner
//
//  Created by star on 3/30/16.
//  Copyright © 2016 zapporoo. All rights reserved.
//

#import "UserModel.h"

static UserModel *me = nil;

@implementation UserModel

+ (UserModel *) currentUser {
    
    if (!me) {
        me = [[UserModel alloc] init];
    }
    
    return me;
}

- (instancetype) initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        self.user_id = dictionary[@"id"];
        self.token = dictionary[@"token"];
        self.fullname = dictionary[@"fullname"];
        self.email = dictionary[@"email"];
        self.account_id = dictionary[@"account_id"];
        self.role_id = dictionary[@"role_id"];
        self.avatar = dictionary[@"profile_pic"];
        self.firstname = dictionary[@"firstname"];
        self.lastname = dictionary[@"lastname"];
        if ([NSNull null] != dictionary[@"gender"]){
            self.gender = [dictionary[@"gender"] intValue];
        } else {
            self.gender = 0;
        }
        self.state = dictionary[@"state"];
        self.city = dictionary[@"city"];
        self.created_at = dictionary[@"created_at"];
        self.errMsg = dictionary[@"error"];
        self.isSuccess = ([dictionary[@"success"] integerValue] == 1);
        
        me = self;
    }
    return self;
}

@end
