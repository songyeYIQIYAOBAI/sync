//
//  SGaugeView.h
//  IOS7Test
//
//  Created by shengyp on 14/11/29.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GaugeView;
@protocol GaugeViewDataSource <NSObject>

@optional
- (NSInteger)numberOfRowsInGaugeView:(GaugeView*)gaugeView;

- (NSString*)gaugeView:(GaugeView*)gaugeView stringAtIndex:(NSInteger)index;

- (UIColor*)gaugeView:(GaugeView*)gaugeView colorAtIndex:(NSInteger)index;

@end

@interface GaugeView : UIView

@property(nonatomic, assign) CGFloat        minAngle;
@property(nonatomic, assign) CGFloat        maxAngle;
@property(nonatomic, assign) CGFloat        maxScale;

@property(nonatomic, retain) UIColor*       scaleColor;

@property(nonatomic, assign) id<GaugeViewDataSource> dataSource;

- (void)setBackgroundImage:(UIImage*)bgImage pointerImage:(UIImage*)pointerImage centerImage:(UIImage*)centerImage;

- (void)setGaugePercentValue:(CGFloat)percent animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

- (void)setGaugePercentValue:(CGFloat)percent duration:(CGFloat)duration voice:(BOOL)voice animated:(BOOL)animated completion:(void (^)(BOOL))completion;

- (void)loadData;

@end
