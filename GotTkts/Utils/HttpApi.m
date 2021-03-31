//
//  HttpAPI.m
//
//
//  Created on 3/4/14.
//  Copyright (c) 2014. All rights reserved.
//

#import "HttpAPI.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@interface HttpAPI()

@end

@implementation HttpAPI


+ (void) sendRequestWithURL:(NSString*) url paramDic:(NSMutableDictionary *)paramDict completionBlock: (void (^)(NSDictionary *, NSError *))completionBlock {
    
    NSString *urlString = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if ([urlString rangeOfString:@"?"].location == NSNotFound) {
        urlString = [NSString stringWithFormat:@"%@?rand=%d", urlString, arc4random()];
    } else {
        urlString = [NSString stringWithFormat:@"%@&rand=%d", urlString, arc4random()];
    }
    
    NSLog(@"\n\n **************** Request to Server  **************** \n\n%@ ** \n\n", urlString);
    
    NSURL *aUrl = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    //    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    // Set Http request method
    [request setHTTPMethod:HTTP_METHOD_POST];
    
    // Set the params
    NSString *strParams = @"";
    if (paramDict) {
        NSArray *keys = [paramDict allKeys];
        for (int i = 0 ; i < keys.count ; i++) {
            NSString *key = [keys objectAtIndex:i];
            NSString *value = [paramDict objectForKey:key];
            value = [value urlEncode];
            if (value.length > 0) {
                strParams = [NSString stringWithFormat:@"%@%@=%@&", strParams,  key, value];
            }
            
        }
        
        NSLog(@"\n **************** With Post params  **************** \n\n%@\n\n", strParams);
        
        [request setHTTPBody:[strParams dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                               
                               NSLog(@"\n\n **************** Response from Server (%@)  **************** \n\n%@\n\n", urlString, json_string);
                               
                               
                               SBJSON *parser = [[SBJSON alloc] init];
                               id server_response = [parser objectWithString:json_string error:nil];
                               
                               completionBlock(server_response, error);
                           }];
}

@end
