//
//  NSString+Email.m
//
//  Created by Liam Parker on 6/02/13.
//  Copyright (c) 2013 Karma Imperial. All rights reserved.
//

#import "NSString+Email.h"

@implementation NSString (Email)

- (BOOL)isEmail{
    NSString *emailRegex = @"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:self];
    return isValid;
}

- (BOOL)isPhone{
    NSString *phoneRegex = @"\\+[0-9][0-9]{6}([0-9]{3,8})?";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL isValid = [test evaluateWithObject:self];
    return isValid;
}


@end
