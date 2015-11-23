//
//  RadarView.h
//  RTSS
//
//  Created by shengyp on 14/10/28.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RadarItemSelectedType) {
    RadarItemSelectedTypeDefault,
    RadarItemSelectedTypeSingle,
    RadarItemSelectedTypeMulti
};

@class PortraitImageView;
@class User;
@interface ERadarItemView : UIView

@property(nonatomic, readonly) PortraitImageView*  itemImageView;
@property(nonatomic, readonly) UIButton*           itemButton;
@property(nonatomic, readonly) UILabel*            itemLabel;

@property(nonatomic, retain) NSString*      itemSN;
@property(nonatomic, retain) User*          itemUser;
@property(nonatomic, retain) NSDictionary*  itemInfo;

- (void)jumpItem;

- (void)selectItem;

- (void)unSelectItem;

@end

@interface RadarView : UIView

@property(nonatomic, assign) CGSize                 radarSize;
@property(nonatomic, assign) CGSize                 scaleSize;
@property(nonatomic, retain) UIColor*               radarBgColor;
@property(nonatomic, readonly) ERadarItemView*      centerItemView;

- (void)startRadar;
- (void)stopRadar;

- (void)addRadarItemView:(ERadarItemView*)itemView;
- (void)addRadarItemsView:(NSArray*)itemsView;

- (void)removeRadarItemView:(ERadarItemView*)itemView;
- (void)removeRadarItemsView;

- (ERadarItemView*)getRadarItemViewWithSN:(NSString*)sn;

@end
