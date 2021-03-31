//
//  FeedCell.h
//  OMG
//
//  Created by Vitaly's Team on 7/22/17.
//  Copyright © 2017 BrainyApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "Util.h"
#import "CircleImageView.h"

@class TicketCell;

@protocol TicketCellDelegate <NSObject>
//@required
@optional
- (void)onDisplayTicket:(TicketCell *)cell;
@end


@interface TicketCell : UITableViewCell

@property (strong, nonatomic) id<TicketCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIImageView *imgEvent;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIView *viewDate;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UIView *viewBarcode;
@property (strong, nonatomic) IBOutlet UILabel *lblOrder;
@property (strong, nonatomic) IBOutlet UIView *viewContent;

@end

