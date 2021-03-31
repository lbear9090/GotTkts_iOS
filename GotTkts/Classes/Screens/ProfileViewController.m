//
//  ProfileViewController.m
//  GotTkts
//
//  Created by Jorge on 7/4/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "ProfileViewController.h"
#import "MainViewController.h"
#import "HCSStarRatingView.h"
#import "FeedCell.h"
#import "AddItemViewController.h"
#import "SignUpViewController.h"
#import <Parse/Parse.h>
#import <GoogleMaps/GoogleMaps.h>

@interface ProfileViewController ()
{
    IBOutlet CircleImageView *imgAvatar;
    IBOutlet UILabel *lblName;
    IBOutlet UIButton *btnEdit;
    
    NSMutableArray *dataArray;
    IBOutlet UIButton *btn_back;
    IBOutlet GMSMapView *mapView;
    IBOutlet UILabel *lblDate;
}
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [Util setBorderView:imgAvatar color:[UIColor grayColor] width:2.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initData];
}

- (void) initData {
    UserModel *me = [UserModel currentUser];
    if (me.fullname){
        lblName.text = me.fullname;
    } else if (me.firstname){
        lblName.text = [NSString stringWithFormat:@"%@ %@", me.firstname, me.lastname];
    }
    if (me.avatar){
        [imgAvatar hnk_setImageFromURL:[NSURL URLWithString:me.avatar]];
    }

    NSDate *date = [Util getDateFromString:me.created_at formatter:nil];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    NSInteger month = [[dateFormatter stringFromDate:date] integerValue];
    
    [dateFormatter setDateFormat:@"yyyy"];
    
    NSString *year = [dateFormatter stringFromDate:date];
    
    lblDate.text = [NSString stringWithFormat:@"Member Since\n%@ %@", [MONTHS objectAtIndex:(month - 1)], year];
}

- (IBAction)onEditProfile:(id)sender {
    SignUpViewController *vc = (SignUpViewController *)[Util getUIViewControllerFromStoryBoard:@"SignUpViewController"];
    vc.isEdit = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)onback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
