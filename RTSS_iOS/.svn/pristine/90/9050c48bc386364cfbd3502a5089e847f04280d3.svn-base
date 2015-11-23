//
//  BudgetGroupSettingCell.h
//  RTSS
//
//  Created by 加富董 on 15/1/28.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SettingCellContentType) {
    SettingCellContentTypeNormal = 1,
    SettingCellContentTypeName,
    SettingCellContentTypePhoto,
    SettingCellContentTypeType,
    SettingCellContentTypeResource,
    SettingCellContentTypeBudget,
};

@class BudgetGroupSettingView;

@interface BudgetGroupSettingCell : UITableViewCell

@property (nonatomic, retain) BudgetGroupSettingView *settingView;
@property (nonatomic, assign) SettingCellContentType contentType;
@property (nonatomic, assign) BOOL editable;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier availableSize:(CGSize)size;
- (void)loadContentViewsByType:(SettingCellContentType)type editable:(BOOL)edit;

@end
