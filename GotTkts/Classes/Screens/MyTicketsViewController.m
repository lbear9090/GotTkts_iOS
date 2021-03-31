//
//  MyTicketsViewController.m
//  GotTkts
//
//  Created by Jorge on 10/26/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "MyTicketsViewController.h"
#import "TicketCell.h"
#import "TicketOrderedResponse.h"
#import "TicketQRViewController.h"

@interface MyTicketsViewController ()<UITableViewDelegate, UITableViewDataSource, TicketCellDelegate>
{
    IBOutlet UITableView *tableview;
    NSMutableArray *dataArray;
}
@end

@implementation MyTicketsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArray = [[NSMutableArray alloc] init];
    [self loadData];
}

- (IBAction)onback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    [manager GET:[NSString stringWithFormat:@"%@%@", REQUEST_ORDERED_TICKETS, [UserModel currentUser].user_id] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        [SVProgressHUD dismiss];
        dataArray = [[NSMutableArray alloc] init];
        TicketOrderedResponse *response = [[TicketOrderedResponse alloc] initWithDictionary:responseObject];
        if (response.status.code != 200){
            [self showError:response.status.msg];
        } else {
            dataArray = (NSMutableArray *)response.result;
            if (dataArray.count == 0){
                [self showError:@"No data"];
            }
        }
        [tableview reloadData];        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [self showError:[error localizedDescription]];
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TicketCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTkt"];
    TicketOrdered *ticket = [dataArray objectAtIndex:indexPath.row];
    [Util setCornerView:cell.viewContent];
    [Util setCornerView:cell.viewDate];
    [Util setCornerView:cell.viewBarcode];
    [Util setCornerView:cell.imgEvent];
    [Util setBorderView:cell.imgEvent color:[UIColor lightGrayColor] width:0.5f];
    
    cell.delegate = self;
    [cell.imgEvent hnk_setImageFromURL:[NSURL URLWithString:ticket.event_image]];
    cell.lblTitle.text = ticket.ticket_title;
    
    NSDate *start_date = [Util getDateFromString:ticket.event_start_date formatter:nil];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    NSInteger month = [[dateFormatter stringFromDate:start_date] integerValue];
    [dateFormatter setDateFormat:@"yyyy"];
    NSInteger day = [[dateFormatter stringFromDate:start_date] integerValue];
    [dateFormatter setDateFormat:@"dd"];
    NSString *year = [dateFormatter stringFromDate:start_date];
    
    cell.lblDate.text = [NSString stringWithFormat:@"%@ %ld %@", [MONTH_WRDS objectAtIndex:(month - 1)], (long)day, year];
    
    NSDate *ordered_date = [Util getDateFromString:ticket.event_start_date formatter:nil];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    month = [[dateFormatter stringFromDate:ordered_date] integerValue];
    [dateFormatter setDateFormat:@"yyyy"];
    day = [[dateFormatter stringFromDate:ordered_date] integerValue];
    [dateFormatter setDateFormat:@"dd"];
    year = [dateFormatter stringFromDate:start_date];
    cell.lblOrder.text = [NSString stringWithFormat:@"Order #%@ on %@ %ld, %@", ticket.order_id, [MONTHS objectAtIndex:(month - 1)], (long)day, year];
    
    return cell;
}

- (void)onDisplayTicket:(TicketCell *)cell {
    NSIndexPath *indexPath = [tableview indexPathForCell:cell];
    TicketOrdered *ticket = [dataArray objectAtIndex:indexPath.row];
    TicketQRViewController *vc = (TicketQRViewController *)[Util getUIViewControllerFromStoryBoard:@"TicketQRViewController"];
    vc.ticket = ticket;
    [self.navigationController pushViewController:vc animated:YES];
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
