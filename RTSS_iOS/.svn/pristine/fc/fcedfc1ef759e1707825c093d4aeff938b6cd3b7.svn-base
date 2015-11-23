//
//  PatternPasswordViewController.m
//  RTSS
//
//  Created by shengyp on 14/10/23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "PatternPasswordViewController.h"
#import "PatternUnlockView.h"
#import "PortraitImageView.h"
#import "CommonUtils.h"
#import "PatternMiniPathView.h"
#import "AppDelegate.h"
#import "RTSSAppStyle.h"
#import "Settings.h"

@interface PatternPasswordViewController ()

@end

@implementation PatternPasswordViewController
@synthesize passwd;
@synthesize fromType;

-(void)dealloc
{
    [gesturesPathView release];
    
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        drawCount = 0;
        fromType = RTSSPatternHandFromSetting;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadView
{
    [super loadView];
    [self layoutBackgroundView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Pattern";
}

-(void)layoutBackgroundView
{
    RTSSAppStyle * colorMgr = [RTSSAppStyle currentAppStyle];
    
    UIView *navBarView = [self addNavigationBarView:NSLocalizedString(@"Transform_Title", nil) bgColor:[[RTSSAppStyle currentAppStyle] navigationBarColor] separator:NO];
    [self.view addSubview:navBarView];
    
    CGFloat y = CGRectGetMaxY(navBarView.frame);

    self.view.backgroundColor = colorMgr.navigationBarColor;
    
    tiplabel = [CommonUtils labelWithFrame:CGRectMake(0, 70 + y, PHONE_UISCREEN_WIDTH, 30) text:@"Draw an unlock pattern" textColor:colorMgr.textSubordinateColor textFont:[UIFont systemFontOfSize:15.0] tag:0];
    tiplabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tiplabel];
    
    PatternUnlockView * unLockView = [[PatternUnlockView alloc]initWithFrame:CGRectMake(PHONE_UISCREEN_WIDTH/2 - 150, 80+y, 300, 300)];
    unLockView.backgroundColor = [UIColor clearColor];
    unLockView.delegate = self;
    [self.view addSubview:unLockView];
    [unLockView release];

    if (RTSSPatternHandFromLogin == fromType) {
        
        UIImage * imageHead = [UIImage imageNamed:@"friends_default_icon.png"];
        PortraitImageView* headImageView = [[PortraitImageView alloc] initWithFrame:CGRectMake(PHONE_UISCREEN_WIDTH/2 - 60/2,8+y,60,60) image:imageHead borderColor:[UIColor lightGrayColor] borderWidth:2.0];
        [self.view addSubview:headImageView];
        [headImageView release];

        UIButton * forgetPasswdBtn = [CommonUtils buttonWithType:UIButtonTypeCustom
                                                           frame:CGRectMake(PHONE_UISCREEN_WIDTH/2 - 133/2, 370+y, 133, 35)
                                                           title:@"forget password"
                                                   bgImageNormal:nil
                                              bgImageHighlighted:nil
                                                 bgImageSelected:nil
                                                       addTarget:self
                                                          action:@selector(forgetPatternGesture)
                                                             tag:0];
        [forgetPasswdBtn setTitleColor:[CommonUtils colorWithHexString:@"#78797B"] forState:UIControlStateNormal];
        forgetPasswdBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.view addSubview:forgetPasswdBtn];
        
    }else if(RTSSPatternHandFromSetting == fromType){
        
        gesturesPathView = [[PatternMiniPathView alloc] initWithFrame:CGRectMake(PHONE_UISCREEN_WIDTH/2 - 25,15+y,50,50)];
        gesturesPathView.backgroundColor = [CommonUtils colorWithHexString:@"#32353a"];
        gesturesPathView.layer.cornerRadius = 4;//设置那个圆角的有多圆
        gesturesPathView.layer.masksToBounds = YES;
        [self.view addSubview:gesturesPathView];
        
    }
}

-(void)forgetPatternGesture
{
    [[AppDelegate shareAppDelegate] startRTSSViewControllerType:RTSSViewControllerTypeLogin];
}

#pragma UnLockViewDelegate implement
-(BOOL)LockViewDidClick:(PatternUnlockView *)lockView andPwd:(NSString *)pwd
{
    BOOL result = NO;
    if (pwd.length <3) {
        return result;
    }

    if (RTSSPatternHandFromLogin == fromType) {
        NSString * storePasswd =  [[Settings standardSettings] getPatternGesturePassword];
        if ([storePasswd isEqualToString:pwd]) {
            result = YES;
            [[AppDelegate shareAppDelegate] startRTSSViewControllerType:RTSSViewControllerTypeHome];
        }else{
            result = NO;
            [self shakeAnimationForView:tiplabel];
        }
    }else if (RTSSPatternHandFromSetting == fromType) {
        drawCount ++;
        if (drawCount == 1) {
            tiplabel.text = @"Draw pattern again to confirm";
            self.passwd = pwd;
        }else if (drawCount == 2) {
            if ([self.passwd isEqualToString:pwd]) {
                result = YES;
                drawCount = 0;
                tiplabel.text = @"Success";
                [[Settings standardSettings] setPatternGesturePassword:self.passwd];
                [self performSelector:@selector(popHandViewController) withObject:nil afterDelay:0.3f];
            }else{
                result = NO;
                drawCount --;
                [self shakeAnimationForView:tiplabel];
            }
        }
        NSLog(@"%@",pwd);
    }
    return result;
}

-(void)drawPatternHandPath:(NSMutableArray *)tags isFinished:(BOOL)isfinished
{
    [gesturesPathView drawGesturesPath:tags isFinished:isfinished];
}

#pragma end delegate
-(void)popHandViewController
{
    if([self.delegate respondsToSelector:@selector(changePatternHandPasswd)]){
        [self.delegate changePatternHandPasswd];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - animation event
- (void)shakeAnimationForView:(UIView *) view
{
    //获取到当前的View
    CALayer *viewLayer = view.layer;
    //获取当前View的位置
    CGPoint position = viewLayer.position;
    //移动的两个终点位置
    CGPoint x = CGPointMake(position.x + 10, position.y);
    CGPoint y = CGPointMake(position.x - 10, position.y);
    //设置动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    //设置运动形式
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    //设置开始位置
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    //设置结束位置
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    //设置自动反转
    [animation setAutoreverses:YES];
    //设置时间
    [animation setDuration:.06];
    //设置次数
    [animation setRepeatCount:3];
    //添加上动画
    [viewLayer addAnimation:animation forKey:nil];
}

@end
