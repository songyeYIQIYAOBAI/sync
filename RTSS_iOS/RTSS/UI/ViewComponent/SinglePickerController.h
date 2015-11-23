//
//  SinglePickerViewController.h
//  RTSS
//
//  Created by shengyp on 14/11/3.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SinglePickerType){
    SinglePickerTypeDefault,
    SinglePickerTypePercent,
    SinglePickerTypeSpeed,
    SinglePickerTypeTimeHour,
    SinglePickerTypeGroup
};

@protocol SinglePickerDelegate;

@interface SinglePickerController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic, assign) SinglePickerType               pickerType;
@property(nonatomic, assign) id<SinglePickerDelegate>       delegate;
@property(nonatomic, retain) NSString*                      pickerTitle;
@property(nonatomic, retain) NSArray*                       pickerArrayData;

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;

@end

@protocol SinglePickerDelegate <NSObject>

@optional
- (void)singlePickerWithCancel:(SinglePickerController*)controller;

// 单列
- (void)singlePickerWithDone:(SinglePickerController*)controller selectedIndex:(NSInteger)index;

// 组列 rows(NSNumber--->NSInteger)
- (void)singlePickerWithDone:(SinglePickerController *)controller rows:(NSArray*)rows;

@end
