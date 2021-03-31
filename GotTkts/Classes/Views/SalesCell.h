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
#import <MBCircularProgressBar/MBCircularProgressBarView.h>

@class SalesCell;

@protocol SalesCellDelegate <NSObject>
//@required
@optional

- (void) onCheckIn:(SalesCell *) cell;

@end


@interface SalesCell : UITableViewCell

@property (strong, nonatomic) id<SalesCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIView *viewContent;
@property (strong, nonatomic) IBOutlet UIImageView *imgEvent;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet MBCircularProgressBarView *circleProgress;
@property (strong, nonatomic) IBOutlet UIView *viewCheckin;
@property (strong, nonatomic) IBOutlet UILabel *lblContent;

- (void) drawChart;

@end

