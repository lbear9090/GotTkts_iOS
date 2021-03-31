//
//  MessageModel.m
//  Partner
//
//  Created by star on 3/30/16.
//  Copyright © 2016 zapporoo. All rights reserved.
//

#import "EventSales.h"

@implementation EventSales
- (instancetype) initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        NSDictionary *data = (NSMutableDictionary *)dictionary[@"result"];
        self.event_gross_income = data[@"event_gross_income"];
        self.event_total_tickets = data[@"event_total_tickets"];
        self.total_order_tickets = [data[@"total_order_tickets"] integerValue];
        self.total_checkin_tickets = [data[@"total_chackin_tickets"] integerValue];
        self.event_order_tickets = [[NSMutableArray alloc] init];
        NSMutableArray *order_tikcets = (NSMutableArray *) data[@"event_order_tickets"];
        for (int i=0;i<order_tikcets.count;i++){
            NSDictionary *ticketData = (NSDictionary *) [order_tikcets objectAtIndex:i];
            TicketSales *ticket = [[TicketSales alloc] init];
            ticket.ticket_title = ticketData[@"TICKE_TITLE"];
            ticket.ticket_qty = [ticketData[@"TICKE_QTY"] integerValue];
            ticket.number_order = [ticketData[@"NUMBER_OF_ORDER"] integerValue];
            ticket.number_checkin =  [ticketData[@"NUMBER_OF_CHACKIN"] integerValue];
            [self.event_order_tickets addObject:ticket];
        }        
        self.status = [[Status alloc] initWithDictionary:(NSDictionary *)dictionary[@"status"]];
    }
    return self;
}
@end
