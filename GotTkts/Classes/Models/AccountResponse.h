//
//  MessageModel.h
//  Partner
//
//  Created by star on 3/30/16.
//  Copyright © 2016 zapporoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Response.h"
#import "Status.h"

@interface AccountResponse : Response

@property (nonatomic) BOOL success;
@property (nonatomic, strong) NSString *accountId;

@end
