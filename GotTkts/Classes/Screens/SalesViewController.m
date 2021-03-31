//
//  SalesViewController.m
//  GotTkts
//
//  Created by Jorge on 11/5/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "SalesViewController.h"
#import "EventSales.h"
#import <DYQRCodeDecoder/DYQRCodeDecoderViewController.h>

@interface SalesViewController ()<UITableViewDelegate, UITableViewDataSource, SalesCellDelegate>
{
    IBOutlet UITableView *tableview;
    
    NSMutableArray *dataArray;
    NSString *event_gross_income;
    NSString *event_total_tickets;
    NSInteger total_checkin_tickets, total_order_tickets;
}
@end

@implementation SalesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArray = [[NSMutableArray alloc] init];
    
    [self refreshItems];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void) refreshItems {
    
    if (![Util isConnectableInternet]){
        [Util showAlertTitle:self title:@"Error" message:@"The Internet connection appears to be offline."];
        return;
    }
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [UserModel currentUser].token] forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager POST:[NSString stringWithFormat:@"%@%@", REQUEST_EVENT_DASH, self.event.event_unique_id] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        [SVProgressHUD dismiss];
        dataArray = [[NSMutableArray alloc] init];
        EventSales *response = [[EventSales alloc] initWithDictionary:responseObject];
        if (response.status.code != 200){
            [self showError:response.status.msg];
        } else {
            event_gross_income = response.event_gross_income;
            event_total_tickets = response.event_total_tickets;
            total_order_tickets = response.total_order_tickets;
            total_checkin_tickets = response.total_checkin_tickets;
            dataArray = response.event_order_tickets;
            [tableview reloadData];
            if (dataArray.count == 0){
                [self showError:@"No Data"];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [self showError:[error localizedDescription]];
    }];
}

- (IBAction)onback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SalesCell *cell = (SalesCell *)[tableView dequeueReusableCellWithIdentifier:@"cellSales"];
    [Util setCornerView:cell.viewContent];
    [Util setCornerView:cell.viewCheckin];
    cell.lblTitle.text = self.event.event_name;
    cell.lblDate.text = [NSDate stringFromDate:[Util getDateFromString:self.event.event_start_datetime formatter:nil] withFormat:NSDateFormatDmy4Hm24 andTimeZone:NSDateTimeZoneUTC];
    cell.delegate = self;
    [cell.imgEvent hnk_setImageFromURL:[NSURL URLWithString:self.event.event_image]];
    TicketSales *ticket_sales = [dataArray objectAtIndex:indexPath.row];
    [UIView animateWithDuration:1.0f animations:^{
        cell.circleProgress.value = 100.0f * ticket_sales.number_order / ticket_sales.ticket_qty;
    }];
    NSString *strContent =  [NSString stringWithFormat:@"%@\n%@\n%ld/%ld TICKETS SOLD", event_gross_income, @"CROSS SALES",ticket_sales.number_order, ticket_sales.ticket_qty];
    cell.lblContent.text = strContent;
    
    return cell;
}

- (void)onCheckIn:(SalesCell *)cell {
    NSIndexPath *indexpath = [tableview indexPathForCell:cell];
    DYQRCodeDecoderViewController *vc = [[DYQRCodeDecoderViewController alloc] initWithCompletion:^(BOOL succeeded, NSString *result) {
        if (succeeded) {
            NSLog(@"%@", result);
            [self checkInEvent:result];
        } else {
            NSLog(@"failed");
        }
    }];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navVC animated:YES completion:NULL];
}

- (void) checkInEvent:(NSString *)qrcode {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [UserModel currentUser].token] forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager POST:[NSString stringWithFormat:@"%@%@/%@", REQUEST_EVENT_CHECKIN, qrcode,self.event.event_unique_id] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        [SVProgressHUD dismiss];
        NSDictionary *result = (NSDictionary *)responseObject;
        if (result[@"msg"]){
            [Util showAlertTitle:self title:@"Check In" message:result[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [self showError:[error localizedDescription]];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
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
