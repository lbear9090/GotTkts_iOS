//
//  FavoritesViewController.m
//  GotTkts
//
//  Created by Jorge on 7/4/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "FavoritesViewController.h"
#import "MainViewController.h"
#import "HTHorizontalSelectionList.h"

#define LABEL_TOPBAR               [[NSArray alloc] initWithObjects:@"PAST", @"ALL", nil]

@interface FavoritesViewController ()<HTHorizontalSelectionListDelegate, HTHorizontalSelectionListDataSource, UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet HTHorizontalSelectionList *topbarList;
    IBOutlet UITableView *tableview;
    
    NSMutableArray *dataArray;
}
@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onMenu:(id)sender {
    [[MainViewController getInstance] toggleMenu];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index {
    
}

- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList {
    return LABEL_TOPBAR.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellEvent"];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

@end
