//
//  MainViewController.m
//  GotTkts
//
//  Created by Jorge on 7/4/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "MainViewController.h"
#import "FeedCell.h"
#import "PostDetailsViewController.h"
#import "EventResponse.h"
#import "MapViewController.h"

@interface MainViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate>
{
    IBOutlet UICollectionView *collectionview;
    
    NSMutableArray *dataArray;
    NSMutableArray *filteredArray;
    IBOutlet UISearchBar *searchBar;
}
@end

static MainViewController *_sharedViewController = nil;

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _sharedViewController = self;
    collectionview.delegate = self;
    collectionview.dataSource = self;
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onHome:) name:NOTIFICATION_PAGE_HOME object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onProfile:) name:NOTIFICATION_PAGE_PROFILE object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onCategory:) name:NOTIFICATION_PAGE_CATEGORY object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onTrade:) name:NOTIFICATION_PAGE_TRADE object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onFavorite:) name:NOTIFICATION_PAGE_FAVORITE object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onMessage:) name:NOTIFICATION_PAGE_MESSAGE object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onAbout:) name:NOTIFICATION_PAGE_ABOUT object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onSettings:) name:NOTIFICATION_PAGE_SETTINGS object:nil];
    
    dataArray = [[NSMutableArray alloc] init];
    filteredArray = [[NSMutableArray alloc] init];
    [Util setBorderView:searchBar color:[UIColor lightTextColor] width:0.5f];
    [Util setCornerView:searchBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    searchBar.text = @"";
    [self refreshItems];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0){
        filteredArray = dataArray;
        [collectionview reloadData];
    } else {
        [self filterEvents:searchText];
    }
}

- (void) filterEvents:(NSString *)searchText {
    NSString *filterNameFormat = @"SELF.event_name CONTAINS[c] %@";
    NSString *filterDateFormat = @"SELF.dateString CONTAINS[c] %@";
    NSPredicate *filterName = [NSPredicate predicateWithFormat:filterNameFormat, searchText];
    NSPredicate *filterDate = [NSPredicate predicateWithFormat:filterDateFormat, searchText];
    NSCompoundPredicate *filter = [NSCompoundPredicate orPredicateWithSubpredicates:@[filterName, filterDate]];
//    NSPredicate* predicate = [NSPredicate predicateWithFormat:filter,searchText];
//    filteredArray = (NSMutableArray *)[dataArray filteredArrayUsingPredicate:predicate];
    filteredArray = (NSMutableArray *) [dataArray filteredArrayUsingPredicate:filter];
    [collectionview reloadData];
}

- (void) refreshItems {
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
        filteredArray = [[NSMutableArray alloc] init];
        EventResponse *response = [[EventResponse alloc] initWithDictionary:responseObject];
        if (response.status.code != 200){
            [self showError:response.status.msg];
        } else {
            for (Event *item in response.result){
                if (item.event_image.length > 0){
                    item.dateString = [self dateStringofEvent:item];
                    [dataArray addObject:item];
                }
            }
            filteredArray = dataArray;
        }
        [collectionview reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [self showError:[error localizedDescription]];
    }];
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return filteredArray.count;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellEvent" forIndexPath:indexPath];
    UIImageView *imgEvent = [cell viewWithTag:1];
    UIView *viewBottom = [cell viewWithTag:2];
    UILabel *lblTitle = [cell viewWithTag:3];
    UILabel *viewTop = [cell viewWithTag:4];
    UILabel *lblDay = [cell viewWithTag:5];
    [Util setCircleView:viewTop];
    
    if (row % 4 == 0){
        viewBottom.backgroundColor = [UIColor redColor];
        viewTop.backgroundColor = [UIColor redColor];
    } else if (row % 4 == 1){
        viewBottom.backgroundColor = [UIColor greenColor];
        viewTop.backgroundColor = [UIColor greenColor];
    } else if (row % 4 == 2){
        viewBottom.backgroundColor = [UIColor purpleColor];
        viewTop.backgroundColor = [UIColor purpleColor];
    } else if (row % 4 == 3){
        viewBottom.backgroundColor = [UIColor grayColor];
        viewTop.backgroundColor = [UIColor grayColor];
    }
    
    Event *event = [filteredArray objectAtIndex:indexPath.row];
    lblTitle.text = event.event_name;
    imgEvent.layer.cornerRadius = 6.0;
    imgEvent.clipsToBounds = true;
    NSString *newString = [[event.dateString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];

    lblDay.text = newString;
    
    [imgEvent hnk_setImageFromURL:[NSURL URLWithString:event.event_image]];
    [Util setCornerView:cell];
    return cell;
}

- (NSString *) dateStringofEvent:(Event *)event {
    NSArray *dataComps = [event.event_end_datetime componentsSeparatedByString:@" "];
    NSString *date = dataComps[0];
    dataComps = [date componentsSeparatedByString:@"-"];
    NSString *day = dataComps[2];
    NSString *year = dataComps[0];
    int month = [dataComps[1] intValue];
    NSString *monthStr = [MONTH_WRDS objectAtIndex:(month-1)];
    return [NSString stringWithFormat:@"%@\n%@\n%@", monthStr, day, year];
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = collectionView.frame.size.width / 3.0;
    CGFloat height = width / 2.0 + 180;
    return CGSizeMake(width, height);
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PostDetailsViewController *vc = (PostDetailsViewController *)[Util getUIViewControllerFromStoryBoard:@"PostDetailsViewController"];
    vc.event = [filteredArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onMap:(id)sender {
    MapViewController *vc = (MapViewController *)[Util getUIViewControllerFromStoryBoard:@"MapViewController"];
    vc.dataArray = dataArray;
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

- (IBAction)onMenu:(id)sender {
//    [self toggleMenu];
    [self.navigationController popViewControllerAnimated:YES];
}

+ (MainViewController *)getInstance {
    return _sharedViewController;
}
- (void) pushViewController:(UIViewController *) viewController {
    [self.navigationController pushViewController:viewController animated:YES];
}
- (void) pushViewController:(UIViewController *)viewController animation:(BOOL) animate {
    [self.navigationController pushViewController:viewController animated:animate];
}
- (void) presentViewController:(UIViewController *) viewController {
    [self presentViewController:viewController animated:YES completion:^(void){
    }];
}

- (void) toggleMenu {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

- (void) gotoTarget:(UIViewController *)vc Class:(Class)member{
    for (UIViewController *vc in [MainViewController getInstance].navigationController.viewControllers){
        if ([vc isKindOfClass:member]){
            [self.navigationController popToViewController:vc animated:NO];
            [self toggleMenu];
            return;
        }
    }
    [self.navigationController pushViewController:vc animated:NO];
    [self toggleMenu];
}

- (void) onHome:(NSNotification *)notification {
    MainViewController *vc = (MainViewController *)[Util getUIViewControllerFromStoryBoard:@"MainViewController"];
    [self gotoTarget:vc Class:[MainViewController class]];
}

- (void) onProfile:(NSNotification *)notification {
    ProfileViewController *vc = (ProfileViewController *)[Util getUIViewControllerFromStoryBoard:@"ProfileViewController"];
    [self gotoTarget:vc Class:[ProfileViewController class]];
}

- (void) onCategory:(NSNotification *)notification {
    CategoryViewController *vc = (CategoryViewController *)[Util getUIViewControllerFromStoryBoard:@"CategoryViewController"];
    [self gotoTarget:vc Class:[CategoryViewController class]];
}

- (void) onTrade:(NSNotification *)notification {
    TradeViewController *vc = (TradeViewController *)[Util getUIViewControllerFromStoryBoard:@"TradeViewController"];
    [self gotoTarget:vc Class:[TradeViewController class]];
}

- (void) onFavorite:(NSNotification *)notification {
    FavoritesViewController *vc = (FavoritesViewController *)[Util getUIViewControllerFromStoryBoard:@"FavoritesViewController"];
    [self gotoTarget:vc Class:[FavoritesViewController class]];
}

- (void) onMessage:(NSNotification *)notification {
    MessagesViewController *vc = (MessagesViewController *)[Util getUIViewControllerFromStoryBoard:@"MessagesViewController"];
    [self gotoTarget:vc Class:[MessagesViewController class]];
}

- (void) onAbout:(NSNotification *)notification {
    InformViewController *vc = (InformViewController *)[Util getUIViewControllerFromStoryBoard:@"InformViewController"];
    [self gotoTarget:vc Class:[InformViewController class]];
}

- (void) onSettings:(NSNotification *)notification {
    SettingsViewController *vc = (SettingsViewController *)[Util getUIViewControllerFromStoryBoard:@"SettingsViewController"];
    [self gotoTarget:vc Class:[SettingsViewController class]];
}



@end
