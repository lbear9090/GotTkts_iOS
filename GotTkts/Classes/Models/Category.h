//
//  MessageModel.h
//  Partner
//
//  Created by star on 3/30/16.
//  Copyright © 2016 zapporoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category : NSObject

@property (nonatomic) NSInteger category_id;
@property (nonatomic, strong) NSString *category_name;
@property (nonatomic, strong) NSString *category_slug;
@property (nonatomic, strong) NSString *category_parent;
@property (nonatomic, strong) NSString *category_description;
@property (nonatomic, strong) NSString *category_image;
@property (nonatomic) NSInteger category_status;
@property (nonatomic, strong) NSString *category_parent_name;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *updated_at;

@end
