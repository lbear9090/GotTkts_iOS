//
//  ResetPasswordViewController.m
//  GotTkts
//
//  Created by Jorge on 7/3/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "SignUpViewController.h"

@interface ResetPasswordViewController ()
{
    IBOutlet UITextField *txtEmail;
    
}
@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [Util setCornerView:txtEmail];
    [Util setBorderView:txtEmail color:[UIColor lightGrayColor] width:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSubmit:(id)sender {
    NSString *email = [Util trim:txtEmail.text];
    txtEmail.text = email;
    
    if (email.length == 0){
        [txtEmail resignFirstResponder];
        [Util showAlertTitle:self title:@"Reset password" message:@"Please input Email" finish:^(void) {
            [txtEmail becomeFirstResponder];
        }];
        return;
    }
    
    if (![email isEmail]){
        [Util showAlertTitle:self title:@"Reset password" message:@"Please input valid Email" finish:^(void){
            [txtEmail becomeFirstResponder];
        }];
        return;
    }
    
    if (![Util isConnectableInternet]){
        [Util showAlertTitle:self title:@"Error" message:@"The Internet connection appears to be offline"];
        return;
    }
    
    NSDictionary *params = @{
                             @"email" : txtEmail.text
                             };
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager POST:REQUEST_RESET_PWD parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        [SVProgressHUD dismiss];
        Response *response = [[Response alloc] initWithDictionary:(NSDictionary *) responseObject];
        if (response.isSuccess){
            [Util showAlertTitle:self title:@"Reset Password" message:@"Reset Password link is sent to your email. Please check your email." finish:^(void){
                [self onback:nil];
            }];
        } else {
            [Util showAlertTitle:self title:@"Error" message:response.errMsg finish:^(void){
                
            }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [self showError:error.localizedDescription];
    }];
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
