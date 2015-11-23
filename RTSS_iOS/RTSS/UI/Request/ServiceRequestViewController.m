//
//  ServiceRequestViewController.m
//  RTSS
//
//  Created by 蔡杰Alan on 15-1-16.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "ServiceRequestViewController.h"
#import "AddServiceRequestViewController.h"
#import "RTSSAppStyle.h"
#import "ServiceRequestCell.h"
#import "ServiceRequestHeaderView.h"
#import "Toast+UIView.h"
#import "session.h"
#import "Customer.h"
#import "Account.h"
//========Macro



//========

@interface ServiceRequestViewController ()<DateFootprintDelegate,UITableViewDataSource,UITableViewDelegate,MappActorDelegate>{
    
}
@property(nonatomic,retain)ServiceRequestHeaderView *headerView;
@property(nonatomic,retain)UITableView *mTableView;
@property(nonatomic,retain)NSMutableArray *dataSource;//数据源
@property(nonatomic,retain)NSMutableArray *serversDataSource;//服务器数据源
@property(nonatomic,retain)NSDate *mDate;
@property(nonatomic,retain)NSMutableArray *mFiltrateArray;
@property(nonatomic,retain)NSMutableDictionary *mIndexDic;
@end

@implementation ServiceRequestViewController
@synthesize headerView,mTableView,dataSource,serversDataSource,mDate,mFiltrateArray,mIndexDic;
#pragma mark --LifetStyle
-(void)dealloc{
    [headerView release];
    [mTableView release];
    [dataSource release];
    [serversDataSource release];
    [mDate release];
    [mIndexDic release];
    [mFiltrateArray release];
    [super dealloc];
}
-(void)loadView{
    [super loadView];
    self.dataSource = [NSMutableArray arrayWithCapacity:0];
    self.serversDataSource = [NSMutableArray arrayWithCapacity:0];
    self.mIndexDic = [NSMutableDictionary dictionaryWithCapacity:0];
    self.mFiltrateArray = [NSMutableArray arrayWithCapacity:0];
    self.mDate = [NSDate date];
     self.view.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    [self loadHeaderView];
    [self loadTableView];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Service_Request_Title", nil);
//    [self updateData];
  
}
-(void)loadHeaderView{
    
    CGRect mHeaderRect = CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 166);
    
    if (PHONE_UISCREEN_IPHONE5) {
        mHeaderRect = CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 180);
    }
    else if (PHONE_UISCREEN_IPHONE6) {
        mHeaderRect = CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 200);
    }
    else if (PHONE_UISCREEN_IPHONE6PLUS) {
        mHeaderRect = CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 220);
    }
    NSArray *categoryArray = @[
                               @{@"categoryName":NSLocalizedString(@"Service_Request_categoryId_All", nil),@"categoryId":@"All"},
                               @{@"categoryName":NSLocalizedString(@"Service_Request_categoryId_Open", nil),@"categoryId":@"Open"},
                               @{@"categoryName":NSLocalizedString(@"Service_Request_categoryId_Resolved", nil),@"categoryId":@"Resolved"},
                               @{@"categoryName":NSLocalizedString(@"Service_Request_categoryId_Rejected", nil),@"categoryId":@"Rejected"},
                               @{@"categoryName":NSLocalizedString(@"Service_Request_categoryId_ReOpen", nil),@"categoryId":@"ReOpen"},
                               @{@"categoryName":NSLocalizedString(@"Service_Request_categoryId_Closed", nil),@"categoryId":@"Closed"}];
    
    
    //NSLocalizedString(@"Service_Request_categoryId_All", nil)
    [self.mFiltrateArray addObjectsFromArray:categoryArray];
    
    
    
    self.headerView = [[[ServiceRequestHeaderView alloc]initWithFrame:mHeaderRect] autorelease];
    [self.headerView install_SR_MoreSubviewsButton:self.mFiltrateArray];
    self.headerView.backgroundColor= [RTSSAppStyle currentAppStyle].navigationBarColor;
    self.headerView.delegate = self;
    [self.view addSubview:self.headerView];
//    [headerView release];
}
-(void)loadTableView{
    
    
    CGRect mTableRect = CGRectMake(0, 166, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-180-26-20);
    if (PHONE_UISCREEN_IPHONE5) {
        mTableRect = CGRectMake(0, 180, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-180-40-20);
    }
    else if (PHONE_UISCREEN_IPHONE6) {
        mTableRect = CGRectMake(0, 200, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-180-60-20);
    }
    else if (PHONE_UISCREEN_IPHONE6PLUS) {
        mTableRect = CGRectMake(0, 220, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-180-60-20-20);
    }
    
    UITableView *tableViewTemp = [[UITableView alloc]initWithFrame:mTableRect style:UITableViewStylePlain];
    tableViewTemp.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    tableViewTemp.delegate = self;
    tableViewTemp.dataSource = self;
     tableViewTemp.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableViewTemp setSeparatorInset:UIEdgeInsetsZero];
    self.mTableView = tableViewTemp;
    [tableViewTemp release];
}

- (void)loadData
{
    [self loadServersData:[NSDate date]];
}

// 根据date转换string
- (NSString *)getDateString:(NSDate *)bDate
{
    return [DateUtils getStringDateByDate:bDate dateFormat:@"yyyyMMddHHmmss"];
}

- (void)loadServersData:(NSDate *)aDate{
    NSDate *startDate = [DateUtils dateAtStartOfDayByDate:aDate];
    NSDate *endDate   = [DateUtils dateAtEndOfDayByDate:aDate];
    
    
    // 根据起始和结束时间请求数据
    [APPLICATION_KEY_WINDOW makeToastActivity];
    [[Session sharedSession].mMyCustomer queryMyServiceRequestWithAccountId:[Session sharedSession].mCurrentAccount.mId andState:0 andBeginDate:[self getDateString:startDate] andEndDate:[self getDateString:endDate] andDelegate:self];
    
    
    
}

//  请求数据回调
- (void)queryMyServiceRequestFinished:(NSInteger)status andInfo:(NSArray *)info
{
    [APPLICATION_KEY_WINDOW hideToastActivity];
    if (status == MappActorFinishStatusOK) {
        if ([self.dataSource count] > 0) {
            [self.dataSource removeAllObjects];
        }
        [self.serversDataSource removeAllObjects];
        [self.mIndexDic removeAllObjects];
        [self classifyDataSource:info];
    }
}

- (void)classifyDataSource:(NSArray *)info
{
    NSString *statusType;
    [self.serversDataSource addObjectsFromArray:info];
    for (int i = 0; i < [info count]; i++) {
        statusType = [self covertStatus:[[[info objectAtIndex:i] objectForKey:@"status"]integerValue]];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[self.mIndexDic objectForKey:statusType]];
        if (array) {
            [array addObject:[info objectAtIndex:i]];
            [self.mIndexDic setObject:array forKey:statusType];
        } else {
            NSMutableArray *array2 = [NSMutableArray arrayWithCapacity:0];
            [array2 addObject:[info objectAtIndex:i]];
            [self.mIndexDic setObject:array2 forKey:statusType];
        }
        
    }
    [self.dataSource addObjectsFromArray:info];
    [self updateData];
}

-(NSString*)covertStatus:(NSInteger)status{
    
    switch (status) {
            
            
        case 1:{
            
            return NSLocalizedString(@"Service_Request_categoryId_Open", nil);
            break;
        }
        case 2:{
            return NSLocalizedString(@"Service_Request_categoryId_Resolved", nil);
            break;
        }
        case 3:{
            return NSLocalizedString(@"Service_Request_categoryId_Rejected", nil);
            break;
        }
        case 4:{
            return NSLocalizedString(@"Service_Request_categoryId_ReOpen", nil);
            break;
        }
        case 5:{
            return NSLocalizedString(@"Service_Request_categoryId_Closed", nil);
            break;
        }
        default:
            return @"";
            break;
    }
}


//checkFooterView  addFooterView  废弃
-(void)checkFooterView{
    
    CGFloat height =self.mTableView.frame.size.height - [ServiceRequestCell serviceRequestCellFixedHeight]*self.dataSource.count;
    
    [self addFooterView:CGSizeMake(self.mTableView.frame.size.width,height>0?height:0)];
    
}

-(void)addFooterView:(CGSize)size{
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(100,0, 2, size.height)];
    lineView.backgroundColor =[RTSSAppStyle currentAppStyle].navigationBarColor;
    [footerView addSubview:lineView];
    self.mTableView.tableFooterView = footerView;
    [lineView release];
    [footerView release];

}
#pragma mark --Property
//-(NSMutableArray *)dataSource{
//    
//    if (!_dataSource) {
//        _dataSource = [[NSMutableArray alloc]init];
//    }
//    
//    return _dataSource;
//}


#pragma mark --UITableView Delegate && DateSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [ServiceRequestCell serviceRequestCellFixedHeight];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *const CellIdentify = @"ServiceRequest";
    
    ServiceRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentify];
    
    if (cell == nil) {
        
        cell = [[[ServiceRequestCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentify]autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setCellBlackColor:[RTSSAppStyle currentAppStyle].viewControllerBgColor];
    }
    
    NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
    [cell updateData:dic];
    [cell addLastLine];
    //去掉最后一个cell的尾线条
    if (indexPath.row == self.dataSource.count - 1) {
        [cell removeLastLine];
    }
    
    return cell;
}

-(void)updateData{
    [self.mTableView reloadData];
    [self.mTableView removeFromSuperview];
     CGRect Oriframe = self.mTableView.frame;
    CGRect frame = self.mTableView.frame;
    frame.origin.y = CGRectGetMaxY(self.view.frame)+frame.size.height;
    self.mTableView.frame = frame;
    [self.view addSubview:self.mTableView];
    [UIView animateWithDuration:1.0 animations:^{
        self.mTableView.frame = Oriframe;
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark--ServiceRequestHeader Delegate

-(void)updateUserDate:(NSDate *)aDate{
    //不同月份
    [self.headerView allButtonGreen];
    self.mDate = aDate;
    [self.dataSource removeAllObjects];
    [self loadServersData:aDate];
}

-(void)serviceRequestActionType:(NSString *)actionType{
    if ([actionType isEqualToString:NSLocalizedString(@"Service_Request_categoryId_All", nil)]) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:self.serversDataSource];
    } else if ([actionType isEqualToString:@"Add"]) {
        [self addServiceRequest];
    }
    else {
        [self.dataSource removeAllObjects];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[self.mIndexDic objectForKey:actionType]];
        if (array) {
            [self.dataSource addObjectsFromArray:array];
        }
    }
    [self updateData];
}

-(void)addServiceRequest
{
    AddServiceRequestViewController *addServiceVC = [[AddServiceRequestViewController alloc]init];
    [self.navigationController pushViewController:addServiceVC animated:YES];
    
    [addServiceVC release];
    addServiceVC = nil;
}
@end
