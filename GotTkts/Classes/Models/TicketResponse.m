//
//  MessageModel.m
//  Partner
//
//  Created by star on 3/30/16.
//  Copyright © 2016 zapporoo. All rights reserved.
//

#import "TicketResponse.h"

@implementation TicketResponse

- (instancetype) initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        self.result = [[NSMutableArray alloc] init];
        NSMutableArray *resultArray = (NSMutableArray *)dictionary[@"result"];
        for (int i=0;i<resultArray.count;i++){
            NSDictionary *data = (NSDictionary *) [resultArray objectAtIndex:i];
            Ticket *ticket = [[Ticket alloc] init];
            ticket.t_id = [data[@"id"] integerValue];
            ticket.ticket_id = data[@"ticket_id"];
            ticket.event_id = data[@"event_id"];
            ticket.ticket_title = data[@"ticket_title"];
            ticket.ticket_description = data[@"ticket_description"];
            ticket.ticket_desc_status = [data[@"ticket_desc_status"] integerValue];
            ticket.ticket_qty = [data[@"ticket_qty"] integerValue];
            ticket.ticket_remaning_qty = [data[@"ticket_remaning_qty"] integerValue];
            ticket.ticket_type = [data[@"ticket_type"] integerValue];
            ticket.ticket_status = [data[@"ticket_status"] integerValue];
            ticket.ticket_services_fee = [data[@"ticket_services_fee"] integerValue];
            ticket.ticket_price_buyer = data[@"ticket_price_buyer"];
            ticket.ticket_price_actual = data[@"ticket_price_actual"];
            ticket.created_at = data[@"created_at"];
            ticket.updated_at = data[@"updated_at"];
            
            [self.result addObject:ticket];
        }
        
        self.status = [[Status alloc] initWithDictionary:(NSDictionary *)dictionary[@"status"]];
    }
    return self;
}

@end
