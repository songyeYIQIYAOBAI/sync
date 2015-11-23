//
//  BottleView.m
//
//  Created by lvming on 14-3-3.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import "cocos2d.h"
#import "BottleView.h"

@implementation BottleView

@synthesize followTrack;
@synthesize adjust;
@synthesize delegate;

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    if (backgroundColor != _backgroundColor) {
        [_backgroundColor release];
    }
    _backgroundColor = [backgroundColor retain];
    
    waterLayer.backgroundColor = _backgroundColor;
}

- (void)setColor:(UIColor*)color {
    if (color != _color) {
        [_color release];
    }
    _color = [color retain];
    
    waterLayer.waterColor = _color;
}

- (void)setBackground:(NSString*)backgroundName {
    if (backgroundName != _backgroundName) {
        [_backgroundName release];
    }
    _backgroundName = [backgroundName retain];
    
	waterLayer.backgroundName = _backgroundName;
}

- (void)setForeground:(NSString*)foregroundName {
	if(nil == foregroundView) {
		foregroundView = [[UIImageView alloc] initWithFrame:self.frame];
		[self addSubview:foregroundView];
	}
  	
    NSString* filename = nil;
//    CGFloat deviceHeight = [UIScreen mainScreen].bounds.size.height;
//    if(480.0f == deviceHeight) {
//        filename = [NSString stringWithFormat:@"%@@2x.png", foregroundName];
//    }else if(568.0f == deviceHeight) {
//        filename = [NSString stringWithFormat:@"%@-568h@2x.png", foregroundName];
//    }else if(667.0f == deviceHeight){
//        filename = [NSString stringWithFormat:@"%@-667h@2x.png", foregroundName];
//    }else if(736.0f == deviceHeight){
//        filename = [NSString stringWithFormat:@"%@-667h@2x.png", foregroundName];
//    }else {
        filename = [NSString stringWithFormat:@"%@@2x.png", foregroundName];
//    }
	foregroundView.image = [UIImage imageNamed:filename];
}

- (id)initWithFrame:(CGRect)frame {
    CGFloat factor = 2;//[UIScreen mainScreen].scale;//屏幕比例
    frame.origin = CGPointMake(frame.origin.x / factor, frame.origin.y / factor);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        followTrack = NO;
        
        _size = frame.size.width > frame.size.height ? frame.size.width * factor: frame.size.height * factor;
		[self loadWater];
    }
    return self;
}

- (void)dealloc {
    [_color release];
    [_backgroundColor release];
    [_backgroundName release];
    
    [foregroundView release];
    
    self.delegate = nil;
    
	[super dealloc];
}

- (void)setFullLevel:(int)fullLevel emptyLevel:(int)emptyLevel {
    _fullLevel = fullLevel;
    _emptyLevel = emptyLevel;
    waterLayer.fullLevel = _fullLevel;
    waterLayer.emptyLevel = _emptyLevel;
}

- (void)setInitVolume:(float)volume {
    _volume = volume;
	waterLayer.volume = _volume;
}

- (void)updateVolume:(float)volume completeBlock:(void(^)(void))callback {
    _volume = volume;
    [waterLayer updateVolume:_volume withDuration:2.0 withDelay:0 andCompleteBlock:callback];
    
    int offset = _size / 4;
    [waterLayer shakeWater:80 at:CGPointMake(offset, 0)];
    [waterLayer shakeWater:80 at:CGPointMake(_size - offset, 0)];
}

- (void)quickUpdateVolume:(float)volume completeBlock:(void(^)(void))callback {
    _volume = volume;
    [waterLayer updateVolume:_volume withDuration:0.2 withDelay:0 andCompleteBlock:callback];
}

- (void)updateToPeekThenVolume:(float)volume completePeekBlock:(void(^)(void))peekCallback completeBlock:(void(^)(void))callback {
    [waterLayer updateVolume:100 withDuration:1.5 withDelay:0 andCompleteBlock:^{
        if (nil != peekCallback) {
            peekCallback();
        }
        
        _volume = volume;
        [waterLayer updateVolume:volume withDuration:1.5 withDelay:0.2 andCompleteBlock:^{
            if (nil != callback) {
                callback();
            }
        }];
    }];
    
    int offset = _size / 4;
    [waterLayer shakeWater:80 at:CGPointMake(offset, 0)];
    [waterLayer shakeWater:80 at:CGPointMake(_size - offset, 0)];
}

- (void)rotateToAngle:(float)degree withSpeed:(double)speed {
	[waterLayer rotateToAngle:degree withSpeed:speed andAdjustBlock:adjust];
}

- (void)loadWater {
    CGRect glFrame = CGRectMake(self.frame.origin.x+1, self.frame.origin.y+1, self.frame.size.width-2, self.frame.size.height-2);
    glView = [EAGLView viewWithFrame:glFrame
                         pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
                         depthFormat:0						// GL_DEPTH_COMPONENT16_OES
              ];
    
    // water
    {
        if(! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink])
            [CCDirector setDirectorType:kCCDirectorTypeDefault];
        
        CCDirector* director = [CCDirector sharedDirector];
        
        // attach the openglView to the director
        [director setOpenGLView:glView];
        
        // Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
        if( ! [director enableRetinaDisplay:YES] )
            CCLOG(@"Retina Display Not supported");
        
        [director setDeviceOrientation:kCCDeviceOrientationPortrait];
        
        [director setAnimationInterval:1.0/60];
        [director setDisplayFPS:NO];
        
        // Default texture format for PNG/BMP/TIFF/JPEG/GIF images
        // It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
        // You can change this setting at any time.
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
        
        CCScene* scene = [CCScene node];
        waterLayer = [WaterLayer node];
        waterLayer.size = CGSizeMake(_size, _size);
        waterLayer.origin = CGPointMake(self.frame.size.width / 2, 0);
        [scene addChild:waterLayer];
        
        [[CCDirector sharedDirector] runWithScene:scene];
    }
    
    [self addSubview:glView];
    [self bringSubviewToFront:foregroundView];
}

- (void)reloadWater {
    [self loadWater];
    
    if (nil != _color) {
        waterLayer.waterColor = _color;
    }
    
    if (nil != _backgroundColor) {
        waterLayer.backgroundColor = _backgroundColor;
    }
    
    if (nil != _backgroundName) {
        waterLayer.backgroundName = _backgroundName;
    }
    
    waterLayer.fullLevel = _fullLevel;
    waterLayer.emptyLevel = _emptyLevel;
    waterLayer.volume = _volume;
}

- (void)unloadWater {
    [waterLayer stopAllActions];
    [[CCDirector sharedDirector] end];
    [glView removeFromSuperview];
}

- (void)startTraceMotion:(CMMotionManager*)motionManager {
	@try {
		_motionManager = motionManager;
		[_motionManager startDeviceMotionUpdates];
		
		keepTracking = YES;
        
        [self performSelectorInBackground:@selector(handleDeviceMotion) withObject:nil];
	}
	@catch (NSException *exception) {
		;
	}
}

- (void)stopTraceMotion {
	@try {
		keepTracking = NO;
		
		[_motionManager stopDeviceMotionUpdates];
	}
	@catch (NSException *exception) {
		;
	}
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent*)event{
	if (UIEventSubtypeMotionShake == motion) {
        int offset = _size / 4;
		[waterLayer shakeWater:120 at:CGPointMake(offset, 0)];
		[waterLayer shakeWater:120 at:CGPointMake(_size - offset, 0)];
	}
}

- (void)handleDeviceMotion {
	
	while (YES == keepTracking) {
		if (YES == followTrack && YES == _motionManager.deviceMotionActive) {
			double gravityX = _motionManager.deviceMotion.gravity.x;
			double gravityY = _motionManager.deviceMotion.gravity.y;
            double speed = _motionManager.deviceMotion.rotationRate.z;
//            NSLog(@"gravityX=%.2f, gravityY=%.2f, speed=%.2f", gravityX, gravityY, speed);
            
            double roll = _motionManager.deviceMotion.attitude.roll / M_PI * 180.0;
            double pitch = _motionManager.deviceMotion.attitude.pitch / M_PI * 180.0;
//            NSLog(@"roll=%.2f, pitch=%.2f", roll, pitch);
            
            if (10 > fabs(pitch) && 10 > fabs(roll)) {
//                NSLog(@"by pass!");
            } else {
                double xyTheta = atan2(gravityX, gravityY) / M_PI * 180.0;
//                NSLog(@"xyTheta=%.2f", xyTheta);
            
                if (0 < xyTheta) {
                    [waterLayer rotateToAngle:xyTheta - 180 withSpeed:speed andAdjustBlock:adjust];
                } else if (0 > xyTheta) {
                    [waterLayer rotateToAngle:xyTheta - 180 withSpeed:speed andAdjustBlock:adjust];
                }
                
                if(100 < 180 - abs(xyTheta)){
                    // 左右倾斜事件开始
                    if(nil != delegate && [delegate respondsToSelector:@selector(bottleLeanAppear:)]){
                        dispatch_async(dispatch_get_main_queue(), ^ {
                            [delegate bottleLeanAppear:xyTheta];
                        });
                    }
                }else if(90 > 180 - abs(xyTheta)){
                    // 左右倾斜事件结束
                    if(nil != delegate && [delegate respondsToSelector:@selector(bottleLeanDisappear:)]){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [delegate bottleLeanDisappear:xyTheta];
                        });
                    }
                }
            }
		}
		
		usleep(30 * 1000);
	}
}

@end
