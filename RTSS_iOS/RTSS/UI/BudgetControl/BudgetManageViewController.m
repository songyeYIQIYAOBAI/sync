//
//  BudgetManageViewController.m
//  RTSS
//
//  Created by 加富董 on 15/1/18.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "BudgetManageViewController.h"
#import "BudgetAddMembersViewController.h"
#import "BudgetCreateViewController.h"
#import "BudgetGroupMemberView.h"
#import "BudgetGroupSettingCell.h"
#import "BudgetGroupSettingView.h"
#import "PortraitImageView.h"
#import "BudgetDetailViewController.h"
#import "Cache.h"
#import "AlertController.h"
#import "ActionSheetController.h"
#import "SinglePickerController.h"
#import "CommonUtils.h"
#import "ImageUtils.h"
#import "RTSSAppDefine.h"
#import "Subscriber.h"
#import "BudgetGroup.h"

#define MEMBERS_VIEW_HEIGHT_DEFAULE 105.0
#define MEMBERS_VIEW_COLUMN_COUNT 4

@interface BudgetManageViewController () <UITableViewDataSource, UITableViewDelegate, BudgetGroupMemberViewDelegate, AlertControllerDelegate,ActionSheetControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    UITableView *groupManageTableView;
    BudgetGroupMemberView *membersView;
    UIImageView *groupMembersSpeLine;
}

@property (nonatomic, retain) NSMutableArray *membersArray;
@property (nonatomic, retain) NSMutableArray *datasArray;

@end

@implementation BudgetManageViewController

@synthesize groupType;
@synthesize membersArray;
@synthesize datasArray;
@synthesize curGroup;

#pragma mark dealloc
- (void)dealloc {
    [groupManageTableView release];
    [membersView release];
    [groupMembersSpeLine release];
    [membersArray release];
    [datasArray release];
    [curGroup release];
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
    navigationBarView = [self addNavigationBarView:/*NSLocalizedString(@"Budget_Manage_Title", nil)*/self.curGroup.mGroupName bgColor:[[RTSSAppStyle currentAppStyle] navigationBarColor] separator:YES];
    [self.view addSubview:navigationBarView];
}

- (void)loadContentView {
    //table
    CGRect tableRect = CGRectMake(0.0, CGRectGetMaxY(navigationBarView.frame), PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT - CGRectGetMaxY(navigationBarView.frame));
    groupManageTableView = [[UITableView alloc] initWithFrame:tableRect];
    groupManageTableView.backgroundColor = [UIColor clearColor];
    groupManageTableView.delegate = self;
    groupManageTableView.dataSource = self;
    groupManageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    groupManageTableView.rowHeight = SETTING_CELL_HEIGHT;
    groupManageTableView.showsHorizontalScrollIndicator = NO;
    groupManageTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:groupManageTableView];
}

- (void)loadTableHeaderView {
    if (membersView) {
        [membersView removeFromSuperview];
    }
    CGRect membersRect = CGRectMake(0.0, CGRectGetMaxY(navigationBarView.frame), PHONE_UISCREEN_WIDTH, MEMBERS_VIEW_HEIGHT_DEFAULE);
    BOOL editable = groupType == GroupTypeCreated ? YES : NO;
    membersView = [[BudgetGroupMemberView alloc] initWithFrame:membersRect canEdit:editable columnCount: MEMBERS_VIEW_COLUMN_COUNT delegate:self];
    membersView.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    CGSize contentSize = [membersView loadContentWithData:self.membersArray];
    
    //add seperator line
    CGRect sepRect = CGRectMake(0.0, contentSize.height - SEPERATOR_LINE_HEIGHT, PHONE_UISCREEN_WIDTH, SEPERATOR_LINE_HEIGHT);
    groupMembersSpeLine = [[UIImageView alloc] initWithFrame:sepRect];
    groupMembersSpeLine.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [membersView addSubview:groupMembersSpeLine];

    groupManageTableView.tableHeaderView = membersView;
}

- (void)refreshMembersView {
    CGSize contentSize = membersView.frame.size;
    CGRect sepRect = groupMembersSpeLine.frame;
    CGFloat originY = contentSize.height - SEPERATOR_LINE_HEIGHT;
    sepRect.origin.y = originY;
    groupMembersSpeLine.frame = sepRect;
    groupManageTableView.tableHeaderView = membersView;
}

#pragma mark button clicked
- (void)backBarButtonAction:(UIButton*)barButtonItem {
    //back
    NSArray *controllers = self.navigationController.viewControllers;
    UIViewController *controller = nil;
    if ([CommonUtils objectIsValid:controllers]) {
        for (int i = 0; i < [controllers count]; i ++) {
            controller = [controllers objectAtIndex:i];
            if ([controller isMemberOfClass:[BudgetViewController class]]) {
                break;
            }
        }
    }
    if (controller) {
        [self.navigationController popToViewController:controller animated:YES];
    }
}

#pragma mark table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [datasArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SETTING_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"settingCell";
    BudgetGroupSettingCell *settingCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (settingCell == nil) {
        settingCell = [[[BudgetGroupSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId availableSize:CGSizeMake(PHONE_UISCREEN_WIDTH, SETTING_CELL_HEIGHT)] autorelease];
    }
    SettingCellContentType type = [self cellTypeAtIndexPath:indexPath];
    BOOL edit = [self editableByType:type];
    [settingCell loadContentViewsByType:type editable:edit];
    [self layoutSettingCell:settingCell indexPath:indexPath];
    [self setBgStyle:settingCell editable:edit];
    return settingCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"budget set cell did clicked at index %d",indexPath.row);
    BudgetGroupSettingCell *cell = (BudgetGroupSettingCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.editable) {
        SettingCellContentType type = cell.contentType;
        switch (type) {
            case SettingCellContentTypeName:
            {
                AlertController *alert = [[AlertController alloc] initWithTitle:nil message:NSLocalizedString(@"Budget_Group_Alert_Title_Set_Name_Message", nil) delegate:self tag:AlertTypeSetGroupName cancelButtonTitle:NSLocalizedString(@"UIAlertView_Cancel_String", nil) otherButtonTitles:NSLocalizedString(@"UIAlertView_Confirm_String", nil),nil];
                [alert addTextFieldWithStyle:AlertControllerStylePlainTextInput holder:NSLocalizedString(@"UIAlertView_Input_holder", nil) leftView:nil rightView:nil textLength:BUDGET_GROUP_NAME_MAX_LENGTH textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textMode:AlertControllerTextModeDefault];
                UITextField *field = [alert textFieldAtIndex:0];
                field.keyboardType = UIKeyboardTypeDefault;
                [alert showInViewController:self];
                [alert release];
            }
                break;
            case SettingCellContentTypePhoto:
            {
                ActionSheetController *actionSheet = [[ActionSheetController alloc] initWithTitle:nil delegate:self tag:0 cancelButtonTitle:NSLocalizedString(@"UIAlertView_Cancel_String", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Budget_Group_Action_Take_Photo", nil),NSLocalizedString(@"Budget_Group_Action_Choose_Photos", nil), nil];
                [actionSheet showInViewController:self];
                [actionSheet release];
            }
                break;
            case SettingCellContentTypeType:
            {
                //do nothing
            }
                break;
            case SettingCellContentTypeBudget:
            {
                NSString *alertLeftStr = [self getBudgetUnit];
                AlertController *alert = [[AlertController alloc] initWithTitle:nil message:NSLocalizedString(@"Budget_Group_Alert_Title_Set_Budget_Message", nil) delegate:self tag:AlertTypeSetGroupBudget cancelButtonTitle:NSLocalizedString(@"UIAlertView_Cancel_String", nil) otherButtonTitles:NSLocalizedString(@"UIAlertView_Confirm_String", nil),nil];
                
                UILabel* leftLabel = [CommonUtils labelWithFrame:CGRectMake(0, 0, [self getBudgetUnitWidthByUnit:curGroup.mUnit], 30) text:alertLeftStr textColor:[RTSSAppStyle currentAppStyle].textSubordinateColor textFont:[UIFont systemFontOfSize:10.0] tag:0];
                leftLabel.backgroundColor = [UIColor clearColor];
                leftLabel.textAlignment = NSTextAlignmentLeft;
                leftLabel.numberOfLines = 1;
                
                [alert addTextFieldWithStyle:AlertControllerStylePlainTextInput holder:NSLocalizedString(@"UIAlertView_Input_holder", nil) leftView:leftLabel rightView:nil textLength:BUDGET_GROUP_NAME_MAX_LENGTH textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textMode:AlertControllerTextModeNumber];
                [alert showInViewController:self];
                [alert release];
            }
            default:
                break;
        }
    }
}

- (void)layoutSettingCell:(BudgetGroupSettingCell *)cell indexPath:(NSIndexPath *)indexPath {
    if (cell && cell.settingView) {
        NSDictionary *dataDict = [datasArray objectAtIndex:indexPath.row];
        NSString *fieldName = [dataDict objectForKey:BUDGET_FIELD_NAME_KEY];
        id fieldValue = [dataDict objectForKey:BUDGET_FIELD_VALUE_KEY];
        
        //field name
        cell.settingView.propertyNameLable.text = fieldName;
        
        //field value
        switch (cell.contentType) {
            case SettingCellContentTypeName:
            {
                NSString *value = [CommonUtils objectIsValid:fieldValue] ? fieldValue : NSLocalizedString(@"Budget_Group_Name_Holder", nil);
                ((BudgetGroupSetNameView *)cell.settingView).groupNameLabel.text = value;
            }
                break;
            case SettingCellContentTypePhoto:
            {
                if (fieldValue && [fieldValue isKindOfClass:[UIImage class]]) {
                    ((BudgetGroupSetPhotoView *)cell.settingView).groupPortraitImageView.portraitImage = (UIImage *)fieldValue;
                } else if (fieldValue && [CommonUtils objectIsValid:fieldValue] && [fieldValue isKindOfClass:[NSString class]]) {
                    ((BudgetGroupSetPhotoView *)cell.settingView).groupPortraitImageView.portraitImage = [[Cache standardCache] getSmallPortraitImageWithUrl:(NSString *)fieldValue placeHolderImageName:@"friends_add_friend_icon" completion:^ (UIImage *image) {
                        ((BudgetGroupSetPhotoView *)cell.settingView).groupPortraitImageView.portraitImage = image;
                    }];
                } else {
                    ((BudgetGroupSetPhotoView *)cell.settingView).groupPortraitImageView.portraitImage = [[Cache standardCache] getSmallPortraitImageWithUrl:nil placeHolderImageName:@"friends_add_friend_icon" completion:^ (UIImage *image) {
                        ((BudgetGroupSetPhotoView *)cell.settingView).groupPortraitImageView.portraitImage = image;
                    }];
                }
            }
                break;
            case SettingCellContentTypeType:
            {
                NSString *type = nil;
                if (fieldValue && [fieldValue isKindOfClass:[NSNumber class]]) {
                    NSNumber *typeNumber = (NSNumber *)fieldValue;
                    type = [self getShareNameByType:typeNumber];
                }
                ((BudgetGroupSetTypeView *)cell.settingView).groupTypeLabel.text = type;
            }
                break;
            case SettingCellContentTypeResource:
            {
                if ([CommonUtils objectIsValid:fieldValue]) {
                    ((BudgetGroupSetResourceView *)cell.settingView).groupResourceLabel.text = curGroup.mTargetName;
                }
            }
                break;
            case SettingCellContentTypeBudget:
            {
                if (fieldValue && [fieldValue isKindOfClass:[NSNumber class]]) {
                    ((BudgetGroupSetBudgetView *)cell.settingView).groupBudgetLabel.text = [self convertBudgetValue:[(NSNumber *)fieldValue longLongValue] unit:curGroup.mUnit];
                }
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark tools method
- (NSString *)getShareNameByType:(NSNumber *)shareType {
    NSString *name = nil;
    if (shareType) {
        if ([shareType integerValue] == BudgetGroupTypeTypeShareWallet) {
            name = NSLocalizedString(@"Budget_Group_Share_Type_Wallet", nil);
        } else if ([shareType integerValue] == BudgetGroupTypeTypeShareUsage) {
            name = NSLocalizedString(@"Budget_Group_Share_Type_Usage", nil);
        }
    }
    return name;
}

- (SettingCellContentType)cellTypeAtIndexPath:(NSIndexPath *)indexPath {
    SettingCellContentType type = SettingCellContentTypeNormal;
    if (indexPath) {
        switch (indexPath.row) {
            case 0:
                type = SettingCellContentTypeName;
                break;
            case 1:
                type = SettingCellContentTypePhoto;
                break;
            case 2:
                type = SettingCellContentTypeType;
                break;
            case 3:
            {
                if ([self isCurrentGroupShareUsage]) {
                    type = SettingCellContentTypeResource;
                } else {
                    type = SettingCellContentTypeBudget;
                }
            }
                break;
            case 4:
                type = SettingCellContentTypeBudget;
                break;
            default:
                type = SettingCellContentTypeNormal;
                break;
        }
    }
    return type;
}

- (BOOL)editableByType:(SettingCellContentType)type {
    return (type == SettingCellContentTypeType || type == SettingCellContentTypeResource) ? NO : (groupType == GroupTypeCreated ? YES : NO) ;
}

- (void)setBgStyle:(BudgetGroupSettingCell *)cell editable:(BOOL)edit {
    //normal
    UIView *unselectedView = [[UIView alloc] initWithFrame:cell.frame];
    unselectedView.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    cell.backgroundView = unselectedView;
    [unselectedView release];

    //selected
    if (edit) {
        UIView *selectedView = [[UIView alloc] initWithFrame:cell.frame];
        selectedView.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
        cell.selectedBackgroundView = selectedView;
        [selectedView release];
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

- (void)launchImagePickerBySourceType:(UIImagePickerControllerSourceType)type {
    UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
    imagePickerVC.sourceType = type;
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    [imagePickerVC release];
}

- (BudgetFieldEditStyle)getBudgetFieldEditStyle {
    BudgetFieldEditStyle style = BudgetFieldEditStyleAlert;
    NSMutableDictionary *cellDict = [datasArray objectAtIndex:2];
    if (cellDict) {
        id value = [cellDict objectForKey:BUDGET_FIELD_VALUE_KEY];
        if (value && [value isKindOfClass:[NSNumber class]]) {
            NSNumber *fieldValue = (NSNumber *)value;
            if ([fieldValue integerValue] == BudgetGroupTypeTypeShareUsage) {
                style = BudgetFieldEditStylePicker;
            } else {
                style = BudgetFieldEditStyleAlert;
            }
        }
    }
    return style;
}

//用于budget值的显示
- (NSString *)convertBudgetValue:(long long)amount unit:(MeasureUnit)unit {
    CGFloat value = [CommonUtils getUnitConverteValue:amount AndUnit:unit];
    NSString *unitName = [CommonUtils getUnitName:unit];
    NSString *budgetValue = nil;
    if ([self isCurrentGroupShareUsage]) {
        budgetValue = [NSString stringWithFormat:@"%.0f %@",value,unitName];
    } else {
        budgetValue = [NSString stringWithFormat:@"%@ %0.f",unitName,value];
    }
    return budgetValue;
}

- (BOOL)isCurrentGroupShareUsage {
    BOOL isShareUsage = NO;
    if (self.curGroup) {
        if (curGroup.mType == BudgetGroupTypeTypeShareUsage) {
            isShareUsage = YES;
        } else if (curGroup.mType == BudgetGroupTypeTypeShareWallet) {
            isShareUsage = NO;
        }
    }
    return isShareUsage;
}

- (NSString *)getResourceNameByType:(NSNumber *)resourceType {
    NSString *name = nil;
    @try {
        if (resourceType) {
            NSInteger unit = [resourceType integerValue];
            switch (unit) {
                case UnitForDataAmount:
                    name = NSLocalizedString(@"Budget_Group_Resource_Data", nil);
                    break;
                case UnitForMessageAmount:
                    name = NSLocalizedString(@"Budget_Group_Resource_Msg", nil);
                    break;
                case UnitForTime:
                    name = NSLocalizedString(@"Budget_Group_Resource_Voice", nil);
                    break;
                default:
                    break;
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"manage:getResourceNameByType==%@",exception);
    }
    return name;
}

- (NSString *)getBudgetUnit {
    NSString *unitStr = nil;
    if ([self isCurrentGroupShareUsage]) {
        unitStr = [CommonUtils getUnitName:curGroup.mUnit];
    } else {
        unitStr = NSLocalizedString(@"Currency_Unit", nil);
    }
    return unitStr;
}

- (CGFloat)getBudgetUnitWidthByUnit:(MeasureUnit)unit {
    CGFloat width = 10.0;
    switch (unit) {
        case UnitForMoney:
        {
            width = 10.0;
        }
            break;
        case UnitForDataAmount:
        {
            width = 20.0;
        }
            break;
        case UnitForMessageAmount:
        {
            width = 22.0;
        }
            break;
        case UnitForTime:
        {
            width = 22.0;
        }
            break;
        default:
            break;
    }
    return width;
}

#pragma mark budget members view delegate
- (void)budgetGroupMemberViewDidClickedAddButton:(BudgetGroupMemberView *)mbsView {
    NSLog(@"vc===budget clicked add button");
    if (self.curGroup) {
        BudgetAddMembersViewController *addVC = [[BudgetAddMembersViewController alloc] init];
        addVC.currentGroup = self.curGroup;
        addVC.fromType = EnterTypeFromManage;
        [self.navigationController pushViewController:addVC animated:YES];
        [addVC release];
    } else {
        NSLog(@"buget group invalid");
    }
}

- (void)budgetGroupMemberView:(BudgetGroupMemberView *)mbView didDeleteMemberAtIndex:(NSInteger)index {
    NSLog(@"vc===budget delete member at index %d",index);
    @try {
        [mbView deleteMembersFromMembersViewAtIndex:index];
        
        [self refreshMembersView];
    }
    @catch (NSException *exception) {
        NSLog(@"budgetGroupMemberView==didDeleteMemberAtIndex exception===%@",exception);
    }
}

- (void)budgetGroupMemberView:(BudgetGroupMemberView *)mbView didSelectMemberAtIndex:(NSInteger)index {
    NSLog(@"vc===budget select member at index %d",index);
    @try {
        if ([CommonUtils objectIsValid:membersArray]) {
            Subscriber *member = [membersArray objectAtIndex:index];
            MemberBudget *budget = nil;
            if (member && [CommonUtils objectIsValid:member.mId]) {
                if ([CommonUtils objectIsValid:curGroup.mMemberBudgets]) {
                    budget = [curGroup.mMemberBudgets objectForKey:member.mId];
                }
                if (curGroup) {
                    BudgetDetailViewController *detailVC = [[BudgetDetailViewController alloc] init];
                    detailVC.editable = groupType == GroupTypeCreated ? YES : NO;
                    detailVC.currentMember = member;
                    detailVC.currentGroup = curGroup;
                    detailVC.currentBudget = budget;
                    [self.navigationController pushViewController:detailVC animated:YES];
                    [detailVC release];
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"budget manage member select exception");
    }
}

#pragma mark alert delegate
- (void)alertController:(AlertController *)alertController didDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch (alertController.tag) {
        case AlertTypeSetGroupName:
        {
            if (buttonIndex == alertController.firstOtherButtonIndex) {
                UITextField *field = [alertController textFieldAtIndex:0];
                if (field.text.length <= 0) {
                    [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Budget_Group_Name_Empty_Message", nil)];
                } else {
                    [self updateSettingCellWithData:field.text cellType:SettingCellContentTypeName];
                }
            }
        }
            break;
        case AlertTypeSetGroupBudget:
        {
            if (buttonIndex == alertController.firstOtherButtonIndex) {
                UITextField *field = [alertController textFieldAtIndex:0];
                if (field.text.length <= 0 ) {
                    [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Budget_Group_Budget_Empty_Message", nil)];
                } else {
                    long long budget = [field.text longLongValue];
                    NSNumber *budgetNumber = [NSNumber numberWithLongLong:[CommonUtils convertCurrentValue:budget toTargetUnit:curGroup.mUnit]];
                    [self updateSettingCellWithData:budgetNumber cellType:SettingCellContentTypeBudget];
                }
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark action sheet delegate
- (void)actionSheetController:(ActionSheetController *)controller didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == controller.firstOtherButtonIndex) {
        [self launchImagePickerBySourceType:UIImagePickerControllerSourceTypeCamera];
    } else if (buttonIndex == controller.firstOtherButtonIndex + 1) {
        [self launchImagePickerBySourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

#pragma mark single picker delegate

#pragma mark image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^ {
        if (info) {
            UIImage *selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
            if (selectedImage) {
                UIImage *newImage = [ImageUtils scaleImage:selectedImage scaleWidth:150.0];
                [self updateSettingCellWithData:newImage cellType:SettingCellContentTypePhoto];
            }
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateSettingCellWithData:(id)data cellType:(SettingCellContentType)type {
    if (data) {
        NSMutableDictionary *cellDict = nil;
        NSIndexPath *cellIndexPath = nil;
        switch (type) {
            case SettingCellContentTypeName:
            {
                cellDict = [datasArray objectAtIndex:0];
                [cellDict setObject:(NSString *)data forKey:BUDGET_FIELD_VALUE_KEY];
                cellIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                
            }
                break;
            case SettingCellContentTypePhoto:
            {
                cellDict = [datasArray objectAtIndex:1];
                [cellDict setObject:(UIImage *)data forKey:BUDGET_FIELD_VALUE_KEY];
                cellIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            }
                break;
            case SettingCellContentTypeType:
            {
//                cellDict = [datasArray objectAtIndex:2];
//                [cellDict setObject:(NSNumber *)data forKey:BUDGET_FIELD_VALUE_KEY];
//                cellIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            }
                break;
            case SettingCellContentTypeResource:
            {
//                cellDict = [datasArray objectAtIndex:3];
//                [cellDict setObject:(NSNumber *)data forKey:BUDGET_FIELD_VALUE_KEY];
//                cellIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
            }
                break;
            case SettingCellContentTypeBudget:
            {
                NSInteger rowIndex = [self isCurrentGroupShareUsage] ? 4 : 3;
                cellDict = [datasArray objectAtIndex:rowIndex];
                [cellDict setObject:(NSNumber *)data forKey:BUDGET_FIELD_VALUE_KEY];
                cellIndexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
            }
            default:
                break;
        }
        [groupManageTableView reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark load data
- (void)loadData {
//    [self fakeData];
    [self loadGroupData];
    [self loadTableHeaderView];
}

- (void)loadGroupData {
    if (self.curGroup) {
        self.membersArray = curGroup.mMembers;
        self.datasArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        int rowCount = [self isCurrentGroupShareUsage] ? 5 : 4;
        for (int i = 0; i < rowCount; i ++) {
            NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
            switch (i) {
                case 0:
                {
                    [dataDict setObject:NSLocalizedString(@"Budget_Group_Name", nil) forKey:BUDGET_FIELD_NAME_KEY];
                    if ([CommonUtils objectIsValid:curGroup.mGroupName]) {
                        [dataDict setObject:curGroup.mGroupName forKey:BUDGET_FIELD_VALUE_KEY];
                    }
                }
                    break;
                case 1:
                {
                    [dataDict setObject:NSLocalizedString(@"Budget_Group_Photo", nil) forKey:BUDGET_FIELD_NAME_KEY];
                    if ([CommonUtils objectIsValid:curGroup.mIcon]) {
                        [dataDict setObject:curGroup.mIcon forKey:BUDGET_FIELD_VALUE_KEY];
                    }

                }
                    break;
                case 2:
                {
                    [dataDict setObject:NSLocalizedString(@"Budget_Group_Type", nil) forKey:BUDGET_FIELD_NAME_KEY];
                    [dataDict setObject:[NSNumber numberWithInteger:curGroup.mType] forKey:BUDGET_FIELD_VALUE_KEY];

                }
                    break;
                case 3:
                {
                    if (rowCount == 4) {
                        [dataDict setObject:NSLocalizedString(@"Budget_Group_Budget", nil) forKey:BUDGET_FIELD_NAME_KEY];
                        [dataDict setObject:[NSNumber numberWithLongLong:curGroup.mGroupBudget] forKey:BUDGET_FIELD_VALUE_KEY];
                    } else {
                        [dataDict setObject:NSLocalizedString(@"Budget_Group_Resource", nil) forKey:BUDGET_FIELD_NAME_KEY];
                        if ([CommonUtils objectIsValid:curGroup.mTargetName]) {
                            [dataDict setObject:curGroup.mTargetName forKey:BUDGET_FIELD_VALUE_KEY];
                        }
                    }
                }
                    break;
                case 4:
                {
                    [dataDict setObject:NSLocalizedString(@"Budget_Group_Budget", nil) forKey:BUDGET_FIELD_NAME_KEY];
                    [dataDict setObject:[NSNumber numberWithLongLong:curGroup.mGroupBudget] forKey:BUDGET_FIELD_VALUE_KEY];
                }
                    break;
                default:
                    break;
            }
            [datasArray addObject:dataDict];
            [dataDict release];
        }
    }
}
    
- (void)fakeData {
    self.membersArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    NSArray *membersName = @[@"John",@"Lucy",@"Kite",@"Job",@"Bob"];
    for (int i = 0; i < 5; i ++) {
        Subscriber *subscriber = [[Subscriber alloc] init];
        subscriber.mName = [membersName objectAtIndex:i];
        [membersArray addObject:subscriber];
    }
    self.datasArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    for (int i = 0; i < 4; i++) {
        NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
        if (i == 0) {
            [dataDict setObject:NSLocalizedString(@"Budget_Group_Name", nil) forKey:BUDGET_FIELD_NAME_KEY];
            [dataDict setObject:@"John's family" forKey:@"fieldValue"];
        } else if (i == 1) {
            [dataDict setObject:NSLocalizedString(@"Budget_Group_Photo", nil) forKey:BUDGET_FIELD_NAME_KEY];
        } else if (i == 2) {
            [dataDict setObject:NSLocalizedString(@"Budget_Group_Type", nil) forKey:BUDGET_FIELD_NAME_KEY];
            [dataDict setObject:[NSNumber numberWithInteger:BudgetGroupTypeTypeShareWallet] forKey:BUDGET_FIELD_VALUE_KEY];
        } else if (i == 3) {
            [dataDict setObject:NSLocalizedString(@"Budget_Group_Budget", nil) forKey:BUDGET_FIELD_NAME_KEY];
            [dataDict setObject:[NSString stringWithFormat:@"%@%d",NSLocalizedString(@"Currency_Unit", nil),400] forKey:BUDGET_FIELD_VALUE_KEY];
        }
        [datasArray addObject:dataDict];
        [dataDict release];
    }
}

@end

