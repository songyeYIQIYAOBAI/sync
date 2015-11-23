//
//  TransationBaseTableViewCell.h
//  RTSS
//
//  Created by 蔡杰Alan on 15-2-2.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ComboSlider.h"
#import "RTSSAppStyle.h"
#import "RTSSAppDefine.h"

@class TransationBaseTableViewCell;
@protocol TransationBaseTableViewCellDelegate <NSObject>

@optional
- (void)transationTableViewCell:(TransationBaseTableViewCell*)cell  onSliderValueChanged:(ComboSlider*)comboSlider;

- (void)transationTableViewCell:(TransationBaseTableViewCell*)cell  onSliderTouchUpInside:(ComboSlider*)comboSlider;

- (void)transationTableViewCell:(TransationBaseTableViewCell*)cell  resourceEvent:(ComboSlider*)comboSlider;

- (void)transationTableViewCell:(TransationBaseTableViewCell*)cell  rightItemEvent:(ComboSlider*)comboSlider;

@end
/**
 *
 */
@interface TransationBaseTableViewCell : UITableViewCell


@property(nonatomic,assign)id<TransationBaseTableViewCellDelegate>delegate;

@property(nonatomic,retain)ComboSlider *comboSlider;


@property(nonatomic,copy)NSString *identify;

-(void)setTransationBaseTableViewCellBgColor:(UIColor*)color;
/**
 * ======= 以下函数 --子类 overRide======
 */

/**
 *  目的：定制个性化ComboSlider 先调用[ super configure]初始化comboSlider;
 */
-(void)configure;


//后调用调用[ super onSlider----] 调用代理函数;
- (void)onSliderValueChanged:(id)sender;
- (void)onSliderTouchUpInside:(id)sender;

+(CGFloat)transationTableViewCellFixHeight;
@end
