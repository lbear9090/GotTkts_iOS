//
//  TicketsViewController.m
//  GotTkts
//
//  Created by Jorge on 10/22/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "TicketsViewController.h"
#import "IQDropDownTextField.h"
#import "TicketResponse.h"
#import "MyPaymentViewController.h"
#import "BookResponse.h"
#import "MenuViewController.h"

@interface TicketsViewController ()<UITableViewDelegate, UITableViewDataSource, IQDropDownTextFieldDelegate>
{
    IBOutlet UITableView *tableview;
    IBOutlet UILabel *lblQty;
    IBOutlet UILabel *lblAmount;
    IBOutlet UIButton *btnBook;
    
    NSMutableArray *dataArray, *quantyArray;
    double sum ;
    int quanty ;
}
@end

@implementation TicketsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArray = [[NSMutableArray alloc] init];
    quantyArray = [[NSMutableArray alloc] init];
    sum = 0.0f;
    quanty = 0;
    [self loadData];
}

- (void) loadData {
    if (![Util isConnectableInternet]){
        [Util showAlertTitle:self title:@"Error" message:@"The Internet connection appears to be offline."];
        return;
    }
    dataArray = [[NSMutableArray alloc] init];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [UserModel currentUser].token] forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager POST:[NSString stringWithFormat:@"%@%@", REQUEST_TICKETS, self.event.event_unique_id] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        [SVProgressHUD dismiss];
        dataArray = [[NSMutableArray alloc] init];
        TicketResponse *response = [[TicketResponse alloc] initWithDictionary:responseObject];
//        if (response.status.code != 200){
//            [self showError:response.status.msg];
//        } else {
            dataArray = (NSMutableArray *)response.result;
            for (int i=0;i<dataArray.count;i++){
                [quantyArray addObject:[NSNumber numberWithInt:0]];
            }
//        }
        [tableview reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [self showError:[error localizedDescription]];
    }];
    
}

- (IBAction)onbook:(id)sender {
    if (![Util isConnectableInternet]){
        [Util showAlertTitle:self title:@"Error" message:@"The Internet connection appears to be offline."];
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   [UserModel currentUser].user_id, @"user_id",
                                   [NSString stringWithFormat:@"%ld", (long)self.event.event_id], @"event_id",
                                   self.event.event_unique_id, @"event_uid",
                                   [NSString stringWithFormat:@"%ld", (long)quanty], @"total_ticket",
                                   [NSString stringWithFormat:@"%.02f", sum], @"total_amount",
                                   nil];
    
    NSMutableArray *array_tid = [[NSMutableArray alloc] init];
    NSMutableArray *array_ticket_qty = [[NSMutableArray alloc] init];
    NSMutableArray *array_ticket_id = [[NSMutableArray alloc] init];
    for (int i=0;i<quantyArray.count;i++){
        int val = [[quantyArray objectAtIndex:i] intValue];
        if (val != 0){
            Ticket *ticket = [dataArray objectAtIndex:i];
            [array_tid addObject:[NSNumber numberWithInteger:ticket.t_id]];
            [array_ticket_qty addObject:[NSNumber numberWithInteger:val]];
            [array_ticket_id addObject:ticket.ticket_id];
        }
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array_tid options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [params setObject:jsonString forKey:@"tid"];
    jsonData = [NSJSONSerialization dataWithJSONObject:array_ticket_qty options:NSJSONWritingPrettyPrinted error:&error];
    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [params setObject:jsonString forKey:@"ticket_type_qty"];
    jsonData = [NSJSONSerialization dataWithJSONObject:array_ticket_id options:NSJSONWritingPrettyPrinted error:&error];
    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [params setObject:jsonString forKey:@"ticket_id"];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [UserModel currentUser].token] forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager POST:REQUEST_TICKETS_BOOK parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        [SVProgressHUD dismiss];
        BookResponse *response = [[BookResponse alloc] initWithDictionary:responseObject];
        if (response.status.code != 200){
            [self showError:response.status.msg];
        } else {
            [self gotoNextScreen:response.result];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [self showError:[error localizedDescription]];
    }];
}

- (void) gotoNextScreen:(Book *)bookData {
    if (sum == 0){
        [Util showAlertTitle:self title:@"Event Ticket" message:@"Booked free ticket successfully." finish:^(void){
            for (UIViewController *vc in self.navigationController.viewControllers){
                if ([vc isKindOfClass:[MenuViewController class]]){
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }];
    } else {
        MyPaymentViewController *vc = (MyPaymentViewController *)[Util getUIViewControllerFromStoryBoard:@"MyPaymentViewController"];
        vc.bookData = bookData;
        vc.event = self.event;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)onback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTicket"];
    UILabel *lblTitle = [cell viewWithTag:1];
    UILabel *lblPrice = [cell viewWithTag:2];
    IQDropDownTextField *dropQty = [cell viewWithTag:3];
    
    Ticket *ticket = [dataArray objectAtIndex:indexPath.row];
    lblTitle.text = ticket.ticket_title;
    double price_buyer = [ticket.ticket_price_buyer doubleValue];
    double price_actual = [ticket.ticket_price_actual doubleValue];
    lblPrice.text = [NSString stringWithFormat:@"$ %@ + %.02f Fees = $ %@", ticket.ticket_price_actual, (price_buyer - price_actual), ticket.ticket_price_buyer];
    
    dropQty.itemList = [NSArray arrayWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", nil];
    dropQty.delegate = self;
    
    return cell;
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    UITableViewCell *cell = (UITableViewCell *) textField.superview.superview;
    NSInteger index = [tableview indexPathForCell:cell].row;
    if (textField.text.length > 0){
        NSInteger val = [textField.text integerValue];
        if (quantyArray.count > index){
            [quantyArray removeObjectAtIndex:index];
        }
        [quantyArray insertObject:[NSNumber numberWithInteger:val] atIndex:index];
    }
    [self validate];
}

- (void) validate {
    sum = 0.0;
    quanty = 0;
    for (int i=0;i<quantyArray.count;i++){
        NSInteger val = [[quantyArray objectAtIndex:i] integerValue];
        Ticket *ticket = [dataArray objectAtIndex:i];
        double price_buyer = [ticket.ticket_price_buyer doubleValue];
        sum = sum + price_buyer * val;
        quanty = (int)quanty + (int)val;
    }
    lblQty.text = [NSString stringWithFormat:@"%@ : %d", @"QTY", quanty];
    lblAmount.text = [NSString stringWithFormat:@"%@ : $ %.02f", @"Amount", sum];
    btnBook.enabled = (quanty != 0);
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
