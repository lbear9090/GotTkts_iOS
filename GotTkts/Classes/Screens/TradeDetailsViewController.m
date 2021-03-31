//
//  TradeDetailsViewController.m
//  GotTkts
//
//  Created by Jorge on 7/25/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "TradeDetailsViewController.h"

@interface TradeDetailsViewController ()
{
    IBOutlet UILabel *lblTitle;
    IBOutlet UIButton *btnYes;
    IBOutlet UIButton *btnNo;
    
    IBOutlet UILabel *imgAvatarFrom;
    IBOutlet UILabel *lblNameFrom;
    IBOutlet UIImageView *imgItemFrom;
    IBOutlet UILabel *lblTitleFrom;
    IBOutlet CircleImageView *imgAvatarTo;
    IBOutlet UILabel *lblNameTo;
    IBOutlet UILabel *lblTitleTo;
    IBOutlet UIImageView *imgItemTo;
}
@end

@implementation TradeDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [Util setBorderView:imgItemFrom color:[UIColor whiteColor] width:1.0f];
    [Util setBorderView:imgItemTo color:[UIColor whiteColor] width:1.0f];
    [Util setCornerView:imgItemFrom];
    [Util setCornerView:imgItemTo];
    
    // init data
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onYes:(id)sender {
    
}

- (IBAction)onNo:(id)sender {
    
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
