//
//  ETTQueryMonthViewController.m
//  EasyTT
//
//  Created by 蔡杰 on 14-10-22.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import "QueryMonthViewController.h"


#import "EColumnChartView.h"
#import "EColumnDataModel.h"
#import "CommonUtils.h"
#import "DateUtils.h"
#import "MonthflowTableViewCell.h"
#include "RTSSAppStyle.h"


#define ETTCellRowHeight 44.0f


@implementation QueryMonthTableHeaderView
@synthesize mColumnChartView;

- (void)dealloc
{
    [mColumnChartView release];
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutContentViewWithFrame:frame];
    }
    return self;
}

- (void)layoutContentViewWithFrame:(CGRect)frame
{
    mColumnChartView = [[EColumnChartView alloc] initWithFrame:CGRectMake(0, 5, self.bounds.size.width, self.bounds.size.height -5)];
    mColumnChartView.backgroundColor = [UIColor clearColor];
    [self addSubview:mColumnChartView];

}

@end



@interface QueryMonthViewController ()
{
    QueryMonthTableHeaderView* headerView;

}
@end

@implementation  QueryMonthViewController

-(void)loadView
{
    [super loadView];
    self.view.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    headerView = [[QueryMonthTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 210)];
    headerView.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    
    //addline
    [headerView addSubview:[self createLineImageViewWithY:headerView.bounds.size.height-2]];
    self.tableView.tableHeaderView =  headerView;
    //self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    self.tableView.rowHeight = ETTCellRowHeight;
    
    //[self configuraTableViewNormalSeparatorInset];
}


#pragma mark --LifeStyle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Month flow";
    
    
    [self loadChartViewData];
    
    [self.dataSource addObject:@"1"];
    [self.dataSource addObject:@"2"];
    
    [self.tableView reloadData];
}
-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  --Overide


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentify = @"CellIdentify";

    MonthflowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentify];
    if (!cell) {
        cell = [[[MonthflowTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentify]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row%2) {
        [cell updateDetailInfo:@"Jio 51 plan for 50MB data" DataLeft:@"30M/100M"];
    }else{
        
         [cell updateDetailInfo:@"Jio 51 plan for 200MB data" DataLeft:@"60M/100M"];
    }

    return cell ;
    
    
}


-(UIImageView*)createLineImageViewWithY:(CGFloat)lineY{
    
    UIImageView *line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line"]];
    line.frame = CGRectMake(0, lineY, PHONE_UISCREEN_WIDTH, 2);
    return [line autorelease];
    
}

#pragma mark --假数据

- (void)loadChartViewData
{
    long long totalValue = 1024*1024*1024ll;
    NSInteger days = [DateUtils getNumbersOfDaysByMonth];
    CGFloat averageValue = (CGFloat)((totalValue*1.0)/(1024*1024)/days);
    
    NSMutableArray* columnArray = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i = 0; i < 10; i ++) {
        NSMutableArray* rowsArray = [[NSMutableArray alloc] initWithCapacity:3];
        for (int i = 1; i <= 3; i ++) {
            CGFloat value = arc4random() % 1024 / days;
            NSString* labelString = [NSString stringWithFormat:@"%d",i];
            NSString* valueText = [NSString stringWithFormat:@"%0.1f", value];
            EColumnDataModel* eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:labelString
                                                                               valueText:valueText
                                                                                   value:value
                                                                            averageValue:averageValue
                                                                                   index:i
                                                                                    unit:@"MB"];
            [rowsArray addObject:eColumnDataModel];
            [eColumnDataModel release];
        }
        [columnArray addObject:rowsArray];
        [rowsArray release];
    }

    [headerView.mColumnChartView reloadChartData:columnArray];
    
    [columnArray release];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
