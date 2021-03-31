//
//  ChatViewController.m
//  Lavigne
//
//  Created by gao on 7/26/18.
//  Copyright © 2018 developer. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatDetailsViewController.h"

@interface ChatViewController ()
{
    IBOutlet UILabel *lblTitle;
    
}
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showChat"]) {
        ChatDetailsViewController *vc = (ChatDetailsViewController *) segue.destinationViewController;
        
    }
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
