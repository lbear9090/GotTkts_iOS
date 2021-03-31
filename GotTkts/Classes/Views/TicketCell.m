//
//  FeedCell.m
//  OMG
//
//  Created by Vitaly's Team on 7/22/17.
//  Copyright © 2017 BrainyApps. All rights reserved.
//

#import "TicketCell.h"

@implementation TicketCell

- (IBAction)onDisplayTicket:(id)sender {
    if (self.delegate){
        [self.delegate onDisplayTicket:self];
    }
}

@end
