//
//  MainViewController.h
//  GotTkts
//
//  Created by Jorge on 7/4/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "SuperViewController.h"
#import "MFSideMenu.h"
#import "ProfileViewController.h"
#import "CategoryViewController.h"
#import "TradeViewController.h"
#import "FavoritesViewController.h"
#import "MessagesViewController.h"
#import "InformViewController.h"
#import "SettingsViewController.h"

@interface MainViewController : SuperViewController

+ (MainViewController *)getInstance;
- (void) pushViewController:(UIViewController *) viewController;
- (void) pushViewController:(UIViewController *)viewController animation:(BOOL) animate;
- (void) presentViewController:(UIViewController *) viewController;
- (void) toggleMenu;

@end
