//
//  BudgetGroupCell.h
//  RTSS
//
//  Created by 加富董 on 15/1/26.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PortraitImageView;
@class BudgetGroupAbstractCell;


@protocol BudgetGroupAbstractCellDelegate <NSObject>

@optional
- (void)budgetGroupAbstractCellHistoryButtonDidClicked:(BudgetGroupAbstractCell *)groupCell;

@end

@interface BudgetGroupAbstractCell : UITableViewCell

@property (nonatomic, assign) id <BudgetGroupAbstractCellDelegate> delegate;

@property (nonatomic, readonly) PortraitImageView *groupImageView;

@property (nonatomic, readonly) UILabel *groupNameLabel;

@property (nonatomic, readonly) UIButton *groupHistoryButton;

@property (nonatomic, readonly) UIImageView *groupSeperatorImageView;

@property (nonatomic, retain) NSIndexPath *cellIndexPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier availableSize:(CGSize)size;


@end