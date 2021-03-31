//
//  ViewController.m
//  PagaYa
//
//  Created by developer on 28/05/17.
//  Copyright © 2017 developer. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [SVProgressHUD setForegroundColor:MAIN_COLOR];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        LoginViewController *vc = (LoginViewController *)[Util getUIViewControllerFromStoryBoard:@"LoginViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onStart:(id)sender {
//    if (![Util getBoolValue:@"isFirst"]){
        [Util setBoolValue:@"isFirst" value:YES];
        PagerViewController *vc = (PagerViewController *)[Util getUIViewControllerFromStoryBoard:@"PagerViewController"];
        [self.navigationController pushViewController:vc animated:YES];
//    } else {
//        LoginViewController *vc = (LoginViewController *)[Util getUIViewControllerFromStoryBoard:@"LoginViewController"];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}

@end
