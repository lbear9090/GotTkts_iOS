//
//  AppStateManager.m
//  Partner
//
//  Created by star on 12/8/15.
//  Copyright (c) 2015 zapporoo. All rights reserved.
//

#import "AppStateManager.h"
#import <AVFoundation/AVFoundation.h>


#define SOUND_VOLUME    1.0
#define INCOMING_SOUND  @"incoming_call_ring.wav"
#define OUTGOING_SOUND  @"outgoing_call_ring.wav"

static AppStateManager *sharedInstance = nil;

@interface AppStateManager() <AVAudioPlayerDelegate>
{
    AVAudioPlayer *audioPlayer;
}
@end

@implementation AppStateManager

+ (AppStateManager *)sharedInstance {
    
    if (!sharedInstance) {
        sharedInstance = [[AppStateManager alloc] init];
        sharedInstance.alertCount = 0;
        sharedInstance.chatRoomId = @"";
        
        // DindinSpins
        sharedInstance.price_bottom = -1;
        sharedInstance.price_top = -1;
        sharedInstance.distance_bottom = -1;
        sharedInstance.distance_top = -1;
        sharedInstance.rate_bottom = -1;
        sharedInstance.rate_top = -1;
        sharedInstance.is_filter = false;
    }
    
    return sharedInstance;
}

- (void)playIncomingSound {
    if (audioPlayer) {
        [audioPlayer stop];
        audioPlayer = nil;
    }
    NSURL *urlPath = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], INCOMING_SOUND]];
    NSError *err = nil;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:urlPath error:&err];
    audioPlayer.numberOfLoops = -1;
    audioPlayer.delegate = self;
    [audioPlayer setVolume:SOUND_VOLUME];
    [audioPlayer play];
}

- (void)playOutgoingSound {
    if (audioPlayer) {
        [audioPlayer stop];
        audioPlayer = nil;
    }
    NSURL *urlPath = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], OUTGOING_SOUND]];
    NSError *err = nil;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:urlPath error:&err];
    audioPlayer.numberOfLoops = -1;
    audioPlayer.delegate = self;
    [audioPlayer setVolume:SOUND_VOLUME];
    [audioPlayer play];
}

- (void)stopSound {
    if (audioPlayer) {
        [audioPlayer stop];
        audioPlayer = nil;
    }
}

- (void)resetAlertCount {
    self.alertCount = 0;
}

@end
