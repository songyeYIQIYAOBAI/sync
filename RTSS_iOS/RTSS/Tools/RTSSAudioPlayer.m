//
//  RTSSAudioPlayer.m
//  RTSS
//
//  Created by shengyp on 14/12/11.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "RTSSAudioPlayer.h"

@interface RTSSAudioPlayer()


@end

@implementation RTSSAudioPlayer
@synthesize avAudioPlayer;

- (void)dealloc{
    [avAudioPlayer release];
    
    [super dealloc];
}

- (instancetype)initWithURL:(NSURL*)fileUrl{
    self = [super init];
    if(self){
        if(!TARGET_IPHONE_SIMULATOR){
            if(nil != fileUrl){
                avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:NULL];
                avAudioPlayer.volume = 1.0;
                [avAudioPlayer prepareToPlay];
            }
        }
    }
    return self;
}

- (BOOL)play{
    if(!TARGET_IPHONE_SIMULATOR){
        return [avAudioPlayer play];
    }
    return NO;
}

- (void)pause{
    if(!TARGET_IPHONE_SIMULATOR){
        [avAudioPlayer pause];
    }
}

- (void)stop{
    if(!TARGET_IPHONE_SIMULATOR){
        [avAudioPlayer stop];
    }
}

@end
