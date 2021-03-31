//
//  LoginViewController.m
//  GotTkts
//
//  Created by Jorge on 7/3/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "ResetPasswordViewController.h"
#import "SignUpViewController.h"
#import "MainViewController.h"
#import "MFSideMenu.h"
#import "SideMenuViewController.h"
#import "UserModel.h"
#import "MenuViewController.h"
#import "SubpromoterMenuViewController.h"

@interface LoginViewController ()
{
    IBOutlet UIView *viewEdit;
    
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtPassword;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Util setBorderView:viewEdit color:[UIColor lightGrayColor] width:1.0];
    [Util setCornerView:viewEdit];
    
    if ([Util getLoginUserName].length > 0){
        txtEmail.text = [Util getLoginUserName];
        txtPassword.text = [Util getLoginUserPassword];
        [self onLogin:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


- (IBAction)onSignUp:(id)sender {
    SignUpViewController *vc = (SignUpViewController *)[Util getUIViewControllerFromStoryBoard:@"SignUpViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onPassword:(id)sender {
    ResetPasswordViewController *vc = (ResetPasswordViewController *)[Util getUIViewControllerFromStoryBoard:@"ResetPasswordViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onLogin:(id)sender {
    
#ifdef DEBUG
    if ([txtEmail.text isEqualToString:@"a"]){
        txtEmail.text = @"tyharrisnyc@gmail.com"; // promoter
        txtPassword.text = @"djleft3784";
    }
    if ([txtEmail.text isEqualToString:@"b"]){
        txtEmail.text = @"djleft@me.com"; // promoter
        txtPassword.text = @"djleft3784";
    }
#endif

    
    if (![self isValid]){
        return;
    }
    
    if (![Util isConnectableInternet]){
        [Util showAlertTitle:self title:@"Error" message:@"The Internet connection appears to be offline"];
        return;
    }
    
    NSDictionary *params = @{
                             @"email" : txtEmail.text,
                             @"password" : txtPassword.text
                             };
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager POST:REQUEST_SIGN_IN parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        [SVProgressHUD dismiss];
        UserModel *response = [[UserModel alloc] initWithDictionary:(NSDictionary *) responseObject];
        if (response.isSuccess){
            [Util setLoginUserName:txtEmail.text password:txtPassword.text];
            [self gotoMainScreen];
        } else {
            [self showError:response.errMsg];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [self showError:@"Login Failed."];
    }];
}


- (void) gotoMainScreen {
    if ([[UserModel currentUser].role_id intValue] == 2) { // sub promoter - 2
        SubpromoterMenuViewController *vc = (SubpromoterMenuViewController *)[Util getUIViewControllerFromStoryBoard:@"SubpromoterMenuViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        MenuViewController *mainVC = (MenuViewController *)[Util getUIViewControllerFromStoryBoard:@"MenuViewController"];
        [self.navigationController pushViewController:mainVC animated:YES];
    }
    txtEmail.text = @"";
    txtPassword.text = @"";
//    UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:mainVC];
//    [mainNav setNavigationBarHidden:YES];
//
//    SideMenuViewController *leftMenuViewController = (SideMenuViewController*) [Util getUIViewControllerFromStoryBoard:@"SideMenuViewController"];
//
//    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
//                                                    containerWithCenterViewController:mainNav
//                                                    leftMenuViewController:leftMenuViewController
//                                                    rightMenuViewController:nil];
//    [container setLeftMenuWidth:280];
//    [container setPanMode:MFSideMenuPanModeSideMenu];
//
//    [self.navigationController pushViewController:container animated:YES];
}

- (BOOL) isValid {
    txtEmail.text = [Util trim:txtEmail.text];
    if (txtEmail.text.length == 0){
        [Util showAlertTitle:self title:@"Error" message:@"Please enter email address." finish:^(void){
            [txtEmail becomeFirstResponder];
        }];
        return NO;
    }
    if (![txtEmail.text isEmail]){
        [Util showAlertTitle:self title:@"Error" message:@"Please enter valid address." finish:^(void){
            [txtEmail becomeFirstResponder];
        }];
        return NO;
    }
    if (txtPassword.text.length == 0){
        [Util showAlertTitle:self title:@"Error" message:@"Please enter password." finish:^(void){
            [txtPassword becomeFirstResponder];
        }];
        return NO;
    }
    
    return YES;
}


@end
