//
//  PaymentHistoryViewController.m
//  RTSS
//
//  Created by 宋野 on 15-4-15.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "PaymentHistoryViewController.h"
#import "DateFootprintBaseView.h"
#import "ServiceRequestCell.h"
#import "Session.h"

#define DATE_VIEW_HEIGHT            50
#define CELL_HEIGHT                 90


@interface PaymentHistoryModel : NSObject
@property (nonatomic ,retain)NSString * month;
@property (nonatomic ,retain)NSString * ID;
@property (nonatomic ,retain)NSString * paymentMode;
@property (nonatomic ,retain)NSString * creditAmount;
@property (nonatomic ,retain)NSString * dateString;
@property (nonatomic ,retain)NSString * imageString;

@end

@implementation PaymentHistoryModel

- (void)dealloc{
    [_ID release];
    [_paymentMode release];
    [_creditAmount release];
    [_dateString release];
    [_imageString release];
    [_month release];
    [super dealloc];
}

@end

@interface PaymentHistoryCell : ServiceRequestCell

- (void)updateModel:(NSDictionary *)model;

@end

@implementation PaymentHistoryCell

- (void)dealloc{
    [super dealloc];
}

#pragma mark - OverRide

-(void)updateData:(NSDictionary *)dic{
    
    
}

#pragma mark - Privte

- (void)updateModel:(NSDictionary *)model{
    NSString * dateString = [model objectForKey:@"transactionDate"];
    if([CommonUtils objectIsValid:dateString]){
        NSDate* date = [DateUtils dateByDateString:dateString UseFormatString:@"yyyyMMddHHmmss"];
        self.dateLabel.text = [DateUtils getStringDateByDate:date dateFormat:@"dd/MM/yyyy"];
    }
    
    NSString * transactionRefNum = [model objectForKey:@"transactionRefNum"];
    if ([CommonUtils objectIsValid:transactionRefNum]) {
        self.idLabel.text = [NSString stringWithFormat:@"ID: %@",transactionRefNum];
        
    }
    self.titleLabel.text = [NSString stringWithFormat:@"Payment Mode: %d",[[model objectForKey:@"paymentMode"] integerValue]];
    self.statusLabel.text = [NSString stringWithFormat:@"Credit Amount: %@",[CommonUtils formatMoneyWithPenny:[[model objectForKey:@"creditAmount"] longLongValue] decimals:2 unitEnable:YES]];
    [self.showButton setBackgroundColor:[RTSSAppStyle getFreeResourceColorWithIndex:2]];
    [self.showButton setImage:[UIImage imageNamed:@"payment_history_support.png"] forState:UIControlStateNormal];
    
}

@end


@interface PaymentHistoryViewController ()<UITableViewDataSource,UITableViewDelegate,DateFootprintDelegate,MappActorDelegate>{
    DateFootprintBaseView * myDateView;
    UITableView * myTableView;
    NSMutableArray * datasArray;
    NSMutableDictionary * allMonthDatas;
    NSDate * tableCurrentDate;
    
    NSInteger  currentMonth;
}

@end

@implementation PaymentHistoryViewController

- (void)dealloc{
    [myDateView release];
    [myTableView release];
    [datasArray release];
    [tableCurrentDate release];
    [allMonthDatas release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)loadView{
    [super loadView];
    [self initViews];
}

- (void)initViews{
    self.view.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    //navi bar
    UIView * navBar = [self addNavigationBarView:NSLocalizedString(@"Payment_History_Navi_Title", nil) bgColor:[RTSSAppStyle currentAppStyle].navigationBarColor separator:NO];
    [self.view addSubview:navBar];
    
    //date view
    myDateView = [[DateFootprintBaseView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(navBar.frame), CGRectGetWidth(self.view.frame), DATE_VIEW_HEIGHT)];
    myDateView.dateInterval = 1;
    myDateView.delegate = self;
    myDateView.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    [myDateView updateCurrentDate];
    [myDateView.leftButton addTarget:self action:@selector(dateViewLeftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [myDateView.rightButton addTarget:self action:@selector(dateViewRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myDateView];
    //获取当前月份
    tableCurrentDate = [[DateUtils dateBySubtractingMonths:1 by:[NSDate date]] retain];
    
    //line
    UIImageView * line = [[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(myDateView.frame), CGRectGetWidth(self.view.frame), 1)] autorelease];
    line.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [self.view addSubview:line];
    
    //tableView
    UIView * tableBgView = [[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), CGRectGetWidth(self.view.frame), PHONE_UISCREEN_HEIGHT - CGRectGetMaxY(line.frame))] autorelease];
    tableBgView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    [self.view addSubview:tableBgView];
    
    myTableView = [[UITableView alloc] initWithFrame:tableBgView.bounds style:UITableViewStylePlain];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    
    [tableBgView addSubview:myTableView];
    [self tableViewAnimation];
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)loadData{
    NSDate * monthFirstDate = [DateUtils dateAtStartOfDayByDate:tableCurrentDate];
    NSDate * monthLastDate = [DateUtils dateAtEndOfDayByDate:tableCurrentDate];
    NSString * monthFirstDateString = [DateUtils getStringDateByDate:monthFirstDate dateFormat:@"yyyyMMddHHmmss"];
    NSString * monthLastDateString = [DateUtils getStringDateByDate:monthLastDate dateFormat:@"yyyyMMddHHmmss"];
    
    [APPLICATION_KEY_WINDOW makeToastActivity];
    [[Session sharedSession].mMyCustomer getStatementWithAccountId:[Session sharedSession].mMyCustomer.mId andType:0 andBeginMonth:monthFirstDateString andEndMonth:monthLastDateString andDelegate:self];
    
}



#pragma mark - Action

- (void)dateViewLeftBtnClick:(UIButton *)button{
    
}

- (void)dateViewRightBtnClick:(UIButton *)button{
    
}

- (void)tableViewAnimation{
    CGRect originalFrame = myTableView.frame;
    CGRect bottomFrame = myTableView.frame;
    
    bottomFrame.origin.y += CGRectGetHeight(myTableView.frame);
    myTableView.frame = bottomFrame;
    
    [UIView animateWithDuration:0.5 animations:^{
        myTableView.frame = originalFrame;
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return datasArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"Payment_history_cell";
    
    PaymentHistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[PaymentHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setCellBlackColor:[RTSSAppStyle currentAppStyle].viewControllerBgColor];
    }
    
    [self setCell:cell indexPath:indexPath];
    
    return cell;
}

- (void)setCell:(PaymentHistoryCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    NSDictionary * model = [datasArray objectAtIndex:indexPath.row];
    [cell updateModel:model];
    
    if (indexPath.row == datasArray.count - 1) {
        [cell removeLastLine];
    }
    
}

#pragma mark - DateFootprintDelegate

- (void)updateUserDate:(NSDate*)aDate{
    if (tableCurrentDate) {
        [tableCurrentDate release];
        tableCurrentDate = [aDate retain];
    }
    
    NSInteger month = [DateUtils monthBy:aDate];
    NSArray * keys = [allMonthDatas allKeys];
    for (NSString * key in keys) {
        if ([key integerValue] == month) {
            if (datasArray) {
                [datasArray release];
            }
            datasArray = [[NSMutableArray alloc] initWithArray:[allMonthDatas objectForKey:key]];
            [myTableView reloadData];
            [self tableViewAnimation];
            return;
        }
    }
    
    [self loadData];
}

#pragma mark - MappActorDelegate

- (void)getStatementFinished:(NSInteger)status andInfo:(NSArray *)info{
    [APPLICATION_KEY_WINDOW hideToastActivity];
    if (status == MappActorFinishStatusOK) {
        NSArray * datas = [[[NSArray alloc] initWithArray:info] autorelease];
        if (allMonthDatas == nil) {
            allMonthDatas = [[NSMutableDictionary alloc] initWithCapacity:0];
        }
        NSInteger month = [DateUtils monthBy:tableCurrentDate];
        [allMonthDatas setObject:datas forKey:[NSString stringWithFormat:@"%d",month]];
        
        if (datasArray) {
            [datasArray release];
        }
        datasArray = [[NSMutableArray alloc] initWithArray:info];
        
        
        [myTableView reloadData];
        [self tableViewAnimation];
    }else{
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Payment_History_Get_Statement_Faild_Title", nil)];
    }
    
}


@end
