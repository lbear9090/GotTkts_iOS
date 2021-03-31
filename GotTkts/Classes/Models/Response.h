//
//  MessageModel.h
//  Partner
//
//  Created by star on 3/30/16.
//  Copyright © 2016 zapporoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Response : NSObject

- (instancetype) initWithDictionary:(NSDictionary*)dictionary;

@property (strong, nonatomic) NSString *errMsg;
@property (nonatomic) BOOL isSuccess;

@end
