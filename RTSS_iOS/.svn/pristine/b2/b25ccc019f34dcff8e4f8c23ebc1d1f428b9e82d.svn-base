//
//  RechargeViewController.m
//  RTSS
//
//  Created by 加富董 on 14/11/26.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "RechargeViewController.h"
#import "ProductOffer.h"
#import "ServicePlanCell.h"
#import "SlideOptionsView.h"
#import "ManagePlanDetailViewController.h"
#import "Session.h"
#import "Customer.h"
#import "Subscriber.h"
#import "PayViewController.h"
#import "ErrorMessage.h"
#import "AlertController.h"

#define PLANS_SCROLL_VIEW_TAG 10000
#define TABLE_VIEW_BASE_TAG 1000
#define SLIDE_OPTIONS_HEIGHT 46.0
#define RECHARGE_SEPERATE_LINE_HEIGHT 1.0

#define PLANS_TABLE_HEADER_HEIGHT 30.0
#define PLANS_TABLE_SEPERATOR_HEIGHT 20.0

@interface RechargeViewController () <UITableViewDataSource,UITableViewDelegate,ServicePlanCellDelegate,SlideOptionsViewDelegate,MappActorDelegate,PaymentActionDelegate,AlertControllerDelegate> {
    SlideOptionsView *slideOptionsView;
    UIScrollView *plansScrollView;
    NSInteger serviceIndex;
    NSInteger itemIndex;
    UIView *statusBarView;
}

@property (nonatomic,retain)NSArray *servicesArray;
@property (nonatomic,retain)NSArray *plansArray;
@property (nonatomic,retain)NSMutableArray *planTablesArray;
@property (nonatomic,assign)BOOL rechargeSucceed;

@end

@implementation RechargeViewController

@synthesize servicesArray;
@synthesize plansArray;
@synthesize planTablesArray;
@synthesize contentType;
@synthesize rechargeSucceed;

#pragma mark dealloc
- (void)dealloc {
    [servicesArray release];
    [plansArray release];
    [planTablesArray release];
    [slideOptionsView release];
    [plansScrollView release];
    [statusBarView release];
    [super dealloc];
}

#pragma mark life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    //此处不应再隐藏，会连续hide两次，导致加载框隐藏不掉的情况，即需要成对出现
//    [APPLICATION_KEY_WINDOW hideToastActivity];
}

- (void)loadView {
    [super loadView];
    //clip
    self.view.clipsToBounds = YES;
    
    //nav bar
    [self loadNavBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    serviceIndex = 0;
    [self createContentView];
}

#pragma mark init views
- (void)loadNavBar {
    //bg color
    self.view.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    
    //status bar
    statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, PHONE_UISCREEN_HEIGHT, 20.0)];
    statusBarView.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
    [self.view addSubview:statusBarView];
    
    //nav
    NSString *title = nil;
    if (self.contentType == ContentTypeRecharge) {
        title = NSLocalizedString(@"Recharge_Recharge_Title", nil);
    } else if (self.contentType == ContentTypeMyPlan) {
        title = NSLocalizedString(@"Recharge_My_Plan_Title", nil);
    }
    navigationBarView = [self addNavigationBarView:title bgColor:[[RTSSAppStyle currentAppStyle] navigationBarColor] separator:YES];
    [self.view addSubview:navigationBarView];
}

- (void)createContentView {
//    [self loadSlideOptionsViewByServicesData:servicesArray];
    [self loadPlansDisplayScrollView];
    if (servicesArray && [servicesArray count] > 0) {
        [self loadSubscriberPlansByServiceIndex:serviceIndex];
    }
}

//- (void)loadSlideOptionsViewByServicesData:(NSArray *)data {
//    if (![CommonUtils objectIsValid:data]) {
//        return;
//    }
//    NSMutableArray *optionsArray = [[NSMutableArray alloc] initWithCapacity:0];
//    NSEnumerator *enumerator = [data objectEnumerator];
//    Subscriber *subscriber = nil;
//    while (subscriber = [enumerator nextObject]) {
//            if ([CommonUtils objectIsValid:subscriber.mName]) {
//                    [optionsArray addObject:subscriber.mName];
//            }
//    }
//
//    CGRect slideViewFrame = CGRectMake(0., CGRectGetMaxY(navigationBarView.frame), PHONE_UISCREEN_WIDTH, SLIDE_OPTIONS_HEIGHT);
//    slideOptionsView = [[SlideOptionsView alloc] initWithFrame:slideViewFrame optionTiltes:optionsArray gangedPageWidth:PHONE_UISCREEN_WIDTH];
//    slideOptionsView.delegate = self;
//    slideOptionsView.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
//    [self.view addSubview:slideOptionsView];
//    [optionsArray release];
//    
//    //seperator line
//    CGRect seperatorRect = CGRectMake(0.f, CGRectGetMaxY(slideOptionsView.frame), PHONE_UISCREEN_WIDTH, RECHARGE_SEPERATE_LINE_HEIGHT);
//    UIView *sepView = [[UIView alloc] initWithFrame:seperatorRect];
//    sepView.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
//    [self.view addSubview:sepView];
//    [sepView release];
//}

- (void)loadPlansDisplayScrollView {
    //bg scroll view
    CGRect scrollViewFrame = CGRectMake(0., CGRectGetMaxY(navigationBarView.frame), PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT - CGRectGetMaxY(navigationBarView.frame));
    plansScrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    plansScrollView.backgroundColor = [UIColor clearColor];
    plansScrollView.delegate = self;
    plansScrollView.pagingEnabled = YES;
    plansScrollView.showsHorizontalScrollIndicator = NO;
    plansScrollView.showsVerticalScrollIndicator = NO;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSlideView:)];
    tapGesture.cancelsTouchesInView = NO;
    [plansScrollView addGestureRecognizer:tapGesture];
    [tapGesture release];
    [self.view addSubview:plansScrollView];
    
    //create plan tables
    if ([CommonUtils objectIsValid:servicesArray]) {
        [self createPlanTables];
    }
}

- (void)createPlanTables {
    if (planTablesArray == nil) {
        planTablesArray = [[NSMutableArray alloc] initWithCapacity:0];
    } else {
        [planTablesArray removeAllObjects];
    }
    for (int i = 0; i < [servicesArray count]; i ++) {
        CGRect tableFrame = CGRectMake(0. + PHONE_UISCREEN_WIDTH * i, CGRectGetHeight(slideOptionsView.frame) + RECHARGE_SEPERATE_LINE_HEIGHT + PLANS_TABLE_SEPERATOR_HEIGHT, CGRectGetWidth(plansScrollView.frame), CGRectGetHeight(plansScrollView.frame) - CGRectGetHeight(slideOptionsView.frame) - RECHARGE_SEPERATE_LINE_HEIGHT - PLANS_TABLE_SEPERATOR_HEIGHT);
        UITableView *tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tag = TABLE_VIEW_BASE_TAG + i;
        [plansScrollView addSubview:tableView];
        [planTablesArray addObject:tableView];
    }
    plansScrollView.contentOffset = CGPointMake(0., 0.);
    plansScrollView.contentSize = CGSizeMake(CGRectGetWidth(plansScrollView.frame) * [servicesArray count], CGRectGetHeight(plansScrollView.frame));
}

- (UIView *)createTableSectionHeaderViewAtIndex:(int)tableIndex {
    UIView *headerView = nil;
    if (tableIndex >= 0 && tableIndex < [servicesArray count]) {
        NSString *serviceId = nil;
        Subscriber *subscribe = (Subscriber *)[servicesArray objectAtIndex:tableIndex];
        if (subscribe) {
            serviceId = subscribe.mId;
        }
        CGRect tableHeaderFrame = CGRectMake(0.f, 0.f, PHONE_UISCREEN_WIDTH, PLANS_TABLE_HEADER_HEIGHT);
        headerView = [[[UIView alloc] initWithFrame:tableHeaderFrame] autorelease];
        headerView.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
       
        //seperate top
        CGRect seperatorTopRect = CGRectMake(0.0, 0.0, CGRectGetWidth(tableHeaderFrame), 1.0);
        UIView *sepTopView = [[UIView alloc] initWithFrame:seperatorTopRect];
        sepTopView.backgroundColor = [[RTSSAppStyle currentAppStyle] separatorColor];
        [headerView addSubview:sepTopView];
        
        //lable
        CGRect serviceIdLabelFrame = CGRectMake(15.f, 1.0, CGRectGetWidth(tableHeaderFrame),PLANS_TABLE_HEADER_HEIGHT - 2);
        UILabel *idLabel = [CommonUtils labelWithFrame:serviceIdLabelFrame text:serviceId textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textFont:[RTSSAppStyle getRTSSFontWithSize:15.0] tag:0];
        idLabel.backgroundColor = [UIColor clearColor];
        idLabel.textAlignment = NSTextAlignmentLeft;
        idLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [headerView addSubview:idLabel];
       
        //seperate bottom
        CGRect seperatorBottomRect = CGRectMake(0.f, CGRectGetHeight(tableHeaderFrame) - 1.0, CGRectGetWidth(tableHeaderFrame), 1.f);
        UIView *sepBottomView = [[UIView alloc] initWithFrame:seperatorBottomRect];
        sepBottomView.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
        [headerView addSubview:sepBottomView];
        return headerView;
    }
    return headerView;
}

#pragma mark tableview delegate method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    NSInteger tableIndex = tableView.tag - TABLE_VIEW_BASE_TAG;
    if (tableIndex == serviceIndex) {
        rows = [plansArray count];
    }
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    CGFloat height = SERVICE_PLAN_CELL_HEIGHT;
    if ([CommonUtils objectIsValid:plansArray]) {
        if (row < [plansArray count]) {
            id cellData = [plansArray objectAtIndex:row];
            if (cellData) {
                height = [ServicePlanCell getPlanCellHeightByData:cellData contentType:self.contentType availableWidth:CGRectGetWidth(tableView.frame)];
            }
        }
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self createTableSectionHeaderViewAtIndex:serviceIndex];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return PLANS_TABLE_HEADER_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"servicePlanCell";
    ServicePlanCell *planCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (planCell == nil) {
        planCell = [[[ServicePlanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier availableSize:CGSizeMake(CGRectGetWidth(tableView.frame), SERVICE_PLAN_CELL_HEIGHT) delegate:self] autorelease];
        planCell.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
    }
    if ([CommonUtils objectIsValid:plansArray]) {
        if (indexPath.row < [plansArray count]) {
            id cellData = [plansArray objectAtIndex:indexPath.row];
            if (cellData) {
                [planCell layoutSubviewsByData:cellData contentType:self.contentType atIndexPath:indexPath belongToTableView:tableView showSeperateLine:YES];
                [self setBgStyle:planCell withData:cellData];
            }
        }
    }
    return planCell;
}

- (void) setBgStyle:(UITableViewCell *)cell withData:(id)data {
    UIView *unselectedView = [[UIView alloc] init];
    unselectedView.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
    cell.backgroundView = unselectedView;
    [unselectedView release];
    
    UIView *selectedView = [[UIView alloc] init];
    selectedView.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    cell.selectedBackgroundView = selectedView;
    [selectedView release];
    
    CGFloat cellHeight = [ServicePlanCell getPlanCellHeightByData:data contentType:self.contentType availableWidth:CGRectGetWidth(cell.frame)];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0.0, cellHeight - 1.0, CGRectGetWidth(cell.frame), 1.0)];
    line.backgroundColor = [[RTSSAppStyle currentAppStyle] separatorColor];
    [selectedView addSubview:line];
    [line release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([CommonUtils objectIsValid:plansArray] && indexPath.row < [plansArray count]) {
        id product = [plansArray objectAtIndex:indexPath.row];
        if (product) {
            NSString *productId = nil;
            if (contentType == ContentTypeMyPlan) {
                productId = [(Product *)product mId];
            } else if (contentType == ContentTypeRecharge) {
                productId = [(ProductOffer *)product mOfferId];
            }
            ManagePlanDetailViewController *detailVC = [[ManagePlanDetailViewController alloc] init];
            detailVC.mOfferId = productId;
            NSLog(@"offid ====== %@",detailVC.mOfferId);
            [self.navigationController pushViewController:detailVC animated:YES];
            [detailVC release];
        }
    }
}

#pragma mark scroll view delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]]) {
        NSLog(@"table view scroll");
    } else if ([scrollView isKindOfClass:[UIScrollView class]]) {
        NSLog(@"scroll view scroll");
        CGFloat offsetX = scrollView.contentOffset.x;
        int pageIndex = offsetX / CGRectGetWidth(scrollView.frame);
        NSLog(@"current page index %d",pageIndex);
        if (pageIndex >= 0 && pageIndex < [servicesArray count] && pageIndex != serviceIndex) {
            [slideOptionsView moveToIndex:pageIndex callBack:NO];
            serviceIndex = pageIndex;
            [self loadSubscriberPlansByServiceIndex:serviceIndex];
        }
    }
}

#pragma mark slide options view delegate
- (void)slideOptionsView:(SlideOptionsView *)slideView didSelectOptionAtIndex:(int)index {
    NSLog(@"*****slide optons view did select at index %d",index);
    serviceIndex = index;
    [self loadSubscriberPlansByServiceIndex:serviceIndex];
    //控制page翻页
    [plansScrollView setContentOffset:CGPointMake(CGRectGetWidth(plansScrollView.frame) * index, 0.) animated:YES];
}

#pragma mark map actor delegate
- (void)productOffers:(NSInteger)status productOffers:(NSDictionary*)productOffers dataBinding:(int)binding {
    [APPLICATION_KEY_WINDOW hideToastActivity];
    if (status == MappActorFinishStatusOK) {
        if ([CommonUtils objectIsValid:productOffers]) {
            NSArray *tempProductOffers = [[productOffers allValues] lastObject];
            if ([CommonUtils objectIsValid:tempProductOffers]) {
                self.plansArray = tempProductOffers;
                if (binding == serviceIndex) {
                    UITableView *currentTableView = (UITableView *)[planTablesArray objectAtIndex:binding];
                    if (currentTableView) {
                        [currentTableView reloadData];
                    }
                }
            }
        }
    } else if (status == MappActorFinishStatusNetwork) {
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"ErroMessage_Status_Network", nil)];
    } else {
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Recharge_Failed", nil)];
    }
}

- (void)rechargeFinished:(NSInteger)status payParams:(NSString *)params {
    [APPLICATION_KEY_WINDOW hideToastActivity];
    if (status == MappActorFinishStatusOK) {
        NSLog(@"order preview payment request succeed !!!!!!!\n %@\n\n",params);
        NSString *retUrl = params;
        if ([CommonUtils objectIsValid:retUrl]) {
            //goto web page
            PayViewController *payVC = [[PayViewController alloc] init];
            payVC.payUrlString = retUrl;
            payVC.delegate = self;
            if (contentType == ContentTypeMyPlan) {
                payVC.payAction = NSLocalizedString(@"Pay_Action_Renew", @"Renew");
                Product* product = [plansArray objectAtIndex:itemIndex];
                payVC.payFor = product.mName;
            } else if (contentType == ContentTypeRecharge) {
                payVC.payAction = NSLocalizedString(@"Pay_Action_Recharge", @"Recharge");
                ProductOffer* offer = [plansArray objectAtIndex:itemIndex];
                payVC.payFor = offer.mDescription;
            }
            
            [self.navigationController pushViewController:payVC animated:YES];
        } else {
            [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Recharge_Finished_Ret_Url_Error", nil)];
        }
    } else if (status == MappActorFinishStatusNetwork) {
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"ErroMessage_Status_Network", nil)];
    } else {
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Recharge_Failed", nil)];
    }
}

- (void)syncFinished:(NSInteger)status {
    [APPLICATION_KEY_WINDOW hideToastActivity];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark service plan cell delegate
- (void)servicePlanCell:(ServicePlanCell *)cell didClickedPurchaseButtonAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView {
    itemIndex = indexPath.row;
    
    if ([CommonUtils objectIsValid:plansArray]) {
        if (indexPath.row < [plansArray count]) {
            id product = [plansArray objectAtIndex:indexPath.row];
            if (product) {
                NSString *serviceId = nil;
                Subscriber *subscribe = (Subscriber *)[servicesArray objectAtIndex:serviceIndex];
                if (subscribe && [CommonUtils objectIsValid:subscribe.mId]) {
                    serviceId = subscribe.mId;
                    [APPLICATION_KEY_WINDOW makeToastActivity];
                    if (contentType == ContentTypeMyPlan) {
                        long long amount = [(Product *)product mPrice];
                        [(Product *)product recharge:[[Session sharedSession] mMyCustomer] serviceId:serviceId amount:amount payType:0 delegate:self];
                    } else if (contentType == ContentTypeRecharge) {
                        long long amount = [(ProductOffer *)product mPrice];
                        [(ProductOffer *)product recharge:[[Session sharedSession] mMyCustomer] serviceId:serviceId amount:amount payType:0 delegate:self];
                    }
                }
            }
        }
    }
}

#pragma mark payment delegate
- (void)paymentActionBackWithPaymentStatus:(BOOL)succeed andParameters:(NSDictionary *)parameters {
    [self performSelector:@selector(showPayResult:) withObject:parameters afterDelay:0.1];
}

- (void)showPayResult:(NSDictionary*)payResult {
    NSString* status = [payResult objectForKey:@"Status"];
    if (YES == [status isEqualToString:@"000"]) {
        self.rechargeSucceed = YES;
    } else {
        self.rechargeSucceed = NO;
    }
    [PayViewController showPayResult:payResult inController:self delegate:self];
}

#pragma mark gesture
- (void)tapSlideView:(UITapGestureRecognizer *)tapGesture {
    UIView *tapView = tapGesture.view;
    CGPoint tapLocation = [tapGesture locationInView:tapView];
    CGRect tableRect = CGRectMake(0., CGRectGetHeight(slideOptionsView.frame) + RECHARGE_SEPERATE_LINE_HEIGHT, CGRectGetWidth(plansScrollView.frame), CGRectGetHeight(plansScrollView.frame) - CGRectGetHeight(slideOptionsView.frame) - RECHARGE_SEPERATE_LINE_HEIGHT);
    if (CGRectContainsPoint(tableRect, tapLocation)) {
        NSLog(@"tap table");
    } else {
        for (int i = 0; i < [[slideOptionsView optionViewsArray] count]; i ++) {
            OptionView *option = [[slideOptionsView optionViewsArray] objectAtIndex:i];
            if (option) {
                CGPoint buttonPoint = [option.optionButton convertPoint:tapLocation fromView:tapView];
                if (CGRectContainsPoint(option.optionButton.frame, buttonPoint)) {
                    [slideOptionsView moveToIndex:i callBack:YES];
                    break;
                }
            }
        }
    }
}

#pragma mark alert controller
- (void)alertController:(AlertController *)alertController didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (self.rechargeSucceed == YES) {
        Session *session = [Session sharedSession];
        Customer *customer = session.mMyCustomer;
        if (customer) {
            [APPLICATION_KEY_WINDOW makeToastActivity];
            [customer sync:self];
        }
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark load data
- (void)loadData {
#ifdef APPLICATION_BUILDING_RELEASE
    //获取service信息，以便创建segment菜单
    Session *currentSession = [Session sharedSession];
    
//    if ([CommonUtils objectIsValid:currentSession.mCurrentSubscriber]) {
//        NSMutableArray *array = [NSMutableArray array];
//        for (Account *subAccount in currentSession.mCurrentSubscriber) {
//            [array addObject:subAccount.mPaidSubscriber];
//        }
//        if ([array count]>0) {
//            self.servicesArray = array;
//        }else{
//            return;
//        }
//    }
    
    self.servicesArray = [[NSArray alloc] initWithObjects:currentSession.mCurrentSubscriber, nil];
#else
    self.servicesArray = [self filterInvalidSubscriber:[self fakeServiecesData]];
#endif

}


- (void)loadSubscriberPlansByServiceIndex:(NSInteger)index {
#ifdef APPLICATION_BUILDING_RELEASE
    Subscriber *subscriber = [servicesArray objectAtIndex:index];
    if (subscriber) {
        if (contentType == ContentTypeMyPlan) {
            NSArray *products = subscriber.mProducts;
            if ([CommonUtils objectIsValid:products]) {
                self.plansArray = products;
                UITableView *currentTableView = (UITableView *)[planTablesArray objectAtIndex:index];
                if (currentTableView) {
                    [currentTableView reloadData];
                }
            }
        } else if (contentType == ContentTypeRecharge){
            [APPLICATION_KEY_WINDOW makeToastActivity];
            [[[Session sharedSession] mMyCustomer] rechargeableProductOffers:subscriber.mId dataBinding:index delegate:self];
        }
    }
#else
    self.plansArray = (NSArray *)[self fakePlansDataByIndex:index];
    [(UITableView *)[planTablesArray objectAtIndex:index] reloadData];
#endif
}

- (NSMutableArray *)fakePlansDataByIndex:(NSInteger)index {
    NSMutableArray *plansArr = [NSMutableArray array];
    
    if (contentType == ContentTypeRecharge) {
        for (int i = 0; i < 15; i ++) {
            ProductOffer *plan = [[ProductOffer alloc] init];
            plan.mDescription = [NSString stringWithFormat:@"Jio data:%d msg:%d",(i + 1) * 100,(index + 1) * 50];
            plan.mPrice = (i + 1) * 100 + (index + 1) * 20;
            [plansArr addObject:plan];
            [plan release];
        }
    } else {
        for (int i = 0; i < 15; i ++) {
            Product *product = [[Product alloc] init];
            product.mName = [NSString stringWithFormat:@"Jio data:%d msg:%d",(i + 1) * 100,(index + 1) * 50];
            product.mPrice = (i + 1) * 100 + (index + 1) * 20;
            [plansArr addObject:product];
            [product release];
        }
    }


    return plansArr;
}

- (NSMutableArray *)fakeServiecesData {
    NSMutableArray *services = [NSMutableArray array];
    NSArray *titles = @[@"WIFI",@"VVM",@"MIFI",@"wifi",@"vvm",@"mifi",@"KONGHUA",@"BEIJING",@"CHENGDE",@"SHIJIAZHUANG"];
    for (int i = 0; i < 6; i ++) {
        Subscriber *subscriber = [[Subscriber alloc] init];
        subscriber.mId = [NSString stringWithFormat:@"77740125%02d",i];
        subscriber.mName = [titles objectAtIndex:i];
        if (i == 0) {
            subscriber.mServiceType = @"Z0002";
        } else if (i == 1) {
            subscriber.mServiceType = @"Z0003";
        } else if (i == 2) {
//            subscriber.mServiceType = @"Z0004";
        } else if (i == 3) {
//            subscriber.mServiceType = @"Z0005";
        } else if (i == 4) {
//            subscriber.mServiceType = @"Z0006";
        } else {
            subscriber.mServiceType = @"Z0006";
        }
        [services addObject:subscriber];
        [subscriber release];
    }
    return services;
}

#pragma mark others
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
