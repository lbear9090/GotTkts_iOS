//
//  MyPaymentViewController.m
//  GotTkts
//
//  Created by Jorge on 10/22/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "MyPaymentViewController.h"
#import <Stripe/Stripe-Swift.h>
#import "MenuViewController.h"

@interface MyPaymentViewController ()<STPPaymentCardTextFieldDelegate>
{
    
    IBOutlet UIButton *btnPay;
    IBOutlet UIView *viewCard;
    
    STPPaymentCardTextField *paymentField;
    IBOutlet UIView *viewContent;
}
@end

@implementation MyPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [viewCard layoutIfNeeded];
    [viewContent layoutIfNeeded];
    paymentField = [[STPPaymentCardTextField alloc] initWithFrame:viewCard.frame];
    paymentField.delegate = self;
    [viewContent addSubview:paymentField];
}

- (IBAction)onback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onPay:(id)sender {
    STPCardParams *cardParams = paymentField.cardParams;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [[STPAPIClient sharedClient] createTokenWithCard:cardParams completion:^(STPToken *token, NSError *error){
        if (error){
            [SVProgressHUD dismiss];
            [self showError:[error localizedDescription]];
        } else {// should call purchase api
            [self payStripe:token.tokenId];
        }
    }];
}

- (void) payStripe:(NSString *) token {
    NSDictionary *params = @{
                             @"event_create_by" : [NSString stringWithFormat:@"%ld", (long)self.event.event_created_by],
                             @"event_booking_id" : self.bookData.order_id,
                             @"event_uid" : self.event.event_unique_id,
                             @"stripeToken" : token,
                             @"stripeEmail" : [UserModel currentUser].email,
                        };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [UserModel currentUser].token] forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager POST:REQUEST_TICKETS_PURCHASE parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        [SVProgressHUD dismiss];
        [Util showAlertTitle:self title:@"Success" message:@"Purchased Ticket successfully." finish:^(void){
            // goto Menu view
            for (UIViewController *vc in self.navigationController.viewControllers){
                if ([vc isKindOfClass:[MenuViewController class]]){
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [self showError:[error localizedDescription]];
    }];
}

- (void)paymentCardTextFieldDidChange:(STPPaymentCardTextField *)textField {
//    NSLog(@"Card number: %@ Exp Month: %@ Exp Year: %@ CVC: %@", textField.cardParams.number, @(textField.cardParams.expMonth), @(textField.cardParams.expYear), textField.cardParams.cvc);
    btnPay.enabled = textField.isValid;
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
