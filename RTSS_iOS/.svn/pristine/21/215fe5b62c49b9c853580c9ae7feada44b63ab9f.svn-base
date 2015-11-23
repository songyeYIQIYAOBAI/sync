//
//  RadarPickerViewController.h
//  RTSS
//
//  Created by shengyp on 14/10/23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "BasicViewController.h"
#import "RadarView.h"

typedef NS_ENUM(NSInteger, RadarPickerStatus) {
    RadarPickerStatusDefault,
    RadarPickerStatusUserJioned,
    RadarPickerStatusUserSelected,
    RadarPickerStatusUserInfo,
    RadarPickerStatusPeerJioned,
    RadarPickerStatusPeerSelected,
    RadarPickerStatusPeerInfo
};

@protocol RadarPickerViewControllerDelegate <NSObject>

- (void)singleSelectedItemView:(ERadarItemView*)itemView;

- (void)defaultSelectedItemView:(ERadarItemView*)itemView;

@end

@interface RadarPickerViewController : BasicViewController

@property(nonatomic, assign) RadarItemSelectedType radarItemSelectedType;

@property(nonatomic, assign) id<RadarPickerViewControllerDelegate> delegate;

@end
