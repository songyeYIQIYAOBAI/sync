//
//  AddCardViewController.m
//  RTSS
//
//  Created by 蔡杰 on 14-11-4.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "AddCardViewController.h"

#import "CardInfomationViewController.h"

#include "UIView+RTSSAddView.h"

#import "UITextField+CheckState.h"

#import "CommonUtils.h"
#import "RTSSAppStyle.h"

@interface AddCardViewController (){
    UITextField *cardType;
    UITextField *cardNo;
    
}
@end

@implementation AddCardViewController


#pragma mark --life
-(void)dealloc{
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView{
    [super loadView];
    [self.view setViewBlackColor];
    [self installSubViews];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Add Card";
}

-(void)viewWillDisappear:(BOOL)animated{
    [self hideKeyBoard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --InstallView

-(void)installSubViews{
    
    
    CGFloat height = 80.0f;
    CGFloat edge = 5.0f;
    cardType = [self.view addTextFieldWithFrame:CGRectMake(0, edge, PHONE_UISCREEN_WIDTH, height) Name:@"Name:" TextFieldDelegate:self KeyboardType:UIKeyboardTypeASCIICapable isMoneySymbol:NO];
    cardNo = [self.view addTextFieldWithFrame:CGRectMake(0, edge*2+height, PHONE_UISCREEN_WIDTH, height) Name:@"Card NO:" TextFieldDelegate:self KeyboardType:UIKeyboardTypeNumberPad isMoneySymbol:NO];
    //按钮
    CGFloat buttonBgViewY = edge*2+height*2;
    UIView *buttonBgView = [[UIView alloc]initWithFrame:CGRectMake(0,buttonBgViewY,PHONE_UISCREEN_WIDTH,PHONE_UISCREEN_HEIGHT-buttonBgViewY-64)];
    buttonBgView.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    NSLog(@"buttonY= %@",NSStringFromCGRect(buttonBgView.frame));
    UIButton *submitButton =[RTSSAppStyle getMajorGreenButton:CGRectMake((PHONE_UISCREEN_WIDTH-253)/2,CGRectGetHeight(buttonBgView.frame)/2-45/2, 253, 45) target:self action:@selector(next) title:@"Next"];
    submitButton.backgroundColor = [UIColor grayColor];
    submitButton.layer.cornerRadius = 6.0f;
    submitButton.layer.masksToBounds = YES;
    [buttonBgView addSubview:submitButton];
    [self.view addSubview:buttonBgView];
    [buttonBgView release];
    
}

#pragma mark --Action

-(void)next{
    
    
    CardInfomationViewController *cardInfomation = [[CardInfomationViewController alloc]init];
    
    
    
    
    [self.navigationController pushViewController:cardInfomation animated:YES];
    
    
    [cardInfomation release];
    
    
    
}

#pragma mark --Touch

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    [self hideKeyBoard];
    
}

-(void)hideKeyBoard{
    
    [cardNo giveUpTheKeyboard];
    
    [cardType giveUpTheKeyboard];

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
