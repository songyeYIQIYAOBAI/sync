//
//  UsageAlertListView.m
//  RTSS
//
//  Created by tiger on 14-11-26.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "UsageAlertListView.h"
#import "UsageAlertListModel.h"
#import "UsageAlertListCell.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"
#import "UsageAlertListCell.h"

#define TABLE_HEAD_HEIGHT               48


@interface UsageAlertListView()
{
    //之前选中的model
    UsageAlertListModel* oldModel;
}

@end

@implementation UsageAlertListView
@synthesize dataList, delegate, headTitle;

-(void)dealloc
{
    [dataList release];
    [headTitle release];
    [super dealloc];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initObject:frame];
    }
    return self;
}

-(void)initObject:(CGRect)frame
{
    //初始化表
    tableListView = [[UITableView alloc]initWithFrame:frame];
    tableListView.dataSource = self;
    tableListView.delegate = self;
    tableListView.backgroundColor = [UIColor clearColor];
    tableListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:tableListView];
    [tableListView release];
    
    oldModel = nil;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataList.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UsageAlertListModel* m = dataList[indexPath.row];
    static NSString* key = @"default";
    UsageAlertListCell* cell = [tableView dequeueReusableCellWithIdentifier:key];
    if (!cell) {
        cell = [[[UsageAlertListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:key]autorelease];
    }
    [cell.budgetBtn addTarget:self action:@selector(notificationBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = m;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TABLE_HEAD_HEIGHT;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, TABLE_HEAD_HEIGHT)] autorelease];
    headerView.backgroundColor = [UIColor clearColor];
    
    //标题
    UILabel *titleLabel = [CommonUtils labelWithFrame:CGRectMake(0, 0, self.bounds.size.width, TABLE_HEAD_HEIGHT) text:nil textColor:[RTSSAppStyle currentAppStyle].textMajorGreenColor textFont:[UIFont systemFontOfSize:12] tag:0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = headTitle;
    titleLabel.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    [headerView addSubview:titleLabel];
    
    //分割线
    UIImageView *line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_separator_line"]];
    line.frame = CGRectMake(0, TABLE_HEAD_HEIGHT-2, self.bounds.size.width, 2);
    [headerView addSubview:line];
    [line release];
    
    return headerView;
}

-(void)notificationBtnOnClick:(UIButton *)button
{
    UsageAlertListCell * cell = (UsageAlertListCell *)[button superview];
    NSIndexPath * indexPath = [tableListView indexPathForCell:cell];
    UsageAlertListModel * model = [dataList objectAtIndex:indexPath.row];
    
    if ([delegate respondsToSelector:@selector(UsageAlertListViewNotificationClick:WithModel:)]) {
        [delegate UsageAlertListViewNotificationClick:button WithModel:model];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UsageAlertListModel* m = dataList[indexPath.row];
    
    if (m.layer == kMaxLayer) {
        return;
    }
    
    UsageAlertListCell* cell = (UsageAlertListCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    if (!m.isOpen) {
        double delayInSeconds = 0.0f;
        if (oldModel != nil && oldModel != m && oldModel.isOpen == YES) {
            delayInSeconds = 0.3;
            [self closeWithIndex:[dataList indexOfObject:oldModel] tableView:tableView isAnimation:YES];
            //关闭之前打开项
            NSIndexPath * oldPath = [NSIndexPath indexPathForRow:[dataList indexOfObject:oldModel] inSection:0];
            UsageAlertListCell* oldCell = (UsageAlertListCell *)[tableListView cellForRowAtIndexPath:oldPath];
            [oldCell setImageFold:YES];
            oldModel.isOpen = NO;
        }
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self openWithIndex:[dataList indexOfObject:m] tableView:tableView isAnimation:YES];
            [cell setImageFold:NO];
            m.isOpen = YES;
        });
    }
    else
    {
        [self closeWithIndex:indexPath.row tableView:tableView isAnimation:YES];
        [cell setImageFold:YES];
        m.isOpen = NO;
    }
    oldModel = m;
}

-(void)openWithIndex:(NSInteger)index tableView:(UITableView*)tableView isAnimation:(BOOL)animation
{
    UsageAlertListModel* m = dataList[index];
    NSMutableArray* indexPathArray = [NSMutableArray array];
    for (int i = 1; i <= m.children.count; i++) {
        NSIndexPath* subIndexPath = [NSIndexPath indexPathForRow:index+i inSection:0];
        [indexPathArray addObject:subIndexPath];
    }
    NSRange range;
    range.length = m.children.count;
    range.location = index+1;
    NSIndexSet* indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    [dataList insertObjects:m.children  atIndexes:indexSet];
    if (animation) {
        [tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    }
    else
        [tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
}

-(void)closeWithIndex:(NSInteger)index tableView:(UITableView*)tableView isAnimation:(BOOL)animation
{
    UsageAlertListModel* m = dataList[index];
    NSMutableArray* indexPathArray = [NSMutableArray array];
    for (int i = 1; i <= m.children.count; i++) {
        NSIndexPath* subIndexPath = [NSIndexPath indexPathForRow:index+i inSection:0];
        [indexPathArray addObject:subIndexPath];
    }
    NSRange range;
    range.length = m.children.count;
    range.location = index+1;
    NSIndexSet* indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    [dataList removeObjectsAtIndexes:indexSet];
    if (animation) {
        [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    }
    else
        [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
}

@end
