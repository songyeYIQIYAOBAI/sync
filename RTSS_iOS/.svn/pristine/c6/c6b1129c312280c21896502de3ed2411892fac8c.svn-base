//
//  UsageAlertViewController.m
//  RTSS
//
//  Created by tiger on 14-11-26.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "UsageAlertViewController.h"
#import "UsageAlertListView.h"
#import "UsageAlertListModel.h"
#import "RTSSAppStyle.h"

@interface UsageAlertViewController ()
{
    UsageAlertListView * usageAlertView;
    UsageAlertListModel * currentOperModel;
    UIButton * currentOperButton;
}
@end

@implementation UsageAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Usage Alert";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadView
{
    [super loadView];
    
    usageAlertView = [[UsageAlertListView alloc]initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-64)];
    usageAlertView.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    usageAlertView.delegate = self;
    usageAlertView.headTitle = @"Custom your threshod limit for the below services";
    [self.view addSubview:usageAlertView];
    [usageAlertView release];
}

-(void)loadData
{
    usageAlertView.dataList = [self fakeData];
}

-(NSMutableArray *)fakeData
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:10];
    
    //////////////////////第一组数据
    UsageAlertListModel * model = [[UsageAlertListModel alloc]init];
    model.isOpen = NO;
    model.layer = 1;
    model.content = @"LTE MIFI";
    
    NSMutableArray * children = [NSMutableArray arrayWithCapacity:10];
    
    UsageAlertListModel * children1 = [[UsageAlertListModel alloc]init];
    children1.isOpen = NO;
    children1.layer = 2;
    children1.content = @"50M for 1 day";
    children1.notificationValue = @"80%";
    [children addObject:children1];
    [children1 release];
    
    UsageAlertListModel * children2 = [[UsageAlertListModel alloc]init];
    children2.isOpen = NO;
    children2.layer = 2;
    children2.content = @"50M for 1 day";
    children2.notificationValue = @"60%";
    [children addObject:children2];
    [children2 release];
    
    model.children = children;
    [array addObject:model];
    
    //////////////////////第二组数据
    UsageAlertListModel * model2 = [[UsageAlertListModel alloc]init];
    model2.isOpen = NO;
    model2.layer = 1;
    model2.content = @"LTE FTTX";
    
    NSMutableArray * twochildren = [NSMutableArray arrayWithCapacity:10];
    
    UsageAlertListModel * children21 = [[UsageAlertListModel alloc]init];
    children21.isOpen = NO;
    children21.layer = 2;
    children21.content = @"50M for 1 day";
    children21.notificationValue = @"80%";
    [twochildren addObject:children21];
    [children21 release];
    
    UsageAlertListModel * children22 = [[UsageAlertListModel alloc]init];
    children22.isOpen = NO;
    children22.layer = 2;
    children22.content = @"50M for 1 day";
    children22.notificationValue = @"60%";
    [twochildren addObject:children22];
    [children22 release];
    
    model2.children = twochildren;
    [array addObject:model2];
    ///////////////////////////////////////
    
    
    return array;
}

#define mark - UsageAlertListViewDelegate
-(void)UsageAlertListViewNotificationClick:(UIButton *)button WithModel:(UsageAlertListModel *)model
{
    //当前操作的单元格元素
    currentOperButton = button;
    currentOperModel = model;
    
    SinglePickerController * pick = [[SinglePickerController alloc]init];
    pick.pickerTitle = NSLocalizedString(@"Budget_Notification_Setting_Prompt", nil);
    pick.pickerType = SinglePickerTypePercent;
    pick.delegate = self;
    pick.pickerArrayData = [NSArray arrayWithObjects:@70, @80, @90, @100, nil];
    [self.view.window addSubview:pick.view];
}

#pragma mark - SinglePickerDelegate implement
-(void)singlePickerWithDone:(SinglePickerController*)controller selectedIndex:(NSInteger)index
{
    NSNumber * notificationValue = [controller.pickerArrayData objectAtIndex:index];
    
    //如何网络请求成功
    [currentOperButton setTitle: [NSString stringWithFormat:@"%@%%", notificationValue] forState:UIControlStateNormal];
    currentOperModel.notificationValue = [NSString stringWithFormat:@"%@%%", notificationValue];
    
    
    [controller.view removeFromSuperview];
    [controller release];
}

-(void)singlePickerWithCancel:(SinglePickerController*)controller
{
    [controller.view removeFromSuperview];
    [controller release];
}

@end
