//
//  ComboSlider.m
//  IOS7Test
//
//  Created by shengyp on 15-1-27.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "ComboSlider.h"

@implementation SliderUtils

+ (UIImage*)convertViewToImage:(UIView*)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIColor*)convertImageToColor:(UIImage*)image
{
    return [UIColor colorWithPatternImage:image];
}

+ (UIImage*)convertColorToImage:(UIColor*)color size:(CGSize)size
{
    return [SliderUtils convertColorToImage:color size:size border:NO];
}

+ (UIImage*)convertImageToImage:(UIImage*)image size:(CGSize)size
{
    UIImageView* bgView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)] autorelease];
    bgView.image = image;
    
    return [self convertViewToImage:bgView];
}

+ (UIImage*)convertColorToImage:(UIColor*)color size:(CGSize)size border:(BOOL)border
{
    UIView* bgView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)] autorelease];
    bgView.backgroundColor = color;
    bgView.layer.cornerRadius = size.height/2.0;
    
    if(border){
        bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        bgView.layer.borderWidth = 0.5;
    }
    
    return [self convertViewToImage:bgView];
}

@end


@implementation ProgressView
@synthesize progressView;
@synthesize progress;
@synthesize progressColor, trackColor;
@synthesize progressImage, trackImage;

- (void)dealloc
{
    [progressView release];
    [progressColor release];
    [trackColor release];
    [progressImage release];
    [trackImage release];
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        progressView = [[UIProgressView alloc] initWithFrame:self.bounds];
        progressView.backgroundColor = [UIColor clearColor];
        progressView.progressViewStyle = UIProgressViewStyleDefault;
        progressView.userInteractionEnabled = NO;
        progressView.layer.frame = self.bounds;
        for (CALayer* subLayer in progressView.layer.sublayers) {
            subLayer.masksToBounds = YES;
            subLayer.cornerRadius  = self.bounds.size.height/2.0;
        }
        [self addSubview:progressView];
    }
    return self;
}

- (void)setProgress:(float)aProgress
{
    [self setProgress:aProgress animated:NO];
}

- (void)setProgress:(float)aProgress animated:(BOOL)animated
{
    progress = aProgress;
    
    [progressView setProgress:aProgress animated:animated];
}

- (void)setProgressColor:(UIColor *)aProgressColor
{
    if(progressColor != aProgressColor){
        [progressColor release];
        progressColor = nil;
        progressColor = [aProgressColor retain];
    }
    
    if(nil != progressColor){
        progressView.progressTintColor = progressColor;
    }
}

- (void)setTrackColor:(UIColor *)aTrackColor
{
    if(trackColor != aTrackColor){
        [trackColor release];
        trackColor = nil;
        trackColor = [aTrackColor retain];
    }
    
    if(nil != trackColor){
        progressView.trackTintColor = trackColor;
    }
}

- (void)setProgressImage:(UIImage *)aProgressImage
{
    if(progressImage != aProgressImage){
        [progressImage release];
        progressImage = nil;
        progressImage = [aProgressImage retain];
    }
    
    if(nil != progressImage){
        progressView.progressTintColor = [SliderUtils convertImageToColor:progressImage];
    }
}

- (void)setTrackImage:(UIImage *)aTrackImage
{
    if(trackImage != aTrackImage){
        [trackImage release];
        trackImage = nil;
        trackImage = [aTrackImage retain];
    }
    
    if(nil != trackImage){
        progressView.trackTintColor = [SliderUtils convertImageToColor:trackImage];
    }
}

@end

@implementation Slider
@synthesize thumbSize;
@synthesize thumbColor, minimumTrackColor, maximumTrackColor;
@synthesize thumbImage, minimumTrackImage, maximumTrackImage;

- (void)dealloc
{
    [thumbColor release];
    [minimumTrackColor release];
    [maximumTrackColor release];
    
    [thumbImage release];
    [minimumTrackImage release];
    [maximumTrackImage release];
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.thumbSize = CGSizeMake(frame.size.height+6, frame.size.height+6);
    }
    return self;
}

- (CGRect)trackRectForBounds:(CGRect)bounds
{
    CGRect trackRectTemp = [super trackRectForBounds:bounds];
    trackRectTemp.origin.x = 0;
    trackRectTemp.origin.y = 0;
    trackRectTemp.size.width  = bounds.size.width;
    trackRectTemp.size.height = bounds.size.height;
    
    return trackRectTemp;
}

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{
    CGRect thumbRectTemp = [super thumbRectForBounds:bounds trackRect:rect value:value];
    
    return thumbRectTemp;
}

- (void)setThumbSize:(CGSize)aThumbSize
{
    thumbSize = aThumbSize;
    
    if(nil != thumbColor){
        [self setThumbImage:[SliderUtils convertColorToImage:thumbColor size:thumbSize border:YES] forState:UIControlStateNormal];
        [self setThumbImage:[SliderUtils convertColorToImage:thumbColor size:thumbSize border:YES] forState:UIControlStateHighlighted];
    }else if(nil != thumbImage){
        [self setThumbImage:[SliderUtils convertImageToImage:thumbImage size:thumbSize] forState:UIControlStateNormal];
        [self setThumbImage:[SliderUtils convertImageToImage:thumbImage size:thumbSize] forState:UIControlStateHighlighted];
    }
}

- (void)setThumbColor:(UIColor *)aThumbColor
{
    if(thumbColor != aThumbColor){
        [thumbColor release];
        thumbColor = nil;
        thumbColor = [aThumbColor retain];
    }
    
    if(NO == CGSizeEqualToSize(CGSizeZero, thumbSize)){
        [self setThumbImage:[SliderUtils convertColorToImage:thumbColor size:thumbSize border:YES] forState:UIControlStateNormal];
        [self setThumbImage:[SliderUtils convertColorToImage:thumbColor size:thumbSize border:YES] forState:UIControlStateHighlighted];
    }
}

- (void)setMinimumTrackColor:(UIColor *)aMinimumTrackColor
{
    if(minimumTrackColor != aMinimumTrackColor){
        [minimumTrackColor release];
        minimumTrackColor = nil;
        minimumTrackColor = [aMinimumTrackColor retain];
    }
    
    if(nil != minimumTrackColor){
        UIImage* minTrackImage = [SliderUtils convertColorToImage:minimumTrackColor size:self.bounds.size];
        [self setMinimumTrackImage:[minTrackImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)
                                                                 resizingMode:UIImageResizingModeTile]
                          forState:UIControlStateNormal];
    }
}

- (void)setMaximumTrackColor:(UIColor *)aMaximumTrackColor
{
    if(maximumTrackColor != aMaximumTrackColor){
        [maximumTrackColor release];
        maximumTrackColor = nil;
        maximumTrackColor = [aMaximumTrackColor retain];
    }
    
    if(nil != maximumTrackColor){
        UIImage* maxTrackImage = [SliderUtils convertColorToImage:maximumTrackColor size:self.bounds.size];
        [self setMaximumTrackImage:[maxTrackImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)
                                                                 resizingMode:UIImageResizingModeTile]
                          forState:UIControlStateNormal];
    }
}

- (void)setThumbImage:(UIImage *)aThumbImage
{
    if(thumbImage != aThumbImage){
        [thumbImage release];
        thumbImage = nil;
        thumbImage = [aThumbImage retain];
    }
    
    if(NO == CGSizeEqualToSize(CGSizeZero, thumbSize)){
        [self setThumbImage:[SliderUtils convertImageToImage:thumbImage size:thumbSize] forState:UIControlStateNormal];
        [self setThumbImage:[SliderUtils convertImageToImage:thumbImage size:thumbSize] forState:UIControlStateHighlighted];
    }
}

- (void)setMinimumTrackImage:(UIImage *)aMinimumTrackImage
{
    if( minimumTrackImage != aMinimumTrackImage){
        [minimumTrackImage release];
        minimumTrackImage = nil;
        minimumTrackImage = [aMinimumTrackImage retain];
    }
    
    if(nil != minimumTrackImage){
        UIImage* minTrackImage = [SliderUtils convertImageToImage:minimumTrackImage size:self.bounds.size];
        [self setMinimumTrackImage:[minTrackImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)
                                                                     resizingMode:UIImageResizingModeTile]
                          forState:UIControlStateNormal];
    }
}

- (void)setMaximumTrackImage:(UIImage *)aMaximumTrackImage
{
    if(maximumTrackImage != aMaximumTrackImage){
        [maximumTrackImage release];
        maximumTrackImage = nil;
        maximumTrackImage = [aMaximumTrackImage retain];
    }
    
    if(nil != maximumTrackImage){
        UIImage* maxTrackImage = [SliderUtils convertImageToImage:maximumTrackImage size:self.bounds.size];
        [self setMaximumTrackImage:[maxTrackImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)
                                                                 resizingMode:UIImageResizingModeTile]
                          forState:UIControlStateNormal];
    }
}

@end


@implementation MidSlider
@synthesize sliderControl, progressView;

- (void)dealloc
{
    [sliderControl release];
    [progressView release];
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // ===
        progressView = [[ProgressView alloc] initWithFrame:self.bounds];
        progressView.backgroundColor = [UIColor clearColor];
        [self addSubview:progressView];
        
        // ===
        sliderControl = [[Slider alloc] initWithFrame:self.bounds];
        sliderControl.backgroundColor = [UIColor clearColor];
        sliderControl.maximumTrackColor = [UIColor clearColor];
        [self addSubview:sliderControl];
    }
    return self;
}

@end

@implementation ComboSlider
@synthesize thumbSize;
@synthesize thumbColor, minimumTrackColor, maximumTrackColor, midimumTrackColor;
@synthesize thumbImage, minimumTrackImage, maximumTrackImage, midimumTrackImage;
@synthesize midSlider;
@synthesize resourceTitleLabel;
@synthesize resourceItemButton, rightItemButton;
@synthesize minimumValueLabel, maximumValueLabel, resetValueLabel, historyValueLabel, currentValueLabel;
@synthesize minimumMarkView, maximumMarkView, resetMarkView, historyMarkView;
@synthesize comboSliderId, minimumValue, maximumValue, currentValue, resetValue, historyValue;
@synthesize activeStep, negtiveStep;
@synthesize resetMarkImage, historyMarkImage;
@synthesize showMinimumValue, showMaximumValue, showCurrentValue, showChangeValue, showResetValue, showHistoryValue;
@synthesize showRightItemButton, showResourceItemButton;
@synthesize showComboSliderThumb;
@synthesize comboSliderSelected;

- (void)dealloc
{
    [resourceTitleLabel release];
    
    [resourceItemButton release];
    [rightItemButton release];
    
    [minimumValueLabel release];
    [maximumValueLabel release];
    [resetValueLabel release];
    [historyValueLabel release];
    [currentValueLabel release];
    
    [minimumMarkView release];
    [maximumMarkView release];
    [resetMarkView release];
    [historyMarkView release];
    
    [midSlider release];
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        // init value
        minimumValue = 0.0;
        maximumValue = 1.0;
        currentValue = 0.0;
        resetValue   = 0.0;
        historyValue = 0.0;
        
        activeStep   = 1.0;
        negtiveStep  = 1.0;
        
        showMinimumValue        = YES;
        showMaximumValue        = YES;
        showCurrentValue        = YES;
        showResetValue          = YES;
        showHistoryValue        = YES;
        
        showRightItemButton     = NO;
        showResourceItemButton  = NO;
        
        showComboSliderThumb    = YES;
        comboSliderSelected     = YES;
        
        // resource title label
        resourceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, frame.size.width-20*2, 25)];
        resourceTitleLabel.backgroundColor = [UIColor clearColor];
        resourceTitleLabel.textAlignment = NSTextAlignmentLeft;
        resourceTitleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        resourceTitleLabel.numberOfLines = 1;
        resourceTitleLabel.font = [UIFont systemFontOfSize:15];
        resourceTitleLabel.textColor = [UIColor whiteColor];
        resourceTitleLabel.adjustsFontSizeToFitWidth = YES;
        resourceTitleLabel.text = @"N/A";
        [self addSubview:resourceTitleLabel];
        
        // midslider
        midSlider = [[MidSlider alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(resourceTitleLabel.frame)+20, frame.size.width-20*2, 12)];
        midSlider.backgroundColor = [UIColor clearColor];
        [midSlider.sliderControl addTarget:self action:@selector(onSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [midSlider.sliderControl addTarget:self action:@selector(onSliderTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [midSlider.sliderControl addTarget:self action:@selector(onSliderTouchUpInside:) forControlEvents:UIControlEventTouchCancel];
        [self addSubview:midSlider];
        
        // current value label
        currentValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
        currentValueLabel.center = CGPointMake(CGRectGetMinX(midSlider.frame), (currentValueLabel.bounds.size.height/4.0)+CGRectGetMaxY(resourceTitleLabel.frame));
        currentValueLabel.backgroundColor = [UIColor clearColor];
        currentValueLabel.textAlignment = NSTextAlignmentCenter;
        currentValueLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        currentValueLabel.numberOfLines = 1;
        currentValueLabel.font = [UIFont systemFontOfSize:20];
        currentValueLabel.textColor = [UIColor whiteColor];
        currentValueLabel.adjustsFontSizeToFitWidth = YES;
        currentValueLabel.text = @"0";
        [self insertSubview:currentValueLabel belowSubview:midSlider];
        
        // min mark
        minimumMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(midSlider.frame)+3, CGRectGetMaxY(midSlider.frame)+3, 1, 4)];
        minimumMarkView.backgroundColor = [UIColor whiteColor];
        [self insertSubview:minimumMarkView belowSubview:midSlider];
        
        // min value label
        minimumValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 8)];
        minimumValueLabel.center = CGPointMake(CGRectGetMaxX(minimumMarkView.frame), CGRectGetMaxY(minimumMarkView.frame)+8);
        minimumValueLabel.backgroundColor = [UIColor clearColor];
        minimumValueLabel.textAlignment = NSTextAlignmentCenter;
        minimumValueLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        minimumValueLabel.numberOfLines = 1;
        minimumValueLabel.font = [UIFont systemFontOfSize:8];
        minimumValueLabel.textColor = [UIColor whiteColor];
        minimumValueLabel.adjustsFontSizeToFitWidth = YES;
        minimumValueLabel.text = @"0";
        [self insertSubview:minimumValueLabel belowSubview:midSlider];
        
        // max mark
        maximumMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(midSlider.frame)-3, CGRectGetMaxY(midSlider.frame)+3, 1, 4)];
        maximumMarkView.backgroundColor = [UIColor whiteColor];
        [self insertSubview:maximumMarkView belowSubview:midSlider];
        
        // max value label
        maximumValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 8)];
        maximumValueLabel.center = CGPointMake(CGRectGetMaxX(maximumMarkView.frame), CGRectGetMaxY(maximumMarkView.frame)+8);
        maximumValueLabel.backgroundColor = [UIColor clearColor];
        maximumValueLabel.textAlignment = NSTextAlignmentCenter;
        maximumValueLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        maximumValueLabel.numberOfLines = 1;
        maximumValueLabel.font = [UIFont systemFontOfSize:8];
        maximumValueLabel.textColor = [UIColor whiteColor];
        maximumValueLabel.adjustsFontSizeToFitWidth = YES;
        maximumValueLabel.text = @"0";
        [self insertSubview:maximumValueLabel belowSubview:midSlider];
        
        // reset mark
        resetMarkView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(midSlider.frame), CGRectGetMaxY(midSlider.frame)+3, 1, 4)];
        resetMarkView.backgroundColor = [UIColor whiteColor];
        [self insertSubview:resetMarkView belowSubview:midSlider];
        
        // reset value label
        resetValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 8)];
        resetValueLabel.center = CGPointMake(CGRectGetMaxX(resetMarkView.frame), CGRectGetMaxY(resetMarkView.frame)+8);
        resetValueLabel.backgroundColor = [UIColor clearColor];
        resetValueLabel.textAlignment = NSTextAlignmentCenter;
        resetValueLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        resetValueLabel.numberOfLines = 1;
        resetValueLabel.font = [UIFont systemFontOfSize:8];
        resetValueLabel.textColor = [UIColor whiteColor];
        resetValueLabel.adjustsFontSizeToFitWidth = YES;
        resetValueLabel.text = @"0";
        [self insertSubview:resetValueLabel belowSubview:midSlider];
        
        // history mark
        historyMarkView = [[UIImageView alloc] initWithFrame:resetMarkView.frame];
        historyMarkView.backgroundColor = [UIColor whiteColor];
        [self insertSubview:historyMarkView belowSubview:midSlider];
        
        // history value label
        historyValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 8)];
        historyValueLabel.center = resetValueLabel.center;
        historyValueLabel.backgroundColor = [UIColor clearColor];
        historyValueLabel.textAlignment = NSTextAlignmentCenter;
        historyValueLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        historyValueLabel.numberOfLines = 1;
        historyValueLabel.font = [UIFont systemFontOfSize:8];
        historyValueLabel.textColor = [UIColor whiteColor];
        historyValueLabel.adjustsFontSizeToFitWidth = YES;
        historyValueLabel.text = @"0";
        [self insertSubview:historyValueLabel belowSubview:midSlider];
        
        // right Item Button
        rightItemButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-20-25, 0, 25, 25)];
        rightItemButton.backgroundColor = [UIColor clearColor];
        [self addSubview:rightItemButton];
        rightItemButton.hidden = NO;
        
        // resource  Item Button
        resourceItemButton = [[UIButton alloc] initWithFrame:self.bounds];
        resourceItemButton.backgroundColor = [UIColor clearColor];
        [self addSubview:resourceItemButton];
        resourceItemButton.hidden = YES;
        
    }
    return self;
}

#pragma mark ===事件响应===
- (void)onSliderValueChanged:(id)sender
{
    float value = midSlider.sliderControl.value;
    float scale = (maximumValue-minimumValue) == 0.0 ? 1.0 : (maximumValue-minimumValue);
    float currentx = (value-minimumValue)*1.0/scale*CGRectGetWidth(midSlider.frame)+CGRectGetMinX(midSlider.frame);
    CGPoint currentLabelCenterPoint = currentValueLabel.center;
    currentLabelCenterPoint.x = currentx;
    currentValueLabel.center = currentLabelCenterPoint;
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)onSliderTouchUpInside:(id)sender
{
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

#pragma mark ===数据===
- (void)setMinimumValue:(float)aMinimumValue
{
    minimumValue = aMinimumValue;
    
    midSlider.sliderControl.minimumValue = aMinimumValue;
}

- (void)setMaximumValue:(float)aMaximumValue
{
    maximumValue = aMaximumValue;
    
    midSlider.sliderControl.maximumValue = aMaximumValue;
}

- (void)setCurrentValue:(float)aCurrentValue
{
    [self setCurrentValue:aCurrentValue animated:NO];
}

- (void)setCurrentValue:(float)aCurrentValue animated:(BOOL)animated
{
    currentValue = aCurrentValue;
    [midSlider.sliderControl setValue:aCurrentValue animated:animated];
    
    float scale = (maximumValue-minimumValue) == 0.0 ? 1.0 : (maximumValue-minimumValue);
    float currentx = (aCurrentValue-minimumValue)*1.0/scale*CGRectGetWidth(midSlider.frame)+CGRectGetMinX(midSlider.frame);
    CGPoint currentCenterPoint = currentValueLabel.center;
    currentCenterPoint.x = currentx;
    
    if(animated){
        [UIView animateWithDuration:0.5 animations:^{
            currentValueLabel.center = currentCenterPoint;
        }];
    }else{
        currentValueLabel.center = currentCenterPoint;
    }
}

- (void)setResetValue:(float)aResetValue
{
    resetValue = aResetValue;
    
    float scale = (maximumValue-minimumValue) == 0.0 ? 1.0 : (maximumValue-minimumValue);
    float resetx = (resetValue-minimumValue)*1.0/scale*CGRectGetWidth(midSlider.frame)+CGRectGetMinX(midSlider.frame);
    CGPoint resetLabelCenterPoint = resetValueLabel.center;
    resetLabelCenterPoint.x = resetx;
    resetValueLabel.center = resetLabelCenterPoint;
    
    CGPoint resetMarkCenterPoint = resetMarkView.center;
    resetMarkCenterPoint.x = resetx;
    resetMarkView.center = resetMarkCenterPoint;
    
    float reset = (resetValue-minimumValue)*1.0/scale;
    midSlider.progressView.progress = reset;
}

- (void)setHistoryValue:(float)aHistoryValue
{
    historyValue = aHistoryValue;
    float scale = (maximumValue-minimumValue) == 0.0 ? 1.0 : (maximumValue-minimumValue);
    float historyx = (historyValue-minimumValue)*1.0/scale*CGRectGetWidth(midSlider.frame)+CGRectGetMinX(midSlider.frame);
    CGPoint historyLabelCenterPoint = historyValueLabel.center;
    historyLabelCenterPoint.x = historyx;
    historyValueLabel.center = historyLabelCenterPoint;
    
    CGPoint historyMarkCenterPoint = historyMarkView.center;
    historyMarkCenterPoint.x = historyx;
    historyMarkView.center = historyMarkCenterPoint;
}

- (void)setActiveStep:(float)aActiveStep
{
    if(0 < aActiveStep){
        activeStep = aActiveStep;
    }
}

- (void)setNegtiveStep:(float)aNegtiveStep
{
    if(0 < aNegtiveStep){
        negtiveStep = aNegtiveStep;
    }
}

#pragma mark ===显示===
- (void)setResetMarkImage:(UIImage *)aResetMarkImage
{
    if(nil != aResetMarkImage){
        resetMarkImage = aResetMarkImage;
        
        CGPoint oldCenter = resetMarkView.center;
        CGRect  oldRect   = resetMarkView.frame;
        if(aResetMarkImage.size.height > oldRect.size.height){
            oldCenter.y -= aResetMarkImage.size.height - oldRect.size.height;
        }
        oldRect.size.width =  aResetMarkImage.size.width;
        oldRect.size.height = aResetMarkImage.size.height;
        resetMarkView.frame = oldRect;
        resetMarkView.center = oldCenter;
        resetMarkView.image = aResetMarkImage;
        resetMarkView.backgroundColor = [UIColor clearColor];
    }
}

- (void)setHistoryMarkImage:(UIImage *)aHistoryMarkImage
{
    if(nil != aHistoryMarkImage){
        historyMarkImage = aHistoryMarkImage;
        
        CGPoint oldCenter = historyMarkView.center;
        CGRect  oldRect   = historyMarkView.frame;
        if(aHistoryMarkImage.size.height > oldRect.size.height){
             oldCenter.y -= aHistoryMarkImage.size.height - oldRect.size.height;
        }
        oldRect.size.width =  aHistoryMarkImage.size.width;
        oldRect.size.height = aHistoryMarkImage.size.height;
        historyMarkView.frame = oldRect;
        historyMarkView.center = oldCenter;
        historyMarkView.image = aHistoryMarkImage;
        historyMarkView.backgroundColor = [UIColor clearColor];
    }
}

- (void)setShowMinimumValue:(BOOL)aShowMinimumValue
{
    showMinimumValue = aShowMinimumValue;
    
    minimumValueLabel.hidden = !aShowMinimumValue;
    minimumMarkView.hidden   = !aShowMinimumValue;
}

- (void)setShowMaximumValue:(BOOL)aShowMaximumValue
{
    showMaximumValue = aShowMaximumValue;
    
    maximumValueLabel.hidden = !aShowMaximumValue;
    maximumMarkView.hidden   = !aShowMaximumValue;
}

- (void)setShowCurrentValue:(BOOL)aShowCurrentValue
{
    showCurrentValue = aShowCurrentValue;
    
    currentValueLabel.hidden = !aShowCurrentValue;
}

- (void)setShowChangeValue:(BOOL)aShowChangeValue
{
    showChangeValue = aShowChangeValue;
}

- (void)setShowResetValue:(BOOL)aShowResetValue
{
    showResetValue = aShowResetValue;
    
    resetValueLabel.hidden = !aShowResetValue;
    resetMarkView.hidden   = !aShowResetValue;
}

- (void)setShowHistoryValue:(BOOL)aShowHistoryValue
{
    showHistoryValue = aShowHistoryValue;
    
    historyValueLabel.hidden = !aShowHistoryValue;
    historyMarkView.hidden   = !aShowHistoryValue;
}

- (void)setShowRightItemButton:(BOOL)aShowRightItemButton
{
    showRightItemButton = aShowRightItemButton;
    
    rightItemButton.hidden = !aShowRightItemButton;
}

- (void)setShowResourceItemButton:(BOOL)aShowResourceItemButton
{
    showResourceItemButton = aShowResourceItemButton;
    
    resourceItemButton.hidden = !aShowResourceItemButton;
}

- (void)setShowComboSliderThumb:(BOOL)aShowComboSliderThumb
{
    showComboSliderThumb = aShowComboSliderThumb;
    
    midSlider.sliderControl.hidden = !aShowComboSliderThumb;
}

- (void)setComboSliderSelected:(BOOL)aComboSliderSelected
{
    comboSliderSelected = aComboSliderSelected;
    
    rightItemButton.selected = aComboSliderSelected;
    
    self.showResourceItemButton = !aComboSliderSelected;
}

#pragma mark ===样式====
- (void)setThumbSize:(CGSize)aThumbSize
{
    thumbSize = aThumbSize;
    
    midSlider.sliderControl.thumbSize = aThumbSize;
}

- (void)setThumbColor:(UIColor *)aThumbColor
{
    thumbColor = aThumbColor;
    
    midSlider.sliderControl.thumbColor = aThumbColor;
}

- (void)setMinimumTrackColor:(UIColor *)aMinimumTrackColor
{
    minimumTrackColor = aMinimumTrackColor;
    
    midSlider.sliderControl.minimumTrackColor = aMinimumTrackColor;
}

- (void)setMaximumTrackColor:(UIColor *)aMaximumTrackColor
{
    maximumTrackColor = aMaximumTrackColor;
    
    midSlider.progressView.trackColor = aMaximumTrackColor;
}

- (void)setMidimumTrackColor:(UIColor *)aMidimumTrackColor
{
    midimumTrackColor = aMidimumTrackColor;
    
    midSlider.progressView.progressColor = aMidimumTrackColor;
}

- (void)setThumbImage:(UIImage *)aThumbImage
{
    thumbImage = aThumbImage;
    
    midSlider.sliderControl.thumbImage = aThumbImage;
 }

- (void)setMinimumTrackImage:(UIImage *)aMinimumTrackImage
{
    minimumTrackImage = aMinimumTrackImage;
    
    midSlider.sliderControl.minimumTrackImage = aMinimumTrackImage;
}

- (void)setMaximumTrackImage:(UIImage *)aMaximumTrackImage
{
    maximumTrackImage = aMaximumTrackImage;
    
    midSlider.progressView.trackImage = aMaximumTrackImage;
}

- (void)setMidimumTrackImage:(UIImage *)aMidimumTrackImage
{
    midimumTrackImage = aMidimumTrackImage;
    
    midSlider.progressView.progressImage = aMidimumTrackImage;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"ad");
}

@end
