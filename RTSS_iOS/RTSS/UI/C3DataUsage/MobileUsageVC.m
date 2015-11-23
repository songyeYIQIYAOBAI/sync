//
//  MobileUsageVC.m
//  EasyTT
//
//  Created by sheng yinpeng on 13-1-7.
//  Copyright (c) 2013年 lvming. All rights reserved.
//

#import "MobileUsageVC.h"
#import "RTSSAppDefine.h"
#import "Toast+UIView.h"
#import "CommonUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "AppListByMonthVC.h"
#import "DateListByMonthVC.h"
#import "FileUtils.h"
#import "NSString+SBJSON.h"

#import "C3DataConfig.h"
#import "StaticData.h"

#define UsageCellHeight 102/2.0

@interface MobileUsageVC ()

@end

@implementation MobileUsageVC
@synthesize totalValueLabel;
@synthesize appListButton,dateListButton;
@synthesize appTableView,dateTableView;
@synthesize startDate,endDate;
@synthesize appListDic,dateListDic;
@synthesize appListResultDic,dateListResultDic;

- (void)dealloc
{
    [startDate release];
    [endDate release];
    
    [appListButton release];
    [dateListButton release];
    [totalValueLabel release];
    
    [appTableView release];
    [dateTableView release];
    
    [appListDic release];
    [dateListDic release];
    
    [appListResultDic release];
    [dateListResultDic release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)layoutNavigationBar
{
//    UIBarButtonItem* settingItem = [[UIBarButtonItem alloc] initWithTitle:@"Setting"
//                                                                    style:UIBarButtonItemStylePlain
//                                                                   target:self
//                                                                   action:@selector(setting:)];
    CGSize settingSize = [CommonUtils calculateTextSize:NSLocalizedString(@"DataUsage_RightItem_Setting", nil) constrainedSize:CGSizeMake(PHONE_UISCREEN_WIDTH, 30) textFont:[RTSSAppStyle getRTSSFontWithSize:18.f] lineBreakMode:NSLineBreakByWordWrapping];

    UIButton *settingButton = [CommonUtils buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, (44-settingSize.height)/2, settingSize.width, settingSize.height) title:NSLocalizedString(@"DataUsage_RightItem_Setting", nil) bgImageNormal:nil bgImageHighlighted:nil bgImageSelected:nil addTarget:self action:@selector(setting:) tag:0];
    settingButton.backgroundColor = [UIColor clearColor];
    settingButton.titleLabel.font = [RTSSAppStyle getRTSSFontWithSize:18.f];
    [settingButton setTitleColor:[RTSSAppStyle currentAppStyle].textBlueColor forState:UIControlStateNormal];
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    
    self.navigationItem.rightBarButtonItem = settingItem;
    [settingItem release];
}

-(void)setting:(id)action
{
    FlowDateSearchVC* VC = [[FlowDateSearchVC alloc] init];
    VC.delegate = self;
    VC.startDate = self.startDate;
    VC.endDate = self.endDate;
//    UINavigationController* rootNav = [[UINavigationController alloc] initWithRootViewController:VC];
    UINavigationController *rootNav = [[RTSSAppStyle currentAppStyle] getRTSSNavigationController:VC];
    [self presentViewController:rootNav animated:YES completion:nil];
    [VC release];
    //[rootNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_bg.png"] forBarMetrics:UIBarMetricsDefault];
//    rootNav.navigationBar.tintColor = [CommonUtils colorWithHexString:@"#54565C"];
//    [rootNav setModalPresentationStyle:UIModalPresentationPageSheet];
//    [rootNav setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
//    [rootNav release];
}

- (void)layoutSegmentView
{
    //应用列表按钮
    UIButton* appListButtonTemp = [[UIButton alloc] initWithFrame:CGRectMake(5, 12.5, 98, 30)];
	[appListButtonTemp setTitle:@"App List" forState:UIControlStateNormal];
	appListButtonTemp.titleLabel.font = [RTSSAppStyle getRTSSFontWithSize:16];
    [appListButtonTemp setTitleColor:[RTSSAppStyle currentAppStyle].textSubordinateColor forState:UIControlStateNormal];
    [appListButtonTemp setTitleColor:[RTSSAppStyle currentAppStyle].textGreenColor forState:UIControlStateSelected];
	[appListButtonTemp setBackgroundImage:[UIImage imageNamed:@"c3_leftbutton_d.png"] forState:UIControlStateNormal];
	[appListButtonTemp setBackgroundImage:[UIImage imageNamed:@"c3_leftbutton_a.png"] forState:UIControlStateSelected];
	[appListButtonTemp addTarget:self action:@selector(onAppListTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:appListButtonTemp];
    self.appListButton = appListButtonTemp;
    [appListButtonTemp release];
    [appListButton setSelected:YES];
    
    //日期列表按钮
    UIButton* dateListButtonTemp = [[UIButton alloc] initWithFrame:CGRectMake(5+98, 12.5, 100, 30)];
	[dateListButtonTemp setTitle:@"Date List" forState:UIControlStateNormal];
	dateListButtonTemp.titleLabel.font = [RTSSAppStyle getRTSSFontWithSize:16];
    [dateListButtonTemp setTitleColor:[RTSSAppStyle currentAppStyle].textSubordinateColor forState:UIControlStateNormal];
    [dateListButtonTemp setTitleColor:[RTSSAppStyle currentAppStyle].textGreenColor forState:UIControlStateSelected];
	[dateListButtonTemp setBackgroundImage:[UIImage imageNamed:@"c3_rightbutton_d.png"] forState:UIControlStateNormal];
	[dateListButtonTemp setBackgroundImage:[UIImage imageNamed:@"c3_rightbutton_a.png"] forState:UIControlStateSelected];
	[dateListButtonTemp addTarget:self action:@selector(onDateListTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:dateListButtonTemp];
    self.dateListButton = dateListButtonTemp;
    [dateListButtonTemp release];
    [dateListButton setSelected:NO];
    
    //Total:
    UILabel* totalTiltleLabel = [[UILabel alloc] initWithFrame:CGRectMake(205,0,35,55)];
    totalTiltleLabel.backgroundColor = [UIColor clearColor];
    totalTiltleLabel.textColor = [RTSSAppStyle currentAppStyle].textGreenColor;
    totalTiltleLabel.text = @"Total:";
    totalTiltleLabel.textAlignment = NSTextAlignmentCenter;
    totalTiltleLabel.font = [RTSSAppStyle getRTSSFontWithSize:14];
    totalTiltleLabel.numberOfLines = 1;
    totalTiltleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [self.view addSubview:totalTiltleLabel];
    [totalTiltleLabel release];
    
    //Total Value
    UILabel* totalValueLabelTemp = [[UILabel alloc] initWithFrame:CGRectMake(240,0,80,55)];
    totalValueLabelTemp.backgroundColor = [UIColor clearColor];
    totalValueLabelTemp.textColor = [RTSSAppStyle currentAppStyle].textGreenColor;
    totalValueLabelTemp.text = @"0B";
    totalValueLabelTemp.textAlignment = NSTextAlignmentCenter;
    totalValueLabelTemp.font = [RTSSAppStyle getRTSSFontWithSize:14];
    totalValueLabelTemp.numberOfLines = 1;
    totalValueLabelTemp.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [self.view addSubview:totalValueLabelTemp];
    self.totalValueLabel = totalValueLabelTemp;
    [totalValueLabelTemp release];
    
    UIImageView* lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 55, PHONE_UISCREEN_WIDTH, 1)];
    lineImageView.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [self.view addSubview:lineImageView];
    [lineImageView release];
}

- (void)addAppListView
{
    FlowByAppTableView* appListViewTemp = [[FlowByAppTableView alloc] initWithFrame:CGRectMake(0, 56, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-20-44-56)];
    appListViewTemp.delegate = self;
    [self.view addSubview:appListViewTemp];
    self.appTableView = appListViewTemp;
    [appListViewTemp release];
}

- (void)removeAppListView
{
    if(nil != self.appTableView){
        [self.appTableView removeFromSuperview];
    }
}

- (void)addDateListView
{
    FlowByDateTableView* dateListViewTemp = [[FlowByDateTableView alloc] initWithFrame:CGRectMake(0, 56, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-20-44-56)];
    dateListViewTemp.delegate = self;
    [self.view addSubview:dateListViewTemp];
    self.dateTableView = dateListViewTemp;
    [dateListViewTemp release];
}

- (void)removeDateListView
{
    if(nil != self.dateTableView){
        [self.dateTableView removeFromSuperview];
    }
}

- (void)loadView
{
    [super loadView];
    
    [self layoutNavigationBar];
    [self layoutSegmentView];
    
    [[C3DataConfig standardC3DataConfig] readUserDataC3];
}

- (void)updateTotalFlowUI:(NSNumber*)totalNumber
{
    if(nil != totalNumber){
        long long totalReal = [totalNumber longLongValue];
        [self.totalValueLabel setText:[CommonUtils formatDataWithByte:totalReal decimals:2 unitEnable:YES]];
    }else{
        [self.totalValueLabel setText:[CommonUtils formatDataWithByte:0 decimals:2 unitEnable:YES]];
    }
}

//解析应用列表数据，并处理
- (void)resolveAppList
{
    if(nil != self.appListResultDic){
        int errorCode = [[self.appListResultDic objectForKey:@"errorCode"] intValue];
        if(0 == errorCode){
            NSDictionary* appDic = [StaticData getAppListData:self.appListResultDic];
            NSMutableArray* appArray = [appDic objectForKey:@"AppList"];
            NSNumber* totalNumber = [appDic objectForKey:@"AppTotal"];
            if(nil != appArray && [appArray count] > 0 && nil != totalNumber){
                if(self.appTableView){
                    self.appListDic = appDic;
                    [self updateTotalFlowUI:totalNumber];
                    self.appTableView.totalAppFlow = totalNumber;
                    [self.appTableView reloadTableViewRow:appArray];
                }
            }else{
                [self updateTotalFlowUI:totalNumber];
                //[MyAlertView showSimpleAlertView:NSLocalizedString(@"MobileUsage_Network_Data_Empty_Prompt", nil)];
            }
        }else{
            [self updateTotalFlowUI:nil];
            //[MyAlertView showSimpleAlertView:[self.appListResultDic objectForKey:@"errorMsg"]];
            //[MyAlertView showSimpleAlertView:NSLocalizedString(@"MobileUsage_Network_Data_Empty_Prompt", nil)];
        }
    }
}

- (void)sendLoadAppListMessage
{
    C3DataConfig* config = [C3DataConfig standardC3DataConfig];

    self.appListResultDic = [config getUserDataByC3WithDataKey:@"AppListDic"];
}

- (void)refreshAppListData
{
    [self removeAppListView];
    [self removeDateListView];
    [self addAppListView];
    
    [APPLICATION_KEY_WINDOW makeToastActivity];
    
    [self sendLoadAppListMessage];
    [self resolveAppList];
    
    [APPLICATION_KEY_WINDOW hideToastActivity];
}

//解析时间列表，并处理
- (void)resolveDateList
{
    if(nil != self.dateListResultDic){
        int errorCode = [[self.dateListResultDic objectForKey:@"errorCode"] intValue];
        if(0 == errorCode){
            NSDictionary* dateDic = [StaticData getDateListData:self.dateListResultDic];
            NSMutableArray* dateArray = [dateDic objectForKey:@"DateList"];
            NSNumber* totalNumber = [dateDic objectForKey:@"DateTotal"];
            if(nil != dateArray && [dateArray count] > 0 && nil != totalNumber){
                if(self.dateTableView){
                    self.dateListDic = dateDic;
                    [self updateTotalFlowUI:totalNumber];
                    self.dateTableView.totalAppFlow = totalNumber;
                    [self.dateTableView reloadTableViewRow:dateArray];
                }
            }else{
                [self updateTotalFlowUI:nil];
                //[MyAlertView showSimpleAlertView:NSLocalizedString(@"MobileUsage_Network_Data_Empty_Prompt", nil)];
            }
        }else{
            [self updateTotalFlowUI:nil];
            //[MyAlertView showSimpleAlertView:[self.dateListResultDic objectForKey:@"errorMsg"]];
            //[MyAlertView showSimpleAlertView:NSLocalizedString(@"MobileUsage_Network_Data_Empty_Prompt", nil)];
        }
    }
}

- (void)sendLoadDateListMessage
{
    C3DataConfig* config = [C3DataConfig standardC3DataConfig];
    self.dateListResultDic = [config getUserDataByC3WithDataKey:@"DateListDic"];
}

- (void)refreshDateListData
{
    [self removeDateListView];
    [self removeAppListView];
    [self addDateListView];
    
    [APPLICATION_KEY_WINDOW makeToastActivity];
    
    [self sendLoadDateListMessage];
    [self resolveDateList];
    
    [APPLICATION_KEY_WINDOW hideToastActivity];
}

- (void)refreshListData
{
    if(currentType == AppListType){
        [self refreshAppListData];
    }else if(currentType == DateListType){
        [self refreshDateListData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Home_Menu_Usage_Data", nil);
    
    currentType = AppListType;

    [self refreshListData];
}

-(void)onAppListTouchUpInside:(id)action
{
    currentType = AppListType;
    
    UIButton* button = (UIButton*)action;
    if(button.isSelected){
        //已经被选中了
    }else{
        //将要选中
        [appListButton setSelected:YES];
        [dateListButton setSelected:NO];
    }
    
    [self refreshListData];
}

-(void)onDateListTouchUpInside:(id)action
{
    currentType = DateListType;
    
    UIButton* button = (UIButton*)action;
    if(button.isSelected){
        //已经选中了
    }else{
        //将要选中
        [appListButton setSelected:NO];
        [dateListButton setSelected:YES];
    }
    
    [self refreshListData];
}

#pragma mark -
#pragma mark FlowDateSearchDelegate
- (void)flowDateStart:(NSDate*)start dateEnd:(NSDate*)end
{
    self.startDate = start;
    self.endDate = end;
    
    //[[NSUserDefaults standardUserDefaults] setObject:start forKey:C3_GET_DATA_START_DATE_KEY];
    //[[NSUserDefaults standardUserDefaults] setObject:end forKey:C3_GET_DATA_END_DATE_KEY];
    
    [self refreshListData];
}

#pragma mark -
#pragma mark FlowByAppTableViewDelegate
- (void)flowByAppTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(nil == self.appListDic){
        //[MyAlertView showSimpleAlertView:@"Data Error!"];
    }else{
        AppListByMonthVC* VC = [[AppListByMonthVC alloc] init];
        VC.appItemDic = [[self.appListDic objectForKey:@"AppList"] objectAtIndex:indexPath.row];
        VC.startDate = self.startDate;
        VC.endDate = self.endDate;
        VC.rowKey = indexPath.row;
        [self.navigationController pushViewController:VC animated:YES];
        [VC release];
    }
}

#pragma mark -
#pragma mark FlowByDateTableViewDelegate
- (void)flowByDateTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(nil == self.dateListDic){
        //[MyAlertView showSimpleAlertView:@"Data Error!"];
    }else{
        DateListByMonthVC* VC = [[DateListByMonthVC alloc] init];
        VC.dateItemDic = [[self.dateListDic objectForKey:@"DateList"] objectAtIndex:indexPath.row];
        VC.rowKey = indexPath.row;
        [self.navigationController pushViewController:VC animated:YES];
        [VC release];
    }
}

@end
