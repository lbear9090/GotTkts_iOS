//
//  MessageModel.m
//  Partner
//
//  Created by star on 3/30/16.
//  Copyright © 2016 zapporoo. All rights reserved.
//

#import "SoldTicketsResponse.h"

@implementation SoldTicketsResponse

- (instancetype) initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        self.result = [[NSMutableArray alloc] init];
        NSMutableArray *resultArray = (NSMutableArray *)dictionary[@"result"];
        for (int i=0;i<resultArray.count;i++){
            NSDictionary *data = (NSDictionary *) [resultArray objectAtIndex:i];
            SoldTicket *ticket = [[SoldTicket alloc] init];
            ticket.order_id = data[@"order_id"];
            ticket.event_name = data[@"event_name"];
            ticket.order_tickets = [data[@"order_tickets"] intValue];
            ticket.BOOKING_ON = data[@"BOOKING_ON"];
            [self.result addObject:ticket];
        }
        
        self.status = [[Status alloc] initWithDictionary:(NSDictionary *)dictionary[@"status"]];
    }
    return self;
}

@end
