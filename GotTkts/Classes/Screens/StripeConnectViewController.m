//
//  StripeConnectViewController.m
//  GotTkts
//
//  Created by Jorge Siu on 11/15/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "StripeConnectViewController.h"

@interface StripeConnectViewController ()
{
    UIWebView *webview;
    BOOL inited;
    NSURLRequest *stripeRequest;
    IBOutlet UIView *htmlView;
}
@end

@implementation StripeConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *stripeURL = [NSString stringWithFormat:@"%@?email=%@&password=%@", STRIPE_CONNECT_URL, [Util getLoginUserName], [Util getLoginUserPassword]];
    NSURL *url = [NSURL URLWithString:stripeURL];
    stripeRequest =[NSURLRequest requestWithURL:url];
}

- (IBAction)onback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (inited)
        return;
    
    webview = [[UIWebView alloc] initWithFrame:htmlView.frame];
    [self.view addSubview:webview];
    inited = YES;
//    webview.delegate = self;
    [webview loadRequest:stripeRequest];
    webview.backgroundColor = [UIColor clearColor];
    [webview setOpaque:NO];
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
