//
//  BankCardUnitView.h
//  RTSS
//
//  Created by 蔡杰Alan on 15-1-26.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BankCardUnitViewDelagate <NSObject>

-(void)bankCardUnitAddcard;


@end


@interface BankCardUnitView : UIView

@property(nonatomic,assign)id<BankCardUnitViewDelagate>delagte;

/**
 *  银行卡片点击响应事件.default = NO
 */
@property(nonatomic,assign,getter=isCardTouch)BOOL cardTouch;

//设置背景颜色
-(void)setScrollViewBgColor:(UIColor*)bgColor;

-(void)setAddButtonBgColor:(UIColor*)bgColor;


-(void)reloaDataWithArray:(NSArray*)array;

@end
