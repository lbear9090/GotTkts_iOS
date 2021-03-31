//
//  MessageModel.h
//  Partner
//
//  Created by star on 3/30/16.
//  Copyright © 2016 zapporoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoldTicket : NSObject

@property (nonatomic) NSInteger t_id;
@property (nonatomic, strong) NSString *event_id;
@property (nonatomic) int user_id;
@property (nonatomic, strong) NSString *affilate_id;
@property (nonatomic) int subpromter_id;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic) int order_tickets;
@property (nonatomic, strong) NSString *order_amount;
@property (nonatomic, strong) NSMutableArray *order_t_id;
@property (nonatomic, strong) NSMutableArray *order_t_title;
@property (nonatomic, strong) NSMutableArray *order_t_qty;
@property (nonatomic, strong) NSMutableArray *order_t_price;
@property (nonatomic, strong) NSMutableArray *order_t_fees;
@property (nonatomic, strong) NSMutableArray *order_t_type;
@property (nonatomic, strong) NSString *client_token;
@property (nonatomic) int order_status;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *updated_at;
@property (nonatomic, strong) NSString *event_unique_id;
@property (nonatomic) int event_category;
@property (nonatomic, strong) NSString *event_name;
@property (nonatomic, strong) NSString *event_slug;
@property (nonatomic, strong) NSString *event_description;
@property (nonatomic, strong) NSString *event_location;
@property (nonatomic) int map_display;
@property (nonatomic, strong) NSString *event_address;
@property (nonatomic, strong) NSString *event_start_datetime;
@property (nonatomic, strong) NSString *event_end_datetime;
@property (nonatomic, strong) NSString *event_image;
@property (nonatomic, strong) NSString *event_url;
@property (nonatomic, strong) NSString *event_qrcode;
@property (nonatomic, strong) NSString *event_qrcode_image;
@property (nonatomic, strong) NSString *event_create_by;
@property (nonatomic, strong) NSString *event_org_name;
@property (nonatomic) int allow_subpromoter;
@property (nonatomic, strong) NSString *subpromoter_commision;
@property (nonatomic, strong) NSMutableArray *event_pickup;
@property (nonatomic, strong) NSString *event_entertain;
@property (nonatomic, strong) NSString *event_drcod;
@property (nonatomic, strong) NSString *age;
@property (nonatomic) double event_latitude;
@property (nonatomic) double event_longitude;
@property (nonatomic, strong) NSString *org_slug;
@property (nonatomic, strong) NSString *org_name;
@property (nonatomic, strong) NSString *BOOKING_ON;

@end
