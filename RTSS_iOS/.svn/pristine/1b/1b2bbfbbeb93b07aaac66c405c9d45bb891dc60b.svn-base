//
//  SettingsTableView.h
//  EasyTT
//
//  Created by shengyp on 14-10-9.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SettingsTableViewCellType) {
	SettingsTableViewCellTypeDefault,
	SettingsTableViewCellTypeSwitch,
};

typedef NS_ENUM(NSInteger, SettingItemSwitchTag) {
    SettingItemSwitchTagDefault,
    SettingItemSwitchTagPushOnSwitch,
};

typedef NS_ENUM(NSInteger, SettingItemIndexTag) {
    SettingItemIndexTagDefault,
    SettingItemIndexTagDisturb,
    SettingItemIndexTagLanguage,
    SettingItemIndexTagChangeVersion,
    SettingItemIndexTagAbout,
};

@protocol SettingsTableViewDelegate;
@interface SettingsTableView : UIView<UITableViewDataSource,UITableViewDelegate>
{

}

@property(nonatomic,readonly)UITableView* myTableView;
@property(nonatomic,retain)NSMutableArray* sectionArray;
@property(nonatomic,retain)NSMutableArray* rowArray;

@property(nonatomic,assign)id<SettingsTableViewDelegate> delegate;

- (void)reloadTableViewSection:(NSMutableArray*)sections row:(NSMutableArray*)rows;

- (void)updateRowIndexPath:(NSIndexPath *)indexPath indexSwitch:(UISwitch *)indexSwitch;

@end

@protocol SettingsTableViewDelegate <NSObject>

@optional

- (void)settingsTableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath indexSwitch:(UISwitch*)indexSwitch;
- (void)settingsTableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath indexTag:(NSInteger)indexTag;

@end

@interface SettingsTableViewCell : UITableViewCell

@property(nonatomic, readonly)UISwitch  *itemSwitch;
@property(nonatomic, assign, setter=setSwitchHidden:)BOOL switchHidden;

- (void)switchValueChange:(UISwitch*)indexSwitch;

@end

@interface SettingItemModel : NSObject

@property(nonatomic, retain) NSString       *itemText;
@property(nonatomic, assign) NSInteger       itemType;
@property(nonatomic, assign) BOOL            itemSwitchValue;
@property(nonatomic, assign) NSInteger       itemSwitchTag;
@property(nonatomic, assign) NSInteger       itemIndexTag;

@end

