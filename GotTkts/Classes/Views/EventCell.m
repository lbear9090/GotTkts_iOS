//
//  FeedCell.m
//  OMG
//
//  Created by Vitaly's Team on 7/22/17.
//  Copyright © 2017 BrainyApps. All rights reserved.
//

#import "EventCell.h"

@implementation EventCell


- (IBAction)onSales:(id)sender {
    if (self.delegate){
        [self.delegate onSales:self];
    }
}
- (IBAction)onEdit:(id)sender {
    if (self.delegate){
        [self.delegate onEdit:self];
    }
}
- (IBAction)onView:(id)sender {
    if (self.delegate){
        [self.delegate onView:self];
    }
}

- (IBAction)onCancel:(id)sender {
    if (self.delegate){
        [self.delegate onCancel:self];
    }
}
    @end
