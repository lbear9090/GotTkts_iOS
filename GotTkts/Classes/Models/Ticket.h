//
//  MessageModel.h
//  Partner
//
//  Created by star on 3/30/16.
//  Copyright © 2016 zapporoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ticket : NSObject

@property (nonatomic) NSInteger t_id;
@property (nonatomic, strong) NSString *ticket_id;
@property (nonatomic, strong) NSString *event_id;
@property (nonatomic, strong) NSString *ticket_title;
@property (nonatomic, strong) NSString *ticket_description;
@property (nonatomic) NSInteger ticket_desc_status;
@property (nonatomic) NSInteger ticket_qty;
@property (nonatomic) NSInteger ticket_remaning_qty;
@property (nonatomic) NSInteger ticket_type;
@property (nonatomic) NSInteger ticket_status;
@property (nonatomic) NSInteger ticket_services_fee;
@property (nonatomic, strong) NSString *ticket_price_buyer;
@property (nonatomic, strong) NSString *ticket_price_actual;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *updated_at;

@end
