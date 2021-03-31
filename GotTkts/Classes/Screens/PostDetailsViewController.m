//
//  PostDetailsViewController.m
//  GotTkts
//
//  Created by Jorge on 7/25/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "PostDetailsViewController.h"
#import "TicketsViewController.h"
#import <WebKit/WebKit.h>

@interface PostDetailsViewController ()
{
    IBOutlet UILabel *lblTitle;
    IBOutlet UIImageView *imgEvent;
    IBOutlet UILabel *lblLocation;
    IBOutlet UILabel *lblStart;
    IBOutlet UILabel *lblEnd;
    IBOutlet UIWebView *webview;
    __weak IBOutlet UILabel *testingLbl;
}
@end

@implementation PostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
}

- (void) initData {
    lblTitle.text = self.event.event_name;
    [imgEvent hnk_setImageFromURL:[NSURL URLWithString:self.event.event_image]];
    
    if (self.event.event_address != nil){
        lblLocation.text = self.event.event_address;
    } else if (self.event.event_location.length && self.event.event_location.length > 0) {
        lblLocation.text = self.event.event_location;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSString *formatterStr = @"MM-dd-yyyy";
    [dateFormatter setDateFormat:formatterStr];
    lblStart.text = [dateFormatter stringFromDate:[Util getDateFromString:self.event.event_start_datetime formatter:nil]];
    
    [webview setBackgroundColor:[UIColor clearColor]];
    webview.scrollView.scrollEnabled = YES;
//    webview.scalesPageToFit = YES;
    webview.contentMode = UIViewContentModeScaleAspectFill;
    
    [webview loadHTMLString:self.event.event_description baseURL:nil];
    
    
    
    NSString *strHTML = @"S.Panchami 01.38<br>Arudra 02.01<br>V.08.54-10.39<br>D.05.02-06.52<br> <font color=red><u>Festival</u></font><br><font color=blue>Shankara Jayanthi<br></font>";
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[self.event.event_description dataUsingEncoding:NSUTF8StringEncoding]
                                                                   options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                             NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)}
                                                        documentAttributes:nil
                                                                     error:nil];
    NSLog(@"html: %@",self.event.event_description);
    NSLog(@"attr: %@", attrStr);
    NSLog(@"string: %@", [attrStr string]);
    NSString *finalString = [attrStr string];
    NSLog(@"The finalString is - %@",finalString);
    
    testingLbl.text = finalString;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onAttend:(id)sender {
    TicketsViewController *vc = (TicketsViewController *)[Util getUIViewControllerFromStoryBoard:@"TicketsViewController"];
    vc.event = self.event;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
