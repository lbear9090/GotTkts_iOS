//
//  SettingsViewController.m
//  GotTkts
//
//  Created by Jorge on 7/4/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "SettingsViewController.h"
#import "MainViewController.h"
#import "InformViewController.h"
#import "LoginViewController.h"
#import "AccountResponse.h"
#import "StripeConnectViewController.h"
#import "AddBankViewController.h"

@interface SettingsViewController ()
{
    
    IBOutlet UILabel *lblStripe;
}
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([UserModel currentUser].account_id.length > 0){
        [self setStripeLabel];
//        return;
    }
    if (![Util isConnectableInternet]){
        [Util showAlertTitle:self title:@"Error" message:@"The Internet connection appears to be offline."];
        return;
    }
    NSDictionary *params = @{
                             @"id" : [UserModel currentUser].user_id
                             };
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [UserModel currentUser].token] forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager POST:REQUEST_GET_ACCOUNTID parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        [SVProgressHUD dismiss];
        AccountResponse *response = [[AccountResponse alloc] initWithDictionary:responseObject];
        if (response.accountId.length > 0){
            [UserModel currentUser].account_id = response.accountId;
        }
        [self setStripeLabel];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [self showError:[error localizedDescription]];
    }];
}

- (void) setStripeLabel {
    NSString *account = [UserModel currentUser].account_id;
    if (account.length == 0){
        lblStripe.text = @"Connect Stripe";
    } else {
        NSString *end = [account substringFromIndex: [account length] - 4];
        lblStripe.text = [NSString stringWithFormat:@"Connected acct_***%@", end];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onMenu:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onFaq:(id)sender {
    [self onNextPage:FLAG_FAQ];
}

- (IBAction)onPrivacy:(id)sender {
    [self onNextPage:FLAG_PRIVACY];
}

- (IBAction)onTerms:(id)sender {
    [self onNextPage:FLAG_TERMS];
}

- (void) onNextPage:(NSInteger) type {
    InformViewController *vc = (InformViewController *)[Util getUIViewControllerFromStoryBoard:@"InformViewController"];
    vc.type = type;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onStripe:(id)sender {
//    if ([UserModel currentUser].account_id.length > 0){
//        return;
//    }
//    StripeConnectViewController *vc = (StripeConnectViewController *)[Util getUIViewControllerFromStoryBoard:@"StripeConnectViewController"];
//    [self.navigationController pushViewController:vc animated:YES];
    [self onBank:nil];
}

- (IBAction)onBank:(id)sender {
    AddBankViewController *vc = (AddBankViewController *)[Util getUIViewControllerFromStoryBoard:@"AddBankViewController"];
    [self.navigationController pushViewController:vc animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
