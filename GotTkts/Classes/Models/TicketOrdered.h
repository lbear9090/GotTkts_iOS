//
//  MessageModel.h
//  Partner
//
//  Created by star on 3/30/16.
//  Copyright © 2016 zapporoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TicketOrdered : NSObject

@property (nonatomic) NSInteger t_id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *event_id;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *ticket_id;
@property (nonatomic, strong) NSString *qr_code;
@property (nonatomic, strong) NSString *qr_image;
@property (nonatomic, strong) NSString *user_firstname;
@property (nonatomic, strong) NSString *user_lastname;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *updated_at;
@property (nonatomic, strong) NSString *ordered_date;
@property (nonatomic, strong) NSString *ticket_title;
@property (nonatomic, strong) NSString *ticket_price;
@property (nonatomic, strong) NSString *event_start_date;
@property (nonatomic, strong) NSString *event_end_date;
@property (nonatomic, strong) NSString *event_image;
@property (nonatomic, strong) NSString *event_address;
@property (nonatomic, strong) NSString *user_email;
@property (nonatomic) NSInteger status;
@property (nonatomic) NSInteger ticket_qty;

@end
