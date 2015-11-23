//
//  BudgetAddMembersViewController.m
//  RTSS
//
//  Created by 加富董 on 15/1/18.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "BudgetAddMembersViewController.h"
#import "ScanViewController.h"
#import "BudgetAddMembersCell.h"
#import "CommonUtils.h"
#import "PortraitImageView.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Subscriber.h"
#import "BudgetManageViewController.h"
#import "BudgetVicinityViewController.h"

typedef NS_ENUM(NSInteger, AddMembersMethod) {
    AddMembersMethodViaQRCode = 0,
    AddMembersMethodViaVicinity,
    AddMembersMethodViaMobileContacts,
};

#define BUDGET_ADD_MEMBERS_SEP_HEADER_HEIGHT 23.0
#define ADD_CELL_HEIGHT 50.0

#define ADD_CELL_ICON_KEY @"icon"
#define ADD_CELL_TEXT_KEY @"text"

@interface BudgetAddMembersViewController () <UITableViewDataSource, UITableViewDelegate, ABPeoplePickerNavigationControllerDelegate, BudgetVicinityViewControllerDelegate> {
    UIView *contentView;
    UIView *seperatorHeaderView;
}

@property (nonatomic, retain)NSMutableArray *dataArray;
@property (nonatomic, retain)UITableView *addMethodTableView;

@end

@implementation BudgetAddMembersViewController

@synthesize dataArray;
@synthesize addMethodTableView;
@synthesize currentGroup;
@synthesize fromType;

#pragma mark dealloc
- (void)dealloc {
    [contentView release];
    [seperatorHeaderView release];
    [dataArray release];
    [addMethodTableView release];
    [currentGroup release];
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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark init views
- (void)loadNavBarView {
    navigationBarView = [self addNavigationBarView:NSLocalizedString(@"Budget_Add_Members_Title", nil) bgColor:[[RTSSAppStyle currentAppStyle] viewControllerBgColor] separator:YES];
    [self.view addSubview:navigationBarView];
}

- (void)loadContentView {
    CGRect contentRect = CGRectMake(0.0, CGRectGetMaxY(navigationBarView.frame), PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT - CGRectGetMaxY(navigationBarView.frame));
    contentView = [[UIView alloc] initWithFrame:contentRect];
    contentView.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
    [self.view addSubview:contentView];
    
    [self loadSeperatorHeaderView];
    [self loadAddMethodTableView];
}

- (void)loadSeperatorHeaderView {
    if (seperatorHeaderView == nil) {
        CGRect headerRect = CGRectMake(0.0, 0.0, PHONE_UISCREEN_WIDTH, BUDGET_ADD_MEMBERS_SEP_HEADER_HEIGHT);
        seperatorHeaderView = [[UIView alloc] initWithFrame:headerRect];
        seperatorHeaderView.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
        [contentView addSubview:seperatorHeaderView];
        
        //sep line
        CGRect sepRect = CGRectMake(0.0, CGRectGetHeight(seperatorHeaderView.frame) - SEPERATOR_LINE_HEIGHT, PHONE_UISCREEN_WIDTH, SEPERATOR_LINE_HEIGHT);
        UIImageView *sepLine = [[UIImageView alloc] initWithFrame:sepRect];
        sepLine.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
        [seperatorHeaderView addSubview:sepLine];
        [sepLine release];
    }
}

- (void)loadAddMethodTableView {
    if (addMethodTableView == nil) {
        CGRect tableRect = CGRectMake(0.0, CGRectGetMaxY(seperatorHeaderView.frame), PHONE_UISCREEN_WIDTH, CGRectGetHeight(contentView.frame) - CGRectGetMaxY(seperatorHeaderView.frame));
        addMethodTableView = [[UITableView alloc] initWithFrame:tableRect];
        addMethodTableView.backgroundColor = [UIColor clearColor];
        addMethodTableView.delegate = self;
        addMethodTableView.dataSource = self;
        addMethodTableView.showsHorizontalScrollIndicator = NO;
        addMethodTableView.showsVerticalScrollIndicator = YES;
        addMethodTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        addMethodTableView.rowHeight = ADD_CELL_HEIGHT;
        [contentView addSubview:addMethodTableView];
    }
}

#pragma mark table view delegate method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ADD_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"addCell";
    BudgetAddMembersCell *addCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (addCell == nil) {
        addCell = [[[BudgetAddMembersCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId availableSize:CGSizeMake(PHONE_UISCREEN_WIDTH, ADD_CELL_HEIGHT)] autorelease];
        [self setBgStyle:addCell];
    }
    NSDictionary *cellData = [self.dataArray objectAtIndex:indexPath.row];
    if ([CommonUtils objectIsValid:cellData]) {
        [self layoutAddCell:addCell cellData:cellData];
    }
    return addCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"join method did select row at index == %d",indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == AddMembersMethodViaQRCode) {
        
        //scan qr code
        ScanViewController *scanVC = [[ScanViewController alloc] init];
        scanVC.tips = NSLocalizedString(@"Budget_Add_Members_From_QR_Code_Tip", nil);
        [scanVC setSuccessBlock:^ (NSString *valueStr) {
            NSLog(@"qr code value string == %@",valueStr);
            if (self.currentGroup && [CommonUtils objectIsValid:valueStr]) {
                Subscriber *sub = [[Subscriber alloc] init];
//                sub.mSubscriberName = valueStr;
//                sub.mPhoneNumber = valueStr;
//                sub.mSubscriberId = valueStr;
                [self.currentGroup addMember:sub];
                [sub release];
                
                BudgetManageViewController *manageVC = [[BudgetManageViewController alloc] init];
                manageVC.curGroup = self.currentGroup;
                manageVC.groupType = GroupTypeCreated;
                [self.navigationController pushViewController:manageVC animated:YES];
            }
            
        }];
        [self presentViewController:scanVC animated:YES completion:nil];
        [scanVC release];

    } else if (indexPath.row == AddMembersMethodViaVicinity) {
    
        //join vicinity
        BudgetVicinityViewController *vicinityVC = [[BudgetVicinityViewController alloc] init];
        vicinityVC.groupType = GroupTypeCreated;
        vicinityVC.delegate = self;
        vicinityVC.currentGroup = self.currentGroup;
        [self.navigationController pushViewController:vicinityVC animated:YES];
        [vicinityVC release];
                
    } else if (indexPath.row == AddMembersMethodViaMobileContacts) {
        
        //mobile contacts
        ABPeoplePickerNavigationController* picker = [[ABPeoplePickerNavigationController alloc] init];
        picker.peoplePickerDelegate = self;
        [self presentViewController:picker animated:YES completion:nil];
        [picker release];
    }
}

- (void)layoutAddCell:(BudgetAddMembersCell *)cell cellData:(NSDictionary *)dataDict {
    if ([CommonUtils objectIsValid:dataDict]) {
        NSString *methodIcon = [dataDict objectForKey:ADD_CELL_ICON_KEY];
        NSString *methodText = [dataDict objectForKey:ADD_CELL_TEXT_KEY];
        cell.iconImageView.portraitImage = [UIImage imageNamed:methodIcon];
        cell.methodTextLable.text = methodText;
        cell.arrowImageView.image = [UIImage imageNamed:@"common_next_arrow2"];
    }
}

#pragma mark vicinity delegate
- (void)budgetVicinityViewController:(BudgetVicinityViewController *)vicinity didClickedConfirmButtonWithMembersData:(NSMutableArray *)membersArray {
    NSLog(@"budget addvc vicinity members==%@",membersArray);
    if ([CommonUtils objectIsValid:membersArray] && currentGroup) {
        for (int i = 0; i < [membersArray count]; i ++) {
            id sub = [membersArray objectAtIndex:i];
            if (sub && [sub isKindOfClass:[Subscriber class]]) {
                [currentGroup addMember:sub];
            }
        }
        [self performSelector:@selector(pushToManage) withObject:nil afterDelay:0.2];
    }
}

- (void)pushToManage {
    BudgetManageViewController *manageVC = [[BudgetManageViewController alloc] init];
    manageVC.curGroup = self.currentGroup;
    manageVC.groupType = GroupTypeCreated;
    [self.navigationController pushViewController:manageVC animated:YES];
    [manageVC release];
}

#pragma mark people picker delegate
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

- (void)pickUpPeopleInfoFromController:(ABPeoplePickerNavigationController *)peoplePicker selectedPerson:(ABRecordRef)person property:(ABPropertyID)property inentifier:(ABMultiValueIdentifier)identifier {
    BOOL canAdd = NO;
    if (self.currentGroup) {
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
            NSString *phoneStr = [[NSString alloc] initWithString:(NSString *)phone];
            CFRelease(phoneMulti);
            CFRelease(phone);
            
            phoneNum = [phoneStr stringByReplacingOccurrencesOfString:@"[^\\d]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0,[phoneNum length])];
            [phoneStr release];
        }
        if ([CommonUtils objectIsValid:phoneNum]) {
            if (![CommonUtils objectIsValid:name]) {
                if (name) {
                    [name release];
                    name = [phoneNum copy];
                } 
            }
            ////temp
            Subscriber *sub = [[Subscriber alloc] init];
//            sub.mSubscriberName = name;
//            sub.mPhoneNumber = phoneNum;
//            sub.mSubscriberId = phoneNum;
            [self.currentGroup addMember:sub];
            [sub release];
            
            [name release];
            canAdd = YES;
            
        } else {
            NSLog(@"phone num is invalid");
            if (name) {
                [name release];
            }
            canAdd = NO;
        }
    }
    [peoplePicker dismissViewControllerAnimated:YES completion:^ {
        if (canAdd && currentGroup) {
            BudgetManageViewController *manageVC = [[BudgetManageViewController alloc] init];
            manageVC.curGroup = currentGroup;
            manageVC.groupType = GroupTypeCreated;
            [self.navigationController pushViewController:manageVC animated:YES];
        }
    }];
}

#pragma mark tools method
- (void)setBgStyle:(BudgetAddMembersCell *)cell {
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


#pragma mark button action
- (void)backBarButtonAction:(UIButton*)barButtonItem {
    if (self.fromType == EnterTypeFromCreate) {
        BudgetManageViewController *manageVC = [[BudgetManageViewController alloc] init];
        manageVC.groupType = GroupTypeCreated;
        manageVC.curGroup = self.currentGroup;
        [self.navigationController pushViewController:manageVC animated:YES];
        [manageVC release];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark load data
- (void)loadData {
    self.dataArray = [self getData];
}

- (NSMutableArray *)getData {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *iconsArray = @[@"budget_group_add_from_qr_code",@"budget_group_add_from_vicinity",@"budget_group_add_from_vicinity@2x"];
    NSArray *textArray = @[NSLocalizedString(@"Budget_Add_Members_Via_Scan_QR_Code", nil),
                           NSLocalizedString(@"Budget_Add_Members_Via_vicinity", nil),
                           NSLocalizedString(@"Budget_Add_Members_Via_Mobile_Contacts", nil)];
    for (int i = 0; i < 3; i ++) {
        NSMutableDictionary *cellDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        [cellDict setObject:[iconsArray objectAtIndex:i] forKey:ADD_CELL_ICON_KEY];
        [cellDict setObject:[textArray objectAtIndex:i] forKey:ADD_CELL_TEXT_KEY];
        [array addObject:cellDict];
        [cellDict release];
    }
    return [array autorelease];
}

@end
