//
//  MenuViewController.m
//  GotTkts
//
//  Created by Jorge on 10/22/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "MenuViewController.h"
#import "UserModel.h"
#import "ProfileViewController.h"
#import "MainViewController.h"
#import "SettingsViewController.h"
#import "LoginViewController.h"
#import "CreateEventOneViewController.h"
#import "MyTicketsViewController.h"
#import "AddBankViewController.h"

enum {
    TAG_PROFILE = 100,
    TAG_TICKETS = 200,
    TAG_FIND_EVENTS = 300,
    TAG_CREAT_EVENT = 400,
    TAG_SETTINGS = 500,
    TAG_MANGE_EVENTS = 600
};

@interface MenuViewController ()
{
    IBOutlet CircleImageView *imgAvatar;
    
}
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UserModel *me = [UserModel currentUser];
    if (me.avatar){
        [imgAvatar hnk_setImageFromURL:[NSURL URLWithString:me.avatar]];
    }
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)onAction:(id)sender {
    NSInteger tag = [sender tag];
    switch (tag) {
        case TAG_PROFILE:
            [self onProfile];
            break;
        case TAG_TICKETS:
            [self onMyTickets];
            break;
        case TAG_FIND_EVENTS:
            [self onEvents];
            break;
        case TAG_CREAT_EVENT:
            [self onCreate];
            break;
        case TAG_SETTINGS:
            [self onSettings];
            break;
        case TAG_MANGE_EVENTS:
            [self onManagerEvents];
            break;
    }
}
- (IBAction)logOutBtnTap:(id)sender {
    NSString *msg = @"Are you sure want to sign out?";
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    alert.customViewColor = MAIN_COLOR;
    alert.horizontalButtons = YES;
    [alert addButton:@"Yes" actionBlock:^(void) {
        for (UIViewController *vc in self.navigationController.viewControllers){
            if ([vc isKindOfClass:[LoginViewController class]]){
                [Util setLoginUserName:@"" password:@""];
                [SVProgressHUD dismiss];
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }];
    [alert addButton:@"No" actionBlock:^(void) {
        
    }];
    [alert showQuestion:@"Sign Out" subTitle:msg closeButtonTitle:nil duration:0.0f];
}

- (IBAction)onAvatar:(id)sender {
    [self onProfile];
}

- (void) onMyTickets {
    MyTicketsViewController *vc = (MyTicketsViewController *)[Util getUIViewControllerFromStoryBoard:@"MyTicketsViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) onProfile {
    ProfileViewController *vc = (ProfileViewController *)[Util getUIViewControllerFromStoryBoard:@"ProfileViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) onCreate {
    CreateEventOneViewController *vc = (CreateEventOneViewController *)[Util getUIViewControllerFromStoryBoard:@"CreateEventOneViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) onSettings {
    SettingsViewController *vc = (SettingsViewController *)[Util getUIViewControllerFromStoryBoard:@"SettingsViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) onEvents {
    MainViewController *vc = (MainViewController *)[Util getUIViewControllerFromStoryBoard:@"MainViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) onManagerEvents {
    ManageEventsViewController *vc = (ManageEventsViewController *)[Util getUIViewControllerFromStoryBoard:@"ManageEventsViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) onLogout {
    NSString *msg = @"Are you sure want to sign out?";
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    alert.customViewColor = MAIN_COLOR;
    alert.horizontalButtons = YES;
    [alert addButton:@"Yes" actionBlock:^(void) {
        for (UIViewController *vc in self.navigationController.viewControllers){
            if ([vc isKindOfClass:[LoginViewController class]]){
                [SVProgressHUD dismiss];
                [self.navigationController popViewControllerAnimated:vc];
            }
        }
    }];
    [alert addButton:@"No" actionBlock:^(void) {
        [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
    }];
    [alert showQuestion:@"Sign Out" subTitle:msg closeButtonTitle:nil duration:0.0f];
}
- (IBAction)payoutBtnTap:(id)sender {
    AddBankViewController *vc = (AddBankViewController *)[Util getUIViewControllerFromStoryBoard:@"AddBankViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
