//
//  TicketQRViewController.h
//  GotTkts
//
//  Created by Jorge on 10/27/18.
//  Copyright © 2018 Jorge. All rights reserved.
//

#import "SuperViewController.h"
#import "TicketOrdered.h"

NS_ASSUME_NONNULL_BEGIN

@interface TicketQRViewController : SuperViewController
@property (strong, nonatomic) TicketOrdered *ticket;
@end

NS_ASSUME_NONNULL_END
