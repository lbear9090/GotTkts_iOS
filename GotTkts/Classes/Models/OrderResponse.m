//
//  MessageModel.m
//  Partner
//
//  Created by star on 3/30/16.
//  Copyright © 2016 zapporoo. All rights reserved.
//

#import "OrderResponse.h"

@implementation OrderResponse

- (instancetype) initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        self.result = [[NSMutableArray alloc] init];
        NSMutableArray *resultArray = (NSMutableArray *)dictionary[@"result"];
        for (int i=0;i<resultArray.count;i++){
            NSDictionary *data = (NSDictionary *) [resultArray objectAtIndex:i];
            Order *order = [[Order alloc] init];
            order.ticket_title = data[@"TICKE_TITLE"];
            order.ot_order_id = data[@"ot_order_id"];
            order.ot_ticket_id = data[@"ot_ticket_id"];
            order.ot_qr_code = data[@"ot_qr_code"];
            order.ot_firstname = data[@"ot_f_name"];
            order.ot_lastname = data[@"ot_l_name"];
            order.ot_email = data[@"ot_email"];
            order.ot_status = [data[@"ot_status"] integerValue];
            order.order_on = data[@"ORDER_ON"];
            [self.result addObject:order];
        }
        
        self.status = [[Status alloc] initWithDictionary:(NSDictionary *)dictionary[@"status"]];
    }
    return self;
}

@end
