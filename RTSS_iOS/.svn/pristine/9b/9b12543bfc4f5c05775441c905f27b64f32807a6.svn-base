//
//  PassWordViewViewController.m
//  RTSS
//
//  Created by 蔡杰 on 14-11-3.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "PassWordViewViewController.h"
#import "PasswordInputView.h"
#import "RTSSAppDefine.h"
#import "UIView+RTSSAddView.h"
#import "SJBKeyboardView.h"
#import "RTSSAppDefine.h"



@interface PassWordViewViewController ()<SJBKeyboardDelegate>{
    
    PasswordInputView *passwordInput;
    
}




@end

@implementation PassWordViewViewController

#pragma mark --Life

-(void)dealloc{
    
    [passwordInput release];
    [super dealloc];
}

-(void)loadView{
    
    [super loadView];
    [self.view  setViewBlackColor];
    [self installSubviews];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"PassWord";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --InstallSuviews

-(void)installSubviews{
    
    
    CGFloat edge = 20.f;
    CGFloat passWordHeight = 180;
    passwordInput = [[PasswordInputView alloc]initWithFrame:CGRectMake(edge, edge+64,PHONE_UISCREEN_WIDTH - 2*edge, passWordHeight)];
    passwordInput.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:passwordInput];
    CGFloat keyboardHeight = 280;
    
    SJBKeyboardView *keyBoardView = [[SJBKeyboardView alloc]initWithFrame:CGRectMake(0, PHONE_UISCREEN_HEIGHT-keyboardHeight+64, PHONE_UISCREEN_WIDTH, keyboardHeight) viewType:SJBKeyboardViewNumber];
    keyBoardView.delegate = self;
    [self.view addSubview:keyBoardView];
    [keyBoardView release];
    
}

#pragma mark --SJKeyBoardView Delagate


-(void)didNumberKeyPressed:(NSString *)numberString{
    [passwordInput updateNumber:numberString];
    
}

-(void)didBackspaceKeyPressed{
    [passwordInput deleteNumber];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
