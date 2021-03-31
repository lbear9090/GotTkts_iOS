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

@class EventCell;

@protocol EventCellDelegate <NSObject>
//@required
@optional


- (void) onSales:(EventCell *) cell;
- (void) onEdit:(EventCell *) cell;
- (void) onView: (EventCell *) cell;
- (void) onCancel: (EventCell *) cell;

@end


@interface EventCell : UITableViewCell

@property (strong, nonatomic) id<EventCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *viewContent;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UIImageView *imgEvent;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
    
@end

