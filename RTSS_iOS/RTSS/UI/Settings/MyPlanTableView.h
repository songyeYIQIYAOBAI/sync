//
//  MyPlanTableView.h
//  RTSS
//
//  Created by 宋野 on 14-11-22.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@protocol MyPlanTableViewDelegate <NSObject>

- (void)myPlanTableViewClickUpdateButtonIndex:(NSIndexPath *)indexPath;
- (void)myPlanTableViewCellTapIndex:(NSIndexPath *)indexPath;

@end


@interface MyPlanTableView : UIView
@property (nonatomic ,assign)id<MyPlanTableViewDelegate>delegate;
- (void)initViewsWithArray:(NSArray *)modelsArray;

@end

@class MyPlanTableViewModel;

@interface MyPlanTableViewCell : UITableViewCell
@property (nonatomic ,readonly)UILabel * titleLabel;
@property (nonatomic ,readonly)UILabel * priceLabel;
@property (nonatomic ,readonly)UIButton * updateBtn;


@end

@interface MyPlanTableHeadView : UIView
@property (nonatomic ,retain)UILabel * title;

@end
