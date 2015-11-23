//
//  WalletViewController.m
//  RTSS
//
//  Created by caijie on 14/10/23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "WalletViewController.h"
#import "RTSSWalletRelation.h"
#import "UIView+RTSSAddView.h"
#import "RTSSModuleView.h"
#import "RTSSWalletManagerRes.h"
#import "BalanceTransferViewController.h"
#import "ServiceTopUpViewController.h"
#import "ScanViewController.h"
#import "ScanTranferViewController.h"

#import "RTSSAppStyle.h"


#define kRTSSTopViewHeight          210
#define kRTSSTopEdge                10
//待定
#define kRTSSModuleViewLRspace
//上下间距
#define kRTSSModuleViewTopSpace     20
//左右间距
#define KRTSSModuleViewInternalSpace   50
//宽
#define KRTSSModuleViewWith       100
//高
#define KRTSSModuleViewHeight      80

@interface WalletViewController ()

@end

@implementation WalletViewController{
    
    BOOL flag;
}

#pragma mark --life
- (void)dealloc{
    
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

- (void)loadView{
    [super loadView];
    
    [self installSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    flag = NO;
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    if (flag == NO) {
         self.navigationController.navigationBarHidden = NO;
    }
   
}
- (void)loadData{

}

#pragma mark --InstallViews
-(void)installSubviews{
    [self.view setViewBlackColor];
    
    //topView  深色部分
    [self.view addTopViewWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, kRTSSTopViewHeight)];
    
    [self.view addSubview:[self addNavigationBarView:@"Wallet" bgColor:[RTSSAppStyle currentAppStyle].navigationBarColor separator:NO]];
    
    //add SubView
     CGFloat navHeight = CGRectGetMaxY(navigationBarView.frame);
    // 深色部分  扫描 和二维码生成
    for(int i= 0;i < 2; i++) {
        //布局时 一个moduleView占屏幕宽一半，子视图内部调整
        RTSSModuleView *moduleView = [[RTSSModuleView alloc]initWithFrame:CGRectMake((i%2)*PHONE_UISCREEN_WIDTH/2,navHeight,PHONE_UISCREEN_WIDTH/2, kRTSSTopViewHeight-navHeight)];
        
        //调节文本颜色
        if (i == 0) [moduleView setTitleColor:[RTSSAppStyle currentAppStyle].walletTitleOrgangeColor];
        if (i == 1) [moduleView setTitleColor:[RTSSAppStyle currentAppStyle].walletTitleBlueColor];
        [moduleView setButtonTag:kRTSSBasicButtonTag + i  Target:self Action:@selector(userAction:)];
        [self.view addSubview:moduleView];
        [moduleView release];
    }
    
    //分类
     NSInteger line = 2;//一行
    CGFloat width = PHONE_UISCREEN_WIDTH/line ;
    CGFloat height = 80.0f;
    for(int i= 0;i < line; i++) {
        //布局时 一个moduleView占屏幕宽一半，子视图内部调整
        RTSSModuleView *moduleView = [[RTSSModuleView alloc] initWithFrame:CGRectMake((i%line)*width,(i/line)*height+kRTSSTopViewHeight,width, height)];
        [moduleView setButtonTag:kRTSSBasicButtonTag +i+2 Target:self Action:@selector(userAction:)];
        [self.view addSubview:moduleView];
        [moduleView release];
    }
}

#pragma mark --Action
-(void)userAction:(id)sender{
    UIButton *button = (UIButton*)sender;
    NSLog(@"ViewController = %@",[RTSSWalletManagerRes obtainClassNameWithType:button.tag-kRTSSBasicButtonTag]);
    //根据tag生成类字符串
    NSString *classString = [RTSSWalletManagerRes obtainClassNameWithType:button.tag-kRTSSBasicButtonTag];
    UIViewController *userViewController = [[NSClassFromString(classString) alloc] init];
    
    //判断是否是扫描界面
    if ([userViewController isKindOfClass:NSClassFromString(@"ScanViewController")]) {
        ScanViewController *scan = [[ScanViewController alloc] init];
        flag = YES;
        __block typeof(self) weakSelf = self;
       [scan setSuccessBlock:^(NSString *stringValue) {
          
         [weakSelf scanTranferPay:stringValue];
           
       }];
        [self presentViewController:scan animated:YES completion:^{
            
        }];
        [scan release];
         scan = nil;
        return;
    }else{
        
        [self.navigationController pushViewController:userViewController animated:YES];
        [userViewController release];
        userViewController = nil;
    }
}

-(void)scanTranferPay:(NSString *)userInfo{
    NSLog(@"userinfo = %@",userInfo);
    if (![userInfo length] > 0) {
        return;
    }
    
    BalanceTransferViewController *balance = [[BalanceTransferViewController alloc]init];
    balance.mdn = userInfo;
    balance.flag = YES;
   // ScanTranferViewController *scanTranfer = [[ScanTranferViewController alloc]init];
    //scanTranfer.mdn = userInfo;
    [self.navigationController pushViewController:balance animated:NO];
    [balance release];
}

/*
-(void)scanTransfer:(NSString *accountString){
    
    ScanTranferViewController *scanTransfer = [[ScanTranferViewController alloc]init];
    
    [self.navigationController pushViewController:scanTransfer animated:YES];
    
    [scanTransfer release];
    
    scanTransfer = nil;
    
    

}
 */

@end
