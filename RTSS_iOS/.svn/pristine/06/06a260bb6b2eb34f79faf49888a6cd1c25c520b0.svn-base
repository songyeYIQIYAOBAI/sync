//
//  CircleProgressView.m
//  IOS7Test
//
//  Created by shengyp on 14-9-1.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "CircleProgressView.h"

#import "CommonUtils.h"
#import "RTSSAppDefine.h"
#import "RTSSAppStyle.h"
#define BottomHeightToCenter  10.0f



@interface CircleProgressView (){
    UILabel *remainLabel;
    UILabel *describeLabel;
    UILabel *totalLabel;
}

@end

@implementation CircleProgressView
@synthesize circleShapeLayer,circleProgressLayer,circleButton;
@synthesize lineWidth, trackColor, progressColor, progress;
@synthesize allroundView;

- (void)dealloc
{
	
	[circleButton release];
	[trackColor release];
	[progressColor release];
    [self.allroundView release];
	
    [super dealloc];
}

- (void)setLineWidth:(CGFloat)aLineWidth
{
	lineWidth = aLineWidth;
	circleShapeLayer.lineWidth = lineWidth;
	circleProgressLayer.lineWidth = lineWidth;
}

- (void)setTrackColor:(UIColor *)aTrackColor
{
	if(nil != trackColor){
		[trackColor release];
		trackColor = nil;
	}
	trackColor = [aTrackColor retain];
	
	//circleShapeLayer.strokeColor = trackColor.CGColor;
    
    circleProgressLayer.strokeColor = trackColor.CGColor;
}

- (void)setProgressColor:(UIColor *)aProgressColor
{
	if(nil != progressColor){
		[progressColor release];
		progressColor = nil;
	}
	progressColor = [aProgressColor retain];
	
	//circleProgressLayer.strokeColor = progressColor.CGColor;
    
    circleShapeLayer.strokeColor = progressColor.CGColor;
}

- (void)setProgress:(CGFloat)aProgress
{
	progress = aProgress;
	
	[self setProgress:progress duration:1.0 animated:NO];
}

- (id)initWithFrame:(CGRect)frame line:(CGFloat)aLine
{
    self = [super initWithFrame:frame];
    if (self) {
    
        
        self.layer.cornerRadius = self.bounds.size.height/2;
        self.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        
        lineWidth = aLine;
        
        NSLog(@"sel = %@",NSStringFromCGRect(self.bounds));
        
       allroundView = [[AllRoundView alloc]initWithFrame:self.bounds line:aLine];
       allroundView.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
        [self addSubview:self.allroundView];
       
           
        CAGradientLayer *colorLayer = [CAGradientLayer layer];
        colorLayer.frame = self.bounds;
        colorLayer.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor blueColor].CGColor];
        //[colorLayer setStartPoint:CGPointMake(0.5, 0)];
        //[colorLayer setEndPoint:CGPointMake(1.0, 0.5)];
        //[self.layer addSublayer:colorLayer];
        // Initialization code
		//lineWidth = 10.0f;
		//trackColor = [UIColor lightGrayColor];
		//progressColor = [UIColor orangeColor];
        trackColor = [UIColor orangeColor];
        self.progressColor =  [RTSSAppStyle currentAppStyle].viewControllerBgColor;
		UIBezierPath* circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, (self.bounds.size.height)/2)
																  radius:MIN(self.bounds.size.width/2.0, (self.bounds.size.height)/2.0)
															  startAngle:0.0f
																endAngle:M_PI * 2
															   clockwise:YES];
		// ========
		circleShapeLayer = [CAShapeLayer layer];
		circleShapeLayer.path = circlePath.CGPath;
		circleShapeLayer.lineCap = kCALineCapButt;
		circleShapeLayer.fillColor = [UIColor clearColor].CGColor;
		circleShapeLayer.lineWidth = lineWidth;
		circleShapeLayer.strokeColor = trackColor.CGColor;
		circleShapeLayer.zPosition = -1;
		[self.layer addSublayer:circleShapeLayer];
				
		// ========
		circleProgressLayer = [CAShapeLayer layer];
		circleProgressLayer.lineCap = kCALineCapButt;
		circleProgressLayer.fillColor = [UIColor clearColor].CGColor;
		circleProgressLayer.lineWidth = lineWidth;
		circleProgressLayer.strokeColor = progressColor.CGColor;
		circleProgressLayer.zPosition = -1;
		[self.layer addSublayer:circleProgressLayer];
		circleButton = [[UIButton alloc] initWithFrame:self.bounds];
		circleButton.backgroundColor = [UIColor clearColor];
		[self addSubview:circleButton];
        
        
    }
    return self;
}

- (void)setProgress:(CGFloat)aProgress duration:(CGFloat)aDuration animated:(BOOL)animated
{
    NSLog(@"progress===%f",aProgress);
	progress = MIN(MAX(aProgress, 0.0f), 1.0f);
    NSLog(@"progress===%f",1-progress);
    /*
	UIBezierPath* circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2,(self.bounds.size.height)/2)
															  radius:MIN(self.bounds.size.width/2.0, (self.bounds.size.height)/2.0)
														  startAngle:-M_PI_2
															endAngle:M_PI * 2 * (1 - progress) + M_PI_2 * 3
														   clockwise:NO];
     */
    
    UIBezierPath* circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2,(self.bounds.size.height)/2)
                                                              radius:MIN(self.bounds.size.width/2.0, (self.bounds.size.height)/2.0)
                                                          startAngle:-M_PI_2
                                                            endAngle:- M_PI_2 +(1- progress) * 2 * M_PI
                                                           clockwise:YES];
    
    
	circleProgressLayer.path = circlePath.CGPath;
	
	if(animated){
		CABasicAnimation* pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
		pathAnimation.duration = aDuration;
		pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
		pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
		pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
		[circleProgressLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
	}
}

-(UIImageView*)createLineImageViewWithY:(CGFloat)lineY{
    
    UIImageView *line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_separator_line"]];
    line.frame = CGRectMake(0, lineY, PHONE_UISCREEN_WIDTH, 2);
    return [line autorelease];
    
}

-(void)setRemainingAmount:(NSString *)aRemaining total:(NSString *)aTotal Unit:(NSString *)aUnit Color:(UIColor *)aColor{
    
    [self.allroundView setRemainingAmount:aRemaining total:aTotal Unit:aUnit Color:aColor];
    [self setProgressColor:aColor];
    
}

@end
