//
//  TransationBaseViewController.h
//  RTSS
//
//  Created by 蔡杰Alan on 15-2-3.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "BasicViewController.h"
#import "TransactionView.h"
#import "TransationBaseTableViewCell+BussinessLogic.h"
#import "RTSSAppStyle.h"
#import "Session.h"
#import "TTRule.h"
#import "ProductResource.h"
#import "RuleManager.h"
#import "Product.h"
#import "CommonUtils.h"
#import "PriceRule.h"
#import "ImageUtils.h"

#define kResourceUnit   @"ResourceUnit"
#define kResourceName   @"ResourceName"
#define kResourceAmount @"ResourceAmount"

#define kCellIndentify  @"CellIDentify_Row%d_Section%d"

@interface TransationBaseViewController : BasicViewController<TransactionViewDelegate,MappActorDelegate>


@property(nonatomic,retain)NSMutableArray *dataSourceList;

@property(nonatomic,retain)TransactionView *transactionView;

@property(nonatomic,retain)NSMutableDictionary *resourceUnitAndName;

@property(nonatomic,retain)NSMutableDictionary *storeCell;


-(void)loadTransactionViewWtihFrame:(CGRect)frame bindTransationCell:(Class)cellClass bindTransactionView:(Class)transactionClass;


-(void)setCellProperty:(TransationBaseTableViewCell*)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath;
//更改submit按钮的状态
-(void)updateSubmitButtonState:(BOOL)state;
//按钮 subclass override
-(void)reset;//reset按钮响应事件
-(void)submit;//submit 按钮响应事件
-(void)installPanellData;//初始化 面板的数据---只需要覆盖，已经在父类调用

-(void)sureSubmit;
@end
