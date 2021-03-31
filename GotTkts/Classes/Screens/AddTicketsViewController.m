//
//  AddTicketsViewController.m
//  GotTkts
//
//  Created by Jorge Siu on 11/21/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "AddTicketsViewController.h"
#import "CreateEventThreeViewController.h"
#import "HTHorizontalSelectionList.h"
#import "FeedCell.h"
#import "Ticket.h"

@interface AddTicketsViewController ()<HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource, UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet HTHorizontalSelectionList *topbarList;
    NSMutableArray *labelPays;
    
    NSMutableArray *paidArray, *freeArray, *planArray;
    IBOutlet UITableView *tableview;//paid
    IBOutlet UITableView *tbl_free;
    
    IBOutlet UITableView *tbl_plan;
    NSInteger current_index;
}
@end

@implementation AddTicketsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    labelPays = [[NSMutableArray alloc] initWithObjects:@"Paid", @"Free", @"Plan",nil];
    topbarList.delegate = self;
    topbarList.dataSource = self;
    topbarList.backgroundColor = [UIColor clearColor];
    topbarList.selectionIndicatorAnimationMode = HTHorizontalSelectionIndicatorAnimationModeLightBounce;
    topbarList.selectionIndicatorColor = COLOR_BLUE_LIGHT;
    [topbarList setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [topbarList setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [topbarList setTitleFont:[UIFont boldSystemFontOfSize:13] forState:UIControlStateNormal];
    [topbarList setTitleFont:[UIFont boldSystemFontOfSize:15] forState:UIControlStateSelected];
    [topbarList setTitleFont:[UIFont boldSystemFontOfSize:15] forState:UIControlStateHighlighted];
    
    Ticket *ticket = [[Ticket alloc] init];
    paidArray = [[NSMutableArray alloc] init];
    freeArray = [[NSMutableArray alloc] init];
    planArray = [[NSMutableArray alloc] init];
    [paidArray addObject:ticket];
    [freeArray addObject:ticket];
    [planArray addObject:ticket];
    
    current_index = 0;
    
    tableview.hidden = NO;
    tbl_free.hidden = YES;
    tbl_plan.hidden = YES;
    
    tableview.userInteractionEnabled = YES;
    tbl_free.userInteractionEnabled = NO;
    tbl_plan.userInteractionEnabled = NO;
}

- (IBAction)onback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onNext:(id)sender {
    if (current_index == 0){
        for (int i=0;i<paidArray.count;i++){
            Ticket *data = [paidArray objectAtIndex:i];
            FeedCell *cell = [tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            data.ticket_title = cell.txtName.text;
            data.ticket_price_actual = cell.txtPrice.text;
            data.ticket_qty = [cell.txtQty.text integerValue];
        }
    } else if (current_index == 1){
        for (int i=0;i<freeArray.count;i++){
            Ticket *data = [freeArray objectAtIndex:i];
            FeedCell *cell = [tbl_free cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            data.ticket_title = cell.txtName.text;
            data.ticket_price_actual = cell.txtPrice.text;
            data.ticket_qty = [cell.txtQty.text integerValue];
        }
    } else {
        for (int i=0;i<planArray.count;i++){
            Ticket *data = [planArray objectAtIndex:i];
            FeedCell *cell = [tbl_plan cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            data.ticket_title = cell.txtName.text;
            data.ticket_price_actual = cell.txtPrice.text;
            data.ticket_qty = [cell.txtQty.text integerValue];
        }
    }
    
    
    for (int i=0;i<paidArray.count;i++){
        Ticket *ticket = [paidArray objectAtIndex:i];
        if (ticket.ticket_title.length == 0 || ticket.ticket_qty == 0 || ticket.ticket_price_actual == 0){
            [paidArray removeObject:ticket];
        }
    }
    for (int i=0;i<freeArray.count;i++){
        Ticket *ticket = [freeArray objectAtIndex:i];
        if (ticket.ticket_title.length == 0 || ticket.ticket_qty == 0){
            [freeArray removeObject:ticket];
        }
    }
    for (int i=0;i<planArray.count;i++){
        Ticket *ticket = [planArray objectAtIndex:i];
        if (ticket.ticket_title.length == 0 || ticket.ticket_qty == 0 || ticket.ticket_price_actual == 0){
            [planArray removeObject:ticket];
        }
    }
    CreateEventThreeViewController *vc = (CreateEventThreeViewController *)[Util getUIViewControllerFromStoryBoard:@"CreateEventThreeViewController"];
    vc.paidArray = paidArray;
    vc.freeArray = freeArray;
    vc.planArray = planArray;
    vc.event = self.event;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList {
    return labelPays.count;
}

- (IBAction)onAdd:(id)sender {
    if (current_index == 0){
        for (int i=0;i<paidArray.count;i++){
            Ticket *data = [paidArray objectAtIndex:i];
            FeedCell *cell = [tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            data.ticket_title = cell.txtName.text;
            data.ticket_price_actual = cell.txtPrice.text;
            data.ticket_qty = [cell.txtQty.text integerValue];
//            [paidArray replaceObjectAtIndex:i withObject:data];
        }
        Ticket *ticket = [[Ticket alloc] init];
        [paidArray addObject:ticket];
        [tableview reloadData];
    } else if (current_index == 1){
        for (int i=0;i<freeArray.count;i++){
            Ticket *data = [freeArray objectAtIndex:i];
            FeedCell *cell = [tbl_free cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            data.ticket_title = cell.txtName.text;
            data.ticket_price_actual = cell.txtPrice.text;
            data.ticket_qty = [cell.txtQty.text integerValue];
//            [freeArray replaceObjectAtIndex:i withObject:data];
        }
        Ticket *ticket = [[Ticket alloc] init];
        [freeArray addObject:ticket];
        [tbl_free reloadData];
    } else {
        for (int i=0;i<planArray.count;i++){
            Ticket *data = [planArray objectAtIndex:i];
            FeedCell *cell = [tbl_plan cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            data.ticket_title = cell.txtName.text;
            data.ticket_price_actual = cell.txtPrice.text;
            data.ticket_qty = [cell.txtQty.text integerValue];
//            [planArray replaceObjectAtIndex:i withObject:data];
        }
        Ticket *ticket = [[Ticket alloc] init];
        [planArray addObject:ticket];
        [tbl_plan reloadData];
    }
}

- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index {
    for (int i=0;i<paidArray.count;i++){
        Ticket *data = [paidArray objectAtIndex:i];
        FeedCell *cell = [tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        data.ticket_title = cell.txtName.text;
        data.ticket_price_actual = cell.txtPrice.text;
        data.ticket_qty = [cell.txtQty.text integerValue];
//        [paidArray replaceObjectAtIndex:i withObject:data];
    }
    for (int i=0;i<freeArray.count;i++){
        Ticket *data = [freeArray objectAtIndex:i];
        FeedCell *cell = [tbl_free cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        data.ticket_title = cell.txtName.text;
        data.ticket_price_actual = cell.txtPrice.text;
        data.ticket_qty = [cell.txtQty.text integerValue];
//        [freeArray replaceObjectAtIndex:i withObject:data];
    }
    for (int i=0;i<planArray.count;i++){
        Ticket *data = [planArray objectAtIndex:i];
        FeedCell *cell = [tbl_plan cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        data.ticket_title = cell.txtName.text;
        data.ticket_price_actual = cell.txtPrice.text;
        data.ticket_qty = [cell.txtQty.text integerValue];
//        [planArray replaceObjectAtIndex:i withObject:data];
    }
    current_index = index;
    if (index == 0){
        tableview.hidden = NO;
        tbl_free.hidden = YES;
        tbl_plan.hidden = YES;
        
        tableview.userInteractionEnabled = YES;
        tbl_free.userInteractionEnabled = NO;
        tbl_plan.userInteractionEnabled = NO;
    } else if (index == 1){
        tableview.hidden = YES;
        tbl_free.hidden = NO;
        tbl_plan.hidden = YES;
        
        tableview.userInteractionEnabled = NO;
        tbl_free.userInteractionEnabled = YES;
        tbl_plan.userInteractionEnabled = NO;
    } else {
        tableview.hidden = YES;
        tbl_free.hidden = YES;
        tbl_plan.hidden = NO;
        
        tableview.userInteractionEnabled = NO;
        tbl_free.userInteractionEnabled = NO;
        tbl_plan.userInteractionEnabled = YES;
    }
    
}

- (NSString *)selectionList:(HTHorizontalSelectionList *)selectionList titleForItemWithIndex:(NSInteger)index {
    return labelPays[index];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == tableview){
        return paidArray.count;
    } else if (tableView == tbl_free){
        return freeArray.count;
    } else {
        return planArray.count;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedCell *cell;
    Ticket *ticket;
    if (tableView == tableview){
        cell = [tableview dequeueReusableCellWithIdentifier:@"cellTicketPaid"];
        ticket = [paidArray objectAtIndex:indexPath.row];
    } else if (tableView == tbl_free){
        cell = [tbl_free dequeueReusableCellWithIdentifier:@"cellTicketFree"];
        ticket = [freeArray objectAtIndex:indexPath.row];
    } else {
        cell = [tbl_plan dequeueReusableCellWithIdentifier:@"cellTicketPlan"];
        ticket = [planArray objectAtIndex:indexPath.row];
    }
    
    [cell.txtName setText:ticket.ticket_title];
    if (ticket.ticket_qty == 0){
        [cell.txtQty setText:@""];
    } else {
        [cell.txtQty setText:[NSString stringWithFormat:@"%ld", ticket.ticket_qty]];
    }
    if (ticket.ticket_price_actual == nil){
        [cell.txtPrice setText:@""];
    } else {
        [cell.txtPrice setText:[NSString stringWithFormat:@"%@", ticket.ticket_price_actual]];
    }
    if (tableView == tbl_free){
        [cell.txtPrice setText:@"FREE"];
    }
    
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
