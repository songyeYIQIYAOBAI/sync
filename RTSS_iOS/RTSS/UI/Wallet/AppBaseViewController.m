//
//  AppBaseViewController.m
//  RTSS
//
//  Created by 蔡杰 on 14-10-25.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "AppBaseViewController.h"

@interface AppBaseViewController ()
{
    UIButton *doneInKeyboardButton;
    
    NSInteger   normalKeyboardHeight;
}
@end
@implementation AppBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)registeredKeyboardNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)handleKeyboardWillHide:(NSNotification *)notification{
    if (doneInKeyboardButton.superview)
    {
        [doneInKeyboardButton removeFromSuperview];
    }
    
}

- (void)handleKeyboardDidShow:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    normalKeyboardHeight = kbSize.height;
    
    // NSLog(@"info = %@",info);
    
    
    // create custom button
    if (doneInKeyboardButton == nil)
    {
        doneInKeyboardButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        
        doneInKeyboardButton.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 53, 106, 53);
        
        doneInKeyboardButton.adjustsImageWhenHighlighted = NO;
        
        [doneInKeyboardButton setTitle:@"Done" forState:UIControlStateNormal];
        
        
        [doneInKeyboardButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // locate keyboard view
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    
    
    
    if (doneInKeyboardButton.superview == nil)
    {
        [tempWindow addSubview:doneInKeyboardButton]; // 注意这里直接加到window上
    }
    
}
#pragma mark --Action
-(void)finishAction{
    //subClass 执行
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
