//
//  EPieRotated.m
//  IOS7Test
//
//  Created by shengyp on 14-6-23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "EPieRotated.h"
#import "EPieDataModel.h"

#define K_EPSINON        			(1e-127)
#define IS_ZERO_FLOAT(X) 			(X < K_EPSINON && X > -K_EPSINON)
#define K_FRICTION              	6.0f   // 摩擦系数
#define K_MAX_SPEED             	12.0f

@interface EPieRotated()

@property (nonatomic, assign) NSInteger 		selectedIndex;
@property (nonatomic, retain) EPie* 			ePie;
@property (nonatomic, assign) BOOL 				canLayerOpen;

@property (nonatomic, retain) NSDate*			mDragBeforeDate;
@property (nonatomic, retain) NSTimer*			mDecelerateTimer;

@end

@implementation EPieRotated
@synthesize selectedIndex,ePie,canLayerOpen,mDragBeforeDate,mDecelerateTimer;
@synthesize delegate,dataSource,fracValue,isAutoRotation;

- (void)dealloc
{
	[mThetaArray release];
	[ePie release];
	[mDragBeforeDate release];
	
	self.dataSource = nil;
	self.delegate = nil;
	
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		mRelativeTheta = 0.0;
		isAnimating = NO;
		isTapStopped = NO;
		
		self.ePie = [[[EPie alloc] initWithFrame:self.bounds] autorelease];
		self.ePie.userInteractionEnabled = NO;
		self.ePie.dataSource = self;
		self.ePie.delegate = self;
		[self.ePie setPieCenter:CGPointMake(frame.size.width/2, frame.size.height/2)];
		[self addSubview:self.ePie];
    }
    return self;
}

- (void)startedAnimate
{
	[self performSelector:@selector(delayAnimate) withObject:nil afterDelay:0.0f];
}

- (void)reloadPieRotated
{
	isAutoRotation = YES;
    [self.ePie reloadPie];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	if(nil == dataSource) return;
	
    NSInteger wedges = [dataSource numberOfSlicesInEPieRotated:self];
    
    mThetaArray = [[NSMutableArray alloc] initWithCapacity:wedges];
    
    float sum = 0.0f;
    for (int i = 0; i < wedges; i ++) {
		EPieDataModel* dataModel = [dataSource pieRotated:self valueForSliceAtIndex:i];
        sum += dataModel.value;
    }
	if(0.0f == sum) sum = 1.0;
	
    float frac = 2.0 * M_PI / sum;
    self.fracValue = frac;
    
    float endAngle = 0.0;
    for (int i = 0; i < wedges; i ++) {
		EPieDataModel* dataModel = [dataSource pieRotated:self valueForSliceAtIndex:i];
        endAngle += dataModel.value * frac;
        [mThetaArray addObject:[NSNumber numberWithFloat:endAngle]];
    }
}

#pragma mark handle rotation angle
- (float)thetaForX:(float)x andY:(float)y
{
    if (IS_ZERO_FLOAT(y)) {
        if (x < 0) {
            return M_PI;
        } else {
            return 0;
        }
    }
    
    float theta = atan(y / x);
    if (x < 0 && y > 0) {
        theta = M_PI + theta;
    } else if (x < 0 && y < 0) {
        theta = M_PI + theta;
    } else if (x > 0 && y < 0) {
        theta = 2 * M_PI + theta;
    }
    return theta;
}

- (float)rotationThetaForNewTheta:(float)newTheta
{
    float rotationTheta;
    if (mRelativeTheta > (3 * M_PI_2) && (newTheta < M_PI_2)) {
        rotationTheta = newTheta + (2 * M_PI - mRelativeTheta);
    } else {
        rotationTheta = newTheta - mRelativeTheta;
    }
    return rotationTheta;
}

- (float)thetaForTouch:(UITouch *)touch onView:view
{
    CGPoint location = [touch locationInView:view];
    float xOffset    = self.bounds.size.width / 2;
    float yOffset    = self.bounds.size.height / 2;
    float centeredX  = location.x - xOffset;
    float centeredY  = location.y - yOffset;
    
    return [self thetaForX:centeredX andY:centeredY];
}

#pragma mark Private & handle rotation
- (void)timerStop
{
	if(nil != self.mDecelerateTimer && [self.mDecelerateTimer isValid]){
		[self.mDecelerateTimer invalidate];
		self.mDecelerateTimer = nil;
	}

    mDragSpeed = 0;
    isAnimating = NO;
    
    [self performSelector:@selector(delayAnimate) withObject:nil afterDelay:0.0f];
}

- (void)delayAnimate
{
    double tan2 = atan2(self.transform.b, self.transform.a);

    //根据旋转角度判断当前在那个扇区中
    float curTheta = M_PI_2 - tan2;
    curTheta = curTheta > 0 ? curTheta : M_PI*2+curTheta;
    int selIndex = 0;
    for (;selIndex < [mThetaArray count]; selIndex ++) {
        if (curTheta < [[mThetaArray objectAtIndex:selIndex] floatValue]) {
            break;
        }
    }
	
    //根据当前旋转弧度和选中扇区的起止弧度，判断居中需要旋转的弧度
    float calTheta = [[mThetaArray objectAtIndex:selIndex] floatValue] - curTheta;
	float fanTheta = [dataSource pieRotated:self valueForSliceAtIndex:selIndex].value * self.fracValue;
    float rotateTheta = fanTheta/2 - calTheta;
	
    //设置动画旋转
    [UIView animateWithDuration:0.42 animations:^{
        self.transform = CGAffineTransformRotate(self.transform,rotateTheta);
    } completion:^(BOOL finished) {
        [self outPie];
    }];
	
    [self delayAnimateStop:selIndex];
}

- (void)outPie
{
    [self.ePie pieSelected:self.selectedIndex];
    self.canLayerOpen = YES;
}

- (void)delayAnimateStop:(NSInteger)index
{
    float sum = 0.0f;
	NSInteger count = [dataSource numberOfSlicesInEPieRotated:self];
    for (int i = 0; i < count; ++i) {
		sum += [dataSource pieRotated:self valueForSliceAtIndex:i].value;
    }
	if(0.0f == sum) sum = 1.0;
	
    float percent = [dataSource pieRotated:self valueForSliceAtIndex:index].value / sum;
    self.selectedIndex = index;
	
    if (nil != delegate && [self.delegate respondsToSelector:@selector(selectedFinish:index:percent:)]) {
        [self.delegate selectedFinish:self index:index percent:percent];
    }
}

- (void)animationDidStop:(NSString*)str finished:(NSNumber*)flag context:(void*)context
{
    isAutoRotation = NO;
    [self delayAnimate];
}

- (int)touchIndex
{
    int index = 0;
    for (int i = 0; i < [mThetaArray count]; i ++) {
        if (mRelativeTheta < [[mThetaArray objectAtIndex:i] floatValue]) {
			index = i;
            break;
        }
    }
    return index;
}

- (void)tapStopped
{
    int tapAreaIndex = [self touchIndex];
    
    if (tapAreaIndex == 0) {
        mRelativeTheta = [[mThetaArray objectAtIndex:0] floatValue] / 2;
    } else {
        mRelativeTheta = [[mThetaArray objectAtIndex:tapAreaIndex] floatValue]
        - (([[mThetaArray objectAtIndex:tapAreaIndex] floatValue]
            - [[mThetaArray objectAtIndex:tapAreaIndex - 1] floatValue]) / 2);
    }
    if (tapAreaIndex != self.selectedIndex) {
        if (self.canLayerOpen) {
            [self.ePie pieSelected:self.selectedIndex];
            self.canLayerOpen = NO;
        }
        isAutoRotation = YES;
        [UIView beginAnimations:@"tap stopped" context:nil];
        [UIView setAnimationDuration:1];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        self.transform = CGAffineTransformMakeRotation([self rotationThetaForNewTheta:M_PI_2]);
        [UIView commitAnimations];
    }
    
    return;
}

- (void)decelerate
{
    if (mDragSpeed > 0) {
        mDragSpeed -= (K_FRICTION / 100);
        
        if (mDragSpeed < 0.01) {
            [self timerStop];
        }
        
        mAbsoluteTheta += (mDragSpeed / 100);
        if ((M_PI * 2) < mAbsoluteTheta) {
            mAbsoluteTheta -= (M_PI * 2);
        }
    } else if (mDragSpeed < 0){
        mDragSpeed += (K_FRICTION /100);
        if (mDragSpeed > -0.01) {
            [self timerStop];
        }
        
        mAbsoluteTheta += (mDragSpeed / 100);
        if (0 > mAbsoluteTheta) {
            mAbsoluteTheta = (M_PI * 2) + mAbsoluteTheta;
        }
    }
    
    isAnimating = YES;
    [UIView beginAnimations:@"pie rotation" context:nil];
    [UIView setAnimationDuration:0.01];
    self.transform = CGAffineTransformMakeRotation([self rotationThetaForNewTheta:mAbsoluteTheta]);
    [UIView commitAnimations];
}

#pragma mark Responder
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isAutoRotation) {
        return;
    }
    
    isTapStopped = IS_ZERO_FLOAT(mDragSpeed);
    
    if (nil != mDecelerateTimer && [self.mDecelerateTimer isValid]) {
        [self.mDecelerateTimer invalidate];
        self.mDecelerateTimer = nil;
        mDragSpeed = 0;
        isAnimating = NO;
    }
    
    UITouch* touch   = [touches anyObject];
    mAbsoluteTheta   = [self thetaForTouch:touch onView:self.superview];
    mRelativeTheta   = [self thetaForTouch:touch onView:self];
    self.mDragBeforeDate  = [NSDate date];
    mDragBeforeTheta = 0.0f;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (isAutoRotation) {
        return;
    }
    
    if (self.canLayerOpen) {
        [self.ePie pieSelected:self.selectedIndex];
        self.canLayerOpen = NO;
    }
    
    isAnimating = YES;
    UITouch* touch = [touches anyObject];
    
    // 取得当前触点的theta值
    mAbsoluteTheta = [self thetaForTouch:touch onView:self.superview];
    
    // 计算速度
    NSTimeInterval dragInterval = [self.mDragBeforeDate timeIntervalSinceNow];
    
    /*由于theta大于2*PI后自动归零,因此此处需判断是否是在0度前后拖动 */
    if (fabsf(mAbsoluteTheta - mDragBeforeTheta) > M_PI) {    // 应判断是否#约等于#2PI.
        if (mAbsoluteTheta > mDragBeforeTheta) {  // 反方向转动
            mDragSpeed = (mAbsoluteTheta - (mDragBeforeTheta + 2 * M_PI)) / fabs(dragInterval);
        } else {        // 正向转动
            mDragSpeed = ((mAbsoluteTheta + 2 * M_PI) - mDragBeforeTheta) / fabs(dragInterval);
        }
    } else {
        mDragSpeed = (mAbsoluteTheta - mDragBeforeTheta) / fabs(dragInterval);
    }

    [UIView beginAnimations:@"pie rotation" context:nil];
    [UIView setAnimationDuration:1];
    self.transform = CGAffineTransformMakeRotation([self rotationThetaForNewTheta:mAbsoluteTheta]);
    [UIView commitAnimations];
	
    isAnimating = NO;
    mDragBeforeTheta = mAbsoluteTheta;
    self.mDragBeforeDate = [NSDate date];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent *)event
{
    if (isAutoRotation) {
        return;
    }
    
    if (IS_ZERO_FLOAT(mDragSpeed)) {
        if (isTapStopped) {
            [self tapStopped];
            return;
        } else {
            [self delayAnimate];
            return;
        }
    } else if ((fabsf(mDragSpeed) > K_MAX_SPEED)) {
        mDragSpeed = (mDragSpeed > 0) ? K_MAX_SPEED : -K_MAX_SPEED;
    }

	NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:0.01
													  target:self
													selector:@selector(decelerate)
													userInfo:nil
													 repeats:YES];
    self.mDecelerateTimer = timer;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

#pragma -mark EPieDataSource
- (NSInteger)numberOfSlicesInEPie:(EPie*)pie
{
	return [dataSource numberOfSlicesInEPieRotated:self];
}

- (EPieDataModel*)pie:(EPie*)pie valueForSliceAtIndex:(NSInteger)index
{
	return [dataSource pieRotated:self valueForSliceAtIndex:index];
}

- (UIColor*)pie:(EPie*)pie colorForSliceAtIndex:(NSInteger)index
{
	return [dataSource pieRotated:self colorForSliceAtIndex:index];
}

#pragma mark EPieDelegate
- (void)animateFinish:(EPie*)pie
{
    isAutoRotation = NO;
    [self startedAnimate];
}

- (void)pie:(EPie*)pie willSelectSliceAtIndex:(NSUInteger)index
{
	if(nil != delegate && [delegate respondsToSelector:@selector(pieRotated:willSelectSliceAtIndex:)]){
		[delegate pieRotated:self willSelectSliceAtIndex:index];
	}
}

- (void)pie:(EPie*)pie didSelectSliceAtIndex:(NSUInteger)index
{
	if(nil != delegate && [delegate respondsToSelector:@selector(pieRotated:didSelectSliceAtIndex:)]){
		[delegate pieRotated:self didSelectSliceAtIndex:index];
	}
}

- (void)pie:(EPie*)pie willDeselectSliceAtIndex:(NSUInteger)index
{
	if(nil != delegate && [delegate respondsToSelector:@selector(pieRotated:willDeselectSliceAtIndex:)]){
		[delegate pieRotated:self willDeselectSliceAtIndex:index];
	}
}

- (void)pie:(EPie*)pie didDeselectSliceAtIndex:(NSUInteger)index
{
	if(nil != delegate && [delegate respondsToSelector:@selector(pieRotated:didDeselectSliceAtIndex:)]){
		[delegate pieRotated:self didDeselectSliceAtIndex:index];
	}
}

@end
