//
//  ManagePlanDetailViewController.m
//  RTSS
//
//  Created by 蔡杰Alan   on 14-11-13.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "ManagePlanDetailViewController.h"

#import "ExpandTableView.h"
#import "ExpandTitleTableViewCell.h"
#import "ExpandDetailTableViewCell.h"
#import "ErrorMessage.h"
#import "ExpandHeaderView.h"
#import "Session.h"
#import "Customer.h"


@interface ManagePlanDetailViewController ()<MappActorDelegate>{
    
    ExpandTableView *expandTableView;
    ExpandHeaderView *headerView;
}

@end

@implementation ManagePlanDetailViewController

#pragma mark --life

-(void)dealloc{
    
    [expandTableView release];
    [headerView release];
   // [self.porductOffer release];
    
    [super dealloc];
}
-(void)loadView{
    [super loadView];
    
    [self installSubviews];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Plan_Detail_Title", nil);

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
   self.navigationController.navigationBarHidden = NO;

}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    //self.navigationController.navigationBar.hidden = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --Installview
-(void)installSubviews{
    
   // [self.view addSubview:[self addNavigationBarView:@"Plan Detail" bgColor:[RTSSAppStyle currentAppStyle].navigationBarColor separator:YES]];
    [self.view setBackgroundColor:[RTSSAppStyle currentAppStyle].viewControllerBgColor];
    expandTableView = [[ExpandTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height -CGRectGetMaxY(navigationBarView.frame)-80) style:UITableViewStylePlain];
    expandTableView.backgroundColor =[RTSSAppStyle currentAppStyle].viewControllerBgColor;
    [self.view addSubview:expandTableView];
    
    headerView = [[ExpandHeaderView alloc]initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 120)];
    // headerView = [[ExpandHeaderView alloc]initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 120) subViewCount:5];
    headerView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    expandTableView.tableHeaderView = headerView;
    
}

-(void)loadData{
    
   // [headerView setPlanName:self.porductOffer.mName Type:@"" BillingType:@"" Changes:[NSString stringWithFormat:@"%lld",self.porductOffer.mPrice]];
    if (![self.mOfferId length]>0) {
        NSLog(@"我没有只");
        return;
    }
    [APPLICATION_KEY_WINDOW makeToastActivity];
    Customer *myCustumer = [Session sharedSession].mMyCustomer;
 //   [myCustumer offerDetail:@[self.mOfferId] delegate:self];
    [myCustumer acquireProductOfferingWithProductOfferId:self.mOfferId andDelegate:self];
}
-(void)acquireProductOfferingFinished:(NSInteger)status andInfo:(NSDictionary *)detail{
    
    NSLog(@"sattus = %d",status);
    
    [APPLICATION_KEY_WINDOW hideToastActivity];
    //错误处理
    if(MappActorFinishStatusOK != status){
        
        if(MappActorFinishStatusNetwork == status){
            [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"ErroMessage_Status_Network", nil)];
        }else {
            [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Plan_Detail_Failed", nil)];
        }
        return;
    }
    //返回数据验证
    if (!detail || (detail && detail.count <= 0)) {
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Plan_Detail_Failed", nil)];
        return;
    }
    NSLog(@"detail=%@",detail);
    
//    if (![detail.allKeys containsObject:self.mOfferId]) {
//        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Plan_Detail_Failed", nil)];
//        return;
//    }
//    
    
    NSDictionary *PlanId = detail;
    
    //头部数据
    NSInteger billingType = [(NSNumber*)[PlanId objectForKey:@"billingType"]integerValue];
    NSInteger type =[(NSNumber*)[PlanId objectForKey:@"offeringTypeCode"]integerValue];
    
    id priceDic = [PlanId objectForKey:@"price"];
    
    long long price = 0;
    if ([priceDic isKindOfClass:[NSDictionary class]]) {
        
        price = [(NSNumber*)[priceDic  objectForKey:@"priceValue"]longLongValue];
        
    }
    
    
    
    [headerView setBillingType:billingType];
    [headerView setType:type];
    [headerView setPrice:price];
    
    NSMutableArray *dataSourceList = [NSMutableArray array];
    
    id locationList = [PlanId objectForKey:@"locationArray"];
    NSArray *location;
    if ([CommonUtils objectIsValid:locationList]) {
        
        NSMutableArray *locationArray = [NSMutableArray array];
        
        NSDictionary *dic = [locationList objectAtIndex:0];
        for (NSString *key in dic) {
            [locationArray addObject:[dic objectForKey:key]];
        }
        location = [NSArray arrayWithArray:locationArray];
        
        // expandTableView.dataSourceList = @[locationList,@[desc]];
    }else{
        
        location = [NSArray array];
    }
    [dataSourceList addObject:location];
    
    NSArray *spec;
    NSArray *specifications = [PlanId objectForKey:@"specArray"];
    if ([CommonUtils objectIsValid:specifications]) {
        
        NSMutableArray *characteristicsArray = [NSMutableArray array];
        
        NSArray *characteristics = [[specifications objectAtIndex:0]objectForKey:@"characteristics"];
        if ([CommonUtils objectIsValid:characteristics]) {
            NSDictionary *dic = [characteristics objectAtIndex:0];
            for (NSString *key in dic) {
                [characteristicsArray addObject:[dic objectForKey:key]];
            }
        }else{
            spec = [NSArray array];

        }
        spec = [NSArray arrayWithArray:characteristicsArray];
        
    }else{
        spec = [NSArray array];
    }
    
    [dataSourceList addObject:spec];
    
    expandTableView.dataSourceList = dataSourceList;
    
    [expandTableView reloadData];
}
#pragma mark MappActorDelegate

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
