//
//  CreateEventTwoViewController.h
//  GotTkts
//
//  Created by Jorge on 10/23/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "SuperViewController.h"
#import "Event.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateEventTwoViewController : SuperViewController
@property (strong, nonatomic) Event *event;
@property (nonatomic) BOOL isEdit;
@end

NS_ASSUME_NONNULL_END
