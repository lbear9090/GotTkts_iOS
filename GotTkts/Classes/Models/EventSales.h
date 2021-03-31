//
//  MessageModel.h
//  Partner
//
//  Created by star on 3/30/16.
//  Copyright © 2016 zapporoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TicketSales.h"
#import "Response.h"
#import "Status.h"

@interface EventSales : Response

@property (nonatomic, strong) NSString *event_gross_income;
@property (nonatomic, strong) NSString *event_total_tickets;
@property (nonatomic) NSInteger total_order_tickets ;
@property (nonatomic) NSInteger total_checkin_tickets;
@property (nonatomic, strong) NSMutableArray *event_order_tickets;
@property (nonatomic, strong) Status *status;

@end
