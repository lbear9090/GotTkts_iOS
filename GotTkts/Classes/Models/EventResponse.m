//
//  MessageModel.m
//  Partner
//
//  Created by star on 3/30/16.
//  Copyright © 2016 zapporoo. All rights reserved.
//

#import "EventResponse.h"

@implementation EventResponse

- (instancetype) initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        self.result = [[NSMutableArray alloc] init];
        NSMutableArray *resultArray = (NSMutableArray *)dictionary[@"result"];
        for (int i=0;i<resultArray.count;i++){
            NSDictionary *data = (NSDictionary *) [resultArray objectAtIndex:i];
            Event *event = [[Event alloc] init];
            if ([NSNull null] != data[@"EVENT_ORDERD_TICKETS"])
                event.event_ordered_tickets = [data[@"EVENT_ORDERD_TICKETS"] integerValue];
            else
                event.event_ordered_tickets = [data[@"EVENT_ORDERD_TICKETS"] integerValue];
            if ([NSNull null] != data[@"EVENT_TOTAL_TICKETS"])
                event.event_total_tickets = [data[@"EVENT_TOTAL_TICKETS"] integerValue];
            else
                event.event_total_tickets = 0;
            event.event_address = data[@"event_address"];
            event.event_category = [data[@"event_category"] integerValue];
            if ([NSNull null] != data[@"event_create_by"])
                event.event_created_by = [data[@"event_create_by"] integerValue];
            else
                event.event_created_by = 0;
            event.event_description = data[@"event_description"];
            event.event_start_datetime = data[@"event_start_datetime"];
            event.event_end_datetime = data[@"event_end_datetime"];
            event.event_image = data[@"event_image"];
            event.event_latitude = [data[@"event_latitude"] doubleValue];
            event.event_longitude = [data[@"event_longitude"] doubleValue];
            event.event_name = data[@"event_name"];
            if ([NSNull null] != data[@"event_org_name"]){
                event.event_org_name = [data[@"event_org_name"] integerValue];
            } else {
                event.event_org_name = 0;
            }
            event.org_name = [data[@"org_name"] stringValue];
            event.event_remaining = [data[@"event_remaining"] integerValue];
            event.event_status = [data[@"event_status"] integerValue];
            event.event_unique_id = data[@"event_unique_id"];
            event.event_id = [data[@"id"] integerValue];
            [self.result addObject:event];
        }
        
        self.status = [[Status alloc] initWithDictionary:(NSDictionary *)dictionary[@"status"]];
    }
    return self;
}

@end
