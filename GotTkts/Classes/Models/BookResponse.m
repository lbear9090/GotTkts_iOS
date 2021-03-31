//
//  MessageModel.m
//  Partner
//
//  Created by star on 3/30/16.
//  Copyright © 2016 zapporoo. All rights reserved.
//

#import "BookResponse.h"

@implementation BookResponse

- (instancetype) initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.result = [[Book alloc] init];
        NSMutableDictionary *data = [dictionary objectForKey:@"result"];
        self.result.event_id = data[@"event_id"];
        self.result.user_id = [data[@"user_id"] integerValue];
        self.result.order_id = data[@"order_id"];
        self.result.order_tickets = [data[@"order_tickets"] integerValue];
        self.result.order_amount = data[@"order_amount"];
        self.result.client_token = data[@"client_token"];
        self.result.order_t_id = data[@"order_t_id"];
        self.result.order_t_title = data[@"order_t_title"];
        self.result.order_t_qty = data[@"order_t_qty"];
        self.result.order_t_price = data[@"order_t_price"];
        self.result.order_t_fees = data[@"order_t_fees"];
        self.result.updated_at = data[@"updated_at"];
        self.result.created_at = data[@"created_at"];
        self.result.b_id = [data[@"id"] integerValue];
        
        self.status = [[Status alloc] initWithDictionary:(NSDictionary *)dictionary[@"status"]];
    }
    return self;
}

@end
