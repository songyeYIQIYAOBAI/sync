//
//  UITextField+CheckState.h
//  EasyTT
//
//  Created by 蔡杰 on 14-10-24.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (CheckState)

//放弃键盘
-(void)giveUpTheKeyboard;

-(void)clearupInpuView;

-(void)addRightViewWithFrame:(CGRect)aFrame BlackImage:(UIImage*)aImage Target:(id)aTarget Action:(SEL)aSel;

//金额是否合法
-(BOOL)isBalanceValid;

-(BOOL)isBalacceValueValid;
//转增账户合法性
-(BOOL)isAccountValid;

-(BOOL)isAccountValueValid;

-(BOOL)isEmptyShowMessage:(NSString*)message;
//获取VC
- (UIViewController *)viewController;
//top up金额是否合法
-(BOOL)isTopupBalanceValid;

-(BOOL)isTopupBalacceValueValid;



@end
