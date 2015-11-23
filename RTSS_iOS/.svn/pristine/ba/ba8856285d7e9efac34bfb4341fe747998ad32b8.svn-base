//
//  ELine.m
//  SJB2
//
//  Created by shengyp on 14-6-19.
//  Copyright (c) 2014年 ailk. All rights reserved.
//

#import "ELine.h"
#import "ELineDataModel.h"

static const CGFloat ELine_Highest_Scale = 1.3;
static const CGFloat ELine_Bottom_Margin = 25.0;
static const CGFloat ELine_Left_Margin = 20.0;

@interface ELine()

@property (nonatomic, retain) CAShapeLayer *shapeLayer;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, retain) UIColor* lineColor;
@property (nonatomic, retain) UIColor* dotColor;
@property (nonatomic, assign) CGFloat horizentalGap;

@end

@implementation ELine
@synthesize shapeLayer,lineWidth,lineColor,dotColor,dataSource,horizentalGap;

- (void)dealloc
{
	[shapeLayer release];
	[lineColor release];
	[dotColor release];
	
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame lineColor:(UIColor*)aLineColor lineWidth:(CGFloat)aLineWidth dotColor:(UIColor*)aDotColor
{
	self = [self initWithFrame:frame];
	if(self){
		self.backgroundColor = [UIColor clearColor];
		self.lineColor = aLineColor;
		self.lineWidth = aLineWidth;
		self.dotColor = aDotColor;
	}
	return self;
}

- (CGFloat)getELineContentHeight
{
	return CGRectGetHeight(shapeLayer.bounds)-ELine_Bottom_Margin;
}

- (void)reloadDataWithAnimation:(BOOL)shouldAnimation
{
	if(nil == dataSource ||
       NO == [dataSource respondsToSelector:@selector(numberOfPointsInELine:)] ||
       NO == [dataSource respondsToSelector:@selector(horizentalGapInELine:)]){
        return;
    }
	
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
    /** 1. Configure Layer*/
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.zPosition = 0.0f;
    self.shapeLayer.strokeColor = lineColor.CGColor;
    self.shapeLayer.lineWidth = lineWidth;
    self.shapeLayer.lineCap = kCALineCapRound;
    self.shapeLayer.lineJoin = kCALineJoinRound;
    self.shapeLayer.frame = self.frame;
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor;
	
	/** 2. Construct the Path*/
	CGFloat highestPointValue = [dataSource highestValueInELine:self].value*ELine_Highest_Scale;
	if(0 == highestPointValue) highestPointValue = 1.0;
	self.horizentalGap = [dataSource horizentalGapInELine:self];
	
	CGFloat firstPointValue = [dataSource eLine:self valueForIndex:0].value;
	[self putLabelAt:0 animation:shouldAnimation];
	
	UIBezierPath* eLineChartPath = [UIBezierPath bezierPath];
	eLineChartPath.miterLimit = -5.0;
	CGFloat scaleHeight = [self getELineContentHeight]-[self getELineContentHeight]*(firstPointValue/highestPointValue);
	[eLineChartPath moveToPoint:CGPointMake(ELine_Left_Margin, scaleHeight)];
	
	UIBezierPath* animFromPath = [UIBezierPath bezierPath];
	[animFromPath moveToPoint:CGPointMake(ELine_Left_Margin, [self getELineContentHeight])];
	
	for (int i = 1; i < [dataSource numberOfPointsInELine:self]; i ++) {
		CGFloat pointValue = [dataSource eLine:self valueForIndex:i].value;
		CGFloat scaleHeightTemp = [self getELineContentHeight]-[self getELineContentHeight]*(pointValue/highestPointValue);
		[eLineChartPath addLineToPoint:CGPointMake(ELine_Left_Margin+i*horizentalGap, scaleHeightTemp)];
        [animFromPath addLineToPoint:CGPointMake(ELine_Left_Margin+i*horizentalGap, [self getELineContentHeight])];
		[self putLabelAt:i animation:shouldAnimation];
	}
	
	/** 3. Add Path to layer*/
    shapeLayer.path = eLineChartPath.CGPath;
	
	/** 4. Add Animation to The Layer*/
	if(shouldAnimation){
		CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"path"];
        [anim setRemovedOnCompletion:YES];
        anim.fromValue = (id)animFromPath.CGPath;
        anim.toValue = (id)eLineChartPath.CGPath;
        anim.duration = 0.75f;
        anim.removedOnCompletion = NO;
        anim.fillMode = kCAFillModeForwards;
        anim.autoreverses = NO;
        anim.repeatCount = 0;
        [anim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [shapeLayer addAnimation:anim forKey:@"path"];
	}else{
		[shapeLayer removeAnimationForKey:@"path"];
	}
	[self.layer addSublayer:shapeLayer];
	
	/** 5. Add dot to view*/
	if(shouldAnimation){
		[self performSelector:@selector(reloadDotWithAnimation:) withObject:[NSNumber numberWithBool:shouldAnimation] afterDelay:0.75];
	}else{
		[self performSelector:@selector(reloadDotWithAnimation:) withObject:[NSNumber numberWithBool:shouldAnimation] afterDelay:0.0];
	}
}

- (void)reloadDotWithAnimation:(NSNumber*)shouldAnimation
{
	for (int i = 0; i < [dataSource numberOfPointsInELine:self]; i ++) {
		[self putDotAndTopLabelAt:i animation:[shouldAnimation boolValue]];
	}
}

- (UIView*)layoutDotView:(NSInteger)index
{
	UIView* dotView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, lineWidth*6, lineWidth*6)] autorelease];
	dotView.backgroundColor = dotColor;
	dotView.layer.borderColor = [dataSource eLine:self colorForIndex:index].CGColor;
	dotView.layer.borderWidth = lineWidth;
	dotView.layer.cornerRadius = lineWidth*3;
	return dotView;
}

- (UILabel*)layoutTopLabel:(NSInteger)index
{
	CGFloat topLabelWidth = [dataSource horizentalGapInELine:self]-5;
	UILabel* topLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, topLabelWidth, 15)] autorelease];
	topLabel.backgroundColor = [UIColor clearColor];
	topLabel.text = [dataSource eLine:self valueForIndex:index].valueString;
	topLabel.textColor = [dataSource eLine:self colorForIndex:index];
	topLabel.textAlignment = NSTextAlignmentCenter;
	topLabel.font = [UIFont systemFontOfSize:8.0];
	topLabel.minimumScaleFactor = 5.0/13.0;
	return topLabel;
}

- (UILabel*)layoutBottomLabel:(NSInteger)index
{
	UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 15)] autorelease];
	label.backgroundColor = [UIColor clearColor];
	label.text = [dataSource eLine:self valueForIndex:index].label;
	label.textColor = [UIColor grayColor];
	label.textAlignment = NSTextAlignmentCenter;
	label.font = [UIFont systemFontOfSize:13.0];
	return label;
}

- (void)putDotAndTopLabelAt:(NSInteger)index animation:(BOOL)shouldAnimation
{
	CGFloat height = [self getELineContentHeight];
	CGFloat pointValue = [dataSource eLine:self valueForIndex:index].value;
	CGFloat highestPointValue = [dataSource highestValueInELine:self].value*ELine_Highest_Scale;
	if(0 == highestPointValue) highestPointValue = 1.0;
    CGFloat dotY = height - (height * (pointValue / highestPointValue));
    CGPoint dotPosition = CGPointMake(ELine_Left_Margin+index*horizentalGap, dotY);
	CGPoint topPosition = CGPointMake(ELine_Left_Margin+index*horizentalGap, dotY-15);
	
	UIView* dotView = [self layoutDotView:index];
	dotView.center = dotPosition;
	[self addSubview:dotView];
	
	UILabel* topLabel = [self layoutTopLabel:index];
	topLabel.center = topPosition;
	[self addSubview:topLabel];
	
	if(shouldAnimation){
		dotView.alpha = 0.0;
		topLabel.alpha = 0.0;
		[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			dotView.alpha = 1.0;
			topLabel.alpha = 1.0;
		} completion:nil];
	}else{
		dotView.alpha = 1.0;
		topLabel.alpha = 1.0;
	}
}

- (void)putLabelAt:(NSInteger)index animation:(BOOL)shouldAnimation
{
	CGFloat height = CGRectGetHeight(shapeLayer.bounds);
	CGPoint labelPosition = CGPointMake(ELine_Left_Margin+index*horizentalGap, height-10);
	
	UILabel* label = [self layoutBottomLabel:index];
	label.center = labelPosition;
	[self addSubview:label];
	
	if(shouldAnimation){
		label.alpha = 0.0;
		[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			label.alpha = 1.0;
		} completion:nil];
	}else{
		label.alpha = 1.0;
	}
}

#pragma -mark- UIView Delegate
- (void)setTransform:(CGAffineTransform)newValue;
{
    newValue.d = 1.0;
    [super setTransform:newValue];
}

@end
