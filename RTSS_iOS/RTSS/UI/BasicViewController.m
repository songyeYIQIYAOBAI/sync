//
//  BasicViewController.m
//  RTSS
//
//  Created by shengyp on 14/10/21.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "BasicViewController.h"
#import "InternationalControl.h"

@interface BasicViewController ()

@end

@implementation BasicViewController
@synthesize navigationBackButton, navigationSeparatorView;

- (void)dealloc{
   // [self removeApplicationChangeLanguageNotification];
    
    [navigationBackButton release];
    [navigationBarView release];
    [navigationSeparatorView release];
    
    [super dealloc];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark loadView

- (UIButton*)getBackButton:(CGRect)buttonFrame{
    self.navigationBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.navigationBackButton.backgroundColor = [UIColor clearColor];
    self.navigationBackButton.exclusiveTouch = YES;
    [self.navigationBackButton setImage:[UIImage imageNamed:@"common_navigation_back_d.png"] forState:UIControlStateNormal];
    [self.navigationBackButton setImage:[UIImage imageNamed:@"common_navigation_back_a.png"] forState:UIControlStateHighlighted];
    [self.navigationBackButton addTarget:self action:@selector(backBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBackButton.frame = buttonFrame;
    return self.navigationBackButton;
}

- (UIView*)addNavigationBarView:(NSString*)title bgColor:(UIColor*)bgColor separator:(BOOL)separator{
    if(nil == navigationBarView){
        navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 20+44)];
        navigationBarView.backgroundColor = bgColor;
    }

    if(separator && nil == navigationSeparatorView){
        navigationSeparatorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(navigationBarView.frame)-1, CGRectGetWidth(navigationBarView.frame), 1)];
        navigationSeparatorView.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
        [navigationBarView addSubview:navigationSeparatorView];
    }

    UILabel* navigationBarLabel = [CommonUtils labelWithFrame:CGRectMake(0, 20, CGRectGetWidth(navigationBarView.frame), 44) text:title textColor:[[RTSSAppStyle currentAppStyle] textMajorColor] textFont:[RTSSAppStyle getRTSSFontWithSize:20.0] tag:0];
    navigationBarLabel.backgroundColor = [UIColor clearColor];
    [navigationBarView addSubview:navigationBarLabel];
    
    if([self.navigationController.viewControllers count] > 1){
        [navigationBarView addSubview:[self getBackButton:CGRectMake(16, 20, 40, 44)]];
    }
    
    return navigationBarView;
}

-(void)loadView{
    [super loadView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    
    if([self.navigationController.viewControllers count] > 1){
        UIBarButtonItem* backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[self getBackButton:CGRectMake(0, 0, 40, 44)]];
        self.navigationItem.leftBarButtonItem = backBarButtonItem;
        [backBarButtonItem release];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // [self addApplicationChangeLanguageNotification];
    
    [self loadData];
}

#pragma mark loadData
- (void)loadData
{
    
}

- (void)addApplicationChangeLanguageNotification
{
    //注册通知，用于接收改变语言的通知
    [[RTSSNotificationCenter standardRTSSNotificationCenter] addNotificationWithType:RTSSNotificationTypeApplicationChangeLanguage observer:self selector:@selector(applicationChangeLanguage:) object:nil];
}

- (void)removeApplicationChangeLanguageNotification
{
    [[RTSSNotificationCenter standardRTSSNotificationCenter] removeNotificationWithType:RTSSNotificationTypeApplicationChangeLanguage observer:self object:nil];
}

- (BOOL)setApplicationLanguage:(NSString *)languageName
{
    BOOL result = [[InternationalControl standerControl] setUserlanguage:languageName];
    if(result){
        //改变完成之后发送通知，告诉其他页面修改完成，提示刷新界面
        [[RTSSNotificationCenter standardRTSSNotificationCenter] postNotificationWithType:RTSSNotificationTypeApplicationChangeLanguage object:nil userInfo:nil];
    }
    return result;
}

- (void)applicationChangeLanguage:(NSNotification*)notification
{
    /*如:
     self.title = RTSSLocalizedString(@"title", nil);
     [self.mButton setTitle:RTSSLocalizedString(@"button", nil) forState:UIControlStateNormal];
     self.mLabel.text = RTSSLocalizedString(@"label", nil);
     */
}

#pragma mark action
- (void)backBarButtonAction:(UIButton*)barButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
