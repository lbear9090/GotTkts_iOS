//
//  MessageModel.h
//  Partner
//
//  Created by star on 3/30/16.
//  Copyright © 2016 zapporoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Response.h"
#import <UIKit/UIKit.h>
#import "Status.h"

@interface Event : Response

@property (nonatomic) NSInteger event_ordered_tickets;
@property (nonatomic) NSInteger event_total_tickets;
@property (nonatomic, strong) NSString *event_address;
@property (nonatomic) NSInteger event_category;
@property (nonatomic) NSInteger event_created_by;
@property (nonatomic, strong) NSString *event_description;
@property (nonatomic, strong) NSString *event_end_datetime;
@property (nonatomic, strong) NSString *event_expire_datetime;
@property (nonatomic, strong) NSString *event_start_datetime;
@property (nonatomic, strong) NSString *event_image;
@property (nonatomic) double event_latitude;
@property (nonatomic) double event_longitude;
@property (nonatomic, strong) NSString *event_location;
@property (nonatomic, strong) NSString *event_name;
@property (nonatomic, strong) NSString *org_name;
@property (nonatomic) NSInteger event_org_name;
@property (nonatomic) NSInteger event_remaining;
@property (nonatomic) NSInteger event_status;
@property (nonatomic, strong) NSString *event_unique_id;
@property (nonatomic) NSInteger event_id;

// for create event
@property (nonatomic, strong) NSString *event_url;
@property (nonatomic, strong) NSString *event_slug;
@property (nonatomic, strong) NSString *event_url_facebook;
@property (nonatomic, strong) NSString *event_url_twitter;
@property (nonatomic, strong) NSString *event_url_instagram;
@property (nonatomic) int event_allow_subpormoter;
@property (nonatomic) int event_is_publish;
@property (nonatomic) int event_display_map;
@property (nonatomic) int event_display_remain;
@property (nonatomic) double event_commision;
@property (nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *event_pickup;
@property (strong, nonatomic) NSString *event_entertainment;
@property (strong, nonatomic) NSString *event_dress_code;
@property (strong, nonatomic) NSString *event_age;
@property (strong, nonatomic) NSString *event_promo_code;
@property (nonatomic) NSInteger event_promo_type;
@property (strong, nonatomic) NSString *event_discount_percent;
@property (strong, nonatomic) NSString *event_package_description;
@property (strong, nonatomic) NSString *event_package_amount;

// customer parameter
@property (strong, nonatomic) NSString *dateString;
@property (strong, nonatomic) NSString *event_old_image;

@property (strong, nonatomic) Status *status;

@end
