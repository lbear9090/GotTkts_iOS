//
//  HttpAPI.h
//  BarcodeApp
//
//  Created on 3/4/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSON.h"
#import "Config.h"
#import "NSString+UrlEncode.h"


#define HTTP_METHOD_GET                 @"GET"
#define HTTP_METHOD_POST                @"POST"
#define HTTP_METHOD_DELETE              @"DELETE"

#define HTTP_NO_INTERNET_MESSAGE        @"Sorry, we couldn't connect to our server. Please confirm you have an internet connection and try again in a moment."

@interface HttpAPI : NSObject

+ (void) sendRequestWithURL:(NSString*) url paramDic:(NSMutableDictionary *)paramDict completionBlock: (void (^)(NSDictionary *, NSError *))completionBlock ;

@end
