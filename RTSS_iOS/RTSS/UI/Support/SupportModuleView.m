//
//  TextInputView.m
//  RTSS
//
//  Created by Liuxs on 15-2-7.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "SupportModuleView.h"
#import "RTSSAppStyle.h"
#import "RTSSAppDefine.h"
#import "CommonUtils.h"
@interface PickerSuperView()<UIPickerViewDataSource,UIPickerViewDelegate>

@end

@implementation PickerSuperView

@synthesize pickerDateToolbar,pickerView,mDataSource;

- (void)dealloc
{
    [pickerDateToolbar release];
    [pickerView release];
    [mDataSource release];
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame target:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        [self layoutPickerSuperView];
    }
    return self;
}

- (void)layoutPickerSuperView
{
    CGRect mPickerDateToolbarRect = CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 44);
    CGRect mPickerViewRect        = CGRectMake(0, 44, PHONE_UISCREEN_WIDTH, 216);
    
    
    //
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self.delegate action:@selector(toolBarCanelClick:)];
    //
    UIBarButtonItem *doneBtn   = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self.delegate action:@selector(toolBarDoneClick:)];
    
    self.pickerDateToolbar = [[[UINavigationBar alloc] initWithFrame:mPickerDateToolbarRect]autorelease];
    self.pickerDateToolbar.translucent = YES;
    self.pickerDateToolbar.barStyle    = UIBarStyleBlackTranslucent;
    
    self.pickerDateToolbar.barStyle = UIBarStyleBlackOpaque;
    //    [self.pickerDateToolbar sizeToFit];
    self.pickerDateToolbar.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    
    UINavigationItem* navItem  = [[[UINavigationItem alloc] initWithTitle:nil] autorelease];
    navItem.leftBarButtonItem  = cancelBtn;
    navItem.rightBarButtonItem = doneBtn;
    [self.pickerDateToolbar pushNavigationItem:navItem animated:YES];
    [cancelBtn release];
    [doneBtn release];
    
    
    self.pickerView = [[[UIPickerView alloc] initWithFrame:mPickerViewRect]autorelease];
    self.pickerView.delegate   = self;
    self.pickerView.dataSource = self;
    self.pickerView.showsSelectionIndicator = YES;
    [self.pickerView selectRow:1 inComponent:0 animated:YES];
    self.pickerView.tintColor  = [UIColor whiteColor];
    self.pickerView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    [self addSubview:self.pickerView];
    [self addSubview:self.pickerDateToolbar];
}

- (void)pickerReloadAllComponents:(NSArray *)dataSource
{
    self.mDataSource = dataSource;
    [self.pickerView reloadAllComponents];
}



//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.mDataSource count];
}

//设置当前行的内容
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.mDataSource[row];
}

//选中picker cell,save ArrayIndex
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //    self.tempString = self.dataSource[row];
}




@end



@interface BallImageView()<UIDynamicAnimatorDelegate,UICollisionBehaviorDelegate>

@end

@implementation BallImageView
@synthesize dynamicAnimator,gravityBehavior,collisionBehavior,suspendBehavior,touchBehavior,itemBehavior,portraitPoint,borderColor,mTitleLabel,mIconNumberLabel;

- (void)dealloc
{
    [dynamicAnimator release];
    [gravityBehavior release];
    [collisionBehavior release];
    [suspendBehavior release];
    [touchBehavior release];
    [itemBehavior release];
    [borderColor release];
    [mTitleLabel release];
    [mIconNumberLabel release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame backgroundImage:(UIImage *)image withReferenceView:(UIView *)view
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dynamicAnimator = [[[UIDynamicAnimator alloc] initWithReferenceView:view]autorelease];
        
        //content mode
        // self.contentMode = UIViewContentModeCenter;
        self.userInteractionEnabled = YES;
        
        //holder image
        
        
        //        self.image = image;
        self.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
        // 设置边框颜色
        [self.layer setBorderColor: [[RTSSAppStyle currentAppStyle].separatorColor CGColor]];
        // 设置边框宽度
        [self.layer setBorderWidth: 1.0];
        // 设置投影偏移量，CGSizeMake(x轴方向, y轴方向)
        [[self layer] setShadowOffset:CGSizeMake(1, 1)];
        // 设置投影颜色
        //        [[self layer] setShadowColor:[UIColor redColor].CGColor];
        // 设置投影半径
        [[self layer] setShadowRadius:3];
        // 设置透明度
        [[self layer] setShadowOpacity:1];
        
        //        radius
        self.layer.cornerRadius = CGRectGetWidth(frame) / 2.f;
        self.layer.masksToBounds = YES;
        
        
        
        
        
        
        
        // 单击手势
        UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]autorelease];
        [self addGestureRecognizer:tap];
        
        // 移动手势
        UIPanGestureRecognizer* panGesture = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pannedGesture:)]autorelease];
        [self addGestureRecognizer:panGesture];
        [self layoutDynamicAnimator];
        
    }
    return self;
}


- (void)layoutIconImageWithFrame:(CGRect)frame icon:(UIImage *)image
{
    UIImageView *icon = [[UIImageView alloc] initWithFrame:frame];
    icon.image = image;
    [self addSubview:icon];
    [icon release];
}



- (void)layoutTitleLabelWithFrame:(CGRect)frame title:(NSString *)text textFont:(UIFont *)font
{
    self.mTitleLabel = [CommonUtils labelWithFrame:frame text:text textColor:[RTSSAppStyle currentAppStyle].textSubordinateColor textFont:font tag:0];
//    self.mTitleLabel.backgroundColor = [UIColor redColor];
    [self addSubview:self.mTitleLabel];
}


- (void)setTitleLabelText:(NSString *)text
{
    self.mTitleLabel.text = text;
}


// 启动动画属性
- (void)initAnimation
{
    [self.layer setBorderColor: [[RTSSAppStyle currentAppStyle].textSubordinateColor CGColor]];
    [self.dynamicAnimator addBehavior:self.suspendBehavior];
    [self.dynamicAnimator addBehavior:self.gravityBehavior];
    [self.dynamicAnimator addBehavior:self.collisionBehavior];
}

- (void)tap:(UITapGestureRecognizer *)recognizer
{
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(tap:)]) {
        [self.delegate tap:recognizer];
    }
}

- (void)pannedGesture:(UIPanGestureRecognizer*)gesture
{
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(pannedGesture:)]) {
        [self.delegate pannedGesture:gesture];
    }
}


// 初始化动画的各个属性
- (void)layoutDynamicAnimator
{
    CGPoint anchor = CGPointMake(self.center.x-5, self.center.y - 15);
    self.suspendBehavior = [[[UIAttachmentBehavior alloc] initWithItem:self attachedToAnchor:anchor]autorelease];
    self.suspendBehavior.length    = 10;
    self.suspendBehavior.damping   = 1;
    self.suspendBehavior.frequency = 1.2;
    
    // ==
    self.itemBehavior = [[[UIDynamicItemBehavior alloc] initWithItems:@[self]]autorelease];
    self.itemBehavior.elasticity = 0.3;
    self.itemBehavior.friction   = 1.0;
    self.itemBehavior.resistance = 5;
    self.itemBehavior.density    = 5;
    self.itemBehavior.allowsRotation = NO;
    
    // ==
    self.gravityBehavior = [[[UIGravityBehavior alloc] initWithItems:@[self]]autorelease];
    self.gravityBehavior.gravityDirection = CGVectorMake(0, 1);
    
    // ==
    self.collisionBehavior = [[[UICollisionBehavior alloc] initWithItems:@[self]]autorelease];
    [self.collisionBehavior setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(0, -6, 0, 0)];
    self.collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    
    
}


- (void)GestureRecognizerStateBegan
{
    [self.dynamicAnimator removeBehavior:self.itemBehavior];
    [self.dynamicAnimator removeBehavior:self.suspendBehavior];
    
    self.touchBehavior = nil;
    self.touchBehavior = [[[UIAttachmentBehavior alloc] initWithItem:self attachedToAnchor:self.center]autorelease];
    self.touchBehavior.damping   = 0.3;
    self.touchBehavior.frequency = 1.0;
    [self.dynamicAnimator addBehavior:self.touchBehavior];
}

- (void)removeTouchBehavior
{
    [self.dynamicAnimator removeBehavior:self.touchBehavior];
    
}

- (void)removeAllBehaviors
{
    [self.dynamicAnimator removeAllBehaviors];
}

- (void)startItemBehavior{
    [self.itemBehavior addLinearVelocity:self.portraitPoint forItem:self];
}

- (void)startSuspendBehavior{
    [self.dynamicAnimator addBehavior:self.suspendBehavior];
}


- (void)setFrame:(CGRect)newFrame {
    [super setFrame:newFrame];
    self.layer.cornerRadius = CGRectGetWidth(newFrame) / 2.f;
    self.layer.masksToBounds = YES;
}

@end


@interface BallView()<UIDynamicAnimatorDelegate,UICollisionBehaviorDelegate,BallImageViewDelegate>

@property(nonatomic, retain) UIImageView*               logoView;

@property (nonatomic, retain) BallImageView  *mEmailImageView;
@property (nonatomic, retain) BallImageView  *mRequestImageView;
@property (nonatomic, retain) BallImageView  *mLiveImageView;
@property (nonatomic, retain) BallImageView  *mCallImageView;
@property (nonatomic, retain) BallImageView  *mVideoImageView;
@property (nonatomic, retain) NSMutableArray *mBallArray;

@end

@implementation BallView
@synthesize delegate,logoView,mEmailImageView,mRequestImageView,mLiveImageView,mCallImageView,mVideoImageView,mBallArray;

- (void)dealloc
{
    [logoView          release];
    [mEmailImageView   release];
    [mRequestImageView release];
    [mLiveImageView    release];
    [mCallImageView    release];
    [mVideoImageView   release];
    [mBallArray        release];
    
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:frame];
        [self layoutContentView];
        
    }
    return self;
}
- (void)layoutContentView
{
    
    // == 5个圆圈的rect
    CGRect logoRect        = CGRectMake((self.bounds.size.width-120)/2, (self.bounds.size.height-120)/2, 120, 120);
    CGRect logoIconRect    = CGRectMake(43, 15, 44, 44);
    CGRect logoNumberLabelRect = CGRectMake(7, logoRect.size.height/2, 105, 17);
    CGRect logoTitleLabelRect = CGRectMake(20, 85, 75, 15);
    UIFont *logoNumberLabelFont = [RTSSAppStyle getRTSSFontWithSize:17.0f];
    CGRect mEmailRect      = CGRectMake(40, 15, 80, 80);
    CGRect mRequestRect    = CGRectMake(210, 10, 80, 80);
    CGRect mLiveRect       = CGRectMake(4, 150, 80, 80);
    CGRect mCallRect       = CGRectMake(238, 205, 80, 80);
    CGRect mVideoRect      = CGRectMake(125, 195, 80, 80);
    CGRect mBallIconRect   = CGRectMake(mEmailRect.size.width/5+1, mEmailRect.size.height/8, 45, 45);
    CGRect mBallTitleLabelRect = CGRectMake(10, 50, 60, 15);
    UIFont *mTitleLabelFont = [RTSSAppStyle getRTSSFontWithSize:11.0f];
    if (PHONE_UISCREEN_IPHONE5) {
        logoRect        = CGRectMake((self.bounds.size.width-130)/2, (self.bounds.size.height-130)/2, 130, 130);
        logoIconRect    = CGRectMake(45, 15, 45, 45);
        logoNumberLabelRect = CGRectMake(10, logoRect.size.height/2, 105, 18);
        logoTitleLabelRect = CGRectMake(18, 90, 86, 15);
        logoNumberLabelFont = [RTSSAppStyle getRTSSFontWithSize:18.0f];
        mEmailRect   = CGRectMake(40, 35, 90, 90);
        mRequestRect = CGRectMake(205, 30, 90, 90);
        mLiveRect    = CGRectMake(4, 200, 90, 90);
        mCallRect    = CGRectMake(230, 260, 90, 90);
        mVideoRect      = CGRectMake(115, 250, 90, 90);
        mBallIconRect   = CGRectMake(mEmailRect.size.width/4-2, mEmailRect.size.height/7, 50, 50);
        mBallTitleLabelRect = CGRectMake(15, 60, 60, 15);
        mTitleLabelFont = [RTSSAppStyle getRTSSFontWithSize:12.0f];
        
    }else if (PHONE_UISCREEN_IPHONE6) {
        logoRect     = CGRectMake((self.bounds.size.width-160)/2, (self.bounds.size.height-160)/2, 160, 160);
        logoIconRect = CGRectMake(55, 20, 60, 60);
        logoNumberLabelRect = CGRectMake(8, logoRect.size.height/2, 140, 22);
        logoTitleLabelRect = CGRectMake(20, 110, 110, 15);
        logoNumberLabelFont = [RTSSAppStyle getRTSSFontWithSize:22.0f];
        mEmailRect   = CGRectMake(40, 50
                                  , 100, 100);
        mRequestRect = CGRectMake(250, 45, 100, 100);
        mLiveRect    = CGRectMake(4, 240, 100, 100);
        mCallRect    = CGRectMake(270, 310, 100, 100);
        mVideoRect      = CGRectMake(140, 300, 100, 100);
        mBallIconRect = CGRectMake(mEmailRect.size.width/4-2, mEmailRect.size.height/7, 55, 55);
        mBallTitleLabelRect = CGRectMake(12, 65, 76, 15);
        mTitleLabelFont = [RTSSAppStyle getRTSSFontWithSize:13.0f];
    }else if (PHONE_UISCREEN_IPHONE6PLUS) {
        logoRect     = CGRectMake((self.bounds.size.width-170)/2, (self.bounds.size.height-170)/2, 170, 170);
        logoIconRect = CGRectMake(55, 22, 65, 65);
        logoNumberLabelRect = CGRectMake(8, logoRect.size.height/2, 150, 25);
        logoTitleLabelRect = CGRectMake(22, 113, 113, 20);
        logoNumberLabelFont = [RTSSAppStyle getRTSSFontWithSize:25.0f];
        mEmailRect   = CGRectMake(40, 50, 115, 115);
        mRequestRect = CGRectMake(260, 45, 115, 115);
        mLiveRect    = CGRectMake(4, 260, 115, 115);
        mCallRect    = CGRectMake(270, 330, 115, 115);
        mVideoRect      = CGRectMake(140, 300, 115, 115);
        mBallIconRect = CGRectMake(mEmailRect.size.width/4-3, mEmailRect.size.height/7, 60, 60);
        mBallTitleLabelRect = CGRectMake(15, 77, 80, 17);
        mTitleLabelFont = [RTSSAppStyle getRTSSFontWithSize:15.0f];
    }
    
    self.mBallArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    // 中心圆圈
    self.logoView = [[[UIImageView alloc] initWithFrame:logoRect] autorelease];
    self.logoView.image = [UIImage imageNamed:@"support_center.png"];
    [self addSubview:self.logoView];
    
    UIImageView *logoIcon = [[[UIImageView alloc] initWithFrame:logoIconRect] autorelease];
    logoIcon.image = [UIImage imageNamed:@"support_center_icon.png"];
    [self.logoView addSubview:logoIcon];
    
    UILabel *logoNumberLabel = [CommonUtils labelWithFrame:logoNumberLabelRect text:@"24/7" textColor:[RTSSAppStyle currentAppStyle].textSubordinateColor textFont:logoNumberLabelFont tag:0];
//    logoNumberLabel.backgroundColor = [UIColor redColor];
    [self.logoView addSubview:logoNumberLabel];
    
    UILabel *logoTitleLabel = [CommonUtils labelWithFrame:logoTitleLabelRect text:NSLocalizedString(@"Support_Center_Title",nil) textColor:[RTSSAppStyle currentAppStyle].textSubordinateColor textFont:mTitleLabelFont tag:0];
//    logoTitleLabel.backgroundColor = [UIColor grayColor];
    [self.logoView addSubview:logoTitleLabel];
    
    
    // ==
    
    self.mEmailImageView = [[[BallImageView alloc] initWithFrame:mEmailRect backgroundImage:[UIImage imageNamed:@"support_email_icon.png"] withReferenceView:self] autorelease];
    [self.mEmailImageView layoutIconImageWithFrame:mBallIconRect icon:[UIImage imageNamed:@"support_email_icon.png"]];
    [self.mEmailImageView layoutTitleLabelWithFrame:mBallTitleLabelRect title:NSLocalizedString(@"Support_Button_Title_Email", nil) textFont:mTitleLabelFont];
        self.mEmailImageView.borderColor = [RTSSAppStyle getFreeResourceColorWithIndex:0];
//    self.mEmailImageView.borderColor = [RTSSAppStyle currentAppStyle].supportBallViewEmailselectedBorderColor;
    self.mEmailImageView.tag      = SupportBallTypeEmail;
    self.mEmailImageView.delegate = self;
    [self addSubview:self.mEmailImageView];
    [self.mBallArray addObject:self.mEmailImageView];
    // ==
    
    self.mRequestImageView = [[[BallImageView alloc] initWithFrame:mRequestRect backgroundImage:[UIImage imageNamed:@"support_request_call_icon.png"] withReferenceView:self] autorelease];
    [self.mRequestImageView layoutIconImageWithFrame:mBallIconRect icon:[UIImage imageNamed:@"support_request_call_icon.png"]];
    [self.mRequestImageView layoutTitleLabelWithFrame:mBallTitleLabelRect title:NSLocalizedString(@"Support_Title_RequestCall", nil) textFont:mTitleLabelFont];
        self.mRequestImageView.borderColor = [RTSSAppStyle getFreeResourceColorWithIndex:2];
//    self.mRequestImageView.borderColor = [RTSSAppStyle currentAppStyle].supportBallViewRequestselectedBorderColor;
    self.mRequestImageView.tag      = SupportBallTypeRequestCall;
    self.mRequestImageView.delegate = self;
    [self addSubview:self.mRequestImageView];
    [self.mBallArray addObject:self.mRequestImageView];
    // ==
    
    self.mLiveImageView = [[[BallImageView alloc] initWithFrame:mLiveRect backgroundImage:[UIImage imageNamed:@"support_livechat_icon.png"] withReferenceView:self] autorelease];
    [self.mLiveImageView layoutIconImageWithFrame:mBallIconRect icon:[UIImage imageNamed:@"support_livechat_icon.png"]];
    [self.mLiveImageView layoutTitleLabelWithFrame:mBallTitleLabelRect title:NSLocalizedString(@"Support_Button_Title_liveChat", nil) textFont:mTitleLabelFont];
        self.mLiveImageView.borderColor = [RTSSAppStyle getFreeResourceColorWithIndex:1];
//    self.mLiveImageView.borderColor = [RTSSAppStyle currentAppStyle].supportBallViewLiveSelectedBorderColor;
    self.mLiveImageView.tag      = SupportBallTypeLiveChat;
    self.mLiveImageView.delegate = self;
//    [self addSubview:self.mLiveImageView];
//    [self.mBallArray addObject:self.mLiveImageView];
    // ==
    
    self.mCallImageView = [[[BallImageView alloc] initWithFrame:mCallRect backgroundImage:[UIImage imageNamed:@"support_callus_icon.png"] withReferenceView:self] autorelease];
    [self.mCallImageView layoutIconImageWithFrame:mBallIconRect icon:[UIImage imageNamed:@"support_callus_icon.png"]];
        self.mCallImageView.borderColor = [RTSSAppStyle getFreeResourceColorWithIndex:3];
//    self.mCallImageView.borderColor = [RTSSAppStyle currentAppStyle].supportBallViewCallSelectedBorderColor;
    [self.mCallImageView layoutTitleLabelWithFrame:mBallTitleLabelRect title:NSLocalizedString(@"Support_Button_Title_CallUs", nil) textFont:mTitleLabelFont];
    self.mCallImageView.tag      = SupportBallTypeCallUs;
    self.mCallImageView.delegate = self;
    [self addSubview:self.mCallImageView];
    [self.mBallArray addObject:self.mCallImageView];
    
    self.mVideoImageView = [[[BallImageView alloc] initWithFrame:mVideoRect backgroundImage:[UIImage imageNamed:@"support_video_chat_icon.png"] withReferenceView:self] autorelease];
    [self.mVideoImageView layoutIconImageWithFrame:mBallIconRect icon:[UIImage imageNamed:@"support_video_chat_icon.png"]];
        self.mVideoImageView.borderColor = [RTSSAppStyle getFreeResourceColorWithIndex:4];
//    self.mVideoImageView.borderColor = [RTSSAppStyle currentAppStyle].supportBallViewVideoSelectedBorderColor;
    [self.mVideoImageView layoutTitleLabelWithFrame:mBallTitleLabelRect title:NSLocalizedString(@"Support_Button_Title_VideoChat", nil) textFont:mTitleLabelFont];
    self.mVideoImageView.tag      = SupportBallTypeVideoChat;
    self.mVideoImageView.delegate = self;
    //    [self addSubview:self.mVideoImageView];
    //    [self.mBallArray addObject:self.mVideoImageView];
    
}

// 启动各自动画属性
- (void)initAnimation{
    for (BallImageView *ballImage in self.mBallArray) {
        ballImage.userInteractionEnabled = YES;
        [ballImage initAnimation];
    }
}

// 点击圆圈
- (void)tap:(UITapGestureRecognizer *)recognizer
{
    BallImageView *ballImage = (BallImageView *)recognizer.view;
    if (ballImage.userInteractionEnabled) {
        for (BallImageView *ballImageView in self.mBallArray) {
            if (ballImageView != ballImage) {
                ballImageView.userInteractionEnabled = NO;
            }
        }
        [ballImage removeAllBehaviors];
        [self jumpToLogoAnimation:ballImage];
    }
}

// 圆圈手势监听
- (void)pannedGesture:(UIPanGestureRecognizer*)gesture
{
    BallImageView *ballImage = (BallImageView *)gesture.view;
    if (ballImage.userInteractionEnabled) {
        CGPoint location = [gesture locationInView:self];
        switch (gesture.state) {
            case UIGestureRecognizerStateBegan:{
                [ballImage GestureRecognizerStateBegan];
                for (BallImageView *ballImageView in self.mBallArray) {
                    if (ballImageView != ballImage) {
                        ballImageView.userInteractionEnabled = NO;
                    }
                }
                break;
            }
            case UIGestureRecognizerStateChanged:{
                if(nil != ballImage.touchBehavior){
                    ballImage.touchBehavior.anchorPoint = location;
                }
                break;
            }
            case UIGestureRecognizerStateEnded :
            case UIGestureRecognizerStateCancelled:{
                if(nil != ballImage.touchBehavior){
                    [ballImage removeAllBehaviors];
                }
                
                if(CGRectContainsPoint(self.logoView.frame, location)){
                    [ballImage removeAllBehaviors];
                    [self jumpToLogoAnimation:ballImage];
                }else{
                    [ballImage initAnimation];
                    for (BallImageView *ballImageView in self.mBallArray) {
                        if (ballImageView != ballImage) {
                            ballImageView.userInteractionEnabled = YES;
                        }
                    }
                }
                
                break;
            }
                
            default:
                break;
        }
    }
}
// 移动到中间圆圈区域
- (void)jumpToLogoAnimation:(BallImageView *)imageView{
    for (BallImageView *ballImage in self.mBallArray) {
        ballImage.userInteractionEnabled = NO;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(isLeftBarButtonItemEnabled:)]) {
        [self.delegate isLeftBarButtonItemEnabled:NO];
    }
    imageView.layer.borderColor = imageView.borderColor.CGColor;
    [UIView animateWithDuration:0.8 animations:^{
        imageView.center = self.logoView.center;
    } completion:^(BOOL finished) {
        if(nil != delegate && [delegate respondsToSelector:@selector(jumpToLogoAnimationCompletion:)]){
            [delegate jumpToLogoAnimationCompletion:imageView.tag];
        }
    }];
    
}


@end



@interface TextInputView()

@end

@implementation TextInputView
@synthesize textType,sendButton,textField;

- (void)dealloc
{
    [sendButton release];
    [textField  release];
    [super dealloc];
}
- (instancetype)initWithFrame:(CGRect)frame Type:(TextInputType)type target:(id)delegate Color:(UIColor *)color placeholder:(NSString *)placeholder ReturnKeyType:(UIReturnKeyType)returnKeyType
{
    self = [super initWithFrame:frame];
    self.textType            = type;
    self.delegate            = delegate;
    self.backgroundColor     = color;
    UIImageView *upImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 1)];
    upImageView.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
//    upImageView.image        = [UIImage imageNamed:@"common_separator_line.png"];
    [self addSubview:upImageView];
    [upImageView release];
    [self layoutViewTarget:delegate placeholder:placeholder ReturnKeyType:returnKeyType];
    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:delegate action:@selector(tap:)]autorelease];
    [self addGestureRecognizer:tap];
    return self;
}

- (void)layoutViewTarget:(id)delegate placeholder:(NSString *)placeholder ReturnKeyType:(UIReturnKeyType)returnKeyType {
    switch (textType) {
        case TextInputTypePicker:
            // 选择器
        {
            self.textField = [[[UITextField alloc] initWithFrame:CGRectMake(13, 15, self.bounds.size.width - 26, 40)]autorelease];
            self.textField.returnKeyType = returnKeyType;
            self.textField.borderStyle   = UITextBorderStyleRoundedRect;
            self.textField.leftViewMode  = UITextFieldViewModeAlways;
            self.textField.leftView      = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 2)]autorelease];
            self.textField.layer.cornerRadius = 5.0;
            self.textField.layer.backgroundColor = [RTSSAppStyle currentAppStyle].textMajorColor.CGColor;
            self.textField.rightViewMode = UITextFieldViewModeAlways;
            self.textField.rightView     = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 40)]autorelease];
            UIImage *_image = [UIImage imageNamed:@"common_arrow_down.png"];
            UIImageView *arrowImage      = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 8.0, _image.size.width, _image.size.height)];
            arrowImage.image             = _image;
            [self.textField.rightView addSubview:arrowImage];
//            arrowImage.userInteractionEnabled = NO;
            [arrowImage release];
            self.textField.delegate      = delegate;
            self.textField.attributedPlaceholder = [self getAttributed:placeholder];
            self.textField.font          = [RTSSAppStyle getRTSSFontWithSize:14.0];
            self.textField.textColor     = [RTSSAppStyle currentAppStyle].textMajorColor;
            self.textField.backgroundColor = [RTSSAppStyle currentAppStyle].textFieldBgColor;
            [self addSubview:self.textField];
            break;
        }
        case TextInputTypeInput:
            // 输入框
            self.textField = [[[UITextField alloc] initWithFrame:CGRectMake(13, 15, self.bounds.size.width - 26, 40)]autorelease];
            self.textField.returnKeyType         = returnKeyType;
            self.textField.borderStyle           = UITextBorderStyleRoundedRect;
            self.textField.leftViewMode          = UITextFieldViewModeAlways;
            self.textField.layer.cornerRadius    = 5.0;
            self.textField.layer.backgroundColor = [RTSSAppStyle currentAppStyle].textMajorColor.CGColor;
            self.textField.delegate = delegate;
            self.textField.attributedPlaceholder = [self getAttributed:placeholder];
            self.textField.font                  = [RTSSAppStyle getRTSSFontWithSize:14.0];
            self.textField.textColor             = [RTSSAppStyle currentAppStyle].textMajorColor;
            self.textField.backgroundColor       = [RTSSAppStyle currentAppStyle].textFieldBgColor;
            [self addSubview:self.textField];
            break;
        case TextInputTypeButton:
            // 按钮
            self.sendButton = [RTSSAppStyle getMajorGreenButton:CGRectMake(25, 15, self.bounds.size.width - 50, 40) target:delegate action:@selector(submitButtonClick:) title:placeholder];
            self.sendButton.titleLabel.font = [RTSSAppStyle getRTSSFontWithSize:20];
            self.sendButton.enabled         = NO;
            [self addSubview:self.sendButton];
            UIImageView *downImageView      = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-1, self.bounds.size.width, 1)];
            downImageView.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
//            downImageView.image             = [UIImage imageNamed:@"common_separator_line.png"];
            [self addSubview:downImageView];
            [downImageView release];
            break;
        default:
            break;
    }
}


- (NSMutableAttributedString*)getAttributed:(NSString*)text
{
    NSMutableAttributedString* attributedString = [[[NSMutableAttributedString alloc] initWithString:text] autorelease];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[RTSSAppStyle currentAppStyle].textSubordinateColor
                             range:NSMakeRange(0, attributedString.length)];
    return attributedString;
}

@end


