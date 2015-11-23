//
//  HomeViewController.m
//  RTSS
//
//  Created by shengyp on 14/10/21.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "HomeViewController.h"
#import "TransformViewController.h"
#import "TransferViewController.h"
#import "BudgetControlViewController.h"
#import "FriendsViewController.h"
#import "WalletViewController.h"
#import "TurboBoostViewController.h"
#import "PlanManageViewController.h"
#import "MessageBoxViewController.h"
#import "SettingsViewController.h"
#import "MobileUsageViewController.h"
#import "HomeView.h"

#import "RTSSAppDefine.h"

@interface HomeViewController ()<HomeGridItemViewDelegate>{
    HomeView* homeView;
}

@end

@implementation HomeViewController

- (void)dealloc{
    [homeView release];
    
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
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutHomeView{
    homeView = [[HomeView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT)];
    homeView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:homeView];
}

- (void)layoutBottleView{
    
}

- (HomeGridItemView*)layoutHomeGridItemView:(HomeGridViewIndex)gridViewIndex{
    HomeGridItemView* homeGridItemView = [[HomeGridItemView alloc] initWithFrame:CGRectZero];
    homeGridItemView.gridItemIndexTag = gridViewIndex;
    homeGridItemView.delegate = self;
    [homeGridItemView.gridItemButton setTitleEdgeInsets:UIEdgeInsetsMake(40, 0, 0, 0)];
    switch (gridViewIndex) {
        case HomeGridViewIndexMobileUsage:{
            [homeGridItemView.gridItemButton setBackgroundImage:[UIImage imageNamed:@"home_icon_mobileusage.png"] forState:UIControlStateNormal];
            [homeGridItemView.gridItemButton setTitle:NSLocalizedString(@"Home_Menu_Mobile_Usage", nil) forState:UIControlStateNormal];
            break;
        }
        case HomeGridViewIndexTransform:{
            [homeGridItemView.gridItemButton setBackgroundImage:[UIImage imageNamed:@"home_icon_transform.png"] forState:UIControlStateNormal];
            [homeGridItemView.gridItemButton setTitle:NSLocalizedString(@"Home_Menu_Transform", nil) forState:UIControlStateNormal];
            break;
        }
        case HomeGridViewIndexTransfer:{
            [homeGridItemView.gridItemButton setBackgroundImage:[UIImage imageNamed:@"home_icon_transfer.png"] forState:UIControlStateNormal];
            [homeGridItemView.gridItemButton setTitle:NSLocalizedString(@"Home_Menu_Transfer", nil) forState:UIControlStateNormal];
            break;
        }
        case HomeGridViewIndexBudgetControl:{
            [homeGridItemView.gridItemButton setBackgroundImage:[UIImage imageNamed:@"home_icon_budget.png"] forState:UIControlStateNormal];
            [homeGridItemView.gridItemButton setTitle:NSLocalizedString(@"Home_Menu_Budget", nil) forState:UIControlStateNormal];
            break;
        }
        case HomeGridViewIndexFriends:{
            [homeGridItemView.gridItemButton setBackgroundImage:[UIImage imageNamed:@"home_icon_friends.png"] forState:UIControlStateNormal];
            [homeGridItemView.gridItemButton setTitle:NSLocalizedString(@"Home_Menu_Friends", nil) forState:UIControlStateNormal];
            break;
        }
        case HomeGridViewIndexWallet:{
            [homeGridItemView.gridItemButton setBackgroundImage:[UIImage imageNamed:@"home_icon_wallet.png"] forState:UIControlStateNormal];
            [homeGridItemView.gridItemButton setTitle:NSLocalizedString(@"Home_Menu_Wallet", nil) forState:UIControlStateNormal];
            break;
        }
        case HomeGridViewIndexTurboBoost:{
            [homeGridItemView.gridItemButton setBackgroundImage:[UIImage imageNamed:@"home_icon_turboboost.png"] forState:UIControlStateNormal];
            [homeGridItemView.gridItemButton setTitle:NSLocalizedString(@"Home_Menu_Turbo_Boost", nil) forState:UIControlStateNormal];
            break;
        }
        case HomeGridViewIndexPlanManage:{
            [homeGridItemView.gridItemButton setBackgroundImage:[UIImage imageNamed:@"home_icon_planmanage.png"] forState:UIControlStateNormal];
            [homeGridItemView.gridItemButton setTitle:NSLocalizedString(@"Home_Menu_Plan_Manage", nil) forState:UIControlStateNormal];
            break;
        }
        case HomeGridViewIndexMessages:{
            [homeGridItemView.gridItemButton setBackgroundImage:[UIImage imageNamed:@"home_icon_message.png"] forState:UIControlStateNormal];
            [homeGridItemView.gridItemButton setTitle:NSLocalizedString(@"Home_Menu_Messages", nil) forState:UIControlStateNormal];
            break;
        }
        case HomeGridViewIndexSettings:{
            [homeGridItemView.gridItemButton setBackgroundImage:[UIImage imageNamed:@"home_icon_settings.png"] forState:UIControlStateNormal];
            [homeGridItemView.gridItemButton setTitle:NSLocalizedString(@"Home_Menu_Settings", nil) forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
    
    return [homeGridItemView autorelease];
}

- (void)layoutMenuView{
    // ====
    HomeMenuView* menuFristView = [[[HomeMenuView alloc] initWithFrame:homeView.bounds] autorelease];
    menuFristView.backgroundColor = [UIColor clearColor];
    menuFristView.gridView.frame = CGRectMake(0, 90, menuFristView.bounds.size.width, menuFristView.bounds.size.height-90);
    menuFristView.gridView.backgroundColor = [UIColor clearColor];
    [menuFristView.gridView addGridItemView:[self layoutHomeGridItemView:HomeGridViewIndexMobileUsage]];
    [menuFristView.gridView addGridItemView:[self layoutHomeGridItemView:HomeGridViewIndexTransform]];
    [menuFristView.gridView addGridItemView:[self layoutHomeGridItemView:HomeGridViewIndexTransfer]];
    [menuFristView.gridView addGridItemView:[self layoutHomeGridItemView:HomeGridViewIndexBudgetControl]];
    [menuFristView.gridView addGridItemView:[self layoutHomeGridItemView:HomeGridViewIndexFriends]];
    [menuFristView.gridView addGridItemView:[self layoutHomeGridItemView:HomeGridViewIndexWallet]];
    [menuFristView.gridView addGridItemView:[self layoutHomeGridItemView:HomeGridViewIndexTurboBoost]];
    [menuFristView.gridView addGridItemView:[self layoutHomeGridItemView:HomeGridViewIndexPlanManage]];
    [menuFristView.gridView loadHomeGridView];
    [homeView addPageView:menuFristView];
    
    // ====
    HomeMenuView* menuSecondView = [[[HomeMenuView alloc] initWithFrame:homeView.bounds] autorelease];
    menuSecondView.backgroundColor = [UIColor clearColor];
    menuSecondView.gridView.frame = CGRectMake(0, 90, menuSecondView.bounds.size.width, menuSecondView.bounds.size.height-90);
    menuSecondView.gridView.backgroundColor = [UIColor clearColor];
    [menuSecondView.gridView addGridItemView:[self layoutHomeGridItemView:HomeGridViewIndexMessages]];
    [menuSecondView.gridView addGridItemView:[self layoutHomeGridItemView:HomeGridViewIndexSettings]];
    [menuSecondView.gridView loadHomeGridView];
    [homeView addPageView:menuSecondView];
    
    [homeView loadHomeView];
}

- (void)loadView{
    [super loadView];
    // ===
    [self layoutHomeView];
    // ===
    [self layoutMenuView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)loadData{

}

#pragma mark HomeGridItemViewDelegate
- (void)homeGridItemView:(HomeGridItemView *)itemView selectedIndex:(HomeGridViewIndex)index{
    UIViewController* viewController = nil;
    switch (index) {
        case HomeGridViewIndexMobileUsage:{
            MobileUsageViewController *mobileUsage = [[MobileUsageViewController alloc]init];
            viewController = mobileUsage;
            break;
        }
        case HomeGridViewIndexTransform:{
            TransformViewController *transform = [[TransformViewController alloc] init];
            viewController = transform;
            break;
        }
        case HomeGridViewIndexTransfer:{
            TransferViewController *transfer = [[TransferViewController alloc] init];
            viewController = transfer;
            break;
        }
        case HomeGridViewIndexBudgetControl:{
            BudgetControlViewController *budgetControl = [[BudgetControlViewController alloc] init];
            viewController = budgetControl;
            break;
        }
        case HomeGridViewIndexFriends:{
            FriendsViewController *friends = [[FriendsViewController alloc] init];
            viewController = friends;
            break;
        }
        case HomeGridViewIndexWallet:{
            WalletViewController *wallet = [[WalletViewController alloc] init];
            viewController = wallet;
            break;
        }
        case HomeGridViewIndexTurboBoost:{
            TurboBoostViewController *turboBoost = [[TurboBoostViewController alloc] init];
            viewController = turboBoost;
            break;
        }
        case HomeGridViewIndexPlanManage:{
            PlanManageViewController *planManage = [[PlanManageViewController alloc] init];
            viewController = planManage;
            break;
        }
        case HomeGridViewIndexMessages:{
            MessageBoxViewController *messageBox = [[MessageBoxViewController alloc] init];
            viewController = messageBox;
            break;
        }
        case HomeGridViewIndexSettings:{
            SettingsViewController *settings = [[SettingsViewController alloc] init];
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

@end
