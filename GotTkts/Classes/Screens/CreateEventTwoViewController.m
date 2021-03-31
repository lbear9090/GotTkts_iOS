//
//  CreateEventTwoViewController.m
//  GotTkts
//
//  Created by Jorge on 10/23/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "CreateEventTwoViewController.h"
#import "CreateEventThreeViewController.h"
#import "AddTicketsViewController.h"
#import "CreateEventFourViewController.h"

@interface CreateEventTwoViewController ()
{
    IBOutlet UIButton *onback;
    
    IBOutlet UITextField *txtUrl;
    IBOutlet UITextField *txtAddress;
    IBOutlet UITextField *txtCommission;
    IBOutlet UITextField *txtFacebook;
    IBOutlet UITextField *txtTwitter;
    IBOutlet UITextField *txtInstagram;
    IBOutlet UISwitch *swtPublish;
    IBOutlet UISwitch *swtReaminTkts;
    IBOutlet UIView *viewCommision;
    IBOutlet UISwitch *swtSubpromoter;
    IBOutlet UILabel *lblTitle;
    IBOutlet UISwitch *swtMap;
    IBOutlet UITextField *txtPickUp;
}
@end

@implementation CreateEventTwoViewController
     
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.isEdit){
        txtUrl.text = self.event.event_url;
        txtAddress.text = self.event.event_address;
        txtCommission.text = [NSString stringWithFormat:@"%f", self.event.event_commision];
        [swtSubpromoter setOn:(self.event.event_allow_subpormoter == 1)];
        [swtPublish setOn:(self.event.event_is_publish == 1)];
        [swtReaminTkts setOn:(self.event.event_display_remain == 1)];
        lblTitle.text = @"Edit Event";
    }
}

- (IBAction)onback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onNext:(id)sender {
    if (![self isValid]){
        return;
    }
    self.event.event_url = txtUrl.text;
//    self.event.event_address = txtAddress.text;
    self.event.event_commision = [txtCommission.text doubleValue];
    if (swtSubpromoter.isOn){
        self.event.event_allow_subpormoter = 1;
    } else {
        self.event.event_allow_subpormoter = 0;
    }
    if (swtPublish.isOn){
        self.event.event_is_publish = 1;
    } else {
        self.event.event_is_publish = 0;
    }
    if (swtReaminTkts.isOn){
        self.event.event_display_remain = 1;
    } else {
        self.event.event_display_remain = 0;
    }
    if (swtMap.isOn){
        self.event.event_display_map = 1;
    } else {
        self.event.event_display_map = 0;
    }
    if (txtPickUp.text.length > 0){
        self.event.event_pickup = txtPickUp.text;
    } else {
        self.event.event_pickup = @"";
    }
//    AddTicketsViewController *vc = (AddTicketsViewController *)[Util getUIViewControllerFromStoryBoard:@"AddTicketsViewController"];
//    vc.event = self.event;
    CreateEventFourViewController *vc = (CreateEventFourViewController *)[Util getUIViewControllerFromStoryBoard:@"CreateEventFourViewController"];
    vc.event = self.event;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL) isValid {
    txtUrl.text = [Util trim:txtUrl.text];
    txtAddress.text = [Util trim:txtAddress.text];
    txtCommission.text = [Util trim:txtCommission.text];
    
    return YES;
}

- (IBAction)onAllowSubpromoter:(id)sender {
    viewCommision.hidden = !swtSubpromoter.isOn;
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
