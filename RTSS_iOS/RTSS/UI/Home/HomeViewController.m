//
//  HomeViewController.m
//  RTSS
//
//  Created by shengyp on 14/10/21.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "FriendsViewController.h"
#import "MobileUsageViewController.h"
#import "QuickTransferViewController.h"
#import "PersonCenterViewController.h"
#import "RadarPickerViewController.h"
#import "RechargeViewController.h"
#import "MyUsageViewController.h"
#import "SinglePickerController.h"
#import "SettingsViewController.h"
#import "BalanceTransferViewController.h"
#import "AcountTopupViewController.h"
#import "ActionSheetController.h"
#import "WalletViewController.h"
#import "ServiceRequestViewController.h"
#import "TurboBoostViewController.h"
#import "MessageBoxViewController.h"
#import "SupportViewController.h"
#import "BudgetViewController.h"
#import "TransferViewController.h"
#import "TransFormViewController.h"
#import "MobileUsageVC.h"
#import "FindHomeViewController.h"
#import "PlanManageViewController.h"

#import "HomeView.h"
#import "QuadCurveMenu.h"
#import "BottleView.h"
#import "CountdownView.h"
#import "WaitingView.h"
#import "QuadCurveMenuItem.h"
#import "PortraitImageView.h"
#import "LabelNumberJump.h"
#import "RTSSLocation.h"
#import "ImageUtils.h"
#import "DateUtils.h"
#import "User.h"

#import "Session.h"
#import "Customer.h"
#import "Cache.h"
#import "EventItem.h"
#import "Events.h"
#import "Friends.h"
#import "Settings.h"
#import "ProductResource.h"
#import "TransferTransaction.h"
#import "RuleManager.h"

#import <CoreMotion/CoreMotion.h>

/**
 *  @author 蔡杰Alan, 15-05-15 14:05:53
 *
 *  @brief  V2.5
 */
#import "MManager.h"

@implementation HomeModel
@synthesize currentTransferIndex, currentTransferArray, currentTransfer, currentTransferValue;
@synthesize friendsGiftUser, singleSelectedItemView, defaultSelectedItemView,currentTransferTransactionStatus;

- (void)dealloc
{
    [currentTransfer release];
    [currentTransferArray release];
    
    [friendsGiftUser release];
    [singleSelectedItemView release];
    [defaultSelectedItemView release];
    
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        currentTransferIndex                 = -1;
        currentTransferValue                 = 0;
        
        currentTransferTransactionStatus     = HomeTransferTransactionStatusDefault;
    }
    return self;
}

- (void)clear
{
    currentTransferIndex                    = -1;
    currentTransferValue                    = 0;
    
    currentTransferTransactionStatus        = HomeTransferTransactionStatusDefault;
    
    self.currentTransfer                    = nil;
    self.currentTransferArray               = nil;
    
    self.friendsGiftUser                    = nil;
    self.singleSelectedItemView             = nil;
    self.defaultSelectedItemView            = nil;
}

- (id<ITransferable>)getTransferWithIndex:(NSInteger)index{
    if([CommonUtils objectIsValid:self.currentTransferArray]){
        if(index >= 0 && index < [self.currentTransferArray count]){
            currentTransferIndex = index;
            self.currentTransfer = [self.currentTransferArray objectAtIndex:index];
        }else{
            currentTransferIndex = 0;
            self.currentTransfer = [self.currentTransferArray objectAtIndex:0];
        }
        
        currentTransferValue = [[Settings standardSettings] getTransferValueByKey:[self getUnitKeyStringByUnit:[self.currentTransfer getUnit]]];
        
        if(0 == currentTransferValue){
            MeasureUnit currentTransferUnit = [self.currentTransfer getUnit];
            switch (currentTransferUnit) {
                case UnitForDataAmount:
                    currentTransferValue = 50*RTSS_1MB_VALUE;
                    break;
                case UnitForMoney:
                    currentTransferValue = 50*RTSS_1YUAN_VALUE;
                    break;
                case UnitForTime:
                    currentTransferValue = 5*RTSS_1MINUTE_VALUE;
                    break;
                case UnitForMessageAmount:
                    currentTransferValue = 5*RTSS_1MSG_VALUE;
                    break;
                default:
                    break;
            }
        }
        
        return self.currentTransfer;
    }
    return nil;
}

- (NSInteger)getIndexWithITransferable:(id<ITransferable>)transferable{
    NSInteger index = -1;
    if([CommonUtils objectIsValid:self.currentTransferArray]){
        for (int i = 0; i < [self.currentTransferArray count]; i ++) {
            id<ITransferable> transferableTemp = [self.currentTransferArray objectAtIndex:i];
            if(nil != transferable && [[transferable getItemId] isEqualToString:[transferableTemp getItemId]]){
                index = i;
                break;
            }
        }
    }
    return index;
}

#pragma mark 根据单位获取相应单位的KEY
- (NSString*)getUnitKeyStringByUnit:(MeasureUnit)unit
{
    return [NSString stringWithFormat:@"TRANSFER_UNIT_%@",[[NSNumber numberWithInteger:unit] stringValue]];
}

#pragma mark 获取接收者当前资源的信息
- (NSString*)getReceiveTransferId{
    NSString* transferId = [self.singleSelectedItemView.itemInfo objectForKey:TRANSFERABLE_ID_RECEIVE_KEY];
    return nil != transferId ? transferId : @"";
}

- (NSString*)getReceiveTransferName{
    NSString* transferName = [self.singleSelectedItemView.itemInfo objectForKey:TRANSFERABLE_NAME_RECEIVE_KEY];
    return nil != transferName ? transferName : @"";
}

- (MeasureUnit)getReceiveTransferUnit{
    return [[self.singleSelectedItemView.itemInfo objectForKey:TRANSFERABLE_UNIT_RECEIVE_KEY] integerValue];
}

- (NSString*)getReceiveSubscriberId{
    NSString* subscriberId = [self.singleSelectedItemView.itemInfo objectForKey:TRANSFERABLE_SUBSCRIBERID_RECEIVE_KEY];
    return nil != subscriberId ? subscriberId : @"";
}

- (long long)getGiftTransferValue{
    return [[self.defaultSelectedItemView.itemInfo objectForKey:TRANSFERABLE_VALUE_GIFT_KEY] longLongValue];
}

#pragma mark 获取赠送者当前资源的信息
- (NSString*)getGiftTransferId{
    NSString* transferId = [self.defaultSelectedItemView.itemInfo objectForKey:TRANSFERABLE_ID_GIFT_KEY];
    return nil != transferId ? transferId : @"";
}

- (NSString*)getGiftTransferName{
    NSString* transferName = [self.defaultSelectedItemView.itemInfo objectForKey:TRANSFERABLE_NAME_GIFT_KEY];
    return nil != transferName ? transferName : @"";
}

- (MeasureUnit)getGiftTransferUnit{
    return [[self.defaultSelectedItemView.itemInfo objectForKey:TRANSFERABLE_UNIT_GIFT_KEY] integerValue];
}


#pragma mark -- Get Subscriber
/**
 *  @author 蔡杰Alan, 15-05-15 14:05:56
 *
 *  @brief  V2.5  获取当前 Subscriber
 */
- (Subscriber*)getCustomerSubscriber
{
    NSString* customerSubscriberId = [[Settings standardSettings] getCustomerSubscriberId];
    
    if([CommonUtils objectIsValid:customerSubscriberId]){
        for (Subscriber* subscriber in [[MManager sharedMManager]getSession].mMyCustomer.mMySubscribers) {
            if([subscriber.mId isEqualToString:customerSubscriberId]){
                NSLog(@"---settting get customerSubscriber ");
                return subscriber;
            }
        }
    }
    if([CommonUtils objectIsValid:[Session sharedSession].mMyCustomer.mMySubscribers]){
        NSLog(@"------->%@",[Session sharedSession].mMyCustomer.mMySubscribers);
        return [[[MManager sharedMManager]getSession].mMyCustomer.mMySubscribers objectAtIndex:0];
    }
    
    return nil;
}

- (NSArray*)getTransferableByCustomerSubscribers:(Subscriber*)subscriber
{
    if(nil != subscriber){
        NSArray* array = [[MManager sharedMManager]getSession].mTransferables;
        
        if(ACCOUNT_PREPAID_TYPE == subscriber.mPaidType){
            // 预付费
            NSMutableArray* prepaidArray  = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
            for (int i = 0; i < [array count]; i ++) {
                id<ITransferable> transferable = [array objectAtIndex:i];
                if(1 == [transferable getTypeCode]){
                    [prepaidArray addObject:transferable];
                }
            }
            return prepaidArray;
        }else{
            // 后付费
            NSMutableArray* postpaidArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
            for (int i = 0; i < [array count]; i ++) {
                id<ITransferable> transferable = [array objectAtIndex:i];
                if(1 != [transferable getTypeCode] && 2 != [transferable getTypeCode]){
                    [postpaidArray addObject:transferable];
                }
            }
            return postpaidArray;
        }
    }
    return nil;
}




@end


@interface HomeViewController ()<HomeGridItemViewDelegate,HomeViewDelegate,QuadCurveMenuDelegate,CountdownViewDelegate,AlertControllerDelegate,BottleViewDelegate, RadarPickerViewControllerDelegate, MappActorDelegate, RTSSLocationDelegate,SinglePickerDelegate>{
    
    HomeNavigationBar*                  homeNavigationBar;
    HomeView*                           homeView;
    HomeBottleView*                     homeBottleView;
    CountdownView*                      homeCountdownView;
    WaitingView*                        homeWaitingView;
    
    HomeBottlePouringOutOrInStatus      homeBottlePouringStatus;
    HomeModel*                          homeModel;
    RTSSLocation*                       homeLocation;
    
}

@property(nonatomic, assign) BOOL       homeOnResume;
@property(nonatomic, assign) BOOL       homeSwithAccounts;

@end

@implementation HomeViewController
@synthesize homeOnResume, homeSwithAccounts;

- (void)dealloc{
    [homeNavigationBar release];
    [homeView release];
    [homeBottleView release];
    [homeCountdownView release];
    [homeWaitingView release];
    
    [homeModel release];
    
    [homeLocation release];
    
    [super dealloc];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.homeOnResume                   = NO;
        self.homeSwithAccounts              = NO;
        homeBottlePouringStatus             = HomeBottlePouringInitial;
        homeModel                           = [[HomeModel alloc] init];
        homeLocation                        = [[RTSSLocation alloc] init];
        homeLocation.delegate               = self;
        homeLocation.updatingLocationFinishedStopLocation = YES;
        homeLocation.updatingLocationFinishedCloseLocation = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(YES == self.homeOnResume && 0 == homeView.homePageControl.currentPage){
        [homeBottleView.homeDisplayView.bottleView startTraceMotion:[AppDelegate sharedMotionManager]];
    }
    
    BOOL isCalibrate = [DateUtils compareDifferMinute:[NSDate date] toDate:[[Settings standardSettings] getCalibrateDate] minute:3];
    if(YES == self.homeOnResume && (HomeTransferTransactionStatusGifting != homeModel.currentTransferTransactionStatus && HomeTransferTransactionStatusReceiving != homeModel.currentTransferTransactionStatus) && isCalibrate){
        if(YES == self.homeSwithAccounts){
            self.homeSwithAccounts = NO;
            [self clearAccountSource];
        }
        [self loadSubcriberSyc:YES];
    }else if (YES == self.homeSwithAccounts){
        self.homeSwithAccounts = NO;
        [self clearAccountSource];
        [self loadSubcriberSyc:YES];
    }else{
        [self refreshCurrentTransfer];
    }
    self.homeOnResume = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    if(0 == homeView.homePageControl.currentPage){
        [homeBottleView.homeDisplayView.bottleView stopTraceMotion];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutHomeView
{
    homeCountdownView = [[CountdownView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT)];
    homeCountdownView.backgroundColor = [UIColor clearColor];
    homeCountdownView.countDown = COUNTDOWNVIEW_TRANSFER_TIMEOUT;
    homeCountdownView.countDownLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    homeCountdownView.countDownLabel.font = [RTSSAppStyle getRTSSFontWithSize:50.0];
    homeCountdownView.delegate = self;
    
    homeWaitingView = [[WaitingView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT)];
    homeWaitingView.backgroundColor = [UIColor blackColor];
    homeWaitingView.alpha = 0.3;
    
    homeNavigationBar = [[HomeNavigationBar alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 76)];
    homeNavigationBar.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    homeNavigationBar.portraitImageView.portraitImage = [[Cache standardCache] getSmallPortraitImageWithUrl:[Session sharedSession].mMyUser.mPortrait completion:^(UIImage *image) {
        homeNavigationBar.portraitImageView.portraitImage = image;
    }];
    [homeNavigationBar.portraitImageView.actionButton addTarget:self action:@selector(headImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeNavigationBar];
    
    homeView = [[HomeView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT)];
    homeView.backgroundColor = [UIColor clearColor];
    homeView.delegate = self;
    [self.view insertSubview:homeView belowSubview:homeNavigationBar];
}

- (void)layoutBottleView{
    homeBottleView = [[HomeBottleView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT)];
    homeBottleView.backgroundColor = [UIColor clearColor];
    homeBottleView.homeDisplayView.homeMarkView.quadCurveMenu.delegate = self;
    [homeBottleView.homeDisplayView.homeMarkView.transferRuleView.actionButton addTarget:self action:@selector(transferRuleAction:) forControlEvents:UIControlEventTouchUpInside];
    [homeBottleView.homeDisplayView.homeBottleButton addTarget:self action:@selector(bottleAction:) forControlEvents:UIControlEventTouchUpInside];
    homeBottleView.homeDisplayView.bottleView.delegate = self;
    [homeBottleView.homeDisplayView.bottleView startTraceMotion:[AppDelegate sharedMotionManager]];
    
    [homeView addPageView:homeBottleView];
    [homeView loadHomeView];
}

- (void)layoutMenuView{
    // ====
    [homeView removeAllPageView];
    
    // ====
    [homeView addPageView:homeBottleView];
    
    // ====
    [homeView addPageArrayView:[self getHomeMenuViewArrayWithTag:[Session sharedSession].mCurrentAccount.mPaidType]];
    
    // ====
    [homeView loadHomeViewWithIndex:homeView.homePageControl.currentPage];
}

- (void)loadView{
    [super loadView];
    // ===
    [self layoutHomeView];
    // ===
    [self layoutBottleView];
}

#pragma mark HomeGridViewData
- (NSArray*)getHomeGridItemArrayWithTag:(NSInteger)tag
{
    HomeGridStyle* gridStyle = [HomeGridStyle defaultStyle];
    
    NSArray* configList = nil;
    NSDictionary* homeMenuDic = [[AppDelegate shareAppDelegate].configDictionary objectForKey:@"Home_Menu"];
    if(ACCOUNT_PREPAID_TYPE == tag){
        configList = [homeMenuDic objectForKey:@"Home_Menu_Prepaid_List"];
    }else{
        configList = [homeMenuDic objectForKey:@"Home_Menu_Postpaid_List"];
    }
    
    NSUInteger pageNumber = 0 == [configList count]%(gridStyle.rowCount*gridStyle.columnCount) ? [configList count]/(gridStyle.rowCount*gridStyle.columnCount) : ([configList count]/(gridStyle.rowCount*gridStyle.columnCount)+1);
    
    NSMutableArray* menuList = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    // 添加配置菜单
    for (int i = 0; i < [configList count]; i ++) {
        [menuList addObject:[HomeGridItemView getHomeGridItemIndexTagByString:[configList objectAtIndex:i]]];
    }
    
    // 添加空位补位（不需要补位 请注视掉）
    for (int i = 0; i < (pageNumber*(gridStyle.rowCount*gridStyle.columnCount)-[configList count]); i ++) {
        [menuList addObject:[HomeGridItemView getHomeGridItemIndexTagByString:nil]];
    }
    
    return menuList;
}

- (NSArray*)getHomeMenuViewArrayWithTag:(NSInteger)tag
{
    HomeGridStyle* gridStyle = [HomeGridStyle defaultStyle];
    
    NSArray* gridItemArray = [self getHomeGridItemArrayWithTag:tag];
    
    NSMutableArray* homeMenuArrayView = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    HomeMenuView* menuView = nil;
    for (int i = 0; i < [gridItemArray count]; i ++) {
        if(0 == (i % (gridStyle.rowCount*gridStyle.columnCount))){
            menuView = [[[HomeMenuView alloc] initWithFrame:homeView.bounds] autorelease];
            menuView.backgroundColor = [UIColor clearColor];
            menuView.gridView.frame = CGRectMake(20, 90, CGRectGetWidth(homeView.bounds)-2*20, CGRectGetHeight(homeView.bounds)-90);
            menuView.backgroundColor = [UIColor clearColor];
            [homeMenuArrayView addObject:menuView];
        }
        if(nil != menuView){
            [menuView.gridView addGridItemView:[HomeGridItemView layoutHomeGridItemView:[[gridItemArray objectAtIndex:i] integerValue] delegate:self]];
        }
    }
    
    [homeMenuArrayView enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [((HomeMenuView*)obj).gridView loadHomeGridView];
    }];
    
    return homeMenuArrayView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[RTSSNotificationCenter standardRTSSNotificationCenter] addNotificationWithType:RTSSNotificationTypeUserPortrait observer:self selector:@selector(updateUserPortrait:) object:nil];
    
    [[RTSSNotificationCenter standardRTSSNotificationCenter] addNotificationWithType:RTSSNotificationTypeChangeAccount observer:self selector:@selector(updateCutomerAccount:) object:nil];
}

- (void)loadData{
#ifdef APPLICATION_BUILDING_RELEASE
    [[[MManager sharedMManager]getSession].mMyUser syncProperty:self];
    [self loadCustomerSync:YES];
#endif
}

- (void)loadCustomerSync:(BOOL)isShowWaiting{
#ifdef APPLICATION_BUILDING_RELEASE
    if(isShowWaiting){
        [self startWaitingIndicator];
    }
    [[[MManager sharedMManager]getSession].mMyCustomer sync:self];
#endif
}



-(void)loadSubcriberSyc:(BOOL)isShowWaiting{
#ifdef APPLICATION_BUILDING_RELEASE
    if(isShowWaiting){
        [self startWaitingIndicator];
    }
    Subscriber *subcsciber = [homeModel getCustomerSubscriber];
    [subcsciber sync:self];
#endif
    
}

#pragma mark FreeSource
- (void)clearAccountSource
{
    [homeModel clear];
    [Session sharedSession].mCurrentSubscriber = nil;
    [Session sharedSession].mCurrentAccount = nil;
    
    homeBottleView.homeDisplayView.homeMarkView.resourceValueLabel.text                         = @"";
    homeBottleView.homeDisplayView.homeMarkView.resourceNameLabel.text                          = @"";
    homeBottleView.homeDisplayView.homeMarkView.bottleMarkView.currentSourceNameLabel.text      = @"";
    homeBottleView.homeDisplayView.homeMarkView.bottleMarkView.currentSourceIdLabel.text        = @"";
    homeBottleView.homeDisplayView.homeMarkView.bottleMarkView.currentRemainingLabel.text       = @"";
    homeBottleView.homeDisplayView.homeMarkView.bottleMarkView.currentRemainingValueLabel.text  = @"";
    [homeBottleView.homeDisplayView.homeMarkView.transferRuleView removeTransferRuleNumber];
    
    [homeBottleView.homeDisplayView updateBottleVolume:0.0 animated:NO];
}

- (void)refreshTransferUI:(id<ITransferable>)transfer{
    
    if(nil != transfer){
        
        // 设置当前Account的钱数
        homeBottleView.homeDisplayView.homeMarkView.resourceNameLabel.text  = NSLocalizedString(@"Home_Account_Balance_Label", nil);
        homeBottleView.homeDisplayView.homeMarkView.resourceValueLabel.text = [CommonUtils formatMoneyWithPenny:[[MManager sharedMManager] getSession].mCurrentSubscriber.mDefaultAccount.mRemainAmount decimals:2 unitEnable:YES];
        
        // 赠送提示
        NSString* numberString = [CommonUtils formatResourcesWithValue:homeModel.currentTransferValue unit:[transfer getUnit] decimals:0];
        [homeBottleView.homeDisplayView.homeMarkView.transferRuleView setTransferRuleNumber:numberString editedImage:[UIImage imageNamed:@"common_edit.png"] title:NSLocalizedString(@"Home_TransferRule_Per_Gift", nil)];
        
        // 设置当前瓶子资源的显示
        homeBottleView.homeDisplayView.homeMarkView.bottleMarkView.currentSourceNameLabel.text = [transfer getItemName];
        homeBottleView.homeDisplayView.homeMarkView.bottleMarkView.currentSourceIdLabel.text = [transfer getSubscriberId];
        homeBottleView.homeDisplayView.homeMarkView.bottleMarkView.currentRemainingLabel.text = NSLocalizedString(@"Home_Remaining_Balance_Label", nil);
        homeBottleView.homeDisplayView.homeMarkView.bottleMarkView.currentRemainingValueLabel.text = [CommonUtils formatResourcesWithValue:[transfer getRemainAmount] unit:[transfer getUnit]];
        
        // 更新瓶子水颜色
        UIColor* waterColor = [RTSSAppStyle getFreeResourceColorWithIndex:homeModel.currentTransferIndex];
        [RTSSAppStyle currentAppStyle].pouringWatterColor = waterColor;
        homeBottleView.homeDisplayView.bottleView.color = waterColor;
        
        // 更新瓶子容量
        if(0 == [transfer getTotalAmount]){
            [homeBottleView.homeDisplayView updateBottleVolume:0.0 animated:NO];
        }else {
            CGFloat volume = ([transfer getRemainAmount]*1.0/[transfer getTotalAmount]);
            [homeBottleView.homeDisplayView updateBottleVolume:volume animated:NO];
        }
    }
}

- (void)refreshNextTransfer{
    id<ITransferable> transfer = [homeModel getTransferWithIndex:homeModel.currentTransferIndex+1];
    if(nil != transfer){
        [self refreshTransferUI:transfer];
    }
}

- (void)refreshLastTransfer{
    id<ITransferable> transfer = [homeModel getTransferWithIndex:0];
    if(nil != transfer){
        [self refreshTransferUI:transfer];
    }
}

- (void)refreshCurrentTransfer{
    if(nil != homeModel.currentTransfer){
        NSInteger index = [homeModel getIndexWithITransferable:homeModel.currentTransfer];
        id<ITransferable> transferable = [homeModel getTransferWithIndex:index];
        if(nil != transferable){
            [self refreshTransferUI:transferable];
        }
    }
}

- (BOOL)refreshTransfer{
    if((HomeTransferTransactionStatusGiftSuccessful == homeModel.currentTransferTransactionStatus && HomeBottlePouringOutFinish == homeBottlePouringStatus) ||
       (HomeTransferTransactionStatusReceiveSuccessful == homeModel.currentTransferTransactionStatus && HomeBottlePouringInFinish == homeBottlePouringStatus) ||
       (HomeTransferTransactionStatusFriendsGiftSuccessful == homeModel.currentTransferTransactionStatus)){
        
        NSInteger index = [homeModel getIndexWithITransferable:homeModel.currentTransfer];
        id<ITransferable> transferable = [homeModel getTransferWithIndex:index];
        if(nil != transferable){
            [self refreshTransferUI:transferable];
        }
        
        if(HomeTransferTransactionStatusGiftSuccessful == homeModel.currentTransferTransactionStatus){
            [self handleTransferTransaction:HomeTransferTransactionStatusGiftFinish];
        }else if(HomeTransferTransactionStatusReceiveSuccessful == homeModel.currentTransferTransactionStatus){
            [self handleTransferTransaction:HomeTransferTransactionStatusReceiveFinished];
        }else if(HomeTransferTransactionStatusFriendsGiftSuccessful == homeModel.currentTransferTransactionStatus){
            [self handleTransferTransaction:HomeTransferTransactionStatusFriendsGiftFinish];
        }
        return YES;
    }
    return NO;
}

- (void)addTransferTransactionEventItem{
    @try {
        User* user = [[User alloc] init];
        user.mId = [homeModel getGiftTransferId];
        user.mName = [homeModel getGiftTransferName];
        user.mPhoneNumber = [homeModel getGiftTransferId];
        
        [[Friends shareFriends] add:user];
        [user release];
    }
    @catch (NSException *exception) {
        
    }
    
    @try {
        EventItem* event = [[EventItem alloc] init];
        event.mDescription = @"balance transfer";
        event.mPeerPhoneNumber = [homeModel getGiftTransferId];
        event.mTimeStamp = time(NULL);
        event.mType = EventTypeBalanceTransferIn;
        
        /*
        NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithCapacity:0];
        [parameters setObject:[NSNumber numberWithLongLong:[homeModel getGiftTransferValue]] forKey:SERVICE_AMOUNT_KEY];
        [parameters setObject:[homeModel.currentTransfer getSubscriberType] forKey:SERVICE_TYPE_KEY];
        [parameters setObject:[homeModel.currentTransfer getItemId] forKey:SERVICE_ID_KEY];
        [parameters setObject:[homeModel getGiftTransferId] forKey:SERVICE_ID_SOURCE_KEY];
        [parameters setObject:[homeModel getGiftTransferName] forKey:SERVICE_TYPE_SOURCE_KEY];
        [parameters setObject:[NSNumber numberWithInt:UserStatusTransferSuccessful] forKey:@"status"];
        event.mParameters = parameters;
         */
        
        [[Events sharedEvents] addEvent:event];
        [event release];
    }
    @catch (NSException *exception) {
        
    }
}

#pragma mark notification
- (void)updateUserPortrait:(NSNotificationCenter*)notification{
    // 头像更新
    homeNavigationBar.portraitImageView.portraitImage = [[Cache standardCache] getSmallPortraitImageWithUrl:[Session sharedSession].mMyUser.mPortrait completion:^(UIImage *image) {
        homeNavigationBar.portraitImageView.portraitImage = image;
    }];
}

- (void)updateCutomerAccount:(NSNotificationCenter*)notification{
    // 账户更新
    self.homeSwithAccounts = YES;
}

#pragma mark Action
- (void)headImageAction:(UIButton*)button{
    if(homeBottleView.homeDisplayView.homeMarkView.quadCurveMenu.expanding){
        homeBottleView.homeDisplayView.homeMarkView.quadCurveMenu.expanding = NO;
    }
    
    PersonCenterViewController * personCenter = [[PersonCenterViewController alloc] init];
    [self.navigationController pushViewController:personCenter animated:YES];
    [personCenter release];
}

- (void)transferRuleAction:(UIButton*)button{
    AlertController* alert = [[AlertController alloc] initWithTitle:nil message:NSLocalizedString(@"Home_Balance_Alert_Title", nil) delegate:self tag:HomeAlertControllerTagTransferInput cancelButtonTitle:NSLocalizedString(@"UIAlertView_Cancel_String", nil) otherButtonTitles:NSLocalizedString(@"UIAlertView_Confirm_String", nil),nil];
    
    NSString* amountHolder = [CommonUtils formatResourcesWithValue:homeModel.currentTransferValue unit:[homeModel.currentTransfer getUnit] decimals:0 unitEnable:NO];
    
    NSString* unitName = [CommonUtils getUnitName:[homeModel.currentTransfer getUnit]];
    UIFont* unitFont = [RTSSAppStyle getRTSSFontWithSize:10.0];
    NSDictionary* numberDic = [NSDictionary dictionaryWithObjectsAndKeys:unitFont,NSFontAttributeName, nil];
    CGSize numberSize = [unitName boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:numberDic context:nil].size;
    
    UILabel* leftLabel = [CommonUtils labelWithFrame:CGRectMake(0, 0, numberSize.width+5, 30) text:unitName textColor:[RTSSAppStyle currentAppStyle].textSubordinateColor textFont:unitFont tag:20];
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.backgroundColor = [UIColor clearColor];
    
    [alert addTextFieldWithStyle:AlertControllerStylePlainTextInput holder:amountHolder leftView:leftLabel rightView:nil textLength:3 textColor:[RTSSAppStyle currentAppStyle].textMajorColor textMode:AlertControllerTextModeNumber];
    [alert showInViewController:self];
    [alert release];
}

- (void)bottleAction:(UIButton*)button{
    if(homeBottleView.homeDisplayView.homeMarkView.quadCurveMenu.expanding || HomeTransferTransactionStatusDefault != homeModel.currentTransferTransactionStatus){
        homeBottleView.homeDisplayView.homeMarkView.quadCurveMenu.expanding = NO;
        return;
    }
    
    if(NO == [CommonUtils objectIsValid:homeModel.currentTransferArray]){
        [self loadSubcriberSyc:YES];
    }else{
        [self refreshNextTransfer];
    }
}

#pragma mark Gift Action
- (void)handleTransferTransaction:(HomeTransferTransactionStatus)status{
    homeModel.currentTransferTransactionStatus = status;
    
    if(HomeTransferTransactionStatusLocationFinished == status){
        return;
    }else if(HomeTransferTransactionStatusLocationFailed == status){
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Common_Loaction_Failed", nil)];
    }else if(HomeTransferTransactionStatusLocationException == status){
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Common_Loaction_Failed", nil)];
    }else if(HomeTransferTransactionStatusGiftBegin == status){
        return;
    }else if(HomeTransferTransactionStatusGifting == status){
        return;
    }else if(HomeTransferTransactionStatusGiftSuccessful == status){
        return;
    }else if(HomeTransferTransactionStatusGiftFailed == status){
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Home_Gift_Fail_Message", nil)];
        if(HomeBottlePouringOutProceed == homeBottlePouringStatus){
            [self stopPouringOutAnimation];
            [self stopPouringOutCountdown];
        }
    }else if(HomeTransferTransactionStatusGiftFinish == status){
        
    }else if(HomeTransferTransactionStatusReceiveBegin == status){
        return;
    }else if(HomeTransferTransactionStatusReceiving == status){
        return;
    }else if(HomeTransferTransactionStatusReceiveSuccessful == status){
        return;
    }else if(HomeTransferTransactionStatusReceiveFailed == status){
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Home_Receive_Fail_Message", nil)];
    }else if(HomeTransferTransactionStatusReceiveFinished == status){
        AlertController* alert = [[AlertController alloc] initWithTitle:@"" message:NSLocalizedString(@"Home_Receive_Successful_Message", nil) delegate:nil tag:0 cancelButtonTitle:NSLocalizedString(@"UIAlertView_Confirm_String", nil) otherButtonTitles:nil,nil];
        [alert showInViewController:self];
        [alert release];
    }else if(HomeTransferTransactionStatusException == status){

    }else if(HomeTransferTransactionStatusNetworkError == status){
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"ErroMessage_Status_Network", nil)];
    }else if(HomeTransferTransactionStatusTimeOut == status){
    
    }else if(HomeTransferTransactionStatusSyncAccountFailed == status){
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Home_SyncAccount_Failed_Error", nil)];
    }else if(HomeTransferTransactionStatusFriendsGift == status){
        return;
    }else if(HomeTransferTransactionStatusFriendsGiftSuccessful == status){
        return;
    }else if(HomeTransferTransactionStatusFriendsGiftFailed == status){
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Home_Gift_Fail_Message", nil)];
    }else if(HomeTransferTransactionStatusFriendsGiftFinish == status){
        
    }else{
        
    }
    
    // 状态复位
    homeBottlePouringStatus = HomeBottlePouringInitial;
    homeModel.currentTransferTransactionStatus = HomeTransferTransactionStatusDefault;
    [[TransferTransaction sharedTransferTransaction] close];
    [self stopWaitingIndicator];
    [self removePouringNotification];
}

- (void)startWaitingIndicator{
    if(nil == [homeWaitingView superview]){
        [self.view addSubview:homeWaitingView];
        [homeWaitingView startWaiting];
    }
}

- (void)stopWaitingIndicator{
    if(nil != [homeWaitingView superview]){
        [homeWaitingView stopWaiting];
        [homeWaitingView removeFromSuperview];
    }
}

#pragma mark 选取朋友完成
- (void)showFriendsGiftAlert{
    if(homeModel.currentTransferValue > [homeModel.currentTransfer getRemainAmount]){
        NSString* numberString = [CommonUtils formatResourcesWithValue:[homeModel.currentTransfer getRemainAmount] unit:[homeModel.currentTransfer getUnit]];
        NSString* message = [NSString stringWithFormat:NSLocalizedString(@"Home_Transfer_Balance_Amount_Larger_Than_Error", nil), numberString];
        [APPLICATION_KEY_WINDOW makeToast:message];
    }else{
        NSString* numberString = [CommonUtils formatResourcesWithValue:homeModel.currentTransferValue unit:[homeModel.currentTransfer getUnit]];
        NSString* message = [NSString stringWithFormat:NSLocalizedString(@"Home_Friends_Gift_Alert_Message", nil), numberString, homeModel.friendsGiftUser.mName];
        
        AlertController* alert = [[AlertController alloc] initWithTitle:nil message:message delegate:self tag:HomeAlertControllerTagFriendsGift cancelButtonTitle:NSLocalizedString(@"UIAlertView_Cancel_String", nil) otherButtonTitles:NSLocalizedString(@"UIAlertView_Confirm_String", nil),nil];
        [alert showInViewController:self];
        [alert release];
    }
}

- (void)fetchFriendFinish:(User *)friendInfo{
    if(nil != friendInfo){
        homeModel.friendsGiftUser = friendInfo;
        [self performSelector:@selector(showFriendsGiftAlert) withObject:nil afterDelay:1.0];
    }
}

#pragma mark 接收者确认完成
- (void)receiverConfirmFinish{
    [self stopWaitingIndicator];
    [self startPouringOutCountdown];
}

#pragma mark 启动倒水倒计时
- (void)startPouringOutCountdown{
    homeBottlePouringStatus = HomeBottlePouringOutWaiting;
    
    if(nil == [homeCountdownView superview]){
        [self.view addSubview:homeCountdownView];
        [homeBottleView.homeDisplayView openBottleCap];
    }
    [homeCountdownView startCountdown];
}

#pragma mark 停止倒水倒计时
- (void)stopPouringOutCountdown{
    if(nil != [homeCountdownView superview]){
        [homeCountdownView stopCountdown];
        [homeCountdownView removeFromSuperview];
        
        [homeBottleView.homeDisplayView closeBottleCap];
    }
}

#pragma mark 播放倒水动画
- (void)playPouringOutAnimation:(NSNumber*)xyTheTa{
    homeBottlePouringStatus = HomeBottlePouringOutProceed;
    [homeView scrollEnabled:NO];
    
    // 停止倒计时
    [homeCountdownView stopCountdown];
    
    // 标记视图消失
    [homeBottleView.homeDisplayView dismissHomeMarkView];
    [homeNavigationBar dismissHomeNavigationBar];
    
    // 显示倒水方向
    if(0 < [xyTheTa doubleValue]){
        homeBottleView.homePouringOutViewGroup.hidden = NO;
        [homeBottleView.homePouringOutViewGroup addHomePouringOutView];
        homeBottleView.homePouringOutViewGroup.isHiddenLeft  = NO;
        homeBottleView.homePouringOutViewGroup.isHiddenRight = YES;
    }else{
        homeBottleView.homePouringOutViewGroup.hidden = NO;
        [homeBottleView.homePouringOutViewGroup addHomePouringOutView];
        homeBottleView.homePouringOutViewGroup.isHiddenLeft  = YES;
        homeBottleView.homePouringOutViewGroup.isHiddenRight = NO;
    }
    
    // 启动倒水声音
    [homeBottleView.homeDisplayView playOpenPouringAudio];
}

#pragma mark 停止倒水动画
- (void)stopPouringOutAnimation{
    [homeView scrollEnabled:YES];
    
    // 标记视图显示
    [homeBottleView.homeDisplayView showHomeMarkView];
    [homeNavigationBar showHomeNavigationBar];
    
    // 倒水视图移除
    homeBottleView.homePouringOutViewGroup.hidden = YES;
    [homeBottleView.homePouringOutViewGroup removeHomePouringOutView];
    
    // 停止倒水声音
    [homeBottleView.homeDisplayView stopOpenPouringAudio];
}

#pragma mark Accept Action
#pragma mark 赠送者赠送成功
- (void)presentFriendFinish{
    [self startPouringInCountdown];
    
    [self loadSubcriberSyc:NO];
}

#pragma mark 启动进水倒计时
- (void)startPouringInCountdown{
    homeBottlePouringStatus = HomeBottlePouringInWaiting;
    
    if(nil == [homeCountdownView superview]){
        [self.view addSubview:homeCountdownView];
        [homeBottleView.homeDisplayView openBottleCap];
    }
    [homeCountdownView startCountdown];
    
    [self performSelector:@selector(playPouringInAnimation:) withObject:[NSNumber numberWithDouble:1] afterDelay:1.0];
}

#pragma mark 停止进水倒计时
- (void)stopPouringInCountdown{
    if(nil != [homeCountdownView superview]){
        [homeCountdownView stopCountdown];
        [homeCountdownView removeFromSuperview];
        
        [homeBottleView.homeDisplayView closeBottleCap];
    }
}

#pragma mark 播放进水动画
- (void)playPouringInAnimation:(NSNumber*)xyTheTa{
    homeBottlePouringStatus = HomeBottlePouringInProceed;
    [homeView scrollEnabled:NO];
    
    // 停止倒计时
    [homeCountdownView stopCountdown];
    
    // 标记视图消失
    [homeBottleView.homeDisplayView dismissHomeMarkView];
    [homeNavigationBar dismissHomeNavigationBar];
    
    // 显示进水方向
    if(0 < [xyTheTa doubleValue]){
        homeBottleView.homePouringInViewGroup.hidden = NO;
        [homeBottleView.homePouringInViewGroup addHomePouringInView];
    }else{
        homeBottleView.homePouringInViewGroup.hidden = NO;
        [homeBottleView.homePouringInViewGroup addHomePouringInView];
    }
    
    [homeBottleView.homeDisplayView playOpenPouringAudio];
    
    [self performSelector:@selector(stopPouringInAnimation) withObject:nil afterDelay:2.0];
}

#pragma mark 停止进水动画
- (void)stopPouringInAnimation{
    homeBottlePouringStatus = HomeBottlePouringInFinish;
    [homeView scrollEnabled:YES];
    
    // 标记视图显示
    [homeBottleView.homeDisplayView showHomeMarkView];
    [homeNavigationBar showHomeNavigationBar];
    
    // 倒水视图移除
    homeBottleView.homePouringInViewGroup.hidden = YES;
    [homeBottleView.homePouringInViewGroup removeHomePouringInView];
    
    [homeBottleView.homeDisplayView stopOpenPouringAudio];
    
    [self performSelector:@selector(receiveGiftFinish) withObject:nil afterDelay:0.5];
}

#pragma mark 接收完成
- (void)receiveGiftFinish{
    [self stopPouringInCountdown];
    [self startWaitingIndicator];
    [self refreshTransfer];
}

#pragma mark 左右倾斜手机启动倒水动画
- (void)bottleLeanAppear:(double)xyTheta{
    // 手机左右倾斜时，启动倒水动画
    if(HomeBottlePouringOutWaiting == homeBottlePouringStatus){
        [self playPouringOutAnimation:[NSNumber numberWithDouble:xyTheta]];
        //
        if([homeModel getReceiveSubscriberId].length > 0){
            [homeModel.currentTransfer transferWithPeerId:[homeModel getReceiveSubscriberId] andAmount:homeModel.currentTransferValue andDelegate:self];
        }else{
            [self handleTransferTransaction:HomeTransferTransactionStatusGiftFailed];
        }
    }
}

- (void)bottleLeanDisappear:(double)xyTheta{
    // 手机恢复到原始，停止倒水动画
    if(HomeBottlePouringOutProceed == homeBottlePouringStatus){
        homeBottlePouringStatus = HomeBottlePouringOutFinish;
        [self stopPouringOutAnimation];
        [self stopPouringOutCountdown];
        [self showTransferSuccessAlert];
    }
}

#pragma mark 移除所有通知
- (void)removePouringNotification{
    RTSSNotificationCenter* notification = [RTSSNotificationCenter standardRTSSNotificationCenter];
    
    [notification removeNotificationWithType:RTSSNotificationTypePeerStatusUpdated observer:self object:nil];
    
    [notification removeNotificationWithType:RTSSNotificationTypeMyStatusUpdated observer:self object:nil];
    
    [notification removeNotificationWithType:RTSSNotificationTypeUserStatusUpdated observer:self object:nil];
    
    [notification removeNotificationWithType:RTSSNotificationTypeTransactionIdle observer:self object:nil];
}

#pragma mark 接收者弹框 接收或者拒绝
- (void)showReceiveAlert{
    long long transferValue = [homeModel getGiftTransferValue];
    
    //    MeasureUnit receiveTransferableUnit = [homeModel.currentTransfer getUnit];
    //    NSString* receiveTransferableName = [homeModel.currentTransfer getSubscriberTypeName];
    //    NSString* receiveTransferableId = [homeModel.currentTransfer getItemId];
    
    MeasureUnit giftTransferableUnit = [homeModel getGiftTransferUnit];
    NSString* giftTransferableName = [homeModel getGiftTransferName];
    NSString* giftTransferableId = [homeModel getGiftTransferId];
    
    NSString* giftString = [NSString stringWithFormat:@"%@(%@) %@", giftTransferableName, giftTransferableId, [CommonUtils formatResourcesWithValue:transferValue unit:giftTransferableUnit decimals:0]];
    
    //    NSString* receiveString = [NSString stringWithFormat:@"%@ %@", receiveTransferableName, [CommonUtils formatResourcesWithValue:transferValue unit:receiveTransferableUnit decimals:0]];
    
    NSString* nameString = homeModel.defaultSelectedItemView.itemUser.mName;
    NSString* message = [NSString stringWithFormat:@"%@ wants to gift you with %@.", nameString, giftString];
    
    AlertController* alert = [[AlertController alloc] initWithTitle:nil message:message delegate:self tag:HomeAlertControllerTagReceiveGift cancelButtonTitle:NSLocalizedString(@"UIAlertView_Refuse_String", nil) otherButtonTitles:NSLocalizedString(@"UIAlertView_Receive_String", nil),nil];
    [alert showInViewController:self];
    [alert release];
}

- (void)showDeclineAlert{
    NSString* message = NSLocalizedString(@"Home_Refuse_Alert_Message", nil);
    
    AlertController* alert = [[AlertController alloc] initWithTitle:nil message:message delegate:self tag:HomeAlertControllerTagRefuseGift cancelButtonTitle:NSLocalizedString(@"UIAlertView_Confirm_String", nil) otherButtonTitles:nil,nil];
    [alert showInViewController:self];
    [alert release];
}

- (void)showTransferSuccessAlert{
    if((HomeTransferTransactionStatusGiftSuccessful == homeModel.currentTransferTransactionStatus && HomeBottlePouringOutFinish == homeBottlePouringStatus) ||
       (HomeTransferTransactionStatusFriendsGiftSuccessful == homeModel.currentTransferTransactionStatus)){
        AlertController* alert = [[AlertController alloc] initWithTitle:nil message:NSLocalizedString(@"Home_Gift_Successful_Message", nil) delegate:self tag:HomeAlertControllerTagGiftSuccess cancelButtonTitle:NSLocalizedString(@"UIAlertView_Confirm_String", nil) otherButtonTitles:nil,nil];
        [alert showInViewController:self];
        [alert release];
    }
}

#pragma mark RadarPickerViewControllerDelegate
#pragma mark 选中一个接收者
- (void)singleSelectedItemView:(ERadarItemView*)itemView{
    if(nil != itemView && nil != itemView.itemInfo){
        homeModel.singleSelectedItemView = itemView;
        
        [self startWaitingIndicator];
        
        RTSSNotificationCenter* notification = [RTSSNotificationCenter standardRTSSNotificationCenter];
        [notification addNotificationWithType:RTSSNotificationTypePeerStatusUpdated observer:self selector:@selector(peerStatusUpdated:) object:nil];
        [notification addNotificationWithType:RTSSNotificationTypeTransactionIdle observer:self selector:@selector(giftTransactionIdle:) object:nil];
    }else{
        // 异常
        [self handleTransferTransaction:HomeTransferTransactionStatusException];
    }
}

#pragma mark 接收者被选中
- (void)defaultSelectedItemView:(ERadarItemView *)itemView{
    if(nil != itemView && nil != itemView.itemInfo){
        homeModel.defaultSelectedItemView = itemView;
        
        RTSSNotificationCenter* notification = [RTSSNotificationCenter standardRTSSNotificationCenter];
        [notification addNotificationWithType:RTSSNotificationTypeMyStatusUpdated observer:self selector:@selector(myStatusUpdated:) object:nil];
        [notification addNotificationWithType:RTSSNotificationTypeUserStatusUpdated observer:self selector:@selector(userStatusUpdated:) object:nil];
        [notification addNotificationWithType:RTSSNotificationTypeTransactionIdle observer:self selector:@selector(receiveTransactionIdle:) object:nil];
        
        NSLog(@"---->赠送者准备赠送,延迟弹出框");
        [self performSelector:@selector(showReceiveAlert) withObject:nil afterDelay:1.0];
    }else{
        // 异常
        [self handleTransferTransaction:HomeTransferTransactionStatusException];
    }
}

#pragma mark Notification
- (void)giftTransactionIdle:(NSNotification*)notification
{
    if(HomeBottlePouringOutProceed != homeBottlePouringStatus && HomeBottlePouringOutWaiting != homeBottlePouringStatus){
        AlertController* alert = [[AlertController alloc] initWithTitle:nil message:NSLocalizedString(@"RadarPickerView_Waiting_Alert_Message", nil) delegate:self tag:BasicViewControllerAlertTagTransactionIdleByGift cancelButtonTitle:NSLocalizedString(@"UIAlertView_NO_String", nil) otherButtonTitles:NSLocalizedString(@"UIAlertView_Continue_String", nil),nil];
        [alert showInViewController:self];
        [alert release];
    }
}

- (void)receiveTransactionIdle:(NSNotification*)notification
{
    AlertController* alert = [[AlertController alloc] initWithTitle:nil message:NSLocalizedString(@"RadarPickerView_Waiting_Alert_Message", nil) delegate:self tag:BasicViewControllerAlertTagTransactionIdleByReceive cancelButtonTitle:NSLocalizedString(@"UIAlertView_NO_String", nil) otherButtonTitles:NSLocalizedString(@"UIAlertView_Continue_String", nil),nil];
    [alert showInViewController:self];
    [alert release];
}

//赠送者 等待RTSSNotificationTypeTransactionCreated通知的回调
- (void)transactionCreated:(NSNotification *)notification
{
    [[RTSSNotificationCenter standardRTSSNotificationCenter] removeNotificationWithType:RTSSNotificationTypeTransactionCreated observer:self object:nil];
    
    NSLog(@"---->赠送---->RTSSNotificationTypeTransactionCreated通知收到.....");
    NSInteger status = [[notification.userInfo objectForKey:@"status"] integerValue];
    if(MappActorFinishStatusOK == status && HomeTransferTransactionStatusGifting == homeModel.currentTransferTransactionStatus){
        
        RadarPickerViewController* radarPickerVC = [[RadarPickerViewController alloc] init];
        radarPickerVC.title = NSLocalizedString(@"RadarPickerView_Selected_Friend_Title", nil);
        radarPickerVC.delegate = self;
        radarPickerVC.radarItemSelectedType = RadarItemSelectedTypeSingle;
        [self.navigationController pushViewController:radarPickerVC animated:YES];
        [radarPickerVC release];
        
    }else {
        [self handleTransferTransaction:HomeTransferTransactionStatusGiftFailed];
    }
}

//赠送者 等待接收者确认的通知,接收或者拒绝
- (void)peerStatusUpdated:(NSNotification *)notification
{
    [[RTSSNotificationCenter standardRTSSNotificationCenter] removeNotificationWithType:RTSSNotificationTypePeerStatusUpdated observer:self object:nil];
    
    NSLog(@"---->接收到接收者回应的通知......");
    NSDictionary* userInfo = notification.userInfo;
    if(UserStatusPeerAccepted == [[userInfo objectForKey:@"transactionStatus"] integerValue]){
        NSLog(@"---->接收者接收赠送");
        [self receiverConfirmFinish];
    }else if(UserStatusPeerRejected == [[userInfo objectForKey:@"transactionStatus"] integerValue]){
        NSLog(@"---->接收者拒绝赠送");
        [self showDeclineAlert];
    }
}

//接收者 等待RTSSNotificationTypeTransactionJoined通知
- (void)transactionJoined:(NSNotification *)notification
{
    // 移除加入的注册通知
    [[RTSSNotificationCenter standardRTSSNotificationCenter] removeNotificationWithType:RTSSNotificationTypeTransactionJoined observer:self object:nil];
    
    NSLog(@"---->接收---->RTSSNotificationTypeTransactionJoined通知收到.....");
    NSInteger status = [[notification.userInfo objectForKey:@"status"] integerValue];
    if(MappActorFinishStatusOK == status && HomeTransferTransactionStatusReceiving == homeModel.currentTransferTransactionStatus){
        
        RadarPickerViewController* radarPickerVC = [[RadarPickerViewController alloc] init];
        radarPickerVC.title = NSLocalizedString(@"RadarPickerView_Receive_Title", nil);
        radarPickerVC.delegate = self;
        radarPickerVC.radarItemSelectedType = RadarItemSelectedTypeDefault;
        [self.navigationController pushViewController:radarPickerVC animated:YES];
        [radarPickerVC release];
        
    }else {
        [self handleTransferTransaction:HomeTransferTransactionStatusException];
    }
}

//接收者 等待更新接收者状态的回调(接收或者拒绝状态)
- (void)userStatusUpdated:(NSNotification*)notification
{
    if(MappActorFinishStatusOK == [[notification.userInfo objectForKey:@"status"] integerValue]){
        NSLog(@"---->更新接收者的状态成功,并添加RTSSNotificationTypePeerStatusUpdated通知");
        //[[RTSSNotificationCenter standardRTSSNotificationCenter] addNotificationWithType:RTSSNotificationTypePeerStatusUpdated observer:self selector:@selector(peerStatusUpdated:) object:nil];
    }
    
    [[RTSSNotificationCenter standardRTSSNotificationCenter] removeNotificationWithType:RTSSNotificationTypeUserStatusUpdated observer:self object:nil];
}

//接收者 等待赠送者赠送的通知,赠送成功或者失败
- (void)myStatusUpdated:(NSNotification *)notification
{
    [[RTSSNotificationCenter standardRTSSNotificationCenter] removeNotificationWithType:RTSSNotificationTypeMyStatusUpdated observer:self object:nil];
    
    NSLog(@"---->赠送者是否赠送成功回应......");
    NSDictionary* userInfo = notification.userInfo;
    if(UserStatusTransferSuccessful == [[userInfo objectForKey:@"transactionStatus"] integerValue]){
        NSLog(@"---->赠送者赠送成功");
        @try {
            [self stopWaitingIndicator];
            [self addTransferTransactionEventItem];
            [self handleTransferTransaction:HomeTransferTransactionStatusReceiveSuccessful];
            [self presentFriendFinish];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }else if(UserStatusTransferFailed == [[userInfo objectForKey:@"transactionStatus"] integerValue]){
        NSLog(@"---->赠送者赠送失败");
        [self handleTransferTransaction:HomeTransferTransactionStatusReceiveFailed];
    }
}

#pragma mark CountdownViewDelegate
- (void)countdownViewFinished:(CountdownView*)view{
    
    if(HomeBottlePouringOutWaiting == homeBottlePouringStatus){
        AlertController* alertController = [[AlertController alloc] initWithTitle:nil message:NSLocalizedString(@"Home_Gift_Timed_Out_Alert_Message", nil) delegate:self tag:HomeAlertControllerTagGiftTimeOut cancelButtonTitle:NSLocalizedString(@"UIAlertView_NO_String", nil) otherButtonTitles:NSLocalizedString(@"UIAlertView_Continue_String", nil),nil];
        [alertController showInViewController:self];
        [alertController release];
    }else if(HomeBottlePouringInWaiting == homeBottlePouringStatus){
        
    }
}

#pragma mark AlertControllerDelegate
- (void)alertController:(AlertController *)alertController didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (alertController.tag) {
        case HomeAlertControllerTagGiftTimeOut:{
            if(alertController.cancelButtonIndex == buttonIndex){
                [self stopPouringOutCountdown];
                [self handleTransferTransaction:HomeTransferTransactionStatusException];
            }else if(alertController.firstOtherButtonIndex == buttonIndex){
                [self startPouringOutCountdown];
            }
            
            break;
        }
        case HomeAlertControllerTagTransferInput:{
            
            if(alertController.cancelButtonIndex == buttonIndex){
                
            }else if(alertController.firstOtherButtonIndex == buttonIndex){
                UITextField * textField = [alertController textFieldAtIndex:0];
                
                if(0 == textField.text.length){
                    [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Home_Transfer_Balance_Amount_Error", nil)];
                }else{
                    homeModel.currentTransferValue = [CommonUtils formatResourcesValueWithValue:[textField.text floatValue] unit:[homeModel.currentTransfer getUnit]];
                    
                    [[Settings standardSettings] setTransferValue:homeModel.currentTransferValue key:[homeModel getUnitKeyStringByUnit:[homeModel.currentTransfer getUnit]]];
                    
                    NSString* numberString = [CommonUtils formatResourcesWithValue:homeModel.currentTransferValue unit:[homeModel.currentTransfer getUnit] decimals:0];
                    [homeBottleView.homeDisplayView.homeMarkView.transferRuleView updateTransferRuleNumber:numberString];
                }
            }
            
            break;
        }
        case HomeAlertControllerTagReceiveGift:{
            if(alertController.cancelButtonIndex == buttonIndex){
                NSLog(@"----->接收者拒绝接收礼物");
                
                TransferTransaction* tt = [TransferTransaction sharedTransferTransaction];
                [tt update:tt.mMe transactionStatus:UserStatusPeerRejected];
                
                dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*5);
                dispatch_after(when, dispatch_get_main_queue(), ^{
                    [self handleTransferTransaction:HomeTransferTransactionStatusReceiveFailed];
                });
                
            }else if(alertController.firstOtherButtonIndex == buttonIndex){
                NSLog(@"----->接收者确认接收礼物");
                
                [self startWaitingIndicator];
                
                TransferTransaction* tt = [TransferTransaction sharedTransferTransaction];
                [tt update:tt.mMe transactionStatus:UserStatusPeerAccepted];
                
            }
            break;
        }
        case HomeAlertControllerTagFriendsGift:{
            if(alertController.cancelButtonIndex == buttonIndex){
                [self handleTransferTransaction:HomeTransferTransactionStatusException];
            }else if(alertController.firstOtherButtonIndex == buttonIndex){
                
                [self startWaitingIndicator];
                
                [homeModel.currentTransfer transferWithPeerId:homeModel.friendsGiftUser.mId andAmount:homeModel.currentTransferValue andDelegate:self];
            }
            break;
        }
        case HomeAlertControllerTagRefuseGift:{
            if(alertController.cancelButtonIndex == buttonIndex){
                [self handleTransferTransaction:HomeTransferTransactionStatusGiftFailed];
            }
            break;
        }
        case HomeAlertControllerTagGiftSuccess:{
            if(alertController.cancelButtonIndex == buttonIndex){
                [self loadSubcriberSyc:YES];
            }
            break;
        }
        case BasicViewControllerAlertTagTransactionIdleByGift:{
            if(alertController.cancelButtonIndex == buttonIndex){
                [self handleTransferTransaction:HomeTransferTransactionStatusException];
            }
            break;
        }
        case BasicViewControllerAlertTagTransactionIdleByReceive:{
            if(alertController.cancelButtonIndex == buttonIndex){
                [self handleTransferTransaction:HomeTransferTransactionStatusReceiveFailed];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark HomeGridItemViewDelegate
- (void)homeGridItemView:(HomeGridItemView *)itemView selectedIndex:(HomeGridViewIndex)index{
    UIViewController* viewController = nil;
    switch (index) {
        case HomeGridViewIndexUsageOverView:{
            MobileUsageViewController *mobileUsage = [[MobileUsageViewController alloc] init];
            viewController = mobileUsage;
            break;
        }
        case HomeGridViewIndexUsageExplore:{
            MyUsageViewController *myUsage = [[MyUsageViewController alloc] init];
            viewController = myUsage;
            break;
        }
        case HomeGridViewIndexUsageData:{
            MobileUsageVC* mobileUsage = [[MobileUsageVC alloc] init];
            viewController = mobileUsage;
            break;
        }
        case HomeGridViewIndexQuickOrder:{
            PlanManageViewController* planManage = [[PlanManageViewController alloc] init];
            viewController = planManage;
            break;
        }
        case HomeGridViewIndexTurboBoost:{
            TurboBoostViewController *turboBoost = [[TurboBoostViewController alloc] init];
            viewController = turboBoost;
            break;
        }
        case HomeGridViewIndexTransfer:{
            TransferViewController* transfer = [[TransferViewController alloc] init];
            viewController = transfer;
            break;
        }
        case HomeGridViewIndexTransform:{
            TransFormViewController* transform = [[TransFormViewController alloc] init];
            viewController = transform;
            break;
        }
        case HomeGridViewIndexWallet:{
            WalletViewController *wallet = [[WalletViewController alloc] init];
            viewController = wallet;
            break;
        }
        case HomeGridViewIndexBudgetControl:{
            BudgetViewController *budget = [[BudgetViewController alloc] init];
            viewController = budget;
            break;
        }
        case HomeGridViewIndexDiscovery:{
            FindHomeViewController* find = [[FindHomeViewController alloc] initWithFindMode:FindModeByDiscovery findTag:0];
            viewController = find;
            break;
        }
        case HomeGridViewIndexMessages:{
            MessageBoxViewController *message = [[MessageBoxViewController alloc] init];
            viewController = message;
            break;
        }

        case HomeGridViewIndexCustomerSupport:{
            SupportViewController *support = [[SupportViewController alloc] init];
            viewController = support;
            break;
        }
        case HomeGridViewIndexServiceRequest:{
            ServiceRequestViewController *serviceRequest = [[ServiceRequestViewController alloc] init];
            viewController = serviceRequest;
            break;
        }
        case HomeGridViewIndexSettings:{
            SettingsViewController* settings = [[SettingsViewController alloc] init];
            viewController = settings;
            break;
        }
        default:
            break;
    }
    
    if(nil != viewController){
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
}

#pragma mark HomeViewDelegate
- (void)homeView:(HomeView *)homeView viewWillAppear:(NSInteger)viewIndex{
    if(0 == viewIndex){
        // 瓶子视图显示
         [homeBottleView.homeDisplayView.bottleView startTraceMotion:[AppDelegate sharedMotionManager]];
    }
}

- (void)homeView:(HomeView *)homeView viewDisappear:(NSInteger)viewIndex{
    if(0 == viewIndex){
        // 瓶子视图消失
        if(homeBottleView.homeDisplayView.homeMarkView.quadCurveMenu.expanding){
            homeBottleView.homeDisplayView.homeMarkView.quadCurveMenu.expanding = NO;
        }
        [homeBottleView.homeDisplayView.bottleView stopTraceMotion];
    }
}

- (void)startDefaultLocation
{
    // 北京亚信大厦的位置longitude:116.277979,latitude:40.042564
    CLLocation* location = [[CLLocation alloc] initWithLatitude:40.042564f longitude:116.277979f];
    [self locationFinished:location];
    [location release];
}

#pragma mark QuadCurveMenuDelegate
- (void)quadCurveMenuExpanding:(BOOL)isExpanding{
    homeBottleView.homeDisplayView.homeMarkView.transferRuleView.hidden = !isExpanding;
}

- (void)quadCurveMenu:(QuadCurveMenu *)menu didSelectIndex:(NSInteger)idx{
    switch (idx) {
        case QuadCurveMenuIndexTransfer:{
            
            if(homeModel.currentTransferValue > [homeModel.currentTransfer getRemainAmount]){
                NSString* numberString = [CommonUtils formatResourcesWithValue:[homeModel.currentTransfer getRemainAmount] unit:[homeModel.currentTransfer getUnit]];
                NSString* largerString = [NSString stringWithFormat:NSLocalizedString(@"Home_Transfer_Balance_Amount_Larger_Than_Error", nil), numberString];
                [APPLICATION_KEY_WINDOW makeToast:largerString];
            }else{
                [self startWaitingIndicator];
                [self handleTransferTransaction:HomeTransferTransactionStatusGiftBegin];
                //[homeLocation startUpdatingLocation];
                [self startDefaultLocation];
            }
            
            break;
        }
        case QuadCurveMenuIndexReceive:{
            [self startWaitingIndicator];
            [self handleTransferTransaction:HomeTransferTransactionStatusReceiveBegin];
            //[homeLocation startUpdatingLocation];
            [self startDefaultLocation];
            
            break;
        }
        case QuadCurveMenuIndexHistory:{
            
            QuickTransferViewController *transferVC = [[QuickTransferViewController alloc] init];
            transferVC.selectType = SelectTypeBySingle;
            transferVC.fetchFriendsInfoBlock = ^ (NSMutableArray *friendsArray) {
                if ([CommonUtils objectIsValid:friendsArray]) {
                    User* itemUser = [friendsArray objectAtIndex:0];
                    if([[homeModel.currentTransfer getSubscriberId] isEqualToString:itemUser.mId]){
                        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Balance_Transfer_FailTo_Myself", nil)];
                    }else{
                        [self handleTransferTransaction:HomeTransferTransactionStatusFriendsGift];
                        [self fetchFriendFinish:itemUser];
                    }
                }
            };
            [self.navigationController pushViewController:transferVC animated:YES];
            [transferVC release];
            
            break;
        }
        default:
            break;
    }
}

#pragma mark RTSSLocationDelegate
- (void)locationServicesEnabled:(BOOL)enabled{
    NSLog(@"---->定位服务是否启用:%d",enabled);
    if(NO == enabled){
        [self stopWaitingIndicator];
        
        AlertController* alert = [[AlertController alloc] initWithTitle:nil message:NSLocalizedString(@"Common_Loaction_Opted_Out", nil) delegate:nil tag:10 cancelButtonTitle:NSLocalizedString(@"UIAlertView_Confirm_String", nil) otherButtonTitles:nil,nil];
        [alert showInViewController:self];
        [alert release];
    }
}

- (void)locationFinished:(CLLocation*)location{
    
    if(nil != location){
        //        [self handleTransferTransaction:HomeTransferTransactionStatusLocationFinished];
        NSLog(@"---->定位成功并停止定位服务.....");
        double longitude = location.coordinate.longitude;
        double latitude  = location.coordinate.latitude;
        
        @try {
            if(HomeTransferTransactionStatusGiftBegin == homeModel.currentTransferTransactionStatus && nil != homeModel.currentTransfer){
                
                // 2. 状态是赠送中
                [self handleTransferTransaction:HomeTransferTransactionStatusGifting];
                
                [[RTSSNotificationCenter standardRTSSNotificationCenter] addNotificationWithType:RTSSNotificationTypeTransactionCreated observer:self selector:@selector(transactionCreated:) object:nil];
                NSLog(@"---->赠送---->添加RTSSNotificationTypeTransactionCreated通知.....");
                
                // 2.创建赠送请求
                NSMutableDictionary* optionDic = [NSMutableDictionary dictionaryWithCapacity:0];
                [optionDic setObject:[homeModel.currentTransfer getItemId] forKey:TRANSFERABLE_ID_GIFT_KEY];
                [optionDic setObject:[homeModel.currentTransfer getItemName] forKey:TRANSFERABLE_NAME_GIFT_KEY];
                [optionDic setObject:[[NSNumber numberWithInteger:[homeModel.currentTransfer getUnit]] stringValue] forKey:TRANSFERABLE_UNIT_GIFT_KEY];
                [optionDic setObject:[[NSNumber numberWithLongLong:homeModel.currentTransferValue] stringValue] forKey:TRANSFERABLE_VALUE_GIFT_KEY];
                
                // 2.创建赠送请求
                [[TransferTransaction sharedTransferTransaction] create:[Session sharedSession].mMyUser longitude:longitude latitude:latitude andOptions:optionDic];
                NSLog(@"---->赠送---->发起RTSSNotificationTypeTransactionCreated请求.....longitude:%f,latitude:%f",longitude,latitude);
                
            }else if(HomeTransferTransactionStatusReceiveBegin == homeModel.currentTransferTransactionStatus && nil != homeModel.currentTransfer){
                
                // 2. 状态是接收中
                [self handleTransferTransaction:HomeTransferTransactionStatusReceiving];
                
                [[RTSSNotificationCenter standardRTSSNotificationCenter] addNotificationWithType:RTSSNotificationTypeTransactionJoined observer:self selector:@selector(transactionJoined:) object:nil];
                NSLog(@"---->接收---->添加RTSSNotificationTypeTransactionJoined通知.....");
                
                // 2.创建接收请求
                NSMutableDictionary* optionDic = [NSMutableDictionary dictionaryWithCapacity:0];
                [optionDic setObject:[homeModel.currentTransfer getItemId] forKey:TRANSFERABLE_ID_RECEIVE_KEY];
                [optionDic setObject:[homeModel.currentTransfer getItemName] forKey:TRANSFERABLE_NAME_RECEIVE_KEY];
                [optionDic setObject:[[NSNumber numberWithInteger:[homeModel.currentTransfer getUnit]] stringValue] forKey:TRANSFERABLE_UNIT_RECEIVE_KEY];
                [optionDic setObject:[homeModel.currentTransfer getSubscriberId] forKey:TRANSFERABLE_SUBSCRIBERID_RECEIVE_KEY];
                
                // 2.创建接收请求
                [[TransferTransaction sharedTransferTransaction] join:[Session sharedSession].mMyUser longitude:longitude latitude:latitude andOptions:optionDic];
                NSLog(@"---->接收---->发起RTSSNotificationTypeTransactionJoined请求.....longitude:%f,latitude:%f",longitude,latitude);
                
            }else {
                // 定位异常
                [self handleTransferTransaction:HomeTransferTransactionStatusLocationException];
            }
        }
        @catch (NSException *exception) {
            // 定位异常
            [self handleTransferTransaction:HomeTransferTransactionStatusLocationException];
        }
    }
}

- (void)locationFailed:(NSError*)error{
    NSLog(@"---->定位失败并停止定位服务.....");
    [self handleTransferTransaction:HomeTransferTransactionStatusLocationFailed];
}

#pragma mark MappActorDelegate
- (void)syncPropertyFinished:(NSInteger)status{
    if(MappActorFinishStatusOK == status){\
        [self updateUserPortrait:nil];
    }
}

-(void)subscriberSyncFinished:(NSInteger)status{
    
    [self stopWaitingIndicator];
    
    if(MappActorFinishStatusOK == status){
        [[Settings standardSettings] setCalibrateDate:[NSDate date]];
        //设置当前subsciber
        Session *session = [[MManager sharedMManager] getSession];
        session.mCurrentSubscriber = [homeModel getCustomerSubscriber];
        session.mCurrentAccount = session.mCurrentSubscriber.mDefaultAccount;
        homeModel.currentTransferArray = [homeModel getTransferableByCustomerSubscribers:session.mCurrentSubscriber];
        
        [self layoutMenuView];
        
        if(HomeTransferTransactionStatusGiftSuccessful == homeModel.currentTransferTransactionStatus){
            [self refreshTransfer];
        }else if(HomeTransferTransactionStatusReceiveSuccessful == homeModel.currentTransferTransactionStatus){
            [self refreshTransfer];
        }else if(HomeTransferTransactionStatusFriendsGiftSuccessful == homeModel.currentTransferTransactionStatus){
            [self refreshTransfer];
        }else {
            [self handleTransferTransaction:HomeTransferTransactionStatusException];
            [self refreshLastTransfer];
        }
        
    }else if (MappActorFinishStatusNetwork == status){
        [self handleTransferTransaction:HomeTransferTransactionStatusNetworkError];
    }else{
        [self handleTransferTransaction:HomeTransferTransactionStatusSyncAccountFailed];
    }

    
    
    
}
- (void)syncFinished:(NSInteger)status{
    if(MappActorFinishStatusOK == status){
        [self loadSubcriberSyc:YES];
    }else if (MappActorFinishStatusNetwork == status){
        [self stopWaitingIndicator];
        [self handleTransferTransaction:HomeTransferTransactionStatusNetworkError];
    }else{
        [self stopWaitingIndicator];
        [self handleTransferTransaction:HomeTransferTransactionStatusSyncAccountFailed];
    }
}

- (void)transferBalanceFinished:(NSInteger)status result:(NSDictionary*)result{
    TransferTransaction* tt = [TransferTransaction sharedTransferTransaction];
    if(MappActorFinishStatusOK == status){
        if(HomeTransferTransactionStatusFriendsGift == homeModel.currentTransferTransactionStatus){
            [self handleTransferTransaction:HomeTransferTransactionStatusFriendsGiftSuccessful];
            [self showTransferSuccessAlert];
        }else if(HomeTransferTransactionStatusGifting == homeModel.currentTransferTransactionStatus){
            [tt update:tt.mPeer transactionStatus:UserStatusTransferSuccessful];
            [self handleTransferTransaction:HomeTransferTransactionStatusGiftSuccessful];
            [self showTransferSuccessAlert];
        }
    }else if (MappActorFinishStatusNetwork == status){
        [self handleTransferTransaction:HomeTransferTransactionStatusNetworkError];
    }else{
        if(HomeTransferTransactionStatusFriendsGift == homeModel.currentTransferTransactionStatus){
            [self handleTransferTransaction:HomeTransferTransactionStatusGiftFailed];
        }else if(HomeTransferTransactionStatusGifting == homeModel.currentTransferTransactionStatus){
            [tt update:tt.mPeer transactionStatus:UserStatusTransferFailed];
            [self handleTransferTransaction:HomeTransferTransactionStatusGiftFailed];
        }
    }
}

@end
