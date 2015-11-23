//
//  BudgetDetailCell.h
//  RTSS
//
//  Created by 加富董 on 15/2/4.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BudgetDetailView;
@class BudgetDetailCell;

typedef NS_ENUM(NSInteger, DetailCellContentType) {
    DetailCellContentTypeBudget = 0,
    DetailCellContentTypeNotify,
    DetailCellContentTypeBar,
    DetailCellContentTypeUnknown,
};

@protocol BudgetDetailCellDelegate <NSObject>

@optional

- (void)budgetDetailCell:(BudgetDetailCell *)detailCell didClickedActionButtonAtIndexPath:(NSIndexPath *)indexPath;

@end




@interface BudgetDetailCell : UITableViewCell

@property (nonatomic, retain) BudgetDetailView *detailView;
@property (nonatomic, assign) DetailCellContentType contentType;
@property (nonatomic, assign) BOOL showArrow;
@property (nonatomic, assign) BOOL supportInteraction;
@property (nonatomic, retain) NSIndexPath *cellIndexPath;
@property (nonatomic, assign) id <BudgetDetailCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier availableSize:(CGSize)size;
- (void)loadContentViewsByType:(DetailCellContentType)type showArrow:(BOOL)show supportInteraction:(BOOL)interaction indexPath:(NSIndexPath *)indexPath;


@end

