//
//  RTSSAudioPlayer.h
//  RTSS
//
//  Created by shengyp on 14/12/11.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface RTSSAudioPlayer : NSObject

@property(nonatomic, readonly)AVAudioPlayer*            avAudioPlayer;

- (instancetype)initWithURL:(NSURL*)fileUrl;

- (BOOL)play;

- (void)pause;

- (void)stop;

@end
