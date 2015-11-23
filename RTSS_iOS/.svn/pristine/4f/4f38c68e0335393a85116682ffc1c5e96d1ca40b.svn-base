//
//  BalanceDetailViewController.m
//  RTSS
//
//  Created by tiger on 14-11-29.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "BalanceDetailViewController.h"
#import "BalanceDetailView.h"
#import "MobileUsageModel.h"
#import "Session.h"
#import "Subscriber.h"
#import "ProductResource.h"
#import "ITransferable.h"
#import "MManager.h"
#define LABEL_HEIGHT                    13
#define LABEL_HEIGHT_Y                  55

@interface BalanceDetailViewController ()
{
    BalanceDetailView * balanceView;
    UILabel * serviceLabel;
}
@property(nonatomic,retain)NSString *mTitle;
@property(nonatomic,retain)NSString *mServiceID;
@property(nonatomic,assign)NSInteger currentServiceIndex;
@end

@implementation BalanceDetailViewController
@synthesize mTitle,mServiceID,currentServiceIndex;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)setTitle:(NSString *)title AndServiceID:(NSString *)serviceID CurrentServiceIndex:(NSInteger)index
{
    self.mTitle = title ;
    self.mServiceID = serviceID ;
    self.currentServiceIndex = index;
}

-(void)dealloc
{
    [mTitle release];
    [mServiceID release];
    [balanceView release];
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData
{
//    balanceView.dataList = [self getData];
    balanceView.dataList = [self getModelData];
}

/*
-(NSMutableArray *)getData
{
    Session * session = [Session sharedSession];
    NSArray * products = session.mCurrentSubscriber.mProducts;
    
    Product *product = [products objectAtIndex:currentServiceIndex];
    
    NSMutableArray * modelArray = [NSMutableArray array];
    
    NSArray * rescourceArray = product.mResources;
    for (int i = 0; i < rescourceArray.count; i++) {
        ProductResource * productResource = [rescourceArray objectAtIndex:i];
        
       // ProductResource * productResource = product.mResources[0];
        
        //为model赋值
        MobileUsageModel * model = [[MobileUsageModel alloc]init];
        model.title = productResource.mName;

        model.remain = [[[CommonUtils getValueAndUnitByConverteValue:productResource.mRemain AndUnit:productResource.mUnit] objectForKey:@"resultValue"] floatValue];
        model.unitForRemain = [[CommonUtils getValueAndUnitByConverteValue:productResource.mRemain AndUnit:productResource.mUnit] objectForKey:@"resultUnit"];
        model.total = [[[CommonUtils getValueAndUnitByConverteValue:productResource.mTotal AndUnit:productResource.mUnit] objectForKey:@"resultValue"] floatValue];
        model.unitForTotal = [[CommonUtils getValueAndUnitByConverteValue:productResource.mTotal AndUnit:productResource.mUnit] objectForKey:@"resultUnit"];

        model.color = [RTSSAppStyle getFreeResourceColorWithIndex:product.mType];
        [modelArray addObject:model];
        [model release];
    }
    
    return modelArray;
}
*/
-(NSMutableArray *)getModelData
{
    /*
    NSMutableArray * modelArray = [NSMutableArray arrayWithCapacity:0];
    
    Session * session = [Session sharedSession];
    //服务类型数量
    
    if([CommonUtils objectIsValid:session.mCurrentAccount.mSubAccounts]){

        Account *subAccount = [session.mCurrentAccount.mSubAccounts objectAtIndex:currentServiceIndex];
        
        NSArray *transbles = session.mTransferables;
        //根据subScribe ID  从mTransferables找出对应的资源
        NSMutableArray *productResources = [NSMutableArray array];
        for (id<ITransferable>item in transbles) {
            if ([item getTypeCode] == 1 || [item getTypeCode] == 2) {
                continue;
            }
            if ([subAccount.mPaidSubscriber.mId isEqualToString:[item getSubscriberId]]) {
                [productResources addObject:item];
            }
        }
*/
        
        
        
        
        NSMutableArray * modelArray = [NSMutableArray arrayWithCapacity:0];
        
        Session * session = [[MManager sharedMManager] getSession];
        //服务类型数量
        
        if([CommonUtils objectIsValid:session.mCurrentSubscriber.mProducts]){
            //根据subScribe ID  从mTransferables找出对应的资源
            NSMutableArray *productResources = [NSMutableArray array];
            Product *product = [session.mCurrentSubscriber.mProducts objectAtIndex:currentServiceIndex];;
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
    }
    return modelArray;
}


-(void)loadView
{
    [super loadView];
    
    [self layoutContentView];
}

-(void)layoutContentView
{
    UIView *navBarView = [self addNavigationBarView:[[[RTSSAppStyle currentAppStyle] getServiceSourceWithServiceType:self.mTitle]objectForKey:@""] bgColor:[[RTSSAppStyle currentAppStyle] navigationBarColor] separator:NO];
    [self.view addSubview:navBarView];
    self.view.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
//    serviceLabel = [CommonUtils labelWithFrame:CGRectMake(0, LABEL_HEIGHT_Y, PHONE_UISCREEN_WIDTH, LABEL_HEIGHT) text:nil textColor:[RTSSAppStyle currentAppStyle].textSubordinateColor textFont:[UIFont systemFontOfSize:13] tag:0];
//    serviceLabel.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
//    serviceLabel.text =mServiceID;
    //[self.view addSubview:serviceLabel];
    
    balanceView = [[BalanceDetailView alloc]initWithFrame:CGRectMake(0, LABEL_HEIGHT_Y + LABEL_HEIGHT, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-(LABEL_HEIGHT_Y + LABEL_HEIGHT))];
    balanceView.backgroundColor = [UIColor redColor];
    [self.view addSubview:balanceView];
   

}


@end
