//
//  AddTicketsViewController.h
//  GotTkts
//
//  Created by Jorge Siu on 11/21/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "SuperViewController.h"
#import "Event.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddTicketsViewController : SuperViewController
@property (strong, nonatomic) Event *event;
@end

NS_ASSUME_NONNULL_END
