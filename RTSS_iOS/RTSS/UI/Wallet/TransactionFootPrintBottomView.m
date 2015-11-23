//
//  TransactionFootPrintBottomView.m
//  RTSS
//
//  Created by 蔡杰 on 14-10-29.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "TransactionFootPrintBottomView.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"

@implementation TransactionFootPrintBottomViewModel
@synthesize dateString,businessString,imageString,type;

- (void)dealloc{
    [dateString release];
    [businessString release];
    [imageString release];
    [super dealloc];
}

@end

@interface TransactionFootPrintBottomView ()<UITableViewDataSource,UITableViewDelegate>

@end
@implementation TransactionFootPrintBottomView
-(void)dealloc{
    [_tableView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self installTableView];
    }
    return self;
}
-(void)installTableView{
    _tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 60;
    _tableView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    //防止滚动无法滚动到最后一行
//    _tableView.contentInset =UIEdgeInsetsMake(0, 0, 65.0, 0);
    [self addSubview:_tableView];
}

#pragma mark --UITabaleViewDataSource && UITableViewDelegae
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfItems)]) {
        return [_dataSource numberOfItems];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIndentify = @"CellIndentify";
    TransactionFootPrintTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentify];
    if (nil == cell) {
        cell = [[[TransactionFootPrintTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIndentify]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(transactionFootPrintBottomViewIndexItem:)]) {
        TransactionFootPrintBottomViewModel * item = [_dataSource transactionFootPrintBottomViewIndexItem:indexPath.row];
        [cell updateDate:item.dateString Info:item.businessString ImageString:item.imageString type:item.type bgType:item.bgType];
    }

    return cell;
}

-(void)updateData{
    [self.tableView reloadData];
    [self.tableView removeFromSuperview];
    CGRect frame = self.tableView.frame;
    frame.origin.y = CGRectGetMaxY(self.frame)+frame.size.height;
    self.tableView.frame = frame;
    [self addSubview:self.tableView];
    [UIView animateWithDuration:1.0 animations:^{
        self.tableView.frame = self.bounds;
    } completion:^(BOOL finished) {
        
    }];
}
-(void)refreshData:(NSMutableArray *)data{
    [self.tableView removeFromSuperview];
    CGRect frame = self.tableView.frame;
    frame.origin.y = CGRectGetMaxY(self.frame)+frame.size.height;
    self.tableView.frame = frame;
    [self addSubview:self.tableView];
    [UIView animateWithDuration:1.0 animations:^{
        self.tableView.frame = self.bounds;
    } completion:^(BOOL finished) {
        
    }];
}

@end
