//
//  SGaugeView.m
//  IOS7Test
//
//  Created by shengyp on 14/11/29.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "GaugeView.h"
#import "RTSSAudioPlayer.h"

#define MAX_GAUGE_SCALE                 135.0
#define MIN_GAUGE_SCALE                 0.0

#define MAX_GAUGE_ANGLE                 135.0
#define MIN_GAUGE_ANGLE                 -135.0

#define ROTATE_GAUGE_AVERAGE_NUMBER     12

// 此宏标识CONTEXT画刻度线
#define CONTEXT_GAUGE_SCALE_LINE

@interface GaugeView()

@property(nonatomic, retain) UIImage*               gaugeImage;
@property(nonatomic, retain) UIImageView*           gaugeImageView;
@property(nonatomic, retain) CALayer*               pointerLayer;
@property(nonatomic, retain) UIImageView*           centerImageView;

@property(nonatomic, assign) CGFloat                gaugeAngle;
@property(nonatomic, assign) CGFloat                gaugeScale;

@property(nonatomic, readonly) RTSSAudioPlayer*     engineAudioPlayer;

@end

@implementation GaugeView
@synthesize minAngle, maxAngle, maxScale, gaugeAngle, gaugeScale, scaleColor, gaugeImage, gaugeImageView, pointerLayer, centerImageView, dataSource,engineAudioPlayer;

- (void)dealloc
{
    [gaugeImage release];
    [gaugeImageView release];
    [pointerLayer release];
    [centerImageView release];
    [scaleColor release];
    [engineAudioPlayer release];
    
    [super dealloc];
}

- (void)initValue
{
    self.maxAngle = MAX_GAUGE_ANGLE;
    self.minAngle = MIN_GAUGE_ANGLE;
    self.maxScale = MAX_GAUGE_SCALE;
    
    self.gaugeAngle = MIN_GAUGE_ANGLE;
    self.gaugeScale = MIN_GAUGE_SCALE;
    
    self.scaleColor = [UIColor whiteColor];
    
    NSURL* engineUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"turbo_boost_engine" ofType:@"caf"]];
    engineAudioPlayer = [[RTSSAudioPlayer alloc] initWithURL:engineUrl];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initValue];
    }
    return self;
}

- (void)setBackgroundImage:(UIImage*)bgImage pointerImage:(UIImage*)pointerImage centerImage:(UIImage*)centerImage
{
    self.gaugeImage = bgImage;
    
#ifndef CONTEXT_GAUGE_SCALE_LINE
    [self.gaugeImageView removeFromSuperview];
    self.gaugeImageView = nil;
    
    self.gaugeImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)] autorelease];
    self.gaugeImageView.backgroundColor = [UIColor orangeColor];
    self.gaugeImageView.image = bgImage;
    self.gaugeImageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    [self addSubview:self.gaugeImageView];
#endif

    [self.pointerLayer removeFromSuperlayer];
    self.pointerLayer = nil;
    
    self.pointerLayer = [CALayer layer];
    self.pointerLayer.bounds = CGRectMake(0, 0, pointerImage.size.width, pointerImage.size.height);
    self.pointerLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    self.pointerLayer.anchorPoint = CGPointMake(0.5, 1);
    self.pointerLayer.contents = (id)pointerImage.CGImage;
    self.pointerLayer.transform = CATransform3DRotate(CATransform3DIdentity,[self transToRadian:minAngle], 0, 0, 1);
    
    [self.centerImageView removeFromSuperview];
    self.centerImageView = nil;
    
    self.centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, centerImage.size.width, centerImage.size.height)];
    self.centerImageView.backgroundColor = [UIColor clearColor];
    self.centerImageView.image = centerImage;
    self.centerImageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);

#ifndef CONTEXT_GAUGE_SCALE_LINE
    [self.layer addSublayer:self.pointerLayer];
    [self addSubview:self.centerImageView];
#endif
    
}

- (void)setGaugePercentValue:(CGFloat)percent animated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
    [self setGaugePercentValue:percent duration:0.5 voice:NO animated:animated completion:completion];
}

- (void)setGaugePercentValue:(CGFloat)percent duration:(CGFloat)duration voice:(BOOL)voice animated:(BOOL)animated completion:(void (^)(BOOL))completion
{
    CGFloat scaleVale = [self percentToScaleValue:percent];
    CGFloat angle     = [self scaleValueToAngle:scaleVale];
    
    if(animated){
        [self pointerToAngle:angle duration:duration];
    }else{
        [self pointerToAngle:angle duration:0.0];
    }
    if(voice && nil != engineAudioPlayer){
        [engineAudioPlayer play];
    }
    self.gaugeScale = scaleVale;
    
    [self performSelector:@selector(animationFinished:) withObject:completion afterDelay:duration];
}

- (void)animationFinished:(void (^)(BOOL finished))completion
{
    if(completion){
        completion(YES);
    }
}

#pragma mark 百分比转刻度值
- (CGFloat)percentToScaleValue:(CGFloat)percent
{
    if(percent < 0){
        return 0;
    }else if(percent > 1){
        return 1 * maxScale;
    }
    return (percent * maxScale);
}

#pragma mark 刻度值转角度
- (CGFloat)scaleValueToAngle:(CGFloat)val
{
    if(val < MIN_GAUGE_SCALE){
        return MIN_GAUGE_SCALE;
    }else if(val > MAX_GAUGE_SCALE){
        return MAX_GAUGE_SCALE;
    }else {
        return (val - gaugeScale) * ((maxAngle-minAngle)/(maxScale-MIN_GAUGE_SCALE));
    }
}

#pragma mark 角度转弧度
- (CGFloat)transToRadian:(CGFloat)angel
{
    return angel*M_PI/180;
}

#pragma mark 半径和角度计算X
- (CGFloat)parseToX:(CGFloat)radius angle:(CGFloat)angle
{
    CGFloat radian = [self transToRadian:angle];
    return radius*cos(radian);
}

#pragma mark 半径和角度计算Y
- (CGFloat)parseToY:(CGFloat)radius angle:(CGFloat)angle
{
    CGFloat radian = [self transToRadian:angle];
    return radius*sin(radian);
}

#pragma mark 按角度旋转
- (void)pointerToAngle:(CGFloat)angle duration:(CGFloat)duration
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSMutableArray* values = [NSMutableArray array];
    animation.duration = duration;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    // 把旋转的角度平均分
    CGFloat distance = angle/ROTATE_GAUGE_AVERAGE_NUMBER;
    // 设置转动路径，不能直接用CABaseAnimation的toValue，那样是按最短路径的，转动超过180度时无法控制方向
    int i = 1;
    for(;i <= ROTATE_GAUGE_AVERAGE_NUMBER; i ++){
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, [self transToRadian:(gaugeAngle+distance*i)], 0, 0, 1)]];
    }
    //添加缓动效果
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, [self transToRadian:(gaugeAngle+distance*(i))], 0, 0, 1)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, [self transToRadian:(gaugeAngle+distance*(i-2))], 0, 0, 1)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, [self transToRadian:(gaugeAngle+distance*(i-1))], 0, 0, 1)]];
    
    animation.values = values;
    [pointerLayer addAnimation:animation forKey:@"GaugePointerAnimation"];
    gaugeAngle = gaugeAngle + angle;
}

- (void)loadData
{
    if(nil == dataSource ||
       NO == [dataSource respondsToSelector:@selector(numberOfRowsInGaugeView:)] ||
       NO == [dataSource respondsToSelector:@selector(gaugeView:stringAtIndex:)] ||
       NO == [dataSource respondsToSelector:@selector(gaugeView:colorAtIndex:)]){
        return;
    }
    
    NSInteger count = [dataSource numberOfRowsInGaugeView:self];
    if(0 == count || 1 == count) return;
    
    CGFloat angleGap = (maxAngle-minAngle)/(count-1);
    CGPoint centerPoint = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = self.gaugeImage.size.width/2;
    CGFloat currentAngle = 0;
    
    for (int i = 0; i < count; i ++) {
        currentAngle = minAngle + i * angleGap - 90;
        
        // 刻度值
        UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)] autorelease];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:9.0];
        label.text = [dataSource gaugeView:self stringAtIndex:i];
        label.textColor = [dataSource gaugeView:self colorAtIndex:i];
        label.center = CGPointMake(centerPoint.x+[self parseToX:radius-40 angle:currentAngle], centerPoint.y+[self parseToY:radius-40 angle:currentAngle]);
        
#ifdef CONTEXT_GAUGE_SCALE_LINE
        [self addSubview:label];
#else
        [self insertSubview:label aboveSubview:gaugeImageView];
        
        // 刻度线
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 1)];
        line.backgroundColor = self.scaleColor;
        line.center = CGPointMake(centerPoint.x+[self parseToX:radius-25 angle:currentAngle], centerPoint.y+[self parseToY:radius-25 angle:currentAngle]);
        line.layer.anchorPoint = CGPointMake(0.5, 0.5);
        line.layer.transform = CATransform3DRotate(CATransform3DIdentity, [self transToRadian:currentAngle], 0, 0, 1);
        [self insertSubview:line aboveSubview:gaugeImageView];
        [line release];
#endif
    }
    
#ifdef CONTEXT_GAUGE_SCALE_LINE
    [self.layer addSublayer:self.pointerLayer];
    [self addSubview:self.centerImageView];
#endif
}


#ifdef CONTEXT_GAUGE_SCALE_LINE

- (void)layoutGaugeMark:(CGRect)rect context:(CGContextRef)context
{
    CGFloat maxWidth = rect.size.width;
    CGFloat imageWidth = self.gaugeImage.size.width;
    CGFloat imageHeight = self.gaugeImage.size.height;
    
    CGRect bounds = CGRectMake(0, 0, imageWidth, imageHeight);
    if(imageWidth > maxWidth || imageHeight > maxWidth){
        CGFloat ratio = imageWidth/imageHeight;
        if(ratio > 1){
            bounds.size.width  = maxWidth;
            bounds.size.height = bounds.size.width / ratio;
        }else{
            bounds.size.height = maxWidth;
            bounds.size.width  = bounds.size.height * ratio;
        }
    }
    bounds.origin.x = (rect.size.width-bounds.size.width)/2;
    bounds.origin.y = (rect.size.height-bounds.size.height)/2;
    
    [self.gaugeImage drawInRect:bounds];
}

- (void)layoutLineMark:(CGContextRef)context
{
    if(nil == dataSource || NO == [dataSource respondsToSelector:@selector(numberOfRowsInGaugeView:)]){
        return;
    }
    
    NSInteger count = [dataSource numberOfRowsInGaugeView:self];
    if(0 == count || 1 == count) return;
    
    CGFloat angleGap = (maxAngle-minAngle)/(count-1);
    CGPoint centerPoint = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = self.gaugeImage.size.width/2;
    CGFloat currentAngle = 0;
    
    for (int i = 0; i < count; i ++) {
        currentAngle = minAngle + i * angleGap - 90;
        if(nil != self.scaleColor){
            CGContextSetStrokeColorWithColor(context, self.scaleColor.CGColor);
        }
        CGContextSetLineWidth(context, 1);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextStrokePath(context);
        CGContextMoveToPoint(context, centerPoint.x+[self parseToX:radius-20 angle:currentAngle], centerPoint.y+[self parseToY:radius-20 angle:currentAngle]);
        CGContextAddLineToPoint(context, centerPoint.x+[self parseToX:radius-25 angle:currentAngle], centerPoint.y+[self parseToY:radius-25 angle:currentAngle]);
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self layoutGaugeMark:rect context:context];
    [self layoutLineMark:context];
    CGContextStrokePath(context);
}
 
#endif


@end