//
//  DateListByDayVC.m
//  EasyTT
//
//  Created by sheng yinpeng on 13-6-6.
//  Copyright (c) 2013年 lvming. All rights reserved.
//

#import "DateListByDayVC.h"
#import "FlowByDateTableView.h"
#import "CommonUtils.h"
#import "FileUtils.h"
#import "NSString+SBJSON.h"

#import "C3DataConfig.h"
#import "StaticData.h"

@interface DateListByDayVC ()

@end

@implementation DateListByDayVC
@synthesize dateTableView;
@synthesize appItemDic,dateItemDic;
@synthesize dateListByDayResultDic;
@synthesize rowKey,rowKeySuper;

- (void)dealloc
{
    [dateTableView release];
    
    [appItemDic release];
    [dateItemDic release];
    
    [dateListByDayResultDic release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutHeaderView
{
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 95)];
    
    //应用程序icon
    appIconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100/2.0, 100/2.0)];
    appIconView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:appIconView];
    
    //应用程序名称
    appNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10+82/2.0,150,30)];
    appNameLabel.backgroundColor = [UIColor clearColor];
    appNameLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    appNameLabel.textAlignment = NSTextAlignmentLeft;
    appNameLabel.font = [RTSSAppStyle getRTSSFontWithSize:14];
    appNameLabel.numberOfLines = 1;
    appNameLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [headerView addSubview:appNameLabel];
    
    //月份
    monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 10, 150, 30)];
    monthLabel.backgroundColor = [UIColor clearColor];
    monthLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    monthLabel.textAlignment = NSTextAlignmentCenter;
    monthLabel.font = [RTSSAppStyle getRTSSFontWithSize:14];
    monthLabel.numberOfLines = 1;
    monthLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [headerView addSubview:monthLabel];
    
    //总流量
    totalFlowLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 10+30, 150, 50)];
    totalFlowLabel.backgroundColor = [UIColor clearColor];
    totalFlowLabel.textColor = [RTSSAppStyle currentAppStyle].textGreenColor;
    totalFlowLabel.textAlignment = NSTextAlignmentCenter;
    totalFlowLabel.font = [RTSSAppStyle getRTSSFontWithSize:20];
    totalFlowLabel.numberOfLines = 1;
    totalFlowLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [headerView addSubview:totalFlowLabel];
    
    UIImageView* lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 94, PHONE_UISCREEN_WIDTH, 1)];
    lineImageView.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [headerView addSubview:lineImageView];
    [lineImageView release];
    
    [self.view addSubview:headerView];
    [headerView release];
}

- (void)layoutDateListView
{
    FlowByDateTableView* dateTableViewTemp = [[FlowByDateTableView alloc] initWithFrame:CGRectMake(0, 95, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-22-44-95)];
    dateTableViewTemp.rowType = 1;
    [self.view addSubview:dateTableViewTemp];
    self.dateTableView = dateTableViewTemp;
    [dateTableViewTemp release];
}

-(void)loadView
{
    [super loadView];
    
    [self layoutHeaderView];
    [self layoutDateListView];
}

- (void)updateTotalFlowUI:(NSNumber*)totalNumber
{
    if(nil != totalNumber){
        long totalReal = [totalNumber longValue];
        [totalFlowLabel setText:[CommonUtils formatDataWithByte:totalReal decimals:2 unitEnable:YES]];
    }else{
        [totalFlowLabel setText:[CommonUtils formatDataWithByte:0 decimals:2 unitEnable:YES]];
    }
}

- (void)resolveDateListByMonth
{
    if(nil != self.dateListByDayResultDic){
        int errorCode = [[self.dateListByDayResultDic objectForKey:@"errorCode"] intValue];
        if(0 == errorCode){
            NSDictionary* dayDic = [StaticData getAppListByMonthData:self.dateListByDayResultDic];
            NSMutableArray* dayArray = [dayDic objectForKey:@"DateList"];
            NSNumber* totalNumber = [dayDic objectForKey:@"DateTotal"];
            if(nil != dayArray && [dayArray count] > 0 && nil != totalNumber){
                [self updateTotalFlowUI:totalNumber];
                dateTableView.totalAppFlow = totalNumber;
                [dateTableView reloadTableViewRow:dayArray];
            }else{
                [self updateTotalFlowUI:totalNumber];
                //[MyAlertView showSimpleAlertView:NSLocalizedString(@"MobileUsage_Network_Data_Empty_Prompt", nil)];
            }
        }else{
            [self updateTotalFlowUI:nil];
            //[MyAlertView showSimpleAlertView:[self.dateListByDayResultDic objectForKey:@"errorMsg"]];
            //[MyAlertView showSimpleAlertView:NSLocalizedString(@"MobileUsage_Network_Data_Empty_Prompt", nil)];
        }
    }
}

- (void)sendLoadDateListByDayMessage
{
    C3DataConfig* config = [C3DataConfig standardC3DataConfig];
    self.dateListByDayResultDic = [config getUserDataByC3WithDataKey:[NSString stringWithFormat:@"DateListDay_%d_%d",self.rowKeySuper,self.rowKey]];
}

- (void)refreshDateListData
{
    if(nil != self.appItemDic && nil != self.dateItemDic){
        [appIconView setImage:[UIImage imageNamed:[self.appItemDic objectForKey:@"AppIcon"]]];
        [appNameLabel setText:[self.appItemDic objectForKey:@"itemName"]];
        [monthLabel setText:[self.dateItemDic objectForKey:@"itemName"]];
        
        [APPLICATION_KEY_WINDOW makeToastActivity];
        
        [self sendLoadDateListByDayMessage];
        [self resolveDateListByMonth];
        
        [APPLICATION_KEY_WINDOW hideToastActivity];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"App Day List";
    
    [self refreshDateListData];
}

@end
