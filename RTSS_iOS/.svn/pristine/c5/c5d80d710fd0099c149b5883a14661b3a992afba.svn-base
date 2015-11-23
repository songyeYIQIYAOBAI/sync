//
//  TransactionView.h
//  RTSS
//
//  Created by 蔡杰Alan on 15-2-2.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransationBaseTableViewCell.h"
#import "TransactionPanelBaseView.h"
#import "TransationPanelInterface.h"


//=============

#define kTransactionViewTopEdge 10.0f
#define kTransactionViewBottomEdge 0.0f

#define kTransactionViewLREdge   0.0f



@class TransactionView;

@protocol TransactionViewDelegate <NSObject>

@required



-(NSInteger)transactionView_TableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

-(TransationBaseTableViewCell*)transactionView_TableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@optional

-(CGFloat)transactionView_TableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

-(void)transactionView:(TransactionView*)transationView transationTableViewCell:(TransationBaseTableViewCell *)cell onSliderValueChanged:(ComboSlider *)comboSlider;

-(void)transactionView:(TransactionView*)transationView transationTableViewCell:(TransationBaseTableViewCell *)cell onSliderTouchUpInside:(ComboSlider *)comboSlider;


- (void)transactionView:(TransactionView*)transationView transationTableViewCell:(TransationBaseTableViewCell*)cell  resourceEvent:(ComboSlider*)comboSlider;

- (void)transactionView:(TransactionView*)transationView transationTableViewCell:(TransationBaseTableViewCell*)cell  rightItemEvent:(ComboSlider*)comboSlider;

@optional

@end

@interface TransactionView : UIView

@property(nonatomic,assign)id<TransactionViewDelegate>delegate;

@property(nonatomic,retain)UITableView *tableView;


@property(nonatomic,retain)TransactionPanelBaseView<TransationPanelInterface> *panelView;

@property(nonatomic,retain)NSMutableArray *dataSourceList;

-(void)panelViewShow:(BOOL)isShow;
//必须实现的函数
-(void)bindTransactionCell:(Class)class;

-(void)bindTransactionView:(Class)class;

@end
