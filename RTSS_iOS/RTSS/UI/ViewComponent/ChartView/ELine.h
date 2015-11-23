//
//  ELine.h
//  SJB2
//
//  Created by shengyp on 14-6-19.
//  Copyright (c) 2014年 ailk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ELine;
@class ELineDataModel;

@protocol ELineDataSource <NSObject>
@required

- (NSInteger)numberOfPointsInELine:(ELine*)eLine;

- (CGFloat)horizentalGapInELine:(ELine*)eLine;

- (ELineDataModel*)highestValueInELine:(ELine*)eLine;

- (ELineDataModel*)eLine:(ELine*)eLine valueForIndex:(NSInteger)index;

- (UIColor*)eLine:(ELine*)eLine colorForIndex:(NSInteger)index;

@end


@interface ELine : UIView

@property (nonatomic, assign) id<ELineDataSource> dataSource;

- (id)initWithFrame:(CGRect)frame lineColor:(UIColor*)aLineColor lineWidth:(CGFloat)aLineWidth dotColor:(UIColor*)aDotColor;

- (void)reloadDataWithAnimation:(BOOL)shouldAnimation;

@end
