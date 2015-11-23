//
//  HomeBottleView.m
//  RTSS
//
//  Created by shengyp on 14/10/29.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "HomeBottleView.h"
#import "QuadCurveMenu.h"
#import "QuadCurveMenuItem.h"
#import "PortraitImageView.h"
#import "BottleView.h"
#import "LabelNumberJump.h"

#import "CommonUtils.h"
#import "DateUtils.h"
#import "ImageUtils.h"
#import "RTSSAppStyle.h"
#import "RTSSAppDefine.h"
#import "RTSSAudioPlayer.h"

#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

#define __BOTTLE_FULLLEVEL_IPHONE4X 160
#define __BOTTLE_EMPTYLEVEL_IPHONE4X 4

#define __BOTTLE_FULLLEVEL_IPHONE5X 160
#define __BOTTLE_EMPTYLEVEL_IPHONE5X 4

#define __BOTTLE_FULLLEVEL_IPHONE6X 160
#define __BOTTLE_EMPTYLEVEL_IPHONE6X 4

#define __BOTTLE_FULLLEVEL_IPHONE6PX 160
#define __BOTTLE_EMPTYLEVEL_IPHONE6PX 4


@implementation HomeBottleMarkView
@synthesize currentSourceNameLabel,currentSourceIdLabel,currentRemainingLabel,currentRemainingValueLabel;

- (void)dealloc{
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutContentView];
    }
    return self;
}

- (void)layoutContentView{
    // ==
    currentSourceNameLabel = [CommonUtils labelWithFrame:CGRectMake(0, 0, self.bounds.size.width, 15) text:@"" textColor:[RTSSAppStyle currentAppStyle].textSubordinateColor textFont:[RTSSAppStyle getRTSSFontWithSize:13.0] tag:0];
    currentSourceNameLabel.textAlignment = NSTextAlignmentLeft;
    currentSourceNameLabel.text = @"";
    [self addSubview:currentSourceNameLabel];
    
    // ==
    currentSourceIdLabel = [CommonUtils labelWithFrame:CGRectMake(0, CGRectGetMaxY(currentSourceNameLabel.frame), self.bounds.size.width, 15) text:@"" textColor:[RTSSAppStyle currentAppStyle].textMajorColor textFont:[RTSSAppStyle getRTSSFontWithSize:14.0] tag:0];
    currentSourceIdLabel.textAlignment = NSTextAlignmentLeft;
    currentSourceIdLabel.text = @"";
    currentSourceIdLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:currentSourceIdLabel];
    
    // ==
    currentRemainingLabel = [CommonUtils labelWithFrame:CGRectMake(0, CGRectGetMaxY(currentSourceIdLabel.frame)+5, self.bounds.size.width, 15) text:@"" textColor:[RTSSAppStyle currentAppStyle].textSubordinateColor textFont:[RTSSAppStyle getRTSSFontWithSize:13.0] tag:0];
    currentRemainingLabel.textAlignment = NSTextAlignmentLeft;
    currentRemainingLabel.text = @"";
    [self addSubview:currentRemainingLabel];
    
    // ==
    currentRemainingValueLabel = [[LabelNumberJump alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(currentRemainingLabel.frame), self.bounds.size.width, 25)];
    currentRemainingValueLabel.unitString = @"";
    currentRemainingValueLabel.numberOfLines = 1;
    currentRemainingValueLabel.textAlignment = NSTextAlignmentLeft;
    currentRemainingValueLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    currentRemainingValueLabel.font = [RTSSAppStyle getRTSSFontWithSize:14.0];
    currentRemainingValueLabel.adjustsFontSizeToFitWidth = YES;
    currentRemainingValueLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [self addSubview:currentRemainingValueLabel];
}

@end

#define TransferNumberLabelFont     [RTSSAppStyle getRTSSFontWithSize:15.0]
#define TransferTitleLabelFont      [RTSSAppStyle getRTSSFontWithSize:15.0]

@interface TransferRuleView()

@property(nonatomic, retain) UIImage*               editedImage;
@property(nonatomic, retain) NSString*              titleText;

@end

@implementation TransferRuleView
@synthesize actionButton,editedImageView,transferTitleLabel,transferNumberLabel,editedImage,titleText;

- (void)dealloc
{
    [editedImage release];
    [titleText release];
    
    [actionButton release];
    [editedImageView release];
    
    [transferNumberLabel release];
    [transferTitleLabel release];
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        actionButton = [[UIButton alloc] initWithFrame:self.bounds];
        actionButton.backgroundColor = [UIColor clearColor];
        
        editedImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        editedImageView.backgroundColor = [UIColor clearColor];
        
        transferNumberLabel = [[CommonUtils labelWithFrame:CGRectZero text:@"" textColor:[RTSSAppStyle currentAppStyle].pouringWatterColor textFont:TransferNumberLabelFont tag:10] retain];
        transferNumberLabel.backgroundColor = [UIColor clearColor];
        
        transferTitleLabel = [[CommonUtils labelWithFrame:CGRectZero text:@"" textColor:[RTSSAppStyle currentAppStyle].textSubordinateColor textFont:TransferTitleLabelFont tag:11] retain];
        transferTitleLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setTransferRuleNumber:(NSString*)number editedImage:(UIImage*)edited title:(NSString*)title{
    if([CommonUtils objectIsValid:number] && [CommonUtils objectIsValid:title] && nil != edited){
        self.editedImage = edited;
        self.titleText = title;
        
        // ==
        CGSize size = CGSizeMake(MAXFLOAT, self.bounds.size.height);
        
        UIFont* numberFont = TransferNumberLabelFont;
        NSDictionary* numberDic = [NSDictionary dictionaryWithObjectsAndKeys:numberFont,NSFontAttributeName, nil];
        CGSize numberSize = [number boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:numberDic context:nil].size;
        
        UIFont* titleFont = TransferTitleLabelFont;
        NSDictionary* titleDic = [NSDictionary dictionaryWithObjectsAndKeys:titleFont,NSFontAttributeName, nil];
        CGSize titleSize = [title boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:titleDic context:nil].size;
        
        CGFloat numberX = (self.bounds.size.width-numberSize.width-titleSize.width-edited.size.width)/2;
        
        CGRect numberRect = CGRectMake(numberX, 0, numberSize.width, self.bounds.size.height);
        
        CGRect editedRect = CGRectMake(CGRectGetMaxX(numberRect)+3, (self.bounds.size.height-edited.size.height)/2, edited.size.width, edited.size.height);
        
        CGRect titleRect = CGRectMake(CGRectGetMaxX(editedRect)+5, 0, titleSize.width, self.bounds.size.height);

        // ==
        transferNumberLabel.frame = numberRect;
        transferNumberLabel.text = number;
        // ==
        editedImageView.frame = editedRect;
        editedImageView.image = edited;
        // ==
        transferTitleLabel.frame = titleRect;
        transferTitleLabel.text = title;
        
        if(nil == [transferNumberLabel superview]){
            [self addSubview:transferNumberLabel];
        }
        
        if(nil == [editedImageView superview]){
            [self addSubview:editedImageView];
        }
        
        if(nil == [transferTitleLabel superview]){
            [self addSubview:transferTitleLabel];
        }
        
        if(nil == [actionButton superview]){
            [self addSubview:actionButton];
        }
    }
}

- (void)updateTransferRuleNumber:(NSString*)number{
    [self setTransferRuleNumber:number editedImage:self.editedImage title:self.titleText];
}

- (void)removeTransferRuleNumber{
    self.editedImage = nil;
    self.titleText = nil;
    
    transferNumberLabel.text = @"";
    editedImageView.image = nil;
    transferTitleLabel.text = @"";
    
    if(nil != [transferNumberLabel superview]){
        [transferNumberLabel removeFromSuperview];
    }
    
    if(nil != [editedImageView superview]){
        [editedImageView removeFromSuperview];
    }
    
    if(nil != [transferTitleLabel superview]){
        [transferTitleLabel removeFromSuperview];
    }
    
    if(nil != [actionButton superview]){
        [actionButton removeFromSuperview];
    }
}

@end

@implementation HomeMarkView
@synthesize quadCurveMenu,transferMenuItem,receiveMenuItem,historyMenuItem,resourceNameLabel,resourceValueLabel,bottleMarkView,transferRuleView;

- (void)dealloc{
    [transferMenuItem release];
    [receiveMenuItem release];
    [historyMenuItem release];
    [quadCurveMenu release];
    [bottleMarkView release];
    [transferRuleView release];
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutContentView];
    }
    return self;
}

- (void)layoutContentView
{
    CGRect panelViewFrame     = CGRectMake(0, 395, self.bounds.size.width, self.bounds.size.height-355);
    CGRect quadCurveMenuFrame = CGRectMake(self.bounds.size.width-120, 367, 110, 110);
    CGRect bottleMarkFrame    = CGRectMake(20, 400, self.bounds.size.width-40, 75);
    CGRect transferRuleFrame  = CGRectMake(100, 425, self.bounds.size.width-200, 40);
    CGRect resourceNameLabelFrame = CGRectMake(20, 100, self.bounds.size.width-20, 13);
    CGRect resourceValueLabelFrame = CGRectMake(20, 115, self.bounds.size.width-20, 13);
    if(PHONE_UISCREEN_IPHONE5){
        panelViewFrame.origin.y             += 60;
        quadCurveMenuFrame.origin.y         += 60;
        bottleMarkFrame.origin.y            += 70;
        transferRuleFrame.origin.y          += 80;
        resourceNameLabelFrame.origin.y     += 10;
        resourceValueLabelFrame.origin.y    += 10;
    }else if(PHONE_UISCREEN_IPHONE6){
        panelViewFrame.origin.y             += 110;
        quadCurveMenuFrame.origin.y         += 110;
        bottleMarkFrame.origin.y            += 130;
        transferRuleFrame.origin.y          += 150;
        resourceNameLabelFrame.origin.y     += 20;
        resourceValueLabelFrame.origin.y    += 20;
    }else if(PHONE_UISCREEN_IPHONE6PLUS){
        panelViewFrame.origin.y             += 170;
        quadCurveMenuFrame.origin.y         += 170;
        bottleMarkFrame.origin.y            += 190;
        transferRuleFrame.origin.y          += 210;
        resourceNameLabelFrame.origin.y     += 40;
        resourceValueLabelFrame.origin.y    += 40;
    }
    
    // =====
    UIView* panelView = [[UIView alloc] initWithFrame:panelViewFrame];
    panelView.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    [self addSubview:panelView];
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, panelViewFrame.size.width, 1)];
    lineView.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [panelView addSubview:lineView];
    [lineView release];
    [panelView release];
    
    // =====
    transferMenuItem = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"home_menu_d.png"]
                                               highlightedImage:[UIImage imageNamed:@"home_menu_d.png"]
                                                   ContentImage:nil
                                        highlightedContentImage:nil];
    transferMenuItem.contentLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    transferMenuItem.contentLabel.font = [RTSSAppStyle getRTSSFontWithSize:11.0];
    transferMenuItem.contentLabel.text = NSLocalizedString(@"Home_QuadCurve_Menu_Gift", nil);
    
    // =====
    receiveMenuItem = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"home_menu_d.png"]
                                              highlightedImage:[UIImage imageNamed:@"home_menu_d.png"]
                                                  ContentImage:nil
                                       highlightedContentImage:nil];
    receiveMenuItem.contentLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    receiveMenuItem.contentLabel.font = [RTSSAppStyle getRTSSFontWithSize:11.0];
    receiveMenuItem.contentLabel.text = NSLocalizedString(@"Home_QuadCurve_Menu_Receive", nil);
    
    // =====
    historyMenuItem = [[QuadCurveMenuItem alloc] initWithImage:[UIImage imageNamed:@"home_menu_d.png"]
                                              highlightedImage:[UIImage imageNamed:@"home_menu_d.png"]
                                                  ContentImage:nil
                                       highlightedContentImage:nil];
    historyMenuItem.contentLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    historyMenuItem.contentLabel.font = [RTSSAppStyle getRTSSFontWithSize:11.0];
    historyMenuItem.contentLabel.text = NSLocalizedString(@"Home_QuadCurve_Menu_Friends", nil);
    
    NSArray* menuItems = [NSArray arrayWithObjects:transferMenuItem,receiveMenuItem,historyMenuItem, nil];
    quadCurveMenu = [[QuadCurveMenu alloc] initWithFrame:quadCurveMenuFrame menus:menuItems];
    quadCurveMenu.backgroundColor = [UIColor clearColor];
    [quadCurveMenu enableExpanding:YES];
    [self addSubview:quadCurveMenu];
    
    // =====
    resourceNameLabel = [CommonUtils labelWithFrame:resourceNameLabelFrame text:@"" textColor:[RTSSAppStyle currentAppStyle].textSubordinateColor textFont:[RTSSAppStyle getRTSSFontWithSize:13.0] tag:0];
    resourceNameLabel.numberOfLines = 1;
    resourceNameLabel.adjustsFontSizeToFitWidth = YES;
    resourceNameLabel.textAlignment = NSTextAlignmentLeft;
    [self insertSubview:resourceNameLabel aboveSubview:quadCurveMenu];
    resourceNameLabel.text = @"";
    
    resourceValueLabel = [CommonUtils labelWithFrame:resourceValueLabelFrame text:@"" textColor:[RTSSAppStyle currentAppStyle].textMajorColor textFont:[RTSSAppStyle getRTSSFontWithSize:14.0] tag:0];
    resourceValueLabel.numberOfLines = 1;
    resourceValueLabel.adjustsFontSizeToFitWidth = YES;
    resourceValueLabel.textAlignment = NSTextAlignmentLeft;
    [self insertSubview:resourceValueLabel belowSubview:quadCurveMenu];
    resourceValueLabel.text = @"";
    
    // =====
    bottleMarkView = [[HomeBottleMarkView alloc] initWithFrame:bottleMarkFrame];
    bottleMarkView.backgroundColor = [UIColor clearColor];
    [self insertSubview:bottleMarkView belowSubview:quadCurveMenu];
    
    // =====
    transferRuleView = [[TransferRuleView alloc] initWithFrame:transferRuleFrame];
    transferRuleView.backgroundColor = [UIColor clearColor];
    transferRuleView.hidden = YES;
    [self addSubview:transferRuleView];
}

@end

@interface HomeDisplayView(){
    // 瓶子当前的百分比(0.0-1.0)
    CGFloat                 currentPercent;
    // 开瓶盖的声音
    RTSSAudioPlayer*        homeOpenCapPlayer;
    // 倒水的声音
    RTSSAudioPlayer*        homeOpenPouringPlayer;
    // 瓶盖的偏移量
    CGFloat                 homeCapOffsetx;
    CGFloat                 homeCapOffsety;
}

@end

@implementation HomeDisplayView
@synthesize homeMarkView, bottleView, homeBottleButton, bottleneckImageView,bottlecapImageView;

- (void)dealloc{
    [homeMarkView release];

    bottleView.delegate = nil;
    [bottleView stopTraceMotion];
    [bottleView unloadWater];
    [bottleView release];
    
    [homeBottleButton release];
    [bottleneckImageView release];
    [bottlecapImageView release];
    
    [homeOpenCapPlayer release];
    [homeOpenPouringPlayer release];
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutContentView];
    }
    return self;
}

- (void)layoutContentView{
    self.userInteractionEnabled = YES;
    
    homeCapOffsetx = 80;
    homeCapOffsety = 55;
    
    int fullLevel = __BOTTLE_FULLLEVEL_IPHONE4X;
    int emptyLevel = __BOTTLE_EMPTYLEVEL_IPHONE4X;
    CGRect bottleFrame       = CGRectMake((self.bounds.size.width-192)/2.0, 130, 192, 260);
    CGRect bottleneckFrame   = CGRectMake((self.bounds.size.width-45)/2, 131, 45, 44.5);
    CGRect bottleButtonFrame = CGRectMake((self.bounds.size.width-192)/2.0, 130, 192, 260);
    if (PHONE_UISCREEN_IPHONE5) {
        homeCapOffsety = 80;
        
        fullLevel = __BOTTLE_FULLLEVEL_IPHONE5X;
        emptyLevel = __BOTTLE_EMPTYLEVEL_IPHONE5X;
        
        bottleFrame.origin.y            += 40;
        bottleneckFrame.origin.y        += 40;
        bottleButtonFrame.origin.y      += 40;
        
    } else if (PHONE_UISCREEN_IPHONE6) {
        homeCapOffsety = 80;
        
        fullLevel = __BOTTLE_FULLLEVEL_IPHONE6X;
        emptyLevel = __BOTTLE_EMPTYLEVEL_IPHONE6X;
        
        bottleFrame.origin.y            += 70;
        bottleneckFrame.origin.y        += 70;
        bottleButtonFrame.origin.y      += 70;
        
    } else if (PHONE_UISCREEN_IPHONE6PLUS){
        homeCapOffsety = 80;
        
        fullLevel = __BOTTLE_FULLLEVEL_IPHONE6PX;
        emptyLevel = __BOTTLE_EMPTYLEVEL_IPHONE6PX;
        
        bottleFrame.origin.y            += 100;
        bottleneckFrame.origin.y        += 100;
        bottleButtonFrame.origin.y      += 100;
    }
    // 标记
    homeMarkView = [[HomeMarkView alloc] initWithFrame:self.bounds];
    homeMarkView.backgroundColor = [UIColor clearColor];
    homeMarkView.userInteractionEnabled = YES;
    [self addSubview:homeMarkView];
    
    bottleView = [[BottleView alloc] initWithFrame:bottleFrame];
    bottleView.foregroundName = @"home_bottle_fg";
    bottleView.color = [RTSSAppStyle currentAppStyle].pouringWatterColor;
    bottleView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    [bottleView setFullLevel:fullLevel emptyLevel:emptyLevel];
    [bottleView setInitVolume:0];
    bottleView.adjust = ^(int volume, float degree) {
        //        NSLog(@"BottleView::adjust:volume=%d, degree=%.2f", volume, degree);
        
        float xOffset = 0;
        float yOffset = 0;
        
        //        // volume: 100, angle: +/-10
        //        // volume: 100, angle: +/-20
        //        // volume: 100, angle: +/-30
        //        // volume: 100, angle: +/-40
        //        // volume: 100, angle: +/-50
        //        // volume: 100, angle: +/-60, xOffset = 5;
        //        if (60 <= fabs(degree) && 70 > fabs(degree)) {
        //            xOffset = (5 + fabs(degree)-60) * fabs(degree)/degree;
        //        }
        //        // volume: 100, angle: +/-70, xOffset = 15;
        //        if (70 <= fabs(degree) && 80 > fabs(degree)) {
        //            xOffset = (15 + (fabs(degree)-70) / 10 * 5) * fabs(degree)/degree;
        //        }
        //        // volume: 100, angle: +/-80, xOffset = 20;
        //        if (80 <= fabs(degree) && 90 > fabs(degree)) {
        //            xOffset = (20 + (fabs(degree)-80) / 10 * 20) * fabs(degree)/degree;
        //        }
        //        // volume: 100, angle: +/-90, xOffset = 40;
        //        
        //        NSLog(@"BottleView::adjust:xOffset=%.2f, yOffset=%.2f", xOffset, yOffset);
        
        return CGPointMake(xOffset, yOffset);
    };
    [self insertSubview:bottleView belowSubview:homeMarkView];
    
    // 瓶颈
    bottleneckImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_bottle_bottleneck.png"]];
    bottleneckImageView.backgroundColor = [UIColor clearColor];
    bottleneckImageView.frame = bottleneckFrame;
    [self addSubview:bottleneckImageView];
    
    // 瓶盖
    bottlecapImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_bottle_bottlecap.png"]];
    bottlecapImageView.backgroundColor = [UIColor clearColor];
    bottlecapImageView.frame = CGRectMake(0, 0, 42, 42);
    bottlecapImageView.center = bottleneckImageView.center;
    [self insertSubview:bottlecapImageView belowSubview:bottleneckImageView];
    
    // 点击事件
    homeBottleButton = [[UIButton alloc] initWithFrame:bottleButtonFrame];
    homeBottleButton.backgroundColor = [UIColor clearColor];
    [homeMarkView insertSubview:homeBottleButton belowSubview:homeMarkView.quadCurveMenu];
    
    // 预加载声音
    [self initOpenCapAudio];
}

#pragma mark 瓶盖
- (void)openBottleCap{
    CAKeyframeAnimation* openAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    openAnimation.duration = 0.5f;
    
    CGMutablePathRef openPath = CGPathCreateMutable();
    CGPoint targetPoint = CGPointMake(bottlecapImageView.center.x+homeCapOffsetx, bottlecapImageView.center.y-homeCapOffsety);
    CGPathMoveToPoint(openPath, NULL, bottlecapImageView.center.x, bottlecapImageView.center.y);
    CGPathAddQuadCurveToPoint(openPath, NULL, bottlecapImageView.center.x, bottlecapImageView.center.y-50, targetPoint.x, targetPoint.y);
    openAnimation.path = openPath;
    CGPathRelease(openPath);
    
    [bottlecapImageView.layer addAnimation:openAnimation forKey:@"OpenCap"];
    bottlecapImageView.center = targetPoint;
    
    [self playOpenCapAudio];
}

- (void)closeBottleCap{
    CAKeyframeAnimation* closeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    closeAnimation.duration = 0.5f;
    
    CGMutablePathRef closePath = CGPathCreateMutable();
    CGPoint targetPoint = CGPointMake(bottlecapImageView.center.x-homeCapOffsetx, bottlecapImageView.center.y+homeCapOffsety);
    CGPathMoveToPoint(closePath, NULL, bottlecapImageView.center.x, bottlecapImageView.center.y);
    CGPathAddQuadCurveToPoint(closePath, NULL, targetPoint.x, targetPoint.y-50, targetPoint.x, targetPoint.y);
    closeAnimation.path = closePath;
    CGPathRelease(closePath);
    
    [bottlecapImageView.layer addAnimation:closeAnimation forKey:@"CloseCap"];
    bottlecapImageView.center = targetPoint;
}

#pragma mark 标记视图
- (void)showHomeMarkView{
    if(0.0 == homeMarkView.alpha){
        [UIView animateWithDuration:1.0 animations:^{
            homeMarkView.alpha = 1.0;
        }];
    }
}

- (void)dismissHomeMarkView{
    if(1.0 == homeMarkView.alpha){
        [UIView animateWithDuration:1.0 animations:^{
            homeMarkView.alpha = 0.0;
        }];
    }
}

- (void)initOpenCapAudio{
    NSURL* openPath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"home_bottle_open_cap" ofType:@"caf"]];
    if(nil != openPath){
        homeOpenCapPlayer = [[RTSSAudioPlayer alloc] initWithURL:openPath];
    }
    NSURL* openPouringPath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"home_bottle_pouring" ofType:@"mp3"]];
    if(nil != openPouringPath){
        homeOpenPouringPlayer = [[RTSSAudioPlayer alloc] initWithURL:openPouringPath];
    }
}

- (void)playOpenCapAudio{
    if(nil != homeOpenCapPlayer){
        [homeOpenCapPlayer play];
    }
}

- (void)playOpenPouringAudio{
    if(nil != homeOpenPouringPlayer){
        [homeOpenPouringPlayer play];
    }
}

- (void)stopOpenPouringAudio{
    if(nil != homeOpenPouringPlayer){
        [homeOpenPouringPlayer stop];
    }
}

- (void)updateBottleVolume:(CGFloat)percent animated:(BOOL)animated{
    if(animated){
        bottleView.followTrack = NO;
        homeBottleButton.enabled = NO;
        [bottleView updateToPeekThenVolume:(percent*100)
                         completePeekBlock:^{
                             // 水到达瓶子顶部
                             
                         }
                             completeBlock:^{
                                 // 水下降完成
                                 bottleView.followTrack = YES;
                                 homeBottleButton.enabled = YES;
                             }];
    }else{
        bottleView.followTrack = NO;
        [bottleView updateVolume:(percent*100) completeBlock:^{
            // 水位更新完成
            bottleView.followTrack = YES;
        }];
    }
}

@end

@interface HomePouringOutView (){
    
    NSInteger _direction;
    
    CGPoint emitterPosition;
    
    CGFloat velocity;
}

@end

@implementation HomePouringOutView

- (void)dealloc{
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutContentView:-1];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame direction:(NSInteger)direction{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutContentView:direction];
    }
    return self;
}

- (void)layoutContentView:(NSInteger)direction{
    _direction = direction;
    
    emitterPosition = CGPointMake(self.bounds.size.width/2, 128);
    velocity        = 45;
    if(PHONE_UISCREEN_IPHONE5){
        emitterPosition     = CGPointMake(self.bounds.size.width/2, 168);
        velocity            = 60;
    }else if(PHONE_UISCREEN_IPHONE6){
        emitterPosition     = CGPointMake(self.bounds.size.width/2, 198);
        velocity            = 60;
    }else if(PHONE_UISCREEN_IPHONE6PLUS){
        emitterPosition     = CGPointMake(self.bounds.size.width/2, 228);
        velocity            = 65;
    }
    
    self.backgroundColor = [UIColor clearColor];
    
    [self creatEmitterCells:_direction color:[RTSSAppStyle currentAppStyle].pouringWatterColor];
}

+ (Class)layerClass {
    return [CAEmitterLayer class];
}

- (void)creatEmitterCells:(NSInteger)direction color:(UIColor*)color{
    CAEmitterLayer* emitterLayer = (CAEmitterLayer*)self.layer;
    emitterLayer.emitterPosition = emitterPosition;
    
    NSMutableArray* emitterCellArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    {
        CAEmitterCell* emitterCell = [CAEmitterCell emitterCell];
        emitterCell.contents = (id)[[UIImage imageNamed:@"home_emitter_cell1.png"] CGImage];
        emitterCell.birthRate = 150;
        emitterCell.lifetime = 2.5;
        emitterCell.lifetimeRange = 0.5;
        emitterCell.color = [color colorWithAlphaComponent:0.2f].CGColor;
        emitterCell.velocity = 0 > direction ? -velocity : velocity;
        emitterCell.velocityRange = 1.0;
        emitterCell.xAcceleration = 0 > direction ? -45.0 : 45.0;
        emitterCell.emissionLongitude = 0 > direction ? M_PI_2 : -M_PI_2;
        emitterCell.emissionRange = 0;
        emitterCell.name = @"1";
        
        [emitterCellArray addObject:emitterCell];
    }
    
    {
        CAEmitterCell* emitterCell = [CAEmitterCell emitterCell];
        emitterCell.contents = (id)[[UIImage imageNamed:@"home_emitter_cell2.png"] CGImage];
        emitterCell.birthRate = 150;
        emitterCell.lifetime = 2.5;
        emitterCell.lifetimeRange = 0.5;
        emitterCell.color = [color colorWithAlphaComponent:0.3f].CGColor;
        emitterCell.velocity = 0 > direction ? -velocity : velocity;
        emitterCell.velocityRange = 1.0;
        emitterCell.xAcceleration = 0 > direction ? -45.0 : 45.0;
        emitterCell.emissionLongitude = 0 > direction ? M_PI_2 : -M_PI_2;
        emitterCell.emissionRange = 0;
        emitterCell.name = @"2";
        
        [emitterCellArray addObject:emitterCell];
    }
    
    emitterLayer.emitterCells = emitterCellArray;
    
    [emitterCellArray release];
}

- (void)updateEmitterCellColor:(UIColor*)color{
    [self creatEmitterCells:_direction color:color];
}

@end

@interface HomePouringInView()
{
    NSInteger _direction;
    
    CGPoint emitterPosition;
    
    CGFloat velocity;
    
    CGFloat lifetime;
}

@end

@implementation HomePouringInView

- (void)dealloc{
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutContentView:-1];
    }
    return self;
}

// 初始化出水图层，根据方向
- (instancetype)initWithFrame:(CGRect)frame direction:(NSInteger)direction
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutContentView:direction];
    }
    return self;
}

- (void)layoutContentView:(NSInteger)direction{
    self.backgroundColor    = [UIColor clearColor];
    
    _direction              = direction;
    
    emitterPosition         = CGPointMake(self.bounds.size.width, 15);
    velocity                = 82;
    lifetime                = 1.8;
    if(PHONE_UISCREEN_IPHONE5){
        velocity            = 72;
        lifetime            = 2.1;
    }else if(PHONE_UISCREEN_IPHONE6){
        velocity            = 77;
        lifetime            = 2.3;
    }else if(PHONE_UISCREEN_IPHONE6PLUS){
        emitterPosition     = CGPointMake(self.bounds.size.width, 30);
        velocity            = 79;
        lifetime            = 2.4;
    }
    
    [self creatEmitterCells:_direction color:[RTSSAppStyle currentAppStyle].pouringWatterColor];
}

+ (Class)layerClass {
    return [CAEmitterLayer class];
}

- (void)creatEmitterCells:(NSInteger)direction color:(UIColor*)color{
    CAEmitterLayer* emitterLayer = (CAEmitterLayer*)self.layer;
    emitterLayer.emitterPosition = emitterPosition;
    
    NSMutableArray* emitterCellArray = [[NSMutableArray alloc] initWithCapacity:0];
    {
        CAEmitterCell* emitterCell = [CAEmitterCell emitterCell];
        emitterCell.contents = (id)[[UIImage imageNamed:@"home_emitter_cell3.png"] CGImage];
        emitterCell.birthRate = 150;
        emitterCell.lifetime = lifetime;
        emitterCell.lifetimeRange = 0.5;
        emitterCell.color = [color colorWithAlphaComponent:0.3f].CGColor;
        emitterCell.velocity = 0 > direction ? -velocity : velocity;
        emitterCell.velocityRange = 1.0;
        emitterCell.yAcceleration = 0 > direction ? 60.0 : -60.0;
        emitterCell.emissionLongitude = 0;
        emitterCell.emissionRange = 0;
        emitterCell.name = @"1";
        [emitterCellArray addObject:emitterCell];
    }
    
    {
        CAEmitterCell* emitterCell = [CAEmitterCell emitterCell];
        emitterCell.contents = (id)[[UIImage imageNamed:@"home_emitter_cell2.png"] CGImage];
        emitterCell.birthRate = 150;
        emitterCell.lifetime = lifetime;
        emitterCell.lifetimeRange = 0.5;
        emitterCell.color = [color colorWithAlphaComponent:0.3f].CGColor;
        emitterCell.velocity = 0 > direction ? -velocity : velocity;
        emitterCell.velocityRange = 1.0;
        emitterCell.yAcceleration = 0 > direction ? 60.0 : -60.0;
        emitterCell.emissionLongitude = 0;
        emitterCell.emissionRange = 0;
        emitterCell.name = @"2";
        [emitterCellArray addObject:emitterCell];
    }
    
    emitterLayer.emitterCells = emitterCellArray;
    
    [emitterCellArray release];
}

- (void)updateEmitterCellColor:(UIColor*)color{
    [self creatEmitterCells:_direction color:color];
}

@end

@implementation HomePouringOutViewGroup
@synthesize leftHomePouringOutView,rightHomePouringOutView;
@synthesize isHiddenLeft,isHiddenRight;

- (void)dealloc{
    [leftHomePouringOutView release];
    [rightHomePouringOutView release];
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)addHomePouringOutView{
    if(nil == leftHomePouringOutView){
        leftHomePouringOutView = [[HomePouringOutView alloc] initWithFrame:self.bounds direction:1];
        [self addSubview:leftHomePouringOutView];
    }
    
    if(nil == rightHomePouringOutView){
        rightHomePouringOutView = [[HomePouringOutView alloc] initWithFrame:self.bounds direction:-1];
        [self addSubview:rightHomePouringOutView];
    }
}

- (void)removeHomePouringOutView{
    if(nil != leftHomePouringOutView){
        [leftHomePouringOutView removeFromSuperview];
        [leftHomePouringOutView release];
        leftHomePouringOutView = nil;
    }
    
    if(nil != rightHomePouringOutView){
        [rightHomePouringOutView removeFromSuperview];
        [rightHomePouringOutView release];
        rightHomePouringOutView = nil;
    }
}

- (void)setHiddenLeft:(BOOL)hiddenLeft{
    isHiddenLeft = hiddenLeft;
    if(nil != leftHomePouringOutView){
        leftHomePouringOutView.hidden = isHiddenLeft;
    }
}

- (void)setHiddenRight:(BOOL)hiddenRight{
    isHiddenRight = hiddenRight;
    if(nil != rightHomePouringOutView){
        rightHomePouringOutView.hidden = isHiddenRight;
    }
}

@end

@implementation HomePouringInViewGroup
@synthesize rightHomePouringInView;

- (void)dealloc{
    [rightHomePouringInView release];
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)addHomePouringInView{
    if(nil == rightHomePouringInView){
        rightHomePouringInView = [[HomePouringInView alloc] initWithFrame:self.bounds direction:-1];
        [self addSubview:rightHomePouringInView];
    }
}

- (void)removeHomePouringInView{
    if(nil != rightHomePouringInView){
        [rightHomePouringInView removeFromSuperview];
        [rightHomePouringInView release];
        rightHomePouringInView = nil;
    }
}

@end


@implementation HomeBottleView
@synthesize homeDisplayView,homePouringInViewGroup,homePouringOutViewGroup;

- (void)dealloc{
    [homeDisplayView release];
    [homePouringOutViewGroup release];
    [homePouringInViewGroup release];
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutContentView];
    }
    return self;
}

- (void)layoutContentView{
    
    homeDisplayView = [[HomeDisplayView alloc] initWithFrame:self.bounds];
    homeDisplayView.backgroundColor = [UIColor clearColor];
    homeDisplayView.userInteractionEnabled = YES;
    [self addSubview:homeDisplayView];
    
    homePouringOutViewGroup = [[HomePouringOutViewGroup alloc] initWithFrame:self.bounds];
    homePouringOutViewGroup.backgroundColor = [UIColor clearColor];
    homePouringOutViewGroup.hidden = YES;
    [self addSubview:homePouringOutViewGroup];
    
    homePouringInViewGroup = [[HomePouringInViewGroup alloc] initWithFrame:self.bounds];
    homePouringInViewGroup.backgroundColor = [UIColor clearColor];
    homePouringInViewGroup.hidden = YES;
    [self addSubview:homePouringInViewGroup];

}

@end
