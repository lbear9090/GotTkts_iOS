//
//  SuperViewController.m
//  Quize
//
//  Created by anton bill on 12/10/13.
//  Copyright (c) 2013 anton bill. All rights reserved.
//

#import "SuperViewController.h"
#import "IQKeyboardManager.h"
#import <MessageUI/MessageUI.h>
#import "IQKeyboardReturnKeyHandler.h"

@interface SuperViewController ()
{
    IQKeyboardReturnKeyHandler *returnKeyHandler;
}
@end

@implementation SuperViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    [self setKeyBoard];
    
    if (lblTitle) {
        [lblTitle setFont: [UIFont fontWithName: @"Lobster 1.4" size: 23]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChangedPage:) name:NOTIFICATION_CHANGED_PAGE object:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void) dealloc {
    if (topV) {
        [topV setShowPullToRefresh:NO];
    }
    if (bottomV) {
        [bottomV setShowPullToRefresh:NO];
    }
    if (topVNext) {
        [topVNext setShowPullToRefresh:NO];
    }
    if (bottomVNext) {
        [bottomVNext setShowPullToRefresh:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) onChangedPage:(NSNotification *)notification {
    [self.view endEditing:YES];
}

-(void)setKeyBoard
{
    [[IQKeyboardManager sharedManager] setOverrideKeyboardAppearance:NO];
    [[IQKeyboardManager sharedManager] setKeyboardAppearance:UIKeyboardAppearanceDefault];
//    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    [returnKeyHandler setLastTextFieldReturnKeyType:UIReturnKeyDone];
    [[IQKeyboardManager sharedManager] setShouldShowTextFieldPlaceholder:YES];
    [[IQKeyboardManager sharedManager] keyboardDistanceFromTextField];
    [[IQKeyboardManager sharedManager] setShouldShowTextFieldPlaceholder:NO];
}

#pragma mark - Pull Refresh related functions
- (void) setPullRefreshView:(UIScrollView *) view hasTop:(BOOL) hasTop hasBottom:(BOOL) hasBottom {
    pullRefreshTable = view;
    
    __weak SuperViewController *weakSelf = self;
    
    self.curPage = PAGINATION_START_INDEX;
    
    if (pullRefreshTable) {
        if (hasTop) {
            // top
            topV = [pullRefreshTable addPullToRefreshPosition:AAPullToRefreshPositionTop ActionHandler:^(AAPullToRefresh *v) {
                weakSelf.curPage = PAGINATION_START_INDEX;
                [weakSelf PullRefreshTableViewRefresh];
            }];
            topV.borderColor = [UIColor whiteColor];
            topV.imageIcon = [UIImage imageNamed:@"pullRefresh_header.png"];
            topV.threshold = 30.f;
        }
        
        if (hasBottom) {
            // bottom
            bottomV = [pullRefreshTable addPullToRefreshPosition:AAPullToRefreshPositionBottom ActionHandler:^(AAPullToRefresh *v) {
                weakSelf.curPage ++;
                [weakSelf PullRefreshTableViewRefresh];
            }];
            bottomV.borderColor = [UIColor whiteColor];
            bottomV.imageIcon = [UIImage imageNamed:@"pullRefresh_header.png"];
            bottomV.threshold = 30.f;
        }
    }
}

- (void) gotoMain {
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    UIViewController *aViewController;
    NSInteger count = allViewControllers.count;
    for (int i=0;i<count;i++) {
        aViewController = allViewControllers[count-i-1];
//        if ([aViewController isKindOfClass:[AppNameViewController class]]) {
//            [self.navigationController popToViewController:aViewController animated:NO];
//            break;
//        }
    }
}

- (void) gotoLogin {
    NSString *msg = @"You need to login first to continue. Are you want to login now?";
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    alert.customViewColor = MAIN_COLOR;
    alert.horizontalButtons = YES;
    [alert addButton:@"Yes" actionBlock:^(void) {
        for (UIViewController *vc in self.navigationController.viewControllers){
//            if ([vc isKindOfClass:[LoginViewController class]]){
//                [self.navigationController popToViewController:vc animated:YES];
//                break;
//            }
        }
    }];
    [alert addButton:@"No" actionBlock:^(void) {
        
    }];
    [alert showError:@"Action Required" subTitle:msg closeButtonTitle:nil duration:0.0f];
}


- (void) setPullRefreshViewNext:(UIScrollView *) view hasTop:(BOOL) hasTop hasBottom:(BOOL) hasBottom {
    pullRefreshTableNext = view;
    
    __weak SuperViewController *weakSelf = self;
    
    self.curPageNext = PAGINATION_START_INDEX;
    
    if (pullRefreshTable) {
        if (hasTop) {
            // top
            topVNext = [pullRefreshTableNext addPullToRefreshPosition:AAPullToRefreshPositionTop ActionHandler:^(AAPullToRefresh *v) {
                weakSelf.curPageNext = PAGINATION_START_INDEX;
                [weakSelf PullRefreshTableViewRefreshNext];
            }];
            topVNext.borderColor = [UIColor whiteColor];
            topVNext.imageIcon = [UIImage imageNamed:@"pullRefresh_header.png"];
            topVNext.threshold = 30.f;
        }
        
        if (hasBottom) {
            // bottom
            bottomVNext = [pullRefreshTableNext addPullToRefreshPosition:AAPullToRefreshPositionBottom ActionHandler:^(AAPullToRefresh *v) {
                weakSelf.curPageNext ++;
                [weakSelf PullRefreshTableViewRefreshNext];
            }];
            bottomVNext.borderColor = [UIColor whiteColor];
            bottomVNext.imageIcon = [UIImage imageNamed:@"pullRefresh_header.png"];
            bottomVNext.threshold = 30.f;
        }
    }
}

// Overridable function for refreshing and load more
- (void) PullRefreshTableViewRefresh {
    
}

// Overridable function for refreshing and load more
- (void) PullRefreshTableViewRefreshNext {
    
}

// Overridable function for saving the origin content offset
- (void) stopRefreshAnimationRestoreOffset {
    
    if (!pullRefreshTable) {
        return;
    }
    CGPoint contentOffset = pullRefreshTable.contentOffset;
    if ([pullRefreshTable isKindOfClass:[UITableView class]]) {
        [((UITableView*) pullRefreshTable) reloadData];
    } else if ([pullRefreshTable isKindOfClass:[UICollectionView class]]) {
        [((UICollectionView*) pullRefreshTable) reloadData];
    } else {
        contentOffset = CGPointMake(0, 0);
    }
    
    if (self.curPage == PAGINATION_START_INDEX) {
        [topV stopIndicatorAnimation];
    } else {
        [bottomV stopIndicatorAnimation];
        [pullRefreshTable setContentOffset:contentOffset];
    }
    
    // Check the current item count
    NSInteger curCount = 0;
    if ([pullRefreshTable isKindOfClass:[UITableView class]]) {
        curCount = [(UITableView*)pullRefreshTable numberOfRowsInSection:0];
    } else if ([pullRefreshTable isKindOfClass:[UICollectionView class]]) {
        curCount = [(UICollectionView*) pullRefreshTable numberOfItemsInSection:0];
    }
    if (curCount < PAGINATION_DEFAULT_COUNT) {
        if (bottomV) {
            [bottomV setShowPullToRefresh:NO];
        }
    } else {
        if (bottomV) {
            [bottomV setShowPullToRefresh:YES];
        }
    }
}

- (void) sendMail:(NSArray *)emails subject:(NSString *)subj message:(id)msg{
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    if([MFMailComposeViewController canSendMail])
    {
        [controller setToRecipients:emails];
        [controller setSubject:subj];
        [controller setMessageBody:msg isHTML:NO];
        controller.mailComposeDelegate = self;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [self presentViewController:controller animated:YES completion:^{
            [SVProgressHUD dismiss];
        }];
    } else {
        NSLog(@"Cannot send email");
    }
}

#pragma mark - MFMailcomposer
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:^{
        if (result == MFMailComposeResultSent) {
            NSLog(@"mail sent");
            [Util showAlertTitle:self title:@"" message:@"Email sent"];
        } else if (result == MFMailComposeResultFailed){
            [Util showAlertTitle:self title:@"" message:@"Email failed"];
            NSLog(@"mail failed");
        } else if (result == MFMailComposeResultSaved){
            [Util showAlertTitle:self title:@"" message:@"Email saved"];
            NSLog(@"mail saved");
        } else if (result == MFMailComposeResultCancelled){
            [Util showAlertTitle:self title:@"" message:@"Email cancelled"];
            NSLog(@"mail cancelled");
        }
    }];
}

// Overridable function for saving the origin content offset
- (void) stopRefreshAnimationRestoreOffsetNext {
    
    if (!pullRefreshTableNext) {
        return;
    }
    CGPoint contentOffset = pullRefreshTableNext.contentOffset;
    if ([pullRefreshTableNext isKindOfClass:[UITableView class]]) {
        [((UITableView*) pullRefreshTableNext) reloadData];
    } else if ([pullRefreshTableNext isKindOfClass:[UICollectionView class]]) {
        [((UICollectionView*) pullRefreshTableNext) reloadData];
    } else {
        contentOffset = CGPointMake(0, 0);
    }
    
    if (self.curPage == PAGINATION_START_INDEX) {
        [topVNext stopIndicatorAnimation];
    } else {
        [bottomVNext stopIndicatorAnimation];
        [pullRefreshTableNext setContentOffset:contentOffset];
    }
    
    // Check the current item count
    NSInteger curCount = 0;
    if ([pullRefreshTableNext isKindOfClass:[UITableView class]]) {
        curCount = [(UITableView*)pullRefreshTableNext numberOfRowsInSection:0];
    } else if ([pullRefreshTableNext isKindOfClass:[UICollectionView class]]) {
        curCount = [(UICollectionView*) pullRefreshTableNext numberOfItemsInSection:0];
    }
    if (curCount < PAGINATION_DEFAULT_COUNT) {
        if (bottomVNext) {
            [bottomVNext setShowPullToRefresh:NO];
        }
    } else {
        if (bottomVNext) {
            [bottomVNext setShowPullToRefresh:YES];
        }
    }
}

- (void) showError:(NSString *)error {
    [Util showAlertTitle:self title:@"Error" message:error];
}
@end
