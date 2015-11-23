//
//  BudgetJoinViewController.m
//  RTSS
//
//  Created by 加富董 on 15/1/18.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "BudgetJoinViewController.h"
#import "PayCodeViewController.h"

#import "RTSSAppStyle.h"
#import "RTSSAppDefine.h"
#import "BudgetJoinCell.h"
#import "BudgetVicinityViewController.h"

typedef NS_ENUM(NSInteger, JoinMethod) {
    JoinMethodViaQRCode = 0,
    JoinMethodViaVicinity,
};

#define JOIN_CELL_ICON_KEY @"icon"
#define JOIN_CELL_TEXT_KEY @"text"

#define BUDGET_JOIN_SEP_HEADER_HEIGHT 23.0
#define JOIN_CELL_HEIGHT 50.0


@interface BudgetJoinViewController () <UITableViewDataSource, UITableViewDelegate, BudgetVicinityViewControllerDelegate> {
    UIView *contentView;
    UIView *seperatorHeaderView;
}

@property (nonatomic, retain)UITableView *joinMethodTableView;
@property (nonatomic, retain)NSMutableArray *joinMethodArray;

@end

@implementation BudgetJoinViewController

@synthesize joinMethodTableView;
@synthesize joinMethodArray;

#pragma mark dealloc
- (void)dealloc {
    [contentView release];
    [seperatorHeaderView release];
    [joinMethodTableView release];
    [joinMethodArray release];
    [super dealloc];
}

#pragma mark life cycle
- (void)loadView {
    [super loadView];
    [self loadNavBarView];
    [self loadContentView];
}

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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark init views
- (void)loadNavBarView {
    self.view.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    navigationBarView = [self addNavigationBarView:NSLocalizedString(@"Budget_Join_Title", nil) bgColor:[[RTSSAppStyle currentAppStyle] navigationBarColor] separator:YES];
    [self.view addSubview:navigationBarView];
}

- (void)loadContentView {
    CGRect contentRect = CGRectMake(0.0, CGRectGetMaxY(navigationBarView.frame), PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT - CGRectGetMaxY(navigationBarView.frame));
    contentView = [[UIView alloc] initWithFrame:contentRect];
    contentView.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    [self.view addSubview:contentView];
    
    [self loadSeperatorHeaderView];
    [self loadJoinMethodTable];
}

- (void)loadSeperatorHeaderView {
    if (seperatorHeaderView == nil) {
        CGRect headerRect = CGRectMake(0.0, 0.0, PHONE_UISCREEN_WIDTH, BUDGET_JOIN_SEP_HEADER_HEIGHT);
        seperatorHeaderView = [[UIView alloc] initWithFrame:headerRect];
        seperatorHeaderView.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
        [contentView addSubview:seperatorHeaderView];
        
        //sep line
        CGRect sepRect = CGRectMake(0.0, CGRectGetHeight(seperatorHeaderView.frame) - SEPERATOR_LINE_HEIGHT, PHONE_UISCREEN_WIDTH, SEPERATOR_LINE_HEIGHT);
        UIImageView *sepLine = [[UIImageView alloc] initWithFrame:sepRect];
        sepLine.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;

        [seperatorHeaderView addSubview:sepLine];
        [sepLine release];
    }
}

- (void)loadJoinMethodTable {
    if (joinMethodTableView == nil) {
        CGRect tableRect = CGRectMake(0.0, CGRectGetMaxY(seperatorHeaderView.frame), PHONE_UISCREEN_WIDTH, CGRectGetHeight(contentView.frame) - CGRectGetMaxY(seperatorHeaderView.frame));
        joinMethodTableView = [[UITableView alloc] initWithFrame:tableRect];
        joinMethodTableView.backgroundColor = [UIColor clearColor];
        joinMethodTableView.delegate = self;
        joinMethodTableView.dataSource = self;
        joinMethodTableView.showsHorizontalScrollIndicator = NO;
        joinMethodTableView.showsVerticalScrollIndicator = YES;
        joinMethodTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        joinMethodTableView.rowHeight = JOIN_CELL_HEIGHT;
        [contentView addSubview:joinMethodTableView];
    }
}

#pragma mark table view delegate method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return JOIN_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    BudgetJoinCell *joinCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (joinCell == nil) {
        joinCell = [[[BudgetJoinCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId availableSize:CGSizeMake(PHONE_UISCREEN_WIDTH, JOIN_CELL_HEIGHT)] autorelease];
        [self setBgStyle:joinCell];
    }
    NSDictionary *cellDict = [joinMethodArray objectAtIndex:indexPath.row];
    if ([CommonUtils objectIsValid:cellDict]) {
        [self layoutJoinCell:joinCell cellData:cellDict];
    }
    return joinCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"join method did select row at index == %d",indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == JoinMethodViaQRCode) {
        
        PayCodeViewController *payVC = [[PayCodeViewController alloc] init];
        payVC.tips = NSLocalizedString(@"Budget_Join_My_QR_Tip", nil);
        [self.navigationController pushViewController:payVC animated:YES];
        [payVC release];
        
    } else if (indexPath.row == JoinMethodViaVicinity) {

        BudgetVicinityViewController *vicinityVC = [[BudgetVicinityViewController alloc] init];
        vicinityVC.groupType = GroupTypeJoined;
        vicinityVC.delegate = self;
        [self.navigationController pushViewController:vicinityVC animated:YES];
        [vicinityVC release];
    }
}

- (void)layoutJoinCell:(BudgetJoinCell *)cell cellData:(NSDictionary *)dataDict {
    if (dataDict) {
        NSString *title = [dataDict objectForKey:JOIN_CELL_TEXT_KEY];
        NSString *icon = [dataDict objectForKey:JOIN_CELL_ICON_KEY];
        cell.joinMethodLabel.text = title;
        cell.joinMethodIcon.image = [UIImage imageNamed:icon];
        cell.joinMethodIcon.contentMode = UIViewContentModeScaleAspectFit;
        cell.arrowImageView.image = [UIImage imageNamed:@"common_next_arrow2"];
    }
}

#pragma mark vicinity delegate
- (void)budgetVicinityViewController:(BudgetVicinityViewController *)vicinity didClickedConfirmButtonWithMembersData:(NSMutableArray *)membersArray {
    NSLog(@"budget joinvc vicinity members===%@",membersArray);
}

#pragma mark tools method
- (void)setBgStyle:(BudgetJoinCell *)cell {
    //normal
    UIView *unselectedView = [[UIView alloc] initWithFrame:cell.frame];
    unselectedView.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
    cell.backgroundView = unselectedView;
    [unselectedView release];
    
    //selected
    UIView *selectedView = [[UIView alloc] initWithFrame:cell.frame];
    selectedView.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
    cell.selectedBackgroundView = selectedView;
    [selectedView release];
}

#pragma mark button clicked
- (void)backBarButtonAction:(UIButton*)barButtonItem {
//    [[RTSSNotificationCenter standardRTSSNotificationCenter] postNotificationWithType:RTSSNotificationTypeBudgetGroupListRefresh object:nil userInfo:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark load data
- (void)loadData {
    self.joinMethodArray = [self getData];
}

- (NSMutableArray *)getData {
    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *titlesArray = @[NSLocalizedString(@"Budget_Join_Via_QR_Code", nil),
                            NSLocalizedString(@"Budget_Join_Via_Vicinity", nil)];
    NSArray *iconsArray = @[@"budget_group_join",@"budget_bg_near_d"];
    for (int i = 0; i < 2; i ++) {
        NSString *title = [titlesArray objectAtIndex:i];
        NSString *icon = [iconsArray objectAtIndex:i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
        [dict setObject:title forKey:JOIN_CELL_TEXT_KEY];
        [dict setObject:icon forKey:JOIN_CELL_ICON_KEY];
        [dataArray addObject:dict];
        [dict release];
    }
    return [dataArray autorelease];
    
}

@end
