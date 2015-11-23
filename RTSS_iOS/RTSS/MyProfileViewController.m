//
//  MyProfileViewController.m
//  RTSS
//
//  Created by 宋野 on 14-11-21.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "MyProfileViewController.h"
#import "MyProfileView.h"
#import "RTSSAppStyle.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface MyProfileViewController (){
    TPKeyboardAvoidingScrollView * scrollView;
    MyProfileView * myProfileView ;
}

@end

@implementation MyProfileViewController

- (void)dealloc{
    
    [myProfileView release];
    [scrollView release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadView{
    [super loadView];
    [self initViews];
}

- (void)loadData{
    MyProfileModelItem * model = [[[MyProfileModelItem alloc] init] autorelease];
    model.itemName = @"Paul 速度发生的发生都发生的发生都发生的发生地方";
    model.itemBillingAdress = @"Room 402,Unit 1 Building阿萨德发生的发生都发生的发生的发生地方";
    model.itemBirthDate = @"1990_09_08";
    model.itemEmailID = @"paul@asiainfo.com";
    model.itemPhoneNumber = @"18816897828";
    model.itemAnniversaryDate = @"2014-11-24";
    model.itemPayment = @"Preferred mode of payment";
    model.itemCommunication = @"Preferred mode of communication";
    model.itemLanguage = @"Preferred language";
    
    [myProfileView addViewWithModel:model];
    [scrollView contentSizeToFit];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"My Profile";
}

- (void)initViews{
    scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-20-44)];
    scrollView.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    scrollView.userInteractionEnabled = YES;
    [self.view addSubview:scrollView];
    
    myProfileView = [[MyProfileView alloc] initWithFrame:scrollView.bounds];
    [myProfileView.saveButton addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [myProfileView.emailID.actionBtn addTarget:self action:@selector(emailIDClick:) forControlEvents:UIControlEventTouchUpInside];
    [myProfileView.phoneNumber.actionBtn addTarget:self action:@selector(phoneNumberClick:) forControlEvents:UIControlEventTouchUpInside];
    [myProfileView.anniversaryDate.actionBtn addTarget:self action:@selector(anniversaryDateClick:) forControlEvents:UIControlEventTouchUpInside];
    [myProfileView.communication.actionBtn addTarget:self action:@selector(communicationClick:) forControlEvents:UIControlEventTouchUpInside];
    [myProfileView.payment.actionBtn addTarget:self action:@selector(paymentClick:) forControlEvents:UIControlEventTouchUpInside];
    [myProfileView.language.actionBtn addTarget:self action:@selector(languageClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:myProfileView];
}

#pragma mark Action
- (void)saveButtonClick:(UIButton *)button{
    NSLog(@"save Button click");
}

- (void)emailIDClick:(UIButton *)button{
    [myProfileView.emailID.textField becomeFirstResponder];
    NSLog(@"emailID clicked");
}

- (void)phoneNumberClick:(UIButton *)button{
    NSLog(@"phoneNumber Click");

}

- (void)anniversaryDateClick:(UIButton *)button{
    NSLog(@"anniversaryDate Click");

}

- (void)communicationClick:(UIButton *)button{
    NSLog(@"communication Click");

}

- (void)paymentClick:(UIButton *)button{
    NSLog(@"payment clicked");
}

- (void)languageClick:(UIButton *)button{
    NSLog(@"language Click");
}

@end
