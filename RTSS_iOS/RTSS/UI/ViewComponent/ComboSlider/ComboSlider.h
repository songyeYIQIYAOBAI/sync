//
//  ComboSlider.h
//  IOS7Test
//
//  Created by shengyp on 15-1-27.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SliderUtils : NSObject

+ (UIImage*)convertViewToImage:(UIView*)view;

+ (UIColor*)convertImageToColor:(UIImage*)image;

+ (UIImage*)convertColorToImage:(UIColor*)color size:(CGSize)size;

+ (UIImage*)convertImageToImage:(UIImage*)image size:(CGSize)size;

@end

@interface ProgressView : UIView

@property(nonatomic, readonly) UIProgressView* progressView;

@property(nonatomic, assign, setter=setProgress:)           float    progress;

@property(nonatomic, retain, setter=setProgressColor:)      UIColor* progressColor;
@property(nonatomic, retain, setter=setTrackColor:)         UIColor* trackColor;

@property(nonatomic, retain, setter=setProgressImage:)      UIImage* progressImage;
@property(nonatomic, retain, setter=setTrackImage:)         UIImage* trackImage;

// ===方法===
- (void)setProgress:(float)aProgress animated:(BOOL)animated;

@end

@interface Slider : UISlider

@property(nonatomic, assign, setter=setThumbSize:)          CGSize   thumbSize;
@property(nonatomic, retain, setter=setThumbColor:)         UIColor* thumbColor;
@property(nonatomic, retain, setter=setMinimumTrackColor:)  UIColor* minimumTrackColor;
@property(nonatomic, retain, setter=setMaximumTrackColor:)  UIColor* maximumTrackColor;

@property(nonatomic, retain, setter=setThumbImage:)         UIImage* thumbImage;
@property(nonatomic, retain, setter=setMinimumTrackImage:)  UIImage* minimumTrackImage;
@property(nonatomic, retain, setter=setMaximumTrackImage:)  UIImage* maximumTrackImage;

@end

@interface MidSlider : UIView

@property(nonatomic, readonly) Slider*                      sliderControl;
@property(nonatomic, readonly) ProgressView*                progressView;

@end

@interface ComboSlider : UIControl

@property(nonatomic, readonly) MidSlider*                   midSlider;

// ===样式====
@property(nonatomic, assign, setter=setThumbSize:)          CGSize   thumbSize;
@property(nonatomic, assign, setter=setThumbColor:)         UIColor* thumbColor;
@property(nonatomic, assign, setter=setMinimumTrackColor:)  UIColor* minimumTrackColor;
@property(nonatomic, assign, setter=setMaximumTrackColor:)  UIColor* maximumTrackColor;
@property(nonatomic, assign, setter=setMidimumTrackColor:)  UIColor* midimumTrackColor;

@property(nonatomic, assign, setter=setThumbImage:)         UIImage* thumbImage;
@property(nonatomic, assign, setter=setMinimumTrackImage:)  UIImage* minimumTrackImage;
@property(nonatomic, assign, setter=setMaximumTrackImage:)  UIImage* maximumTrackImage;
@property(nonatomic, assign, setter=setMidimumTrackImage:)  UIImage* midimumTrackImage;

@property(nonatomic, assign, setter=setResetMarkImage:)     UIImage* resetMarkImage;
@property(nonatomic, assign, setter=setHistoryMarkImage:)   UIImage* historyMarkImage;

// ===组件===
@property(nonatomic, readonly) UILabel*         resourceTitleLabel;

@property(nonatomic, readonly) UIButton*        resourceItemButton;
@property(nonatomic, readonly) UIButton*        rightItemButton;

@property(nonatomic, readonly) UILabel*         minimumValueLabel;
@property(nonatomic, readonly) UILabel*         maximumValueLabel;
@property(nonatomic, readonly) UILabel*         resetValueLabel;
@property(nonatomic, readonly) UILabel*         historyValueLabel;
@property(nonatomic, readonly) UILabel*         currentValueLabel;

@property(nonatomic, readonly) UIImageView*     minimumMarkView;
@property(nonatomic, readonly) UIImageView*     maximumMarkView;
@property(nonatomic, readonly) UIImageView*     resetMarkView;
@property(nonatomic, readonly) UIImageView*     historyMarkView;

// ===数据===
@property(nonatomic, assign) NSString* comboSliderId;
@property(nonatomic, assign, setter=setMinimumValue:) float minimumValue;
@property(nonatomic, assign, setter=setMaximumValue:) float maximumValue;
@property(nonatomic, assign, setter=setCurrentValue:) float currentValue;
@property(nonatomic, assign, setter=setResetValue:)   float resetValue;
@property(nonatomic, assign, setter=setHistoryValue:) float historyValue;

@property(nonatomic, assign, setter=setActiveStep:)   float activeStep;
@property(nonatomic, assign, setter=setNegtiveStep:)  float negtiveStep;

// ===显示===
@property(nonatomic, assign, setter=setShowMinimumValue:) BOOL showMinimumValue;
@property(nonatomic, assign, setter=setShowMaximumValue:) BOOL showMaximumValue;
@property(nonatomic, assign, setter=setShowCurrentValue:) BOOL showCurrentValue;
@property(nonatomic, assign, setter=setShowChangeValue:)  BOOL showChangeValue;
@property(nonatomic, assign, setter=setShowResetValue:)   BOOL showResetValue;
@property(nonatomic, assign, setter=setShowHistoryValue:) BOOL showHistoryValue;

@property(nonatomic, assign, setter=setShowRightItemButton:)    BOOL showRightItemButton;
@property(nonatomic, assign, setter=setShowResourceItemButton:) BOOL showResourceItemButton;

@property(nonatomic, assign, setter=setShowComboSliderThumb:) BOOL showComboSliderThumb;

@property(nonatomic, assign, setter=setComboSliderSelected:)  BOOL comboSliderSelected;

// ===方法===
- (void)setCurrentValue:(float)aCurrentValue animated:(BOOL)animated;

@end
