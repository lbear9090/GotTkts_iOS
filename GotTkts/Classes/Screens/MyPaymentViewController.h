//
//  MyPaymentViewController.h
//  GotTkts
//
//  Created by Jorge on 10/22/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "SuperViewController.h"
#import "Book.h"
#import "Event.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyPaymentViewController : SuperViewController

@property (strong, nonatomic) Book *bookData;
@property (strong, nonatomic) Event *event;

@end

NS_ASSUME_NONNULL_END
