//
//  PayCodeViewController.m
//  RTSS
//
//  Created by caijie on 14/10/23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "PayCodeViewController.h"
#import "UIView+RTSSAddView.h"
#import "UIImage+QRenCodeImage.h"
#import "RTSSAppDefine.h"
#import "CommonUtils.h"
#import "Session.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"
#import  "MManager.h"

#define  kRTSSQRHeight  200

@interface PayCodeViewController (){
    
    UIImageView *qrImageView;
}

@end

@implementation PayCodeViewController

- (void)dealloc{
    [qrImageView release];
    [super dealloc];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
#pragma mark --Life
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView{
    [super loadView];
    
    [self.view setViewBlackColor];
    //loading ImageView
    qrImageView = [[UIImageView alloc]init];
    //CGFloat distance = 180; //偏离center的距离
    //高度和宽度相等
    qrImageView.frame = CGRectMake((PHONE_UISCREEN_WIDTH - kRTSSQRHeight)/2, self.view.center.y -kRTSSQRHeight , kRTSSQRHeight, kRTSSQRHeight);
    qrImageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:qrImageView];
    
    //tips
    if (![self.tips length]>0) {
        self.tips = @"Your friends can transfer money to you by scanning this barcode";
    }
 
   UILabel *tipsLabel =  [CommonUtils labelWithFrame:CGRectMake(0, CGRectGetMaxY(qrImageView.frame)+15, PHONE_UISCREEN_WIDTH, 40) text:self.tips textColor:[UIColor colorWithRed:184.0/255 green:194.0/255 blue:73.0/255 alpha:1.0] textFont:[RTSSAppStyle getRTSSFontWithSize:15.0f] tag:0];
    [self.view addSubview:tipsLabel];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Scan";
   
}

- (void)loadData{
    
    Session *session = [[MManager sharedMManager] getSession];
    NSString *phoneNumber = session.mMyUser.mPhoneNumber;
    
    if (![CommonUtils objectIsValid:phoneNumber]) {
        [APPLICATION_KEY_WINDOW makeToast:@"生成二维码失败"];
        return;
    }
    UIImage *qrImage = [UIImage createNonInterpolatedUIImageFormCIImage:[UIImage createQRForString:phoneNumber] withSize:kRTSSQRHeight];
    qrImageView.image = qrImage;
    return;


}

@end
