//
//  SettingsTableView.m
//  EasyTT
//
//  Created by shengyp on 14-10-9.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import "SettingsTableView.h"

#import "RTSSAppStyle.h"
#import "CommonUtils.h"
#import "RTSSAppDefine.h"
#import "Settings.h"
#import "AppDelegate.h"
#define SettingsTableViewCellHeight             50
#define SettingsTableViewHeaderHeight           25
#define SettingsTableViewFooterHeight           0.1

@implementation SettingsTableView
@synthesize myTableView,sectionArray,rowArray,delegate;

- (void)dealloc
{
	[myTableView release];
	[sectionArray release];
	[rowArray release];
	
	[super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self layoutTableView];
	}
	return self;
}

-(void)layoutTableView
{
	myTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.showsHorizontalScrollIndicator = NO;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self addSubview:myTableView];
}

-(void)reloadTableViewSection:(NSMutableArray*)sections row:(NSMutableArray*)rows
{
	self.sectionArray = sections;
	self.rowArray = rows;
	
	[myTableView reloadData];
}

- (void)updateRowIndexPath:(NSIndexPath *)indexPath indexSwitch:(UISwitch *)indexSwitch
{
    if(nil != self.rowArray && nil != indexPath && nil != indexSwitch){
        SettingItemModel *itemModel = [[self.rowArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        itemModel.itemSwitchValue = indexSwitch.on;
    }
    [[Settings standardSettings] setPushSwitch:indexSwitch.on];
    [[AppDelegate shareAppDelegate] registerForRemoteNotification];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return SettingsTableViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return SettingsTableViewFooterHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SettingsTableViewHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,self.bounds.size.width,SettingsTableViewHeaderHeight)] autorelease];
    UIImageView* lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, SettingsTableViewHeaderHeight-0.5, self.bounds.size.width, 0.5)];
    lineImage.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [headerView addSubview:lineImage];
    [lineImage release];
    
    return headerView;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [self.rowArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[self.rowArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* cellIdentifier = @"SettingsCellIdentifier";
	SettingsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(nil == cell){
		cell = [[[SettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.backgroundColor = [RTSSAppStyle currentAppStyle].personCenterCellBgColor;
        cell.textLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
	}
	
	NSInteger row = indexPath.row;
	NSInteger section = indexPath.section;
	
	SettingItemModel *itemModel = [[self.rowArray objectAtIndex:section] objectAtIndex:row];
	
	cell.textLabel.text = itemModel.itemText;
	
	if(SettingsTableViewCellTypeDefault == itemModel.itemType){
		cell.switchHidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}else if(SettingsTableViewCellTypeSwitch == itemModel.itemType){
        cell.selected = NO;
		cell.switchHidden = NO;
		cell.itemSwitch.on = itemModel.itemSwitchValue;
		cell.itemSwitch.tag = itemModel.itemSwitchTag;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell switchValueChange:cell.itemSwitch];
		[cell.itemSwitch addTarget:self action:@selector(onSwitchChange:) forControlEvents:UIControlEventValueChanged];
	}

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(nil != delegate && [delegate respondsToSelector:@selector(settingsTableView:didSelectRowAtIndexPath:indexTag:)]){
		SettingItemModel *itemModel = [[self.rowArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
		[delegate settingsTableView:tableView didSelectRowAtIndexPath:indexPath indexTag:itemModel.itemIndexTag];
	}
	
	[self performSelector:@selector(deselect) withObject:nil afterDelay:0.3];
}

- (void) deselect
{
	[self.myTableView deselectRowAtIndexPath:[self.myTableView indexPathForSelectedRow] animated:YES];
}

- (void)onSwitchChange:(UISwitch*)indexSwitch
{
	NSIndexPath* indexPath = [self.myTableView indexPathForCell:(UITableViewCell*)[[indexSwitch superview] superview]];
	
	if(nil != delegate && [delegate respondsToSelector:@selector(settingsTableView:didSelectRowAtIndexPath:indexSwitch:)]){
		[delegate settingsTableView:myTableView didSelectRowAtIndexPath:indexPath indexSwitch:indexSwitch];
	}
}

@end

@implementation SettingsTableViewCell
@synthesize itemSwitch,switchHidden;

- (void)dealloc
{
	[super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if(self){
        self.frame = CGRectMake(0, 0, self.bounds.size.width, SettingsTableViewCellHeight);
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		self.textLabel.font = [RTSSAppStyle getRTSSFontWithSize:15.0];
        self.clipsToBounds = YES;
        
        // ===
        UIView* backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, SettingsTableViewCellHeight)];
        backgroundView.backgroundColor = [RTSSAppStyle currentAppStyle].cellUnSelectedColor;
        self.backgroundView = backgroundView;
        [backgroundView release];
        
        UIImageView* backSeparatorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SettingsTableViewCellHeight-0.5, self.bounds.size.width, 0.5)];
        backSeparatorView.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
        [self.backgroundView addSubview:backSeparatorView];
        [backSeparatorView release];
        
        // ===
        UIView* selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        selectedBackgroundView.backgroundColor = [RTSSAppStyle currentAppStyle].cellUnSelectedColor;
        self.selectedBackgroundView = selectedBackgroundView;
        [selectedBackgroundView release];
        
        UIImageView* selectedBackSeparatorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SettingsTableViewCellHeight-0.5, self.bounds.size.width, 0.5)];
        selectedBackSeparatorView.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
        [self.selectedBackgroundView addSubview:selectedBackSeparatorView];
        [selectedBackSeparatorView release];
	}
	
	return self;
}

- (void)setSwitchHidden:(BOOL)aHidden
{
	switchHidden = aHidden;
	if(aHidden){
		self.accessoryView = nil;
	}else{
		itemSwitch = [[[UISwitch alloc] init] autorelease];
        itemSwitch.tintColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
        itemSwitch.thumbTintColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
        [itemSwitch addTarget:self action:@selector(onSwitchChange:) forControlEvents:UIControlEventValueChanged];
        self.accessoryView = itemSwitch;
	}
}

- (void)onSwitchChange:(UISwitch*)indexSwitch{
    [self performSelector:@selector(switchValueChange:) withObject:indexSwitch afterDelay:0.3];
}

- (void)switchValueChange:(UISwitch*)indexSwitch{
    if(indexSwitch.on){
        indexSwitch.thumbTintColor = [UIColor whiteColor];
    }else{
        indexSwitch.thumbTintColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
    }
}

@end

@implementation SettingItemModel
@synthesize itemText, itemType,itemSwitchValue,itemSwitchTag,itemIndexTag;

- (void)dealloc
{
    [itemText release];
    
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.itemText           = @"";
        self.itemType           = SettingsTableViewCellTypeDefault;
        self.itemSwitchValue    = NO;
        self.itemSwitchTag      = SettingItemSwitchTagDefault;
        self.itemIndexTag       = SettingItemIndexTagDefault;
    }
    return self;
}

@end
