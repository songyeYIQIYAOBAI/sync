//
//  PlanManageViewController.m
//  RTSS
//
//  Created by baisw on 14/10/23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "PlanManageViewController.h"
#import "QuickOrderItemView.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"
#import "CommonUtils.h"
#import "ImageUtils.h"
#import "SegmentControlView.h"
#import "QuickOrderCell.h"
#import "ProductOffer.h"
#import "ProductResource.h"
#import "ManagePlanDetailViewController.h"
#import "MappActor.h"
#import "Subscriber.h"
#import "Toast+UIView.h"
#import "MaskView.h"
#import "Session.h"
#import "PriceNegotiationViewController.h"
#import "PriceRule.h"
#import "RuleManager.h"
//#import "OrderSearchResultViewController.h"

#define SEGMENT_CONTROL_PADDING_X 60.f
#define SEGMENT_CONTROL_HEIGHT 30.f
#define SEGMENT_VIEW_HEIGHT 56.f

#define NAV_SEPERATE_LINE_HEIGHT 2.f

#define SEARCH_VIEW_PADDING_X 10.f
#define SEARCH_VIEW_PADDING_Y 10.f
#define SEARCH_VIEW_HEIGHT 50.F

#define ORDERS_TABLE_VIEW_PADDING_X 14.f
#define ORDERS_TABLE_VIEW_PADDING_Y 20.f
#define ORDERS_TABLE_VIEW_SPACE_Y_NORMAL 5.f
#define ORDERS_TABLE_VIEW_SPACE_Y_UNFOLD 20.f

#define ORDERS_TABLE_CELL_BASE_HEIGHT 125.f
#define ORDERS_TABLE_CELL_ADDITION_HEIGHT 20.f

@interface PlanManageViewController () <UITableViewDelegate,UITableViewDataSource,SegmentControlViewDelegate,UISearchBarDelegate,QuickOrderCellDelegate,MappActorDelegate,AlertControllerDelegate>
{
    UITableView *ordersTableView;
    
    UIView *segmentView;
    SegmentControlView *segmentControl;
    
    UIView *contentView;
    
 
    
}
@property(nonatomic,retain)NSArray *currentOrdersArray;
@end

@implementation PlanManageViewController


#pragma mark dealloc
- (void)dealloc
{
    [segmentControl release];
    [segmentView release];
    [contentView release];
    [ordersTableView release];
 
    [super dealloc];
}

#pragma mark init
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark others
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark view life cycle
- (void)loadView
{
    [super loadView];
    
    [self initNavBar];
    [self layoutContentView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma layout views
- (void)initNavBar {
    self.view.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
    navigationBarView = [self addNavigationBarView:NSLocalizedString(@"QuickOrder_Title", nil) bgColor:[[RTSSAppStyle currentAppStyle] navigationBarColor] separator:NO];
    [self.view addSubview:navigationBarView];
}

//- (void)layoutSegmentView {
//    //bg view
//    CGRect segViewFrame = CGRectMake(0.f, CGRectGetMaxY(navigationBarView.frame), PHONE_UISCREEN_WIDTH, SEGMENT_VIEW_HEIGHT);
//    segmentView = [[UIView alloc] initWithFrame:segViewFrame];
//    segmentView.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
//    [self.view addSubview:segmentView];
//    
//    //control
//    CGRect segControlFrame = CGRectMake(SEGMENT_CONTROL_PADDING_X, (SEGMENT_VIEW_HEIGHT - SEGMENT_CONTROL_HEIGHT) / 2.f, (CGRectGetWidth(segmentView.frame) - SEGMENT_CONTROL_PADDING_X * 2.f), SEGMENT_CONTROL_HEIGHT);
//    RTSSAppStyle *appStyle = [RTSSAppStyle currentAppStyle];
//    segmentControl = [[SegmentControlView alloc] initWithFrame:segControlFrame firstSegmentTitle:NSLocalizedString(@"Manage_Plan_Price_Nego_Title", nil) secondSegmentTitle:NSLocalizedString(@"Manage_Plan_Recharge_title", nil) normalTextColor:[appStyle textSubordinateColor] selectedTextColor:[UIColor whiteColor] normalControlBgColor:[appStyle navigationBarColor] selectedControlBgColor:[appStyle commonGreenButtonNormalColor] borderColor:[appStyle turboBoostButtonBgGreenColor] defaultSelectedIndex:0];
//    segmentControl.delegate = self;
//    [segmentView addSubview:segmentControl];
//    
//    //seperate line
//    UIImageView *seperateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0., CGRectGetMaxY(segmentView.frame), PHONE_UISCREEN_WIDTH, NAV_SEPERATE_LINE_HEIGHT)];
//    seperateImageView.image = [UIImage imageNamed:@"common_separator_line"];
//    [self.view addSubview:seperateImageView];
//    [seperateImageView release];
//}

-(void)layoutContentView
{
    CGRect contentFrame = CGRectMake(0, 20+44, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-20-44);
    contentView = [[UIView alloc] initWithFrame:contentFrame];
    contentView.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    [self.view addSubview:contentView];
    
    [self loadOrdersTableView];
}

//- (void)loadSearchView {
//    searchView = [[UISearchBar alloc] initWithFrame:[self getProperSearchViewFrame]];
//    searchView.placeholder = NSLocalizedString(@"Manage_Plan_Search_Holder", nil);
//    searchView.backgroundImage = [ImageUtils createImageWithColor:[[RTSSAppStyle currentAppStyle] viewControllerBgColor] size:CGSizeMake(PHONE_UISCREEN_WIDTH - SEARCH_VIEW_PADDING_X * 2.f, SEARCH_VIEW_HEIGHT)];
//    UITextField *textField = [searchView valueForKey:@"_searchField"];
//    textField.textColor = [[RTSSAppStyle currentAppStyle] textMajorColor];
//    textField.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
//    textField.layer.borderColor = [[RTSSAppStyle currentAppStyle] textFieldBorderColor].CGColor;
//    textField.layer.borderWidth = 1.f;
//    textField.layer.cornerRadius = 5.f;
//    searchView.showsCancelButton = NO;
//    searchView.delegate = self;
//    [contentView addSubview:searchView];
//}

- (void)loadOrdersTableView {
//    CGFloat offsetY = ([segmentControl currentSelectedIndex] == SegmentControlIndexSecond) ? ORDERS_TABLE_VIEW_SPACE_Y_NORMAL : ORDERS_TABLE_VIEW_SPACE_Y_UNFOLD;
//    CGRect tableFrame = CGRectMake(ORDERS_TABLE_VIEW_PADDING_X, CGRectGetMaxY(searchView.frame) + offsetY, PHONE_UISCREEN_WIDTH - ORDERS_TABLE_VIEW_PADDING_X * 2.f, CGRectGetHeight(contentView.frame) - CGRectGetMaxY(searchView.frame) - offsetY - ORDERS_TABLE_VIEW_PADDING_Y);
    CGRect tableFrame = CGRectMake(ORDERS_TABLE_VIEW_PADDING_X, 5, PHONE_UISCREEN_WIDTH - ORDERS_TABLE_VIEW_PADDING_X*2 , CGRectGetHeight(contentView.frame)-5);
    ordersTableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    ordersTableView.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    ordersTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    ordersTableView.showsHorizontalScrollIndicator = NO;
    ordersTableView.showsVerticalScrollIndicator = NO;
    ordersTableView.delegate = self;
    ordersTableView.dataSource = self;
    ordersTableView.allowsSelection = NO;
    [contentView addSubview:ordersTableView];
}

- (CGRect)getProperSearchViewFrame {
    CGRect properFrame = CGRectZero;
    if ([segmentControl currentSelectedIndex] == SegmentControlIndexSecond) {
        properFrame = CGRectMake(SEARCH_VIEW_PADDING_X, SEARCH_VIEW_PADDING_Y, PHONE_UISCREEN_WIDTH - SEARCH_VIEW_PADDING_X * 2.f, SEARCH_VIEW_HEIGHT);
    } else {
        properFrame = CGRectZero;
    }
    return properFrame;
}

#pragma mark table view delegate method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNum = 0;
    if ([self currentOrdersArray]) {
        rowNum = [[self currentOrdersArray] count];
    }
    return rowNum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.f;
    if ([self currentOrdersArray]) {
        height = ORDERS_TABLE_CELL_BASE_HEIGHT + ORDERS_TABLE_CELL_ADDITION_HEIGHT;
        if (indexPath.row == [[self currentOrdersArray] count] - 1) {
           // height -= ORDERS_TABLE_CELL_ADDITION_HEIGHT;
        }
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentity = @"quickOrderCell";
    QuickOrderCell *orderCell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (orderCell == nil) {
        orderCell = [[[QuickOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity availableSize:CGSizeMake(CGRectGetWidth(ordersTableView.frame), ORDERS_TABLE_CELL_BASE_HEIGHT)] autorelease];
        orderCell.delegate = self;
        orderCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //load data
    ProductOffer *offer = nil;
    if ([self currentOrdersArray] && [[self currentOrdersArray] count] > 0) {
        offer = [[self currentOrdersArray] objectAtIndex:indexPath.row];
    }
    [orderCell layoutCellSubviewsByResourceData:offer type:[self currentQuickOrderType] cellIndex:indexPath];
    orderCell.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    return orderCell;
}

- (QuickOrderType)currentQuickOrderType {
    QuickOrderType type;
    if (segmentControl.currentSelectedIndex == SegmentControlIndexFirst) {
        type = QuickOrderTypeNegotiation;
    } else {
        type = QuickOrderTypeRecharge;
    }
    return type;
}



#pragma mark QuickOrderCellDelegate 
- (void)quickOrderCell:(QuickOrderCell *)orderCell actionButtonClickedAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"action button clicked at index %d",indexPath.row);
    
    ProductOffer *offer = [self.currentOrdersArray objectAtIndex:indexPath.row];
    
    if (offer.mNegotiable) {
        
        [APPLICATION_KEY_WINDOW makeToastActivity];
        if (![CommonUtils objectIsValid:offer.mResources] || ![CommonUtils objectIsValid:offer.mOfferId]) {
            [AlertController showSimpleAlertWithTitle:nil message:@"There is no ProductResource data" buttonTitle:@"OK" inViewController:self];
            return;
        }
        
//        PriceRule *priceRule = [[RuleManager sharedRuleManager]getPriceRule:offer.mOfferId];
        
        //保证 rule存在性
//        if (!priceRule || ![CommonUtils objectIsValid:priceRule.mRuleItems]) {
//            [AlertController showSimpleAlertWithTitle:nil message:@"There is no ProductResource Rule" buttonTitle:@"OK" inViewController:self];
//            return;
//        }
//        
//        //规则与产品数量不匹配
//        if ([priceRule.mRuleItems count] != [offer.mResources count]) {
//            [AlertController showSimpleAlertWithTitle:nil message:@"Data Error" buttonTitle:@"OK" inViewController:self];
//            return;
//        }

        [APPLICATION_KEY_WINDOW hideToastActivity];
        //可议价
        PriceNegotiationViewController *priceNegotiation = [[PriceNegotiationViewController alloc]init];
        [priceNegotiation loadProductResourceData:offer.mResources];
//        priceNegotiation.priceRule = priceRule;
        priceNegotiation.currentProductPrice = offer.mPrice;
        
        [self.navigationController pushViewController:priceNegotiation animated:YES];
        [priceNegotiation release];
       
        
    }else{
        //不可以议价
        AlertController *alert = [[AlertController alloc]initWithTitle:nil message:@"Ok to Recharge?" delegate:self tag:2000 cancelButtonTitle:NSLocalizedString(@"UIAlertView_Cancel_String", nil) otherButtonTitles:NSLocalizedString(@"UIAlertView_Confirm_String", nil),nil];
        [alert showInViewController:self];
        [alert release];
        
        
    }
    
}

- (void)quickOrderCell:(QuickOrderCell *)orderCell didSelectCellAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark --AlertDelegate
-(void)alertController:(AlertController *)alertController didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (alertController.tag == 2000) {
        
        if (buttonIndex==0) {
            //用户取消不做任何处理
            
        }else if(buttonIndex == 1){
            //用户确认支付
            AlertController *alert = [[AlertController alloc]initWithTitle:nil message:@"Are you sure?" delegate:self tag:0 cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert showInViewController:self];
            [alert release];
        }
        return;
        
        
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark segment view delegate method
- (void)segmentControlView:(SegmentControlView *)segmentView didSelectedSegmentAtIndex:(SegmentControlIndex)index {
    [self updateViewPositionBySegmentIndex:index];
    [ordersTableView reloadData];
}

- (void)updateViewPositionBySegmentIndex:(SegmentControlIndex)index {
   
    
    //table view
    CGFloat offsetY = ([segmentControl currentSelectedIndex] == SegmentControlIndexSecond) ? ORDERS_TABLE_VIEW_SPACE_Y_NORMAL : ORDERS_TABLE_VIEW_SPACE_Y_UNFOLD;
    CGFloat tableHeight = CGRectGetHeight(contentView.frame) -  - offsetY - ORDERS_TABLE_VIEW_PADDING_Y;
    CGRect tableFrame = ordersTableView.frame;
    tableFrame.origin = CGPointMake(ORDERS_TABLE_VIEW_PADDING_X,  offsetY);
    tableFrame.size.height = tableHeight;
    ordersTableView.frame = tableFrame;
}


#pragma mark load data
- (void)loadData
{
   
    
    [APPLICATION_KEY_WINDOW makeToastActivity];
    Session *session = [Session sharedSession];
    [session.mMyCustomer rechargeableProductOffers:@"key" dataBinding:1 delegate:self];

}

-(void)productOffers:(NSInteger)status productOffers:(NSDictionary *)productOffers dataBinding:(int)binding{
    
    [APPLICATION_KEY_WINDOW hideToastActivity];
    if (status == MappActorFinishStatusOK) {
        
        if (![CommonUtils objectIsValid:productOffers]) {
            return;
        }
    
        self.currentOrdersArray = [productOffers objectForKey:@"key"];
        
        [ordersTableView reloadData];
        
    }else{
        
    
    }
    
}

@end
