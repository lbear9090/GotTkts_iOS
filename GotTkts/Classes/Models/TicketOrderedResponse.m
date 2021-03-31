//
//  MessageModel.m
//  Partner
//
//  Created by star on 3/30/16.
//  Copyright © 2016 zapporoo. All rights reserved.
//

#import "TicketOrderedResponse.h"

@implementation TicketOrderedResponse

- (instancetype) initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        self.result = [[NSMutableArray alloc] init];
        NSMutableArray *resultArray = (NSMutableArray *)dictionary[@"result"];
        for (int i=0;i<resultArray.count;i++){
            NSDictionary *data = (NSDictionary *) [resultArray objectAtIndex:i];
            TicketOrdered *ticket = [[TicketOrdered alloc] init];
            ticket.t_id = [data[@"id"] integerValue];
            ticket.user_id = data[@"ot_user_id"];
            ticket.event_id = data[@"ot_event_id"];
            ticket.order_id = data[@"ot_order_id"];
            ticket.ticket_id = data[@"ot_ticket_id"];
            ticket.qr_code = data[@"ot_qr_code"];
            ticket.qr_image = data[@"ot_qr_image"];
            ticket.user_firstname = data[@"ot_f_name"];
            ticket.user_lastname = data[@"ot_l_name"];
            ticket.qr_image = data[@"ot_qr_image"];
            ticket.user_email = data[@"ot_email"];
            ticket.status = [data[@"ot_status"] integerValue];
            ticket.created_at = data[@"created_at"];
            ticket.updated_at = data[@"updated_at"];
            ticket.ordered_date = data[@"ordered_date"];
            ticket.ticket_title = data[@"ticket_title"];
            ticket.ticket_price = data[@"ticket_price"];
            ticket.event_start_date = data[@"event_start_date"];
            ticket.event_end_date = data[@"event_end_date"];
            ticket.event_image = data[@"event_image"];
            ticket.event_address = data[@"event_address"];
            ticket.ticket_qty = [data[@"ticket_qty"] integerValue];
            
            
            [self.result addObject:ticket];
        }
        
        self.status = [[Status alloc] initWithDictionary:(NSDictionary *)dictionary[@"status"]];
    }
    return self;
}

@end
