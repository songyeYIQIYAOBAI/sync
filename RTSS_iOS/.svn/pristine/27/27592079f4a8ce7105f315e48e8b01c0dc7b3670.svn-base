//
//  MyBillsViewController.m
//  RTSS
//
//  Created by 宋野 on 15-4-13.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "MyBillsViewController.h"
#import "BillsDetailViewController.h"
#import "PaymentHistoryViewController.h"
#import "PayViewController.h"
#import "DateUtils.h"

#import "Session.h"
#import "Customer.h"

#define BOTTOM_VIEW_HEIGHT                  200

#define AMOUNT_LABEL_RIGHT_INTERVAL         25
#define AMOUNT_LABEL_Y                      25
#define AMOUNT_LABEL_HEIGHT                 15

#define TOTAL_LABEL_WIDTH                   30

#pragma mark --BillHeader

#import "EColumnChartView.h"
#import "EColumnDataModel.h"
static int kDateMonthNumber = 6;  //显示
@interface MyBillTableHeaderView : UIView

@property(nonatomic, readonly) EColumnChartView* mColumnChartView;
@end
@interface MyBillTableHeaderView ()

@end

@implementation MyBillTableHeaderView
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
//    mColumnChartView.echatType = ECloumnChartTypeBill;
    mColumnChartView.backgroundColor = [UIColor clearColor];
    [self addSubview:mColumnChartView];
    
}
@end

@interface MyBillsViewController ()<MappActorDelegate>{
    UIView * bottomView;
    UILabel * totalLabel;
    UILabel * amountLabel;
    MyBillTableHeaderView *myBillHeaderView;
}

@end

@implementation MyBillsViewController

- (void)dealloc{
    [bottomView release];
    [totalLabel release];
    [amountLabel release];
    [myBillHeaderView release];
    [super dealloc];
}

- (void)loadView{
    [super loadView];
    //navibar
    UIView * navi = [self addNavigationBarView:NSLocalizedString(@"My_Bills_Navi_Title", nil) bgColor:[RTSSAppStyle currentAppStyle].navigationBarColor separator:YES];
    [self.view addSubview:navi];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad{
    [super viewDidLoad];
}
-(void)loadData{
    
    Session *session =  [Session sharedSession];
    Customer *customer = [Session sharedSession].mMyCustomer;

//    if (session.mCurrentAccount.mPaidType == 1) { //预付用户 加载fileurl.界面不显示
//        
//        //日期不包括当月
//        NSDate *endDate = [DateUtils dateBySubtractingMonths:1 by:[NSDate date]];
//        //  NSDate *beginDate = [DateUtils dateBySubtractingMonths:kDateMonthNumber by:endDate];
//        NSString *dateFormat = @"yyyyMMddHHmmss";//文档
//        NSString *beginDateString =[DateUtils getStringDateByDate:[DateUtils  dateAtStartOfDayByDate:endDate] dateFormat:dateFormat];
//        
//        NSString *endDateString  = [DateUtils getStringDateByDate:[DateUtils  dateAtEndOfDayByDate:endDate] dateFormat:dateFormat];
//        [APPLICATION_KEY_WINDOW makeToastActivity];
//        [customer getDetailedBillWithSubscriberId:@"11" andBeginDate:beginDateString andEndDate:endDateString andDelegate:self];
    
//    }else if (session.mCurrentAccount.mPaidType == 2 ){
        [self initViews];
        //后付费
        NSDate *endDate = [DateUtils dateBySubtractingMonths:1 by:[NSDate date]];
        NSDate *beginDate = [DateUtils dateBySubtractingMonths:kDateMonthNumber by:endDate];
        NSString *dateFormat = @"yyyyMMddHHmmss";//文档
        
        NSString *beginDateString =[DateUtils getStringDateByDate:[DateUtils  dateAtStartOfDayByDate:beginDate] dateFormat:dateFormat];
        NSString *endDateString  = [DateUtils getStringDateByDate:[DateUtils  dateAtEndOfDayByDate:endDate] dateFormat:dateFormat];
        
        [customer getMyBillWithAccountId:session.mCurrentAccount.mId andType:1 andStartDate:beginDateString andEndDate:endDateString andDelegate:self];
//    }

}
- (void)initViews{
    self.view.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    
    UIView *navi = navigationBarView;
    //add rightItemButton
    CGFloat rightInterval = 20;
    CGFloat btnwidth = 26;
    
    UIButton * rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItemButton.frame = CGRectMake(CGRectGetWidth(navi.frame) - rightInterval - btnwidth, 27, btnwidth, btnwidth);
    [rightItemButton setImage:[UIImage imageNamed:@"my_bills_navi_right_btn_image.png"] forState:UIControlStateNormal];
    [rightItemButton addTarget:self action:@selector(rightBarButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [navi addSubview:rightItemButton];
    
    //head view
    CGFloat headerViewHeight = 210;
    myBillHeaderView = [[MyBillTableHeaderView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(navi.frame), PHONE_UISCREEN_WIDTH, headerViewHeight)];
    myBillHeaderView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    [myBillHeaderView addSubview:[self createLineImageViewWithY:myBillHeaderView.bounds.size.height-1]];////addline
    [self.view addSubview:myBillHeaderView];
    
    // bottomView
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(myBillHeaderView.frame), CGRectGetWidth(self.view.frame), PHONE_UISCREEN_HEIGHT - 64 - CGRectGetHeight(myBillHeaderView.frame))];
    bottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bottomView];
    
    //AmountLabel
    CGFloat y = AMOUNT_LABEL_Y;
    CGFloat interval = AMOUNT_LABEL_RIGHT_INTERVAL;
    CGFloat width = TOTAL_LABEL_WIDTH;
    CGFloat height = AMOUNT_LABEL_HEIGHT;
    amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(bottomView.frame) - interval - width, y, width, height)];
    amountLabel.textColor = [RTSSAppStyle currentAppStyle].textGreenColor;
    amountLabel.font = [RTSSAppStyle getRTSSFontWithSize:14];
    amountLabel.text = [NSString stringWithFormat:@"%@",[CommonUtils formatMoneyWithPenny:0 decimals:2 unitEnable:YES]];
    [bottomView addSubview:amountLabel];
    
    //TotalLabel
    width = TOTAL_LABEL_WIDTH;
    height = AMOUNT_LABEL_HEIGHT;
    interval = 5;
    y = AMOUNT_LABEL_Y;
    totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(amountLabel.frame) - interval - width, y, width, height)];
    totalLabel.textColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
    totalLabel.font = [RTSSAppStyle getRTSSFontWithSize:12];
    totalLabel.text = @"Total:";
    [bottomView addSubview:totalLabel];
    
    
    // billsDetailBtn
    interval = AMOUNT_LABEL_RIGHT_INTERVAL;
    height = 40;
    width = (CGRectGetWidth(bottomView.frame) - 3 * interval) / 2.0;
    y = CGRectGetHeight(bottomView.frame) - height - 30;
    
    UIButton * billsDetailBtn = [RTSSAppStyle getMajorGreenButton:CGRectMake(interval, y, width,height) target:self action:@selector(billsDetailBtnClick:) title:NSLocalizedString(@"My_Bills_Bills_Detail_Button_Text", nil)];
    billsDetailBtn.titleLabel.font = [RTSSAppStyle getRTSSFontWithSize:16];
    [bottomView addSubview:billsDetailBtn];
    
    //paymentBtn
    UIButton * paymentBtn = [RTSSAppStyle getMajorGreenButton:CGRectMake(CGRectGetMaxX(billsDetailBtn.frame) + interval, y, width,height) target:self action:@selector(paymentBtnClick:) title:NSLocalizedString(@"My_Bills_Bills_Payment_Button_Text", nil)];
    paymentBtn.titleLabel.font = [RTSSAppStyle getRTSSFontWithSize:16];
    
    [bottomView addSubview:paymentBtn];
}

- (void)setAmontPrice:(NSString *)priceString {
    CGFloat textWidth = [CommonUtils calculateTextSize:priceString constrainedSize:CGSizeMake(250, 15) textFont:[RTSSAppStyle getRTSSFontWithSize:14] lineBreakMode:NSLineBreakByWordWrapping].width;
    
    amountLabel.frame = CGRectMake(CGRectGetWidth(bottomView.frame) - AMOUNT_LABEL_RIGHT_INTERVAL - textWidth, AMOUNT_LABEL_Y, textWidth, AMOUNT_LABEL_HEIGHT);
    totalLabel.frame = CGRectMake(CGRectGetMinX(amountLabel.frame) - 5 - TOTAL_LABEL_WIDTH, AMOUNT_LABEL_Y, TOTAL_LABEL_WIDTH, AMOUNT_LABEL_HEIGHT);
    
    amountLabel.text = priceString;
    
}

-(UIImageView*)createLineImageViewWithY:(CGFloat)lineY{
    
    //UIImageView *line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_separator_line"]];
    UIImageView *line = [[UIImageView alloc]init];
    line.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    line.frame = CGRectMake(0, lineY, PHONE_UISCREEN_WIDTH, 1);
    return [line autorelease];
    
}

#pragma mark Action

- (void)rightBarButtonItemClick:(UIButton *)button{
    PaymentHistoryViewController * payHistoryVC = [[PaymentHistoryViewController alloc] init];
    [self.navigationController pushViewController:payHistoryVC animated:YES];
    
    [payHistoryVC release];
}

- (void)billsDetailBtnClick:(UIButton *)button{
    
    if ([Session sharedSession].mCurrentAccount.mPaidType==1 ) {
        //预付费
        BillsDetailViewController * billsDetailVC = [[BillsDetailViewController alloc] init];
        
        [self.navigationController pushViewController:billsDetailVC animated:YES];
        [billsDetailVC release];
    }else if([Session sharedSession].mCurrentAccount.mPaidType==2 ){
        //后付费
        BillsDetailViewController * billsDetailVC = [[BillsDetailViewController alloc] init];
        
        [self.navigationController pushViewController:billsDetailVC animated:YES];
        [billsDetailVC release];
        
    }
    
}

- (void)paymentBtnClick:(UIButton *)button{
    PayViewController * payViewController = [[PayViewController alloc] init];
    payViewController.payUrlString = @"www.baidu.com";
    payViewController.payAction = nil;
    payViewController.payFor = nil;
    [self.navigationController pushViewController:payViewController animated:YES];
    [payViewController release];
}

#pragma mark --Mappactor delegate-
-(void)getHisBillingStatementFinished:(NSInteger)status andInfo:(NSArray *)info{
    
    if (MappActorFinishStatusOK != status) {
        return;
    }
    
    CGFloat max = 0;//currentCharges
    
    //找出最大值
    for (NSInteger i = 0; i < [info count]; i++) {
        NSDictionary *dic = [info objectAtIndex:i];
        CGFloat currentCharges = [[dic objectForKey:@"currentCharges"]floatValue];
        if (currentCharges > max ) max = currentCharges;
    }
    max = [CommonUtils getUnitConverteValue:max AndUnit:UnitForMoney];
    //刷新  柱状图
    NSMutableArray* columnArray = [[NSMutableArray alloc]init];
    
    
    for (NSInteger i = 0; i < [info count]; i++) {
        
        NSDictionary *dic = [info objectAtIndex:i];
        NSString *beginDateString = [dic objectForKey:@"startDate"];
        
        NSString *covertEndDateString = [DateUtils getStringDateByDate:[DateUtils  dateByDateString:beginDateString UseFormatString:@"yyyyMMddHHmmss"] dateFormat:@"MM/yy"];
        
        CGFloat currentCharges = [[dic objectForKey:@"currentCharges"]floatValue];
        currentCharges =[CommonUtils getUnitConverteValue:currentCharges AndUnit:UnitForMoney];
        
        EColumnDataModel  * eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:covertEndDateString
                                                                             valueText:[NSString stringWithFormat:@"%.2f",currentCharges]
                                                                                 value:currentCharges
                                                                          averageValue:0
                                                                              maxValue:max
                                                                                 index:i
                                                                                  unit:NSLocalizedString(@"Currency_Unit", nil) groupId:0 messureId:UnitForMoney name:@"Bill Acount"];
        NSArray *array = [NSArray arrayWithObjects:eColumnDataModel,nil];
        [columnArray addObject:array];
        [eColumnDataModel release];
    }
    [myBillHeaderView.mColumnChartView reloadChartData:columnArray isHiddenLegend:NO];
    [myBillHeaderView.mColumnChartView scrollToLast:NO];
    [columnArray release];
    
}
#pragma mark --获取预付费fileURl
-(void)getDetailedBillFinished:(NSInteger)status andFileUrl:(NSString *)fileUrl{
    
    [APPLICATION_KEY_WINDOW hideToastActivity];
    if (MappActorFinishStatusOK != status) {
        return;
    }
    //使用safari
    if ([fileUrl length] > 0 ) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:fileUrl]];
        
    }
    [self performSelector:@selector(backHome) withObject:nil afterDelay:1.0];
}

- (void)getMyBillFinished:(NSInteger)status andInfo:(NSArray *)info{
    [APPLICATION_KEY_WINDOW hideToastActivity];
    if (status == MappActorFinishStatusOK) {
        if (info.count > 0) {
            [self getHisBillingStatementFinished:status andInfo:info];
            NSDictionary * dic = [info lastObject];
            long totalAmount = [[dic objectForKey:@"totalBillAmount"] longValue];
            [self setAmontPrice:[NSString stringWithFormat:@"%@",[CommonUtils formatMoneyWithPenny:totalAmount decimals:2 unitEnable:YES]]];
        }
    }else{
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"My_Bills_Get_Total_Bill_Amount_Faild_Text", nil)];
    }
    
}

-(void)backHome{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
