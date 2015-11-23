//
//  SettingsViewController.m
//  RTSS
//
//  Created by shengyp on 14/10/23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "SettingsViewController.h"
#import "AboutViewController.h"
#import "Settings.h"
#import "RTSSAppStyle.h"
#import "SettingsTableView.h"
#import "LanguageViewController.h"
#import "AlertController.h"
#import "DNDViewController.h"
#import "AppDelegate.h"

@interface SettingsViewController ()<SettingsTableViewDelegate,AlertControllerDelegate>{
    
    BOOL                    isRefreshTableViewData;
    
    SettingsTableView       *settingsTableView;
    
    NSString                *versionUpdateUrl;
}

@end

@implementation SettingsViewController

- (void)dealloc{
    
    [settingsTableView release];
    
    [super dealloc];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        isRefreshTableViewData = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(isRefreshTableViewData){
        isRefreshTableViewData = NO;
        [self initSettingsTableViewData];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutSettingTableView{
    settingsTableView = [[SettingsTableView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-20-44)];
    settingsTableView.myTableView.rowHeight = 50;
    settingsTableView.delegate = self;
    [self.view addSubview:settingsTableView];
}

- (void)loadView{
    [super loadView];
    
    [self layoutSettingTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Setting_Title", nil);
}

- (void)initSettingsTableViewData{
    NSMutableArray *sections = [[NSMutableArray alloc] initWithObjects:@"Push",@"DND",@"Language",@"Version",@"About", nil];
    NSMutableArray *rows     = [[NSMutableArray alloc] initWithCapacity:0];
    
    {
        NSMutableArray * rowSections = [[NSMutableArray alloc] initWithCapacity:0];
        
        // ===
        SettingItemModel *itemModel0 = [[[SettingItemModel alloc] init] autorelease];
        itemModel0.itemText         = NSLocalizedString(@"Setting_Item_Push_Message", nil);
        itemModel0.itemType         = SettingsTableViewCellTypeSwitch;
        itemModel0.itemSwitchValue  = YES;
        itemModel0.itemSwitchTag    = SettingItemSwitchTagPushOnSwitch;
        itemModel0.itemSwitchValue  = [[Settings standardSettings] getPushSwitch];
        [rowSections addObject:itemModel0];
        
        [rows addObject:rowSections];
        [rowSections release];
    }
    
//    {
//        NSMutableArray * rowSections = [[NSMutableArray alloc] initWithCapacity:0];
//        
//        // ===
//        SettingItemModel *itemModel0 = [[[SettingItemModel alloc] init] autorelease];
//        itemModel0.itemText         = @"Pattern lock";
//        itemModel0.itemType         = SettingsTableViewCellTypeSwitch;
//        itemModel0.itemSwitchValue  = [[Settings standardSettings] getPatternSwitch];
//        itemModel0.itemSwitchTag    = SettingItemSwitchTagPatternOnSwitch;
//        [rowSections addObject:itemModel0];
//        
//        // ===
//        BOOL isLock = [[Settings standardSettings] getPatternGesturePassword].length != 0;
//        SettingItemModel *itemModel1 = [[[SettingItemModel alloc] init] autorelease];
//        itemModel1.itemText         = isLock == NO ? @"Set pattern lock" : @"Change pattern lock";
//        itemModel1.itemType         = SettingsTableViewCellTypeDefault;
//        itemModel1.itemIndexTag     = SettingItemIndexTagPatternLock;
//        [rowSections addObject:itemModel1];
//        
//        [rows addObject:rowSections];
//        [rowSections release];
//    }
    
    {
        NSMutableArray* rowSections = [[NSMutableArray alloc] initWithCapacity:0];
        
        //
        SettingItemModel * itemModel0 = [[[SettingItemModel alloc] init] autorelease];
        itemModel0.itemText = NSLocalizedString(@"Setting_Item_Language", nil);
        itemModel0.itemType = SettingsTableViewCellTypeDefault;
        itemModel0.itemIndexTag = SettingItemIndexTagLanguage;
        [rowSections addObject:itemModel0];
        
        [rows addObject:rowSections];
        [rowSections release];
    }
    
    {
        NSMutableArray* rowSections = [[NSMutableArray alloc] initWithCapacity:0];
        
        //
        SettingItemModel * itemModel0 = [[[SettingItemModel alloc] init] autorelease];
        itemModel0.itemText = @"DND";
        itemModel0.itemType = SettingsTableViewCellTypeDefault;
        itemModel0.itemIndexTag = SettingItemIndexTagDisturb;
        [rowSections addObject:itemModel0];
        
        [rows addObject:rowSections];
        [rowSections release];
    }
    
    {
        NSMutableArray* rowSections = [[NSMutableArray alloc] initWithCapacity:0];
        
        //
        SettingItemModel * itemModel0 = [[[SettingItemModel alloc] init] autorelease];
        itemModel0.itemText = NSLocalizedString(@"Setting_Item_Version_Update", nil);
        itemModel0.itemType = SettingsTableViewCellTypeDefault;
        itemModel0.itemIndexTag = SettingItemIndexTagChangeVersion;
        [rowSections addObject:itemModel0];
        
        //
        SettingItemModel* itemModel1 = [[[SettingItemModel alloc] init] autorelease];
        itemModel1.itemText         = NSLocalizedString(@"Setting_Item_About", nil);
        itemModel1.itemType         = SettingsTableViewCellTypeDefault;
        itemModel1.itemIndexTag     = SettingItemIndexTagAbout;
        [rowSections addObject:itemModel1];
        
        [rows addObject:rowSections];
        [rowSections release];
    }
    
    [settingsTableView reloadTableViewSection:sections row:rows];
    
    [rows release];
    [sections release];
}

- (void)loadData{
    [self initSettingsTableViewData];
}

- (void)changePatternHandPasswd{
    isRefreshTableViewData = YES;
}

#pragma mark SettingsTableViewDelegate
- (void)settingsTableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath indexSwitch:(UISwitch*)indexSwitch{
    switch (indexSwitch.tag) {
        case SettingItemSwitchTagPushOnSwitch:{
            [settingsTableView updateRowIndexPath:indexPath indexSwitch:indexSwitch];
            break;
        }
        default:
            break;
    }
}

- (void)settingsTableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath indexTag:(NSInteger)indexTag{
    
    UIViewController* viewController = nil;
    switch (indexTag) {

        case SettingItemIndexTagDisturb:{
            DNDViewController * dndVC = [[DNDViewController alloc] init];
            viewController = dndVC;
            break;
        }
        case SettingItemIndexTagLanguage:{
            LanguageViewController *languageVC = [[LanguageViewController alloc] init];
            viewController = languageVC;
            break;
        }
        case SettingItemIndexTagChangeVersion:{
            [[AppDelegate shareAppDelegate] appVersionUpdate:YES alert:YES];
            break;
        }
        case SettingItemIndexTagAbout:{
            AboutViewController* aboutVC = [[AboutViewController alloc] init];
            viewController = aboutVC;
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
