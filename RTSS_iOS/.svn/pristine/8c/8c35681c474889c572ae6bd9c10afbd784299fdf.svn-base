//
//  UILabel+NumberJump.m
//  IOS7Test
//
//  Created by shengyp on 14-8-6.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "LabelNumberJump.h"

@implementation SJBBezierCurve

- (void)dealloc
{
    [super dealloc];
}

+ (Point2D)pointOnCubicBezier:(Point2D *)cp t:(CGFloat)t
{
	// 贝塞尔曲线公式
	// x = (1-t)^3 *x0 + 3*t*(1-t)^2 *x1 + 3*t^2*(1-t) *x2 + t^3 *x3
    // y = (1-t)^3 *y0 + 3*t*(1-t)^2 *y1 + 3*t^2*(1-t) *y2 + t^3 *y3
	
	CGFloat ax = 0, bx = 0, cx = 0;
	CGFloat ay = 0, by = 0, cy = 0;
	CGFloat tSquared = 0, tCubed = 0;
	
	Point2D result; result.x = 0; result.y = 0;
	
	// 计算多项式系数
	cx = 3.0 * (cp[1].x - cp[0].x);
    bx = 3.0 * (cp[2].x - cp[1].x) - cx;
    ax = cp[3].x - cp[0].x - cx - bx;
	
	cy = 3.0 * (cp[1].y - cp[0].y);
    by = 3.0 * (cp[2].y - cp[1].y) - cy;
    ay = cp[3].y - cp[0].y - cy - by;
	
	// 计算位于参数值t的曲线点
	tSquared = t * t;
    tCubed = tSquared * t;
    
    result.x = (ax * tCubed) + (bx * tSquared) + (cx * t) + cp[0].x;
    result.y = (ay * tCubed) + (by * tSquared) + (cy * t) + cp[0].y;
	
	return result;
}

@end

@implementation LabelNumberJump
@synthesize durationJump, startNumber, endNumber, decimalsCount, pointsNumber, isJump, unitString,unitFront,integersCount;

- (void)dealloc
{
	[numberPointArray release];
	
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        integersCount = 0;
		decimalsCount = 1;
		pointsNumber = 50;
        unitString = @"";
        unitFront = NO;
        numberPointArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)cleanUpValue
{
	lastTime = 0;
    indexNumber = 0;
	[numberPointArray removeAllObjects];
}

- (void)initPoints
{
	Point2D startPoint; startPoint.x = 0; startPoint.y = 0;
	Point2D controlPoint1; controlPoint1.x = 0.25; controlPoint1.y = 0.1;
	Point2D controlPoint2; controlPoint2.x = 0.25; controlPoint2.y = 1;
	Point2D endPoint; endPoint.x = 1; endPoint.y = 1;
	
	Point2D bezierCurvePoints[4] = {startPoint, controlPoint1, controlPoint2, endPoint};
	CGFloat dt = 1.0 / (pointsNumber - 1);
	for (int i = 0; i < pointsNumber; i ++) {
		Point2D point = [SJBBezierCurve pointOnCubicBezier:bezierCurvePoints t:i*dt];
		CGFloat durationTime = point.x * durationJump;
		CGFloat value = point.y * (endNumber - startNumber) + startNumber;
		NSArray* array = [NSArray arrayWithObjects:[NSNumber numberWithFloat:durationTime],[NSNumber numberWithFloat:value], nil];
		[numberPointArray addObject:array];
	}
}

- (void)changeNumberBySelector
{
	if(indexNumber >= pointsNumber){
		self.text = [self labelTextFormat:endNumber];
	}else{
		NSArray* array = [numberPointArray objectAtIndex:indexNumber];
		CGFloat durationTime = [[array objectAtIndex:0] floatValue];
		CGFloat value = [[array objectAtIndex:1] floatValue];
		CGFloat difTime = durationTime - lastTime;
		self.text = [self labelTextFormat:value];
		lastTime = durationTime;
		indexNumber += 1;
		[self performSelector:@selector(changeNumberBySelector) withObject:nil afterDelay:difTime];
	}
}

- (NSString*)labelTextFormat:(CGFloat)number
{
    NSString* formatString = nil;
    if(YES == self.unitFront){
        formatString = [NSString stringWithFormat:@"%@%%0%d.%df", unitString, integersCount, decimalsCount];
    }else{
        formatString = [NSString stringWithFormat:@"%%0%d.%df%@", integersCount, decimalsCount, unitString];
    }
	return [NSString stringWithFormat:formatString,number];
}

- (void)jumpNumberWithDuration:(CGFloat)aDuration fromNumber:(CGFloat)aStartNumber toNumber:(CGFloat)aEndNumber isJump:(BOOL)aIsJump
{
	durationJump = aDuration/pointsNumber;
	startNumber = aStartNumber;
	endNumber = aEndNumber;
	isJump = aIsJump;
	
	[self cleanUpValue];
	
	if(isJump){
		[self initPoints];
		[self changeNumberBySelector];
	}else{
		self.text = [self labelTextFormat:endNumber];
	}
}

@end
