//
//  TurboBoostGaugeViewController.m
//  RTSS
//
//  Created by 加富董 on 14/12/1.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "TurboBoostGaugeViewController.h"
#import "SpeedModel.h"
#import "GaugeView.h"
#import "CircleProgressView.h"
#import "Session.h"
#import "Customer.h"
#import "ProductOffer.h"
#import "ProductResource.h"

#import "DateUtils.h"
#import "Product.h"
#import "Subscriber.h"
#import "PayViewController.h"

#define GAUGE_VIEW_PADDING_X 55.0
#define GAUGE_VIEW_HEIGHT 220.0
#define GAUGE_VIEW_NUM_ROWS_COUNT 5

#define CIRCLE_SPEED_VIEW_WIDTH 80.0
#define CIRCLE_SPEED_VIEW_HEIGHT 80.0
#define CIRCLE_SPEED_VIEW_BORDER_WIDTH 8

#define PROMPT_VIEW_TEXT_FONT_SIZE 16.0
#define PROMPT_VIEW_HEIGHT 20.0

@interface TurboBoostGaugeViewController ()<GaugeViewDataSource,UIScrollViewDelegate,MappActorDelegate,PaymentActionDelegate,AlertControllerDelegate> {
    GaugeView *gaugeView;
    UIView *contentView;
    UILabel *promptLabel;
    CircleProgressView *speedCircleView;
}

@property (nonatomic,retain) ProductOffer *currentProductOffer;

@end

@implementation TurboBoostGaugeViewController

@synthesize currentProductOffer;

#pragma mark dealloc
- (void)dealloc {
    [contentView release];
    [gaugeView release];
    [currentProductOffer release];
    [speedCircleView release];
    [super dealloc];
}

#pragma mark life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [APPLICATION_KEY_WINDOW hideToastActivity];
}

- (void)loadView {
    [super loadView];
    [self initViews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark init views
- (void)initViews {
    [self initNavBar];
    [self loadContentView];
}

- (void)initNavBar {
    self.view.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
    navigationBarView = [self addNavigationBarView:NSLocalizedString(@"Turbo_Boost_Gauge_Title", nil) bgColor:[[RTSSAppStyle currentAppStyle] navigationBarColor] separator:YES];
    [self.view addSubview:navigationBarView];
}

- (void)loadContentView {
    CGRect contentViewFrame = CGRectMake(0., CGRectGetMaxY(navigationBarView.frame), PHONE_UISCREEN_WIDTH
                                         , PHONE_UISCREEN_HEIGHT - CGRectGetMaxY(navigationBarView.frame));
    contentView = [[UIView alloc] initWithFrame:contentViewFrame];
    contentView.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    [self.view addSubview:contentView];
    [self loadPromptView];
    [self loadGaugeView];
    [gaugeView loadData];
}

- (void)loadPromptView {
    CGRect promptViewFrame = CGRectMake(0., [self getViewPaddingTopY], PHONE_UISCREEN_WIDTH, PROMPT_VIEW_HEIGHT);
    promptLabel = [CommonUtils labelWithFrame:promptViewFrame text:NSLocalizedString(@"Turbo_Boost_Prompt_Text", nil) textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textFont:[UIFont systemFontOfSize:PROMPT_VIEW_TEXT_FONT_SIZE] tag:0];
    promptLabel.backgroundColor = [UIColor clearColor];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.lineBreakMode = NSLineBreakByWordWrapping;
    promptLabel.numberOfLines = 1;
    [contentView addSubview:promptLabel];
}

- (void)loadGaugeView {
    //gauge view
    CGRect gaugeFrame = CGRectMake(0., CGRectGetMaxY(promptLabel.frame) + [self getGaugeViewSpacingY], PHONE_UISCREEN_WIDTH, GAUGE_VIEW_HEIGHT);
    gaugeView = [[GaugeView alloc] initWithFrame:gaugeFrame];
    gaugeView.backgroundColor = [UIColor clearColor];
    gaugeView.scaleColor = [[RTSSAppStyle currentAppStyle] textSubordinateColor];
    gaugeView.dataSource = self;
    [gaugeView setBackgroundImage:[UIImage imageNamed:@"gauge_panel.png"]
                     pointerImage:[UIImage imageNamed:@"gauge_pointer.png"]
                      centerImage:[UIImage imageNamed:@"gauge_center.png"]];
    [contentView addSubview:gaugeView];
}

- (void)loadSpeedView:(ProductOffer *)productOffer {
    if (productOffer) {
        CGRect speedViewFrame = CGRectMake((CGRectGetWidth(contentView.frame) - CIRCLE_SPEED_VIEW_WIDTH) / 2.0, CGRectGetHeight(contentView.frame) - [self getViewPaddingBottomY] - CIRCLE_SPEED_VIEW_HEIGHT, CIRCLE_SPEED_VIEW_WIDTH, CIRCLE_SPEED_VIEW_HEIGHT);
        speedCircleView = [[CircleProgressView alloc] initWithFrame:speedViewFrame line:CIRCLE_SPEED_VIEW_BORDER_WIDTH];
        UILabel *remainLabel = speedCircleView.allroundView.remainLabel;
        UILabel *desLabel = speedCircleView.allroundView.describeLabel;
        remainLabel.hidden = YES;
        CGRect remainFrame = remainLabel.frame;
        CGRect desFrame = desLabel.frame;
        desFrame.origin.y = remainFrame.origin.y;
        desFrame.size.height += remainFrame.size.height;
        desLabel.frame = desFrame;
        [speedCircleView setRemainingAmount:nil total:[NSString stringWithFormat:@"%@%.2f",NSLocalizedString(@"Currency_Unit", nil),[CommonUtils formatMoneyFromPennyToYuan:productOffer.mPrice]] Unit:productOffer.mOfferName Color:[RTSSAppStyle getFreeResourceColorWithIndex:0]];
        [speedCircleView.circleButton addTarget:self action:@selector(selectSpeedProduct:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:speedCircleView];
    }
}

#pragma mark mapp actor delegate
- (void)productOffers:(NSInteger)status productOffers:(NSDictionary*)productOffers dataBinding:(int)binding {
    [APPLICATION_KEY_WINDOW hideToastActivity];
    if (status == MappActorFinishStatusOK) {
        if ([CommonUtils objectIsValid:productOffers] && productOffers.count > 0) {
            NSArray *offersArr = [[productOffers allValues] objectAtIndex:0];
            if ([CommonUtils objectIsValid:offersArr]) {
                self.currentProductOffer = [offersArr objectAtIndex:0];
                if (self.currentProductOffer) {
                    [self loadSpeedView:self.currentProductOffer];
                }
            }
        }
    } else if (status == MappActorFinishStatusNetwork) {
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"ErroMessage_Status_Network", nil)];
    } else {
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Turbo_Boost_Speed_Failed", nil)];
    }
}

- (void)rechargeFinished:(NSInteger)status payParams:(NSString *)params {
    NSLog(@"recharge finished params ==== %@",params);
    [APPLICATION_KEY_WINDOW hideToastActivity];
    if (status == MappActorFinishStatusOK) {
        if ([CommonUtils objectIsValid:params]) {
            PayViewController *payVC = [[PayViewController alloc] init];
            payVC.payUrlString = params;
            payVC.delegate = self;
            payVC.payAction = NSLocalizedString(@"Pay_Action_Recharge", @"Recharge");
            payVC.payFor = currentProductOffer.mDescription;
            [self.navigationController pushViewController:payVC animated:YES];
            [payVC release];
        } else {
            [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Turbo_Boost_Recharge_Finished_Ret_Url_Error", nil)];
        }
    } else if (status == MappActorFinishStatusNetwork) {
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"ErroMessage_Status_Network", nil)];
    } else {
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Turbo_Boost_Speed_Failed", nil)];
    }
}

- (void)syncFinished:(NSInteger)status {
    [APPLICATION_KEY_WINDOW hideToastActivity];
    if (status == MappActorFinishStatusOK) {
        //循环查找用户已订购的产品，判断是否订购成功
        NSArray *subscribers = [[[Session sharedSession] mMyCustomer] mMySubscribers];
        if ([CommonUtils objectIsValid:subscribers]) {
            BOOL turboSucceed = NO;
            for (int i = 0; i < [subscribers count]; i ++) {
                Subscriber *subscriber = [subscribers objectAtIndex:i];
                NSArray *products = subscriber.mProducts;
                if ([CommonUtils objectIsValid:products]) {
                    for (int j = 0 ; j < [products count]; j ++) {
                        Product *product = [products objectAtIndex:j];
                        if (product && [CommonUtils objectIsValid:product.mProductId] && [CommonUtils objectIsValid:currentProductOffer.mOfferId] && [product.mProductId isEqualToString:currentProductOffer.mOfferId]) {
                            turboSucceed = YES;
                            break;
                        }
                    }
                }
            }
            if (turboSucceed) {
                NSLog(@"产品加速成功");
                [gaugeView setGaugePercentValue:1. duration:2. voice:YES animated:YES completion:nil];
            } else {
                NSLog(@"产品加速失败");
                [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Turbo_Boost_Speed_Failed", nil)];
            }
        }
    } else if (status == MappActorFinishStatusNetwork) {
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"ErroMessage_Status_Network", nil)];
    } else {
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Turbo_Boost_Query_Speed_Result_Failed", nil)];
    }
}

#pragma mark pay action delegate
- (void)paymentActionBackWithPaymentStatus:(BOOL)succeed andParameters:(NSDictionary *)parameters {
    [self performSelector:@selector(showPayResult:) withObject:parameters afterDelay:0.1];
}

- (void)showPayResult:(NSDictionary*)payResult {
    NSString* status = [payResult objectForKey:@"Status"];
    if (YES == [status isEqualToString:@"000"]) {
        [PayViewController showPayResult:payResult inController:self delegate:self];
    } else {
        [PayViewController showPayResult:payResult inController:self delegate:nil];
    }
}

- (void)alertController:(AlertController *)alertController didDismissWithButtonIndex:(NSInteger)buttonIndex {
    Session *session = [Session sharedSession];
    Customer *customer = session.mMyCustomer;
    if (customer) {
        [APPLICATION_KEY_WINDOW makeToastActivity];
        [customer sync:self];
    }
}

#pragma mark load data
- (void)loadData {
#ifdef APPLICATION_BUILDING_RELEASE
    [APPLICATION_KEY_WINDOW makeToastActivity];
    Session *session = [Session sharedSession];
    Customer *customer = session.mMyCustomer;
    if (customer) {
        [customer slaProductOffers:@"" delegate:self];
    }
#else

#endif
}

- (ProductOffer *)fakeData {
    ProductOffer *offer = [[ProductOffer alloc] init];
    offer.mOfferName = @"Turbo";
    offer.mPrice = 1000;
    return offer;
}

#pragma mark gauge view delegate
- (NSInteger)numberOfRowsInGaugeView:(GaugeView*)gaugeView{
    return GAUGE_VIEW_NUM_ROWS_COUNT;
}

- (NSString*)gaugeView:(GaugeView*)gaugeView stringAtIndex:(NSInteger)index{
    NSString *scaleStr = nil;
    if (index == 0) {
        scaleStr = NSLocalizedString(@"Turbo_Boost_Low_Speed", nil);
    } else if (index == GAUGE_VIEW_NUM_ROWS_COUNT - 1) {
        scaleStr = NSLocalizedString(@"Turbo_Boost_High_Speed", nil);
    } else {
        scaleStr = @"";
    }
    return scaleStr;
}

- (UIColor*)gaugeView:(GaugeView*)gaugeView colorAtIndex:(NSInteger)index{
    return [[RTSSAppStyle currentAppStyle] textMajorColor];
}

#pragma mark speed product clicked
- (void)selectSpeedProduct:(UIButton *)product {
    if (self.currentProductOffer) {
        [APPLICATION_KEY_WINDOW makeToastActivity];
        Session *session = [Session sharedSession];
        Customer *customer = session.mMyCustomer;
        if (customer) {
            [currentProductOffer recharge:customer serviceId:@"" amount:self.currentProductOffer.mPrice payType:0 delegate:self];
        }
    }
}

#pragma mark layout parameters
- (CGFloat)getViewPaddingTopY {
    CGFloat topPadding = 25.;
    if (PHONE_UISCREEN_IPHONE5) {
        topPadding = 50.;
    } else if (PHONE_UISCREEN_IPHONE6) {
        topPadding = 60;
    }
    return topPadding;
}

- (CGFloat)getViewPaddingBottomY {
    CGFloat bottomPadding = 44.;
    if (PHONE_UISCREEN_IPHONE5) {
        bottomPadding = 65.;
    } else if (PHONE_UISCREEN_IPHONE6) {
        bottomPadding = 75.;
    }
    return bottomPadding;
}

- (CGFloat)getGaugeViewSpacingY {
    CGFloat spacingY = 25.;
    if (PHONE_UISCREEN_IPHONE5) {
        spacingY = 40.;
    } else if (PHONE_UISCREEN_IPHONE6) {
        spacingY = 60.;
    }
    return spacingY;
}


#pragma mark others
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
