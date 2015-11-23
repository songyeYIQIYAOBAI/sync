//
//  BudgetDetailViewController.m
//  RTSS
//
//  Created by 加富董 on 15/2/3.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "BudgetDetailViewController.h"
#import "BudgetDetailCell.h"
#import "BudgetDetailView.h"
#import "RTSSAppDefine.h"
#import "RTSSAppStyle.h"
#import "CommonUtils.h"
#import "SinglePickerController.h"
#import "AlertController.h"
#import "Subscriber.h"
#import "MemberBudget.h"

#define DETAIL_CELL_HEIGHT 50.0
#define DETAIL_HEADER_HEIGHT 23.0
#define DETAIL_FOOTER_HEIGHT 110.0
#define DETAIL_SUBMIT_BUTTON_OFFSET_Y 45.0
#define DETAIL_SUBMIT_BUTTON_OFFSET_X 35.0
#define DETAIL_SUBMIT_BUTTON_HEIGHT 45.0
#define DETAIL_SUBMIT_BUTTON_CORNER_RADIUS 5.0
#define DETAIL_PROMPT_TEXT_FONT_SIZE 16.0
#define DETAIL_PROMPT_PADDING_X_LEFT 14.0
#define DETAIL_PROMPT_PADDING_X_RIGHT 14.0


#define DETAIL_FIELD_NAME_KEY @"name"
#define DETAIL_FIELD_VALUE_KEY @"value"

#define BUDGET_DETAIL_NAME_MAX_LENGTH 10

typedef NS_ENUM(NSInteger, BudgetDetailAlertType) {
    BudgetDetailAlertTypeSetBudget = 1,
    BudgetDetailAlertTypeSubmitted
};


@interface BudgetDetailViewController () <UITableViewDelegate, UITableViewDataSource, SinglePickerDelegate, AlertControllerDelegate, BudgetDetailCellDelegate>

@property (nonatomic, retain) NSMutableArray *detailDataArray;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UITableView *detailTableView;
@property (nonatomic, retain) UIView *detailHeaderView;
@property (nonatomic, retain) UIView *detailFooterView;
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) SinglePickerController *notifyPicker;

@end

@implementation BudgetDetailViewController

@synthesize detailDataArray;
@synthesize contentView;
@synthesize detailTableView;
@synthesize detailHeaderView;
@synthesize detailFooterView;
@synthesize submitButton;
@synthesize editable;
@synthesize notifyPicker;
@synthesize currentMember;
@synthesize currentGroup;
@synthesize currentBudget;

#pragma mark dealloc
- (void)dealloc {
    [detailDataArray release];
    [contentView release];
    [detailTableView release];
    [detailHeaderView release];
    [detailFooterView release];
    [notifyPicker release];
    [currentMember release];
    [currentBudget release];
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
    [self loadNavBar];
    [self loadContentViews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark load views
- (void)loadNavBar {
    NSString *title = nil;
    if (currentMember) {
        title = currentMember.mName;
    }
    self.view.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    navigationBarView = [self addNavigationBarView:title bgColor:[[RTSSAppStyle currentAppStyle] viewControllerBgColor] separator:YES];
    [self.view addSubview:navigationBarView];
}

- (void)loadContentViews {
    CGRect contentRect = CGRectMake(0.0, CGRectGetMaxY(navigationBarView.frame), PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT - CGRectGetMaxY(navigationBarView.frame));
    contentView = [[UIView alloc] initWithFrame:contentRect];
    contentView.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    [self.view addSubview:contentView];
    
    [self loadDetailTableView];
    if (editable) {
        [self loadFooterView];
    }
}

- (void)loadDetailTableView {
    if (detailTableView == nil) {
        CGRect tableRect = CGRectMake(0.0, 0.0, CGRectGetWidth(contentView.frame), CGRectGetHeight(contentView.frame));
        self.detailTableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
        detailTableView.backgroundColor = [UIColor clearColor];
        detailTableView.delegate = self;
        detailTableView.dataSource = self;
        detailTableView.rowHeight = DETAIL_CELL_HEIGHT;
        detailTableView.showsHorizontalScrollIndicator = NO;
        detailTableView.showsVerticalScrollIndicator = NO;
        detailTableView.allowsSelection = self.editable ? YES : NO;
        detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [contentView addSubview:detailTableView];
    }
}

- (void)loadHeaderView {
    if (detailHeaderView == nil) {
        CGRect headerRect = CGRectMake(0.0, 0.0, CGRectGetWidth(detailTableView.frame), DETAIL_HEADER_HEIGHT);
        detailHeaderView = [[UIView alloc] initWithFrame:headerRect];
        detailHeaderView.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
        
        //prompt label
        CGRect promptRect = CGRectMake(DETAIL_PROMPT_PADDING_X_LEFT, 0.0, CGRectGetWidth(detailHeaderView.frame) - DETAIL_PROMPT_PADDING_X_LEFT - DETAIL_PROMPT_PADDING_X_RIGHT, CGRectGetHeight(detailHeaderView.frame) - SEPERATOR_LINE_HEIGHT);
        UILabel *promptLabel = [CommonUtils labelWithFrame:promptRect text:NSLocalizedString(@"Budget_Detail_Prompt_Text", nil) textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textFont:[UIFont systemFontOfSize:DETAIL_PROMPT_TEXT_FONT_SIZE] tag:0];
        promptLabel.textAlignment = NSTextAlignmentLeft;
        promptLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [detailHeaderView addSubview:promptLabel];
        
        //sep line
        CGRect sepRect = CGRectMake(0.0, CGRectGetHeight(detailHeaderView.frame) - SEPERATOR_LINE_HEIGHT, CGRectGetWidth(detailHeaderView.frame), SEPERATOR_LINE_HEIGHT);
        UIImageView *sepImageView = [[UIImageView alloc] initWithFrame:sepRect];
        sepImageView.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
        [detailHeaderView addSubview:sepImageView];
        [sepImageView release];
    }
}

- (void)loadFooterView {
    if (detailFooterView == nil) {
        CGRect footerRect = CGRectMake(0.0, 0.0, CGRectGetWidth(detailTableView.frame), DETAIL_FOOTER_HEIGHT);
        detailFooterView = [[UIView alloc] initWithFrame:footerRect];
        detailFooterView.backgroundColor = [UIColor clearColor];
        
        //submit button
        CGRect buttonRect = CGRectMake(DETAIL_SUBMIT_BUTTON_OFFSET_X, DETAIL_SUBMIT_BUTTON_OFFSET_Y, CGRectGetWidth(detailFooterView.frame) - DETAIL_SUBMIT_BUTTON_OFFSET_X * 2.0, DETAIL_SUBMIT_BUTTON_HEIGHT);
        submitButton = [CommonUtils buttonWithType:UIButtonTypeCustom frame:buttonRect title:NSLocalizedString(@"Budget_Detail_Submit_Button_Title", nil) colorNormal:[[RTSSAppStyle currentAppStyle] commonGreenButtonNormalColor] colorHighlighted:[[RTSSAppStyle currentAppStyle] commonGreenButtonHighlightColor] colorSelected:[[RTSSAppStyle currentAppStyle] commonGreenButtonHighlightColor] addTarget:self action:@selector(submitButtonClicked:) tag:0];
        submitButton.layer.cornerRadius = DETAIL_SUBMIT_BUTTON_CORNER_RADIUS;
        submitButton.layer.masksToBounds = YES;
        [detailFooterView addSubview:submitButton];
    }
    detailTableView.tableFooterView = detailFooterView;
}

- (void)loadNotifyPicker {
    if (notifyPicker == nil) {
        notifyPicker = [[SinglePickerController alloc] init];
        notifyPicker.delegate = self;
        notifyPicker.pickerArrayData = @[@20,@40,@60,@80,@100];
        notifyPicker.pickerType = SinglePickerTypePercent;
    }
}


#pragma mark table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowCount = 0;
    if ([CommonUtils objectIsValid:self.detailDataArray]) {
        rowCount = [detailDataArray count];
    }
    return rowCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DETAIL_CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return DETAIL_HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (detailHeaderView == nil) {
        [self loadHeaderView];
    }
    return detailHeaderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"detailCell";
    BudgetDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (detailCell == nil) {
        detailCell = [[[BudgetDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId availableSize:CGSizeMake(PHONE_UISCREEN_WIDTH, DETAIL_CELL_HEIGHT)] autorelease];
        [self setBgStyle:detailCell];
    }
    DetailCellContentType type = [self cellTypeAtIndexPath:indexPath];
    BOOL interaction = (type == DetailCellContentTypeBar && self.editable == YES) ? YES : NO;
    if (interaction) {
        detailCell.delegate = self;
    }
    [detailCell loadContentViewsByType:type showArrow:[self showArrowAtIndexPath:indexPath] supportInteraction:interaction indexPath:indexPath];
    [self layoutDetailCell:detailCell cellIndexPath:indexPath];
    return detailCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"budget detail vc did clicked row at row = %d",indexPath.row);
    BudgetDetailCell *budgetCell = (BudgetDetailCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (budgetCell) {
        DetailCellContentType type = budgetCell.contentType;
        switch (type) {
            case DetailCellContentTypeBudget:
            {
                NSString *alertLeftStr = [CommonUtils getUnitName:currentGroup.mUnit];
                UILabel* leftLabel = [CommonUtils labelWithFrame:CGRectMake(0, 0, [self getBudgetUnitWidthByUnit:currentGroup.mUnit], 30) text:alertLeftStr textColor:[RTSSAppStyle currentAppStyle].textSubordinateColor textFont:[UIFont systemFontOfSize:10.0] tag:0];
                leftLabel.backgroundColor = [UIColor clearColor];
                leftLabel.textAlignment = NSTextAlignmentLeft;
                leftLabel.numberOfLines = 1;
                AlertController *alert = [[AlertController alloc] initWithTitle:nil message:NSLocalizedString(@"Budget_Detail_Set_Budget_Message", nil) delegate:self tag:BudgetDetailAlertTypeSetBudget cancelButtonTitle:NSLocalizedString(@"UIAlertView_Cancel_String", nil) otherButtonTitles:NSLocalizedString(@"UIAlertView_Confirm_String", nil),nil];
                [alert addTextFieldWithStyle:AlertControllerStylePlainTextInput holder:NSLocalizedString(@"UIAlertView_Input_holder", nil) leftView:leftLabel rightView:nil textLength:BUDGET_DETAIL_NAME_MAX_LENGTH textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textMode:AlertControllerTextModeNumber];
                [alert showInViewController:self];
                [alert release];
            }
                break;
            case DetailCellContentTypeNotify:
            {
                [self loadNotifyPicker];
                [self.view.window addSubview:notifyPicker.view];
            }
                break;
            case DetailCellContentTypeBar:
            {
                [self chageBudgetBarSelectedStatusAtIndexPath:indexPath];
            }
                break;
            default:
                break;
        }
    }
}

- (void)layoutDetailCell:(BudgetDetailCell *)detailCell cellIndexPath:(NSIndexPath *)indexPath {
    if (detailCell && indexPath && [CommonUtils objectIsValid:self.detailDataArray]) {
        NSDictionary *detailDict = [self.detailDataArray objectAtIndex:indexPath.row];
        if ([CommonUtils objectIsValid:detailDict]) {
            DetailCellContentType type = detailCell.contentType;
            NSString *fieldName = [detailDict objectForKey:DETAIL_FIELD_NAME_KEY];
            id fieldValue = [detailDict objectForKey:DETAIL_FIELD_VALUE_KEY];
            
            //field name
            detailCell.detailView.fieldNameLabel.text = fieldName;
            
            //field value
            switch (type) {
                case DetailCellContentTypeBudget:
                {
                    if (fieldValue && [fieldValue isKindOfClass:[NSNumber class]] && [(NSNumber *)fieldValue longLongValue] > 0) {
                        ((BudgetDetailBudgetView *)detailCell.detailView).budgetValueLabel.text = [self convertBudgetValue:[(NSNumber *)fieldValue longLongValue] unit:currentGroup.mUnit];
                    } else {
                        ((BudgetDetailBudgetView *)detailCell.detailView).budgetValueLabel.text = NSLocalizedString(@"Budget_Detail_Budget_Field_Holder", nil);
                    }
                }
                    break;
                case DetailCellContentTypeNotify:
                {
                    if (fieldValue && [fieldValue isKindOfClass:[NSNumber class]] && [(NSNumber *)fieldValue floatValue] > 0) {
                        ((BudgetDetailNotifyView *)detailCell.detailView).budgetNotifyLabel.text = [NSString stringWithFormat:@"%.0f%%",[(NSNumber *)fieldValue floatValue] * 100];
                    } else {
                        ((BudgetDetailNotifyView *)detailCell.detailView).budgetNotifyLabel.text = NSLocalizedString(@"Budget_Detail_Notify_Field_Holder", nil);
                    }

                }
                    break;
                case DetailCellContentTypeBar:
                {
                    //点击事件
                    if (fieldValue && [fieldValue isKindOfClass:[NSNumber class]]) {
                        if ([fieldValue boolValue]) {
                            ((BudgetDetailBarView *)detailCell.detailView).budgetBarButton.selected = YES;
                        } else {
                            ((BudgetDetailBarView *)detailCell.detailView).budgetBarButton.selected = NO;
                        }
                    } else {
                        ((BudgetDetailBarView *)detailCell.detailView).budgetBarButton.selected = NO;
                    }
                }
                    break;
                default:
                    break;
            }
        }
    }
}

#pragma mark single picker delegate
- (void)singlePickerWithCancel:(SinglePickerController *)controller {
    [controller.view removeFromSuperview];
}

- (void)singlePickerWithDone:(SinglePickerController *)controller selectedIndex:(NSInteger)index {
    @try {
        if (controller && [CommonUtils objectIsValid:controller.pickerArrayData]) {
            NSNumber *select = [controller.pickerArrayData objectAtIndex:index];
            NSNumber *realPercent = [NSNumber numberWithFloat:[select floatValue] / 100.0];
            if (realPercent) {
                [self updateDetailCellWithData:realPercent cellType:DetailCellContentTypeNotify];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"budget detail percent picker exception");
    }
    @finally {
        [controller.view removeFromSuperview];
    }
}

#pragma mark alert delegate
- (void)alertController:(AlertController *)alertController didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertController.firstOtherButtonIndex == buttonIndex) {
        UITextField *field = [alertController textFieldAtIndex:0];
        if (field.text.length <= 0) {
            [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Budget_Group_Budget_Empty_Message", nil)];
        } else {
            [self updateDetailCellWithData:field.text cellType:DetailCellContentTypeBudget];
        }
        
        if (field.text.length <= 0 ) {
            [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Budget_Group_Budget_Empty_Message", nil)];
        } else {
            long long budget = [field.text longLongValue];
            NSNumber *budgetNumber = [NSNumber numberWithLongLong:[CommonUtils convertCurrentValue:budget toTargetUnit:currentGroup.mUnit]];
            [self updateDetailCellWithData:budgetNumber cellType:DetailCellContentTypeBudget];
        }
    }
}

#pragma mark budget detail cell delegate
- (void)budgetDetailCell:(BudgetDetailCell *)detailCell didClickedActionButtonAtIndexPath:(NSIndexPath *)indexPath {
    if (detailCell && indexPath) {
        [self chageBudgetBarSelectedStatusAtIndexPath:indexPath];
    }
}

#pragma mark tools method
//用于budget值的显示
- (NSString *)convertBudgetValue:(long long)amount unit:(MeasureUnit)unit {
    CGFloat value = [CommonUtils getUnitConverteValue:amount AndUnit:unit];
    NSString *unitName = [CommonUtils getUnitName:unit];
    NSString *budgetValue = nil;
    if (currentGroup.mType == BudgetGroupTypeTypeShareUsage) {
        budgetValue = [NSString stringWithFormat:@"%.0f %@",value,unitName];
    } else {
        budgetValue = [NSString stringWithFormat:@"%@ %0.f",unitName,value];
    }
    return budgetValue;
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

- (DetailCellContentType)cellTypeAtIndexPath:(NSIndexPath *)indexPath {
    DetailCellContentType type = DetailCellContentTypeUnknown;
    if (indexPath) {
        switch (indexPath.row) {
            case 0:
                type = DetailCellContentTypeBudget;
                break;
            case 1:
                type = DetailCellContentTypeNotify;
                break;
            case 2:
                type = DetailCellContentTypeBar;
                break;
            default:
                type = DetailCellContentTypeUnknown;
                break;
        }
    }
    return type;
}

- (void)setBgStyle:(BudgetDetailCell *)cell {
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

- (BOOL)showArrowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL show = NO;
    DetailCellContentType type = [self  cellTypeAtIndexPath:indexPath];
    if (editable) {
        if (type == DetailCellContentTypeBar) {
            show = NO;
        } else {
            show = YES;
        }
    }
    return show;
}

- (void)chageBudgetBarSelectedStatusAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath) {
        BudgetDetailCell *detailCell = (BudgetDetailCell *)[detailTableView cellForRowAtIndexPath:indexPath];
        if (detailCell) {
            DetailCellContentType type = detailCell.contentType;
            if (type == DetailCellContentTypeBar) {
                ((BudgetDetailBarView *)detailCell.detailView).budgetBarButton.selected = !((BudgetDetailBarView *)detailCell.detailView).budgetBarButton.selected;
                NSNumber *status = ((BudgetDetailBarView *)detailCell.detailView).budgetBarButton.selected ? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO];
                [self updateDetailCellWithData:status cellType:DetailCellContentTypeBar];
            }
        }
    }
}

- (id)getFieldValueByContentType:(DetailCellContentType)type {
    id value = nil;
    if ([CommonUtils objectIsValid:detailDataArray]) {
        NSDictionary *dict = nil;
        @try {
            switch (type) {
                case DetailCellContentTypeBudget:
                {
                    dict = [detailDataArray objectAtIndex:0];
                }
                    break;
                case DetailCellContentTypeNotify:
                {
                    dict = [detailDataArray objectAtIndex:1];
                }
                    break;
                case DetailCellContentTypeBar:
                {
                    dict = [detailDataArray objectAtIndex:2];
                }
                    break;
                default:
                    break;
            }
            if ([CommonUtils objectIsValid:dict]) {
                value = [dict objectForKey:DETAIL_FIELD_VALUE_KEY];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"pick up budget group field value exception");
        }
    }
    return value;
}

#pragma mark button clicked
- (void)submitButtonClicked:(UIButton *)submitButton {
    //save data
    if (currentBudget) {
        //budget
        BOOL budgetValid = NO;
        id budgetNum = [self getFieldValueByContentType:DetailCellContentTypeBudget];
        if (budgetNum && [budgetNum isKindOfClass:[NSNumber class]] && [(NSNumber *)budgetNum longLongValue] > 0) {
            budgetValid = YES;
            currentBudget.mBudget = [(NSNumber *)budgetNum longLongValue];
        }
        
        //notify
        BOOL notifyValid = NO;
        id notifyNum = [self getFieldValueByContentType:DetailCellContentTypeNotify];
        if (notifyNum && [notifyNum isKindOfClass:[NSNumber class]] && [(NSNumber *)notifyNum floatValue] > 0) {
            currentBudget.mNotification = [(NSNumber *)notifyNum floatValue];
            notifyValid = YES;
        }
        
        //bar
        id barNum = [self getFieldValueByContentType:DetailCellContentTypeBar];
        if (barNum && [barNum isKindOfClass:[NSNumber class]]) {
            currentBudget.mBarred = [(NSNumber *)barNum boolValue];
        }
        
        //alert
        NSString *alertMessage = nil;
        if (budgetValid && notifyValid) {
            alertMessage = NSLocalizedString(@"Budget_Detail_Set_Budget_Submitted", nil);
        } else {
            alertMessage = NSLocalizedString(@"Budget_Detail_Submitted_Failed", nil);
        }
        AlertController *alert = [[AlertController alloc] initWithTitle:nil message:alertMessage delegate:nil tag:BudgetDetailAlertTypeSubmitted cancelButtonTitle:NSLocalizedString(@"UIAlertView_Confirm_String", nil) otherButtonTitles:nil, nil];
        [alert showInViewController:self];
        [alert release];

    }
}

#pragma mark refresh data
- (void)updateDetailCellWithData:(id)data cellType:(DetailCellContentType)cellType {
    if (data) {
        NSMutableDictionary *cellDict = nil;
        NSIndexPath *cellIndexPath = nil;
        BOOL needRefresh = NO;
        switch (cellType) {
            case DetailCellContentTypeBudget:
            {
                @try {
                    cellDict = [detailDataArray objectAtIndex:0];
                    [cellDict setObject:(NSNumber *)data forKey:DETAIL_FIELD_VALUE_KEY];
                    cellIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    needRefresh = YES;
                }
                @catch (NSException *exception) {
                    NSLog(@"update budget exception");
                }
            }
                break;
            case DetailCellContentTypeNotify:
            {
                @try {
                    cellDict = [detailDataArray objectAtIndex:1];
                    [cellDict setObject:(NSNumber *)data forKey:DETAIL_FIELD_VALUE_KEY];
                    cellIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                    needRefresh = YES;
                }
                @catch (NSException *exception) {
                    NSLog(@"update notify exception");
                }
                break;
            }
            case DetailCellContentTypeBar:
            {
                @try {
                    cellDict = [detailDataArray objectAtIndex:2];
                    [cellDict setObject:(NSNumber *)data forKey:DETAIL_FIELD_VALUE_KEY];
                    cellIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
                    needRefresh = YES;
                }
                @catch (NSException *exception) {
                    NSLog(@"update bar exception");
                }
                break;
            }
            default:
                break;
        }
        if (cellIndexPath && needRefresh) {
            [detailTableView reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

#pragma mark load data
- (void)loadData {
    self.detailDataArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    [self loadDetailData];
}

- (void)loadDetailData {
    NSArray *fieldNames = @[NSLocalizedString(@"Budget_Detail_Field_Name_Budget", nil),
                            NSLocalizedString(@"Budget_Detail_Field_Name_Notify", nil),
                            NSLocalizedString(@"Budget_Detail_Field_Name_Bar", nil)];
    for (int i = 0; i < 3; i ++) {
        NSMutableDictionary *detailDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        [detailDict setObject:[fieldNames objectAtIndex:i] forKey:DETAIL_FIELD_NAME_KEY];
        if (currentBudget) {
            if (i == 0) {
                [detailDict setObject:[NSNumber numberWithLongLong:currentBudget.mBudget] forKey:DETAIL_FIELD_VALUE_KEY];
            } else if (i == 1) {
                [detailDict setObject:[NSNumber numberWithFloat:currentBudget.mNotification] forKey:DETAIL_FIELD_VALUE_KEY];
            } else if (i == 2) {
                [detailDict setObject:[NSNumber numberWithBool:currentBudget.mBarred] forKey:DETAIL_FIELD_VALUE_KEY];
            }
        }
        [self.detailDataArray addObject:detailDict];
        [detailDict release];
    }
}

#pragma mark others
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
