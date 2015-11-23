//
//  BudgetGroupSettingCell.m
//  RTSS
//
//  Created by 加富董 on 15/1/28.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "BudgetGroupSettingCell.h"
#import "BudgetGroupSettingView.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"

#define SET_VIEW_BASE_CLASS_STRING @"BudgetGroupSettingView"
#define SET_VIEW_NAME_CLASS_STRING @"BudgetGroupSetNameView"
#define SET_VIEW_PHOTO_CLASS_STRING @"BudgetGroupSetPhotoView"
#define SET_VIEW_TYPE_CLASS_STRING @"BudgetGroupSetTypeView"
#define SET_VIEW_RESOURCE_CLASS_STRING @"BudgetGroupSetResourceView"
#define SET_VIEW_BUDGET_CLASS_STRING @"BudgetGroupSetBudgetView"

@interface BudgetGroupSettingCell () {
    
}

@property (nonatomic, assign) CGSize availableSize;

@end

@implementation BudgetGroupSettingCell

@synthesize availableSize;
@synthesize editable;
@synthesize contentType;
@synthesize settingView;

#pragma mark dealloc
- (void)dealloc {
    [settingView release];
    [super dealloc];
}

#pragma mark init
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier availableSize:(CGSize)size {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.availableSize = size;
    }
    return self;
}

#pragma mark load view
- (void)loadContentViewsByType:(SettingCellContentType)type editable:(BOOL)edit {
    if (settingView) {
        [settingView removeFromSuperview];
    }
    self.editable = edit;
    self.contentType = type;
    NSString *viewClassName = [self getContentViewClass];
    if ([CommonUtils objectIsValid:viewClassName]) {
        CGRect contentRect = CGRectMake(0.0, 0.0, availableSize.width, availableSize.height);
        self.settingView = [[[NSClassFromString(viewClassName) alloc] initWithFrame:contentRect editable:self.editable] autorelease];
        self.settingView.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
        [self.contentView addSubview:settingView];
    } else {
        NSLog(@"view class invalid");
    }
}

#pragma mark tools method
- (NSString *)getContentViewClass {
    NSString *setViewClassName = nil;
    switch (self.contentType) {
        case SettingCellContentTypeName:
            setViewClassName = SET_VIEW_NAME_CLASS_STRING;
            break;
        case SettingCellContentTypePhoto:
            setViewClassName = SET_VIEW_PHOTO_CLASS_STRING;
            break;
        case SettingCellContentTypeType:
            setViewClassName = SET_VIEW_TYPE_CLASS_STRING;
            break;
        case SettingCellContentTypeResource:
            setViewClassName = SET_VIEW_RESOURCE_CLASS_STRING;
            break;
        case SettingCellContentTypeBudget:
            setViewClassName = SET_VIEW_BUDGET_CLASS_STRING;
            break;
        default:
            setViewClassName = SET_VIEW_BASE_CLASS_STRING;
            break;
    }
    return setViewClassName;
}

@end
