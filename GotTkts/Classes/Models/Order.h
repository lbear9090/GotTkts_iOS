//
//  MessageModel.h
//  Partner
//
//  Created by star on 3/30/16.
//  Copyright © 2016 zapporoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

@property (nonatomic, strong) NSString *ticket_title;
@property (nonatomic, strong) NSString *ot_order_id;
@property (nonatomic, strong) NSString *ot_ticket_id;
@property (nonatomic, strong) NSString *ot_qr_code;
@property (nonatomic, strong) NSString *ot_firstname;
@property (nonatomic, strong) NSString *ot_lastname;
@property (nonatomic, strong) NSString *ot_email;
@property (nonatomic, strong) NSString *order_on;
@property (nonatomic) NSInteger ot_status;

@end
