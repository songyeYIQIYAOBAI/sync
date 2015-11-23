//
//  BudgetControlViewController.m
//  RTSS
//
//  Created by baisw on 14/10/23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "BudgetControlViewController.h"
#import "MemberBudgetView.h"
#import "ServiceBudgetViewController.h"
#import "PopView.h"
#import "JoinGroupViewController.h"
#import "AlertController.h"
#import "RTSSAppStyle.h"
#import "CommonUtils.h"
#import "MemberModel.h"
#import "ImageUtils.h"
#import "MemberBudgetViewMgr.h"
#import "MemberScrollView.h"
#import "RTSSAppStyle.h"
#import "FamilyBudgetView.h"
#import "Subscriber.h"
#import "QuickTransferViewController.h"
#import "User.h"

#define _PADDING_TOP_                       30.f
#define _FAMILY_WIDTH_                      290.f
#define _FAMILY_HEIGTH_                     170.f
#define _FAMILY_MEMBER_PADDING_             20.f
#define _NAVHEIGHT_ADD_STATUS_HEIGHT_       64.f


@interface BudgetControlViewController ()
{
    FamilyBudgetView *familyBudgetView;
    MemberScrollView * memberScrollView;
    PopView* popView;
    MemberBudgetView *currentMemberView;
}
@end

@implementation BudgetControlViewController

- (void)dealloc{
    [popView release];
    [familyBudgetView release];
    [memberScrollView release];
    [super dealloc];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView{
    [super loadView];
    
    [self layoutContentView];
    [self layoutNavigationButton];
    [self layoutPopView];
}

- (void)layoutPopView
{
    PopItemView* item1View = [[PopItemView alloc] initWithFrame:CGRectMake(0, 12, 120, 37.75)];
    item1View.popItemButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [item1View.popItemButton setTitle:@"As an owner" forState:UIControlStateNormal];
    [item1View.popItemButton addTarget:self action:@selector(addOwnerAction:) forControlEvents:UIControlEventTouchUpInside];
    
    PopItemView* item2View = [[PopItemView alloc] initWithFrame:CGRectMake(0, 49.75, 120, 37.75)];
    item2View.isSeparate = NO;
    item2View.popItemButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [item2View.popItemButton setTitle:@"As a member" forState:UIControlStateNormal];
    [item2View.popItemButton addTarget:self action:@selector(addMemberAction:) forControlEvents:UIControlEventTouchUpInside];
    
    popView = [[PopView alloc] initWithFrame:CGRectMake(196, 0, 120, 87.5)];
    popView.backgroundColor = [UIColor clearColor];
    [popView setBackgroundImage:[UIImage imageNamed:@"budget_popup_bg.png"]];
    [popView addPopItemView:item1View];
    [popView addPopItemView:item2View];
    [self.view addSubview:popView];
    
    [item1View release];
    [item2View release];
}

- (void)addOwnerAction:(UIButton*)button
{
    [popView dismissPopView:YES];
    
    JoinGroupViewController * vc = [[JoinGroupViewController alloc]init];
    vc.nearbyType = NearbyTypeGroup;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)addMemberAction:(UIButton*)button
{
    [popView dismissPopView:YES];
    
    JoinGroupViewController * vc = [[JoinGroupViewController alloc]init];
    vc.nearbyType = NearbyTypeMember;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

-(void)layoutNavigationButton
{
    //重新定义右键样式
    CGRect buttonRect = CGRectMake(0.f, 0.f, 32.f, 32.f);
    UIButton *addNearButton = [CommonUtils buttonWithType:UIButtonTypeCustom frame:buttonRect title:nil bgImageNormal:[UIImage imageNamed:@"budget_bg_near_d"] bgImageHighlighted:[UIImage imageNamed:@"budget_bg_near_a"] bgImageSelected:nil addTarget:self action:@selector(popMenuItemshow) tag:0];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:addNearButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
}

-(void)popMenuItemshow
{
    if([popView isShowPopView]){
        [popView dismissPopView:YES];
    }else{
        [popView showPopView:YES];
    }
}

-(void)layoutContentView
{
    RTSSAppStyle * colorMgr = [RTSSAppStyle currentAppStyle];
    
    CGSize winSize = self.view.bounds.size;
    
    const int halfView = (winSize.height - _NAVHEIGHT_ADD_STATUS_HEIGHT_)/2;
    //家庭成员视图
    
    familyBudgetView = [[FamilyBudgetView alloc]initWithFrame:CGRectMake(winSize.width/2 - 290/2, (halfView-_FAMILY_HEIGTH_)/2, _FAMILY_WIDTH_, _FAMILY_HEIGTH_)];
    familyBudgetView.backgroundColor = colorMgr.navigationBarColor;
    [familyBudgetView.budgetButton addTarget:self action:@selector(setFamilyBudgetAcount) forControlEvents:UIControlEventTouchUpInside];
    familyBudgetView.familyImageView.image = [UIImage imageNamed:@"common_head_icon_d.png"];
    familyBudgetView.layer.cornerRadius = 8.f;
    familyBudgetView.layer.borderColor = colorMgr.turboBoostBoderColor.CGColor;
    familyBudgetView.layer.borderWidth = 1.f;
    familyBudgetView.clipsToBounds = YES;
    [self.view addSubview:familyBudgetView];
    
    //组成员视图
    memberScrollView = [[MemberScrollView alloc] initWithFrame:CGRectMake(0, halfView, PHONE_UISCREEN_WIDTH, halfView)];
    memberScrollView.backgroundColor = colorMgr.turboBoostUnfoldBgColor;
    memberScrollView.memberDelegate = self;
    [self.view addSubview:memberScrollView];
}

-(void)showPickerOnClick:(UIButton*)sender
{
    SinglePickerController * pick = [[SinglePickerController alloc]init];
    pick.pickerTitle = @"设置提醒";
    pick.pickerType = SinglePickerTypePercent;
    pick.delegate = self;
    pick.pickerArrayData = [NSArray arrayWithObjects:@70, @80, @90, @100, nil];
    [self.view.window addSubview:pick.view];
}

-(void)showServiceBudgetView
{
    ServiceBudgetViewController * serviceBudgetVC = [[ServiceBudgetViewController alloc]init];
    [self.navigationController pushViewController:serviceBudgetVC animated:YES];
    [serviceBudgetVC release];
}

-(void)setFamilyBudgetAcount
{
    AlertController * alert =  [[AlertController alloc]initWithTitle:NSLocalizedString(@"Budget_Budget_Setting_Prompt", nil)
                                                             message:nil
                                                            delegate:self
                                                                 tag:BudgetViewFamily
                                                   cancelButtonTitle:NSLocalizedString(@"UIAlertView_Cancel_String", nil) otherButtonTitles:NSLocalizedString(@"UIAlertView_Confirm_String", nil),nil];
    [alert addTextFieldWithStyle:AlertControllerStylePlainTextInput placeholder:NSLocalizedString(@"UIAlertView_Input_holder", nil)];
    [alert showInViewController:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Budget_Title", nil);
    
    //清除所有
    MemberBudgetViewMgr * viewMgr = [MemberBudgetViewMgr getMemberBudgetMgr];
    [viewMgr removeAllMemberViewFromSuperView];
    
    [self loadData];
    
    [memberScrollView initScrollView];
}

- (void)loadData{
    NSMutableArray * memberModels = [NSMutableArray arrayWithCapacity:10];
    
    MemberModel * memberModel = [MemberModel new];
    memberModel.memberHeadImage = [UIImage imageNamed:@"common_head_icon_d.png"];
    memberModel.memberName = @"paul";
    memberModel.memberPhoneNum = @"808080800";
    memberModel.memberNotification = @"30%";
    memberModel.memberBudgetValue = @"30";
    [memberModels addObject:memberModel];
    [memberModel release];
    
    MemberModel * memberModel2 = [MemberModel new];
    memberModel2.memberHeadImage = [UIImage imageNamed:@"common_head_icon_d.png"];
    memberModel2.memberName = @"Lisa";
    memberModel2.memberPhoneNum = @"808080800";
    memberModel2.memberNotification = @"50%";
    memberModel2.memberBudgetValue = @"70";
    [memberModels addObject:memberModel2];
    [memberModel2 release];
    
    MemberBudgetViewMgr * memberMgr = [MemberBudgetViewMgr getMemberBudgetMgr];
    [memberMgr initMemberData:memberModels];
}

#pragma mark -
#pragma mark -FaceToFaceVCDelegate implement
- (void)faceTofaceNearbyType:(NearbyType)nearbyType
{
    NSLog(@"面对面加人");
}

#pragma mark -
#pragma mark -AlertControllerDelegate implement
- (void)alertController:(AlertController *)alertController didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (alertController.tag) {
        case BudgetViewFamily:
        {
            if(buttonIndex == alertController.firstOtherButtonIndex)
            {
                UITextField * textField = [alertController textFieldAtIndex:0];
                [familyBudgetView.budgetButton setTitle:[NSString stringWithFormat:@"€%@",textField.text] forState:UIControlStateNormal];
            }
            break;
        }
        case BudgetViewMember:
        {
            if(buttonIndex == alertController.firstOtherButtonIndex)
            {
                UITextField * textField = [alertController textFieldAtIndex:0];
                [currentMemberView.budgetBtn setTitle:[NSString stringWithFormat:@"€%@",textField.text] forState:UIControlStateNormal];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - MemberScrollViewDelegate implement
-(void)memberScrollActionBudgetOnClick:(MemberBudgetView *)memberView
{
    currentMemberView = memberView;
    
    AlertController * alert =  [[AlertController alloc]initWithTitle:NSLocalizedString(@"Budget_Budget_Setting_Prompt", nil) message:nil delegate:self tag:BudgetViewMember cancelButtonTitle:NSLocalizedString(@"UIAlertView_Cancel_String", nil) otherButtonTitles:NSLocalizedString(@"UIAlertView_Confirm_String", nil),nil];
    [alert addTextFieldWithStyle:AlertControllerStylePlainTextInput placeholder:NSLocalizedString(@"UIAlertView_Input_holder", nil)];
    [alert showInViewController:self];
    [alert release];
}

-(void)memberScrollActionNotificationOnClick:(MemberBudgetView *)memberView
{
    currentMemberView = memberView;
    
    SinglePickerController * pick = [[SinglePickerController alloc]init];
    pick.pickerTitle = NSLocalizedString(@"Budget_Notification_Setting_Prompt", nil);
    pick.pickerType = SinglePickerTypePercent;
    pick.delegate = self;
    pick.pickerArrayData = [NSArray arrayWithObjects:@70, @80, @90, @100, nil];
    [self.view.window addSubview:pick.view];
}

-(void)memberScrollActionBusinessOnClick:(MemberBudgetView *)memberView
{
    currentMemberView = memberView;
    
    ///
    ServiceBudgetViewController * serviceBudgetVC = [[ServiceBudgetViewController alloc]init];
    serviceBudgetVC.title = currentMemberView.personName.text;
    [self.navigationController pushViewController:serviceBudgetVC animated:YES];
    [serviceBudgetVC release];
}

-(void)memberScrollAddMemberBugetViewOnClick
{
    QuickTransferViewController *quickVC = [[QuickTransferViewController alloc] init];
    quickVC.selectType = SelectTypeByMultiple;
    quickVC.fetchFriendsInfoBlock = ^ (NSMutableArray *selectedFriends) {
        if (selectedFriends) {
            for (int i = 0 ; i < [selectedFriends count]; i ++) {
                User *friend = [selectedFriends objectAtIndex:i];
                NSLog(@"friend info name====%@",friend.mName);
                MemberModel * memberModel = [[MemberModel alloc]init];
                memberModel.memberName = friend.mName;
                memberModel.memberPhoneNum = @"14598766789";
                memberModel.memberHeadImage = [UIImage imageNamed:@"friends_default_icon.png"];
                
                MemberBudgetViewMgr * viewMgr = [MemberBudgetViewMgr getMemberBudgetMgr];
                [viewMgr addMemberModel:memberModel];
                [memberModel release];
            }
            [memberScrollView initScrollView];
        }
    };
    [self.navigationController pushViewController:quickVC animated:YES];
    [quickVC release];
}

#pragma mark - SinglePickerDelegate implement
-(void)singlePickerWithDone:(SinglePickerController*)controller selectedIndex:(NSInteger)index
{
    NSNumber * notificationValue = [controller.pickerArrayData objectAtIndex:index];
    [currentMemberView.remindBtn setTitle: [NSString stringWithFormat:@"%@%%", notificationValue] forState:UIControlStateNormal];
    
    [controller.view removeFromSuperview];
    [controller release];
}

-(void)singlePickerWithCancel:(SinglePickerController*)controller
{
    [controller.view removeFromSuperview];
    [controller release];
}

@end
