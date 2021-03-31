//
//  AppDelegate.m
//  PagaYa
//
//  Created by developer on 28/05/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <GoogleMaps/GoogleMaps.h>
#import <Stripe/Stripe-Swift.h>
#import <GooglePlaces/GooglePlaces.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
    // Push Notification
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge];
    }
    
    // Parse init -- this is for location :)
    [PFUser enableAutomaticUser];
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"56955cc6-ef63-4fc9-b512-e34ee34dbe76";
        configuration.clientKey = @"444076b5-fce3-4925-ab6d-333b8b687b09";
        configuration.server = @"https://parse.brainyapps.com:20004/parse";
    }]];
    [PFUser enableRevocableSessionInBackground];
    
    [GMSServices provideAPIKey:@"AIzaSyC45jrHZaFCIs76fbt9uWJN89khbB8ZnIA"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyC45jrHZaFCIs76fbt9uWJN89khbB8ZnIA"];
    
    // Stripe init
    [STPPaymentConfiguration.sharedConfiguration setPublishableKey:STRIPE_KEY];
    
    return YES;
}

- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
}

/*
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    
    return [[FBSDKApplicationDelegate sharedInstance] application:app
                                                          openURL:url
                                                          options:options];
}

 */

- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSInteger pushType = [[userInfo objectForKey:PUSH_NOTIFICATION_TYPE] integerValue];
    application.applicationIconBadgeNumber = 0;
    
    if (application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground) {
        
    } else { // active status
        
    }
    
    if (pushType == PUSH_TYPE_CHAT){
//        if ([ChatDetailsViewController getInstance]){
//            NSString *roomId = [userInfo objectForKey:@"data"];
//            if ([roomId isEqualToString:[AppStateManager sharedInstance].chatRoomId]){
//                [NSNotificationCenter.defaultCenter postNotificationName:kChatReceiveNotification object:nil];
//            } else {
//                NSString *pushMsg = [[userInfo objectForKey:@"alert"] stringValue];
//
//                UILocalNotification* localNotification = [[UILocalNotification alloc] init];
//                localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
//                localNotification.alertTitle = @"New message";
//                localNotification.alertBody = pushMsg;
//                localNotification.timeZone = [NSTimeZone defaultTimeZone];
//                [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
//            }
//        } else {
//            [NSNotificationCenter.defaultCenter postNotificationName:kChatReceiveRoomsNotification object:nil];
//            NSDictionary *data = userInfo[@"aps"];
//            NSString *pushMsg = [data objectForKey:@"alert"];
//
//            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
//            localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
//            localNotification.alertTitle = @"New message";
//            localNotification.alertBody = pushMsg;
//            localNotification.timeZone = [NSTimeZone defaultTimeZone];
//            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
//        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
