//
//  TransactionView.m
//  RTSS
//
//  Created by 蔡杰Alan on 15-2-2.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "TransactionView.h"
static NSString *CellIndentify = @"TransactionCell";


@interface TransactionView ()<UITableViewDataSource,UITableViewDelegate,TransationBaseTableViewCellDelegate>


@end


@implementation TransactionView

-(void)dealloc{
    
    [_panelView release];
    [_tableView release];
    [super dealloc];
}
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super  initWithFrame:frame];
    if (self) {
        [self configureSubView];
       
    }
    return self;
}

-(void)configureSubView{
    
    _tableView =[[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    //去掉多余的分割线
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorInset =UIEdgeInsetsZero ;
    
    [self addSubview:_tableView];
    
}

#pragma mark --Public
-(void)bindTransactionCell:(Class)class{
    
   // [_tableView registerClass:class forCellReuseIdentifier:CellIndentify];
    
}

-(void)bindTransactionView:(Class)class{
    
    _panelView = [[class alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), kTransactionPanelBaseViewHeight)];
    _panelView.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    [self addSubview:_panelView];

}
#pragma mark --UITabelViewDelegate && UITableViewDatasource
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TransationBaseTableViewCell *cell ;
    
    if (_delegate && [_delegate respondsToSelector:@selector(transactionView_TableView:cellForRowAtIndexPath:)]) {
        
       cell = (TransationBaseTableViewCell*)[_delegate transactionView_TableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    cell.delegate = self;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = 0.0;
    if (_delegate && [_delegate respondsToSelector:@selector(transactionView_TableView:heightForRowAtIndexPath:)]) {
      height = [_delegate transactionView_TableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
    return height >0.0 ? height:[TransationBaseTableViewCell transationTableViewCellFixHeight];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger count = 0;
    if (_delegate && [_delegate respondsToSelector:@selector(transactionView_TableView:numberOfRowsInSection:)]) {
        
       count = [_delegate transactionView_TableView:tableView numberOfRowsInSection:section];
    }
    return count;
}

#pragma mark ---BaseTableViewCell Delegate

-(void)transationTableViewCell:(TransationBaseTableViewCell *)cell onSliderValueChanged:(ComboSlider *)comboSlider{
    
    if (_delegate && [_delegate respondsToSelector:@selector(transactionView:transationTableViewCell:onSliderValueChanged:)]) {

        [_delegate transactionView:self transationTableViewCell:cell onSliderValueChanged:comboSlider];
    }
}

-(void)transationTableViewCell:(TransationBaseTableViewCell *)cell onSliderTouchUpInside:(ComboSlider *)comboSlider{
    
    if (_delegate && [_delegate respondsToSelector:@selector(transactionView:transationTableViewCell:onSliderTouchUpInside:)]) {
        
        [_delegate transactionView:self transationTableViewCell:cell onSliderTouchUpInside:comboSlider];
    }
}

-(void)transationTableViewCell:(TransationBaseTableViewCell *)cell resourceEvent:(ComboSlider *)comboSlider{
    
    if (_delegate && [_delegate respondsToSelector:@selector(transactionView:transationTableViewCell:resourceEvent:)]) {
        
        [_delegate transactionView:self transationTableViewCell:cell resourceEvent:comboSlider];
    }
    
}

-(void)transationTableViewCell:(TransationBaseTableViewCell *)cell rightItemEvent:(ComboSlider *)comboSlider{
    
    if (_delegate && [_delegate respondsToSelector:@selector(transactionView:transationTableViewCell:rightItemEvent:)]) {
        
        [_delegate transactionView:self transationTableViewCell:cell rightItemEvent:comboSlider];
    }
    
}
#pragma mark--animation
-(void)panelViewShow:(BOOL)isShow
{
    if (YES == isShow) {
        
        [UIView animateWithDuration:KTransactionPanelBaseViewDuration animations:^{
            
            
            _panelView.frame = _panelView.initChangePanelBaseFrame;
            _tableView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - kTransactionPanelBaseViewHeight);
            
        } completion:^(BOOL finished){
        
            
        }];
    
    } else {
        
        [UIView animateWithDuration:KTransactionPanelBaseViewDuration animations:^{
            
            _panelView.frame =_panelView.initPanelBaseFrame;
            //CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), kTransactionPanelBaseViewHeight);
            _tableView.frame = self.bounds;
        }];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
