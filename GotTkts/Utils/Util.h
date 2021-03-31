//
//  Util.h
//  NorgesVPN
//
//  Created by IOS7 on 7/22/14.
//  Copyright (c) 2014 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"
#import <Photos/Photos.h>
#import "Event.h"

#import "NSString+Case.h"
#import "NSString+VTContainsSubstring.h"
#import "NSString+UrlEncode.h"
#import "NSString+Email.h"

#import "NSDate+Helpers.h"
#import "NSDate+Escort.h"
#import "NSDate+TimeDifference.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+AFNetworking_UIActivityIndicatorView.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"

#import "AppDelegate.h"
#import "CustomIOS7AlertView.h"
#import "SVProgressHUD.h"

#import "HttpApi.h"


#define SCREEN_WIDTH                       [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                      [UIScreen mainScreen].bounds.size.height

#define PARSE_SERVER_BASE                  @"parse.brainyapps.com"
#define PARSE_CDN_BASE                     @"d2zvprcpdficqw.cloudfront.net"
#define PARSE_CDN_DECNUM                   10000

#define COLOR_BLUE_LIGHT            [UIColor colorWithRed:0/255.0 green:125/255.0 blue:255.0 alpha:1.0]
#define COLOR_BLUE                  [UIColor colorWithRed:24/255.0 green:48/255.0 blue:88/255.0 alpha:1.0]
#define COLOR_BLUE_DARK             [UIColor colorWithRed:16/255.0 green:27/255.0 blue:47/255.0 alpha:1.0]
#define COLOR_GREEN                 [UIColor colorWithRed:89/255.0 green:191/255.0 blue:49/255.0 alpha:1.0]
#define COLOR_ORANGE                [UIColor colorWithRed:1.0 green:82/255.0 blue:16/255.0 alpha:1.0]

#define COLOR_YELLOW                [UIColor colorWithRed:254/255.0 green:188/255.0 blue:17/255.0 alpha:1.0]
#define COLOR_YELLOW_               [UIColor colorWithRed:254/255.0 green:188/255.0 blue:17/255.0 alpha:1.0]
#define COLOR_GRAY_DARK             [UIColor colorWithRed:109/255.0 green:110/255.0 blue:113/255.0 alpha:1.0]
#define COLOR_GRAY_LIGHT            [UIColor colorWithRed:147/255.0 green:149/255.0 blue:152/255.0 alpha:1.0]
#define COLOR_ORANGE                [UIColor colorWithRed:20133/255.0 green:77/255.0 blue:45/255.0 alpha:1.0]


#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif

#define MONTH_WRDS               [[NSArray alloc] initWithObjects:@"JAN", @"FEB", @"MAR", @"APR", @"MAY", @"JUN", @"JUL", @"AUG", @"SEP", @"OCT", @"NOV", @"DEC", nil]
#define MONTHS               [[NSArray alloc] initWithObjects:@"January", @"Febraury", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December", nil]


@interface Util : NSObject

+ (NSString *) randomStringWithLength: (int) len ;
+ (void) setCircleView:(UIView*) view;
+ (void) setCornerView:(UIView*) view;
+ (void) setBorderView:(UIView *)view color:(UIColor*)color width:(CGFloat)width;
+ (void) setCornerCollection:(NSArray*) collection ;
+ (void) setBorderCollection:(NSArray*) collection color:(UIColor*)color ;
+ (UIViewController*) getUIViewControllerFromStoryBoard:(NSString*) storyboardIdentifier ;
+ (UIViewController *) getNewViewControllerFromStoryBoard:(NSString *) storyboardIdentifier;
+ (void) showAlertTitle:(UIViewController *)vc title:(NSString *)title message:(NSString *)message;
+ (void) showAlertTitle:(UIViewController *)vc title:(NSString *)title message:(NSString *)message info:(BOOL)info;
+ (void) showAlertTitle:(UIViewController *)vc title:(NSString *)title message:(NSString *)message finish:(void (^)(void))finish;
+ (CustomIOS7AlertView*) showCustomAlertView:(UIView *) parentView view:(UIView *) view buttonTitleList:(NSMutableArray *)buttonTitleList completionBlock: (void (^)(int buttonIndex))completionBlock;

+ (AppDelegate *) appDelegate ;
+ (UIViewController*) getUIViewControllerFromStoryBoard:(NSString*) storyboardIdentifier ;
+ (BOOL) getBoolValue:(NSString *) key;
+ (void) setBoolValue:(NSString *) key value:(BOOL) val;

+ (void) setLoginUserName:(NSString*) userName password:(NSString*) password;
+ (NSString*) getLoginUserName;
+ (NSString*) getLoginUserPassword;

+ (UITextField *)getTextFieldFromSearchBar:(UISearchBar *)searchBar;

+ (CGFloat) getLabelWidthByMessage :(NSString *) message fontSize:(CGFloat) fontSize ;

+ (UIImage *)getUploadingImageFromImage:(UIImage *)image ;
+ (UIImage *)getSquareImage:(UIImage *)originalImage ;

+ (void) drawBorderLine:(UIView *) view upper: (BOOL)isUpper bottom:(BOOL) isBottom bottomDiff:(CGFloat) bottomDiff borderColor:(UIColor*) borderColor ;
+ (void) removeBorderLine:(UIView*) view removeColor:(UIColor*) removeColor ;

+ (NSDate*) convertString2HourTime:(NSString*) dateString ;
+ (NSString *) convertDate2String:(NSDate*) date ;

+ (NSString *) trim:(NSString *) string;

+ (NSString *) getDocumentDirectory ;


+ (void) sendPushNotification:(NSString *)type receiverList:(NSArray*) receiverList dataInfo:(id)dataInfo ;
+ (NSString *)urlparseCDN:(NSString *)url;

+ (void) animationExchangeView:(UIView *)parent src:(UIView *)src dst:(UIView *)dst duration:(NSTimeInterval)duration back:(BOOL)back vertical:(BOOL)vertical;

+ (NSString *) getParseDate:(NSDate *)date;
+ (BOOL)isToday:(NSDate *)date;
+ (NSDate *)dateStartOfDay:(NSDate *)date;

+ (NSString *) getExpireDateString:(NSDate *)date;
+ (NSString *) convertDate2StringWithFormat:(NSDate*) date dateFormat:(NSString*) format  ;

+ (void) sendPushNotification:(NSString *)email message:(NSString *)message type:(int)type ;
+ (void) sendEmail:(NSString *)email subject:(NSString *)subject message:(NSString *)message ;

+ (BOOL) isConnectableInternet;
+ (BOOL) isPhotoAvaileble ;
+ (BOOL) isCameraAvailable;

+ (void) showWaitingDialog:(NSString *) text view:(UIView *)view;

+ (void)makeCallWithNumber:(NSString *)number;

+ (NSString *) getMonthString:(int) month;

+ (NSDate *) getDateFromString:(NSString *) dateString formatter:(NSString *) formatterStr;

+ (NSString *) dateStringofEvent:(NSString *)datetime ;
@end

