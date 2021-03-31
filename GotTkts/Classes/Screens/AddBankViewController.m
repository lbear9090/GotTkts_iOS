//
//  AddBankViewController.m
//  GotTkts
//
//  Created by Jorge Siu on 12/19/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "AddBankViewController.h"
#import "JVFloatLabeledTextField.h"
#import "HSDatePickerViewController.h"

@interface AddBankViewController ()<HSDatePickerViewControllerDelegate>
{
    IBOutlet JVFloatLabeledTextField *txtFirstname;
    IBOutlet JVFloatLabeledTextField *txtLastname;
    IBOutlet JVFloatLabeledTextField *txtCity;
    IBOutlet JVFloatLabeledTextField *txtState;
    IBOutlet JVFloatLabeledTextField *txtAddress;
    IBOutlet JVFloatLabeledTextField *txtZipcode;
    IBOutlet JVFloatLabeledTextField *txtSSN;
    IBOutlet JVFloatLabeledTextField *txtRouting;
    IBOutlet JVFloatLabeledTextField *txtAccount;
    IBOutlet JVFloatLabeledTextField *txtBirthday;
    IBOutlet UIView *viewbank;
    IBOutlet UIView *viewCard;
    IBOutlet UIButton *btnbank;
    IBOutlet UIButton *btnCard;
    IBOutlet JVFloatLabeledTextField *txtMonth;
    IBOutlet JVFloatLabeledTextField *txtYear;
    IBOutlet JVFloatLabeledTextField *txtCVC;
    IBOutlet JVFloatLabeledTextField *txtCardNumber;
}
@end

@implementation AddBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    txtRouting.delegate = self;
    txtSSN.delegate = self;
    txtYear.delegate = self;
    txtMonth.delegate = self;
    
    [self onbank:nil];
}

- (IBAction)onbank:(id)sender {
    viewbank.hidden = NO;
    viewCard.hidden = YES;
    btnbank.selected = YES;
    btnCard.selected = NO;
}
- (IBAction)onCard:(id)sender {
    viewbank.hidden = YES;
    viewCard.hidden = NO;
    btnbank.selected = NO;
    btnCard.selected = YES;
}

- (IBAction)onback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBirthday:(id)sender {
    HSDatePickerViewController *hsdpvc = [[HSDatePickerViewController alloc] init];
//    if (selectedTag == 200 && txtEndDate.text.length > 0){
//        hsdpvc.date = [NSDate dateFromString:txtEndDate.text withFormat:NSDateFormatDmy4Hm24 andTimeZone:NSDateTimeZoneUTC];
//    }
    hsdpvc.delegate = self;
    [self presentViewController:hsdpvc animated:YES completion:nil];
}

- (void)hsDatePickerPickedDate:(NSDate *)date {
    txtBirthday.text = [NSDate stringFromDate:date withFormat:NSDateFormatDmy4 andTimeZone:NSDateTimeZoneUTC];
}

- (IBAction)onConnect:(id)sender {
    if (![self isValid]){
        return;
    }
    if (![Util isConnectableInternet]){
        [Util showAlertTitle:self title:@"Error" message:@"The Internet connection appears to be offline"];
        return;
    }
    NSString *birthday = txtBirthday.text;
    NSArray *split = [birthday componentsSeparatedByString:@"/"];
    NSString *day = split[0];
    NSString *month = split[1];
    NSString *year = split[2];
    NSDictionary *params = [NSDictionary new];
    if (btnbank.selected){
        params = @{
                  @"pay_method" : @"bank",
                  @"fname" : txtFirstname.text,
                  @"lname" : txtLastname.text,
                  @"city" : txtCity.text,
                  @"state" : txtState.text,
                  @"dobday": day,
                  @"dobmonth": month,
                  @"dobyear": year,
                  @"address_line_1": txtAddress.text,
                  @"ssn": txtSSN.text,
                  @"routingnumber": txtRouting.text,
                  @"accnumber": txtAccount.text,
                  @"sub": @"Connect",
                  @"user_id": [UserModel currentUser].user_id,
                  @"user_type": @"user",
                  };
    } else {
        params = @{
                   @"pay_method" : @"card",
                   @"fname" : txtFirstname.text,
                   @"lname" : txtLastname.text,
                   @"city" : txtCity.text,
                   @"state" : txtState.text,
                   @"dobday": day,
                   @"dobmonth": month,
                   @"dobyear": year,
                   @"address_line_1": txtAddress.text,
                   @"ssn": txtSSN.text,
                   @"sub": @"Connect",
                   @"user_id": [UserModel currentUser].user_id,
                   @"user_type": @"user",
                   @"number": txtCardNumber.text,
                   @"exp_month": txtMonth.text,
                   @"exp_year": txtYear.text,
                   @"cvc": txtCVC.text
                   };
    }
    [SVProgressHUD showWithStatus:@"Please wait..."];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [UserModel currentUser].token] forHTTPHeaderField:@"Authorization"];
    [manager POST:REQUEST_ADD_BANK parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        [SVProgressHUD dismiss];
        Response *response = [[Response alloc] initWithDictionary:(NSDictionary *) responseObject];
        if (response.isSuccess){
            [Util showAlertTitle:self title:@"Success" message:@"Your bank account added successfully." finish:^(void){
                [self onback:nil];
            }];
        } else {
            [self showError:response.errMsg];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [self showError:[error localizedDescription]];
    }];
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    if (textField == txtRouting){
        return newLength <= 9 || returnKey;
    } else if (textField == txtSSN) {
        return newLength <= 4 || returnKey;
    } else if (textField == txtMonth){
        return newLength <= 2 || returnKey;
    } else if (textField == txtYear){
        return newLength <= 4 || returnKey;
    } else {
        return YES;
    }
}

- (BOOL) isValid {
    txtFirstname.text = [Util trim:txtFirstname.text];
    txtLastname.text = [Util trim:txtLastname.text];
    txtCity.text = [Util trim:txtCity.text];
    txtState.text = [Util trim:txtState.text];
    txtAddress.text = [Util trim:txtAddress.text];
    txtZipcode.text = [Util trim:txtZipcode.text];
    txtSSN.text = [Util trim:txtSSN.text];
    txtRouting.text = [Util trim:txtRouting.text];
    txtAccount.text = [Util trim:txtAccount.text];
    txtCardNumber.text = [Util trim:txtCardNumber.text];
    txtMonth.text = [Util trim:txtMonth.text];
    txtYear.text = [Util trim:txtYear.text];
    txtCVC.text = [Util trim:txtCVC.text];
    if (txtFirstname.text.length == 0){
        [self showError:@"Please enter your first name."];
        return NO;
    }
    if (txtLastname.text.length == 0){
        [self showError:@"Please enter your last name."];
        return NO;
    }
    if (txtCity.text.length == 0){
        [self showError:@"Please enter your city."];
        return NO;
    }
    if (txtState.text.length == 0){
        [self showError:@"Please enter your state."];
        return NO;
    }
    if (txtAddress.text.length == 0){
        [self showError:@"Please enter your address."];
        return NO;
    }
    if (txtBirthday.text.length == 0){
        [self showError:@"Please enter your birthday."];
        return NO;
    };
    if (txtSSN.text.length == 0){
        [self showError:@"Please enter your SSN."];
        return NO;
    }
    if (txtSSN.text.length != 4){
        [self showError:@"Invalid SSN."];
        return NO;
    }
    if (btnbank.selected){
        if (txtRouting.text.length == 0){
            [self showError:@"Please enter your routing number."];
            return NO;
        }
        if (txtRouting.text.length != 9){
            [self showError:@"Routing number must have 9 digits."];
            return NO;
        }
        if (txtAccount.text.length == 0){
            [self showError:@"Please enter your account number."];
            return NO;
        }
    } else if (btnCard.selected){
        if (txtCardNumber.text.length == 0){
            [self showError:@"Please enter your card number."];
            return NO;
        }
        if (txtMonth.text.length == 0){
            [self showError:@"Please enter month."];
            return NO;
        }
        if (txtYear.text.length == 0){
            [self showError:@"Please enter year."];
            return NO;
        }
        if (txtCVC.text.length == 0){
            [self showError:@"Please enter CVC."];
            return NO;
        }
        if ([txtMonth.text intValue] > 12){
            [self showError:@"Invalid month value."];
            return NO;
        }
    }
    
    return YES;
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
