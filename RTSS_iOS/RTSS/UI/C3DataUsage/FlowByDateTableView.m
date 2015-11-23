//
//  FlowByDateTableView.m
//  EasyTT
//
//  Created by sheng yinpeng on 13-6-3.
//  Copyright (c) 2013年 lvming. All rights reserved.
//

#import "FlowByDateTableView.h"
#import "CommonUtils.h"
#import "ComboSlider.h"
#import "RTSSAppStyle.h"

#define FlowByDateCellHeight        120/2.0
#define FlowByDateDateWidth         180/2.0
#define FlowByDateSilderWidth       330/2.0
#define FlowByDateSilderHeight      26/2.0
#define FlowByDateFlowWidth         120/2.0
#define FlowByDateAccessoryWidth    36/2.0

@interface FlowByDateTableView()

-(void)layoutTableView;

@end

@implementation FlowByDateTableView
@synthesize myTableView,delegate;
@synthesize rowArray;
@synthesize totalAppFlow;
@synthesize rowType;

-(void)dealloc
{
    [myTableView release];
    [rowArray release];
    
    [totalAppFlow release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        selectedRow = -1;
        [self layoutTableView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame row:(NSMutableArray*)rows
{
    self = [super initWithFrame:frame];
    if(self){
        // Initialization code
        selectedRow = -1;
        [self layoutTableView];
    }
    return self;
}

-(void)layoutTableView
{
    CGRect rectFrame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    UITableView* tableViewTemp = [[UITableView alloc] initWithFrame:rectFrame style:UITableViewStylePlain];
    tableViewTemp.backgroundColor = [UIColor clearColor];
    tableViewTemp.separatorStyle  = UITableViewCellSeparatorStyleSingleLine;
    tableViewTemp.delegate = self;
    tableViewTemp.dataSource = self;
    self.myTableView = tableViewTemp;
    [self addSubview:tableViewTemp];
    [tableViewTemp release];
}

- (void)reloadTableViewRow:(NSMutableArray*)rows
{
    selectedRow = -1;
    
    self.rowArray = rows;
    
    [myTableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return FlowByDateCellHeight;
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rowArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"FlowByDateTableIdentifier";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
        if(1 == rowType){
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView* unSelectedView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, FlowByDateCellHeight)];
        unSelectedView.backgroundColor = [RTSSAppStyle currentAppStyle].cellUnSelectedColor;
        unSelectedView.tag = 1100;
        [cell.contentView addSubview:unSelectedView];
        [unSelectedView release];
        
        UIImageView* selectedView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, FlowByDateCellHeight)];
        selectedView.backgroundColor = [RTSSAppStyle currentAppStyle].cellSelectedColor;
        selectedView.tag = 1101;
        [cell.contentView addSubview:selectedView];
        [selectedView release];
                
        UILabel* appDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,FlowByDateDateWidth,FlowByDateCellHeight)];
        appDateLabel.backgroundColor = [UIColor clearColor];
        appDateLabel.tag = 1102;
        appDateLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
        appDateLabel.textAlignment = NSTextAlignmentCenter;
        appDateLabel.font = [RTSSAppStyle getRTSSFontWithSize:14];
        appDateLabel.numberOfLines = 1;
        appDateLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [cell.contentView addSubview:appDateLabel];
        [appDateLabel release];
        
        ProgressView* progressView = [[ProgressView alloc] initWithFrame:
                                      CGRectMake(FlowByDateDateWidth,
                                                 (FlowByDateCellHeight-FlowByDateSilderHeight)/2.0,
                                                 (self.bounds.size.width-FlowByDateDateWidth-FlowByDateFlowWidth-FlowByDateAccessoryWidth-5),
                                                 FlowByDateSilderHeight)];
        progressView.tag = 1103;
        progressView.trackColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:progressView];
        [progressView release];
        
        UILabel* appFlowLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.bounds.size.width-FlowByDateFlowWidth-FlowByDateAccessoryWidth),0,FlowByDateFlowWidth, FlowByDateCellHeight)];
        appFlowLabel.tag = 1104;
        appFlowLabel.backgroundColor = [UIColor clearColor];
        appFlowLabel.textColor = [RTSSAppStyle currentAppStyle].textGreenColor;
        appFlowLabel.textAlignment = NSTextAlignmentCenter;
        appFlowLabel.font = [RTSSAppStyle getRTSSFontWithSize:11];
        appFlowLabel.numberOfLines = 0;
        appFlowLabel.lineBreakMode = NSLineBreakByCharWrapping;
        appFlowLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [cell.contentView addSubview:appFlowLabel];
        [appFlowLabel release];
    }
    
    NSInteger row = indexPath.row;
    UIImageView* unSelectedView = (UIImageView*)[cell.contentView viewWithTag:1100];
    UIImageView* selectedView = (UIImageView*)[cell.contentView viewWithTag:1101];
    if(row == selectedRow){
        unSelectedView.hidden = YES;
        selectedView.hidden = NO;
    }else{
        unSelectedView.hidden = NO;
        selectedView.hidden = YES;
    }
    
    UILabel* appDateLabel = (UILabel*) [cell.contentView viewWithTag:1102];
    ProgressView* progressView = (ProgressView*)[cell.contentView viewWithTag:1103];
    UILabel* appFlowLabel = (UILabel*)[cell.contentView viewWithTag:1104];
    
    NSDictionary* itemDic = [self.rowArray objectAtIndex:row];
    if(nil != itemDic){
        [appDateLabel setText:[itemDic objectForKey:@"itemName"]];
        
        //计算百分比
        float percent = 0;
        if(nil != self.totalAppFlow){
            NSNumber* number = [itemDic objectForKey:@"AppFlowReal"];
            if(nil != number){
                long appFlowLong = [number longValue];
                long totalFlowLong = [self.totalAppFlow longValue];
                if(0 != totalFlowLong){
                    percent = appFlowLong*1.0/totalFlowLong;
                }
            }
        }
        
        progressView.progressColor = [RTSSAppStyle getFreeResourceColorWithIndex:row];
        progressView.progress = percent;
        [appFlowLabel setText:[itemDic objectForKey:@"AppFlow"]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(0 == rowType){
        selectedRow = indexPath.row;
        [myTableView reloadData];
        
        if(nil != delegate && [delegate respondsToSelector:@selector(flowByDateTableView:didSelectRowAtIndexPath:)]){
            [delegate flowByDateTableView:tableView didSelectRowAtIndexPath:indexPath];
        }
    }
}
@end
