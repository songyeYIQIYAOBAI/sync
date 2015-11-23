//
//  EPie.h
//  IOS7Test
//
//  Created by shengyp on 14-6-23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EPie;
@class EPieDataModel;

@protocol EPieDataSource <NSObject>

@required
- (NSInteger)numberOfSlicesInEPie:(EPie*)pie;

- (EPieDataModel*)pie:(EPie*)pie valueForSliceAtIndex:(NSInteger)index;

- (UIColor*)pie:(EPie*)pie colorForSliceAtIndex:(NSInteger)index;

@end

@protocol EPieDelegate <NSObject>

@optional
- (void)pie:(EPie*)pie willSelectSliceAtIndex:(NSUInteger)index;

- (void)pie:(EPie*)pie didSelectSliceAtIndex:(NSUInteger)index;

- (void)pie:(EPie*)pie willDeselectSliceAtIndex:(NSUInteger)index;

- (void)pie:(EPie*)pie didDeselectSliceAtIndex:(NSUInteger)index;

- (void)animateFinish:(EPie*)pie;

@end

@interface SliceLayer : CAShapeLayer

@property (nonatomic, assign) CGFloat   value;
@property (nonatomic, assign) CGFloat   percentage;
@property (nonatomic, assign) double    startAngle;
@property (nonatomic, assign) double    endAngle;
@property (nonatomic, assign) BOOL      isSelected;

- (void)createArcAnimationForKey:(NSString*)key fromValue:(NSNumber*)from toValue:(NSNumber*)to delegate:(id)delegate;

@end

@interface EPie : UIView
{
	UIView* pieView;
	
	NSInteger selectedSliceIndex;
	
    NSTimer* animationTimer;
	
    NSMutableArray* animations;
}

@property(nonatomic, assign) id<EPieDataSource> dataSource;
@property(nonatomic, assign) id<EPieDelegate> delegate;

@property(nonatomic, assign) CGFloat startPieAngle;
@property(nonatomic, assign) CGFloat animationSpeed;
@property(nonatomic, assign) CGPoint pieCenter;
@property(nonatomic, assign) CGFloat pieRadius;
@property(nonatomic, assign) CGFloat selectedSliceStroke;
@property(nonatomic, assign) CGFloat selectedSliceOffsetRadius;

- (void)reloadPie;
- (void)pieSelected:(NSInteger)selIndex;
- (void)setPieBackgroundColor:(UIColor*)color;

@end
