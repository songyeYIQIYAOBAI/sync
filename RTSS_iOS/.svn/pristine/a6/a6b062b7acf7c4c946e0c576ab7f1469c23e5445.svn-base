//
//  PatternPasswordViewController.h
//  RTSS
//
//  Created by baisw on 14/10/23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BasicViewController.h"
#import "PatternUnlockView.h"

typedef NS_ENUM(NSInteger, HandDetectorTestFrom){
    RTSSPatternHandFromSetting,
    RTSSPatternHandFromLogin
};

@protocol PatternHandViewDelegate <NSObject>

@optional
-(void)changePatternHandPasswd;

@end

@class PatternMiniPathView;
@interface PatternPasswordViewController : BasicViewController <UnLockViewDelegate>
{
    UILabel*                    tiplabel;
    PatternMiniPathView *       gesturesPathView;
    int                         drawCount;
}

@property (nonatomic, assign) HandDetectorTestFrom fromType;
@property (nonatomic, retain) NSString * passwd;
@property (nonatomic, assign) id<PatternHandViewDelegate> delegate;

@end