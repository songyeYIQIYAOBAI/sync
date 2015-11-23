//
//  OrderPreviewViewController.m
//  RTSS
//
//  Created by 加富董 on 14/11/28.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "OrderPreviewViewController.h"
#import "RTSSAppStyle.h"
#import "OrderPreviewCell.h"
#import "CommonUtils.h"
#import "OrderInfoModel.h"
#import "ProductOffer.h"
#import "Toast+UIView.h"
#import "Session.h"
#import "Customer.h"
#import "AlertController.h"
#import "Product.h"
#import "PayViewController.h"

typedef NS_ENUM(NSInteger, ActionType) {
    ActionTypeCancel,
    ActionTypePayment
};

typedef NS_ENUM(NSInteger, AlertViewStyle) {
    AlertViewStyleCancelOrder,
};

#define ORDER_PREVIEW_FOOTER_VIEW_HEIGHT 60.0
#define ACTION_BUTTON_HEIGHT 40.0
#define ACTION_BUTTON_PADDING_X 37.0
#define ACTION_BUTTON_SPACE_X 25.0
#define ACTION_BUTTON_CORNER_RADIUS 5.0
#define ACTION_BUTTON_BORDER_WIDTH 1.0

@interface OrderPreviewViewController () <UITableViewDataSource,UITableViewDelegate,MappActorDelegate,AlertControllerDelegate> {
    UITableView *orderPreviewTableView;
    UIView *orderPreviewFooterView;
}

@property (nonatomic, retain) NSMutableArray *orderInfoArray;

@end

@implementation OrderPreviewViewController

@synthesize orderInfoArray;
@synthesize serviceId;
@synthesize purchaseType;
@synthesize product;

#pragma mark dealloc
- (void)dealloc {
    [orderPreviewFooterView release];
    [orderPreviewTableView release];
    [orderInfoArray release];
    [serviceId release];
    [product release];
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
}

- (void)loadView {
    [super loadView];
    [self loadNavBar];
    [self loadOrderPreviewTableView];
    [self loadOrderPreviewFooterView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark init views
- (void)loadNavBar {
    self.view.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
    navigationBarView = [self addNavigationBarView:NSLocalizedString(@"Order_Preview_Title", nil) bgColor:[[RTSSAppStyle currentAppStyle] navigationBarColor] separator:YES];
    [self.view addSubview:navigationBarView];
}

- (void)loadOrderPreviewTableView {
    CGRect tableViewRect = CGRectMake(0., CGRectGetMaxY(navigationBarView.frame), PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT - CGRectGetMaxY(navigationBarView.frame) - ORDER_PREVIEW_FOOTER_VIEW_HEIGHT);
    orderPreviewTableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
    orderPreviewTableView.allowsSelection = NO;
    orderPreviewTableView.showsHorizontalScrollIndicator = NO;
    orderPreviewTableView.showsVerticalScrollIndicator = NO;
    orderPreviewTableView.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    orderPreviewTableView.delegate = self;
    orderPreviewTableView.dataSource = self;
    orderPreviewTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:orderPreviewTableView];
}

- (void)loadOrderPreviewFooterView {
    CGRect footerViewRect = CGRectMake(0., CGRectGetMaxY(orderPreviewTableView.frame), PHONE_UISCREEN_WIDTH, ORDER_PREVIEW_FOOTER_VIEW_HEIGHT);
    orderPreviewFooterView = [[UIView alloc] initWithFrame:footerViewRect];
    orderPreviewFooterView.backgroundColor = [[RTSSAppStyle currentAppStyle] turboBoostUnfoldBgColor];
    [self.view addSubview:orderPreviewFooterView];
    
    CGFloat actionBtnWidth = (PHONE_UISCREEN_WIDTH - ACTION_BUTTON_PADDING_X * 2 - ACTION_BUTTON_SPACE_X) * 1.0 / 2;
    CGFloat actionBtnY = (ORDER_PREVIEW_FOOTER_VIEW_HEIGHT - ACTION_BUTTON_HEIGHT) * 1.0 / 2;
    
    //cancel button
    CGRect cancelFrame = CGRectMake(ACTION_BUTTON_PADDING_X, actionBtnY, actionBtnWidth, ACTION_BUTTON_HEIGHT);
    UIButton *cancelBtn = [CommonUtils buttonWithType:UIButtonTypeCustom frame:cancelFrame title:NSLocalizedString(@"Order_Preview_Cancel", nil) colorNormal:[[RTSSAppStyle currentAppStyle] viewControllerBgColor] colorHighlighted:nil colorSelected:nil addTarget:self action:@selector(actionButtonClicked:) tag:ActionTypeCancel];
    cancelBtn.layer.cornerRadius = ACTION_BUTTON_CORNER_RADIUS;
    cancelBtn.layer.borderWidth = ACTION_BUTTON_BORDER_WIDTH;
    cancelBtn.layer.borderColor = [[RTSSAppStyle currentAppStyle] textFieldBorderColor].CGColor;
    cancelBtn.layer.masksToBounds = YES;
    [orderPreviewFooterView addSubview:cancelBtn];
    
    //payment button
    CGRect payFrame = CGRectMake(CGRectGetMaxX(cancelFrame) + ACTION_BUTTON_SPACE_X, actionBtnY, actionBtnWidth, ACTION_BUTTON_HEIGHT);
    UIButton *paymentBtn = [CommonUtils buttonWithType:UIButtonTypeCustom frame:payFrame title:NSLocalizedString(@"Order_Preview_Payment", nil) colorNormal:[[RTSSAppStyle currentAppStyle] commonGreenButtonNormalColor] colorHighlighted:[[RTSSAppStyle currentAppStyle] commonGreenButtonHighlightColor] colorSelected:nil addTarget:self action:@selector(actionButtonClicked:) tag:ActionTypePayment];
    paymentBtn.layer.cornerRadius = ACTION_BUTTON_CORNER_RADIUS;
    paymentBtn.layer.borderWidth = ACTION_BUTTON_BORDER_WIDTH;
    paymentBtn.layer.borderColor = [[RTSSAppStyle currentAppStyle] textFieldBorderColor].CGColor;
    paymentBtn.layer.masksToBounds = YES;
    [orderPreviewFooterView addSubview:paymentBtn];
}

#pragma mark table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [orderInfoArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = ORDER_PREVIEW_CELL_DEFAULT_HEIGHT;
    OrderInfoModel *orderInfo = [orderInfoArray objectAtIndex:indexPath.row];
    if (orderInfo) {
        height = [OrderPreviewCell calculateCellHeightByCellData:orderInfo defaultAvailableSize:CGSizeMake(CGRectGetWidth(orderPreviewTableView.frame), ORDER_PREVIEW_CELL_DEFAULT_HEIGHT)];
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"orderPreviewCell";
    OrderPreviewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[OrderPreviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier defaultAvailableSize:CGSizeMake(CGRectGetWidth(orderPreviewTableView.frame), ORDER_PREVIEW_CELL_DEFAULT_HEIGHT)] autorelease];
    }
    //cell bg
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [[RTSSAppStyle currentAppStyle] separationBgColor];
    } else {
        cell.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
    }
    
    //data
    OrderInfoModel *orderInfo = [orderInfoArray objectAtIndex:indexPath.row];
    if (orderInfo) {
        [cell layoutSubviewsByOrderInfoData:orderInfo showSeperateLine:YES];
    }
    
    return cell;
}

#pragma mark map actor delegate
- (void)rechargeFinished:(NSInteger)status payParams:(NSDictionary*)params {
    [APPLICATION_KEY_WINDOW hideToastActivity];
    if (status == MappActorFinishStatusOK) {
        NSLog(@"order preview payment request succeed !!!!!!!\n %@\n\n",params);
        //goto web page
        PayViewController *payVC = [[PayViewController alloc] init];
        payVC.payUrlString = [NSString stringWithFormat:@"http://www.baidu.com"];
        [self.navigationController pushViewController:payVC animated:YES];
    }
}

#pragma mark alert delegate
- (void)alertController:(AlertController *)alertController didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSInteger tag = alertController.tag;
    switch (tag) {
        case AlertViewStyleCancelOrder:
        {
        
        }
            break;
            
        default:
            break;
    }
}

#pragma mark action button clicked
- (void)actionButtonClicked:(UIButton *)actionButton {
    ActionType type = actionButton.tag;
    switch (type) {
        case ActionTypeCancel:
        {
            AlertController *alert = [[AlertController alloc] initWithTitle:nil message:NSLocalizedString(@"Order_Preview_Order_Cancel", nil) delegate:self tag:AlertViewStyleCancelOrder cancelButtonTitle:NSLocalizedString(@"UIAlertView_Confirm_String", nil) otherButtonTitles:nil];
            [alert showInViewController:self];
            [alert release];
        }
            break;
        case ActionTypePayment:
        {
#ifdef APPLICATION_BUILDING_RELEASE
            if (purchaseType == PurchaseTypeProduct) {
                if (self.product) {
                    [APPLICATION_KEY_WINDOW makeToastActivity];
                    //request
                    [(Product *)product recharge:[[Session sharedSession] mMyCustomer] serviceId:serviceId amount:100000 payType:0 delegate:self];
                }
            } else if (purchaseType == PurchaseTypeProductOffer) {
                if (self.product) {
                    [APPLICATION_KEY_WINDOW makeToastActivity];
                    [(ProductOffer *)product recharge:[[Session sharedSession] mMyCustomer] serviceId:serviceId amount:[(ProductOffer *)product mPrice] payType:0 delegate:self];
                }
            }
#else

#endif
        }
            break;
        default:
            break;
    }
}

#pragma mark load data
- (void)loadData {
    self.orderInfoArray = [self fakeData];
}

- (NSMutableArray *)fakeData {
    NSMutableArray *infoArray = [NSMutableArray array];
    NSArray *titles = @[@"Order No",@"Order Type",@"Offer Type",@"Service Id",@"Package Name",@"Created",@"Order Status",@"Order Test",@"Order Test",@"Order Test",@"Order Test",@"Order Test",@"Order Test",@"Order Test",@"Order Test"];
    NSArray *contents = @[@"BR000000LIA8",@"Recharge",@"Prepaid",@"7774012572",@"Jio 800 plan with 200 min",@"28/11/2014 16:48:09",@"€8000.00",@"反对撒娇放假啊老师的放",@"FADJFALDJFLAJDFL",@"fadfjlj",@"放假啊放假了法拉盛都放假了法律的时间发生的解放法律的解放发生了放假啊了法律上解放了伐啦放假啊发的解放了",@"发呆发呆发呆",@"发大发发发",@"我而且诶日热舞",@"发达放假啊了放假啊了解法律家"];
    for (int i = 0; i < 7; i ++) {
        OrderInfoModel *info = [[OrderInfoModel alloc] init];
        info.infoTitle = [titles objectAtIndex:i];
        info.infoContent = [contents objectAtIndex:i];
        if ([[titles objectAtIndex:i] isEqualToString:@"Order Status"]) {
            info.contentColorStr = @"#87ad2b";
        }
        [infoArray addObject:info];
    }
    return infoArray;
}

#pragma mark others
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
