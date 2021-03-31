//
//  InformViewController.m
//  GotTkts
//
//  Created by Jorge on 7/4/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "InformViewController.h"
#import "MainViewController.h"

@interface InformViewController ()
{
    IBOutlet UIWebView *webview;
    IBOutlet UILabel *lblTitle;
    
}
@end

@implementation InformViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    [webview loadHTMLString:htmlString baseURL:[[NSBundle mainBundle] bundleURL]];
    
//    [webview loadHTMLString:[NSString stringWithFormat:@"<html><body style=\"background:transparent\" text=\"#ffffff\" face=\"Bookman Old Style, Book Antiqua, Garamond\" size=\"5\">%@</body></html>", htmlString] baseURL: nil];
    
    [webview setBackgroundColor:[UIColor clearColor]];
    [webview setOpaque:NO];
    webview.scrollView.scrollEnabled = YES;
    webview.scalesPageToFit = YES;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self loadData];
}

- (void) loadData {
    if (![Util isConnectableInternet]){
        [Util showAlertTitle:self title:@"Error" message:@"The Internet connection appears to be offline."];
        return;
    }
    NSString *requestUrl = @"";
    switch (self.type) {
        case FLAG_FAQ:
            requestUrl = REQUEST_FAQ;
            break;
        case FLAG_TERMS:
            requestUrl = REQUEST_TERMS;
            break;
        case FLAG_PRIVACY:
            requestUrl = REQUEST_PRIVACY;
            [webview setOpaque:YES];
            break;
        default:
            requestUrl = REQUEST_FAQ;
            break;
    }
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [UserModel currentUser].token] forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager GET:requestUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        [SVProgressHUD dismiss];
        NSMutableDictionary *response = (NSMutableDictionary *) responseObject;
        NSMutableDictionary *data = response[@"data"];
        NSString *title = data[@"title"];
        NSString *content = data[@"content"];
        lblTitle.text = title;
        [webview loadHTMLString:[NSString stringWithFormat:@"<html><body style=\"background:transparent\" text=\"#ffffff\" face=\"Bookman Old Style, Book Antiqua, Garamond\" size=\"5\">%@</body></html>", content] baseURL: nil];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [self showError:[error localizedDescription]];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onMenu:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
