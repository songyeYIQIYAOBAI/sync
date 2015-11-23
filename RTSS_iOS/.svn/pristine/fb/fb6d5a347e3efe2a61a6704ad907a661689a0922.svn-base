//
//  RTSSPopPasswordView.m
//  RTSS
//
//  Created by 蔡杰 on 14-11-5.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "RTSSPopPasswordView.h"
#import "PasswordInputView.h"
#import "SJBKeyboardView.h"
#import "RTSSAppDefine.h"

#define kRTSSEdge   20.0f
#define kRTSSPassWordHeight  180.0f
#define kRTSSPassWordWidth   280.0f
#define  kRTSSKeyboardHeight  280

@interface RTSSPopPasswordView ()<SJBKeyboardDelegate>{
    
    BOOL _leftLeave;
    
}

@property(nonatomic,retain)PasswordInputView *passwordInput;

@property (nonatomic, retain) UIView *backImageView;

@property(nonatomic,retain)SJBKeyboardView *keyboardView;


@end


@implementation RTSSPopPasswordView


-(void)dealloc{
    if (_passwordInput)   [_passwordInput release];
    if (_backImageView)   [_backImageView release];
    if (_keyboardView)    [_keyboardView  release];
    [super dealloc];
}
#pragma mark --Setter

-(PasswordInputView *)passwordInput{
    
    if (!_passwordInput) {
        _passwordInput = [[PasswordInputView alloc]initWithFrame:self.bounds];
        _passwordInput.backgroundColor = [UIColor whiteColor];
        _passwordInput.cancelBlock = ^(){
        _leftLeave = YES;
        [self dismiss];
        };

    }
    return _passwordInput;
    
}

-(SJBKeyboardView *)keyboardView{
    
    if (!_keyboardView) {
        _keyboardView = [[SJBKeyboardView alloc]initWithFrame:CGRectMake(0, PHONE_UISCREEN_HEIGHT+kRTSSKeyboardHeight, PHONE_UISCREEN_WIDTH, kRTSSKeyboardHeight) viewType:SJBKeyboardViewNumber];
        _keyboardView.delegate = self;

    }
    return _keyboardView;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        //[self createUI];
    }
    return self;
}

-(void)createUI{
    [self addSubview:self.passwordInput];
}



#pragma mark --Public
-(void)show{
    UIViewController *topVC = [self appRootViewController];
        self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kRTSSPassWordWidth) * 0.5, kRTSSEdge+10,kRTSSPassWordWidth, kRTSSPassWordHeight);
    [self createUI];
    [topVC.view addSubview:self];
}

- (void)dismiss{
    [self removeFromSuperview];
}


#pragma mark --Helper
- (UIViewController *)appRootViewController{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];
    
    if (!self.backImageView) {
        self.backImageView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        self.backImageView.backgroundColor = [UIColor blackColor];
        self.backImageView.alpha = 0.6f;
        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backImageView.userInteractionEnabled = YES;
    }
    [topVC.view addSubview:self.backImageView];
    
    self.transform = CGAffineTransformMakeRotation(-M_1_PI / 2);
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kRTSSPassWordWidth) * 0.5, (CGRectGetHeight(topVC.view.bounds) - kRTSSPassWordWidth) * 0.3, kRTSSPassWordWidth , kRTSSPassWordHeight);
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
        self.frame = afterFrame;
    } completion:^(BOOL finished) {
     [self popKeyBoard];
        
    }];
    [super willMoveToSuperview:newSuperview];
}

- (void)removeFromSuperview{
    [self.backImageView removeFromSuperview];
    self.backImageView = nil;
    UIViewController *topVC = [self appRootViewController];
    
  CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - 20) * 0.5, CGRectGetHeight(topVC.view.bounds), 20, 20);
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = afterFrame;
        if (_leftLeave) {
            self.transform = CGAffineTransformMakeRotation(-M_1_PI / 1.5);
        }else {
            self.transform = CGAffineTransformMakeRotation(M_1_PI / 1.5);
        }
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

-(void)popKeyBoard{
    [self.backImageView addSubview:self.keyboardView];
    [UIView animateWithDuration:0.35f animations:^{
        CGRect frame = self.keyboardView.frame;
        frame.origin.y = PHONE_UISCREEN_HEIGHT - kRTSSKeyboardHeight+64;
        self.keyboardView.frame = frame;

    }];
}

-(void)didNumberKeyPressed:(NSString *)numberString{
    [self.passwordInput updateNumber:numberString];
}

-(void)didBackspaceKeyPressed{
    [self.passwordInput deleteNumber];
}



@end
