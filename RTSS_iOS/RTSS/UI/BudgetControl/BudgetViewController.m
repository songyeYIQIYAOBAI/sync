//
//  BudgetViewController.m
//  RTSS
//
//  Created by 加富董 on 15/1/16.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "BudgetViewController.h"
#import "RTSSAppStyle.h"
#import "BudgetCreateViewController.h"
#import "BudgetJoinViewController.h"
#import "BudgetManageViewController.h"
#import "BudgetHistoryViewController.h"
#import "PortraitImageView.h"
#import "BudgetGroupAbstractCell.h"
#import "Cache.h"
#import "BudgetGroup.h"
#import "Subscriber.h"
#import "MappActor.h"
#import "Session.h"
#import "RTSSNotificationCenter.h"

#define GROUP_TABLE_CELL_HEIGHT 70.0
#define GROUP_TABLE_SECTION_HEADER_HEIGHT 40.0

#define GROUP_TABLE_SECTION_HEADER_PADDING_X_LEFT 10.0
#define GROUP_TABLE_SECTION_HEADER_PADDING_X_RIGHT 16.0
#define GROUP_TABLE_SECTION_HEADER_FONT_SIZE 14.0
#define GROUP_TABLE_SECTION_HEADER_BUTTON_WIDTH 22.0
#define GROUP_TABLE_SECTION_HEADER_BUTTON_HEIGHT 22.0

#define GROUPS_HAVE_CREATED @"created"
#define GROUPS_HAVE_JOINED @"joined"

@interface BudgetViewController () <UITableViewDataSource, UITableViewDelegate, BudgetGroupAbstractCellDelegate, MappActorDelegate> {
    UITableView *groupTableView;
    BOOL needRefresh;
}

@property (nonatomic, retain) NSMutableDictionary *groupsDict;

@end

@implementation BudgetViewController

@synthesize groupsDict;

#pragma mark dealloc
- (void)dealloc {
    [self removeNotification];
    [groupTableView release];
    [groupsDict release];
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
    needRefresh = YES;
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
    needRefresh = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark load view
- (void)loadNavBarView {
    self.view.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    navigationBarView = [self addNavigationBarView:NSLocalizedString(@"Budget_Home_Title", nil) bgColor:[[RTSSAppStyle currentAppStyle] viewControllerBgColor] separator:YES];
    [self.view addSubview:navigationBarView];
}

- (void)loadContentView {
    //group table
    CGRect tableRect = CGRectMake(0.0, CGRectGetMaxY(navigationBarView.frame), PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT - CGRectGetMaxY(navigationBarView.frame));
    groupTableView = [[UITableView alloc] initWithFrame:tableRect];
    groupTableView.backgroundColor = [UIColor clearColor];
    groupTableView.showsHorizontalScrollIndicator = NO;
    groupTableView.showsVerticalScrollIndicator = NO;
    groupTableView.rowHeight = GROUP_TABLE_CELL_HEIGHT;
    groupTableView.delegate = self;
    groupTableView.dataSource = self;
    groupTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:groupTableView];
}

#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowsNum = 0;
    if (section == 0) {
        NSMutableArray *createdArr = [groupsDict objectForKey:GROUPS_HAVE_CREATED];
        if ([CommonUtils objectIsValid:createdArr]) {
            rowsNum = [createdArr count];
        }
    } else if (section == 1) {
        NSMutableArray *joinedArr = [groupsDict objectForKey:GROUPS_HAVE_JOINED];
        if ([CommonUtils objectIsValid:joinedArr]) {
            rowsNum = [joinedArr count];
        }
    }
    return rowsNum;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = nil;
    headerView = [self createSectionHeaderViewByGroupType:[self convertGroupTypeFromSectionIndex:section]];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return GROUP_TABLE_CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return GROUP_TABLE_SECTION_HEADER_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"groupCell";
    BudgetGroupAbstractCell *groupCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (groupCell == nil) {
        groupCell = [[[BudgetGroupAbstractCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier availableSize:CGSizeMake(PHONE_UISCREEN_WIDTH, GROUP_TABLE_CELL_HEIGHT)] autorelease];
        groupCell.delegate = self;
        groupCell.backgroundColor = [UIColor clearColor];
        [self setBgStyle:groupCell];
    }
    groupCell.cellIndexPath = indexPath;
    BudgetGroup *groupData = [self getGroupDataByIndexPath:indexPath];
    if (groupData) {
        [self layoutGroupCell:groupCell indexPath:indexPath ByGroupData:groupData];
    }
    return groupCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BudgetGroup *group = [self getGroupDataByIndexPath:indexPath];
    if (group) {
        GroupType type = [self convertGroupTypeFromSectionIndex:indexPath.section];
        NSLog(@"clicked cell of %@",group.mGroupName);
        BudgetManageViewController *manageVC = [[BudgetManageViewController alloc] init];
        manageVC.groupType = type;
        manageVC.curGroup = group;
        [self.navigationController pushViewController:manageVC animated:YES];
        [manageVC release];
    }
}

#pragma mark --helper
- (BudgetGroup *)getGroupDataByIndexPath:(NSIndexPath *)indexPath {
    BudgetGroup *group = nil;
    NSMutableArray *groups = nil;
    if (indexPath.section == 0) {
        groups = [groupsDict objectForKey:GROUPS_HAVE_CREATED];
    } else if (indexPath.section == 1) {
        groups = [groupsDict objectForKey:GROUPS_HAVE_JOINED];
    }
    if ([CommonUtils objectIsValid:groups]) {
        @try {
            group = [groups objectAtIndex:indexPath.row];
        }
        @catch (NSException *exception) {
            NSLog(@"getGroupDataByIndexPath throw exception == %@",exception);
        }
    }
    return group;
}

- (UIView *)createSectionHeaderViewByGroupType:(GroupType)type {
    CGRect headerRect = CGRectMake(0., 0., PHONE_UISCREEN_WIDTH, GROUP_TABLE_SECTION_HEADER_HEIGHT);
    UIView *headerView = [[UIView alloc] initWithFrame:headerRect];
    headerView.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
    
    //type label
    CGRect labelRect = CGRectMake(GROUP_TABLE_SECTION_HEADER_PADDING_X_LEFT, 0., PHONE_UISCREEN_WIDTH - GROUP_TABLE_SECTION_HEADER_PADDING_X_LEFT - GROUP_TABLE_SECTION_HEADER_PADDING_X_RIGHT - GROUP_TABLE_SECTION_HEADER_BUTTON_WIDTH - 5.0, GROUP_TABLE_SECTION_HEADER_HEIGHT - SEPERATOR_LINE_HEIGHT);
    UILabel *typeLabel = [CommonUtils labelWithFrame:labelRect text:(type == GroupTypeCreated ? NSLocalizedString(@"Budget_Home_I_Have_Created", nil) : NSLocalizedString(@"Budget_Home_I_Have_Joined", nil)) textColor:[[RTSSAppStyle currentAppStyle] textMajorColor] textFont:[UIFont systemFontOfSize:GROUP_TABLE_SECTION_HEADER_FONT_SIZE] tag:0];
    typeLabel.backgroundColor = [UIColor clearColor];
    typeLabel.textAlignment = NSTextAlignmentLeft;
    typeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [headerView addSubview:typeLabel];
    
    //create button
    CGRect buttonRect = CGRectMake(PHONE_UISCREEN_WIDTH - GROUP_TABLE_SECTION_HEADER_PADDING_X_RIGHT - GROUP_TABLE_SECTION_HEADER_BUTTON_WIDTH, (GROUP_TABLE_SECTION_HEADER_HEIGHT - GROUP_TABLE_SECTION_HEADER_BUTTON_HEIGHT - SEPERATOR_LINE_HEIGHT) / 2.0, GROUP_TABLE_SECTION_HEADER_BUTTON_WIDTH, GROUP_TABLE_SECTION_HEADER_BUTTON_HEIGHT);
    UIButton *createButton = [CommonUtils buttonWithType:UIButtonTypeCustom frame:buttonRect title:nil imageNormal:[UIImage imageNamed:@"budget_group_create_join"] imageHighlighted:nil imageSelected:nil addTarget:self action:@selector(createButtonClicked:) tag:type];
    [headerView addSubview:createButton];
    
    //seperator line
    CGRect seperatorRect = CGRectMake(0.0, GROUP_TABLE_SECTION_HEADER_HEIGHT - SEPERATOR_LINE_HEIGHT, PHONE_UISCREEN_WIDTH, SEPERATOR_LINE_HEIGHT);
    UIImageView *seperatorLine = [[UIImageView alloc] initWithFrame:seperatorRect];
    seperatorLine.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [headerView addSubview:seperatorLine];
    [seperatorLine release];
    
    return [headerView autorelease];
}

- (void)setBgStyle:(UITableViewCell *)cell {
    UIView *selectedView = [[UIView alloc] initWithFrame:cell.frame];
    selectedView.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
    cell.selectedBackgroundView = selectedView;
    [selectedView release];
    
    UIView *unselectedView = [[UIView alloc] initWithFrame:cell.frame];
    unselectedView.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    cell.backgroundView = unselectedView;
    [unselectedView release];
    
}

- (void)layoutGroupCell:(BudgetGroupAbstractCell *)cell indexPath:(NSIndexPath *)indexPath ByGroupData:(BudgetGroup *)data {
    //index path
    cell.cellIndexPath = indexPath;
    
    //image
    cell.groupImageView.portraitImage = [[Cache standardCache] getSmallPortraitImageWithUrl:data.mIcon placeHolderImageName:@"friends_add_friend_icon" completion:^ (UIImage *image) {
        if (needRefresh) {
            cell.groupImageView.portraitImage = image;
        }
    }];
    
    //name
    cell.groupNameLabel.text = data.mGroupName;
    
}

- (GroupType)convertGroupTypeFromSectionIndex:(NSInteger)sectionIndex {
    GroupType type = GroupTypeCreated;
    if (sectionIndex == 0) {
        type = GroupTypeCreated;
    } else if (sectionIndex == 1) {
        type = GroupTypeJoined;
    }
    return type;
}

#pragma mark budget cell delegate
- (void)budgetGroupAbstractCellHistoryButtonDidClicked:(BudgetGroupAbstractCell *)groupCell {
    //temp暂时不跳转
//    NSIndexPath *indexPath = groupCell.cellIndexPath;
//    if (indexPath) {
//        BudgetGroup *group = [self getGroupDataByIndexPath:indexPath];
//        if (group) {
//            GroupType type = [self convertGroupTypeFromSectionIndex:indexPath.section];
//            NSLog(@"clicked history of %@",group.mGroupName);
//            BudgetHistoryViewController *historyVC = [[BudgetHistoryViewController alloc] init];
//            if (type == GroupTypeCreated) {
//                historyVC.historyMainType = HistoryMainTypeCreate;
//            } else {
//                historyVC.historyMainType = HistoryMainTypeJoin;
//            }
//            historyVC.historySubType = HistorySubTypeUsage;
//            [self.navigationController pushViewController:historyVC animated:YES];
//            [historyVC release];
//        }
//    }
}



- (void)classifyGroups:(NSArray *)groupsArray {
    if ([CommonUtils objectIsValid:groupsArray]) {
        
        NSMutableArray *createdArray = [self.groupsDict objectForKey:GROUPS_HAVE_CREATED];
        if (createdArray == nil) {
            createdArray = [[NSMutableArray alloc] initWithCapacity:0];
            [self.groupsDict setObject:createdArray forKeyedSubscript:GROUPS_HAVE_CREATED];
            [createdArray release];
        }

        NSMutableArray *joinedArray = [self.groupsDict objectForKey:GROUPS_HAVE_JOINED];
        if (joinedArray == nil) {
            joinedArray = [[NSMutableArray alloc] initWithCapacity:0];
            [self.groupsDict setObject:joinedArray forKeyedSubscript:GROUPS_HAVE_JOINED];
            [joinedArray release];
        }
        
        //clean
        [createdArray removeAllObjects];
        [joinedArray removeAllObjects];
        
        for (BudgetGroup *group in groupsArray) {
            NSString *groupId = group.mOwnerId;
            NSString *myGroupId = nil;
            Session *session = [Session sharedSession];
            Subscriber *sub = session.mCurrentSubscriber;
            if (sub) {
                myGroupId = sub.mId;
            }
            if ([CommonUtils objectIsValid:groupId] && [CommonUtils objectIsValid:myGroupId]) {
                if ([groupId isEqualToString:myGroupId]) {
                    [createdArray addObject:group];
                } else {
                    [joinedArray addObject:group];
                }
            }
        }
    }
}

#pragma mark button action
- (void)createButtonClicked:(UIButton *)createButton {
    //register notify
    [self registerNotification];
    
    NSInteger tag = createButton.tag;
    if (tag == GroupTypeCreated) {
        NSLog(@"CREATE");
        BudgetCreateViewController *createVC = [[BudgetCreateViewController alloc] init];
        [self.navigationController pushViewController:createVC animated:YES];
        [createVC release];
    } else if (tag == GroupTypeJoined) {
        BudgetJoinViewController *joinVC = [[BudgetJoinViewController alloc] init];
        [self.navigationController pushViewController:joinVC animated:YES];
        [joinVC release];
        NSLog(@"JOIN");
    }
}

#pragma mark notification method
- (void)registerNotification {
    [[RTSSNotificationCenter standardRTSSNotificationCenter] addNotificationWithType:RTSSNotificationTypeBudgetGroupList observer:self selector:@selector(refreshBudgetGroupsData:) object:nil];
}

- (void)removeNotification {
    [[RTSSNotificationCenter standardRTSSNotificationCenter] removeNotificationWithType:RTSSNotificationTypeBudgetGroupList observer:self object:nil];
}

- (void)refreshBudgetGroupsData:(NSNotification *)notify {
    [self loadGroupsData];
}

#pragma mark load data
- (void)loadData {
    self.groupsDict = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    [self loadGroupsData];
}

- (void)loadGroupsData {
//    Session *session = [Session sharedSession];
//    Subscriber *curSubscriber = session.mCurrentSubscriber;
//    if (curSubscriber) {
//        NSArray *groups = curSubscriber.mBudgetGroups;
//        if ([CommonUtils objectIsValid:groups]) {
//            [self classifyGroups:groups];
//            [groupTableView reloadData];
//        }
//    }
}


#pragma mark mapp actor delegate
//- (void)syncSubscriberFinished:(NSInteger)status {
//    if (status == MappActorFinishStatusOK) {
//        Session *currentSeesion = [Session sharedSession];
//        Subscriber *sub = currentSeesion.mCurrentSubscriber;
//        if (sub) {
//            NSArray *groups = sub.mBudgetGroups;
//            if ([CommonUtils objectIsValid:groups]) {
//                [self classifyGroups:groups];
//                [groupTableView reloadData];
//            }
//        }
//    }
//}
#pragma mark others
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
