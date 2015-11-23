//
//  TextInputView.m
//  RTSS
//
//  Created by Liuxs on 15-2-7.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "TextInputView.h"
#import "InternationalControl.h"
#import "RTSSAppStyle.h"
#import "RTSSAppDefine.h"

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
@synthesize dynamicAnimator,gravityBehavior,collisionBehavior,suspendBehavior,touchBehavior,itemBehavior,portraitPoint,borderColor,mTitleLabel;

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
        self.image = image;
        self.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
        // 设置边框颜色
        [self.layer setBorderColor: [[RTSSAppStyle currentAppStyle].textMajorColor CGColor]];
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


- (void)layoutTitleLabelWithFrame:(CGRect)frame title:(NSString *)text
{
    self.mTitleLabel = [[[UILabel alloc] initWithFrame:frame]autorelease];
    self.mTitleLabel.text = text;
    self.mTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.mTitleLabel.font = [UIFont systemFontOfSize:9.0];
    self.mTitleLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    //        [self addSubview:self.mTitleLabel];
}


// 启动动画属性
- (void)initAnimation
{
    [self.layer setBorderColor: [[RTSSAppStyle currentAppStyle].textMajorColor CGColor]];
    [self.dynamicAnimator addBehavior:self.suspendBehavior];
    [self.dynamicAnimator addBehavior:self.gravityBehavior];
    [self.dynamicAnimator addBehavior:self.collisionBehavior];
    //    [self.dynamicAnimator addBehavior:self.itemBehavior];
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
    self.itemBehavior.friction   = 0.5;
    self.itemBehavior.resistance = 0.3;
    self.itemBehavior.density    = 5;
    self.itemBehavior.allowsRotation = NO;
    
    // ==
    self.gravityBehavior = [[[UIGravityBehavior alloc] initWithItems:@[self]]autorelease];
    self.gravityBehavior.gravityDirection = CGVectorMake(0, 1);
    
    // ==
    self.collisionBehavior = [[[UICollisionBehavior alloc] initWithItems:@[self]]autorelease];
    [self.collisionBehavior setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(-100, -100, -100, -100)];
    self.collisionBehavior.translatesReferenceBoundsIntoBoundary=YES;
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
    //    [self.dynamicAnimator addBehavior:self.itemBehavior];
    
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
@end

@implementation BallView
@synthesize delegate,logoView,mEmailImageView,mRequestImageView,mLiveImageView,mCallImageView;

- (void)dealloc
{
    [logoView          release];
    [mEmailImageView   release];
    [mRequestImageView release];
    [mLiveImageView    release];
    [mCallImageView    release];
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
    CGRect logoRect        = CGRectMake((self.bounds.size.width-100)/2, (self.bounds.size.height-100)/2, 100, 100);
    
    CGRect mEmailRect      = CGRectMake(77, 55, 77, 77);
    CGRect mRequestRect    = CGRectMake(200, 49, 77, 77);
    CGRect mLiveRect       = CGRectMake(17, 185, 77, 77);
    CGRect mCallRect       = CGRectMake(223, 230, 77, 77);
    CGRect mTitleLabelRect = CGRectMake(10, 45, 57, 15);
    if (PHONE_UISCREEN_IPHONE5) {
        logoRect     = CGRectMake((self.bounds.size.width-80)/2, (self.bounds.size.height-80)/2, 80, 80);
        
        mEmailRect   = CGRectMake(77, 99, 77, 77);
        mRequestRect = CGRectMake(200, 93, 77, 77);
        mLiveRect    = CGRectMake(17, 229, 77, 77);
        mCallRect    = CGRectMake(223, 274, 77, 77);
    }else if (PHONE_UISCREEN_IPHONE6) {
        logoRect     = CGRectMake((self.bounds.size.width-120)/2, (self.bounds.size.height-120)/2, 120, 120);
        
        mEmailRect   = CGRectMake(80, 119, 100, 100);
        mRequestRect = CGRectMake(214, 112, 100, 100);
        mLiveRect    = CGRectMake(18, 252, 100, 100);
        mCallRect    = CGRectMake(242, 327, 100, 100);
    }
    
    
    // 中心圆圈
    self.logoView = [[[UIImageView alloc] initWithFrame:logoRect] autorelease];
    self.logoView.image = [UIImage imageNamed:@"support_center_icon.png"];
    //self.logoView.layer.cornerRadius = CGRectGetWidth(logoRect) / 2.f;
    //self.logoView.layer.masksToBounds = YES;
    [self addSubview:self.logoView];
    
    // ==

    self.mEmailImageView = [[[BallImageView alloc] initWithFrame:mEmailRect backgroundImage:[UIImage imageNamed:@"support_email_icon.png"] withReferenceView:self] autorelease];
    [self.mEmailImageView layoutTitleLabelWithFrame:mTitleLabelRect title:RTSSLocalizedString(@"Support_Button_Title_Email", nil)];
    self.mEmailImageView.borderColor = [RTSSAppStyle currentAppStyle].textMajorGreenColor;
    self.mEmailImageView.tag      = 10001;
    self.mEmailImageView.delegate = self;
    [self addSubview:self.mEmailImageView];
    // ==

    self.mRequestImageView = [[[BallImageView alloc] initWithFrame:mRequestRect backgroundImage:[UIImage imageNamed:@"support_request_call_icon.png"] withReferenceView:self] autorelease];
    [self.mLiveImageView layoutTitleLabelWithFrame:mTitleLabelRect title:RTSSLocalizedString(@"Support_Title_RequestCall", nil)];
    self.mRequestImageView.borderColor = [RTSSAppStyle currentAppStyle].walletTitleOrgangeColor;
    self.mRequestImageView.tag      = 10002;
    self.mRequestImageView.delegate = self;
    [self addSubview:self.mRequestImageView];
    // ==

    self.mLiveImageView = [[[BallImageView alloc] initWithFrame:mLiveRect backgroundImage:[UIImage imageNamed:@"support_livechat_icon.png"] withReferenceView:self] autorelease];
    [self.mLiveImageView layoutTitleLabelWithFrame:mTitleLabelRect title:RTSSLocalizedString(@"Support_Button_Title_liveChat", nil)];
    self.mLiveImageView.borderColor = [RTSSAppStyle currentAppStyle].walletTitleBlueColor;
    self.mLiveImageView.tag      = 10003;
    self.mLiveImageView.delegate = self;
    [self addSubview:self.mLiveImageView];
    // ==

    self.mCallImageView = [[[BallImageView alloc] initWithFrame:mCallRect backgroundImage:[UIImage imageNamed:@"support_callus_icon.png"] withReferenceView:self] autorelease];
    self.mCallImageView.borderColor = [RTSSAppStyle getFreeResourceColorWithIndex:3];
    [self.mEmailImageView layoutTitleLabelWithFrame:mTitleLabelRect title:RTSSLocalizedString(@"Support_Button_Title_CallUs", nil)];
    self.mCallImageView.tag      = 10004;
    self.mCallImageView.delegate = self;
    [self addSubview:self.mCallImageView];
    
}
// 启动各自动画属性
- (void)initAnimation{
    
    [self.mEmailImageView   initAnimation];
    [self.mRequestImageView initAnimation];
    [self.mLiveImageView    initAnimation];
    [self.mCallImageView    initAnimation];
    
}

// 点击圆圈
- (void)tap:(UITapGestureRecognizer *)recognizer
{
    BallImageView *ballImage = (BallImageView *)recognizer.view;
    [ballImage removeAllBehaviors];
    [self jumpToLogoAnimation:ballImage];
}

// 圆圈手势监听
- (void)pannedGesture:(UIPanGestureRecognizer*)gesture
{
    BallImageView *ballImage = (BallImageView *)gesture.view;
    CGPoint location = [gesture locationInView:self];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            [ballImage GestureRecognizerStateBegan];
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
                [ballImage removeTouchBehavior];
            }
            
            if(CGRectContainsPoint(self.logoView.frame, location)){
                [ballImage removeAllBehaviors];
                [self jumpToLogoAnimation:ballImage];
            }else{
                [ballImage initAnimation];
            }
            
            break;
        }
            
        default:
            break;
    }
}

// 移动到中间圆圈区域
- (void)jumpToLogoAnimation:(BallImageView *)imageView{
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
    UIImageView *upImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 2)];
    upImageView.image        = [UIImage imageNamed:@"common_separator_line.png"];
    [self addSubview:upImageView];
    [upImageView release];
    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:delegate action:@selector(tap:)]autorelease];
    [self addGestureRecognizer:tap];
    [self layoutViewTarget:delegate placeholder:placeholder ReturnKeyType:returnKeyType];
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
            UIImageView *arrowImage      = [[UIImageView alloc] initWithFrame:CGRectMake(0, 12, 17, 17)];
            arrowImage.image             = [UIImage imageNamed:@"Static_Support_arrow.png"];
            [self.textField.rightView addSubview:arrowImage];
            [arrowImage release];
            self.textField.delegate      = delegate;
            self.textField.attributedPlaceholder = [self getAttributed:placeholder];
            self.textField.font          = [UIFont boldSystemFontOfSize:14.0];
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
            self.textField.font                  = [UIFont boldSystemFontOfSize:14.0];
            self.textField.textColor             = [RTSSAppStyle currentAppStyle].textMajorColor;
            self.textField.backgroundColor       = [RTSSAppStyle currentAppStyle].textFieldBgColor;
            [self addSubview:self.textField];
            break;
        case TextInputTypeButton:
            // 按钮
            self.sendButton = [RTSSAppStyle getMajorGreenButton:CGRectMake(25, 15, self.bounds.size.width - 50, 40) target:delegate action:@selector(submitButtonClick:) title:placeholder];
            self.sendButton.titleLabel.font = [UIFont systemFontOfSize:20];
            self.sendButton.enabled         = NO;
            [self addSubview:self.sendButton];
            UIImageView *downImageView      = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-2, self.bounds.size.width, 2)];
            downImageView.image             = [UIImage imageNamed:@"common_separator_line.png"];
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


