//
//  MyPlanViewController.m
//  RTSS
//
//  Created by 宋野 on 14-11-22.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "MyPlanViewController.h"
#import "MyPlanTableView.h"
#import "OrderPreviewViewController.h"
#import "ManagePlanDetailViewController.h"

#import "Session.h"
#import "Customer.h"
#import "Subscriber.h"
#import "Product.h"
#import "RTSSAppStyle.h"


@interface MyPlanViewController ()<MyPlanTableViewDelegate,MappActorDelegate>{
    MyPlanTableView * myPlanTableView;
    NSMutableArray * mArrayModels;
}

@end

@implementation MyPlanViewController

- (void)dealloc{
    [myPlanTableView release];
    [super dealloc];
}

- (void)loadView{
    [super loadView];
    // == navigationBar
    UIView * view = [self addNavigationBarView:@"My plan" bgColor:[RTSSAppStyle currentAppStyle].viewControllerBgColor separator:YES];
    [self.view addSubview:view];
    
    // ==
    myPlanTableView = [[MyPlanTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT - 20 - 44)];
    myPlanTableView.delegate = self;
    [self.view addSubview:myPlanTableView];
}

- (void)loadData{
    
//    mArrayModels = [NSMutableArray arrayWithCapacity:0];
//    for (int i = 1; i < 4; i++) {
//        Subscriber * model = [[Subscriber alloc] init];
//        model.mId = @"12312312312";
//        model.mName = [NSString stringWithFormat:@"Name %d",i];
//        NSMutableArray * arr = [NSMutableArray array];
//        for (int j = 0; j < 3; j++) {
//            Product * product = [[Product alloc] init];
//            product.mName = [NSString stringWithFormat:@"Jio 50 Plan With 15 Voice Min For %d Day",j];
//            product.mOfferId = @"1";
//            product.mStartDate = [NSString stringWithFormat:@"Jio 50 Plan With 15 Voice Min For %d Day",j];
//            product.mEndDate = [NSString stringWithFormat:@"₹ %d",j * 300];
//            [arr addObject:product];
//        }
//        model.mProducts = [NSArray arrayWithArray:arr];
//        
//        [mArrayModels addObject:model];
//        [model release];
//    }
//    [myPlanTableView initViewsWithArray:mArrayModels];

    Session * session = [Session sharedSession];
    [myPlanTableView initViewsWithArray:session.mMyCustomer.mMySubscribers];
    
//    [session.mMyCustomer sync:self];
//    Customer * custer = [[Customer alloc] init];
//    [custer setMAccountId:@"8888888"];
//    [custer sync:self];
//   
//    session.mMyCustomer = custer;
    
//    [custer release];
}

#pragma mark - MappActorDelegate

- (void)syncFinished:(NSInteger)status{
//    Session * session = [Session sharedSession];
    
//    [myPlanTableView initViewsWithArray:session.mMyCustomer.mMySubscribers];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"My plan";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - MyPlanTableViewDelegate

-(void)myPlanTableViewClickUpdateButtonIndex:(NSIndexPath *)indexPath{
    
//    Subscriber * subscriber = [[Session sharedSession].mMyCustomer.mMySubscribers objectAtIndex:indexPath.section];
//    Product * product = [subscriber.mProducts objectAtIndex:indexPath.row];
//    
//    // == 传入Subscriber的id 和 Product对象
//    OrderPreviewViewController * orderPreviewController= [[OrderPreviewViewController alloc] init];
//    orderPreviewController.serviceId = subscriber.mId;
//    orderPreviewController.purchaseProduct = product;
//    orderPreviewController.purchaseType = PurchaseTypeProduct;
//    
//    [self.navigationController pushViewController:orderPreviewController animated:YES];
//    [orderPreviewController release];
}

- (void)myPlanTableViewCellTapIndex:(NSIndexPath *)indexPath{
    

    Subscriber * subscriber = [[Session sharedSession].mMyCustomer.mMySubscribers objectAtIndex:indexPath.section];
    Product * product = [subscriber.mProducts objectAtIndex:indexPath.row];
    
    //TO DO 根据indexPath 传入Product的id
    ManagePlanDetailViewController * planDetailViewController = [[ManagePlanDetailViewController alloc] init];
    planDetailViewController.mOfferId = product.mOfferId;
    
    [self.navigationController pushViewController:planDetailViewController animated:YES];
    [planDetailViewController release];
}


@end
