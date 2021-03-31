//
//  MessageModel.h
//  Partner
//
//  Created by star on 3/30/16.
//  Copyright © 2016 zapporoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Response.h"

@interface UserModel : Response

@property (nonatomic, strong) NSString *firstname;
@property (nonatomic, strong) NSString *lastname;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *fullname;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *account_id;
@property (nonatomic, strong) NSString *role_id;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic) int gender;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *city;

+ (UserModel *) currentUser;

@end
