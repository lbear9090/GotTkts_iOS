//
//  TicketsSoldViewController.m
//  GotTkts
//
//  Created by Jorge Siu on 1/10/19.
//  Copyright © 2019 developer. All rights reserved.
//

#import "TicketsSoldViewController.h"
#import "OrderCell.h"
#import "SoldTicketsResponse.h"

@interface TicketsSoldViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *tableView;
    NSMutableArray *dataArray;
}
@end

@implementation TicketsSoldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArray = [[NSMutableArray alloc] init];
    [self loadData];
}

- (void) loadData {
    if (![Util isConnectableInternet]){
        [Util showAlertTitle:self title:@"Error" message:@"The Internet connection appears to be offline."];
        return;
    }
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [UserModel currentUser].token] forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager GET:REQUEST_SUB_SOLD_TKTS parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        [SVProgressHUD dismiss];
        dataArray = [[NSMutableArray alloc] init];
        SoldTicketsResponse *response = [[SoldTicketsResponse alloc] initWithDictionary:responseObject];
        if (response.status.code != 200){
            [self showError:response.status.msg];
        } else {
            dataArray = (NSMutableArray *)response.result;
            if (dataArray.count == 0){
                [self showError:@"No data"];
            }
        }
        
        [tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [SVProgressHUD dismiss];
        [self showError:[error localizedDescription]];
    }];
}
- (IBAction)onback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellOrder"];
    
    if (indexPath.row % 2 == 0){
        [cell.viewContent setBackgroundColor:[UIColor whiteColor]];
                
    } else {
        [cell.viewContent setBackgroundColor:MAIN_COLOR];
        
    }
    [Util setCornerView:cell.viewContent];
    
    SoldTicket *ticket = [dataArray objectAtIndex:indexPath.row];
    cell.lblName.text = ticket.event_name;
    cell.lblOrderId.text = ticket.order_id;
    cell.lblDate.text = ticket.BOOKING_ON;
    cell.lblTkts.text = [NSString stringWithFormat:@"%d", ticket.order_tickets];
    return cell;
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
