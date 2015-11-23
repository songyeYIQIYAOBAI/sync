//
//  BudgetGroupMemberView.h
//  RTSS
//
//  Created by 加富董 on 15/1/27.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BudgetGroupMemberView;

@protocol BudgetGroupMemberViewDelegate <NSObject>

@optional

- (void)budgetGroupMemberViewDidClickedAddButton:(BudgetGroupMemberView *)mbsView;
- (void)budgetGroupMemberView:(BudgetGroupMemberView *)mbsView didDeleteMemberAtIndex:(NSInteger)index;
- (void)budgetGroupMemberView:(BudgetGroupMemberView *)mbsView didSelectMemberAtIndex:(NSInteger)index;

@end

@interface MemberCellView : UIView


@end

@interface BudgetGroupMemberView : UIControl

- (id)initWithFrame:(CGRect)frame canEdit:(BOOL)edit columnCount:(NSInteger)colCount delegate:(id <BudgetGroupMemberViewDelegate>)del;
- (CGSize)loadContentWithData:(NSMutableArray *)dataArray;
- (CGSize)deleteMembersFromMembersViewAtIndex:(NSInteger)deleteIndex;
- (CGSize)addMembersIntoMembersView:(NSMutableArray *)members;


@end
