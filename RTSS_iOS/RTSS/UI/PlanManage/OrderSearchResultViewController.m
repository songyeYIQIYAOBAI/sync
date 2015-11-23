//
//  OrderSearchResultViewController.m
//  RTSS
//
//  Created by 加富董 on 14/11/15.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "OrderSearchResultViewController.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"
#import "QuickOrderCell.h"
#import "ProductOffer.h"
#import "ProductResource.h"
#import "PriceNegotiationViewController.h"
#import "ManagePlanDetailViewController.h"

#define ORDERS_TABLE_VIEW_PADDING_X 14.f
#define ORDERS_TABLE_VIEW_PADDING_TOP_Y 20.f
#define ORDERS_TABLE_VIEW_PADDING_BOTTOM_Y 20.f

#define ORDERS_TABLE_CELL_BASE_HEIGHT 125.f
#define ORDERS_TABLE_CELL_ADDITION_HEIGHT 20.f

@interface OrderSearchResultViewController () <UITableViewDelegate,UITableViewDataSource,QuickOrderCellDelegate> {
    UITableView *resultTableView;
    UIView *contentView;
}

@end

@implementation OrderSearchResultViewController

@synthesize ordersResultArray;

#pragma mark dealloc
- (void)dealloc {
    [resultTableView release];
    [contentView release];
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
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark load view
- (void)loadView {
    [super loadView];
    [self initNavBar];
    [self initContentView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initNavBar {
    self.view.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
    navigationBarView = [self addNavigationBarView:NSLocalizedString(@"Manage_Plan_Order_Search_Title", nil) bgColor:[[RTSSAppStyle currentAppStyle] navigationBarColor] separator:YES];
    [self.view addSubview:navigationBarView];
}

- (void)initContentView {
    CGRect contentRect = CGRectMake(0.f, CGRectGetMaxY(navigationBarView.frame), PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT - CGRectGetMaxY(navigationBarView.frame));
    contentView = [[UIView alloc] initWithFrame:contentRect];
    contentView.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    [self.view addSubview:contentView];
    
    [self initResultTableView];
}
- (void)initResultTableView {
    CGRect tableRect = CGRectMake(ORDERS_TABLE_VIEW_PADDING_X, ORDERS_TABLE_VIEW_PADDING_TOP_Y, PHONE_UISCREEN_WIDTH - ORDERS_TABLE_VIEW_PADDING_X * 2.f, PHONE_UISCREEN_HEIGHT - CGRectGetMaxY(navigationBarView.frame) - ORDERS_TABLE_VIEW_PADDING_TOP_Y - ORDERS_TABLE_VIEW_PADDING_BOTTOM_Y);
    resultTableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
    resultTableView.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    resultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    resultTableView.showsHorizontalScrollIndicator = NO;
    resultTableView.showsVerticalScrollIndicator = NO;
    resultTableView.delegate = self;
    resultTableView.dataSource = self;
    resultTableView.allowsSelection = NO;
    [contentView addSubview:resultTableView];
}

#pragma mark table view delegate method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [ordersResultArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = ORDERS_TABLE_CELL_BASE_HEIGHT + ORDERS_TABLE_CELL_ADDITION_HEIGHT;
    if (indexPath.row == [ordersResultArray count] - 1) {
        height -= ORDERS_TABLE_CELL_ADDITION_HEIGHT;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentity = @"quickOrderCell";
    QuickOrderCell *orderCell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (orderCell == nil) {
        orderCell = [[QuickOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity availableSize:CGSizeMake(CGRectGetWidth(resultTableView.frame), ORDERS_TABLE_CELL_BASE_HEIGHT)];
        orderCell.delegate = self;
        orderCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //load data
    ProductOffer *offer = nil;
    if (ordersResultArray && [ordersResultArray count] > 0) {
        offer = [ordersResultArray objectAtIndex:indexPath.row];
    }
    [orderCell layoutCellSubviewsByResourceData:offer type:QuickOrderTypeRecharge cellIndex:indexPath];
    orderCell.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    return orderCell;
}


#pragma mark QuickOrderCellDelegate
- (void)quickOrderCell:(QuickOrderCell *)orderCell actionButtonClickedAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"action button clicked at index %d",indexPath.row);
    PriceNegotiationViewController * vc = [[PriceNegotiationViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)quickOrderCell:(QuickOrderCell *)orderCell didSelectCellAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cell clicked at index %d",indexPath.row);
    ManagePlanDetailViewController *detailVC = [[ManagePlanDetailViewController alloc] init];
    if (ordersResultArray) {
        @try {
            ProductOffer *offer = [ordersResultArray objectAtIndex:indexPath.row];
            //detailVC.porductOffer = offer;
        }
        @catch (NSException *exception) {
            NSLog(@"porduct offer array bad access!");
        }
    }
    [self.navigationController pushViewController:detailVC animated:YES];
    [detailVC release];
}

#pragma mark load data
- (void)loadData {
    [super loadData];
}

#pragma mark other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
