//
//  AppListByMonthVC.m
//  EasyTT
//
//  Created by sheng yinpeng on 13-6-4.
//  Copyright (c) 2013年 lvming. All rights reserved.
//

#import "AppListByMonthVC.h"
#import "AppListByDayVC.h"
#import "CommonUtils.h"
#import "FileUtils.h"
#import "NSString+SBJSON.h"
#import "C3DataConfig.h"
#import "StaticData.h"

@interface AppListByMonthVC ()

@end

@implementation AppListByMonthVC
@synthesize dateTableView;
@synthesize appIconString,appNameString,monthIntervalString,totalFlowString;
@synthesize appItemDic,monthListDic;
@synthesize startDate,endDate;
@synthesize appListByMonthResultDic;
@synthesize rowKey;

- (void)dealloc
{
    [dateTableView release];
    
    [appIconView release];
    [appNameLabel release];
    [monthIntervalLabel release];
    [totalFlowLabel release];
    
    [appIconString release];
    [appNameString release];
    [monthIntervalString release];
    [totalFlowString release];
    
    [appItemDic release];
    [monthListDic release];
    
    [startDate release];
    [endDate release];
    
    [appListByMonthResultDic release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutHeaderView
{
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 95)];
    
    //应用程序icon
    appIconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100/2.0, 100/2.0)];
    appIconView.backgroundColor = [UIColor clearColor];
    if(nil != self.appIconString){
        [appIconView setImage:[UIImage imageNamed:self.appIconString]];
    }
    [headerView addSubview:appIconView];
    
    //应用程序名称
    appNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10+82/2.0,150,30)];
    appNameLabel.backgroundColor = [UIColor clearColor];
    appNameLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    if(nil != self.appNameString){
        [appNameLabel setText:self.appNameString];
    }
    appNameLabel.textAlignment = NSTextAlignmentLeft;
    appNameLabel.font = [RTSSAppStyle getRTSSFontWithSize:14];
    appNameLabel.numberOfLines = 1;
    appNameLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [headerView addSubview:appNameLabel];

    //月份区间
    monthIntervalLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 10, 150, 30)];
    monthIntervalLabel.backgroundColor = [UIColor clearColor];
    monthIntervalLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    if(nil != self.monthIntervalString){
        [monthIntervalLabel setText:self.monthIntervalString];
    }
    monthIntervalLabel.textAlignment = NSTextAlignmentCenter;
    monthIntervalLabel.font = [RTSSAppStyle getRTSSFontWithSize:14];
    monthIntervalLabel.numberOfLines = 1;
    monthIntervalLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [headerView addSubview:monthIntervalLabel];
    
    //总流量
    totalFlowLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 10+30, 150, 50)];
    totalFlowLabel.backgroundColor = [UIColor clearColor];
    totalFlowLabel.textColor = [RTSSAppStyle currentAppStyle].textGreenColor;
    if(nil != self.totalFlowString){
        [totalFlowLabel setText:self.totalFlowString];
    }
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
    dateTableViewTemp.delegate = self;
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

- (void)updateTotalFlowUI:(NSNumber*)totalNumber dateInterval:(NSString*)intervalString
{
    if(nil != totalNumber){
        long totalReal = [totalNumber longValue];
        [totalFlowLabel setText:[CommonUtils formatDataWithByte:totalReal decimals:2 unitEnable:YES]];
    }else{
        [totalFlowLabel setText:[CommonUtils formatDataWithByte:0 decimals:2 unitEnable:YES]];
    }
    if(nil != intervalString){
        [monthIntervalLabel setText:intervalString];
    }else{
        [monthIntervalLabel setText:@"未知"];
    }
}

- (void)resolveAppListByMonth
{
    if(nil != self.appListByMonthResultDic){
        int errorCode = [[self.appListByMonthResultDic objectForKey:@"errorCode"] intValue];
        if(0 == errorCode){
            NSDictionary* monthDic = [StaticData getAppListByMonthData:self.appListByMonthResultDic];
            NSMutableArray* monthArray = [monthDic objectForKey:@"DateList"];
            NSNumber* totalNumber = [monthDic objectForKey:@"DateTotal"];
            NSString* dateInterval = [monthDic objectForKey:@"DateInterval"];
            if(nil != monthArray && [monthArray count] > 0 && nil != totalNumber){
                self.monthListDic = monthDic;
                [self updateTotalFlowUI:totalNumber dateInterval:dateInterval];
                self.dateTableView.totalAppFlow = totalNumber;
                [self.dateTableView reloadTableViewRow:monthArray];
            }else{
                [self updateTotalFlowUI:totalNumber dateInterval:dateInterval];
                //[MyAlertView showSimpleAlertView:NSLocalizedString(@"MobileUsage_Network_Data_Empty_Prompt", nil)];
            }
        }else{
            [self updateTotalFlowUI:nil dateInterval:nil];
            //[MyAlertView showSimpleAlertView:[self.appListByMonthResultDic objectForKey:@"errorMsg"]];
            //[MyAlertView showSimpleAlertView:NSLocalizedString(@"MobileUsage_Network_Data_Empty_Prompt", nil)];
        }
    }
}

- (void)sendLoadAppListByMonthMessage
{
    C3DataConfig* config = [C3DataConfig standardC3DataConfig];
    self.appListByMonthResultDic = [config getUserDataByC3WithDataKey:[NSString stringWithFormat:@"AppListMonth_%d",self.rowKey]];
}

- (void)refreshDateListData
{
    if(nil != self.appItemDic){
        [appIconView setImage:[UIImage imageNamed:[self.appItemDic objectForKey:@"AppIcon"]]];
        [appNameLabel setText:[self.appItemDic objectForKey:@"itemName"]];
        
        [APPLICATION_KEY_WINDOW makeToastActivity];
        
        [self sendLoadAppListByMonthMessage];
        [self resolveAppListByMonth];
        
        [APPLICATION_KEY_WINDOW hideToastActivity];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"App Month List";
    
    [self refreshDateListData];
}

#pragma mark -
#pragma mark FlowByDateTableViewDelegate
- (void)flowByDateTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(nil == self.monthListDic){
        //[MyAlertView showSimpleAlertView:@"Data Error!"];
    }else{
        AppListByDayVC* VC = [[AppListByDayVC alloc] init];
        VC.appItemDic = self.appItemDic;
        VC.monthItemDic = [[self.monthListDic objectForKey:@"DateList"] objectAtIndex:indexPath.row];
        VC.rowKey = indexPath.row;
        VC.rowKeySuper = self.rowKey;
        [self.navigationController pushViewController:VC animated:YES];
        [VC release];
    }
}

@end
