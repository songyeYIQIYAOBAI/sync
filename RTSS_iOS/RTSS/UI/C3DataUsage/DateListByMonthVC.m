//
//  DateListByMonthVC.m
//  EasyTT
//
//  Created by sheng yinpeng on 13-6-4.
//  Copyright (c) 2013年 lvming. All rights reserved.
//

#import "DateListByMonthVC.h"
#import "DateListByDayVC.h"
#import "CommonUtils.h"

#import "FileUtils.h"
#import "NSString+SBJSON.h"
#import "C3DataConfig.h"
#import "StaticData.h"

@interface DateListByMonthVC ()

@end

@implementation DateListByMonthVC
@synthesize appTableView;
@synthesize monthString,totalFlowString;
@synthesize dateItemDic,appListDic;
@synthesize dateListByMonthResultDic;
@synthesize rowKey;

- (void)dealloc
{
    [appTableView release];
    
    [monthLabel release];
    [totalFlowLabel release];
    
    [monthString release];
    [totalFlowString release];
    
    [dateItemDic release];
    [appListDic release];
    
    [dateListByMonthResultDic release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutAppListView
{
    FlowByAppTableView* appTableViewTemp = [[FlowByAppTableView alloc] initWithFrame:CGRectMake(0, 95, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-22-44-95)];
    appTableViewTemp.delegate = self;
    [self.view addSubview:appTableViewTemp];
    self.appTableView = appTableViewTemp;
    [appTableViewTemp release];
}

- (void)layoutHeaderView
{
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 95)];
    
    //月份
    monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 150, 60)];
    monthLabel.backgroundColor = [UIColor clearColor];
    monthLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    if(nil != self.monthString){
        [monthLabel setText:self.monthString];
    }
    monthLabel.textAlignment = NSTextAlignmentCenter;
    monthLabel.font = [RTSSAppStyle getRTSSFontWithSize:20];
    monthLabel.numberOfLines = 1;
    monthLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [headerView addSubview:monthLabel];
    
    //总流量
    totalFlowLabel = [[UILabel alloc] initWithFrame:CGRectMake(150+10, 20, 150, 60)];
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
    
    //格线
    UIImageView* lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 94, PHONE_UISCREEN_WIDTH, 1)];
    lineImageView.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [headerView addSubview:lineImageView];
    [lineImageView release];
    
    [self.view addSubview:headerView];
    [headerView release];
}

-(void)loadView
{
    [super loadView];
    
    [self layoutHeaderView];
    [self layoutAppListView];
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
    if(nil != self.dateListByMonthResultDic){
        int errorCode = [[self.dateListByMonthResultDic objectForKey:@"errorCode"] intValue];
        if(0 == errorCode){
            NSDictionary* appDic = [StaticData getAppListData:self.dateListByMonthResultDic];
            NSMutableArray* appArray = [appDic objectForKey:@"AppList"];
            NSNumber* totalNumber = [appDic objectForKey:@"AppTotal"];
            if(nil != appArray && [appArray count] > 0 && nil != totalNumber){
                self.appListDic = appDic;
                [self updateTotalFlowUI:totalNumber];
                self.appTableView.totalAppFlow = totalNumber;
                [self.appTableView reloadTableViewRow:appArray];
            }else{
                [self updateTotalFlowUI:totalNumber];
                //[MyAlertView showSimpleAlertView:NSLocalizedString(@"MobileUsage_Network_Data_Empty_Prompt", nil)];
            }
        }else{
            [self updateTotalFlowUI:nil];
            //[MyAlertView showSimpleAlertView:[self.dateListByMonthResultDic objectForKey:@"errorMsg"]];
            //[MyAlertView showSimpleAlertView:NSLocalizedString(@"MobileUsage_Network_Data_Empty_Prompt", nil)];
        }
    }
}

- (void)sendLoadDateListByMonthMessage
{
    C3DataConfig* config = [C3DataConfig standardC3DataConfig];
    self.dateListByMonthResultDic = [config getUserDataByC3WithDataKey:[NSString stringWithFormat:@"DateListMonth_%d",self.rowKey]];
}

- (void)refreshAppListData
{
    if(nil != self.dateItemDic){
        [monthLabel setText:[self.dateItemDic objectForKey:@"itemName"]];
        
        [APPLICATION_KEY_WINDOW makeToastActivity];
        
        [self sendLoadDateListByMonthMessage];
        [self resolveDateListByMonth];
        
        [APPLICATION_KEY_WINDOW hideToastActivity];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Date Month List";
    
    [self refreshAppListData];
}

#pragma mark -
#pragma mark FlowByAppTableViewDelegate
- (void)flowByAppTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(nil == self.appListDic){
        //[MyAlertView showSimpleAlertView:@"Data Error!"];
    }else{
        DateListByDayVC* VC = [[DateListByDayVC alloc] init];
        VC.dateItemDic = self.dateItemDic;
        VC.appItemDic = [[self.appListDic objectForKey:@"AppList"] objectAtIndex:indexPath.row];
        VC.rowKey = indexPath.row;
        VC.rowKeySuper = self.rowKey;
        [self.navigationController pushViewController:VC animated:YES];
        [VC release];
    }
}

@end
