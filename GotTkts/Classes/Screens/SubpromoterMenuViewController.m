//
//  SubpromoterMenuViewController.m
//  GotTkts
//
//  Created by Jorge Siu on 12/30/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "SubpromoterMenuViewController.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "PromotingEventsViewController.h"
#import "PendingRequestsViewController.h"
#import "TicketsSoldViewController.h"
#import "PaymentReceivedViewController.h"

@interface SubpromoterMenuViewController ()
{
    IBOutlet CircleImageView *imgAvatar;
    IBOutlet UIView *viewTitle;
    IBOutlet UIView *viewOne;
    IBOutlet UIView *viewTwo;
    IBOutlet UIView *viewThree;
    IBOutlet UIView *viewFour;
    IBOutlet UIView *viewFive;
}
@end

@implementation SubpromoterMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [Util setCornerView:viewTitle];
    [Util setCornerView:viewOne];
    [Util setCornerView:viewTwo];
    [Util setCornerView:viewThree];
    [Util setCornerView:viewFour];
    [Util setCornerView:viewFive];
    
}

- (IBAction)onAvatar:(id)sender {
}

- (IBAction)onLogout:(id)sender {
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

- (IBAction)onEvents:(id)sender {
    MainViewController *vc = (MainViewController *)[Util getUIViewControllerFromStoryBoard:@"MainViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onPromoting:(id)sender {
    PromotingEventsViewController *vc = (PromotingEventsViewController *)[Util getUIViewControllerFromStoryBoard:@"PromotingEventsViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)onPending:(id)sender {
    PendingRequestsViewController *vc = (PendingRequestsViewController *)[Util getUIViewControllerFromStoryBoard:@"PendingRequestsViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)onTickets:(id)sender {
    TicketsSoldViewController *vc = (TicketsSoldViewController *)[Util getUIViewControllerFromStoryBoard:@"TicketsSoldViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)onPayment:(id)sender {
    PaymentReceivedViewController *vc = (PaymentReceivedViewController *)[Util getUIViewControllerFromStoryBoard:@"PaymentReceivedViewController"];
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
