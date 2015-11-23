//
//  TransactionFootPrintBottomView.h
//  RTSS
//
//  Created by 蔡杰 on 14-10-29.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactionFootPrintTableViewCell.h"
#import "TransactionFootPrintHeaderView.h"


@interface TransactionFootPrintBottomViewModel : NSObject
@property (nonatomic ,retain)NSString * dateString;
@property (nonatomic ,retain)NSString * businessString;
@property (nonatomic ,retain)NSString * imageString;
@property (nonatomic ,assign)TransactionFootPrintTableViewCellType type;
@property (nonatomic ,assign)ButtonItemViewType bgType;
@end

@protocol TransactionFootPrintBottomViewDataSource <NSObject>

- (NSInteger)numberOfItems;

- (TransactionFootPrintBottomViewModel *)transactionFootPrintBottomViewIndexItem:(NSInteger)index;

@end

@interface TransactionFootPrintBottomView : UIView

@property(nonatomic,retain)UITableView *tableView;
@property (nonatomic ,assign)id<TransactionFootPrintBottomViewDataSource> dataSource;

-(void)updateData;

-(void)refreshData:(NSMutableArray*)data;

@end
