//
//  MessageModel.h
//  Partner
//
//  Created by star on 3/30/16.
//  Copyright © 2016 zapporoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TicketSales : NSObject

@property (nonatomic, strong) NSString *ticket_title;
@property (nonatomic) NSInteger ticket_qty;
@property (nonatomic) NSInteger number_order;
@property (nonatomic) NSInteger number_checkin;

@end
