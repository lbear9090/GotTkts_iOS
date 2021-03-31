//
//  NSString+Case.m
//  Scriptive
//
//  Created by Josh Justice on 7/12/14.
//  Copyright (c) 2014 Scriptive. All rights reserved.
//

#import "NSString+Case.h"

@implementation NSString (Case)

/**
 * @see http://stackoverflow.com/questions/7359362/uppercase-first-letter-in-nsstring
 */
-(NSString *)uppercaseFirstString
{
    NSString *firstChar = [self substringToIndex:1];
    NSString *remainder = [self substringFromIndex:1];
    return [[firstChar uppercaseString] stringByAppendingString:remainder];
}

@end
