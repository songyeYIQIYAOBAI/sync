//
//  BankCardManageViewController.m
//  RTSS
//
//  Created by caijie on 14/10/23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "BankCardManageViewController.h"
#import "UIView+RTSSAddView.h"

#import "AddCardViewController.h"
#import "BankCardUnitView.h"
#import "RTSSAppStyle.h"


@interface BankCardManageViewController ()<BankCardUnitViewDelagate>{
    BankCardUnitView *bankCardUnitView;
}

@end

@implementation BankCardManageViewController

- (void)dealloc{
    
    [bankCardUnitView release];
    
    [super dealloc];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark  --Life
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView{
    [super loadView];
    [self.view setViewBlackColor];
    [self  intallSubViews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"My Cards";
}

- (void)loadData{
    
     [bankCardUnitView reloaDataWithArray:@[@"1"]];
}

#pragma  mark --installView
-(void)intallSubViews{
    
    bankCardUnitView = [[BankCardUnitView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-80)];
    bankCardUnitView.delagte = self;
    [bankCardUnitView setScrollViewBgColor:[RTSSAppStyle currentAppStyle].viewControllerBgColor];
    [bankCardUnitView setAddButtonBgColor:[RTSSAppStyle currentAppStyle].navigationBarColor];
    [bankCardUnitView setViewBlackColor];
    [self.view addSubview:bankCardUnitView];
}
- (void)layoutBackgroundView
{
    UIView* containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-20-44)];
    containerView.backgroundColor = [UIColor clearColor];
    self.view = containerView;
    [containerView release];
    
    // background
    UIImageView* background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Static_Wallet_bind_bank_card"]];
    background.frame = CGRectMake(0,0,PHONE_UISCREEN_WIDTH,PHONE_UISCREEN_HEIGHT-20-44);
    [containerView addSubview:background];
    [background release];
    
    UIButton* addCardBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 205, PHONE_UISCREEN_WIDTH, 100)];
    [addCardBtn addTarget:self action:@selector(bankCardUnitAddcard) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:addCardBtn];
    
}
#pragma mark --BankCardDegate
-(void)bankCardUnitAddcard{
    
    AddCardViewController *addcard = [[AddCardViewController alloc] init];
    [self.navigationController pushViewController:addcard animated:YES];
    [addcard release];
}


@end
