//
//  NSDate+TimeDifference.m
//  SOLibrary
//
//  Created by satoshi ootake on 12/04/17.
//  Copyright (c) 2012年 satoshi ootake. All rights reserved.
//

#import "NSDate+TimeDifference.h"

//--------------------------------------------------------------//
#pragma mark -- NSDate (TimeDifference) --
//--------------------------------------------------------------//
@interface NSData (TimeDifference)

- (NSString *)localizedStringForKey:(NSString *)key;

@end

@implementation NSDate (TimeDifference)

- (NSString *)localizedStringForKey:(NSString *)key
{
    static NSBundle *bundle = nil;
    if (bundle == nil)
    {
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"NSDate+TimeDifference" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:bundlePath] ?: [NSBundle mainBundle];
        
        for (NSString *language in [NSLocale preferredLanguages])
        {
            if ([[bundle localizations] containsObject:language])
            {
                bundlePath = [bundle pathForResource:language ofType:@"lproj"];
                bundle = [NSBundle bundleWithPath:bundlePath];
                break;
            }
        }
    }
    
    return [bundle localizedStringForKey:key value:nil table:nil];
}

- (NSString *) stringWithTimeDifference
{
    NSTimeInterval seconds = [self timeIntervalSinceNow];
            
    if(fabs(seconds) < 1)
        return [self localizedStringForKey:@"jast now"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date] toDate:self options:0];
    
    int year = [[components valueForKey:@"year"]integerValue];    
    if(year > 1) 
        return [NSString stringWithFormat:[self localizedStringForKey:@"%d years later"], abs(year)];
    if(year == 1)
        return [self localizedStringForKey:@"1 year later"];
    if(year == -1)
        return [self localizedStringForKey:@"1 year ago"];
    if(year < -1) 
        return [NSString stringWithFormat:[self localizedStringForKey:@"%d years ago"], abs(year)];
    
    int month = [[components valueForKey:@"month"]integerValue];    
    if(month > 1) 
        return [NSString stringWithFormat:[self localizedStringForKey:@"%d months later"], abs(month)];
    if(month == 1)
        return [self localizedStringForKey:@"1 month later"];
    if(month == -1)
        return [self localizedStringForKey:@"1 month ago"];
    if(month < -1) 
        return [NSString stringWithFormat:[self localizedStringForKey:@"%d months ago"], abs(month)];

    int week = [[components valueForKey:@"week"]integerValue];    
    if(week > 1) 
        return [NSString stringWithFormat:[self localizedStringForKey:@"%d weeks later"], abs(week)];
    if(week == 1)
        return [self localizedStringForKey:@"1 week later"];
    if(week == -1)
        return [self localizedStringForKey:@"1 week ago"];
    if(week < -1) 
        return [NSString stringWithFormat:[self localizedStringForKey:@"%d weeks ago"], abs(week)];

    int day = [[components valueForKey:@"day"]integerValue];    
    if(day > 1) 
        return [NSString stringWithFormat:[self localizedStringForKey:@"%d days later"], abs(day)];
    if(day == 1)
        return [self localizedStringForKey:@"1 day later"];
    if(day == -1)
        return [self localizedStringForKey:@"1 day ago"];
    if(day < -1) 
        return [NSString stringWithFormat:[self localizedStringForKey:@"%d days ago"], abs(day)];

    int hour = [[components valueForKey:@"hour"]integerValue];    
    if(hour > 1) 
        return [NSString stringWithFormat:[self localizedStringForKey:@"%d hours later"], abs(hour)];
    if(hour == 1)
        return [self localizedStringForKey:@"1 hour later"];
    if(hour == -1)
        return [self localizedStringForKey:@"1 hour ago"];
    if(hour < -1) 
        return [NSString stringWithFormat:[self localizedStringForKey:@"%d hours ago"], abs(hour)];

    int minute = [[components valueForKey:@"minute"]integerValue];    
    if(minute > 1) 
        return [NSString stringWithFormat:[self localizedStringForKey:@"%d minutes later"], abs(minute)];
    if(minute == 1)
        return [self localizedStringForKey:@"1 minute later"];
    if(minute == -1)
        return [self localizedStringForKey:@"1 minute ago"];
    if(minute < -1) 
        return [NSString stringWithFormat:[self localizedStringForKey:@"%d minutes ago"], abs(minute)];

    int second = [[components valueForKey:@"second"]integerValue];    
    if(second > 1) 
        return [NSString stringWithFormat:[self localizedStringForKey:@"%d seconds later"], abs(second)];
    if(second == 1)
        return [self localizedStringForKey:@"1 second later"];
    if(second == -1)
        return [self localizedStringForKey:@"1 second ago"];
    if(second < -1) 
        return [NSString stringWithFormat:[self localizedStringForKey:@"%d seconds ago"], abs(second)];

    return [self description];
}

@end
