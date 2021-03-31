//
//  TicketQRViewController.m
//  GotTkts
//
//  Created by Jorge on 10/27/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "TicketQRViewController.h"
#import "UIImage+MDQRCode.h"

@interface TicketQRViewController ()
{
    
    IBOutlet UIView *viewContent;
    IBOutlet UIImageView *imgEvent;
    IBOutlet CircleImageView *imgQR;
    IBOutlet UILabel *lblSalesDate;
    IBOutlet UILabel *lblAddress;
    IBOutlet UILabel *lblTktName;
    IBOutlet UILabel *lblTktPrice;
    IBOutlet UILabel *lblTktSubTotal;
    IBOutlet UILabel *lblOrderTotal;
    IBOutlet UILabel *lblTktQty;
    IBOutlet UILabel *lblQtyPurchased;
}
@end

@implementation TicketQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [Util setCornerView:viewContent];
    
    // init data
    [imgQR setImage:[UIImage mdQRCodeForString:self.ticket.qr_code size:self.view.frame.size.width - 40 fillColor:[UIColor blackColor]]];
    [Util setBorderView:imgQR color:[UIColor lightGrayColor] width:1.0f];
    [imgEvent hnk_setImageFromURL:[NSURL URLWithString:self.ticket.event_image]];
    lblSalesDate.text = self.ticket.event_start_date;
    lblAddress.text = self.ticket.event_address;
    lblTktName.text = self.ticket.ticket_title;
    lblTktPrice.text = [NSString stringWithFormat:@"$ %@", self.ticket.ticket_price];
    lblTktQty.text = [NSString stringWithFormat:@"%ld", self.ticket.ticket_qty];
    lblTktSubTotal.text = @"$ Free";
    lblOrderTotal.text = [NSString stringWithFormat:@"%ld", self.ticket.ticket_qty];
    lblQtyPurchased.text = [NSString stringWithFormat:@"%ld", self.ticket.ticket_qty];
}

- (IBAction)onback:(id)sender {
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
