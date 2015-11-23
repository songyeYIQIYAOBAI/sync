//
//  TurboBoostViewController.m
//  RTSS
//
//  Created by dongjf on 14/10/23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "TurboBoostViewController.h"
#import "AppTurboBoostCell.h"
#import "AppTurboBoostModel.h"
#import "CommonUtils.h"
#import "DateUtils.h"
#import "AlertController.h"
#import "RTSSAppStyle.h"
#import "SinglePickerController.h"

typedef NS_ENUM(NSInteger, AlertControllerType) {
    AlertControllerTypeDefault,
    AlertControllerTypeSubmitPurchaseConfirm,
    AlertControllerTypePurchaseSubmitted,
    AlertControllerTypeChangePriorityConfirm,
};

#define APPS_TABLE_VIEW_LEFT 14.f
#define APPS_TABLE_VIEW_TOP 10.f
#define APPS_TABLE_VIEW_BOTTOM 20.f
#define APPS_CELL_HEIGHT_FOLD 51.f
#define APPS_CELL_HEIGHT_UNFOLD 161.f

#define SCHEDULED_TIMER_INTERVAL 1.f

@interface TurboBoostViewController () <UITableViewDelegate,UITableViewDataSource,AlertControllerDelegate,AppTurboBoostCellDelegate,SinglePickerDelegate> {
    BOOL isEditing;
    BOOL appsPriorityChanged;
    UITableView *appsTableView;
    NSMutableArray *appsArray;
    NSInteger activeRowIndex;
    NSTimer *timeManageTimer;
    UIButton *navRightButton;
    
    SinglePickerController *speedPicker;//band width picker
    SinglePickerController *hourPicker;//hour picker
}

@end

@implementation TurboBoostViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark setup timer
- (void)setupTimeManageTimer {
    timeManageTimer = [NSTimer scheduledTimerWithTimeInterval:SCHEDULED_TIMER_INTERVAL target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
}

- (void)countDown:(NSTimer *)timer {
    if (activeRowIndex >= 0) {
        NSIndexPath *cellIndex = [NSIndexPath indexPathForRow:activeRowIndex inSection:0];
        AppTurboBoostCell *cell = (AppTurboBoostCell *)[appsTableView cellForRowAtIndexPath:cellIndex];
        if (cell) {
            [cell updateControlDisplay];
        }
    }
}

#pragma mark life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark load view
- (void)loadView{
    [super loadView];
    [self loadNavigationBar];
    [self loadContentView];
    [self loadPickerView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isEditing = NO;
    appsPriorityChanged = NO;
    activeRowIndex = -1;
    self.title = NSLocalizedString(@"TurboBoost_Title", nil);
    [appsTableView reloadData];
    [self setupTimeManageTimer];
}

- (void)viewDidDisappear:(BOOL)animated {
    if (timeManageTimer) {
        [timeManageTimer invalidate];
        timeManageTimer = nil;
    }
}

- (void)loadNavigationBar {
    //nav bar view
    navigationBarView = [self addNavigationBarView:NSLocalizedString(@"TurboBoost_Title", nil) bgColor:[[RTSSAppStyle currentAppStyle] viewControllerBgColor] separator:NO];
    [self.view addSubview:navigationBarView];

    //right button
    CGRect buttonRect = CGRectZero;
    if ([NSLocalizedString(@"Common_Current_Language", nil) isEqualToString:@"English"]) {
        buttonRect = CGRectMake(PHONE_UISCREEN_WIDTH - 20.f - 60.f, 20+12.f, 60.f, 20.f);
    } else {
        buttonRect = CGRectMake(PHONE_UISCREEN_WIDTH - 20.f - 50.f, 20+12.f, 50.f, 20.f);
    }
    navRightButton = [CommonUtils buttonWithType:UIButtonTypeCustom frame: buttonRect title:NSLocalizedString(@"TurboBoost_Right_Bar_Default_Title", nil) bgImageNormal:nil bgImageHighlighted:nil bgImageSelected:nil addTarget:self action:@selector(updateAppPriority:) tag:0];
    navRightButton.titleLabel.textAlignment = NSTextAlignmentRight;
    navRightButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    [navRightButton setTitleColor:[[RTSSAppStyle currentAppStyle] textMajorColor] forState:UIControlStateNormal];
    [navigationBarView addSubview:navRightButton];
}

- (void)changeNavBarRightButtonStyle {
    NSString *title = nil;
    CGRect buttonRect = CGRectZero;
    if (isEditing) {
        title = NSLocalizedString(@"TurboBoost_Right_Bar_Done_Title", nil);
        if ([NSLocalizedString(@"Common_Current_Language", nil) isEqualToString:@"English"]) {
            buttonRect = CGRectMake(PHONE_UISCREEN_WIDTH - 20.f - 45.f, 20+12.f, 45.f, 20.f);
        } else {
            buttonRect = CGRectMake(PHONE_UISCREEN_WIDTH - 20.f - 35.f, 20+12.f, 35.f, 20.f);
        }
    } else {
        title = NSLocalizedString(@"TurboBoost_Right_Bar_Default_Title", nil);
        if ([NSLocalizedString(@"Common_Current_Language", nil) isEqualToString:@"English"]) {
            buttonRect = CGRectMake(PHONE_UISCREEN_WIDTH - 20.f - 60.f, 20+12.f, 60.f, 20.f);
        } else {
            buttonRect = CGRectMake(PHONE_UISCREEN_WIDTH - 20.f - 50.f,20+ 12.f, 50.f, 20.f);
        }
    }
    navRightButton.frame = buttonRect;
    [navRightButton setTitle:title forState:UIControlStateNormal];
}

- (void)loadContentView {
    [self loadBackgroundView];
    [self loadAppsTableView];
}

- (void)loadBackgroundView {
    CGRect bgViewRect = CGRectMake(APPS_TABLE_VIEW_LEFT - 1.f, CGRectGetMaxY(navigationBarView.frame) + APPS_TABLE_VIEW_TOP - 1.f, PHONE_UISCREEN_WIDTH - APPS_TABLE_VIEW_LEFT * 2.f + 2.f, PHONE_UISCREEN_HEIGHT - 20.f - 44.f - APPS_TABLE_VIEW_TOP - APPS_TABLE_VIEW_BOTTOM + 2.f);
    UIView *bgView = [[UIView alloc] initWithFrame:bgViewRect];
    bgView.layer.cornerRadius = 8.f;
    bgView.layer.borderColor = [[RTSSAppStyle currentAppStyle] navigationBarColor].CGColor;
    bgView.layer.borderWidth = 2.f;
    bgView.backgroundColor = [UIColor clearColor];
    bgView.clipsToBounds = YES;
    bgView.tag = 100;
    [self.view addSubview:bgView];
    [bgView release];
}

- (void)loadAppsTableView {
    CGRect tableRect = CGRectMake(1.f, 1.f, PHONE_UISCREEN_WIDTH - APPS_TABLE_VIEW_LEFT * 2.f, PHONE_UISCREEN_HEIGHT - 20.f - 44.f - APPS_TABLE_VIEW_TOP - APPS_TABLE_VIEW_BOTTOM);
    appsTableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
    appsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    appsTableView.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
    appsTableView.showsHorizontalScrollIndicator = NO;
    appsTableView.showsVerticalScrollIndicator = NO;
    appsTableView.rowHeight = APPS_CELL_HEIGHT_FOLD;
    appsTableView.delegate = self;
    appsTableView.dataSource = self;
    [[self.view viewWithTag:100] addSubview:appsTableView];
}

- (void)loadPickerView {
    speedPicker = [[SinglePickerController alloc] init];
    speedPicker.delegate = self;
    speedPicker.pickerType = SinglePickerTypeSpeed;
    
    hourPicker = [[SinglePickerController alloc] init];
    hourPicker.delegate = self;
    hourPicker.pickerType = SinglePickerTypeTimeHour;
}

#pragma mark talbe view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [appsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = APPS_CELL_HEIGHT_FOLD;
    if (activeRowIndex != -1 && activeRowIndex == indexPath.row) {
        cellHeight = APPS_CELL_HEIGHT_UNFOLD;
    }
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellIdentifier";
    AppTurboBoostCell *appCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!appCell) {
        appCell = [[[AppTurboBoostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId belongToTableView:appsTableView] autorelease];
        appCell.selectionStyle = UITableViewCellSelectionStyleNone;
        appCell.backgroundColor = [RTSSAppStyle currentAppStyle].turboBoostUnfoldBgColor;
        appCell.delegate = self;
    }
    [appCell setClipsToBounds:YES];
    
    AppTurboBoostModel *appModel = [appsArray objectAtIndex:indexPath.row];
    [appCell layoutCellHeaderViewWithAppData:appModel indexPath:indexPath isEditing:isEditing];
    
    return appCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AppTurboBoostCell *selectCell = (AppTurboBoostCell *)[tableView cellForRowAtIndexPath:indexPath];
    AppTurboBoostCell *activeCell = nil;
    if (activeRowIndex != -1) {
        activeCell = (AppTurboBoostCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:activeRowIndex inSection:0]];
    }
    if (activeRowIndex != indexPath.row) {
        activeRowIndex = indexPath.row;
        selectCell.appDataModel.isActive = YES;
        if (activeCell) {
            activeCell.appDataModel.isActive = NO;
        }
    } else {
        activeRowIndex = -1;
        selectCell.appDataModel.isActive = NO;
    }
    NSArray *path = [NSArray arrayWithObjects:indexPath, nil];
    [tableView reloadRowsAtIndexPaths:path withRowAnimation:UITableViewRowAnimationNone];

    return indexPath;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSInteger fromRow = sourceIndexPath.row;
    NSInteger toRow = destinationIndexPath.row;
    //未变化
    if (fromRow == toRow) {
        //do nothing
        return;
    } else {
        appsPriorityChanged = YES;
        id startObject = [appsArray objectAtIndex:fromRow];
        if (fromRow > toRow) {
            //向前移动
            [appsArray insertObject:startObject atIndex:toRow];
            [appsArray removeObjectAtIndex:fromRow + 1];
            
        } else {
            //向后移动
            [appsArray insertObject:startObject atIndex:toRow + 1];
            [appsArray removeObjectAtIndex:fromRow];
        }
    }
}

#pragma mark turbo boost cell delegate
- (void)turboBoostCell:(AppTurboBoostCell *)cell indexPath:(NSIndexPath *)cellIndexPath didSelectOperation:(ClickOperationType)operationType withParameters:(NSDictionary *)parameters {
    if (activeRowIndex < 0) {
        return;
    }
    switch (operationType) {
        case ClickOperationTypeSelectBandWidth:
        {
            NSLog(@"speed button clicked");
            speedPicker.pickerArrayData = @[[NSNumber numberWithInteger:1],[NSNumber numberWithInteger:2],[NSNumber numberWithInteger:3],[NSNumber numberWithInteger:4],[NSNumber numberWithInteger:5]];
            [self.view.window addSubview:speedPicker.view];
        }
            break;
        case ClickOperationTypeSelectTime:
        {
            NSLog(@"time button clicked");
            hourPicker.pickerArrayData = @[[NSNumber numberWithInteger:1],[NSNumber numberWithInteger:2],[NSNumber numberWithInteger:3],[NSNumber numberWithInteger:4],[NSNumber numberWithInteger:5]];
            [self.view.window addSubview:hourPicker.view];
        }
            break;
        case ClickOperationTypeReset:
        {
            NSLog(@"reset button clicked");
        }
            break;
        case ClickOperationTypeSubmit:
        {
            NSLog(@"submit button clicked");
            AlertController *alert = nil;
            if (cell.speedButtonValue > 0) {
                alert = [[AlertController alloc] initWithTitle:nil message:NSLocalizedString(@"TurboBoost_Alert_Are_Sure_String", nil) delegate:self tag:AlertControllerTypeSubmitPurchaseConfirm cancelButtonTitle:NSLocalizedString(@"UIAlertView_Cancel_String", nil) otherButtonTitles:NSLocalizedString(@"UIAlertView_Confirm_String", nil),nil];
            } else {
                alert = [[AlertController alloc] initWithTitle:nil message:NSLocalizedString(@"TurboBoost_Alert_Selected_Speed_Value", nil) delegate:nil tag:AlertControllerTypeDefault cancelButtonTitle:NSLocalizedString(@"UIAlertView_Confirm_String", nil) otherButtonTitles:nil];
            }
            [alert showInViewController:self];
            [alert release];
        }
            break;
        case ClickOperationTypePurchase:
        {
            NSLog(@"purchase button clicked");
        }
        default:
            break;
    }
}

#pragma mark alert controller delegate
- (void)alertController:(AlertController *)alertController didDismissWithButtonIndex:(NSInteger)buttonIndex {
    AlertControllerType type = alertController.tag;
    switch (type) {
        case AlertControllerTypeSubmitPurchaseConfirm:
        {
            if (buttonIndex == alertController.firstOtherButtonIndex) {
                //确认购买
                if (activeRowIndex != -1) {
                    NSIndexPath *index = [NSIndexPath indexPathForRow:activeRowIndex inSection:0];
                    AppTurboBoostCell *cell = (AppTurboBoostCell *)[appsTableView cellForRowAtIndexPath:index];
                    //更新最新数据
                    cell.appDataModel.appRateValue = cell.speedButtonValue;
                    cell.appDataModel.appHour = cell.hourButtonValue;
                    cell.appDataModel.expireDate = [self convertExpiredDateStringByLastHour:cell.hourButtonValue];
                    [cell updateControlDisplay];
                    AlertController *alert = [[AlertController alloc] initWithTitle:nil message:NSLocalizedString(@"TurboBoost_Alert_Speed_Request_Submit", nil) delegate:self tag:AlertControllerTypePurchaseSubmitted cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"UIAlertView_Confirm_String", nil),nil];
                    [alert showInViewController:self];
                    [alert release];
                }
            }
        }
            break;
        case AlertControllerTypePurchaseSubmitted:
        {
            if (activeRowIndex != -1) {
                NSIndexPath *index = [NSIndexPath indexPathForRow:activeRowIndex inSection:0];
                AppTurboBoostCell *cell = (AppTurboBoostCell *)[appsTableView cellForRowAtIndexPath:index];
                [cell flipContentView];
                [cell resetControlValues];
            }
        }
            break;
        case AlertControllerTypeChangePriorityConfirm:
        {
            if (buttonIndex == alertController.cancelButtonIndex) {
                //取消修改
                [self resetData];
                [self changeNavBarRightButtonStyle];
                appsTableView.editing = NO;
                [appsTableView reloadData];
            } else if (buttonIndex == alertController.firstOtherButtonIndex) {
                //确认修改
                [self changeNavBarRightButtonStyle];

                //网络请求，数据处理
                appsTableView.editing = NO;
                [appsTableView reloadData];
                //提示用户
                AlertController *alert = [[AlertController alloc] initWithTitle:nil message:NSLocalizedString(@"TurboBoost_Alert_Change_Priority_Succeed_Message", nil) delegate:nil tag:AlertControllerTypeDefault cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"UIAlertView_Confirm_String", nil),nil];
                [alert showInViewController:self];
                [alert release];
            }
            
        }
            break;
        default:
            break;
    }
}

#pragma mark SinglePickerDelegate
- (void)singlePickerWithDone:(SinglePickerController*)controller selectedIndex:(NSInteger)index
{
    SinglePickerType pickerType = controller.pickerType;
    int selectValue = [[controller.pickerArrayData objectAtIndex:index] intValue];
    AppTurboBoostCell *activeCell = (AppTurboBoostCell *)[appsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:activeRowIndex inSection:0]];
    switch (pickerType) {
        case SinglePickerTypeSpeed:
        {
            activeCell.speedButtonValue = selectValue;
        }
            break;
        case SinglePickerTypeTimeHour:
        {
            activeCell.hourButtonValue = selectValue;
        }
        default:
            break;
    }
    
    //remove
    [controller.view removeFromSuperview];
}

- (void)singlePickerWithCancel:(SinglePickerController*)controller
{
    //remove
    [controller.view removeFromSuperview];
}

#pragma mark button action
- (void) updateAppPriority:(UIBarButtonItem *)buttonItem {
    isEditing = !isEditing;
    if (isEditing) {
        [self changeNavBarRightButtonStyle];

        appsPriorityChanged = NO;
        if (activeRowIndex != -1) {
            AppTurboBoostCell *activeCell = (AppTurboBoostCell *)[appsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:activeRowIndex inSection:0]];
            activeCell.appDataModel.isActive = NO;
        }
        activeRowIndex = -1;
        [appsTableView reloadData];
        appsTableView.editing = YES;
        
    } else {
        if (appsPriorityChanged) {
            //优先级已改变，提示用户
            AlertController *alert = [[AlertController alloc] initWithTitle:nil message:NSLocalizedString(@"TurboBoost_Alert_Are_Sure_String", nil) delegate:self tag:AlertControllerTypeChangePriorityConfirm cancelButtonTitle:NSLocalizedString(@"UIAlertView_Cancel_String", nil) otherButtonTitles:NSLocalizedString(@"UIAlertView_Confirm_String", nil),nil];
            [alert showInViewController:self];
            [alert release];
        } else {
            //优先级未改变，回复默认title
            [self changeNavBarRightButtonStyle];

            appsTableView.editing = NO;
            [appsTableView reloadData];
        }
    }
}

#pragma mark load data
- (void)loadData{
    if (!appsArray) {
        appsArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [appsArray addObjectsFromArray:[self fakeData]];
}

- (void)resetData {
    if (!appsArray) {
        appsArray = [[NSMutableArray alloc] initWithCapacity:0];
    } else {
        [appsArray removeAllObjects];
    }
    [appsArray addObjectsFromArray:[self fakeData]];
}

- (NSMutableArray *)fakeData {
    NSMutableArray *appArr = [NSMutableArray array];
    NSArray *apps = @[@"Skype",@"Last FM",@"Youtube",@"WhatsApp",@"FaceBook",@"Internet",@"Mail",@"BBC News",@"Cat Piano",@"Chrome",@"Coachs Eyes",@"Disney Storytime",@"Ever Note"];
    NSArray *icons = @[@"app_skype",@"app_lastfm",@"app_youtube",@"app_whatsapp",@"app_facebook",@"app_internet",@"app_mail",@"app_bbc_news",@"app_cat_piano",@"app_chrome",@"app_coachs_eye",@"app_disney_storytime",@"app_evernote"];
    
    for (NSInteger index = 0; index < 13; index ++) {
        AppTurboBoostModel *appModel = [[AppTurboBoostModel alloc] init];
        appModel.appName = [apps objectAtIndex:index];
        appModel.appIcon = [icons objectAtIndex:index];
        if (index == 0) {
            appModel.appRateValue = 5.f;
        } else if (index % 2 == 0) {
            appModel.appRateValue = 0.f;
        } else {
            appModel.appRateValue = 10.f;
        }
        
        NSString *dateStr = [self convertExpiredDateStringByLastHour:3];
        appModel.expireDate = dateStr;
        [appArr addObject:appModel];
    }
    return appArr;
}

#pragma mark dealloc
- (void)dealloc {
    [appsTableView release];
    [appsArray release];
    [speedPicker release];
    [hourPicker release];
    [super dealloc];
}

#pragma mark others
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSString *)convertExpiredDateStringByLastHour:(int)hour {
    NSDate *expiredDate = [[NSDate date] dateByAddingTimeInterval:hour * 3600];
    return [DateUtils getStringDateByDate:expiredDate dateFormat:@"yyyy-MM-dd HH:mm:ss"];
}

@end
