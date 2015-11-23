//
//  LoadingViewController.h
//  RTSS
//
//  Created by shengyp on 14/11/15.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "BasicViewController.h"

@protocol LoadingImageViewDelegate <NSObject>

// 弹跳完成
- (void)bounceAnimationCompletion;
// 淡入完成
- (void)dissolveAnimationCompletion;
// logo谈入完成
- (void)ballDissolveAnimationCompletion;
// 移动到logo完成
- (void)jumpToLogoAnimationCompletion;

@end

@interface LoadingImageView : UIView

@property(nonatomic, readonly) UIImageView*         imageView;
@property(nonatomic, readonly) UIView*              promptView;
@property(nonatomic, readonly) UILabel*             versionLabel;

@property(nonatomic, assign) id<LoadingImageViewDelegate> delegate;

- (void)startBounceAnimation;

- (void)dissolveAnimation;

@end


@class PortraitImageView;
@interface LoadingBallView : UIView

@property(nonatomic, retain) PortraitImageView*             portraitView;

@property(nonatomic, retain) UIButton*                      logoButton;

@property(nonatomic, assign) id<LoadingImageViewDelegate>   delegate;

- (void)initAnimation;

- (void)ballDissolveAnimation;

- (void)jumpToLogoAnimation;

- (void)ballResetAnimation;

@end

@interface LoadingViewController : BasicViewController

-(void)resetBallAnimation;

@end
