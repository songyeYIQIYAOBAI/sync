//
//  WaterLayer.h
//
//  Created by lvming on 12-12-26.
//  Copyright (c) 2012年 lvming. All rights reserved.
//

#import "cocos2d.h"
#import "WaveNode.h"

@interface WaterLayer : CCLayer {
	CCSprite* backgroundSprite;
	WaveNode* waveNode;
	
    CGPoint _origin;
	int _fullLevel;
    int _emptyLevel;
	int _volume;
}

@property (nonatomic, assign, setter = setSize:) CGSize size;
@property (nonatomic, assign, setter = setOrigin:) CGPoint origin;
@property (nonatomic, assign) int fullLevel;
@property (nonatomic, assign) int emptyLevel;
@property (nonatomic, assign, setter = setVolume:) int volume;

@property (nonatomic, assign, setter = setWaterColor:) UIColor* waterColor;
@property (nonatomic, assign, setter = setBackgroundColor:) UIColor* backgroundColor;
@property (nonatomic, assign, setter = setBackground:) NSString* backgroundName;

- (void)updateVolume:(float)volume withDuration:(float)duration withDelay:(float)delay andCompleteBlock:(void(^)(void))callback;
- (void)rotateToAngle:(float)degree withSpeed:(double)speed andAdjustBlock:(CGPoint(^)(int, float))adjust;
- (void)shakeWater:(float)amplitude at:(CGPoint)point;

@end
