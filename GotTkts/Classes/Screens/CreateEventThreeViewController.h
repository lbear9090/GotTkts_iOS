//
//  CreateEventThreeViewController.h
//  GotTkts
//
//  Created by Jorge on 10/23/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "SuperViewController.h"
#import "Event.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateEventThreeViewController : SuperViewController
@property (strong, nonatomic) Event *event;
@property (nonatomic) BOOL isEdit;
@property (strong, nonatomic) NSMutableArray *paidArray;
@property (strong, nonatomic) NSMutableArray *freeArray;
@property (strong, nonatomic) NSMutableArray *planArray;
@end

NS_ASSUME_NONNULL_END
