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

@class OrderCell;

@protocol OrderCellDelegate <NSObject>
//@required
@optional

- (void) onSMS:(OrderCell *) cell;

@end


@interface OrderCell : UITableViewCell

@property (strong, nonatomic) id<OrderCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *viewContent;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderId;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblTkts;

@end

