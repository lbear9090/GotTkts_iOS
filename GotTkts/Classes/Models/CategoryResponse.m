//
//  MessageModel.m
//  Partner
//
//  Created by star on 3/30/16.
//  Copyright © 2016 zapporoo. All rights reserved.
//

#import "CategoryResponse.h"

@implementation CategoryResponse

- (instancetype) initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        self.result = [[NSMutableArray alloc] init];
        NSMutableArray *resultArray = (NSMutableArray *)dictionary[@"result"];
        for (int i=0;i<resultArray.count;i++){
            NSDictionary *data = (NSDictionary *) [resultArray objectAtIndex:i];
            Category *category = [[Category alloc] init];
            category.category_id = [data[@"id"] integerValue];
            category.category_name = data[@"category_name"];
            category.category_slug = data[@"category_slug"];
            category.category_parent = data[@"category_parent"];
            category.category_description = data[@"category_description"];
            category.category_image = data[@"category_image"];
            category.category_status = [data[@"category_status"] integerValue];
            category.created_at = data[@"created_at"];
            category.updated_at = data[@"updated_at"];
            category.category_parent_name = data[@"Parent_name"];
            
            [self.result addObject:category];
        }
        
        self.status = [[Status alloc] initWithDictionary:(NSDictionary *)dictionary[@"status"]];
    }
    return self;
}

@end
