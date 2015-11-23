//
//  WaterLayer.m
//
//  Created by lvming on 12-12-26.
//  Copyright (c) 2012年 lvming. All rights reserved.
//

#import "cocos2d.h"
#import "WaterLayer.h"

@implementation WaterLayer

@synthesize fullLevel=_fullLevel, emptyLevel=_emptyLevel;

- (void)setSize:(CGSize)size {
	waveNode.width = size.width;
	waveNode.depth = size.height;
	waveNode.contentSize = size;
}

- (void)setOrigin:(CGPoint)origin {
    _origin = origin;
	waveNode.position = _origin;
}

- (void)setVolume:(int)volume {
	_volume = volume;
	_origin = CGPointMake(_origin.x, (_fullLevel - _emptyLevel) * _volume / 100.0 + _emptyLevel);
    waveNode.position = _origin;
}

- (void)setWaterColor:(UIColor*)color {
    const CGFloat* components = CGColorGetComponents(color.CGColor);
    waveNode.waterColorRed = components[0];
    waveNode.waterColorGreen = components[1];
    waveNode.waterColorBlue = components[2];
    waveNode.waterAlpha = components[3];
}

- (void)setBackgroundColor:(UIColor*)backgroundColor {
    if (nil != backgroundSprite) {
		[self removeChild:backgroundSprite cleanup:YES];
	}
    
    backgroundSprite = [CCSprite node];
    [backgroundSprite setTextureRect:CGRectMake(0, 0, waveNode.width, waveNode.depth)];
    
    const CGFloat* components = CGColorGetComponents(backgroundColor.CGColor);
    [backgroundSprite setOpacity:255 * components[3]];
    ccColor3B color = {255 * components[0], 255 * components[1], 255 * components[2]};
    [backgroundSprite setColor:color];
    
    backgroundSprite.position = CGPointMake(_origin.x, 0);
	backgroundSprite.anchorPoint = CGPointMake(0.5, 0);
    
	[self addChild:backgroundSprite];
	[self reorderChild:backgroundSprite z:0];
}

- (void)setBackground:(NSString*)backgroundName {
	if (nil != backgroundSprite) {
		[self removeChild:backgroundSprite cleanup:YES];
	}
    
    NSString* filename = nil;
    CGFloat deviceHeight = [UIScreen mainScreen].bounds.size.height;
    if(480.0f == deviceHeight) {
        filename = [NSString stringWithFormat:@"%@@2x.png", backgroundName];
    }else if (568.0f == deviceHeight) {
        filename = [NSString stringWithFormat:@"%@-568h@2x.png", backgroundName];
    }else if (667.0f == deviceHeight) {
        filename = [NSString stringWithFormat:@"%@-667h@2x.png", backgroundName];
    }else if(736.0f == deviceHeight){
        filename = [NSString stringWithFormat:@"%@-667h@2x.png", backgroundName];
    }else{
        filename = [NSString stringWithFormat:@"%@@2x.png", backgroundName];
    }
	
	backgroundSprite = [CCSprite spriteWithFile:filename];
	backgroundSprite.position = CGPointMake(_origin.x, 0);
	backgroundSprite.anchorPoint = CGPointMake(0.5, 0);
    
	[self addChild:backgroundSprite];
	[self reorderChild:backgroundSprite z:0];
}

- (id)init {
	if (self = [super init]) {
		self.isTouchEnabled = NO;
		
		waveNode = [[WaveNode alloc] init];
		waveNode.anchorPoint = CGPointMake(0.5, 1.0);
		[self addChild:waveNode];
		[self reorderChild:waveNode z:10];
	}
	
	return self;
}

- (void)dealloc {
	[waveNode release];
	
	[super dealloc];
}

- (void)stopAllActions {
	[waveNode stopAllActions];
	
	[super stopAllActions];
}

- (void)updateVolume:(float)volume withDuration:(float)duration withDelay:(float)delay andCompleteBlock:(void(^)(void))callback {
    _volume = volume;
    _origin = CGPointMake(_origin.x, (_fullLevel - _emptyLevel) * _volume / 100.0 + _emptyLevel);
    
    NSMutableArray* actions = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (0 < delay) {
        CCDelayTime* delayAction = [CCDelayTime actionWithDuration:delay];
        [actions addObject:delayAction];
    }
    
    CCMoveTo* moveAction = [CCMoveTo actionWithDuration:duration position:_origin];
    [actions addObject:moveAction];

    if (nil != callback) {
        CCCallBlock* callAction = [CCCallBlock actionWithBlock:callback];
        [actions addObject:callAction];
    }
    
    CCSequence* sequenceAction = [CCSequence actionsWithArray:actions];
    [actions release];
    
	[waveNode runAction:sequenceAction];
}

- (void)rotateToAngle:(float)degree withSpeed:(double)speed andAdjustBlock:(CGPoint(^)(int, float))adjust {
	if (0 < _volume) {
		waveNode.visible = YES;
	} else {
		waveNode.visible = NO;
	}
	
	if (nil != adjust) {
		CGPoint offset = adjust(_volume, degree);
		waveNode.position = CGPointMake(_origin.x + offset.x, _origin.y + offset.y);
	}

	float duration = 0.2;
	CCRotateTo* rotateAction = [CCRotateTo actionWithDuration:duration angle:degree];
	[waveNode runAction:rotateAction];
	
    float amplitude = 10 * fabs(speed);
	int offset = waveNode.width / 18;
	if (0 < speed) {
		[self shakeWater:amplitude at:CGPointMake(offset, 0)];
	} else {
		[self shakeWater:amplitude at:CGPointMake(waveNode.width - offset, 0)];
	}
}

- (void)shakeWater:(float)amplitude at:(CGPoint)point {
	[waveNode makeSplashAt:point.x withAmplitude:amplitude];
}

-(void)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	[waveNode makeSplashAt:[waveNode convertTouchToNodeSpace:[touches anyObject]].x withAmplitude:20.0];
}


@end
