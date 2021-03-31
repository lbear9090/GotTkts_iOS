//
//  MessageModel.h
//  Partner
//
//  Created by star on 3/30/16.
//  Copyright © 2016 zapporoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

@property (nonatomic) NSInteger b_id;
@property (nonatomic, strong) NSString *event_id;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, strong) NSString *order_amount;
@property (nonatomic) NSInteger order_tickets;
@property (nonatomic) NSInteger user_id;
@property (nonatomic, strong) NSString *client_token;
@property (nonatomic, strong) NSString *order_t_id;
@property (nonatomic, strong) NSString *order_t_title;
@property (nonatomic, strong) NSString *order_t_qty;
@property (nonatomic, strong) NSString *order_t_price;
@property (nonatomic, strong) NSString *order_t_fees;
@property (nonatomic, strong) NSString *updated_at;
@property (nonatomic, strong) NSString *created_at;

@end
