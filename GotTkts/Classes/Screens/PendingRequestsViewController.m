//
//  PendingRequestsViewController.m
//  GotTkts
//
//  Created by Jorge Siu on 1/6/19.
//  Copyright © 2019 developer. All rights reserved.
//

#import "PendingRequestsViewController.h"
#import "EventCell.h"
#import "Event.h"
#import "EventResponse.h"

@interface PendingRequestsViewController ()<UITableViewDelegate, UITableViewDataSource, EventCellDelegate>
    {
        IBOutlet UITableView *tableview;
        NSMutableArray *dataArray;
    }
@end

@implementation PendingRequestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArray = [[NSMutableArray alloc] init];
    [self refreshItems];
}
- (IBAction)onback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    [manager GET:REQUEST_SUB_PENDING parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        [SVProgressHUD dismiss];
        dataArray = [[NSMutableArray alloc] init];
        EventResponse *response = [[EventResponse alloc] initWithDictionary:responseObject];
        if (response.status.code != 200){
            [self showError:response.status.msg];
        } else {
            dataArray = (NSMutableArray *) response.result;
            [tableview reloadData];
        }
        [tableview reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [SVProgressHUD dismiss];
        [self showError:[error localizedDescription]];
    }];
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}
    
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellEvent"];
    [Util setCornerView:cell.viewContent];
    Event *event = [dataArray objectAtIndex:indexPath.row];
    [cell.imgEvent hnk_setImageFromURL:[NSURL URLWithString:event.event_image]];
    cell.lblTitle.text = event.event_name;
    cell.lblDate.text = [NSDate stringFromDate:[Util getDateFromString:event.event_start_datetime formatter:nil] withFormat:NSDateFormatDmy4Hm24 andTimeZone:NSDateTimeZoneUTC];
    cell.lblPrice.text = [NSString stringWithFormat:@"By %@", event.org_name];
    cell.delegate = self;
    return cell;
}
    
- (void) onSMS:(EventCell *)cell {
    //    NSIndexPath *indexPath = [tableview indexPathForCell:cell];
    //    Event *event = [dataArray objectAtIndex:indexPath.row];
    [self sendMail:nil subject:@"" message:nil];
}
    
- (void) onCancel:(EventCell *)cell {
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
