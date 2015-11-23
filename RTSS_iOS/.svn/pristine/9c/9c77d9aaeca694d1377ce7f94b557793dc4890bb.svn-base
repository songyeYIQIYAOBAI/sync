//
//  EPieRotated.h
//  IOS7Test
//
//  Created by shengyp on 14-6-23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPie.h"

@class EPieRotated;

@protocol EPieRotatedDataSource <NSObject>

@required
- (NSInteger)numberOfSlicesInEPieRotated:(EPieRotated*)pieRotated;

- (EPieDataModel*)pieRotated:(EPieRotated*)pieRotated valueForSliceAtIndex:(NSInteger)index;

- (UIColor*)pieRotated:(EPieRotated*)pieRotated colorForSliceAtIndex:(NSInteger)index;

@end

@protocol EPieRotatedDelegate <NSObject>

@optional
- (void)pieRotated:(EPieRotated*)pieRotated willSelectSliceAtIndex:(NSUInteger)index;

- (void)pieRotated:(EPieRotated*)pieRotated didSelectSliceAtIndex:(NSUInteger)index;

- (void)pieRotated:(EPieRotated*)pieRotated willDeselectSliceAtIndex:(NSUInteger)index;

- (void)pieRotated:(EPieRotated*)pieRotated didDeselectSliceAtIndex:(NSUInteger)index;

- (void)selectedFinish:(EPieRotated*)pieRotated index:(NSInteger)index percent:(CGFloat)per;

@end

@interface EPieRotated : UIView<EPieDataSource,EPieDelegate>
{
    NSMutableArray*     mThetaArray;
    
    BOOL                isAnimating;
    BOOL                isTapStopped;
    BOOL                isAutoRotation;
    CGFloat             mAbsoluteTheta;
    CGFloat             mRelativeTheta;
    
    CGFloat             mDragSpeed;
    CGFloat             mDragBeforeTheta;
}

@property (nonatomic, assign) id<EPieRotatedDelegate> delegate;
@property (nonatomic, assign) id<EPieRotatedDataSource> dataSource;

@property (nonatomic, assign) CGFloat 		    fracValue;
@property (nonatomic, assign) BOOL              isAutoRotation;


- (void)startedAnimate;

- (void)reloadPieRotated;

@end
