//
//  RadarPickerViewController.m
//  RTSS
//
//  Created by shengyp on 14/10/23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "RadarPickerViewController.h"
#import "PortraitImageView.h"
#import "WaitingView.h"

#import "RTSSLocation.h"
#import "RTSSAudioPlayer.h"

#import "Session.h"
#import "Cache.h"
#import "TransferTransaction.h"

@interface RadarPickerViewController () {
    RadarView*                  radarView;
    
    NSMutableDictionary*        selectedItemsDic;
    
    RTSSAudioPlayer*            radarAudioPlayer;
    
    WaitingView*                radarWaitingView;
}

@property(nonatomic, assign) BOOL                   isRefreshImage;

@property(nonatomic, assign) RadarPickerStatus      currentPickerStatus;

@property(nonatomic, retain) ERadarItemView*        singleERadarItemView;

@property(nonatomic, retain) ERadarItemView*        defaultERadarItemView;

@end

@implementation RadarPickerViewController
@synthesize radarItemSelectedType, delegate, isRefreshImage, currentPickerStatus;
@synthesize singleERadarItemView, defaultERadarItemView;

- (void)dealloc{
    [radarView release];
    [selectedItemsDic release];
    [radarAudioPlayer release];
    
    [singleERadarItemView release];
    [defaultERadarItemView release];
    
    [radarWaitingView release];
    
    [super dealloc];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.isRefreshImage = NO;
        self.currentPickerStatus   = RadarPickerStatusDefault;
        self.radarItemSelectedType = RadarItemSelectedTypeDefault;
        selectedItemsDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.isRefreshImage = YES;
    
    self.navigationController.navigationBarHidden = NO;
    
    [radarView startRadar];
    
    [self playRadarAudioPlayer];
    
    [self performSelector:@selector(addPickerNotification) withObject:nil afterDelay:1.0];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    self.isRefreshImage = NO;
    
    [radarView stopRadar];
    
    [self stopRadarAudioPlayer];
    
    [self removePickerNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutRadarView{
    // ===
    radarWaitingView = [[WaitingView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-20-44)];
    radarWaitingView.backgroundColor = [UIColor blackColor];
    radarWaitingView.alpha = 0.3;
    
    // ===
    radarView = [[RadarView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-20-44)];
    radarView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    radarView.radarBgColor = [RTSSAppStyle currentAppStyle].radarColor;
    radarView.centerItemView.itemImageView.backgroundColor = [RTSSAppStyle currentAppStyle].radarPortraitBgColor;
    radarView.centerItemView.itemImageView.portraitImage = [[Cache standardCache] getLargePortraitImageWithUrl:[Session sharedSession].mMyUser.mPortrait completion:^(UIImage *image) {
        if(self.isRefreshImage){
            radarView.centerItemView.itemImageView.portraitImage = image;
        }
    }];
    radarView.centerItemView.itemLabel.text = [Session sharedSession].mMyUser.mName;
    [self.view addSubview:radarView];
}

- (void)loadView{
    [super loadView];

    [self layoutRadarView];
}

- (void)addPickerNotification{
    NSLog(@"---->添加RTSSNotificationTypeTransactionIdle通知......");
    [[RTSSNotificationCenter standardRTSSNotificationCenter] addNotificationWithType:RTSSNotificationTypeTransactionIdle observer:self selector:@selector(transactionIdle:) object:nil];
    
    [[RTSSNotificationCenter standardRTSSNotificationCenter] addNotificationWithType:RTSSNotificationTypePeerInfoReady observer:self selector:@selector(peerInfoReady:) object:nil];
    
    if(RadarItemSelectedTypeSingle == self.radarItemSelectedType){
        NSLog(@"---->赠送者---->添加RTSSNotificationTypeUserJoined通知.....");
        [[RTSSNotificationCenter standardRTSSNotificationCenter] addNotificationWithType:RTSSNotificationTypeUserJoined observer:self selector:@selector(userJoined:) object:nil];
        
        [[RTSSNotificationCenter standardRTSSNotificationCenter] addNotificationWithType:RTSSNotificationTypeUserStatusUpdated observer:self selector:@selector(userStatusUpdated:) object:nil];
    }else if(RadarItemSelectedTypeDefault == self.radarItemSelectedType){
        NSLog(@"---->接收者---->添加RTSSNotificationTypeMyStatusUpdated通知.....");
        [[RTSSNotificationCenter standardRTSSNotificationCenter] addNotificationWithType:RTSSNotificationTypeMyStatusUpdated observer:self selector:@selector(myStatusUpdated:) object:nil];
    }
}

- (void)removePickerNotification{
    RTSSNotificationCenter* notification = [RTSSNotificationCenter standardRTSSNotificationCenter];
    [notification removeNotificationWithType:RTSSNotificationTypeTransactionIdle observer:self object:nil];
    [notification removeNotificationWithType:RTSSNotificationTypePeerInfoReady observer:self object:nil];
    
    if(RadarItemSelectedTypeSingle == self.radarItemSelectedType){
        [notification removeNotificationWithType:RTSSNotificationTypeUserJoined observer:self object:nil];
        [notification removeNotificationWithType:RTSSNotificationTypeUserStatusUpdated observer:self object:nil];
    }else if(RadarItemSelectedTypeDefault == self.radarItemSelectedType){
        [notification removeNotificationWithType:RTSSNotificationTypeMyStatusUpdated observer:self object:nil];
    }
}

- (void)playRadarAudioPlayer{
    if(nil == radarAudioPlayer){
        NSURL* radarUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"radar_hold" ofType:@"aif"]];
        radarAudioPlayer = [[RTSSAudioPlayer alloc] initWithURL:radarUrl];
        radarAudioPlayer.avAudioPlayer.numberOfLoops = -1;
    }
    [radarAudioPlayer play];
}

- (void)stopRadarAudioPlayer{
    if(nil != radarAudioPlayer){
        [radarAudioPlayer stop];
    }
}

- (void)startWaitingIndicator{
    if(nil == [radarWaitingView superview]){
        [self.view addSubview:radarWaitingView];
        [radarWaitingView startWaiting];
    }
}

- (void)stopWaitingIndicator{
    if(nil != [radarWaitingView superview]){
        [radarWaitingView stopWaiting];
        [radarWaitingView removeFromSuperview];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)handleRadarPicker:(RadarPickerStatus)status{
    self.currentPickerStatus = status;
    
    if(RadarPickerStatusUserJioned == status){
//        [APPLICATION_KEY_WINDOW makeToast:@"User jioned."];
    }else if(RadarPickerStatusUserSelected == status){
//        [APPLICATION_KEY_WINDOW makeToast:@"User selected"];
    }else if(RadarPickerStatusUserInfo == status){
        
    }else if(RadarPickerStatusPeerJioned == status){
//        [APPLICATION_KEY_WINDOW makeToast:@"Peer selected"];
    }else if(RadarPickerStatusPeerSelected == status){
        
    }else if(RadarPickerStatusPeerInfo == status){
        
    }else{
        
    }
}

#pragma mark action
- (void)backBarButtonAction:(UIButton*)barButtonItem{
    AlertController* alert = [[AlertController alloc] initWithTitle:nil message:NSLocalizedString(@"RadarPickerView_Back_Alert_Leave", nil) delegate:self tag:BasicViewControllerAlertTagRadarPickerBack cancelButtonTitle:NSLocalizedString(@"UIAlertView_Cancel_String", nil) otherButtonTitles:NSLocalizedString(@"UIAlertView_Confirm_String", nil),nil];
    [alert showInViewController:self];
    [alert release];
}

#pragma mark AlertControllerDelegate
- (void)alertController:(AlertController *)alertController didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(BasicViewControllerAlertTagRadarPickerBack == alertController.tag){
        if(alertController.firstOtherButtonIndex == buttonIndex){
            [[TransferTransaction sharedTransferTransaction] close];
            if(RadarItemSelectedTypeSingle == self.radarItemSelectedType){
                if(nil != delegate && [delegate respondsToSelector:@selector(singleSelectedItemView:)]){
                    [delegate singleSelectedItemView:nil];
                }
            }else if(RadarItemSelectedTypeDefault == self.radarItemSelectedType){
                if(nil != delegate && [delegate respondsToSelector:@selector(defaultSelectedItemView:)]){
                    [delegate defaultSelectedItemView:nil];
                }
            }

            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if (BasicViewControllerAlertTagTransactionIdle == alertController.tag){
        if(alertController.cancelButtonIndex == buttonIndex){
            [[TransferTransaction sharedTransferTransaction] close];
            if(RadarItemSelectedTypeSingle == self.radarItemSelectedType){
                if(nil != delegate && [delegate respondsToSelector:@selector(singleSelectedItemView:)]){
                    [delegate singleSelectedItemView:nil];
                }
            }else if(RadarItemSelectedTypeDefault == self.radarItemSelectedType){
                if(nil != delegate && [delegate respondsToSelector:@selector(defaultSelectedItemView:)]){
                    [delegate defaultSelectedItemView:nil];
                }
            }

            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark notification
// 赠送者 接收者
- (void)transactionIdle:(NSNotification *)notification
{
    AlertController* alert = [[AlertController alloc] initWithTitle:nil message:NSLocalizedString(@"RadarPickerView_Waiting_Alert_Message", nil) delegate:self tag:BasicViewControllerAlertTagTransactionIdle cancelButtonTitle:NSLocalizedString(@"UIAlertView_NO_String", nil) otherButtonTitles:NSLocalizedString(@"UIAlertView_Continue_String", nil),nil];
    [alert showInViewController:self];
    [alert release];
}

// 等待RTSSNotificationTypePeerInfoReady通知的回调
- (void)peerInfoReady:(NSNotification*)notification
{
    [self stopWaitingIndicator];
    
    if(RadarItemSelectedTypeSingle == self.radarItemSelectedType){
        [self handleRadarPicker:RadarPickerStatusUserInfo];
        
        if(nil != self.singleERadarItemView){
            self.singleERadarItemView.itemUser = [TransferTransaction sharedTransferTransaction].mPeer;
            self.singleERadarItemView.itemInfo = [TransferTransaction sharedTransferTransaction].mPeerInfo;
            NSLog(@"----->gift------>%@------->%@",self.singleERadarItemView.itemUser, self.singleERadarItemView.itemInfo);
            
            [self performSelector:@selector(selectedItemView:) withObject:self.singleERadarItemView afterDelay:0.5];
        }
    }else if(RadarItemSelectedTypeDefault == self.radarItemSelectedType){
        [self handleRadarPicker:RadarPickerStatusPeerInfo];
        
        [self showPeerERadarItem];
        
        if(nil != self.defaultERadarItemView){
            self.defaultERadarItemView.itemUser = [TransferTransaction sharedTransferTransaction].mPeer;
            self.defaultERadarItemView.itemInfo = [TransferTransaction sharedTransferTransaction].mPeerInfo;
            NSLog(@"----->receive------>%@------->%@",self.defaultERadarItemView.itemUser, self.defaultERadarItemView.itemInfo);
            
            [self performSelector:@selector(myStatusUpdatedFinished:) withObject:self.defaultERadarItemView afterDelay:1.0];
        }
    }
}

// 赠送者 1.等待RTSSNotificationTypeUserJoined通知的回调
- (void)userJoined:(NSNotification *)notification
{
    NSArray* userArray = [[TransferTransaction sharedTransferTransaction] getUsers];
    NSLog(@"---->多个接收者信息:%@", [userArray description]);
    if([CommonUtils objectIsValid:userArray]){
        for (int i = 0; i < [userArray count]; i ++) {
            User* user = [userArray objectAtIndex:i];
            
            ERadarItemView* itemView = [[ERadarItemView alloc] initWithFrame:CGRectMake(0, 0, 60, 70)];
            itemView.backgroundColor = [UIColor clearColor];
            itemView.itemImageView.portraitImage = [[Cache standardCache] getSmallPortraitImageWithUrl:user.mPortrait
                                                                                            completion:^(UIImage *image){
                if(self.isRefreshImage){
                    itemView.itemImageView.portraitImage = image;
                }
            }];

            if([CommonUtils objectIsValid:user.mName]){
                itemView.itemLabel.text = user.mName;
            }
            if([CommonUtils objectIsValid:user.mId]){
                itemView.itemSN = user.mId;
            }
            itemView.itemUser = user;
            [itemView.itemButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [radarView addRadarItemView:itemView];
            [itemView release];
        }
        [self handleRadarPicker:RadarPickerStatusUserJioned];
    }
}

// 赠送者 2.等待RTSSNotificationTypeUserStatusUpdated通知的回调
- (void)userStatusUpdated:(NSNotification *)notification
{
    [self stopWaitingIndicator];
    
    NSInteger status = [[notification.userInfo objectForKey:@"status"] integerValue];
    if(MappActorFinishStatusOK == status){
        
        [self handleRadarPicker:RadarPickerStatusUserSelected];
        
        [self startWaitingIndicator];
        
        [[TransferTransaction sharedTransferTransaction] queryPeerInfo];
    }
}

- (void)singleSelectedUserAction:(ERadarItemView*)itemView
{
    self.singleERadarItemView = itemView;
    
    [self startWaitingIndicator];
    
    [[TransferTransaction sharedTransferTransaction] select:itemView.itemUser];
}

//赠送者 2. 选中接收者跳转到主页
- (void)selectedItemView:(ERadarItemView*)itemView
{
    NSLog(@"---->赠送者---->选中接收者跳转到主页.....");
    if (nil != itemView && nil != delegate && [delegate respondsToSelector:@selector(singleSelectedItemView:)]) {
        [self handleRadarPicker:RadarPickerStatusUserSelected];
        [delegate singleSelectedItemView:itemView];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 接收者 显示赠送者的信息
- (void)showPeerERadarItem
{
    TransferTransaction* tracsaction = [TransferTransaction sharedTransferTransaction];
    if(nil != tracsaction.mPeer && nil != tracsaction.mPeerInfo){
        
        ERadarItemView* itemView = [[ERadarItemView alloc] initWithFrame:CGRectMake(0, 0, 50, 60)];
        itemView.backgroundColor = [UIColor clearColor];
        itemView.itemImageView.portraitImage = [[Cache standardCache] getSmallPortraitImageWithUrl:tracsaction.mPeer.mPortrait completion:^(UIImage *image) {
            if(self.isRefreshImage){
                itemView.itemImageView.portraitImage = image;
            }
        }];
        
        if([CommonUtils objectIsValid:tracsaction.mPeer.mName]){
            itemView.itemLabel.text = tracsaction.mPeer.mName;
        }
        if([CommonUtils objectIsValid:tracsaction.mPeer.mId]){
            itemView.itemSN = tracsaction.mPeer.mId;
        }
        self.defaultERadarItemView = itemView;
        [radarView addRadarItemView:itemView];
        [itemView release];
        
        [self handleRadarPicker:RadarPickerStatusPeerJioned];
    }
}

//接收者 1.等待RTSSNotificationTypeMyStatusUpdated通知
- (void)myStatusUpdated:(NSNotification *)notification
{
    NSLog(@"---->接收者---->RTSSNotificationTypeMyStatusUpdated通知收到.....");

    if(UserStatusPeerSelected == [[notification.userInfo objectForKey:@"transactionStatus"] integerValue]){
        
        [self startWaitingIndicator];
        
        [[TransferTransaction sharedTransferTransaction] queryPeerInfo];
    }
}

//接收者 1.1.延迟跳转到瓶子页面
- (void)myStatusUpdatedFinished:(ERadarItemView*)itemView
{
    NSLog(@"---->接收者---->延迟跳转.....");
    if(nil != itemView && nil != delegate && [delegate respondsToSelector:@selector(defaultSelectedItemView:)]){
        [self handleRadarPicker:RadarPickerStatusPeerSelected];
        [delegate defaultSelectedItemView:itemView];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)buttonAction:(UIButton*)button{
    
    // 默认不做任何动作
    if(RadarItemSelectedTypeDefault == self.radarItemSelectedType){
        return;
    }
    
    button.selected = !button.selected;
    ERadarItemView* radarItemView = (ERadarItemView*)[button superview];
    
    // 动画显示选中项
    if(button.selected){
        [radarItemView selectItem];
    }else{
        [radarItemView unSelectItem];
    }
    
    // 单选
    if(RadarItemSelectedTypeSingle == self.radarItemSelectedType){
        for (NSString* snString in [selectedItemsDic allKeys]) {
            ERadarItemView* itemView = [radarView getRadarItemViewWithSN:snString];
            if(nil != itemView){
                [itemView unSelectItem];
                [selectedItemsDic removeObjectForKey:snString];
            }
        }
        
        if(button.selected){
            [selectedItemsDic setObject:radarItemView.itemUser forKey:radarItemView.itemSN];
            
            [self singleSelectedUserAction:radarItemView];
        }
    // 多选
    }else if(RadarItemSelectedTypeMulti == self.radarItemSelectedType){
        if(button.selected){
            [selectedItemsDic setObject:radarItemView.itemUser forKey:radarItemView.itemSN];
        }else{
            [selectedItemsDic removeObjectForKey:radarItemView.itemSN];
        }
    }
}

@end
