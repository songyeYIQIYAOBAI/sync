//
//  EPie.m
//  IOS7Test
//
//  Created by shengyp on 14-6-23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "EPie.h"
#import "EPieDataModel.h"

static NSUInteger kDefaultSliceZOrder = 100;

@implementation SliceLayer
@synthesize value,percentage,startAngle,endAngle,isSelected;

- (void)dealloc
{
    [super dealloc];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"value:%f,percentage:%0.0f,start:%f,end:%f",value,percentage,startAngle/M_PI*180,endAngle/M_PI*180];
}

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"startAngle"] || [key isEqualToString:@"endAngle"]) {
        return YES;
    }else {
        return [super needsDisplayForKey:key];
    }
}

- (id)initWithLayer:(id)layer
{
    if (self = [super initWithLayer:layer]){
        if ([layer isKindOfClass:[SliceLayer class]]) {
            self.startAngle = [(SliceLayer *)layer startAngle];
            self.endAngle = [(SliceLayer *)layer endAngle];
        }
    }
    return self;
}

- (void)createArcAnimationForKey:(NSString*)key fromValue:(NSNumber*)from toValue:(NSNumber*)to delegate:(id)delegate
{
    CABasicAnimation* arcAnimation = [CABasicAnimation animationWithKeyPath:key];
    NSNumber* currentAngle = [[self presentationLayer] valueForKey:key];
    if(!currentAngle) currentAngle = from;
    [arcAnimation setFromValue:currentAngle];
    [arcAnimation setToValue:to];
    [arcAnimation setDelegate:delegate];
    [arcAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self addAnimation:arcAnimation forKey:key];
    [self setValue:to forKey:key];
}

@end


@implementation EPie
@synthesize dataSource,delegate;
@synthesize startPieAngle,animationSpeed,pieCenter,pieRadius,selectedSliceStroke,selectedSliceOffsetRadius;

static CGPathRef CGPathCreateArc(CGPoint center, CGFloat radius, CGFloat startAngle, CGFloat endAngle)
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, center.x, center.y);
    
    CGPathAddArc(path, NULL, center.x, center.y, radius, startAngle, endAngle, 0);
    CGPathCloseSubpath(path);
    
    return path;
}

- (void)dealloc
{
	[pieView release];
	[animations release];
	
	self.dataSource = nil;
	self.delegate = nil;
	
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		pieView = [[UIView alloc] initWithFrame:self.bounds];
		pieView.backgroundColor = [UIColor clearColor];
		[self addSubview:pieView];
		
		selectedSliceIndex = -1;
		
		animations = [[NSMutableArray alloc] initWithCapacity:0];
		
		self.startPieAngle = 0;
		
		self.animationSpeed = 1.0;
		
		self.pieCenter = CGPointMake(frame.size.width/2, frame.size.height/2);
		
		self.pieRadius = MIN(frame.size.width/2, frame.size.height/2);
		
		self.selectedSliceStroke = 3.0;
		
		self.selectedSliceOffsetRadius =  MAX(10, self.pieRadius/10);
    }
    return self;
}

#pragma mark - manage settings
- (void)setPieCenter:(CGPoint)aPieCenter
{
    [pieView setCenter:aPieCenter];
    pieCenter = CGPointMake(pieView.frame.size.width/2, pieView.frame.size.height/2);
}

- (void)setPieRadius:(CGFloat)aPieRadius
{
    pieRadius = aPieRadius;
	
    CGRect frame = CGRectMake(pieCenter.x-pieRadius, pieCenter.y-pieRadius, pieRadius*2, pieRadius*2);
    pieCenter = CGPointMake(frame.size.width/2, frame.size.height/2);
    [pieView setFrame:frame];
    [pieView.layer setCornerRadius:pieRadius];
}

- (void)setPieBackgroundColor:(UIColor*)color
{
	[pieView setBackgroundColor:color];
}

- (void)setSliceSelectedAtIndex:(NSInteger)index
{
    if(selectedSliceOffsetRadius <= 0) return;
	
    SliceLayer* layer = [pieView.layer.sublayers objectAtIndex:index];
    if (nil != layer) {
		if(layer.percentage < 0.5){
			CGFloat adjust = 0.5;
			CGPoint currPos = layer.position;
			double middleAngle = (layer.startAngle + layer.endAngle)/2.0;
			CGPoint newPos = CGPointMake(currPos.x + selectedSliceOffsetRadius*cos(middleAngle)*adjust, currPos.y + selectedSliceOffsetRadius*sin(middleAngle)*adjust);
			layer.position = newPos;
		}

        layer.isSelected = YES;
    }
}

- (void)setSliceDeselectedAtIndex:(NSInteger)index
{
    if(selectedSliceOffsetRadius <= 0) return;
	
    SliceLayer* layer = [pieView.layer.sublayers objectAtIndex:index];
    if (nil != layer) {
        layer.position = CGPointMake(0, 0);
        layer.isSelected = NO;
    }
}

#pragma mark - CAAnimationDelegate + Run Loop Timer
- (void)updateTimerFired:(NSTimer*)timer
{
    CALayer* parentLayer = [pieView layer];
    NSArray* pieLayers = [parentLayer sublayers];
    
    [pieLayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSNumber* presentationLayerStartAngle = [[obj presentationLayer] valueForKey:@"startAngle"];
        CGFloat interpolatedStartAngle = [presentationLayerStartAngle doubleValue];
        
        NSNumber* presentationLayerEndAngle = [[obj presentationLayer] valueForKey:@"endAngle"];
        CGFloat interpolatedEndAngle = [presentationLayerEndAngle doubleValue];
        
        CGPathRef path = CGPathCreateArc(pieCenter, pieRadius, interpolatedStartAngle, interpolatedEndAngle);
        [obj setPath:path];
        CFRelease(path);

    }];
}

- (void)animationDidStart:(CAAnimation*)anim
{
    if (animationTimer == nil) {
        static float timeInterval = 1.0/60.0;
        animationTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(updateTimerFired:) userInfo:nil repeats:YES];
    }
    [animations addObject:anim];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)animationCompleted
{
    [animations removeObject:anim];
    
    if ([animations count] == 0) {
        [animationTimer invalidate];
        animationTimer = nil;
    }
}

#pragma mark - Touch Handing (Selection Notification)
- (NSInteger)getCurrentSelectedOnTouch:(CGPoint)point
{
    __block NSUInteger selectedIndex = -1;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    CALayer* parentLayer = [pieView layer];
    NSArray* pieLayers = [parentLayer sublayers];
    
    [pieLayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SliceLayer* pieLayer = (SliceLayer*)obj;
        CGPathRef path = [pieLayer path];
        
        if (CGPathContainsPoint(path, &transform, point, 0)) {
            [pieLayer setLineWidth:selectedSliceStroke];
            [pieLayer setStrokeColor:[UIColor whiteColor].CGColor];
            [pieLayer setLineJoin:kCALineJoinBevel];
            [pieLayer setZPosition:MAXFLOAT];
            selectedIndex = idx;
        } else {
            [pieLayer setZPosition:kDefaultSliceZOrder];
            [pieLayer setLineWidth:0.0];
        }
    }];
	
    return selectedIndex;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:pieView];
    [self getCurrentSelectedOnTouch:point];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:pieView];
    NSInteger selectedIndex = [self getCurrentSelectedOnTouch:point];
    [self notifyDelegateOfSelectionChangeFrom:selectedSliceIndex to:selectedIndex];
    [self touchesCancelled:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event
{
    CALayer* parentLayer = [pieView layer];
    NSArray* pieLayers = [parentLayer sublayers];
    
    for (SliceLayer* pieLayer in pieLayers) {
        [pieLayer setZPosition:kDefaultSliceZOrder];
        [pieLayer setLineWidth:0.0];
    }
}

- (void)pieSelected:(NSInteger)selIndex
{
    [self notifyDelegateOfSelectionChangeFrom:selectedSliceIndex to:selIndex];
    [self touchesCancelled:nil withEvent:nil];
}

#pragma mark - Selection Notification
- (void)notifyDelegateOfSelectionChangeFrom:(NSUInteger)previousSelection to:(NSUInteger)newSelection
{
    if (previousSelection != newSelection){
        if (previousSelection != -1 && [delegate respondsToSelector:@selector(pie:willDeselectSliceAtIndex:)]){
            [delegate pie:self willDeselectSliceAtIndex:previousSelection];
        }
        
        selectedSliceIndex = newSelection;
        
        if (newSelection != -1){
            if([delegate respondsToSelector:@selector(pie:willSelectSliceAtIndex:)]){
                [delegate pie:self willSelectSliceAtIndex:newSelection];
			}
            if(previousSelection != -1 && [delegate respondsToSelector:@selector(pie:didDeselectSliceAtIndex:)]){
                [delegate pie:self didDeselectSliceAtIndex:previousSelection];
			}

            [self setSliceSelectedAtIndex:newSelection];
			
			if([delegate respondsToSelector:@selector(pie:didSelectSliceAtIndex:)]){
                [delegate pie:self didSelectSliceAtIndex:newSelection];
			}
        }
        
        if(previousSelection != -1){
            [self setSliceDeselectedAtIndex:previousSelection];
			
            if([delegate respondsToSelector:@selector(pie:didDeselectSliceAtIndex:)]){
                [delegate pie:self didDeselectSliceAtIndex:previousSelection];
			}
        }
    }else if (newSelection != -1){
        SliceLayer* layer = [pieView.layer.sublayers objectAtIndex:newSelection];
        if(selectedSliceOffsetRadius > 0 && nil != layer){
            
            if (layer.isSelected) {
                if ([delegate respondsToSelector:@selector(pie:willDeselectSliceAtIndex:)]){
                    [delegate pie:self willDeselectSliceAtIndex:newSelection];
				}
				
                [self setSliceDeselectedAtIndex:newSelection];
				
                if (newSelection != -1 && [delegate respondsToSelector:@selector(pie:didDeselectSliceAtIndex:)]){
                    [delegate pie:self didDeselectSliceAtIndex:newSelection];
				}
            }else {
                if ([delegate respondsToSelector:@selector(pie:willSelectSliceAtIndex:)]){
                    [delegate pie:self willSelectSliceAtIndex:newSelection];
				}
				
                [self setSliceSelectedAtIndex:newSelection];
				
                if (newSelection != -1 && [delegate respondsToSelector:@selector(pie:didSelectSliceAtIndex:)]){
                    [delegate pie:self didSelectSliceAtIndex:newSelection];
				}
            }
        }
    }
}

#pragma mark - Pie Layer Creation Method
- (SliceLayer*)createSliceLayer
{
    SliceLayer* pieLayer = [SliceLayer layer];
	pieLayer.zPosition = 0;
	pieLayer.strokeColor = nil;

    return pieLayer;
}

#pragma mark - Pie Reload Data With Animation
- (void)reloadPie
{
    if (nil != dataSource && nil == animationTimer){
        CALayer* parentLayer = [pieView layer];
        NSArray* slicelayers = [parentLayer sublayers];
        
        selectedSliceIndex = -1;
		
        [slicelayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SliceLayer* layer = (SliceLayer *)obj;
            if(layer.isSelected)
                [self setSliceDeselectedAtIndex:idx];
        }];
        
        double startToAngle = 0.0;
        double endToAngle = startToAngle;
        
        NSUInteger sliceCount = [dataSource numberOfSlicesInEPie:self];
        
        double sum = 0.0;
        double values[sliceCount];
        for (int index = 0; index < sliceCount; index++) {
			EPieDataModel* dataModel = [dataSource pie:self valueForSliceAtIndex:index];
            values[index] = dataModel.value;
            sum += values[index];
        }
        
        double angles[sliceCount];
        for (int index = 0; index < sliceCount; index++) {
            double div;
            if (sum == 0){
                div = 0;
			}else{
                div = values[index] / sum;
			}
            angles[index] = M_PI * 2 * div;
        }
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:animationSpeed];
        
        [pieView setUserInteractionEnabled:NO];
        
		NSMutableArray* layersToRemove = nil;
		
        [CATransaction setCompletionBlock:^{
            
            [layersToRemove enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [obj removeFromSuperlayer];
            }];
            
            [layersToRemove removeAllObjects];
            
            for(SliceLayer* layer in pieView.layer.sublayers){
                [layer setZPosition:kDefaultSliceZOrder];
            }
            
            [pieView setUserInteractionEnabled:YES];
			
            if([delegate respondsToSelector:@selector(animateFinish:)]){
                [delegate animateFinish:self];
            }
			
        }];
        
        BOOL isOnStart = ([slicelayers count] == 0 && sliceCount);
        NSInteger diff = sliceCount - [slicelayers count];
        layersToRemove = [NSMutableArray arrayWithArray:slicelayers];
        
        BOOL isOnEnd = ([slicelayers count] && (sliceCount == 0 || sum <= 0));
        if(isOnEnd){
            for(SliceLayer* layer in pieView.layer.sublayers){
				
                [layer createArcAnimationForKey:@"startAngle"
                                      fromValue:[NSNumber numberWithDouble:startPieAngle]
                                        toValue:[NSNumber numberWithDouble:startPieAngle]
                                       delegate:self];
				
                [layer createArcAnimationForKey:@"endAngle"
                                      fromValue:[NSNumber numberWithDouble:startPieAngle]
                                        toValue:[NSNumber numberWithDouble:startPieAngle]
                                       delegate:self];
            }
            [CATransaction commit];
            return;
        }
        
        for(int index = 0; index < sliceCount; index ++){
            SliceLayer* layer = nil;
            double angle = angles[index];
            endToAngle += angle;
            double startFromAngle = startPieAngle + startToAngle;
            double endFromAngle = startPieAngle + endToAngle;
            
            if(index >= [slicelayers count] ){
                layer = [self createSliceLayer];
                if (isOnStart){
                    startFromAngle = endFromAngle = startPieAngle;
				}
                [parentLayer addSublayer:layer];
                diff --;
            }else{
                SliceLayer* onelayer = [slicelayers objectAtIndex:index];
                if(diff == 0 || onelayer.value == (CGFloat)values[index]){
                    layer = onelayer;
                    [layersToRemove removeObject:layer];
                }else if(diff > 0){
                    layer = [self createSliceLayer];
                    [parentLayer insertSublayer:layer atIndex:index];
                    diff --;
                }else {
                    while(diff < 0){
                        [onelayer removeFromSuperlayer];
                        [parentLayer addSublayer:onelayer];
                        diff ++;
                        onelayer = [slicelayers objectAtIndex:index];
                        if(diff == 0 || onelayer.value == (CGFloat)values[index]){
                            layer = onelayer;
                            [layersToRemove removeObject:layer];
                            break;
                        }
                    }
                }
            }
            
            layer.value = values[index];
            layer.percentage = (sum)?layer.value/sum:0;
            UIColor* color = nil;
            if([dataSource respondsToSelector:@selector(pie:colorForSliceAtIndex:)]){
                color = [dataSource pie:self colorForSliceAtIndex:index];
            }
            if(nil == color){
                color = [UIColor colorWithHue:((index/8)%20)/20.0+0.02 saturation:(index%8+3)/10.0 brightness:91/100.0 alpha:1];
            }
            
            [layer setFillColor:color.CGColor];

            [layer createArcAnimationForKey:@"startAngle"
                                  fromValue:[NSNumber numberWithDouble:startFromAngle]
                                    toValue:[NSNumber numberWithDouble:startToAngle+startPieAngle]
                                   delegate:self];
			
            [layer createArcAnimationForKey:@"endAngle"
                                  fromValue:[NSNumber numberWithDouble:endFromAngle]
                                    toValue:[NSNumber numberWithDouble:endToAngle+startPieAngle]
                                   delegate:self];
			
            startToAngle = endToAngle;
        }
		
        [CATransaction setDisableActions:YES];
		
        for(SliceLayer* layer in layersToRemove){
			layer.fillColor = self.backgroundColor.CGColor;
			layer.delegate = nil;
			layer.zPosition = 0;
        }
		
        [CATransaction setDisableActions:NO];
        [CATransaction commit];
    }
}

@end
