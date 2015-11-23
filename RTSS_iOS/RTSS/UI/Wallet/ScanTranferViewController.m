//
//  ScanTranferViewController.m
//  RTSS
//
//  Created by 蔡杰 on 14-10-27.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "ScanTranferViewController.h"
#import "UIView+RTSSAddView.h"
#import "RTSSKeyBoardView.h"
#import "PortraitImageView.h"

#import "RTSSAppDefine.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"

#import "Customer.h"
#import "Account.h"
#import "AlertController.h"

#define kRTSSHeardImageViewWidth 60

@interface ScanTranferViewController ()<RTSSKeyBoardViewDelegate,MappActorDelegate>{
    
    UIImageView *headImageView;
    UILabel *nameLabel;
    UILabel *tipsLabel;
    
    Customer *customer;
}

@property(retain,nonatomic)RTSSKeyBoardView *keyBoardView;

@end

@implementation ScanTranferViewController

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_keyBoardView release];
    
    [super dealloc];
}

#pragma mark --Life
-(void)loadView{
    [super loadView];
    
    [self.view setViewBlackColor];
    
    [self layoutBackgroundView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Scan Transfer", nil);
    
    if(self.keyBoardView == nil){
        self.keyBoardView = [[RTSSKeyBoardView alloc]initWithFrame:CGRectMake(0,PHONE_UISCREEN_HEIGHT-50, PHONE_UISCREEN_WIDTH, 50)];
        self.keyBoardView.delegate = self;
    }
    self.keyBoardView.backgroundColor = [UIColor whiteColor];
    [self.keyBoardView.textField becomeFirstResponder];
    self.keyBoardView.textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.keyBoardView];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --InstallSubviews
- (void)layoutBackgroundView
{
    [self.view addTopViewWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 200)];

    //头像
    headImageView = [[PortraitImageView alloc] initWithFrame:CGRectMake(PHONE_UISCREEN_WIDTH/2 - kRTSSHeardImageViewWidth/2,15,kRTSSHeardImageViewWidth,kRTSSHeardImageViewWidth) image:[UIImage imageNamed:@"common_head_icon_d"] borderColor:nil borderWidth:0];
    [self.view addSubview:headImageView];
    
    nameLabel = [CommonUtils labelWithFrame:CGRectMake(CGRectGetMidX(headImageView.frame)-100, CGRectGetMaxY(headImageView.frame)+10, 200, 20) text:@"" textColor:[UIColor whiteColor] textFont:[RTSSAppStyle getRTSSFontWithSize:15] tag:0];
    [self.view addSubview:nameLabel];
    
    tipsLabel = [CommonUtils labelWithFrame:CGRectMake(CGRectGetMidX(headImageView.frame)-100, CGRectGetMaxY(nameLabel.frame)+10, 200, 20) text:@"" textColor:[UIColor whiteColor] textFont:[RTSSAppStyle getRTSSFontWithSize:13] tag:0];
    [self.view addSubview:tipsLabel];
}

-(void)loadData{
    //nameLabel.text = @"Ken";
    //tipsLabel.text = @"Transfer to Ken";
    if (!customer) {
        customer = [[Customer alloc] init];
    }
//    sub.mMdn = self.mdn;
//    [customer syncProperty:self];
}

-(void)syncSubscriberInfoFinished:(NSInteger)status message:(NSString *)message{
    if (status == 0) {
        nameLabel.text = customer.mName;
        tipsLabel.text = [NSString stringWithFormat:@"Transfer to %@",customer.mName];
        
        if ([customer.mPortrait length] > 0) {
            [headImageView  setImage:[UIImage imageNamed:customer.mPortrait]];
        }
    }else{
        NSLog(@"转化为换取用户信息");
    }
}

#pragma mark --RTSSKeyBoardViewDelelgate
-(void)keyBoardViewPayBalance:(CGFloat)balance{
    NSLog(@"信息提交");
    // [AlertController showSimpleAlertWithTitle:nil message:@"Balance is successfully transferred." buttonTitle:@"Sure" inViewController:self] ;
   // NSString *mds = self.mdn;
    Account *acount = [[Account alloc]init];
//    [acount transferBalance:balance to:mds delegate:self];
   // [acount transferBalance:balance toPeer:mds inPeer:@"" delegate:self];
    [acount release];
}

#pragma mark -- Account MappActorDelegate
-(void)transferBalanceFinished:(NSInteger)status message:(NSString *)message{
    if (status == 0) {
        //[AlertController showSimpleAlertWithTitle:nil message:@"Balance is successfully transferred." buttonTitle:@"Sure" inViewController:self] ;
        AlertController *alert = [[AlertController alloc]initWithTitle:nil message:@"Balance is successfully transferred." delegate:self tag:0 cancelButtonTitle:@"Sure" otherButtonTitles:nil];
        [alert showInViewController:self];
        [alert release];
    }else{
        [AlertController showSimpleAlertWithTitle:nil message:message buttonTitle:@"Sure" inViewController:self] ;
    }
}

#pragma mark --AlertDelagate
-(void)alertController:(AlertController *)alertController didDismissWithButtonIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
