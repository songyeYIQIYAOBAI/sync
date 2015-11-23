//
//  SupportViewController.m
//  RTSS
//
//  Created by Liuxs on 15-1-16.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "SupportViewController.h"
#import "RequestCallViewController.h"
#import "FAQViewController.h"
#import "LivechatViewController.h"
#import "InternationalControl.h"
#import "SupportModuleView.h"

@interface SupportViewController ()<BallViewDelegate>

@property (nonatomic, retain) UIView   *mFAQView;
@property (nonatomic, retain) UILabel  *mFAQTitleLabel;
@property (nonatomic, retain) UILabel  *mFAQMsgLabelOne;
@property (nonatomic, assign) BOOL     isStart;

@property (nonatomic, retain) BallView *mBallView;


@end

@implementation SupportViewController
@synthesize mBallView,mFAQView,mFAQTitleLabel,mFAQMsgLabelOne,isStart;
-(void)dealloc{

    [mFAQView        release];
    [mBallView       release];
    [mFAQTitleLabel  release];
    [mFAQMsgLabelOne release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isStart) {
        // 小球飞回原来的位置
        [self initAnimation];
    }else {
        self.isStart = YES;
    }
}

- (void)loadView
{
    [super loadView];
    
    [self layoutSupportView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = RTSSLocalizedString(@"Support_Center_Title", nil);
}

- (void)layoutSupportView
{
    // 放置5个圆圈的view的rect
    CGRect mButtonViewRect       = CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-110-60);
    // 下方FAQview
    CGRect mFAQViewRect          = CGRectMake(0, PHONE_UISCREEN_HEIGHT-110-60, PHONE_UISCREEN_WIDTH, 110);
    // 跳转FAQ界面的按钮
    CGRect fAQButtonRect         = CGRectMake(283, 16, 18, 18);
    // FAQ内容label
    CGRect mFAQMsgOneRect        = CGRectMake(0, 40, PHONE_UISCREEN_WIDTH, 52);
    // 问号
    CGRect mFAQQuestionMarkLabelRect  = CGRectMake(0, 0, 18, 18);
    // FAQ标题和内容字号
    UIFont *mFAQTitleFont        = [RTSSAppStyle getRTSSFontWithSize:16.0f];
    UIFont *mFAQMsgOneFont       = [RTSSAppStyle getRTSSFontWithSize:11.0f];
    UIFont *mFAQQuestionMarkFont = [RTSSAppStyle getRTSSFontWithSize:13.0f];
    CGFloat mFAQTitleTextSize    = 16.0f;
    CGFloat mFAQMsgOneTextSize   = 11.0f;
    // FAQlabel距离FAQview的高度
    CGFloat mFAQTitleY           = 15;
    
    NSString *mFAQTitleString    = NSLocalizedString(@"Support_Title_FAQ", nil);
    NSString *mFAQMsgOneString   = NSLocalizedString(@"Support_FAQ_Message", nil);
    
    if(PHONE_UISCREEN_IPHONE5){
        mButtonViewRect       = CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-128-60);
        mFAQViewRect          = CGRectMake(0, PHONE_UISCREEN_HEIGHT-128-60, PHONE_UISCREEN_WIDTH, 128);
        mFAQMsgOneRect        = CGRectMake(0, 45, PHONE_UISCREEN_WIDTH, 60);
        fAQButtonRect         = CGRectMake(278, 21, 18, 18);
        mFAQTitleY           = 20;
        
    }else if(PHONE_UISCREEN_IPHONE6){
        mButtonViewRect       = CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-163-60);
        mFAQViewRect          = CGRectMake(0, PHONE_UISCREEN_HEIGHT-163-60, PHONE_UISCREEN_WIDTH, 163);
        fAQButtonRect         = CGRectMake(328, 26, 22, 22);
        mFAQTitleY            = 25;
        mFAQMsgOneRect        = CGRectMake(0, 70, PHONE_UISCREEN_WIDTH, 54);
        mFAQQuestionMarkLabelRect  = CGRectMake(1, 1, 22, 22);
        mFAQTitleFont         = [RTSSAppStyle getRTSSFontWithSize:18.0f];
        mFAQMsgOneFont        = [RTSSAppStyle getRTSSFontWithSize:12.5f];
        mFAQQuestionMarkFont  = [RTSSAppStyle getRTSSFontWithSize:15.0f];
        mFAQTitleTextSize     = 18.0f;
        mFAQMsgOneTextSize    = 12.5f;
        
    }else if(PHONE_UISCREEN_IPHONE6PLUS){
        mButtonViewRect       = CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-180-60);
        mFAQViewRect          = CGRectMake(0, PHONE_UISCREEN_HEIGHT-180-60, PHONE_UISCREEN_WIDTH, 180);
        fAQButtonRect         = CGRectMake(360, 32, 30, 30);
        mFAQTitleY            = 35;
        mFAQMsgOneRect        = CGRectMake(0, 80, PHONE_UISCREEN_WIDTH, 54);
        mFAQQuestionMarkLabelRect  = CGRectMake(1, 1, 25, 25);
        mFAQTitleFont         = [RTSSAppStyle getRTSSFontWithSize:20.0f];
        mFAQMsgOneFont        = [RTSSAppStyle getRTSSFontWithSize:13.5f];
        mFAQQuestionMarkFont  = [RTSSAppStyle getRTSSFontWithSize:17.0f];
        mFAQTitleTextSize     = 20.0f;
        mFAQMsgOneTextSize    = 13.5f;
        
    }

    
    // 计算FAQ标题label大小
    CGSize mTitleSize = [CommonUtils calculateTextSize:mFAQTitleString constrainedSize:CGSizeMake(PHONE_UISCREEN_WIDTH, 30) textFont:mFAQTitleFont lineBreakMode:NSLineBreakByWordWrapping];
    // 计算label＋问号图片的总大小
    CGRect mFAQTitleViewRect = CGRectMake((PHONE_UISCREEN_WIDTH-(mTitleSize.width+7+mFAQQuestionMarkLabelRect.size.width))/2, mFAQTitleY, mTitleSize.width+7+mFAQQuestionMarkLabelRect.size.width, mFAQQuestionMarkLabelRect.size.height);
    
    CGRect mFAQTitleRect     = CGRectMake(7+mFAQQuestionMarkLabelRect.size.width, 1,mTitleSize.width, mFAQQuestionMarkLabelRect.size.height);
    
    
    // 初始化圆圈所在的view
    self.mBallView = [[[BallView alloc] initWithFrame:mButtonViewRect]autorelease];
    self.mBallView.backgroundColor = [UIColor clearColor];
    self.mBallView.delegate = self;
    [self.view addSubview:self.mBallView];
    [self initAnimation];
    
    
    // FAQ area -  one image two label
    // 初始化FAQ所在的view
    self.mFAQView = [[[UIView alloc] initWithFrame:mFAQViewRect]autorelease];
    self.mFAQView.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    [self.view addSubview:self.mFAQView];
    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(faqAction:)]autorelease];
    [self.mFAQView addGestureRecognizer:tap];

    
    // faq page
    // 跳转按钮
    UIButton *mFAQButton = [CommonUtils buttonWithType:UIButtonTypeCustom
                                                frame:fAQButtonRect
                                                title:nil
                                          imageNormal:[UIImage imageNamed:@"Support_FAQBtn.png"]
                                     imageHighlighted:[UIImage imageNamed:@"Support_FAQBtn.png"]
                                        imageSelected:nil
                                            addTarget:self
                                               action:@selector(faqAction:)
                                                  tag:5];
    
//    [mFAQButton setTitleColor:[RTSSAppStyle currentAppStyle].textSubordinateColor forState:UIControlStateNormal];
    [self.mFAQView addSubview:mFAQButton];
    
    
    UIImageView *mLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 1)];
//    [mLineImageView setImage:[UIImage imageNamed:@"common_separator_line.png"]];
    mLineImageView.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [self.mFAQView addSubview:mLineImageView];
    [mLineImageView release];
    
    
    // one photo one label
    //初始化FAQTitleLabel
    UIView *mFAQTitleView = [[UIView alloc] initWithFrame:mFAQTitleViewRect];
    
    // question mark label
    UILabel *mQuestionMarkLabel = [CommonUtils labelWithFrame:mFAQQuestionMarkLabelRect
                                                         text:@"?"
                                                    textColor:[RTSSAppStyle currentAppStyle].textBlueColor
                                                     textFont:mFAQQuestionMarkFont
                                                          tag:0];
    [mQuestionMarkLabel.layer setBorderColor: [[RTSSAppStyle currentAppStyle].textBlueColor CGColor]];
    [mQuestionMarkLabel.layer setCornerRadius:CGRectGetWidth([mQuestionMarkLabel bounds]) / 2];
    [mQuestionMarkLabel.layer setBorderWidth: 1.5];
    mQuestionMarkLabel.layer.masksToBounds = YES;
    [mFAQTitleView addSubview:mQuestionMarkLabel];
    
    // FAQ title label
    self.mFAQTitleLabel = [CommonUtils labelWithFrame:mFAQTitleRect
                                                 text:mFAQTitleString
                                            textColor:[RTSSAppStyle currentAppStyle].textBlueColor
                                             textFont:[RTSSAppStyle getRTSSFontWithSize:mFAQTitleTextSize]
                                                  tag:0];
    [mFAQTitleView addSubview:self.mFAQTitleLabel];
    [self.mFAQView addSubview:mFAQTitleView];
    [mFAQTitleView release];
    // FAQ message one label
    self.mFAQMsgLabelOne = [CommonUtils labelWithFrame:mFAQMsgOneRect
                                                  text:mFAQMsgOneString
                                             textColor:[RTSSAppStyle currentAppStyle].textSubordinateColor
                                              textFont:[RTSSAppStyle getRTSSFontWithSize:mFAQMsgOneTextSize]
                                                   tag:0];
    self.mFAQMsgLabelOne.numberOfLines = 3;
    [mFAQView addSubview:self.mFAQMsgLabelOne];
    
  
}
// 启动4个圆圈的动画属性
- (void)initAnimation
{
    [self.mBallView initAnimation];
    [self isLeftBarButtonItemEnabled:YES];
}


- (void)isLeftBarButtonItemEnabled:(BOOL)isEnabled
{
    UIBarButtonItem* backBarButtonItem = self.navigationItem.leftBarButtonItem;
    backBarButtonItem.enabled = isEnabled;
}

// 4个圆圈的点击及移动后的实现
- (void)jumpToLogoAnimationCompletion:(SupportBallType)buttonTag
{
    switch (buttonTag) {
        case SupportBallTypeEmail:
        {
            NSLog(@"Email");
            NSURL* mailUrl = [NSURL URLWithString:@"mailto://contactus@superoperator.com"];
            if([[UIApplication sharedApplication] canOpenURL:mailUrl]){
                [[UIApplication sharedApplication] openURL:mailUrl];
            }
            [self performSelector:@selector(initAnimation) withObject:nil afterDelay:2];
            break;
        }
        case SupportBallTypeRequestCall:
            NSLog(@"Request call");
            RequestCallViewController *requestCallViewController = [[RequestCallViewController alloc] init];
            [self.navigationController pushViewController:requestCallViewController animated:YES];
            [requestCallViewController release];
            break;
        case SupportBallTypeLiveChat:
            NSLog(@"Live chat");
            LivechatViewController *livechatViewController = [[LivechatViewController alloc] init];
            [self.navigationController pushViewController:livechatViewController animated:YES];
            [livechatViewController release];
            break;
        case SupportBallTypeCallUs:
            NSLog(@"Call Us");
            NSURL* telUrl = [NSURL URLWithString:@"tel://10086"];
            if([[UIApplication sharedApplication] canOpenURL:telUrl]){
                [[UIApplication sharedApplication] openURL:telUrl];
            }
            [self performSelector:@selector(initAnimation) withObject:nil afterDelay:2];
            break;
        
        default:
            break;
    }

}

// FAQ界面跳转
- (void)faqAction:(UIButton *)button
{
    FAQViewController *faqViewController = [[FAQViewController alloc] init];
    UINavigationController *navigationController = [[RTSSAppStyle currentAppStyle] getRTSSNavigationController:faqViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
    [faqViewController release];
}


//修改显示的内容(貌似没必要)
-(void)changeLanguage
{
    self.title = RTSSLocalizedString(@"Support_Title", nil);
    
    NSString *mFAQTitleString    = RTSSLocalizedString(@"Support_Title_FAQ", nil);
    NSString *mFAQMsgOneString   = RTSSLocalizedString(@"Support_FAQ_Message", nil);
    
    UIFont *mFAQTitleFont        = [UIFont boldSystemFontOfSize:13.0f];
    CGRect mFAQQuestionMarkRect  = CGRectMake(0, 0, 20, 20);
    CGFloat mFAQTitleY           = 10;
    if (PHONE_UISCREEN_IPHONE6) {
        mFAQQuestionMarkRect  = CGRectMake(0, 0, 24, 24);
        mFAQTitleY            = 12;
    }
    CGSize mTitleSize    = [CommonUtils calculateTextSize:mFAQTitleString constrainedSize:CGSizeMake(PHONE_UISCREEN_WIDTH, 30) textFont:mFAQTitleFont lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect mFAQTitleRect = CGRectMake(7+mFAQQuestionMarkRect.size.width, 1,mTitleSize.width, mFAQQuestionMarkRect.size.height);
    self.mFAQTitleLabel.frame = mFAQTitleRect;
    self.mFAQTitleLabel.text  = mFAQTitleString;
    self.mFAQMsgLabelOne.text = mFAQMsgOneString;
}

@end
