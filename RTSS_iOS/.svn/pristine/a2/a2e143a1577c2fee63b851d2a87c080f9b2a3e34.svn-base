//
//  BudgetHistoryViewController.m
//  RTSS
//
//  Created by 加富董 on 15/1/18.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "BudgetHistoryViewController.h"
#import "DateUtils.h"
#import "BudgetHistoryCell.h"
#import "PortraitImageView.h"
#import "Cache.h"

#define HISTORY_HEADER_PADDING_X_LEFT 11.0
#define HISTORY_HEADER_PADDING_X_RIGHT 11.0
#define HISTORY_HEADER_USAGE_SPACE_X 5.0
#define HISTORY_HEADER_GROUP_NAME_SPACE_Y 5.0
#define HISTORY_HEADER_DATE_SPACE_X 5.0

#define HISTORY_HEADER_DATE_WIDTH 100.0
#define HISTORY_HEADER_DATE_HEIGHT 24.0
#define HISTORY_HEADER_DATE_CORNER_RADIUS 6.0
#define HISTORY_HEADER_DATE_FONT_SIZE 14.0

#define HISTORY_HEADER_GROUP_NAME_FONT_SIZE 16.0
#define HISTORY_HEADER_GROUP_NAME_DEFAULT_HEIGHT 17.0
#define HISTORY_HEADER_GROUP_NAME_OFFSET_Y 20.0

#define HISTORY_HEADER_GROUP_USAGE_FONT_SIZE 16.0
#define HISTORY_HEADER_GROUP_USAGE_DEFAULT_HEIGHT 17.0

#define HISTORY_HEADER_HEIGHT 80.0
#define HISTORY_CELL_HEIGHT 50.0

#define HISTORY_FOOTER_HEIGHT 125.0
#define HISTORY_FOOTER_BUTTON_OFFSET_Y 60.0
#define HISTORY_FOOTER_BUTTON_HEIGHT 43.0
#define HISTORY_FOOTER_BUTTON_CORNER_RADIUS 6.0
#define HISTORY_FOOTER_VIEW_PADDING_X 60.0

@implementation BudgetHistoryModel

@synthesize imageUrl;
@synthesize nameNumStr;
@synthesize usageStr;
@synthesize percent;

- (void)dealloc {
    self.imageUrl = nil;
    self.nameNumStr = nil;
    self.usageStr = nil;
    [super dealloc];
}

@end


@interface BudgetHistoryHeaderView : UIView

@property (nonatomic, retain)UIButton *dateButton;
@property (nonatomic, retain)UILabel *groupNameLabel;
@property (nonatomic, retain)UILabel *usageLabel;

@end

@implementation BudgetHistoryHeaderView

@synthesize dateButton;
@synthesize groupNameLabel;
@synthesize usageLabel;

#pragma mark dealloc
- (void)dealloc {
    [super dealloc];
}

#pragma mark init
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initViews];
    }
    return self;
}

#pragma mark init views
- (void)initViews {
    //date button
    CGRect dateRect = CGRectMake(HISTORY_HEADER_PADDING_X_LEFT, (CGRectGetHeight(self.frame) - HISTORY_HEADER_DATE_HEIGHT - SEPERATOR_LINE_HEIGHT) / 2.0, HISTORY_HEADER_DATE_WIDTH, HISTORY_HEADER_DATE_HEIGHT);
    dateButton = [CommonUtils buttonWithType:UIButtonTypeCustom frame:dateRect title:nil colorNormal:[[RTSSAppStyle currentAppStyle] viewControllerBgColor] colorHighlighted:nil colorSelected:nil addTarget:nil action:nil tag:0];
    [dateButton setTitleColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] forState:UIControlStateNormal];
    dateButton.titleLabel.font = [UIFont systemFontOfSize:HISTORY_HEADER_DATE_FONT_SIZE];
    dateButton.layer.borderColor = [[RTSSAppStyle currentAppStyle] textFieldBorderColor].CGColor;
    dateButton.layer.borderWidth = 1.0;
    dateButton.layer.cornerRadius = HISTORY_HEADER_DATE_CORNER_RADIUS;
    dateButton.layer.masksToBounds = YES;
    [self addSubview:dateButton];
    
    CGFloat remainWidth = CGRectGetWidth(self.frame) - HISTORY_HEADER_PADDING_X_LEFT - HISTORY_HEADER_DATE_WIDTH - HISTORY_HEADER_DATE_SPACE_X - HISTORY_HEADER_PADDING_X_RIGHT;
    
    //name
    CGRect nameRect = CGRectMake(CGRectGetMaxX(dateButton.frame) + HISTORY_HEADER_DATE_SPACE_X, HISTORY_HEADER_GROUP_NAME_OFFSET_Y, remainWidth, HISTORY_HEADER_GROUP_NAME_DEFAULT_HEIGHT);
    groupNameLabel = [CommonUtils labelWithFrame:nameRect text:nil textColor:[[RTSSAppStyle currentAppStyle] textMajorColor] textFont:[RTSSAppStyle getRTSSFontWithSize:HISTORY_HEADER_GROUP_NAME_FONT_SIZE] tag:0];
    groupNameLabel.textAlignment = NSTextAlignmentRight;
    groupNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:groupNameLabel];
    
    
    //usage
    CGRect usageRect = CGRectMake(CGRectGetMinX(groupNameLabel.frame), CGRectGetMaxY(groupNameLabel.frame) + HISTORY_HEADER_GROUP_NAME_SPACE_Y, remainWidth, HISTORY_HEADER_GROUP_USAGE_DEFAULT_HEIGHT);
    usageLabel = [CommonUtils labelWithFrame:usageRect text:nil textColor:[[RTSSAppStyle currentAppStyle] textMajorColor] textFont:[RTSSAppStyle getRTSSFontWithSize:HISTORY_HEADER_GROUP_NAME_FONT_SIZE] tag:0];
    usageLabel.textAlignment = NSTextAlignmentRight;
    usageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:usageLabel];
    
    //seperator line
    CGRect lineRect = CGRectMake(0.0, CGRectGetHeight(self.frame) - SEPERATOR_LINE_HEIGHT, PHONE_UISCREEN_WIDTH, SEPERATOR_LINE_HEIGHT);
    UIImageView *sepImageView = [[UIImageView alloc] initWithFrame:lineRect];
    sepImageView.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [self addSubview:sepImageView];
    [sepImageView release];
}

@end




@interface BudgetHistoryViewController () <UITableViewDataSource, UITableViewDelegate>{
    UIView *contentView;
    UIView *footerView;
    UITableView *historyTableView;
    UIButton *addMoreButton;
    BudgetHistoryHeaderView *headerView;
}

@property (nonatomic, retain)NSMutableArray *historyArray;

@end

@implementation BudgetHistoryViewController

@synthesize historyMainType;
@synthesize historySubType;
@synthesize historyArray;

#pragma mark dealloc
- (void)dealloc {
    [contentView release];
    [headerView release];
    [footerView release];
    [historyTableView release];
    [historyArray release];
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

#pragma mark load view
- (void)loadNavBarView {
    self.view.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    navigationBarView = [self addNavigationBarView:NSLocalizedString(@"Budget_History_Title", nil) bgColor:[[RTSSAppStyle currentAppStyle] navigationBarColor] separator:YES];
    [self.view addSubview:navigationBarView];
}

- (void)loadContentView {
    CGRect contentRect = CGRectMake(0.0, CGRectGetMaxY(navigationBarView.frame), PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT - CGRectGetMaxY(navigationBarView.frame));
    contentView = [[UIView alloc] initWithFrame:contentRect];
    contentView.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    [self.view addSubview:contentView];
    
    [self loadTableView];
    [self loadHeaderView];
    if (self.historyMainType == HistoryMainTypeCreate) {
        [self loadFooterView];
    }
}

- (void)loadTableView {
    if (historyTableView == nil) {
        CGRect tableRect = CGRectMake(0.0, 0.0, PHONE_UISCREEN_WIDTH, CGRectGetHeight(contentView.frame));
        historyTableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
        historyTableView.backgroundColor = [UIColor clearColor];
        historyTableView.delegate = self;
        historyTableView.dataSource = self;
        historyTableView.rowHeight = HISTORY_CELL_HEIGHT;
        historyTableView.showsHorizontalScrollIndicator = NO;
        historyTableView.showsVerticalScrollIndicator = NO;
        historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        historyTableView.allowsSelection = NO;
        [contentView addSubview:historyTableView];
    }
}

- (void)loadHeaderView {
    if (headerView == nil) {
        CGRect headerRect = CGRectMake(0.0, 0.0, PHONE_UISCREEN_WIDTH, HISTORY_HEADER_HEIGHT);
        headerView = [[BudgetHistoryHeaderView alloc] initWithFrame:headerRect];
        headerView.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
    }
    historyTableView.tableHeaderView = headerView;
}

- (void)loadFooterView {
    if (footerView == nil) {
        CGRect footerRect = CGRectMake(0.0, 0.0, PHONE_UISCREEN_WIDTH, HISTORY_FOOTER_HEIGHT);
        footerView = [[UIView alloc] initWithFrame:footerRect];
        footerView.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
        
        //add more
        CGRect moreButtonRect = CGRectMake(HISTORY_FOOTER_VIEW_PADDING_X, HISTORY_FOOTER_BUTTON_OFFSET_Y, CGRectGetWidth(footerView.frame) - HISTORY_FOOTER_VIEW_PADDING_X * 2.0, HISTORY_FOOTER_BUTTON_HEIGHT);
        addMoreButton = [CommonUtils buttonWithType:UIButtonTypeCustom frame:moreButtonRect title:NSLocalizedString(@"Budget_History_Add_More_Title", nil) colorNormal:[[RTSSAppStyle currentAppStyle] commonGreenButtonNormalColor] colorHighlighted:nil colorSelected:nil addTarget:self action:@selector(addMoreButtonClicked:) tag:0];
        addMoreButton.layer.cornerRadius = HISTORY_FOOTER_BUTTON_CORNER_RADIUS;
        addMoreButton.layer.masksToBounds = YES;
        [footerView addSubview:addMoreButton];
    }
    historyTableView.tableFooterView = footerView;
}

#pragma mark layout views
- (void)layoutHeaderViews {
    //date
    NSString *dateFormat = @"MM/yyyy";
    NSString *dateStr = [DateUtils getStringDateByDate:[NSDate date] dateFormat:dateFormat];
    [headerView.dateButton setTitle:dateStr forState:UIControlStateNormal];
    
    //name
    NSString *groupName = @"John's family";
    headerView.groupNameLabel.text = groupName;
    
    //usage
    NSString *usageStr = @"Total:600MB/1000MB";
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:usageStr];
    NSRange titleRange = [usageStr rangeOfString:@"Total:"];
    NSRange valueRange = NSMakeRange(titleRange.length, usageStr.length - titleRange.length);
    [attributedStr setAttributes:@{NSForegroundColorAttributeName:[[RTSSAppStyle currentAppStyle] textMajorColor]} range:titleRange];
    [attributedStr setAttributes:@{NSForegroundColorAttributeName:[[RTSSAppStyle currentAppStyle] textMajorGreenColor]} range:valueRange];
    headerView.usageLabel.attributedText = attributedStr;
    [attributedStr release];
}


#pragma mark table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [historyArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return HISTORY_CELL_HEIGHT;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return nil;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"historyCell";
    BudgetHistoryCell *historyCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (historyCell == nil) {
        historyCell = [[[BudgetHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId availableSize:CGSizeMake(PHONE_UISCREEN_WIDTH, HISTORY_CELL_HEIGHT)] autorelease];
        [self setBgStyle:historyCell];
    }
    BudgetHistoryModel *model = [historyArray objectAtIndex:indexPath.row];
    [self layoutHistoryCell:historyCell withData:model];
    return historyCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)layoutHistoryCell:(BudgetHistoryCell *)historyCell withData:(BudgetHistoryModel *)historyModel {
    if (historyCell && historyModel) {
        //portrait
        historyCell.memberPortraitImageView.portraitImage = [[Cache standardCache] getSmallPortraitImageWithUrl:historyModel.imageUrl placeHolderImageName:@"friends_default_icon" completion:^ (UIImage *image) {
            historyCell.memberPortraitImageView.portraitImage = image;
        }];
        
        //name num
        historyCell.memberNameNumLabel.text = historyModel.nameNumStr;
        
        //usage
        historyCell.memberUsageLabel.text = historyModel.usageStr;
        
        //progress
        
        historyCell.memberProgressView.progress = historyModel.percent;
    }
}

#pragma mark tools method
- (void)setBgStyle:(BudgetHistoryCell *)cell {
    //normal
    UIView *unselectedView = [[UIView alloc] initWithFrame:cell.frame];
    unselectedView.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    cell.backgroundView = unselectedView;
    [unselectedView release];
    
    //selected
    UIView *selectedView = [[UIView alloc] initWithFrame:cell.frame];
    selectedView.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
    cell.selectedBackgroundView = selectedView;
    [selectedView release];
}

#pragma mark button clicked
- (void)addMoreButtonClicked:(UIButton *)button {
    
}

#pragma mark load data
- (void)loadData {
    self.historyArray = [self fakeData];
    [self layoutHeaderViews];
//    self.historyArray = [[NSMutableArray alloc] initWithCapacity:0];
//    [self loadHistoryData];
}

- (void)loadHistoryData {
    
}

- (NSMutableArray *)fakeData {
    NSMutableArray *dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *names = @[@"John 700651520",@"Tom 700651521",@"Kite 700651522",@"Jim 700651523",@"Paul 700651524"];
    NSArray *usages = @[@"56MB/100MB",@"70MB/100MB",@"20MB/50MB",@"50MB/50MB",@"100MB/100MB",@"70MB/100MB"];
    NSArray *percent = @[@0.56,@0.7,@0.4,@1.0,@1.0,@0.7];
    for (int i = 0; i < 5; i ++) {
        BudgetHistoryModel *history = [[BudgetHistoryModel alloc] init];
        history.imageUrl = nil;
        history.nameNumStr = [names objectAtIndex:i];
        history.usageStr = [usages objectAtIndex:i];
        history.percent = [[percent objectAtIndex:i] floatValue];
        [dataArr addObject:history];
    }
    return [dataArr autorelease];
}

@end
