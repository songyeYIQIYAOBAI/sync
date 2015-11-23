//
//  BudgetCreateViewController.m
//  RTSS
//
//  Created by 加富董 on 15/1/18.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "BudgetCreateViewController.h"
#import "BudgetAddMembersViewController.h"
#import "BudgetManageViewController.h"
#import "BudgetGroupSettingCell.h"
#import "BudgetGroupSettingView.h"
#import "PortraitImageView.h"
#import "Cache.h"
#import "AlertController.h"
#import "ActionSheetController.h"
#import "SinglePickerController.h"
#import "CommonUtils.h"
#import "ImageUtils.h"
#import "BudgetGroup.h"
#import "Session.h"
#import "Subscriber.h"
#import "RTSSNotificationCenter.h"
#import "ProductResource.h"
#import "Product.h"

#define BUDGET_CREATE_SEP_HEADER_HEIGHT 23.0
#define BUDGET_CREATE_SUBMIT_FOOTER_HEIGHT 110.0
#define BUDGET_CREATE_SUBMIT_BUTTON_OFFSET_Y 45.0
#define BUDGET_CREATE_SUBMIT_BUTTON_OFFSET_X 35.0
#define BUDGET_CREATE_SUBMIT_BUTTON_HEIGHT 45.0
#define BUDGET_CREATE_SUBMIT_BUTTON_CORNER_RADIUS 5.0

@interface BudgetCreateViewController () <UITableViewDataSource, UITableViewDelegate, AlertControllerDelegate,ActionSheetControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,SinglePickerDelegate> {
    UITableView *groupSettingTableView;
    UIView *seperatorHeaderView;
    UIView *submitFooterView;
    UIView *contentView;
}

@property (nonatomic, retain) NSMutableArray *datasArray;
@property (nonatomic, retain) SinglePickerController *resourcePicker;
@property (nonatomic, retain) SinglePickerController *typePicker;
@property (nonatomic, retain) BudgetGroup *newGroup;
@property (nonatomic, retain) NSMutableArray *resourceTypeArray;
@property (nonatomic, retain) NSArray *productResourceArray;

@end

@implementation BudgetCreateViewController

@synthesize datasArray;
@synthesize resourcePicker;
@synthesize typePicker;
@synthesize newGroup;
@synthesize resourceTypeArray;
@synthesize productResourceArray;

#pragma mark dealloc
- (void)dealloc {
    [groupSettingTableView release];
    [datasArray release];
    [resourcePicker release];
    [typePicker release];
    [seperatorHeaderView release];
    [submitFooterView release];
    [contentView release];
    [newGroup release];
    [resourceTypeArray release];
    [productResourceArray release];
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

#pragma mark --load view
- (void)loadNavBarView {
    navigationBarView = [self addNavigationBarView:NSLocalizedString(@"Budget_Create_Title", nil) bgColor:[[RTSSAppStyle currentAppStyle] navigationBarColor] separator:YES];
    [self.view addSubview:navigationBarView];
}

- (void)loadContentView {
    CGRect contentRect = CGRectMake(0.0, CGRectGetMaxY(navigationBarView.frame), PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT - CGRectGetMaxY(navigationBarView.frame));
    contentView = [[UIView alloc] initWithFrame:contentRect];
    contentView.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    [self.view addSubview:contentView];
    
    [self loadSeperatorHeaderView];
    [self loadGroupSettingTableView];
    [self loadSubmitFooterView];
}

- (void)loadSeperatorHeaderView {
    if (seperatorHeaderView == nil) {
        CGRect headerRect = CGRectMake(0.0, 0.0, PHONE_UISCREEN_WIDTH, BUDGET_CREATE_SEP_HEADER_HEIGHT);
        seperatorHeaderView = [[UIView alloc] initWithFrame:headerRect];
        seperatorHeaderView.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
        [contentView addSubview:seperatorHeaderView];
        
        //sep line
        CGRect sepRect = CGRectMake(0.0, CGRectGetHeight(seperatorHeaderView.frame) - SEPERATOR_LINE_HEIGHT, PHONE_UISCREEN_WIDTH, SEPERATOR_LINE_HEIGHT);
        UIImageView *sepLine = [[UIImageView alloc] initWithFrame:sepRect];
        sepLine.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
        [seperatorHeaderView addSubview:sepLine];
        [sepLine release];
    }
}

- (void)loadGroupSettingTableView {
    if (groupSettingTableView == nil) {
        CGRect tableRect = CGRectMake(0.0, CGRectGetMaxY(seperatorHeaderView.frame), PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT - CGRectGetMaxY(seperatorHeaderView.frame));
        groupSettingTableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
        groupSettingTableView.backgroundColor = [UIColor clearColor];
        groupSettingTableView.rowHeight = SETTING_CELL_HEIGHT;
        groupSettingTableView.showsHorizontalScrollIndicator = NO;
        groupSettingTableView.showsVerticalScrollIndicator = YES;
        groupSettingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        groupSettingTableView.delegate = self;
        groupSettingTableView.dataSource = self;
        [contentView addSubview:groupSettingTableView];
    }
}

- (void)loadSubmitFooterView {
    if (submitFooterView == nil) {
        CGRect footerRect = CGRectMake(0.0, 0.0, PHONE_UISCREEN_WIDTH, BUDGET_CREATE_SUBMIT_FOOTER_HEIGHT);
        submitFooterView = [[UIView alloc] initWithFrame:footerRect];
        submitFooterView.backgroundColor = [UIColor clearColor];
        
        //submit button
        CGRect submitRect = CGRectMake(BUDGET_CREATE_SUBMIT_BUTTON_OFFSET_X, BUDGET_CREATE_SUBMIT_BUTTON_OFFSET_Y, CGRectGetWidth(submitFooterView.frame) - BUDGET_CREATE_SUBMIT_BUTTON_OFFSET_X * 2.0, BUDGET_CREATE_SUBMIT_BUTTON_HEIGHT);
        
        UIButton *submitButton = [RTSSAppStyle getMajorGreenButton:submitRect target:self action:@selector(submitButtonClicked:) title:NSLocalizedString(@"Budget_Group_Create_Submit", nil)];
        
        [submitFooterView addSubview:submitButton];
        groupSettingTableView.tableFooterView = submitFooterView;
    }
}

#pragma mark button clicked
- (void)submitButtonClicked:(UIButton *)button {
    NSLog(@"submit button clicked");
    Session *session = [Session sharedSession];
    Subscriber *sub = session.mCurrentSubscriber;
    if (sub) {
        id name = [self getFieldValueByContentType:SettingCellContentTypeName];
        if (name && [name isKindOfClass:[NSString class]] && [CommonUtils objectIsValid:name]) {
            NSString *nameValue = (NSString *)name;
            id type = [self getFieldValueByContentType:SettingCellContentTypeType];
            if (type && [type isKindOfClass:[NSNumber class]]) {
                NSInteger typeValue = BudgetGroupTypeTypeShareWallet;
                NSNumber *typeNumber = (NSNumber *)type;
                id budget = [self getFieldValueByContentType:SettingCellContentTypeBudget];
                if (budget && [budget isKindOfClass:[NSNumber class]]) {
                    long long budgetValue = [budget longLongValue];
                    if ([typeNumber integerValue] == BudgetGroupTypeTypeShareWallet) {
                        typeValue = BudgetGroupTypeTypeShareWallet;
                        self.newGroup = [sub createBudgetGroup:nameValue forAccount:sub.mDefaultAccount withBudget:budgetValue];
                    } else {
                        typeValue = BudgetGroupTypeTypeShareUsage;
                        id resource = [self getFieldValueByContentType:SettingCellContentTypeResource];
                        if (resource && [resource isKindOfClass:[ProductResource class]]) {
                            self.newGroup = [sub createBudgetGroup:nameValue forResource:(ProductResource *)resource withBudget:budgetValue];

                        } else {
                            [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Budget_Group_Resource_Empty_Message", nil)];
                        }
                    }
                } else {
                    [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Budget_Group_Budget_Empty_Message", nil)];
                }
                if (self.newGroup) {
                    //post refresh notify
                   // [[RTSSNotificationCenter standardRTSSNotificationCenter] postNotificationWithType:RTSSNotificationTypeBudgetGroupListRefresh object:nil userInfo:nil];
                    
                    //add members
                    BudgetAddMembersViewController *addVC = [[BudgetAddMembersViewController alloc] init];
                    addVC.currentGroup = self.newGroup;
                    addVC.fromType = EnterTypeFromCreate;
                    [self.navigationController pushViewController:addVC animated:YES];
                    [addVC release];
                } else {
                    NSLog(@"create budget submit failed");
                    [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Budget_Group_Create_Failed", nil)];
                }
            } else {
                [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Budget_Group_Type_Empty_Message", nil)];
            }
        } else {
            [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Budget_Group_Name_Empty_Message", nil)];
        }
    }
}

- (id)getFieldValueByContentType:(SettingCellContentType)type {
    id value = nil;
    if ([CommonUtils objectIsValid:self.datasArray]) {
        NSDictionary *dict = nil;
        @try {
            switch (type) {
                case SettingCellContentTypeName:
                {
                    dict = [datasArray objectAtIndex:0];
                }
                    break;
                case SettingCellContentTypePhoto:
                {
                    dict = [datasArray objectAtIndex:1];
                }
                    break;
                case SettingCellContentTypeType:
                {
                    dict = [datasArray objectAtIndex:2];
                }
                    break;
                case SettingCellContentTypeResource:
                {
                    if ([self isCurrentGroupShareUsage]) {
                        dict = [datasArray objectAtIndex:3];
                    }
                }
                    break;
                case SettingCellContentTypeBudget:
                {
                    if ([self isCurrentGroupShareUsage]) {
                        dict = [datasArray objectAtIndex:4];
                    } else {
                        dict = [datasArray objectAtIndex:3];
                    }
                }
                default:
                    break;
            }
            if ([CommonUtils objectIsValid:dict]) {
                value = [dict objectForKey:BUDGET_FIELD_VALUE_KEY];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"pick up budget group field value exception");
        }
    }
    return value;
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
    [settingCell loadContentViewsByType:type editable:YES];
    [self layoutSettingCell:settingCell indexPath:indexPath];
    [self setBgStyle:settingCell editable:YES];
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
                if (typePicker == nil) {
                    self.typePicker = [[[SinglePickerController alloc] init] autorelease];
                    typePicker.delegate = self;
                    typePicker.pickerType = SinglePickerTypeDefault;
                    NSMutableArray *dataSource = [NSMutableArray array];
                    NSString *value1 = [self getShareNameByType:[NSNumber numberWithInteger:BudgetGroupTypeTypeShareWallet]];
                    if (value1) {
                        [dataSource addObject:value1];
                    }
                    NSString *value2 = [self getShareNameByType:[NSNumber numberWithInteger:BudgetGroupTypeTypeShareUsage]];
                    if (value2) {
                        [dataSource addObject:value2];
                    }
                    typePicker.pickerArrayData = dataSource;
                    typePicker.view.tag = PickerTypeSetGroupType;
                 }
                [self.view.window addSubview:typePicker.view];

            }
                break;
            case SettingCellContentTypeResource:
            {
                if ([CommonUtils objectIsValid:self.productResourceArray]) {
                    if (resourcePicker == nil) {
                        self.resourcePicker = [[[SinglePickerController alloc] init] autorelease];
                        resourcePicker.delegate = self;
                        resourcePicker.pickerType = SinglePickerTypeDefault;
                        NSMutableArray *resources = [NSMutableArray array];
                        for (int i = 0; i < [productResourceArray count]; i ++) {
                            ProductResource *resource = [productResourceArray objectAtIndex:i];
                            NSString *reourceName= resource.mName;
                            if ([CommonUtils objectIsValid:reourceName]) {
                                [resources addObject:reourceName];
                            }
                        }
                        resourcePicker.pickerArrayData = resources;
                        resourcePicker.view.tag = PickerTypeSetResourceType;
                    }
                    [self.view.window addSubview:resourcePicker.view];
                }
            }
                break;
            case SettingCellContentTypeBudget:
            {
                NSString *alertLeftStr = [self getBudgetUnit];
                AlertController *alert = [[AlertController alloc] initWithTitle:nil message:NSLocalizedString(@"Budget_Group_Alert_Title_Set_Budget_Message", nil) delegate:self tag:AlertTypeSetGroupBudget cancelButtonTitle:NSLocalizedString(@"UIAlertView_Cancel_String", nil) otherButtonTitles:NSLocalizedString(@"UIAlertView_Confirm_String", nil),nil];
                
                UILabel* leftLabel = [CommonUtils labelWithFrame:CGRectMake(0, 0, [self getBudgetUnitWidthByUnit:[self getCurrentBudgetMeasureUnit]], 30) text:alertLeftStr textColor:[RTSSAppStyle currentAppStyle].textSubordinateColor textFont:[UIFont systemFontOfSize:10.0] tag:20];
                leftLabel.textAlignment = NSTextAlignmentCenter;
                leftLabel.backgroundColor = [UIColor clearColor];
                
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
                NSString *value = nil;
                if (fieldValue && [fieldValue isKindOfClass:[NSNumber class]]) {
                    NSNumber *type = (NSNumber *)fieldValue;
                    value = [self getShareNameByType:type];
                }
                ((BudgetGroupSetTypeView *)cell.settingView).groupTypeLabel.text = value;
            }
                break;
            case SettingCellContentTypeResource:
            {
                if (fieldValue && [fieldValue isKindOfClass:[ProductResource class]]) {
                    NSString *resourceName = [(ProductResource *)fieldValue mName];
                    if ([CommonUtils objectIsValid:resourceName]) {
                        ((BudgetGroupSetResourceView *)cell.settingView).groupResourceLabel.text = resourceName;
                    }
                }
            }
                break;
            case SettingCellContentTypeBudget:
            {
                NSString *budgetStr = nil;
                if (fieldValue && [fieldValue isKindOfClass:[NSNumber class]]) {
                    budgetStr = [self formatBudgetFieldValue:fieldValue];
                } else {
                    budgetStr = [self formatBudgetFieldValue:[NSNumber numberWithLongLong:0]];
                }
                ((BudgetGroupSetBudgetView *)cell.settingView).groupBudgetLabel.text = budgetStr;
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark tools method
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
        NSLog(@"create:getResourceNameByType==%@",exception);
    }
    return name;
}

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

- (NSNumber *)getShareTypeByName:(NSString *)shareName {
    NSNumber *type = nil;
    if (shareName) {
        if ([shareName isEqualToString:NSLocalizedString(@"Budget_Group_Share_Type_Wallet", nil)]) {
            type = [NSNumber numberWithInteger:BudgetGroupTypeTypeShareWallet];
        } else if ([shareName isEqualToString:NSLocalizedString(@"Budget_Group_Share_Type_Usage", nil)]) {
            type = [NSNumber numberWithInteger:BudgetGroupTypeTypeShareUsage];
        }
    }
    return type;
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
                type = SettingCellContentTypeBudget;
                if ([self isCurrentGroupShareUsage]) {
                    type = SettingCellContentTypeResource;
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

- (BOOL)isCurrentGroupShareUsage {
    BOOL isShareUsage = NO;
    @try {
        NSDictionary *cellDict = [datasArray objectAtIndex:2];
        if ([CommonUtils objectIsValid:cellDict]) {
            id cellValue = [cellDict objectForKey:BUDGET_FIELD_VALUE_KEY];
            if (cellValue && [cellValue isKindOfClass:[NSNumber class]]) {
                NSNumber *cellNum = (NSNumber *)cellValue;
                if (cellNum) {
                    if ([cellNum integerValue] == BudgetGroupTypeTypeShareUsage) {
                        isShareUsage = YES;
                    } else if ([cellNum integerValue] == BudgetGroupTypeTypeShareWallet) {
                        isShareUsage = NO;
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"isCurrentGroupShareUsage exception %@",exception);
    }
    return isShareUsage;
}

- (MeasureUnit)getCurrentBudgetMeasureUnit {
    MeasureUnit unit = UnitForMoney;
    if (![self isCurrentGroupShareUsage]) {
        unit = UnitForMoney;
    } else {
        @try {
            NSDictionary *cellData = [datasArray objectAtIndex:3];
            if ([CommonUtils objectIsValid:cellData]) {
                id cellValue = [cellData objectForKey:BUDGET_FIELD_VALUE_KEY];
                if (cellValue && [cellValue isKindOfClass:[ProductResource class]]) {
                    unit = ((ProductResource *)cellValue).mUnit;
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"getCurrentBudgetMeasureUnit exception==%@",exception);
        }
    }
    return unit;
}

- (NSString *)getBudgetUnit {
    return [CommonUtils getUnitName:[self getCurrentBudgetMeasureUnit]];
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

- (NSString *)formatBudgetFieldValue:(NSNumber *)value {
    NSString *fieldValue = nil;
    @try {
        if (value && [value isKindOfClass:[NSNumber class]]) {
            if ([self isCurrentGroupShareUsage]) {
                fieldValue = [NSString stringWithFormat:@"%.0f %@",[CommonUtils getUnitConverteValue:[value longLongValue] AndUnit:[self getCurrentBudgetMeasureUnit]],[self getBudgetUnit]];
            } else {
                fieldValue = [NSString stringWithFormat:@"%@ %.0f",[self getBudgetUnit],[CommonUtils getUnitConverteValue:[value longLongValue] AndUnit:[self getCurrentBudgetMeasureUnit]]];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"formatBudgetFieldValue ==%@",exception);
    }
    
    return fieldValue;
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
                    NSNumber *budgetNumber = [NSNumber numberWithLongLong:[CommonUtils convertCurrentValue:budget toTargetUnit:[self getCurrentBudgetMeasureUnit]]];
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
- (void)singlePickerWithCancel:(SinglePickerController *)controller {
    [controller.view removeFromSuperview];
}

- (void)singlePickerWithDone:(SinglePickerController *)controller selectedIndex:(NSInteger)index {
    @try {
        NSLog(@"picker selected finished == %@",[controller.pickerArrayData objectAtIndex:index]);
        if (controller.view.tag == PickerTypeSetGroupType) {
            NSString *selectedVaule = [controller.pickerArrayData objectAtIndex:index];
            NSNumber *value = [self getShareTypeByName:selectedVaule];
            if (value) {
                [self updateSettingCellWithData:value cellType:SettingCellContentTypeType];
            }
        } else if (controller.view.tag == PickerTypeSetResourceType) {
            
            [self updateSettingCellWithData:[self.productResourceArray objectAtIndex:index] cellType:SettingCellContentTypeResource];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"singlePickerWithDone exception===%@",exception);
    }
    [controller.view removeFromSuperview];
}

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
        BOOL needRefresh = NO;
        NSMutableDictionary *cellDict = nil;
        NSIndexPath *cellIndexPath = nil;
        switch (type) {
            case SettingCellContentTypeName:
            {
                @try {
                    cellDict = [datasArray objectAtIndex:0];
                    if ([CommonUtils objectIsValid:(NSString *)data]) {
                        [cellDict setObject:(NSString *)data forKey:BUDGET_FIELD_VALUE_KEY];
                        cellIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                        [groupSettingTableView reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"update name exception");
                }
            }
                break;
            case SettingCellContentTypePhoto:
            {
                @try {
                    cellDict = [datasArray objectAtIndex:1];
                    [cellDict setObject:(UIImage *)data forKey:BUDGET_FIELD_VALUE_KEY];
                    cellIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                    [groupSettingTableView reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
                @catch (NSException *exception) {
                    NSLog(@"update photo exception");
                }
            }
                break;
            case SettingCellContentTypeType:
            {
                @try {
                    cellDict = [datasArray objectAtIndex:2];
                    if ([data isKindOfClass:[NSNumber class]]) {
                        NSNumber *current = (NSNumber *)data;
                        id formerV = [cellDict objectForKey:BUDGET_FIELD_VALUE_KEY];
                        if (formerV && [formerV isKindOfClass:[NSNumber class]]) {
                            NSNumber *former = (NSNumber *)formerV;
                            if (!([current integerValue] == [former integerValue])) {

                                //更新数据
                                [cellDict setObject:current forKey:BUDGET_FIELD_VALUE_KEY];
                                cellIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
                                [groupSettingTableView reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                                
                                if ([current integerValue] == BudgetGroupTypeTypeShareUsage) {
                                    //插入resource行
                                    [self updateGroupResourceData:YES];
                                    NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
                                    [groupSettingTableView insertRowsAtIndexPaths:@[rowIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
                                } else if ([current integerValue] == BudgetGroupTypeTypeShareWallet) {
                                    //删除resource行
                                    [self updateGroupResourceData:NO];
                                    NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
                                    [groupSettingTableView deleteRowsAtIndexPaths:@[rowIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
                                }
                                
                                NSInteger budgetCellIndex = [current integerValue] == BudgetGroupTypeTypeShareWallet ? 3 : 4;
                                //type changed,reset budget
                                NSMutableDictionary *dict = [datasArray objectAtIndex:budgetCellIndex];
                                [dict removeObjectForKey:BUDGET_FIELD_VALUE_KEY];
                                NSIndexPath *index = [NSIndexPath indexPathForRow:budgetCellIndex inSection:0];
                                [groupSettingTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
                                
                            } else {
                                needRefresh = NO;
                            }
                        } else {
                            [cellDict setObject:current forKey:BUDGET_FIELD_VALUE_KEY];
                            cellIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
                            [groupSettingTableView reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                        }
                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"update type exception");
                }
            }
                break;
            case SettingCellContentTypeResource:
            {
                @try {
                    cellDict = [datasArray objectAtIndex:3];
                    [cellDict setObject:data forKey:BUDGET_FIELD_VALUE_KEY];
                    cellIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
                    [groupSettingTableView reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                    
                    NSInteger budgetIndex = [self isCurrentGroupShareUsage] ? 4 : 3;
                    NSMutableDictionary *dict = [datasArray objectAtIndex:budgetIndex];
                    [dict removeObjectForKey:BUDGET_FIELD_VALUE_KEY];
                    NSIndexPath *budgetIndexPath = [NSIndexPath indexPathForRow:budgetIndex inSection:0];
                    [groupSettingTableView reloadRowsAtIndexPaths:@[budgetIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
                @catch (NSException *exception) {
                    NSLog(@"update resource exception");
                }
            }
                break;
            case SettingCellContentTypeBudget:
            {
                @try {
                    NSInteger rowNum = [self isCurrentGroupShareUsage] ? 4 : 3;
                    cellDict = [datasArray objectAtIndex:rowNum];
                    [cellDict setObject:(NSNumber *)data forKey:BUDGET_FIELD_VALUE_KEY];
                    cellIndexPath = [NSIndexPath indexPathForRow:rowNum inSection:0];
                    [groupSettingTableView reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
                @catch (NSException *exception) {
                    NSLog(@"update budget exception");
                }
            }
            default:
                break;
        }
    }
}

#pragma mark load data
- (void)loadData {
    [self fakeData];
    [self loadProductResources];
}

- (void)fakeData {
    self.datasArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    for (int i = 0; i < 4; i++) {
        NSMutableDictionary *dataDict = [[NSMutableDictionary alloc] init];
        if (i == 0) {
            [dataDict setObject:NSLocalizedString(@"Budget_Group_Name", nil) forKey:BUDGET_FIELD_NAME_KEY];
        } else if (i == 1) {
            [dataDict setObject:NSLocalizedString(@"Budget_Group_Photo", nil) forKey:BUDGET_FIELD_NAME_KEY];
        } else if (i == 2) {
            [dataDict setObject:NSLocalizedString(@"Budget_Group_Type", nil) forKey:BUDGET_FIELD_NAME_KEY];
            [dataDict setObject:[NSNumber numberWithInteger:BudgetGroupTypeTypeShareWallet] forKey:BUDGET_FIELD_VALUE_KEY];
        } else if (i == 3) {
            [dataDict setObject:NSLocalizedString(@"Budget_Group_Budget", nil) forKey:BUDGET_FIELD_NAME_KEY];
        }
        [datasArray addObject:dataDict];
        [dataDict release];
    }
}

- (void)updateGroupResourceData:(BOOL)insert {
    NSMutableDictionary *resourceDict = nil;
    @try {
        if (insert) {
            resourceDict = [[NSMutableDictionary alloc] initWithCapacity:0];
            [resourceDict setObject:NSLocalizedString(@"Budget_Group_Resource", nil) forKey:BUDGET_FIELD_NAME_KEY];
            if ([CommonUtils objectIsValid:self.productResourceArray]) {
                [resourceDict setObject:[productResourceArray objectAtIndex:0] forKey:BUDGET_FIELD_VALUE_KEY];
            }
            if ([CommonUtils objectIsValid:datasArray] && [datasArray count] == 4) {
                [datasArray insertObject:resourceDict atIndex:3];
            }
            [resourceDict release];
        } else {
            @try {
                if ([CommonUtils objectIsValid:datasArray] && [datasArray count] == 5) {
                    [datasArray removeObjectAtIndex:3];
                }
            }
            @catch (NSException *exception) {
                NSLog(@"budget create remove resource data exception");
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"budget create updateGroupResourceData exception===%@",exception);
    }
}

- (void)loadProductResources {
    @try {
        Session *curSession = [Session sharedSession];
        Subscriber *curSub = curSession.mCurrentSubscriber;
        if (curSub) {
            if ([CommonUtils objectIsValid:curSub.mProducts]) {
                Product *defaultProduct = [curSub.mProducts objectAtIndex:0];
                if (defaultProduct) {
                    NSArray *resources = defaultProduct.mResources;
                    if ([CommonUtils objectIsValid:resources]) {
                        self.productResourceArray = resources;
                    }
                }
            }
        }

    }
    @catch (NSException *exception) {
        NSLog(@"budget create loadProductResources exception == %@",exception);
    }
}

@end
