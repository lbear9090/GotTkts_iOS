//
//  MessagesViewController.m
//  GotTkts
//
//  Created by Jorge on 7/4/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "MessagesViewController.h"
#import "MainViewController.h"
#import "ChatViewController.h"

@interface MessagesViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *dataArray;
    IBOutlet UILabel *lblNodata;
    IBOutlet UITableView *tableview;
}
@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dataArray = [[NSMutableArray alloc] init];
    
    [Util setCornerView:lblNodata];
    [Util setBorderView:lblNodata color:[UIColor whiteColor] width:1.0f];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshItems) name:kChatReceiveRoomsNotification object:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refreshItems];
}

- (void) refreshItems {
    if (![Util isConnectableInternet]){
        [Util showAlertTitle:self title:@"Error" message:@"The Internet connection appears to be offline."];
        return;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onMenu:(id)sender {
    [[MainViewController getInstance] toggleMenu];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellMessage"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    CircleImageView *imgAvatar = [cell viewWithTag:1];
    UILabel *lblName = [cell viewWithTag:2];
    UILabel *lblMessage = [cell viewWithTag:3];
    UILabel *lblDate = [cell viewWithTag:4];
    UIView *ic_dot = [cell viewWithTag:5];
    ic_dot.hidden = YES;
    
    [Util setCircleView:ic_dot];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatViewController *vc = (ChatViewController *)[Util getUIViewControllerFromStoryBoard:@"ChatViewController"];    
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

@end
