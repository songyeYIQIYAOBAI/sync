//
//  BankUnitCell.h
//  RTSS
//
//  Created by 蔡杰Alan on 15-1-26.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  显示用户账户余额
 */
@interface BalanceView : UIView
/**
 *  设置用户Balance
 */
-(void)setUserBalance:(NSString*)balance;

@end

/**
 *  添加按钮样式
 */
@interface AddCardButton: UIControl

@end


/**
 *  银行卡片cell
 */
@class BankUnitCell;

@protocol BankUnitCellDelegate <NSObject>
@optional
// 通知cell被点击，执行操作
- (void)bankUnitCellTouched:(BankUnitCell *)unitCell;
@end

@interface BankUnitCell : UIControl
@property(nonatomic,assign)id<BankUnitCellDelegate>delegate;

@end
