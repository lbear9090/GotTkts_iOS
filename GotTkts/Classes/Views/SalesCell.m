//
//  FeedCell.m
//  OMG
//
//  Created by Vitaly's Team on 7/22/17.
//  Copyright © 2017 BrainyApps. All rights reserved.
//

#import "SalesCell.h"

@implementation SalesCell

- (IBAction)onCheckIn:(id)sender {
    if (self.delegate){
        [self.delegate onCheckIn:self];
    }
}

@end
