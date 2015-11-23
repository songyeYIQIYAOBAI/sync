//
//  EColumn.m
//  IOS7Test
//
//  Created by shengyp on 14-6-20.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "EColumn.h"

@interface EColumn()

@property (nonatomic, retain) CAShapeLayer* eColumnLayer;

@end

@implementation EColumn
@synthesize eColumnLayer,barColor,grade;

- (void)dealloc
{
    [eColumnLayer release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.eColumnLayer              = [CAShapeLayer layer];
        self.eColumnLayer.lineCap      = kCALineCapButt;
        self.eColumnLayer.fillColor    = [[UIColor whiteColor] CGColor];
        self.eColumnLayer.lineWidth    = self.frame.size.width;
        self.eColumnLayer.strokeEnd    = 0.0;
        self.clipsToBounds      	   = YES;
		[self.layer addSublayer:self.eColumnLayer];
    }
    return self;
}

- (void)setBarColor:(UIColor*)aBarColor
{
	if(barColor != aBarColor){
		[barColor release];
	}
	barColor = [aBarColor retain];
    eColumnLayer.strokeColor = [barColor CGColor];
}

- (UIColor *)barColor
{
    return [UIColor colorWithCGColor:eColumnLayer.strokeColor];
}

-(void)setGrade:(CGFloat)aGrade
{
	grade = aGrade;
	
	UIBezierPath* progressline = [UIBezierPath bezierPath];
    [progressline moveToPoint:CGPointMake(self.frame.size.width/2.0, self.frame.size.height)];
	[progressline addLineToPoint:CGPointMake(self.frame.size.width/2.0, (1 - grade) * self.frame.size.height)];
    [progressline setLineWidth:1.0];
    [progressline setLineCapStyle:kCGLineCapSquare];
	
	eColumnLayer.path = progressline.CGPath;
	
	if (barColor) {
		eColumnLayer.strokeColor = barColor.CGColor;
	}else{
		eColumnLayer.strokeColor = [UIColor whiteColor].CGColor;
	}
    
    CABasicAnimation* pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [eColumnLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    eColumnLayer.strokeEnd = 1.0;
}

-(void)rollBack
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        eColumnLayer.strokeColor = [UIColor clearColor].CGColor;
    } completion:nil];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	//Draw BG
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
	CGContextFillRect(context, rect);
}

@end
