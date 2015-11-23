//
//  FriendsViewController.m
//  RTSS
//
//  Created by dongjf on 14/10/23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "FriendsViewController.h"

#import "MaskView.h"
#import "ChineseToPinyin.h"
#import "TransactionHistoryViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ImageUtils.h"
#import "User.h"
#import "FriendCell.h"
#import "QuickTransferCell.h"
#import "Friends.h"
#import "Cache.h"
#import "PortraitImageView.h"

#define SEARCH_BAR_HEIGHT 40.f
#define FRIENDS_TABLE_CELL_HEIGHT  55.f
#define FRIENDS_MASK_VIEW_TAG 1000
#define RESULT_MASK_VIEW_TAG 2000
#define PROMPT_LABEL_HEIGHT 25.f
#define PROMPT_LABEL_OFFSET_Y 70.f

typedef NS_ENUM(NSInteger, AlertViewStyle) {
    AlertViewStyleAddInfoIllegal,
    AlertViewStyleSearchNoResult,
    AlertViewStyleDelete,
};

@interface FriendsViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,ABPeoplePickerNavigationControllerDelegate,AlertControllerDelegate> {
    //friends
    NSMutableDictionary *indexedData;
    NSMutableArray *indexTitles;
    UITableView *friendsTable;
    //results
    NSMutableDictionary *resIndexdData;
    NSMutableArray *resIndexTitles;
    UITableView *resultTable;
    //search bar
    UISearchBar *searchArea;
    
    //标记异步加载的图片是否需要
    BOOL needRefresh;
    UIView *statusBarView;
}

@property (nonatomic,retain) NSIndexPath *currentDeleteIndexPath;

@end

@implementation FriendsViewController

@synthesize currentDeleteIndexPath;
@synthesize actionType;
@synthesize transferFriendInfoBlock;

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark delloc
- (void) dealloc {
    [indexedData release];
    [indexTitles release];
    friendsTable.editing = NO;
    [friendsTable release];
    if (resultTable) {
        [resIndexdData release];
        [resIndexTitles release];
        [resultTable release];
    }
    [searchArea release];
    [currentDeleteIndexPath release];
    if (transferFriendInfoBlock) {
        [transferFriendInfoBlock release];
    }
    [statusBarView release];
    [super dealloc];
}

#pragma mark life cycle method
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    needRefresh = YES;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    needRefresh = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentDeleteIndexPath = nil;
    [friendsTable reloadData];
}

#pragma mark load views
- (void)loadView {
    [super loadView];
    //status bar view
    statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, PHONE_UISCREEN_HEIGHT, 20.0)];
    statusBarView.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
    [self.view addSubview:statusBarView];
    
    //nav
    navigationBarView = [self addNavigationBarView:NSLocalizedString(@"Friends_Title", nil) bgColor:[[RTSSAppStyle currentAppStyle] navigationBarColor] separator:YES];
    [self.view addSubview:navigationBarView];
    
    //search bar
    UIView *searchBgView = [[UIView alloc] initWithFrame:CGRectMake(0.f, CGRectGetMaxY(navigationBarView.frame), PHONE_UISCREEN_WIDTH, SEARCH_BAR_HEIGHT)];
    searchBgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:searchBgView];
    
    searchArea = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(navigationBarView.frame), PHONE_UISCREEN_WIDTH, SEARCH_BAR_HEIGHT)];
    searchArea.showsCancelButton = NO;
    searchArea.delegate = self;
    searchArea.placeholder = NSLocalizedString(@"Friends_Search_Holder", nil);
    [searchArea setSearchTextPositionAdjustment:UIOffsetZero];
    UITextField* searchField = [searchArea valueForKey:@"_searchField"];
    searchField.textColor = [[RTSSAppStyle currentAppStyle] textMajorColor];
    searchField.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
    searchField.layer.cornerRadius = 5.f;
    searchField.layer.borderWidth = 1.f;
    searchField.layer.borderColor = [[RTSSAppStyle currentAppStyle] textFieldBorderColor].CGColor;
    searchArea.backgroundImage = [ImageUtils createImageWithColor:[[RTSSAppStyle currentAppStyle] viewControllerBgColor] size:CGSizeMake(1, 1)];
    [self.view addSubview:searchArea];
    
    //seperator line
    UIImageView *seperatorLine = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, CGRectGetMaxY(searchArea.frame), PHONE_UISCREEN_WIDTH, 1.f)];
    seperatorLine.backgroundColor = [[RTSSAppStyle currentAppStyle] separatorColor];
    [self.view addSubview:seperatorLine];
    [seperatorLine release];
    
    //friends table
    friendsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(seperatorLine.frame), PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT - 64.f - CGRectGetHeight(searchArea.frame) - CGRectGetHeight(seperatorLine.frame))  style:UITableViewStylePlain];
    friendsTable.backgroundColor = [UIColor clearColor];
    friendsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    friendsTable.rowHeight = FRIENDS_TABLE_CELL_HEIGHT;
    friendsTable.sectionHeaderHeight = 22;
    friendsTable.showsVerticalScrollIndicator = NO;
    friendsTable.sectionIndexColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
    friendsTable.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    if (SYSTEM_VERSION_IOS7) {
        friendsTable.sectionIndexBackgroundColor = [UIColor clearColor];
    }
    friendsTable.dataSource = self;
    friendsTable.delegate = self;
    friendsTable.tag = 100;
    [self.view addSubview:friendsTable];
    
}

- (void) loadResultTable {
    //result table
    if (!resultTable) {
        resultTable = [[UITableView alloc] initWithFrame:friendsTable.frame];
        resultTable.backgroundColor = [UIColor clearColor];
        resultTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        resultTable.rowHeight = FRIENDS_TABLE_CELL_HEIGHT;
        resultTable.sectionHeaderHeight = 22.f;
        resultTable.showsVerticalScrollIndicator = NO;
        resultTable.dataSource = self;
        resultTable.delegate = self;
        resultTable.tag = 200;
        //data
        resIndexTitles = [[NSMutableArray alloc] initWithCapacity:0];
        resIndexdData = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    resultTable.hidden = YES;
    [self.view addSubview:resultTable];
    
    //mask
    [self addResultMaskView];
    
}

- (void) addResultMaskView {
    UIView *resultMaskView = [self.view viewWithTag:RESULT_MASK_VIEW_TAG];
    if (!resultMaskView) {
        MaskView *resultMask = [[MaskView alloc] initWithFrame:resultTable.frame];
        resultMask.tag = RESULT_MASK_VIEW_TAG;
        resultMask.hideBlock = ^ (MaskView *maskView) {
            if ([searchArea isFirstResponder]) {
                searchArea.showsCancelButton = NO;
                [searchArea resignFirstResponder];
            }
        };
        resultMask.backgroundColor = [UIColor clearColor];
        resultMask.hidden = resultTable.hidden;
        [self.view addSubview:resultMask];
        [resultMask release];
    } else {
        resultMaskView.hidden = resultTable.hidden;
        [self.view addSubview:resultMaskView];
    }
    
}

- (void) addFriendsMaskView {
    UIView *friendsMaskView = [self.view viewWithTag:FRIENDS_MASK_VIEW_TAG];
    if (!friendsMaskView) {
        //mask view
        CGRect maskFrame = friendsTable.frame;
        MaskView *maskView = [[MaskView alloc] initWithFrame:maskFrame];
        maskView.tag = FRIENDS_MASK_VIEW_TAG;
        maskView.hideBlock = ^(MaskView *view) {
            searchArea.showsCancelButton = NO;
            [searchArea resignFirstResponder];
        };
        maskView.hidden = friendsTable.hidden;
        [self.view addSubview:maskView];
        [maskView release];
    } else {
        friendsMaskView.hidden = friendsTable.hidden;
        [self.view addSubview:friendsMaskView];
    }
}

#pragma mark table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sectionCount = 0;
    if (tableView.tag == 100) {
        sectionCount = [indexTitles count] + 1;
    } else {
        sectionCount = [resIndexTitles count];
    }
    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowCount = 0;
    if (tableView.tag == 100) {
        if (0 == section) {
            rowCount = 1;
        } else {
            NSString* indexTitle = [indexTitles objectAtIndex:section - 1];
            NSArray* entries = [indexedData objectForKey:indexTitle];
            rowCount = [entries count];
        }
    } else {
        NSString *indexTitle = [resIndexTitles objectAtIndex:section];
        NSArray *entries = [resIndexdData objectForKey:indexTitle];
        rowCount = [entries count];
        
    }
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableCellIdentifier = @"FriendsTableCellIdentifier";
    static NSString *addCellIdentifier = @"addCellIdentifier";
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    UITableViewCell *cell = nil;
    if (0 == section && tableView.tag == 100) {
        CommonAddFriendsCell *addCell = [tableView dequeueReusableCellWithIdentifier:addCellIdentifier];
        if (addCell == nil) {
            addCell = [[[CommonAddFriendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addCellIdentifier availableSize:CGSizeMake(CGRectGetWidth(friendsTable.frame), FRIENDS_TABLE_CELL_HEIGHT)] autorelease];
            addCell.accessoryImageView.image = [UIImage imageNamed:@"common_next_arrow2"];
            addCell.portraitImageView.image = [UIImage imageNamed:@"friends_add_friend_icon"];
            [self setBgStyle:addCell];
        }
        addCell.messageLable.text = NSLocalizedString(@"Friends_Add_Friends_From_Mobile_Contact", nil);
        cell = (UITableViewCell *)addCell;
    } else {
        FriendCell *friendCell = [tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
        if (friendCell == nil) {
            friendCell = [[[FriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellIdentifier availableSize:CGSizeMake(CGRectGetWidth(friendsTable.frame), FRIENDS_TABLE_CELL_HEIGHT)] autorelease];
            friendCell.accessoryType = UITableViewCellAccessoryNone;
            [self setBgStyle:friendCell];
        }
        NSString *indexTitle = nil;
        NSArray *friends = nil;
        if (tableView.tag == 100) {
            indexTitle = [indexTitles objectAtIndex:section - 1];
            friends = [indexedData objectForKey:indexTitle];
        } else {
            indexTitle = [resIndexTitles objectAtIndex:section];
            friends = [resIndexdData objectForKey:indexTitle];
        }
        User *friend = [friends objectAtIndex:row];
        [self layoutFriendCell:friendCell byData:friend showSeperateLine:YES];
        cell = (UITableViewCell *)friendCell;
    }
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView.tag == 100) {
        return @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self getActualSectionIndexBySectionTitle:title] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    float height = 22;
    if (0 == section && tableView.tag == 100) {
        height = 0;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FRIENDS_TABLE_CELL_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView* header = nil;
    if (!(section == 0 && tableView.tag == 100)) {
        //bg view
        header = [(UITableViewHeaderFooterView*)[[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 22)] autorelease];
        header.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
        
        //text label
        UILabel* indexTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 30, 18)];
        indexTitleLabel.backgroundColor = [UIColor clearColor];
        indexTitleLabel.font = [RTSSAppStyle getRTSSFontWithSize:16.0];
        indexTitleLabel.textColor = [[RTSSAppStyle currentAppStyle] textSubordinateColor];
        NSString *title = nil;
        if (tableView.tag == 100) {
            title = [indexTitles objectAtIndex:section - 1];
        } else {
            title = [resIndexTitles objectAtIndex:section];
        }
        indexTitleLabel.text = title;
        [header addSubview:indexTitleLabel];
        [indexTitleLabel release];
        
        //seperator line
        UIImageView *seperatorLine = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, CGRectGetMaxY(header.frame) - 1.0, PHONE_UISCREEN_WIDTH, 1.f)];
        seperatorLine.backgroundColor = [[RTSSAppStyle currentAppStyle] separatorColor];
        [header addSubview:seperatorLine];
        [seperatorLine release];
    }
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    User *friend = nil;
    BOOL addFriends = NO;
    if (tableView.tag == 100) {
        //朋友列表
        if (section == 0) {
            addFriends = YES;
        } else {
            NSString *indexTitle = [indexTitles objectAtIndex:section - 1];
            if ([CommonUtils objectIsValid:indexTitle]) {
                NSArray *friends = [indexedData objectForKey:indexTitle];
                if ([CommonUtils objectIsValid:friends]) {
                    friend = [friends objectAtIndex:row];
                }
            }
        }
    } else {
        //搜索列表
        NSString *indexTitle = [resIndexTitles objectAtIndex:section];
        if ([CommonUtils objectIsValid:indexTitle]) {
            NSArray *friends = [resIndexdData objectForKey:indexTitle];
            if ([CommonUtils objectIsValid:friends]) {
                friend = [friends objectAtIndex:row];
            }
        }
    }
    if (addFriends) {
        if (indexPath.row == 0) {
            //从手机通讯录添加好友
            ABPeoplePickerNavigationController* picker = [[ABPeoplePickerNavigationController alloc] init];
            picker.peoplePickerDelegate = self;
            [self presentViewController:picker animated:YES completion:nil];
            [picker release];
        }
    } else {
        if (friend) {
            if (actionType == FriendsActionTypeDisplayHistory) {
                TransactionHistoryViewController *thvc = [[TransactionHistoryViewController alloc] init];
                thvc.currentUser = friend;
                [self.navigationController pushViewController:thvc animated:YES];
                [thvc release];
            } else if (actionType == FriendsActionTypePickFriends && transferFriendInfoBlock) {
                transferFriendInfoBlock(friend);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 100 && indexPath.section != 0) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 100 && editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *indexTitle = [indexTitles objectAtIndex:indexPath.section - 1];
        if ([CommonUtils objectIsValid:indexTitle]) {
            NSMutableArray *tempFriendsArray = [indexedData objectForKey:indexTitle];
            if ([CommonUtils objectIsValid:tempFriendsArray]) {
                self.currentDeleteIndexPath = indexPath;
                //show alert
                AlertController *alert = [[AlertController alloc] initWithTitle:nil message:NSLocalizedString(@"Friends_Delete_Message", nil) delegate:self tag:AlertViewStyleDelete cancelButtonTitle:NSLocalizedString(@"UIAlertView_Cancel_String", nil) otherButtonTitles:NSLocalizedString(@"UIAlertView_Confirm_String", nil), nil];
                [alert showInViewController:self];
                [alert release];
            }
        }
    }
}

- (void) setBgStyle:(UITableViewCell *)cell {
    UIView *unselectedView = [[UIView alloc] init];
    unselectedView.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
    cell.backgroundView = unselectedView;
    [unselectedView release];
    
    UIView *selectedView = [[UIView alloc] init];
    selectedView.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    cell.selectedBackgroundView = selectedView;
    [selectedView release];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0.0, FRIENDS_TABLE_CELL_HEIGHT - 1.0, CGRectGetWidth(cell.frame), 1.0)];
    line.backgroundColor = [[RTSSAppStyle currentAppStyle] separatorColor];
    [selectedView addSubview:line];
    [line release];
}

- (void)layoutFriendCell:(FriendCell *)friendCell byData:(User *)friendData showSeperateLine:(BOOL)show {
    if (!friendData) {
        return;
    }
    
    //portrait
    friendCell.friendPortraitImageView.portraitImage = [[Cache standardCache] getSmallPortraitImageWithUrl:friendData.mPortrait completion:^ (UIImage *image) {
        if (needRefresh) {
            friendCell.friendPortraitImageView.portraitImage = image;
        }
    }];
    
    //name
    friendCell.friendNameLabel.text = friendData.mName;
    
    //seperator line
    friendCell.seperatorLineImageView.hidden = show ? NO : YES;
}

- (NSInteger)getActualSectionIndexBySectionTitle:(NSString *)sectionTitle {
    NSInteger sectionIndex = 26;
    for (NSInteger index = 0; index < [indexTitles count]; index ++) {
        NSString *indexTitle = [indexTitles objectAtIndex:index];
        if ([indexTitle isEqualToString:sectionTitle]) {
            sectionIndex = index;
            break;
        }
    }
    return sectionIndex;
}

#pragma mark people picker delegate
- (void)pickUpPeopleInfoFromController:(ABPeoplePickerNavigationController *)peoplePicker selectedPerson:(ABRecordRef)person property:(ABPropertyID)property inentifier:(ABMultiValueIdentifier)identifier {
    NSString* name = nil;
    NSString* phoneNum = nil;
    if (property == kABPersonPhoneProperty) {
        
        CFStringRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFStringRef middleName = ABRecordCopyValue(person, kABPersonMiddleNameProperty);
        CFStringRef lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        
        name = [[NSString alloc] initWithFormat:@"%@%@%@",firstName ? (NSString *)firstName : @"",middleName ? (NSString *)middleName : @"",lastName ? (NSString *)lastName : @""];
        
        if (firstName) {
            CFRelease(firstName);
        }
        if (middleName) {
            CFRelease(middleName);
        }
        if (lastName) {
            CFRelease(lastName);
        }
        
        ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, property);
        CFIndex index = ABMultiValueGetIndexForIdentifier(phoneMulti,identifier);
        CFStringRef phone = ABMultiValueCopyValueAtIndex(phoneMulti, index);
        CFRelease(phoneMulti);
        
        phone = (CFStringRef)[(NSString *)phone stringByReplacingOccurrencesOfString:@"[^\\d]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0,[(NSString *)phone length])];
        phoneNum = (NSString *)phone;
    }
    if ([CommonUtils objectIsValid:phoneNum]) {
        if (![CommonUtils objectIsValid:name]) {
            if (name) {
                [name release];
                name = [phoneNum copy];
            }
        }
        [self createAndInsertNewFriendsByPhoneNum:phoneNum name:name];
        [friendsTable reloadData];
        if (name) {
            [name release];
        }
        [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    } else {
        //联系人无效
        NSLog(@"联系人无效");
        if (name) {
            [name release];
        }
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Friends_Selected_Friend_No_PhoneNum", nil)];
    }
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    [self pickUpPeopleInfoFromController:peoplePicker selectedPerson:person property:property inentifier:identifier];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    [self pickUpPeopleInfoFromController:peoplePicker selectedPerson:person property:property inentifier:identifier];
    return NO;
}

#pragma mark -- search bar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchArea.showsCancelButton = YES;
    //如果当前显示朋友列表，则加载
    if (!friendsTable.hidden) {
        [self addFriendsMaskView];
        //result table
        [self loadResultTable];
    } else if (!resultTable.hidden) {
        [self addResultMaskView];
    }
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"did change====%@",searchText);
    [self searchResult:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchResult:searchBar.text];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchArea.showsCancelButton = NO;
    [searchArea resignFirstResponder];
    resultTable.hidden = YES;
    [self addResultMaskView];
    
    friendsTable.hidden = NO;
    UIView *friendsMask = [self.view viewWithTag:FRIENDS_MASK_VIEW_TAG];
    if (friendsMask) {
        friendsMask.hidden = YES;
    }
}

- (void)searchResult:(NSString *)searchString {
    if (searchString && ![searchString isEqualToString:@""]) {
        resultTable.hidden = NO;
        friendsTable.hidden = YES;
        [self searchFriendsByName:searchString];
    } else {
        resultTable.hidden = YES;
        [self addResultMaskView];
        friendsTable.hidden = NO;
        [self addFriendsMaskView];
    }
}

- (void) searchFriendsByName:(NSString *)friendName {
    NSMutableArray *resultArr = [[NSMutableArray alloc] initWithCapacity:0];
    [resIndexdData removeAllObjects];
    [resIndexTitles removeAllObjects];
    for (int titleIndex = 0; titleIndex < [indexTitles count]; titleIndex ++) {
        NSString *indexTitle = [indexTitles objectAtIndex:titleIndex];
        if ([CommonUtils objectIsValid:indexTitle]) {
            NSArray *friends = [indexedData objectForKey:indexTitle];
            if ([CommonUtils objectIsValid:friends]) {
                for (User *friend in friends) {
                    NSString *title = [friend.mName uppercaseString];
                    if ([CommonUtils objectIsValid:title] && [title rangeOfString:[friendName uppercaseString]].location != NSNotFound && [title rangeOfString:[friendName uppercaseString]].length > 0) {
                        [resultArr addObject:friend];
                    }
                }
            }
        }
    }
    [self dealWithOriginalData:resultArr resultIndexedData:resIndexdData resultIndexedTitles:resIndexTitles];
    [self refreshViews];
    [resultArr release];
}

#pragma mark alert delegate method
- (void)alertController:(AlertController *)alertController didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (alertController.tag) {
        case AlertViewStyleAddInfoIllegal:
        {
            
        }
            break;
        case AlertViewStyleSearchNoResult:
        {
            
        }
            break;
        case AlertViewStyleDelete:
        {
            if (buttonIndex == alertController.firstOtherButtonIndex) {
                NSString *indexTitle = [indexTitles objectAtIndex:self.currentDeleteIndexPath.section - 1];
                if ([CommonUtils objectIsValid:indexTitle]) {
                    NSMutableArray *tempFriendsArray = [indexedData objectForKey:indexTitle];
                    if ([CommonUtils objectIsValid:tempFriendsArray]) {
                        User *friend = [tempFriendsArray objectAtIndex:self.currentDeleteIndexPath.row];
                        if (friend) {
                            [[Friends shareFriends] remove:friend];
                            [tempFriendsArray removeObject:friend];
                            if ([tempFriendsArray count] <= 0) {
                                [indexedData removeObjectForKey:indexTitle];
                                [indexTitles removeObjectAtIndex:self.currentDeleteIndexPath.section - 1];
                                [friendsTable deleteSections:[NSIndexSet indexSetWithIndex:self.currentDeleteIndexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                            } else {
                                [friendsTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.currentDeleteIndexPath] withRowAnimation:UITableViewRowAnimationTop];
                            }
                        }
                    }
                }
            }
            self.currentDeleteIndexPath = nil;
        }
            break;
        default:
            break;
    }
}

#pragma mark upadte views
- (void) refreshViews {
    [self addResultMaskView];
    [self updateResultTableHeaderView];
    [resultTable reloadData];
    [self addFriendsMaskView];
}

- (void) updateResultTableHeaderView {
    if (resIndexdData.count == 0) {
        //no result and add header
        UIView *headerView = [[UIView alloc] initWithFrame:resultTable.frame];
        headerView.backgroundColor = [UIColor clearColor];
        UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, PROMPT_LABEL_OFFSET_Y, PHONE_UISCREEN_WIDTH, PROMPT_LABEL_HEIGHT)];
        promptLabel = [CommonUtils labelWithFrame:CGRectMake(0., PROMPT_LABEL_OFFSET_Y, PHONE_UISCREEN_WIDTH, PROMPT_LABEL_HEIGHT) text:NSLocalizedString(@"Friends_Search_No_Match_Friends", nil) textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textFont:[RTSSAppStyle getRTSSFontWithSize:18.0] tag:0];
        promptLabel.backgroundColor = [UIColor clearColor];
        promptLabel.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:promptLabel];
        resultTable.tableHeaderView = headerView;
        [headerView release];
    } else {
        //have results and remove header
        resultTable.tableHeaderView = nil;
    }
}

#pragma mark init data
- (void) loadData {
    Friends *friendsManager = [Friends shareFriends];
    indexedData = [[NSMutableDictionary alloc] initWithCapacity:0];
    indexTitles = [[NSMutableArray alloc] initWithCapacity:0];
    int limit = 0;
    [self dealWithOriginalData:[friendsManager friends:limit] resultIndexedData:indexedData resultIndexedTitles:indexTitles];
}

- (void)dealWithOriginalData:(NSArray *)data resultIndexedData:(NSMutableDictionary *)indexDataDict resultIndexedTitles:(NSMutableArray *)indexedTitles
{
    char indices[27] = "\0";
    for (int i = 0, count = [data count]; i < count; i++) {
        User *friend = [data objectAtIndex:i];
        if (friend) {
            NSString* indexTitle = nil;
            //NSString* value = ((NSString*)[entry objectForKey:@"TopText"]).uppercaseString;
            //将value转化为拼音，检查第一个字符
            NSString *value = [ChineseToPinyin pinyinFromChiniseString:friend.mName];
            //            value = friend.mName;
            if (value != nil) {
                int index = (int)[value characterAtIndex:0];
                if ('A' <= index && 'Z' >= index) {
                    indices[index-'A'] = index;
                    indexTitle = [NSString stringWithFormat:@"%c", index];
                } else {
                    indices[26] = '#';
                    indexTitle = @"#";
                }
            } else {
                indices[26] = '#';
                indexTitle = @"#";
            }
            if (nil != indexTitle) {
                NSMutableArray* friends = nil;
                if (nil == (friends = [indexDataDict objectForKey:indexTitle])) {
                    friends = [[NSMutableArray alloc] initWithCapacity:0];
                    [friends addObject:friend];
                    [indexDataDict setObject:friends forKey:indexTitle];
                    [friends release];
                } else {
                    [friends addObject:friend];
                }
            }
        }
    }
    for (int i = 0; i < 27; i++) {
        if ('\0' != indices[i]) {
            [indexedTitles addObject:[NSString stringWithFormat:@"%c", indices[i]]];
        }
    }
}

- (void) createAndInsertNewFriendsByPhoneNum:(NSString *)phoneNum name:(NSString *)personName {
    if (!indexedData) {
        indexedData = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    if (!indexTitles) {
        indexTitles = [[NSMutableArray alloc] initWithCapacity:0];
    }
    User *friend = [[User alloc] init];
    friend.mName = personName;
    friend.mId = personName;
    friend.mPhoneNumber = phoneNum;
    //分组联系人
    NSString *indexTitle = nil;
    if ([CommonUtils objectIsValid:personName]) {
        NSString *value = [ChineseToPinyin pinyinFromChiniseString:personName];
        //        value = personName;
        if ([CommonUtils objectIsValid:value]) {
            int index = (int)[value characterAtIndex:0];
            if ('A' <= index && 'Z' >= index) {
                indexTitle = [NSString stringWithFormat:@"%c", index];
            } else {
                indexTitle = @"#";
            }
        }
    } else {
        indexTitle = @"#";
    }
    //插入
    BOOL hasExistsGroup = NO;
    for (int i = 0; i < [indexTitles count]; i ++) {
        NSString *groupTitle = [indexTitles objectAtIndex:i];
        if ([CommonUtils objectIsValid:groupTitle]) {
            if ([groupTitle compare:indexTitle options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                hasExistsGroup = YES;
                break;
            }
        }
    }
    if (hasExistsGroup) {
        NSMutableArray *friends = [indexedData objectForKey:indexTitle];
        //添加之前需要判断是否重复
        if (![self getPersonEixstsStatus:friend]) {
            //不重复
            [friends addObject:friend];
            [indexedData setObject:friends forKey:indexTitle];
            
            //保存friend
            [[Friends shareFriends] add:friend];
            [friend release];
        } else {
            //重复
            [APPLICATION_KEY_WINDOW  makeToast:NSLocalizedString(@"Friends_Add_Friend_Have_Exist", nil)];
            [friend release];
        }
    } else {
        if (![self getPersonEixstsStatus:friend]) {
            [indexTitles addObject:indexTitle];
            [self orderTitlesByAscent:indexTitles];
            
            NSMutableArray *friends = [[NSMutableArray alloc] initWithCapacity:0];
            [friends addObject:friend];
            [indexedData setObject:friends forKey:indexTitle];
            [friends release];
            
            //保存friend
            [[Friends shareFriends] add:friend];
            [friend release];
        } else {
            //重复
            [APPLICATION_KEY_WINDOW  makeToast:NSLocalizedString(@"Friends_Add_Friend_Have_Exist", nil)];
            [friend release];
        }
    }
}

- (void)orderTitlesByAscent:(NSMutableArray *)dataArray {
    if ([CommonUtils objectIsValid:dataArray]) {
        NSComparator comparator = ^ NSComparisonResult (NSString *str1, NSString *str2) {
            return [str1 compare:str2];
        };
        [dataArray sortUsingComparator:comparator];
    }
    //#,a,b,c,y
    //将#移到最后
    if ([dataArray containsObject:@"#"]) {
        [dataArray removeObject:@"#"];
        [dataArray addObject:@"#"];
    }
    NSLog(@"ordered array === %@",dataArray);
}

- (BOOL)getPersonEixstsStatus:(User *)friend {
    BOOL status = NO;
    if (friend) {
        NSString *friendNum = friend.mPhoneNumber;
        if ([CommonUtils objectIsValid:friendNum]) {
            NSArray *friends = [[Friends shareFriends] friends:0];
            if ([CommonUtils objectIsValid:friends]) {
                for (int j = 0; j < [friends count]; j ++) {
                    User *user = [friends objectAtIndex:j];
                    if (user) {
                        NSString *tempNum = user.mPhoneNumber;
                        if ([CommonUtils objectIsValid:tempNum]) {
                            NSLog(@"newId:%@-------tempId:%@",friendNum,tempNum);
                            if ([friendNum isEqualToString:tempNum]) {
                                status = YES;
                                break;
                            }
                        }
                    }
                }
                
            }
        }
    }
    return status;
}


#pragma mark others
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
