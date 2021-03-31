//
//  SuperViewController.h
//  Quize
//
//  Created by anton bill on 12/10/13.
//  Copyright (c) 2013 anton bill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "Util.h"
#import "Config.h"
#import "AAPullToRefresh.h"
#import "SCLAlertView.h"
#import "UIPlaceHolderTextView.h"
#import "AppStateManager.h"
#import "CircleImageView.h"
#import "Response.h"
#import <Haneke/Haneke.h>
#import "UserModel.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface SuperViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate>
{
    
    IBOutlet UILabel *lblTitle;
    
    /* UITextField Delegate */
    UIButton * numberPadDoneButton;
    BOOL _keyboardIsShowing;
    
    UITextField * weakRefTextField;
    
    // Pull Refresh and Load more
    UIScrollView *pullRefreshTable;
    AAPullToRefresh *topV;
    AAPullToRefresh *bottomV;
    
    UIScrollView *pullRefreshTableNext;
    AAPullToRefresh *topVNext;
    AAPullToRefresh *bottomVNext;
}

@property (nonatomic)       NSInteger curPage;
@property (nonatomic)       NSInteger curPageNext;

- (void) setPullRefreshView:(UIScrollView *) view hasTop:(BOOL) hasTop hasBottom:(BOOL) hasBottom ;
- (void) PullRefreshTableViewRefresh ;
- (void) stopRefreshAnimationRestoreOffset ;
- (void) sendMail:(NSArray *)emails subject:(NSString *)subj message:msg;
- (void) setPullRefreshViewNext:(UIScrollView *) view hasTop:(BOOL) hasTop hasBottom:(BOOL) hasBottom ;
- (void) PullRefreshTableViewRefreshNext ;
- (void) stopRefreshAnimationRestoreOffsetNext ;
- (void) gotoMain ;
- (void) gotoLogin;

- (void) showError:(NSString *)error;
@end
