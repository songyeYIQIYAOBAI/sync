//
//  UIView+RTSSAddView.h
//  EasyTT
//
//  Created by 蔡杰 on 14-10-23.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRTSSLineHeight 1

@interface UIView (RTSSAddView)

/**
 *  Add   Dark View
 *
 */
-(void)addTopViewWithFrame:(CGRect)fame;

/**
 *  添加间割线
 */
-(void)addBottomLine;

-(void)addBottomLineWithY:(CGFloat)lineY;


/**
 *  设置背景颜色
 */
-(void)setViewBlackColor;

/**
 *  load label
 */

+(UILabel*)addLabelWithFrame:(CGRect)aFrame TextColor:(UIColor*)aColor TextAlignment:(NSTextAlignment)ATextAligment;

/**
 *  添加TextField 包括 旁边标识符
 */
-(UITextField*)addTextFieldWithFrame:(CGRect)aFrame Name:(NSString*)name TextFieldDelegate:(id)aDelegate KeyboardType:(UIKeyboardType)aKeyboardType isMoneySymbol:(BOOL)flag;

//topup 界面
-(UILabel *)serviceViewWithFrame:(CGRect)fame Title:(NSString*)title isShowSelect:(BOOL)show  Target:(id)target Action:(SEL)aSel;

-(UILabel *)balanceWithFrame:(CGRect)aFrame TextColor:(UIColor *)aColor TextAlignment:(NSTextAlignment)ATextAligment;

-(void)selectTopUpAccountWithframe:(CGRect)frame Title:(NSString *)title Target:(id)target Action:(SEL)aSel;

//SOA
-(UILabel*)addLabelWithFrame:(CGRect)aFrame Title:(NSString*)title;

//Balance Transfer  添加深色间隔View  
-(UIView*)addIntervalViewWithFrame:(CGRect)frame;

@end
