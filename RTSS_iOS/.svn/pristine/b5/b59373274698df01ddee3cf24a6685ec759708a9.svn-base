//
//  FlowByAppTableView.m
//  EasyTT
//
//  Created by sheng yinpeng on 13-6-3.
//  Copyright (c) 2013年 lvming. All rights reserved.
//

#import "FlowByAppTableView.h"
#import "ComboSlider.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"

#define FlowByAppCellLeftMargin 10/2.0
#define FlowByAppCellHeight     120/2.0
#define FlowByAppIconWidth      82/2.0
#define FlowByAppIconHeight     82/2.0
#define FlowByAppNameWidth      140/2.0
#define FlowByAppSilderWidth    280/2.0
#define FlowByAppSilderHeight   26/2.0
#define FlowByAppFlowWidth      120/2.0
#define FlosByAppAccessoryWidth 36/2.0

@interface FlowByAppTableView()

-(void)layoutTableView;

@end

@implementation FlowByAppTableView
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
        rowType = 0;
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
    return FlowByAppCellHeight;
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rowArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"FlowByAppTableIdentifier";

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
        if(1 == rowType){
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView* unSelectedView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, FlowByAppCellHeight)];
        unSelectedView.backgroundColor = [RTSSAppStyle currentAppStyle].cellUnSelectedColor;
        unSelectedView.tag = 1100;
        [cell.contentView addSubview:unSelectedView];
        [unSelectedView release];
        
        UIImageView* selectedView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, FlowByAppCellHeight)];
        selectedView.backgroundColor = [RTSSAppStyle currentAppStyle].cellSelectedColor;
        selectedView.tag = 1101;
        [cell.contentView addSubview:selectedView];
        [selectedView release];
        
        UIImageView* appIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(FlowByAppCellLeftMargin,
                                                                                 (FlowByAppCellHeight-FlowByAppIconHeight)/2.0,
                                                                                  FlowByAppIconWidth,
                                                                                  FlowByAppIconHeight)];
        appIconImage.backgroundColor = [UIColor clearColor];
        appIconImage.tag = 1102;
        [cell.contentView addSubview:appIconImage];
        [appIconImage release];
        
        UILabel* appNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(FlowByAppCellLeftMargin+FlowByAppIconWidth+2,
                                                                          0,
                                                                          FlowByAppNameWidth,
                                                                          FlowByAppCellHeight)];
        appNameLabel.backgroundColor = [UIColor clearColor];
        appNameLabel.tag = 1103;
        appNameLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
        appNameLabel.textAlignment = NSTextAlignmentLeft;
        appNameLabel.font = [RTSSAppStyle getRTSSFontWithSize:14];
        appNameLabel.numberOfLines = 0;
        appNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        appNameLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [cell.contentView addSubview:appNameLabel];
        [appNameLabel release];
        
        ProgressView* progressView = [[ProgressView alloc] initWithFrame:
                                     CGRectMake(FlowByAppCellLeftMargin+FlowByAppIconWidth+FlowByAppNameWidth+2,
                                                (FlowByAppCellHeight-FlowByAppSilderHeight)/2.0,
                                                (self.bounds.size.width-FlowByAppCellLeftMargin-FlowByAppIconWidth-FlowByAppNameWidth-FlowByAppFlowWidth-FlosByAppAccessoryWidth-2),
                                                FlowByAppSilderHeight)];
        progressView.backgroundColor = [UIColor clearColor];
        progressView.trackColor = [UIColor lightGrayColor];
        progressView.tag = 1104;
        [cell.contentView addSubview:progressView];
        [progressView release];
        
        
        UILabel* appFlowLabel = [[UILabel alloc] initWithFrame:
                                 CGRectMake((self.bounds.size.width-FlowByAppFlowWidth-FlosByAppAccessoryWidth),0,FlowByAppFlowWidth, FlowByAppCellHeight)];
        appFlowLabel.tag = 1105;
        appFlowLabel.backgroundColor = [UIColor clearColor];
        appFlowLabel.textColor = [RTSSAppStyle currentAppStyle].textGreenColor;
        appFlowLabel.textAlignment = NSTextAlignmentCenter;
        appFlowLabel.font = [RTSSAppStyle getRTSSFontWithSize:11];
        appFlowLabel.numberOfLines = 0;
        appFlowLabel.lineBreakMode = NSLineBreakByCharWrapping;
        appFlowLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        appFlowLabel.adjustsFontSizeToFitWidth = YES;
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
    
    UIImageView* appIconImage = (UIImageView*)[cell.contentView viewWithTag:1102];
    UILabel* appNameLabel = (UILabel*) [cell.contentView viewWithTag:1103];
    ProgressView* progressView = (ProgressView*)[cell.contentView viewWithTag:1104];
    UILabel* appFlowLabel = (UILabel*)[cell.contentView viewWithTag:1105];
    
    NSDictionary* itemDic = [self.rowArray objectAtIndex:row];
    if(nil != itemDic){
        [appIconImage setImage:[UIImage imageNamed:[itemDic objectForKey:@"AppIcon"]]];
        [appNameLabel setText:[itemDic objectForKey:@"itemName"]];
        
        //计算百分比
        float percent = 0;
        if(nil != self.totalAppFlow){
            NSNumber* number = [itemDic objectForKey:@"AppFlowReal"];
            if(nil != number){
                long long appFlowLong = [number longLongValue];
                long long totalFlowLong = [self.totalAppFlow longLongValue];
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
        
        if(nil != delegate && [delegate respondsToSelector:@selector(flowByAppTableView:didSelectRowAtIndexPath:)]){
            [delegate flowByAppTableView:tableView didSelectRowAtIndexPath:indexPath];
        }
    }
}

@end
