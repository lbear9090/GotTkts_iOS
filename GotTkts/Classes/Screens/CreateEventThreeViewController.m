//
//  CreateEventThreeViewController.m
//  GotTkts
//
//  Created by Jorge on 10/23/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "CreateEventThreeViewController.h"
#import "IQDropDownTextField.h"
#import "MenuViewController.h"
#import "Ticket.h"

@interface CreateEventThreeViewController ()<IQDropDownTextFieldDelegate, UITextViewDelegate>
{
    IBOutlet IQDropDownTextField *txtCategory;
    IBOutlet IQDropDownTextField *txtOrganizer;
    IBOutlet UITextView *txtDescription;
    
    IBOutlet UILabel *lblPlaceholder;
    
    int selected_category, selected_organizer;
    IBOutlet UILabel *lblTitle;
}
@end

@implementation CreateEventThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [Util setBorderView:txtDescription color:[UIColor whiteColor] width:1.0f];
    [Util setCornerView:txtDescription];
    txtCategory.itemList = CATEGORY_ARRAY;
    txtOrganizer.itemList = [NSArray arrayWithObjects:@"Got Tkts", nil];
    txtDescription.delegate = self;
    txtCategory.delegate = self;
    txtOrganizer.delegate = self;

    if (self.isEdit){
        lblTitle.text = @"Edit Event";
        txtDescription.text = self.event.event_description;
    }
}

- (IBAction)onback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSubmit:(id)sender {
    if (![self isValid]){
        return;
    }

    self.event.event_description = txtDescription.text;
    if (![Util isConnectableInternet]){
        [Util showAlertTitle:self title:@"Error" message:@"The Internet connection appears to be offline"];
        return;
    }
    
    if (self.isEdit){
        [self updateEvent];
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   self.event.event_name, @"event_name",
                                   [NSString stringWithFormat:@"%f", self.event.event_commision], @"subpromoter_commision",
                                   self.event.event_start_datetime, @"event_start_datetime",
                                   self.event.event_end_datetime, @"event_end_datetime",
                                   [NSNumber numberWithInteger:self.event.event_allow_subpormoter], @"allow_subpromoter",

                                   [NSNumber numberWithInteger:self.event.event_is_publish], @"event_status",
                                   [NSNumber numberWithInteger:self.event.event_display_remain], @"event_remaining",
                                   self.event.event_location, @"event_location",
                                   self.event.event_address, @"event_address",
                                   [NSNumber numberWithDouble:self.event.event_latitude], @"event_latitude",
                                   [NSNumber numberWithDouble:self.event.event_longitude], @"event_longitude",
                                   self.event.event_url, @"event_url",
                                   self.event.event_description, @"event_description",
                                   [NSNumber numberWithInteger:self.event.event_display_map], @"map_display",
                                   self.event.event_pickup, @"event_pickup[]",
                                   self.event.event_entertainment, @"event_entertain",
                                   self.event.event_dress_code, @"event_drcod",
                                   [NSNumber numberWithInteger:[self.event.event_age integerValue]], @"age",
                                   self.event.event_promo_code, @"event_promo_code",
                                   [NSNumber numberWithInteger:self.event.event_promo_type], @"event_promo_type",
                                   self.event.event_package_description, @"event_pakcage[]",
                                   self.event.event_package_amount, @"event_package_amount[]",
                                   self.event.event_expire_datetime, @"event_promo_exp_date",
                                   nil];
    
    NSMutableArray *array_ticket_type = [[NSMutableArray alloc] init];
    NSMutableArray *array_service_fee = [[NSMutableArray alloc] init];
    NSMutableArray *array_price_actual = [[NSMutableArray alloc] init];
    NSMutableArray *array_ticket_title = [[NSMutableArray alloc] init];
    NSMutableArray *array_description = [[NSMutableArray alloc] init];
    NSMutableArray *array_qty = [[NSMutableArray alloc] init];
    for (int i=0;i<self.paidArray.count;i++){
        Ticket *ticket = [self.paidArray objectAtIndex:i];
        [array_ticket_type addObject:[NSNumber numberWithInt:1]];
        [array_service_fee addObject:[NSNumber numberWithFloat:0.1f]];
        [array_price_actual addObject:[NSNumber numberWithFloat:[ticket.ticket_price_actual floatValue]]];
        [array_ticket_title addObject:ticket.ticket_title];
        [array_description addObject:@""];
        [array_qty addObject:[NSNumber numberWithInteger:ticket.ticket_qty]];
    }
    for (int i=0;i<self.freeArray.count;i++){
        Ticket *ticket = [self.freeArray objectAtIndex:i];
        [array_ticket_type addObject:[NSNumber numberWithInt:0]];
        [array_service_fee addObject:[NSNumber numberWithFloat:0.1f]];
        [array_price_actual addObject:[NSNumber numberWithFloat:[ticket.ticket_price_actual floatValue]]];
        [array_ticket_title addObject:ticket.ticket_title];
        [array_description addObject:@""];
        [array_qty addObject:[NSNumber numberWithInteger:ticket.ticket_qty]];
    }
    for (int i=0;i<self.planArray.count;i++){
        Ticket *ticket = [self.planArray objectAtIndex:i];
        [array_ticket_type addObject:[NSNumber numberWithInt:2]];
        [array_service_fee addObject:[NSNumber numberWithFloat:0.1f]];
        [array_price_actual addObject:[NSNumber numberWithFloat:[ticket.ticket_price_actual floatValue]]];
        [array_ticket_title addObject:ticket.ticket_title];
        [array_description addObject:@""];
        [array_qty addObject:[NSNumber numberWithInteger:ticket.ticket_qty]];
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array_ticket_type options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonString = [self JSONString:jsonString];
    [params setObject:jsonString forKey:@"ticket_type"];
    jsonData = [NSJSONSerialization dataWithJSONObject:array_service_fee options:NSJSONWritingPrettyPrinted error:&error];
    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonString = [self JSONString:jsonString];
    [params setObject:jsonString forKey:@"ticket_services_fee"];
    jsonData = [NSJSONSerialization dataWithJSONObject:array_price_actual options:NSJSONWritingPrettyPrinted error:&error];
    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonString = [self JSONString:jsonString];
    [params setObject:jsonString forKey:@"ticket_price_actual"];
    jsonData = [NSJSONSerialization dataWithJSONObject:array_ticket_title options:NSJSONWritingPrettyPrinted error:&error];
    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonString = [self JSONString:jsonString];
    [params setObject:jsonString forKey:@"ticket_title"];
    jsonData = [NSJSONSerialization dataWithJSONObject:array_description options:NSJSONWritingPrettyPrinted error:&error];
    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonString = [self JSONString:jsonString];
    [params setObject:jsonString forKey:@"ticket_description"];
    jsonData = [NSJSONSerialization dataWithJSONObject:array_qty options:NSJSONWritingPrettyPrinted error:&error];
    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonString = [self JSONString:jsonString];
    [params setObject:jsonString forKey:@"ticket_qty"];
    
    [SVProgressHUD showWithStatus:@"Please wait..."];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [UserModel currentUser].token] forHTTPHeaderField:@"Authorization"];
    [manager POST:REQUEST_CREATE_EVENT parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(self.event.image, 0.5) name:@"event_image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject){
        [SVProgressHUD dismiss];
        Event *response = [[Event alloc] initWithDictionary:(NSDictionary *) responseObject];
        NSDictionary *status = (NSDictionary *) response.status;
        NSInteger code = [status[@"code"] integerValue];
        if (code == 200){
            [Util showAlertTitle:self title:@"Success" message:@"Added event successfully." finish:^(void){
                [self gotoMainScreen];
            }];
        } else {
            [Util showAlertTitle:self title:@"Error" message:status[@"msg"] finish:^(void){
                [self gotoMainScreen];
            }];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [self showError:@"Failed to create event."];
    }];
}

-(NSString *)JSONString:(NSString *)aString {
    NSMutableString *s = [NSMutableString stringWithString:aString];
//    [s replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
//    [s replaceOccurrencesOfString:@"/" withString:@"\\/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
//    [s replaceOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
//    [s replaceOccurrencesOfString:@"\b" withString:@"\\b" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
//    [s replaceOccurrencesOfString:@"\f" withString:@"\\f" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
//    [s replaceOccurrencesOfString:@"\r" withString:@"\\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
//    [s replaceOccurrencesOfString:@"\t" withString:@"\\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\\" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\n" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];


    return [NSString stringWithString:s];
}

- (void) updateEvent {
    NSDictionary *params = @{
                             @"event_unique_id" : self.event.event_unique_id,
                             @"event_name" : self.event.event_name,
                             @"subpromoter_commision" : [NSString stringWithFormat:@"%f", self.event.event_commision],
                             @"event_start_datetime" : self.event.event_start_datetime,
                             @"event_end_datetime" : self.event.event_end_datetime,
                             @"allow_subpromoter" : [NSNumber numberWithInteger:self.event.event_allow_subpormoter],
                             @"event_status" : [NSNumber numberWithInteger:self.event.event_is_publish],
                             @"event_remaining" : [NSNumber numberWithInteger:self.event.event_display_remain],
                             @"event_location" : self.event.event_location,
                             @"event_address" : self.event.event_address,
                             @"event_latitude" : [NSNumber numberWithDouble:self.event.event_latitude],
                             @"event_longitude" : [NSNumber numberWithDouble:self.event.event_longitude],
                             @"event_url" : self.event.event_url,
                             @"event_description" : self.event.event_description,
                             @"map_display" : [NSNumber numberWithInteger:self.event.event_display_map],
//                             self.event.event_pickup: @"event_pickup[]",
//                             self.event.event_entertainment: @"event_entertain",
//                             self.event.event_dress_code: @"event_drcod",
//                             [NSNumber numberWithInteger: [self.event.event_age integerValue]], @"age",
//                             self.event.event_promo_code: @"event_promo_code",
//                             [NSNumber numberWithInteger: self.event.event_promo_type], @"event_promo_type",
//                             self.event.event_package_description: @"event_pakcage[]",
//                             self.event.event_package_amount: @"evet_package_amount[]",
//                             self.event.event_expire_datetime: @"event_promo_exp_date",
//                             @"old_image" : self.event.event_old_image,
    };
    
    [SVProgressHUD showWithStatus:@"Please wait..."];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [UserModel currentUser].token] forHTTPHeaderField:@"Authorization"];
    [manager POST:REQUEST_UPDATE_EVENT parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(self.event.image, 0.5) name:@"event_image" fileName:@"image.jpg" mimeType:@"image/jpeg"];        
    } success:^(AFHTTPRequestOperation *operation, id responseObject){
        [SVProgressHUD dismiss];
        Event *response = [[Event alloc] initWithDictionary:(NSDictionary *) responseObject];
        NSDictionary *status = (NSDictionary *) response.status;
        NSInteger code = [status[@"code"] integerValue];
        if (code == 200){
            [Util showAlertTitle:self title:@"Success" message:@"Updated event successfully." finish:^(void){
                [self gotoMainScreen];
            }];
        } else {
            [Util showAlertTitle:self title:@"Error" message:status[@"msg"] finish:^(void){
                [self gotoMainScreen];
            }];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [self showError:@"Failed to create event."];
    }];
}

- (void) gotoMainScreen {
    for (UIViewController *vc in self.navigationController.viewControllers){
        if ([vc isKindOfClass:[MenuViewController class]]){
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

- (BOOL) isValid {
    txtDescription.text = [Util trim:txtDescription.text];
    if (txtCategory.selectedRow == -1){
        [self showError:@"Please choose category."];
        return NO;
    }
    if (txtOrganizer.selectedRow == -1){
        [self showError:@"Please choose organizer."];
        return NO;
    }
    if (txtDescription.text.length == 0){
        [self showError:@"Please input description"];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    lblPlaceholder.hidden = (textView.text.length != 0);
}

- (void)textField:(IQDropDownTextField *)textField didSelectItem:(NSString *)item {
    
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
