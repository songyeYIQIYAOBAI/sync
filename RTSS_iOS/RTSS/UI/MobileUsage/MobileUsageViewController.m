//
//  ETTMobileUsageViewController.m
//  EasyTT
//
//  Created by 蔡杰 on 14-10-22.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import "MobileUsageViewController.h"
#import "CircleProgressView.h"
#import "CircleView.h"
#import "UIView+RTSSAddView.h"
#import "ManagePlanDetailViewController.h"
#import "Subscriber.h"
#import "MobileUsageView.h"
#import "MobileUsageModel.h"
#import "BalanceDetailViewController.h"

#import "Session.h"
#import "ProductResource.h"
#import "Account.h"
#import "ITransferable.h"
#import "MManager.h"
#import "Product.h"

@interface MobileUsageViewController ()
{
    MobileUsageView * usageView;
    int currentServiceIndex;
    Subscriber * currentService;
    Product *product;
}

- (UIImage *)imageNameWithServiceType:(NSString *)type; //通过type获取图片

@end

@implementation MobileUsageViewController

#pragma mark -
-(void)dealloc{
    
    [usageView release];
    [super dealloc];
}

-(void)loadView{
    [super loadView];
    [self layoutContentView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Home_Menu_Usage_Overview", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - 界面布局
-(void)layoutContentView
{
    usageView = [[MobileUsageView alloc]initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-64)];
    [usageView.switchView.actionBtn addTarget:self action:@selector(switchButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:usageView];
}

-(void)switchButtonOnClick
{
    [usageView shrinkCircleAnimation:YES completion:^(BOOL finished) {
        if (finished) {
            
            [self loadData];
//            //删除所有圆
//            [usageView removeAllCircleFromSupperView];
//            //填充数据
//            [usageView loadDataAndInitCircleView:[self getModelData]];
//            //打开圆
//            [usageView openCircleAnimation:YES completion:nil];
//            
//            //更多按钮事件
//            if (usageView.actionBtn != nil) {
//                [usageView.actionBtn.moreBtn addTarget:self action:@selector(moreBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
//            }
        }
    }];
}

#pragma mark - 载入数据
-(void)loadData{
    
    //从View上删除所有圆
    [usageView removeAllCircleFromSupperView];

    //填充数据
    [usageView loadDataAndInitCircleView:[self getModelData]];
    
    //打开圆
    [usageView openCircleAnimation:YES completion:nil];
    
    //添加更多按钮事件
    if (usageView.actionBtn != nil) {
        [usageView.actionBtn.moreBtn addTarget:self action:@selector(moreBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(NSMutableArray *)getModelData
{
    NSMutableArray * modelArray = [NSMutableArray arrayWithCapacity:0];
    
    Session * session = [[MManager sharedMManager] getSession];
    //服务类型数量
    
    if([CommonUtils objectIsValid:session.mCurrentSubscriber.mProducts]){
        
        if (currentServiceIndex >= [session.mCurrentSubscriber.mProducts count]) {
            currentServiceIndex = 0;
        }
        product = [session.mCurrentSubscriber.mProducts objectAtIndex:currentServiceIndex];;
        //切换按钮初始化
        usageView.switchView.serviceName.text = product.mName;
        //根据mServiceType获得图片名字
        //usageView.switchView.serviceImage.image = [self imageNameWithServiceType:currentService.mServiceType];


        if([CommonUtils objectIsValid:product.mServiceId]){
           // usageView.switchView.serviceID.text = product.mServiceId;
        }
        
        //根据subScribe ID  从mTransferables找出对应的资源
        NSMutableArray *productResources = [NSMutableArray array];
        [productResources addObjectsFromArray:product.mResources];
        
        if([CommonUtils objectIsValid:productResources]){
            for (int i = 0; i < [productResources count]; i++) {
                ProductResource *productResource = [productResources objectAtIndex:i];
                //为model赋值
                MobileUsageModel * model = [[MobileUsageModel alloc] init];
                if([CommonUtils objectIsValid:[productResource mName]]){
                    model.title = [productResource mName];
                }
                model.remain = [[[CommonUtils getValueAndUnitByConverteValue:[productResource mRemain] AndUnit:[productResource mUnit]] objectForKey:@"resultValue"] floatValue];
                model.unitForRemain = [[CommonUtils getValueAndUnitByConverteValue:[productResource mRemain] AndUnit:[productResource mUnit]] objectForKey:@"resultUnit"];
                model.total = [[[CommonUtils getValueAndUnitByConverteValue:[productResource mTotal] AndUnit:[productResource mUnit]] objectForKey:@"resultValue"] floatValue];
                model.unitForTotal = [[CommonUtils getValueAndUnitByConverteValue:[productResource mTotal] AndUnit:[productResource mUnit]] objectForKey:@"resultUnit"];
                model.color = [RTSSAppStyle getFreeResourceColorWithIndex:i];
                [modelArray addObject:model];
                [model release];
            }
   
        }
        //服务下标增加
        currentServiceIndex ++;
    }
    return modelArray;
}

-(void)moreBtnOnClick
{
    BalanceDetailViewController * detailVC = [[BalanceDetailViewController alloc]init];
    [detailVC setTitle:product.mName AndServiceID:product.mServiceId CurrentServiceIndex:currentServiceIndex-1];
    [self.navigationController pushViewController:detailVC animated:YES];
    
    [detailVC release];
}


- (NSString*)nameWithServiceType:(NSString*)type{
    if (nil == type || 0 == type.length) {
        return NSLocalizedString(@"MoBileUsage_unknown", nil);
    }
    return [[[RTSSAppStyle currentAppStyle] getServiceSourceWithServiceType:type] objectForKey:@""];
}

- (UIImage *)imageNameWithServiceType:(NSString *)type {
    if (nil == type || 0 == type.length) {
        return nil;
    }
    return [[[RTSSAppStyle currentAppStyle] getServiceSourceWithServiceType:type] objectForKey:@""];
}

@end
