//
//  BottleView.h
//
//  Created by lvming on 14-3-3.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "WaterLayer.h"

@protocol BottleViewDelegate;

@interface BottleView : UIView {
	UIImageView* foregroundView;
    EAGLView* glView;
	WaterLayer* waterLayer;
    
    UIColor* _color;
    UIColor* _backgroundColor;
    NSString* _backgroundName;
    
    int _size;
    int _fullLevel;
    int _emptyLevel;
    float _volume;
	
	CMMotionManager* _motionManager;
    BOOL keepTracking;
	BOOL followTrack;
	
	CGPoint(^adjust)(int, float);
}

@property (nonatomic, retain, setter = setColor:) UIColor* color;
@property (nonatomic, retain, setter = setBackgroundColor:) UIColor* backgroundColor;
@property (nonatomic, retain, setter = setBackground:) NSString* backgroundName;
@property (nonatomic, assign, setter = setForeground:) NSString* foregroundName;

@property (nonatomic, assign) BOOL followTrack;
@property (nonatomic, assign) CGPoint(^adjust)(int, float);

@property (nonatomic, assign) id<BottleViewDelegate> delegate;

- (void)setFullLevel:(int)fullLevel emptyLevel:(int)emptyLevel;
- (void)setInitVolume:(float)volume;

- (void)updateVolume:(float)volume completeBlock:(void(^)(void))callback;
- (void)quickUpdateVolume:(float)volume completeBlock:(void(^)(void))callback;
- (void)updateToPeekThenVolume:(float)volume completePeekBlock:(void(^)(void))peekCallback completeBlock:(void(^)(void))callback;

- (void)rotateToAngle:(float)degree withSpeed:(double)speed;

- (void)reloadWater;
- (void)unloadWater;

- (void)startTraceMotion:(CMMotionManager*)motionManager;
- (void)stopTraceMotion;

@end

@protocol BottleViewDelegate <NSObject>

@optional
- (void)bottleLeanAppear:(double)xyTheta;

- (void)bottleLeanDisappear:(double)xyTheta;


@end
