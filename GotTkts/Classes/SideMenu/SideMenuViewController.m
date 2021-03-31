//
//  SideMenuViewController.m
//  PagaYa
//
//  Created by developer on 29/05/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import "SideMenuViewController.h"
#import "LoginViewController.h"
#import "UserModel.h"

static SideMenuViewController *_sharedViewController = nil;

@interface SideMenuViewController ()
{
    IBOutlet UIView *viewHome;
    IBOutlet UIView *viewProfile;
    IBOutlet UIView *viewCategory;
    IBOutlet UIView *viewTrade;
    IBOutlet UIView *viewFavorite;
    IBOutlet UIView *viewMessages;
    IBOutlet UIView *viewAbout;
    IBOutlet UIView *viewSettings;
    IBOutlet UIView *viewSignOut;
    
    IBOutlet UILabel *lblFullname;
    IBOutlet CircleImageView *imgAvatar;
}
@end

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _sharedViewController = self;
    [Util setBorderView:imgAvatar color:[UIColor whiteColor] width:1.0f];
    
    UserModel *me = [UserModel currentUser];
    if (me.fullname){
        lblFullname.text = me.fullname;
    } else if (me.firstname){
        lblFullname.text = [NSString stringWithFormat:@"%@ %@", me.firstname, me.lastname];
    }
    if (me.avatar){
        [imgAvatar hnk_setImageFromURL:[NSURL URLWithString:me.avatar]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

+ (SideMenuViewController *)getInstance{
    return _sharedViewController;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void) clearMenuColor{
    viewHome.backgroundColor = MAIN_COLOR;
    viewCategory.backgroundColor = MAIN_COLOR;
    viewTrade.backgroundColor = MAIN_COLOR;
    viewFavorite.backgroundColor = MAIN_COLOR;
    viewMessages.backgroundColor = MAIN_COLOR;
    viewAbout.backgroundColor = MAIN_COLOR;
    viewSettings.backgroundColor = MAIN_COLOR;
    viewSignOut.backgroundColor = MAIN_COLOR;
    viewProfile.backgroundColor = MAIN_COLOR;
}

- (IBAction)onHome:(id)sender {
    [self clearMenuColor];
    viewHome.backgroundColor = COLOR_BLUE_LIGHT;
    [NSNotificationCenter.defaultCenter postNotificationName:NOTIFICATION_PAGE_HOME object:nil];
}
- (IBAction)onProfile:(id)sender {
    [self clearMenuColor];
    viewProfile.backgroundColor = COLOR_BLUE_LIGHT;
    [NSNotificationCenter.defaultCenter postNotificationName:NOTIFICATION_PAGE_PROFILE object:nil];
}
- (IBAction)onCategory:(id)sender {
    [self clearMenuColor];
    viewCategory.backgroundColor = COLOR_BLUE_LIGHT;
    [NSNotificationCenter.defaultCenter postNotificationName:NOTIFICATION_PAGE_CATEGORY object:nil];
}
- (IBAction)onTrade:(id)sender {
    [self clearMenuColor];
    viewTrade.backgroundColor = COLOR_BLUE_LIGHT;
    [NSNotificationCenter.defaultCenter postNotificationName:NOTIFICATION_PAGE_TRADE object:nil];
}
- (IBAction)onFavorite:(id)sender {
    [self clearMenuColor];
    viewFavorite.backgroundColor = COLOR_BLUE_LIGHT;
    [NSNotificationCenter.defaultCenter postNotificationName:NOTIFICATION_PAGE_FAVORITE object:nil];
}
- (IBAction)onMessages:(id)sender {
    [self clearMenuColor];
    viewMessages.backgroundColor = COLOR_BLUE_LIGHT;
    [NSNotificationCenter.defaultCenter postNotificationName:NOTIFICATION_PAGE_MESSAGE object:nil];
}

- (IBAction)onAbout:(id)sender {
    [self clearMenuColor];
    viewAbout.backgroundColor = COLOR_BLUE_LIGHT;
    [NSNotificationCenter.defaultCenter postNotificationName:NOTIFICATION_PAGE_ABOUT object:nil];
}
- (IBAction)onSettings:(id)sender {
    [self clearMenuColor];
    viewSettings.backgroundColor = COLOR_BLUE_LIGHT;
    [NSNotificationCenter.defaultCenter postNotificationName:NOTIFICATION_PAGE_SETTINGS object:nil];
}
- (IBAction)onSignout:(id)sender {
    NSString *msg = @"Are you sure want to sign out?";
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    alert.customViewColor = MAIN_COLOR;
    alert.horizontalButtons = YES;
    [alert addButton:@"Yes" actionBlock:^(void) {
        [SVProgressHUD showWithStatus:@"Signing out..." maskType:SVProgressHUDMaskTypeClear];
//        [PFUser logOutInBackgroundWithBlock:^(NSError *error){
            for (UIViewController *vc in self.navigationController.viewControllers){
                if ([vc isKindOfClass:[LoginViewController class]]){
                    [SVProgressHUD dismiss];
                    [Util setLoginUserName:@"" password:@""];
                    [self.navigationController popViewControllerAnimated:vc];
                }
            }
//        }];
    }];
    [alert addButton:@"No" actionBlock:^(void) {
        [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
    }];
    [alert showQuestion:@"Sign Out" subTitle:msg closeButtonTitle:nil duration:0.0f];
}


@end
