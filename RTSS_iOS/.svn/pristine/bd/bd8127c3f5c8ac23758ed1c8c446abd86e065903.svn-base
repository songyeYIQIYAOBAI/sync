//
//  BalanceView.m
//  RTSS
//
//  Created by tiger on 14-11-29.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "BalanceDetailView.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"
#import "MobileUsageModel.h"
#import "BalanceDetailCell.h"
#import "RTSSAppStyle.h"
#import "RTSSAppDefine.h"

#define TABLE_HEAD_HEIGHT       44
#define HEAD_LEFT_PADDING       20
#define HEAD_RIGHT_PADDING      15
#define HEAD_INTENER_PADDING    15
#define TEXTFIELD_WIDTH         80
#define TEXTFIELD_HEIGHT        30

@interface BalanceDetailView()
{
}
@end

@implementation BalanceDetailView
@synthesize dataList;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initOjbect];
    }
    return self;
}

-(void)initOjbect
{
    detailTableView = [[UITableView alloc]initWithFrame:self.bounds];
    detailTableView.dataSource = self;
    detailTableView.delegate = self;
    detailTableView.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    
    [self addSubview:detailTableView];
}

-(void)dealloc
{
    [detailTableView release];
    [dataList release];
    [super dealloc];
}

#pragma mark - tableDeletaImplement
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    static NSString* key = @"default";
    BalanceDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:key];
    if (!cell) {
        cell = [[[BalanceDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:key]autorelease];
    }
    
     MobileUsageModel * m = dataList[indexPath.row];
    
    
   cell.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
 
    cell.retainLabel.textColor = [RTSSAppStyle getFreeResourceColorWithIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = m;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TABLE_HEAD_HEIGHT;
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row < dataList.count) {
        MobileUsageModel * m = dataList[indexPath.row];
        return [BalanceDetailCell heightForTitle:m];
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, TABLE_HEAD_HEIGHT)] autorelease];
    headerView.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    
    
    CGFloat labelwidth = (PHONE_UISCREEN_WIDTH-120)/2;
    //名称
    UILabel *planeName = [CommonUtils labelWithFrame:CGRectMake(HEAD_LEFT_PADDING, (TABLE_HEAD_HEIGHT-TEXTFIELD_HEIGHT)/2, 120, TEXTFIELD_HEIGHT) text:nil textColor:[RTSSAppStyle currentAppStyle].textSubordinateColor textFont:[RTSSAppStyle getRTSSFontWithSize:14.0f] tag:0];
   // planeName.textAlignment = NSTextAlignmentLeft;
    planeName.text = NSLocalizedString(@"MoBileUsage_Detail_Plan", nil);
    planeName.backgroundColor = [UIColor clearColor];
    [headerView addSubview:planeName];
    
    //剩余
    UILabel *remain = [CommonUtils labelWithFrame:CGRectMake(140, (TABLE_HEAD_HEIGHT-TEXTFIELD_HEIGHT)/2, labelwidth, TEXTFIELD_HEIGHT) text:nil textColor:[RTSSAppStyle currentAppStyle].textSubordinateColor textFont:[RTSSAppStyle getRTSSFontWithSize:14.0f] tag:0];
    //remain.textAlignment = NSTextAlignmentCenter;
    remain.text =NSLocalizedString(@"MoBileUsage_Detail_Remain", nil);;
    remain.backgroundColor = [UIColor clearColor];
    [headerView addSubview:remain];
    
    //总量
    UILabel *total = [CommonUtils labelWithFrame:CGRectMake(labelwidth+130, (TABLE_HEAD_HEIGHT-TEXTFIELD_HEIGHT)/2, labelwidth, TEXTFIELD_HEIGHT) text:nil textColor:[RTSSAppStyle currentAppStyle].textSubordinateColor textFont:[RTSSAppStyle getRTSSFontWithSize:14.0f] tag:0];
    //total.textAlignment = NSTextAlignmentCenter;
    total.text = NSLocalizedString(@"MoBileUsage_Detail_Total", nil);;
    total.backgroundColor = [UIColor clearColor];
    [headerView addSubview:total];
    
    //分割线
    UIImageView *line = [[UIImageView alloc]init];
    line.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    line.frame = CGRectMake(0, TABLE_HEAD_HEIGHT-1, self.bounds.size.width, 1);
    [headerView addSubview:line];
    [line release];
    
    return headerView;
}

@end
