//
//  MyUsageViewController.m
//  RTSS
//
//  Created by 蔡杰Alan on 14-11-28.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "MyUsageViewController.h"
#import "MyUsageTableViewCell.h"
#import "EColumnChartView.h"
#import "EColumnDataModel.h"
#import "DateUtils.h"

#import "Session.h"
#import "Customer.h"
#import "ErrorMessage.h"

static int kDateNumber = 10;  //显示日期数

@interface MyUsageTableHeaderView ()

@end

@implementation MyUsageTableHeaderView
@synthesize mColumnChartView;

- (void)dealloc{
    [mColumnChartView release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutContentViewWithFrame:frame];
    }
    return self;
}

- (void)layoutContentViewWithFrame:(CGRect)frame{
    mColumnChartView = [[EColumnChartView alloc] initWithFrame:CGRectMake(20, 5, self.bounds.size.width-40, self.bounds.size.height-5)];
    mColumnChartView.backgroundColor = [UIColor clearColor];
    [self addSubview:mColumnChartView];
    
}


@end


@interface MyUsageViewController ()<MappActorDelegate>{
    MyUsageTableHeaderView* headerView;
    NSInteger iCount;
}
@property(nonatomic,retain)NSArray *infoArray;
@property(assign,nonatomic)BOOL empty;  //标记10天数据是否全部为空
@end

@implementation MyUsageViewController
@synthesize infoArray;
#pragma mark --ViewLife
- (void)dealloc{
    [navigationBarView release];
    [infoArray release];
    [super dealloc];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"MyUSage_Title", nil);
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [APPLICATION_KEY_WINDOW hideToastActivity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadView
{
    [super loadView];
    self.view.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    CGFloat headerViewHeight = 210;
    headerView = [[MyUsageTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, headerViewHeight)];
    headerView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    [headerView addSubview:[self createLineImageViewWithY:headerView.bounds.size.height-1]];////addline
    [self.view addSubview:headerView];
    
    iCount = 0;
    
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(headerView.frame), PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-CGRectGetMaxY(headerView.frame)-64);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    self.tableView.rowHeight = 44.0f;
}
-(void)loadData{
    
#ifndef APPLICATION_BUILDING_RELEASE
    self.empty = YES;
    [self emptyLogic];
    return;
#endif
    [APPLICATION_KEY_WINDOW makeToastActivity];
    Customer *myCustomer = [Session sharedSession].mMyCustomer;
    if (!myCustomer) {
        return;
    }
    //日期包括今天
    NSDate *endDate = [NSDate date];
    NSDate *beginDate = [DateUtils dateWithDaysFromDate:endDate BySubtractingDays:kDateNumber-1];
    
    NSString *dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *beginDateString = [DateUtils getStringDateByDate:beginDate dateFormat:dateFormat];
    
    NSString *endDateString  = [DateUtils getStringDateByDate:endDate dateFormat:dateFormat];
    NSLog(@"beginDateString=%@，end=%@",beginDateString,endDateString);
    [myCustomer queryUsageDetailWithSubscriberId:@"" andType:1 andStartDate:beginDateString andEndDate:endDateString andDelegate:self];
    
}
#pragma mark --MappActorDelegate

-(void)queryUsageDetailFinished:(NSInteger)status andInfo:(NSDictionary *)usage{
    [APPLICATION_KEY_WINDOW hideToastActivity];
    //错误处理
    if(MappActorFinishStatusOK != status){
        
        if(MappActorFinishStatusNetwork == status){
            [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"ErroMessage_Status_Network", nil)];
        }else{
            [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"MyUsage_NoData", nil)];
        }
        //后台无数据返
        self.empty = YES;
        [self emptyLogic];
        return;
    }
    
    //返回数据判断
    if ( !usage || ![usage count]>0 ) {
        //返回数组为空或没有处理
        // [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"MyUsage_Failed", nil)];
        //后台无数据返回
        self.empty = YES;
        [self emptyLogic];
        return;
    }
    
    @try {
        
        id info = [usage objectForKey:@"info"];
        
        //info 参考标准   不存在返回
        if (![info isKindOfClass:[NSArray class]] || ![(NSArray*)info count] > 0) {
            [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"MyUsage_Failed", nil)];
            return;
        }
        iCount = [(NSArray*)info count];
        
        self.infoArray = (NSArray*)info;
        
        //USage 目前只有一个元素
        NSDictionary *usageList = [usage objectForKey:@"usageMap"];
        
        if (![CommonUtils objectIsValid:usageList]) {
            return;
        }
        
        NSDate *currentDate = [NSDate date];
        //根据日期遍历
        for (int i = 1 ; i <=kDateNumber; i++) {
            
            NSDate *date = [DateUtils dateWithDaysFromDate:currentDate BySubtractingDays:kDateNumber-i];
            //date key 规则   "2014-12-16"
            NSString *dateKey  = [DateUtils getStringDateByDate:date dateFormat:@"yyyy-MM-dd"];
            NSLog(@"dateKey = %@",dateKey);
            
            //model部分数据
            NSString* labelString = [DateUtils getStringDateByDate:date dateFormat:@"dd/MM"];
            
            CGFloat value = 0;
            NSString* valueText = @"0";
            
            if ([[usageList allKeys] containsObject:dateKey]) {
                
                NSLog(@"找到--%@",dateKey);
                //返回数值包含日期key
                NSDictionary *dateDic = [usageList objectForKey:dateKey];
                //存储数据
                NSMutableArray *modelArray = [NSMutableArray array];
                for (int index = 0; index < [(NSArray*)info count]; index++) {
                    
                    NSDictionary *infoSubDic = [(NSArray*)info objectAtIndex:index];
                    
                    NSString *groupId = [infoSubDic objectForKey:@"groupId"];
                    CGFloat  maxAmount = [(NSNumber*)[infoSubDic objectForKey:@"maxAmount"]longLongValue];
                    
                    EColumnDataModel *eColumnDataModel = nil;
                    //一天当中包含此GroupID
                    if ([[dateDic allKeys]containsObject:groupId]) {
                        
                        NSDictionary *groupIdDic = [dateDic objectForKey:groupId];
                        NSString *name = [groupIdDic objectForKey:@"name"];
                        CGFloat quantity = [(NSNumber*)[groupIdDic objectForKey:@"quantity"]longLongValue];
                        NSInteger measureId = [(NSNumber*)[groupIdDic objectForKey:@"measureId"]integerValue];
                        
                        if(quantity > 0)
                            valueText = [NSString stringWithFormat:@"%.0f",[UsageModel transformeWithNumerical:quantity byMessureId:measureId]];
                        
                        NSString *unit = [CommonUtils getUnitName:measureId];
                        eColumnDataModel = [[EColumnDataModel alloc]initWithLabel:labelString valueText:valueText value:quantity averageValue:quantity maxValue:maxAmount index:index unit:unit groupId:groupId messureId:measureId name:name];
                    }else{
                        //不包含，生成空值
                        valueText = @"0";
                        
                        CGFloat maxValue = [(NSNumber*)[infoSubDic objectForKey:@"maxAmount"]longLongValue];
                        NSString *groupId = [infoSubDic objectForKey:@"groupId"];
                        NSInteger measureId = [(NSNumber*)[infoSubDic objectForKey:@"measureId"]integerValue];
                        NSString *name = [infoSubDic objectForKey:@"groupName"];
                        NSString *unit = [CommonUtils getUnitName:measureId];
                        
                        eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:labelString
                                                                         valueText:valueText
                                                                             value:value
                                                                      averageValue:value
                                                                          maxValue:maxValue
                                                                             index:index
                                                                              unit:unit groupId:groupId messureId:measureId name:name];
                        
                    }
                    
                    [modelArray addObject:eColumnDataModel];
                    
                    if (eColumnDataModel)  [eColumnDataModel release];
                }
                
                //元素
                NSDictionary *element = [NSDictionary dictionaryWithObject:modelArray forKey:dateKey];
                //数据源添加元素
                [self.dataSource addObject:element];
                
            }else{
                //返回数据没有时间key值 添加空值model
                NSLog(@"未找到");
                NSMutableArray *emptyModelArray = [NSMutableArray array];
                
                for (int index = 0; index < [(NSArray*)info count]; index++) {
                    
                    NSDictionary *infoSubDic = [(NSArray*)info objectAtIndex:index];
                    
                    CGFloat maxValue = [(NSNumber*)[infoSubDic objectForKey:@"maxAmount"]longLongValue];
                    NSString *groupId = [infoSubDic objectForKey:@"groupId"];
                    NSInteger measureId = [(NSNumber*)[infoSubDic objectForKey:@"measureId"]integerValue];
                    NSString *name = [infoSubDic objectForKey:@"groupName"];
                    NSString *unit = [UsageModel unitByMessureId:measureId];
                    
                    EColumnDataModel  * eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:labelString
                                                                                         valueText:valueText
                                                                                             value:value
                                                                                      averageValue:value
                                                                                          maxValue:maxValue
                                                                                             index:index
                                                                                              unit:unit groupId:groupId messureId:measureId name:name];
                    
                    [emptyModelArray addObject:eColumnDataModel];
                    [eColumnDataModel release];
                    
                }
                //元素
                NSDictionary *emptyElement = [NSDictionary dictionaryWithObject:emptyModelArray forKey:dateKey];
                //数据源添加元素
                [self.dataSource addObject:emptyElement];
            }
            
        }
        NSLog(@"datesource = %@",self.dataSource);
        [self.tableView reloadData];
        [self loadChartViewData];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}
-(void)emptyLogic{
    
    for (int i = 0 ; i < kDateNumber; i++) {
        
        NSDate *date = [DateUtils dateWithDaysFromDate:[NSDate date] BySubtractingDays:kDateNumber-i];
        //date key 规则   "2014-12-16"
        NSString *dateKey  = [DateUtils getStringDateByDate:date dateFormat:@"yyyy-MM-dd"];
        // NSLog(@"dateKey = %@",dateKey);
        //model部分数据
        NSString* labelString = [DateUtils getStringDateByDate:[DateUtils dateWithDaysFromDate:[NSDate date] BySubtractingDays:kDateNumber-i] dateFormat:@"dd/MM"];
        NSMutableArray *emptyModelArray = [NSMutableArray array];
        
        for (int index = 0; index < 2; index++) {
            
            EColumnDataModel  * eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:labelString
                                                                                 valueText:@""
                                                                                     value:0
                                                                              averageValue:0
                                                                                  maxValue:0
                                                                                     index:index
                                                                                      unit:@"" groupId:0 messureId:0 name:@""];
            
            [emptyModelArray addObject:eColumnDataModel];
            [eColumnDataModel release];
            
        }
        //元素
        NSDictionary *emptyElement = [NSDictionary dictionaryWithObject:emptyModelArray forKey:dateKey];
        //数据源添加元素
        [self.dataSource addObject:emptyElement];
        
    }
    
    [self.tableView reloadData];
    [self loadChartViewData];
}
#pragma mark --加载柱状图数据
- (void)loadChartViewData
{
    NSMutableArray* columnArray = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i = 0; i < kDateNumber; i++) {
        NSDictionary *subDic = [self.dataSource objectAtIndex:i];
        [columnArray addObject:[subDic.allValues objectAtIndex:0]];
    }
    
    [headerView.mColumnChartView reloadChartData:columnArray isHiddenLegend:self.empty];
    [headerView.mColumnChartView scrollToLast:NO];
    [columnArray release];
}


-(UIImageView*)createLineImageViewWithY:(CGFloat)lineY{
    UIImageView *line = [[UIImageView alloc]init];
    line.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    line.frame = CGRectMake(0, lineY, PHONE_UISCREEN_WIDTH, 1);
    return [line autorelease];
    
}
#pragma mark --Override
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    MyUsageTableViewCell *header = [[MyUsageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if ([self.dataSource count]>0) {
        [header dynamicInstallLabelWithCount:iCount+1 AllEmpty:self.empty];//第一个默认为Date
        [header setBackgroundViewColor:[RTSSAppStyle currentAppStyle].navigationBarColor];
        [header showTitle:self.infoArray];
        
    }
    
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *const CellIndentify = @"MyUsage";
    
    MyUsageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentify];
    if (nil == cell) {
        cell = [[MyUsageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentify];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([self.dataSource count]>0) {
        [cell dynamicInstallLabelWithCount:iCount+1 AllEmpty:self.empty];//第一个默认为Date
        
    }
    
    if (indexPath.row < [self.dataSource count]) {
        NSInteger index = self.dataSource.count - indexPath.row-1;
        NSDictionary *dic = [self.dataSource objectAtIndex:index];
        [cell showUserDayWithDictionay:dic];
    }
    if (indexPath.row%2) {
        //颜色分割区分
    }
    return cell;
}

@end
