//
//  UILabel+NumberJump.h
//  IOS7Test
//
//  Created by shengyp on 14-8-6.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

struct Point2D{
	CGFloat x;
	CGFloat y;
};
typedef struct Point2D Point2D;

@interface SJBBezierCurve : NSObject

/** 
 cp 在此是四个元素的数组:
 cp[0] 为起点，或上图中的 P0
 cp[1] 为第一控制点
 cp[2] 为第二控制点
 cp[3] 为结束点
 t 为参数值，0 <= t <= 1 
 */
+ (Point2D)pointOnCubicBezier:(Point2D *)cp t:(CGFloat)t;

@end

@interface LabelNumberJump : UILabel
{
	NSMutableArray* numberPointArray;
	
	CGFloat 	lastTime;
	NSInteger   indexNumber;
}

@property(nonatomic, assign, readonly)CGFloat durationJump;	// 跳变时间
@property(nonatomic, assign, readonly)CGFloat startNumber;	// 起始数字
@property(nonatomic, assign, readonly)CGFloat endNumber;	// 结束数字

@property(nonatomic, retain)NSString*           unitString;     // 单位
@property(nonatomic, assign)BOOL                unitFront;      // YES is 单位在前, NO is 单位在后
@property(nonatomic, assign)int                 decimalsCount;  // 保留小数位数
@property(nonatomic, assign)int                 integersCount;  // 保留整数位数
@property(nonatomic, assign)NSUInteger          pointsNumber;   // 数字跳变的次数
@property(nonatomic, assign)BOOL                isJump;		    // 是否跳动

- (void)jumpNumberWithDuration:(CGFloat)aDuration fromNumber:(CGFloat)aStartNumber toNumber:(CGFloat)aEndNumber isJump:(BOOL)aIsJump;

@end
