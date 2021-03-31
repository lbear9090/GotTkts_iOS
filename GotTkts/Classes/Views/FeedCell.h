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
#import "HCSStarRatingView.h"
#import "CircleImageView.h"

@class FeedCell;

@protocol FeedCellDelegate <NSObject>
//@required
@optional
- (void)onUpvoteFeed:(FeedCell *)cell;
@end


@interface FeedCell : UITableViewCell

@property (strong, nonatomic) id<FeedCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UITextField *txtPrice;
@property (strong, nonatomic) IBOutlet UITextField *txtQty;

@end

