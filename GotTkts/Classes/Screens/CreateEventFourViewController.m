//
//  CreateEventFourViewController.m
//  GotTkts
//
//  Created by Dev & Ops on 2/14/19.
//  Copyright © 2019 developer. All rights reserved.
//

#import "CreateEventFourViewController.h"
#import "AddTicketsViewController.h"
#import "IQDropDownTextField.h"
#import <HSDatePickerViewController/HSDatePickerViewController.h>

@interface CreateEventFourViewController ()<IQDropDownTextFieldDelegate, HSDatePickerViewControllerDelegate>
{
    IBOutlet UITextField *txtEntertainment;
    IBOutlet UITextField *txtDresscode;
    IBOutlet UITextField *txtAge;
    IBOutlet UITextField *txtPromoCode;
    IBOutlet IQDropDownTextField *txtPromoType;
    IBOutlet UITextField *txtPercentage;
    IBOutlet UITextField *txtPkgDescription;
    IBOutlet UITextField *txtDate;
    IBOutlet UITextField *txtPkgAmount;
    
}
@end

@implementation CreateEventFourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    txtPromoType.itemList = PROMO_TYPE;
    txtPromoType.delegate = self;
}

- (IBAction)onDatePicker:(id)sender {
    HSDatePickerViewController *hsdpvc = [[HSDatePickerViewController alloc] init];
    hsdpvc.delegate = self;
    [self presentViewController:hsdpvc animated:YES completion:nil];
}

- (void)hsDatePickerPickedDate:(NSDate *)date {
    txtDate.text = [NSDate stringFromDate:date withFormat:NSDateFormatDmy4Hm24 andTimeZone:NSDateTimeZoneUTC];
}

- (IBAction)onback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onNext:(id)sender {
    if (![self isValid]){
        return;
    }
    if (txtEntertainment.text.length > 0){
        self.event.event_entertainment = txtEntertainment.text;
    } else {
        self.event.event_entertainment = @"";
    }
    if (txtDresscode.text.length > 0){
        self.event.event_dress_code = txtDresscode.text;
    } else {
        self.event.event_dress_code = @"";
    }
    if (txtAge.text.length > 0){
        self.event.event_age = txtAge.text;
    }
    if (txtPromoCode.text.length > 0){
        self.event.event_promo_code = txtPromoCode.text;
    } else {
        self.event.event_promo_code = @"";
    }
    if (txtPromoType.selectedItem.length > 0){
        self.event.event_promo_type = [PROMO_TYPE indexOfObject:txtPromoType.selectedItem];
        if (self.event.event_promo_type == 1){
            self.event.event_discount_percent = txtPercentage.text;
        }
    }
    if (txtPkgDescription.text.length > 0){
        self.event.event_package_description = txtPkgDescription.text;
        if (txtPkgAmount.text.length > 0){
            self.event.event_package_amount = txtPkgAmount.text;
        }
    } else {
        self.event.event_package_description = @"";
        self.event.event_package_amount = @"";
    }
    if (txtDate.text.length > 0){
        self.event.event_expire_datetime = txtDate.text;
    } else {
        self.event.event_expire_datetime = @"";
    }
    AddTicketsViewController *vc = (AddTicketsViewController *)[Util getUIViewControllerFromStoryBoard:@"AddTicketsViewController"];
    vc.event = self.event;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL) isValid {
    if (txtAge.text.length == 0){
        [Util showAlertTitle:self title:@"Error" message:@"Please enter the Age requirement."];
        return NO;
    }
    if (txtPromoType.selectedItem.length > 0){
        self.event.event_promo_type = [PROMO_TYPE indexOfObject:txtPromoType.selectedItem];
        if (self.event.event_promo_type == 1){
            if (txtPercentage.text.length == 0){
                [Util showAlertTitle:self title:@"Error" message:@"Please enter the Discount Percentage."];
                return NO;
            }
        }
    }
    return YES;
}

- (void)textField:(IQDropDownTextField *)textField didSelectItem:(NSString *)item {
    NSInteger index = [PROMO_TYPE indexOfObject:item];
    if (index == 0) {
        [txtPercentage setHidden:YES];
    } else if (index == 1){
        [txtPercentage setHidden:NO];
    } else {
    }
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
