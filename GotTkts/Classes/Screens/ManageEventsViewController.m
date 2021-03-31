//
//  ManageEventsViewController.m
//  GotTkts
//
//  Created by Jorge on 10/30/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "ManageEventsViewController.h"
#import "EventCell.h"
#import "EventResponse.h"
#import "PostDetailsViewController.h"
#import "CreateEventOneViewController.h"
#import "SalesViewController.h"
#import "HTHorizontalSelectionList.h"
#import "OrderCell.h"
#import "OrderResponse.h"

@interface ManageEventsViewController ()<UITableViewDelegate, UITableViewDataSource, EventCellDelegate, HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource>
{
    IBOutlet UITableView *tableview;
    IBOutlet UIView *viewTitle;
    
    NSMutableArray *dataArray;
    NSMutableArray *labelMakes;
    IBOutlet HTHorizontalSelectionList *topbarList;
    IBOutlet UIView *viewOrder;
    IBOutlet UITableView *tableOrders;
}
@end

@implementation ManageEventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [Util setCornerView:viewTitle];
    dataArray = [[NSMutableArray alloc] init];
    
    labelMakes = [[NSMutableArray alloc] initWithObjects:@"Your Events", @"Orders", nil];
    topbarList.delegate = self;
    topbarList.dataSource = self;
    topbarList.backgroundColor = [UIColor clearColor];
    topbarList.selectionIndicatorHeight = 1.5;
    topbarList.selectionIndicatorAnimationMode = HTHorizontalSelectionIndicatorAnimationModeLightBounce;
    topbarList.selectionIndicatorColor = COLOR_ORANGE;
    [topbarList setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [topbarList setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [topbarList setTitleFont:[UIFont boldSystemFontOfSize:15] forState:UIControlStateNormal];
    [topbarList setTitleFont:[UIFont boldSystemFontOfSize:17] forState:UIControlStateSelected];
    [topbarList setTitleFont:[UIFont boldSystemFontOfSize:17] forState:UIControlStateHighlighted];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (topbarList.selectedButtonIndex == 0){
        [self refreshItems];
    } else {
        [self refreshOrders];
    }
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) refreshItems { // my events
    if (![Util isConnectableInternet]){
        [Util showAlertTitle:self title:@"Error" message:@"The Internet connection appears to be offline."];
        return;
    }
    NSDictionary *params = @{
                             @"promotor" : @"0"                         // customer, promoter
                             };
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [UserModel currentUser].token] forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager POST:REQUEST_LIVE_EVENT parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        [SVProgressHUD dismiss];
        dataArray = [[NSMutableArray alloc] init];
        EventResponse *response = [[EventResponse alloc] initWithDictionary:responseObject];
        if (response.status.code != 200){
            [self showError:response.status.msg];
        } else {
            for (Event *item in response.result){
                if (item.event_image.length > 0 && item.event_created_by == [[UserModel currentUser].user_id integerValue]){
                    [dataArray addObject:item];
                }
            }
        }
        [tableview reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [self showError:[error localizedDescription]];
    }];
}

- (void) refreshOrders { // my events
    if (![Util isConnectableInternet]){
        [Util showAlertTitle:self title:@"Error" message:@"The Internet connection appears to be offline."];
        return;
    }
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [UserModel currentUser].token] forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager POST:[NSString stringWithFormat:@"%@%@", REQUEST_GET_ORDERS_LIST, [UserModel currentUser].user_id] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        [SVProgressHUD dismiss];
        dataArray = [[NSMutableArray alloc] init];
        OrderResponse *response = [[OrderResponse alloc] initWithDictionary:responseObject];
        if (response.status.code != 200){
            [self showError:response.status.msg];
        } else {
            dataArray = (NSMutableArray *) response.result;
            [tableOrders reloadData];
        }
        [tableview reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (topbarList.selectedButtonIndex == 0){
        EventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellEvent"];
        [Util setCornerView:cell.viewContent];
        
        Event *event = [dataArray objectAtIndex:indexPath.row];
        [cell.imgEvent hnk_setImageFromURL:[NSURL URLWithString:event.event_image]];
        cell.lblTitle.text = event.event_name;
        cell.lblDate.text = [NSDate stringFromDate:[Util getDateFromString:event.event_start_datetime formatter:nil] withFormat:NSDateFormatDmy4Hm24 andTimeZone:NSDateTimeZoneUTC];
        cell.delegate = self;
        
        return cell;
    } else {
        OrderCell *cell = [tableOrders dequeueReusableCellWithIdentifier:@"cellOrder"];
        Order *order = [dataArray objectAtIndex:indexPath.row];
        if (indexPath.row % 2 == 0){
            [cell.viewContent setBackgroundColor:[UIColor whiteColor]];
            
            [Util setBorderView:cell.lblName color:[UIColor lightGrayColor] width:0.5f];
            [Util setBorderView:cell.lblOrderId color:[UIColor lightGrayColor] width:0.5f];
            [Util setBorderView:cell.lblDate color:[UIColor lightGrayColor] width:0.5f];
            [Util setBorderView:cell.lblTkts color:[UIColor lightGrayColor] width:0.5f];
        } else {
            [cell.viewContent setBackgroundColor:MAIN_COLOR];
            
            [Util setBorderView:cell.lblName color:[UIColor lightTextColor] width:0.5f];
            [Util setBorderView:cell.lblOrderId color:[UIColor lightTextColor] width:0.5f];
            [Util setBorderView:cell.lblDate color:[UIColor lightTextColor] width:0.5f];
            [Util setBorderView:cell.lblTkts color:[UIColor lightTextColor] width:0.5f];
        }
        [Util setCornerView:cell.viewContent];
        
        cell.lblName.text = [NSString stringWithFormat:@"%@ %@", order.ot_firstname, order.ot_lastname];
        cell.lblOrderId.text = order.ot_order_id;
        cell.lblDate.text = [NSDate stringFromDate:[Util getDateFromString:order.order_on formatter:nil] withFormat:NSDateFormatDmy4Hm24 andTimeZone:NSDateTimeZoneUTC];
        
        cell.lblTkts.text = order.ticket_title;
        return cell;
    }
}



- (void) onView:(EventCell *)cell {
    NSIndexPath *indexPath = [tableview indexPathForCell:cell];
    Event *event = [dataArray objectAtIndex:indexPath.row];
    PostDetailsViewController *vc = (PostDetailsViewController *)[Util getUIViewControllerFromStoryBoard:@"PostDetailsViewController"];
    vc.event = event;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) onEdit:(EventCell *)cell {
    NSIndexPath *indexPath = [tableview indexPathForCell:cell];
    Event *event = [dataArray objectAtIndex:indexPath.row];
    CreateEventOneViewController *vc = (CreateEventOneViewController *)[Util getUIViewControllerFromStoryBoard:@"CreateEventOneViewController"];
    vc.eventData = event;
    vc.isEdit = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) onSales:(EventCell *)cell {
    SalesViewController *vc = (SalesViewController *)[Util getUIViewControllerFromStoryBoard:@"SalesViewController"];
    NSIndexPath *indexPath = [tableview indexPathForCell:cell];
    Event *event = [dataArray objectAtIndex:indexPath.row];
    vc.event = event;
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList {
    return labelMakes.count;
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index {
    return [labelMakes objectAtIndex:index];
}
- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index {
    if (index == 0){
        tableview.hidden = NO;
        viewOrder.hidden = YES;
        [self refreshItems];
    } else {
        tableview.hidden = YES;
        viewOrder.hidden = NO;
        [self refreshOrders];
    }
}


@end
