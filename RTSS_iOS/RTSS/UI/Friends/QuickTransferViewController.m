//
//  QuickTransferViewController.m
//  RTSS
//
//  Created by 加富董 on 14-11-3.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "QuickTransferViewController.h"
#import "QuickTransferCell.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Friends.h"
#import "User.h"
#import "Cache.h"
#import "FriendsViewController.h"

#define APPS_TABLE_VIEW_LEFT 14.f
#define APPS_TABLE_VIEW_TOP 20.f
#define APPS_TABLE_VIEW_BOTTOM 20.f

#define HISTORY_CELL_HEIGHT 51.f

#define SELECT_FINISHED_BUTTON_WIDTH 40.f
#define SELECT_FINISHED_BUTTON_HEIGHT 20.f

@interface QuickTransferViewController () <UITableViewDelegate,UITableViewDataSource,ABPeoplePickerNavigationControllerDelegate,QuickTransferCellDelegate> {
    UITableView *historyTableView;
    NSMutableArray *selectedFriendsArray;
    UIButton *selectConfirmButton;
    BOOL needRefresh;
}

@end

@implementation QuickTransferViewController

@synthesize historyArray;
@synthesize fetchFriendsInfoBlock;
@synthesize selectType;

#pragma mark dealloc
- (void)dealloc
{
    [historyTableView release];
    [historyArray release];
    [selectedFriendsArray release];
    self.fetchFriendsInfoBlock = nil;
    [super dealloc];
}

#pragma mark init
- (instancetype)init
{
    self = [super init];
    if (self) {
        selectedFriendsArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

#pragma mark life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    needRefresh = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    needRefresh = NO;
}

#pragma mark initView
-(void)loadView{
    [super loadView];
    [self loadNavView];
    [self loadBackgroundView];
    [self loadTransferHistoryTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)loadNavView {
    self.view.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
    navigationBarView = [self addNavigationBarView:NSLocalizedString(@"Quick_Transfer_Title", nil) bgColor:[[RTSSAppStyle currentAppStyle] navigationBarColor] separator:YES];
    [self.view addSubview:navigationBarView];
    
    //select finished button
    if (selectType == SelectTypeByMultiple) {
        CGRect confirmButtonRect = CGRectMake(PHONE_UISCREEN_WIDTH - APPS_TABLE_VIEW_LEFT - SELECT_FINISHED_BUTTON_WIDTH, (CGRectGetHeight(navigationBarView.frame) - SELECT_FINISHED_BUTTON_HEIGHT) / 2.f, SELECT_FINISHED_BUTTON_WIDTH, SELECT_FINISHED_BUTTON_HEIGHT);
        selectConfirmButton = [CommonUtils buttonWithType:UIButtonTypeCustom frame:confirmButtonRect title:NSLocalizedString(@"Quick_Transfer_Select_Done_title", nil) bgImageNormal:nil bgImageHighlighted:nil bgImageSelected:nil addTarget:self action:@selector(conformSelected:) tag:0];
        selectConfirmButton.titleLabel.textAlignment = NSTextAlignmentRight;
        selectConfirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        [selectConfirmButton setTitleColor:[[RTSSAppStyle currentAppStyle] textMajorColor] forState:UIControlStateNormal];
        [selectConfirmButton setTitleColor:[[RTSSAppStyle currentAppStyle] turboBoostUnfoldBgColor] forState:UIControlStateDisabled];
        selectConfirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        selectConfirmButton.enabled = NO;
        [navigationBarView addSubview:selectConfirmButton];
    }
}

- (void)loadBackgroundView {
    //content view 导航下面的view
    CGRect contentViewRect = CGRectMake(0.f, CGRectGetMaxY(navigationBarView.frame), PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT);
    UIView *contentView = [[UIView alloc] initWithFrame:contentViewRect];
    contentView.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    [self.view addSubview:contentView];
    [contentView release];
    
    CGRect bgViewRect = CGRectMake(APPS_TABLE_VIEW_LEFT - 1.f, APPS_TABLE_VIEW_TOP - 1.f, PHONE_UISCREEN_WIDTH - APPS_TABLE_VIEW_LEFT * 2.f + 2.f, PHONE_UISCREEN_HEIGHT - 20.f - 44.f - APPS_TABLE_VIEW_TOP - APPS_TABLE_VIEW_BOTTOM + 2.f);
    UIView *bgView = [[UIView alloc] initWithFrame:bgViewRect];
    bgView.layer.cornerRadius = 8.f;
    bgView.layer.borderColor = [[RTSSAppStyle currentAppStyle] turboBoostBoderColor].CGColor;
    bgView.layer.borderWidth = 1.f;
    bgView.backgroundColor = [UIColor clearColor];
    bgView.clipsToBounds = YES;
    bgView.tag = 100;
    [contentView addSubview:bgView];
    [bgView release];
}

- (void)loadTransferHistoryTableView {
    CGRect tableRect = CGRectMake(1.f, 1.f, PHONE_UISCREEN_WIDTH - APPS_TABLE_VIEW_LEFT * 2.f, PHONE_UISCREEN_HEIGHT - 20.f - 44.f - APPS_TABLE_VIEW_TOP - APPS_TABLE_VIEW_BOTTOM);
    historyTableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
    historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    historyTableView.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
    historyTableView.showsHorizontalScrollIndicator = NO;
    historyTableView.showsVerticalScrollIndicator = NO;
    historyTableView.rowHeight = HISTORY_CELL_HEIGHT;
    historyTableView.delegate = self;
    historyTableView.dataSource = self;
    [[self.view viewWithTag:100] addSubview:historyTableView];
}

#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [historyArray count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return HISTORY_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *commonCellId = @"commonId";
    static NSString *transferCellId = @"friendId";
    CGSize availableSize = CGSizeMake(CGRectGetWidth(historyTableView.frame), HISTORY_CELL_HEIGHT);
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        CommonAddFriendsCell *addCell = [tableView dequeueReusableCellWithIdentifier:commonCellId];
        if (addCell == nil) {
            addCell = [[[CommonAddFriendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commonCellId availableSize:availableSize] autorelease];
            addCell.portraitImageView.image = [UIImage imageNamed:@"friends_add_friend_icon"];
            addCell.accessoryImageView.image = [UIImage imageNamed:@"common_next_arrow"];
            CGRect accessoryFrame = addCell.accessoryImageView.frame;
            accessoryFrame.origin.x += 10.f;
            addCell.accessoryImageView.frame = accessoryFrame;
        }
        addCell.messageLable.text = NSLocalizedString(@"Quick_Transfer_Add_Friends", nil);
        cell = (UITableViewCell *)addCell;
    } else {
        QuickTransferCell *transferCell = [tableView dequeueReusableCellWithIdentifier:transferCellId];
        if (transferCell == nil) {
            transferCell = [[[QuickTransferCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:transferCellId availableSize:availableSize selectType:selectType] autorelease];
            transferCell.delegate = self;
        }
        User *friendData = [historyArray objectAtIndex:indexPath.row - 1];
        [self layoutQuickTransferCell:transferCell data:friendData selectStatus:[selectedFriendsArray containsObject:friendData] showSeperatorLine:YES];
        cell = (UITableViewCell *)transferCell;
    }
    
    //select style
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //bg color
    cell.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
   
    return cell;
}

- (void)layoutQuickTransferCell:(QuickTransferCell *)transferCell data:(User *)userData selectStatus:(BOOL)status showSeperatorLine:(BOOL)show {
    if (userData) {
        transferCell.userData = userData;
        
        //portrait
        transferCell.personPortraitImageView.portraitImage = [[Cache standardCache] getSmallPortraitImageWithUrl:userData.mPortrait completion:^ (UIImage *image) {
            if (needRefresh) {
                transferCell.personPortraitImageView.portraitImage = image;
            }
        }];
        
        //name
        //User中的mUserName、mPhoneNumber、mEmail调整到Customer中
//        transferCell.personNameLable.text = userData.mUserName;
        
        //phone num
//        transferCell.personPhoneLable.text = userData.mPhoneNumber;
        
        //select status
        if (transferCell.selectButton && transferCell.selectType == SelectTypeByMultiple) {
            transferCell.selectButton.selected = status;
        }
        
        //seperator line
        transferCell.seperatorLine.hidden = show ? NO : YES;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        //从通讯录添加联系人
//        ABPeoplePickerNavigationController *pickerNav = [[ABPeoplePickerNavigationController alloc] init];
//        pickerNav.peoplePickerDelegate = self;
//        [self presentViewController:pickerNav animated:YES completion:nil];
//        [pickerNav release];
        FriendsViewController *fVC = [[FriendsViewController alloc] init];
        fVC.actionType = FriendsActionTypePickFriends;
        fVC.transferFriendInfoBlock = ^ (User *friend) {
            if (friend) {
                [selectedFriendsArray removeAllObjects];
                [self addSelectedFriend:friend];
                if (fetchFriendsInfoBlock) {
                    fetchFriendsInfoBlock(selectedFriendsArray);
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
        };
        [self.navigationController pushViewController:fVC animated:YES];
        [fVC release];
    } else {
        //返回联系人信息
        if (selectType == SelectTypeBySingle && fetchFriendsInfoBlock) {
            [selectedFriendsArray removeAllObjects];
            [self addSelectedFriend:[historyArray objectAtIndex:indexPath.row - 1]];
            fetchFriendsInfoBlock(selectedFriendsArray);
            [self.navigationController popViewControllerAnimated:YES];
        } else if (selectType == SelectTypeByMultiple) {
            QuickTransferCell *cell = (QuickTransferCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell.selectButton.selected = !cell.selectButton.selected;
            if (cell.selectButton.selected) {
                [self addSelectedFriend:[historyArray objectAtIndex:indexPath.row - 1]];
            } else {
                [self removeSelectedFriend:[historyArray objectAtIndex:indexPath.row - 1]];
            }
        }
    }
}

#pragma mark quick transfer cell delegate method
- (void)quickTransferCell:(QuickTransferCell *)cell didClickSelectedButton:(UIButton *)selButton {
    if (cell.userData) {
        if (selButton.selected) {
            [self addSelectedFriend:cell.userData];
        } else {
            [self removeSelectedFriend:cell.userData];
        }
    }
}

#pragma mark ABPeoplePickerNavigationController delegate
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController*)peoplePicker {
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    return YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    [self getUserInfo:peoplePicker person:person property:property identifier:identifier callBack:^(BOOL succeed) {
        [peoplePicker dismissViewControllerAnimated:YES completion:^ {
            if (selectType == SelectTypeBySingle && succeed) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }];
    return NO;
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    [self getUserInfo:peoplePicker person:person property:property identifier:identifier callBack:^ (BOOL succeed) {
        [peoplePicker dismissViewControllerAnimated:YES completion:^ {
            if (selectType == SelectTypeBySingle && succeed) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }];
}

- (void)getUserInfo:(ABPeoplePickerNavigationController *)peoplePicker person:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier callBack:(void (^)(BOOL succeed))callBack {
    NSString* name = nil;
    NSString* phoneNum = nil;
    if (property == kABPersonPhoneProperty) {
        
        CFStringRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFStringRef middleName = ABRecordCopyValue(person, kABPersonMiddleNameProperty);
        CFStringRef lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        //当前语言环境
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
    BOOL succeed = NO;
    if ([CommonUtils objectIsValid:phoneNum]) {
        succeed = YES;
        if (![CommonUtils objectIsValid:name]) {
            if (name) {
                [name release];
            }
            name = [phoneNum copy];
        }
        //创建联系人
        User *newFriend = [[User alloc] init];
        //User中的mUserName、mPhoneNumber、mEmail调整到Customer中
//        newFriend.mUserName = name;
        newFriend.mId = name;
//        newFriend.mPhoneNumber = phoneNum;
        //插入新联系人
        //判断该联系人是否已经存在
        if ([self getPersonExistsStatus:newFriend fromSourcePersonArray:historyArray]) {
            //已经存在
            [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Quick_Transfer_Add_Friend_Have_Exist", nil)];
        } else {
            //不存在，可以添加
            [historyArray insertObject:newFriend atIndex:0];
            [[Friends shareFriends] add:newFriend];
            [historyTableView reloadData];
        }
        
        if (selectType == SelectTypeBySingle) {
            [selectedFriendsArray removeAllObjects];
        }
        [self addSelectedFriend:newFriend];
        
        //返回联系人
        if (selectType == SelectTypeBySingle) {
            if (fetchFriendsInfoBlock) {
                fetchFriendsInfoBlock(selectedFriendsArray);
            }
        }
        [newFriend release];
        
        if (name) {
            [name release];
        }
    } else {
        //联系人不符合要求
        succeed = NO;
        NSLog(@"所选联系人无号码");
        if (name) {
            [name release];
        }
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Quick_Transfer_Selected_Friend_No_PhoneNum", nil)];
    }
    if (callBack) {
        callBack(succeed);
    }
}

- (BOOL) getPersonExistsStatus:(User *)friend fromSourcePersonArray:(NSMutableArray *)friendsArray {
    //User中的mUserName、mPhoneNumber、mEmail调整到Customer中
    NSString *personName = nil;
//    NSString *personName = friend.mUserName;
    BOOL isExists = NO;
    if ([CommonUtils objectIsValid:personName]) {
        for (int i = 0; i < [friendsArray count]; i ++) {
            NSString *name = [[friendsArray objectAtIndex:i] mName];
            if ([personName isEqualToString:name]) {
                isExists = YES;
                break;
            }
        }
    }
    return isExists;
}

#pragma mark button clicked
- (void)conformSelected:(UIButton *)confirmButton {
    if (selectType == SelectTypeByMultiple && [selectedFriendsArray count] > 0 && fetchFriendsInfoBlock) {
        fetchFriendsInfoBlock(selectedFriendsArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark add remove friends
- (void)addSelectedFriend:(User *)friend {
    [selectedFriendsArray addObject:friend];
    [self updateConfirmButton];
}

- (void)removeSelectedFriend:(User *)friend {
    [selectedFriendsArray removeObject:friend];
    [self updateConfirmButton];
}

- (void)updateConfirmButton {
    if (selectedFriendsArray.count > 0) {
        selectConfirmButton.enabled = YES;
    } else {
        selectConfirmButton.enabled = NO;
    }
}
#pragma mark loadData
- (void)loadData{
    Friends *friendsManager = [Friends shareFriends];
    int limit = 5;
    self.historyArray = (NSMutableArray *)[friendsManager friends:limit];
    [historyTableView reloadData];
}

- (NSMutableArray *)fakeData {
    NSArray *nameArr = @[@"Robin",@"Jack",@"Ken",@"Jim",@"Jaffer",@"David",@"Sophie",@"jfm",@"kkf",@"fdf",@"gfg",@"dfsf",@"ggg",@"hhh",@"yyy",@"uuuu"];
    NSArray *phoneArr = @[@"15801685222",@"15801685222",@"15801685222",@"15801685222",@"15801685222",@"15801685222",@"15801685222",@"15801685222",@"15801685222",@"15801685222",@"15801685222",@"15801685222",@"15801685222",@"15801685222",@"15801685222",@"15801685222"];
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSInteger i = 0; i < [nameArr count]; i ++) {
        User *friend = [[User alloc] init];
        //User中的mUserName、mPhoneNumber、mEmail调整到Customer中
//        friend.mUserName = [nameArr objectAtIndex:i];
//        friend.mPhoneNumber = [phoneArr objectAtIndex:i];
        [dataArray addObject:friend];
        [friend release];
    }
    return dataArray;
}

#pragma mark warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

