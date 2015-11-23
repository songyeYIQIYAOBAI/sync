//
//  CommentShareViewController.m
//  RTSS
//
//  Created by Jaffer on 15/4/2.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "FindShareMethodsViewController.h"
#import "FindShareCell.h"

#define SHARE_METHOD_CELL_HEIGHT 60.0
#define SHARE_METHOD_INFO_KEY_ICON @"icon"
#define SHARE_METHOD_INFO_KEY_NAME @"name"

@interface FindShareMethodsViewController () <UITableViewDataSource, UITableViewDelegate> {
    UIView *contentView;
    UITableView *shareMethodsTableView;
}

@property (nonatomic, retain) NSMutableArray *shareMethodsArray;

@end

@implementation FindShareMethodsViewController

@synthesize shareMethodsArray;

#pragma mark dealloc
- (void)dealloc {
    [contentView release];
    [shareMethodsTableView release];
    self.shareMethodsArray = nil;
    
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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)loadView {
    [super loadView];
    [self loadNavView];
    [self loadContentView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark load views
- (void)loadNavView {
    self.view.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
    navigationBarView = [self addNavigationBarView:NSLocalizedString(@"Find_Share_Methods_Title", nil) bgColor:[[RTSSAppStyle currentAppStyle] navigationBarColor] separator:YES];
    [self.view addSubview:navigationBarView];
    
    [self loadShareMethodsTableView];
}

- (void)loadContentView {
    CGRect contentRect = CGRectMake(0.0, CGRectGetMaxY(navigationBarView.frame), PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT - CGRectGetMaxY(navigationBarView.frame));
    contentView = [[UIView alloc] initWithFrame:contentRect];
    contentView.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    [self.view addSubview:contentView];
    
    [self loadShareMethodsTableView];
}

- (void)loadShareMethodsTableView {
    CGRect tableRect = CGRectMake(0.0, 0.0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT -CGRectGetMaxY(navigationBarView.frame));
    shareMethodsTableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
    shareMethodsTableView.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    shareMethodsTableView.rowHeight = SHARE_METHOD_CELL_HEIGHT;
    shareMethodsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    shareMethodsTableView.showsHorizontalScrollIndicator = NO;
    shareMethodsTableView.showsVerticalScrollIndicator = NO;
    shareMethodsTableView.delegate = self;
    shareMethodsTableView.dataSource = self;
    [contentView addSubview:shareMethodsTableView];
}

#pragma mark table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [shareMethodsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SHARE_METHOD_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"shareMethodsCell";
    FindShareCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[FindShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier availableSize:CGSizeMake(PHONE_UISCREEN_WIDTH, SHARE_METHOD_CELL_HEIGHT)] autorelease];
        cell.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
        [self setBgStyle:cell];
    }
    NSDictionary *cellInfo = [shareMethodsArray objectAtIndex:indexPath.row];
    [self layoutShareCellSubviews:cell byCellInfo:cellInfo];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *shareInfo = [shareMethodsArray objectAtIndex:indexPath.row];
    NSLog(@"did select share cell::%@",[shareInfo objectForKey:SHARE_METHOD_INFO_KEY_NAME]);
}

- (void)layoutShareCellSubviews:(FindShareCell *)cell byCellInfo:(NSDictionary *)cellInfo {
   //icon
    cell.shareIconImageView.image = [UIImage imageNamed:[cellInfo objectForKey:SHARE_METHOD_INFO_KEY_ICON]];
    
    //name
    cell.shareNameLabel.text = [cellInfo objectForKey:SHARE_METHOD_INFO_KEY_NAME];
    
    //arrow
    cell.shareArrowImageView.image = [UIImage imageNamed:@"common_next_arrow2.png"];
    
    //sep
    cell.shareSepLineImageView.backgroundColor = [[RTSSAppStyle currentAppStyle] separatorColor];
}


- (void)setBgStyle:(UITableViewCell *)cell {
    UIView *unselectedView = [[UIView alloc] init];
    unselectedView.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
    cell.backgroundView = unselectedView;
    [unselectedView release];
    
    UIView *selectedView = [[UIView alloc] init];
    selectedView.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    cell.selectedBackgroundView = selectedView;
    [selectedView release];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0.0, SHARE_METHOD_CELL_HEIGHT - 0.5, PHONE_UISCREEN_WIDTH, 0.5)];
    line.backgroundColor = [[RTSSAppStyle currentAppStyle] separatorColor];
    [selectedView addSubview:line];
    [line release];
}

#pragma mark load data
- (void)loadData {
    self.shareMethodsArray = [self loadMethodsData];
}

- (NSMutableArray *)loadMethodsData {
    NSMutableArray *methods = [NSMutableArray array];
    NSArray *icons = @[NSLocalizedString(@"Find_Share_Method_Sina_Blog_Icon", nil),
                       NSLocalizedString(@"Find_Share_Method_Tencent_Blog_Icon", nil),
                       NSLocalizedString(@"Find_Share_Method_We_Chat_Icon", nil),
                       NSLocalizedString(@"Find_Share_Method_We_Chat_Friends_Icon", nil)];
    
    NSArray *names = @[NSLocalizedString(@"Find_Share_Method_Sina_Blog", nil),
                       NSLocalizedString(@"Find_Share_Method_Tencent_Blog", nil),
                       NSLocalizedString(@"Find_Share_Method_We_Chat", nil),
                       NSLocalizedString(@"Find_Share_Method_We_Chat_Friends", nil)];
    for (int i = 0; i < 4; i ++) {
        NSDictionary *methodInfo = @{SHARE_METHOD_INFO_KEY_ICON:[icons objectAtIndex:i],
                                     SHARE_METHOD_INFO_KEY_NAME:[names objectAtIndex:i]};
        [methods addObject:methodInfo];
    }
    return methods;
}

#pragma mark others
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
