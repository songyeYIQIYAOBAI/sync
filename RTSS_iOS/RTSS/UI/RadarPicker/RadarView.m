//
//  RadarView.m
//  RTSS
//
//  Created by shengyp on 14/10/28.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "RadarView.h"
#import "PortraitImageView.h"

#import "CommonUtils.h"
#import "RTSSAppStyle.h"

#import "User.h"

@implementation ERadarItemView
@synthesize itemImageView,itemButton,itemLabel,itemUser,itemSN,itemInfo;

- (void)dealloc
{
    [itemImageView release];
    [itemButton release];
    [itemSN release];
    [itemUser release];
    [itemInfo release];
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutContent];
    }
    return self;
}

- (void)layoutContent
{
    CGFloat imageWidth = MIN(self.bounds.size.width, self.bounds.size.height-10);
    itemImageView = [[PortraitImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width-imageWidth)/2.0, 0, imageWidth, imageWidth) image:nil borderColor:[RTSSAppStyle currentAppStyle].portraitBorderColor borderWidth:1];
    [self addSubview:itemImageView];
    [self unSelectItem];
    
    itemButton = [[UIButton alloc] initWithFrame:self.bounds];
    itemButton.backgroundColor = [UIColor clearColor];
    itemButton.selected = NO;
    itemButton.exclusiveTouch = YES;
    [self addSubview:itemButton];
    
    itemLabel = [CommonUtils labelWithFrame:CGRectMake(0, self.bounds.size.height-10, self.bounds.size.width, 10)
                                       text:@""
                                  textColor:[RTSSAppStyle currentAppStyle].textMajorColor
                                   textFont:[RTSSAppStyle getRTSSFontWithSize:10.0]
                                        tag:0];
    itemLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:itemLabel];
}

- (void)selectItem
{
    itemButton.selected = YES;
    itemImageView.layer.borderWidth = 3.0;
    itemImageView.layer.borderColor = [RTSSAppStyle currentAppStyle].radarSelectedItemColor.CGColor;
}

- (void)unSelectItem
{
    itemButton.selected = NO;
    itemImageView.layer.borderWidth = 2.0;
    itemImageView.layer.borderColor = [RTSSAppStyle currentAppStyle].radarUnSelectedItemColor.CGColor;
}

- (void)jumpItem
{
    [UIView animateWithDuration:0.4
                     animations:^{
                         [self setTransform:CGAffineTransformScale(self.transform, 1.2, 1.2)];
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.4
                                          animations:^{
                                              CGAffineTransform t2 = CGAffineTransformInvert(self.transform);
                                              [self setTransform:CGAffineTransformConcat(self.transform, t2)];
                                          }
                                          completion:^(BOOL finished) {
                                              
                                          }];
                     }];
}

@end

@interface RadarView(){
    UIView*                 maskView;
    NSMutableDictionary*    localDictionary;
    NSMutableArray*         pointArray;
    NSInteger               maxMatrixCount;
    NSTimer*                radarTimer;
}

@end

@implementation RadarView
@synthesize radarSize, scaleSize,radarBgColor,centerItemView;

- (void)dealloc{
    
    [maskView release];
    [localDictionary release];
    [radarBgColor release];
    [pointArray release];
    [centerItemView release];
    
    [super dealloc];
}

- (void)initMatrix
{
    NSInteger xW = 4;
    NSInteger yH = 4;
    
    CGFloat itemWidth  = self.bounds.size.width/xW;
    CGFloat itemHeight = self.bounds.size.height/yH;
    
    maxMatrixCount = xW * yH;
    
    pointArray = [[NSMutableArray alloc] initWithCapacity:maxMatrixCount];
    
    for (int i = 0; i < yH; i ++) {
        for (int j = 0; j < xW; j ++) {
            UIView* view = [[UIView alloc] initWithFrame:CGRectMake(j*itemWidth, i*itemHeight, itemWidth, itemHeight)];
            view.backgroundColor = [UIColor clearColor];
            [pointArray addObject:view];
            [view release];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // ===
        maskView = [[UIView alloc] initWithFrame:self.bounds];
        maskView.backgroundColor = [UIColor clearColor];
        [self addSubview:maskView];
        
        // ===
        centerItemView = [[ERadarItemView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        centerItemView.backgroundColor = [UIColor clearColor];
        centerItemView.center = maskView.center;
        CGRect frameTemp = centerItemView.frame;
        frameTemp.origin.y += 5;
        centerItemView.frame = frameTemp;
        [self insertSubview:centerItemView aboveSubview:maskView];
        
        // ===
        self.radarSize = CGSizeMake(70, 70);
        self.scaleSize = CGSizeMake(9, 9);
        self.radarBgColor = [UIColor grayColor];
        
        localDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        [self initMatrix];
    }
    return self;
}

- (NSInteger)getItemViewIndex:(CGPoint)point
{
    NSInteger index = -1;
    for (int i = 0; i < [pointArray count]; i ++) {
        UIView* view = [pointArray objectAtIndex:i];
        if(YES == CGRectContainsPoint(view.frame, point)){
            index = i;
            break;
        }
    }
    
    return index;
}

- (CGPoint)getItemViewPoint:(NSInteger)index
{
    return ((UIView*)[pointArray objectAtIndex:index]).center;
}

- (CGPoint)getItemViewCenterPoint:(ERadarItemView*)itemView
{
    CGPoint point = CGPointMake(0, 0);
    
    NSInteger number = arc4random() % maxMatrixCount;
    
    ERadarItemView* itemViewTemp = [localDictionary objectForKey:[NSNumber numberWithInteger:number]];
    
    CGRect centerRect = CGRectMake((self.bounds.size.width-self.radarSize.width*3.0)/2.0, (self.bounds.size.height-self.radarSize.height*3.0)/2.0, self.radarSize.width*3.0, self.radarSize.height*3.0);
    if(nil != itemViewTemp || CGRectContainsPoint(centerRect, [self getItemViewPoint:number])){
        point = [self getItemViewCenterPoint:itemView];
    }else {
        point = [self getItemViewPoint:number];
        [localDictionary setObject:itemView forKey:[NSNumber numberWithInteger:number]];
    }
    
    return point;
}

- (void)addRadarItemView:(ERadarItemView*)itemView
{
    itemView.center = [self getItemViewCenterPoint:itemView];
    [maskView addSubview:itemView];
    [itemView jumpItem];
}

- (void)addRadarItemsView:(NSArray*)itemsView
{
    for (ERadarItemView* view in itemsView) {
        [self addRadarItemView:view];
    }
}

- (void)removeRadarItemView:(ERadarItemView*)itemView
{
    NSInteger index = [self getItemViewIndex:itemView.center];
    [localDictionary removeObjectForKey:[NSNumber numberWithInteger:index]];
    [itemView removeFromSuperview];
}

- (void)removeRadarItemsView
{
    for (ERadarItemView* view in [localDictionary allValues]) {
        [view removeFromSuperview];
    }
    [localDictionary removeAllObjects];
}

- (ERadarItemView*)getRadarItemViewWithSN:(NSString*)sn {
    ERadarItemView* radarItemView = nil;
    for (ERadarItemView* view in [localDictionary allValues]) {
        if([view.itemSN isEqualToString:sn]){
            radarItemView = view;
            break;
        }
    }
    return radarItemView;
}

- (void)refreshRadar:(NSTimer*)timer
{
    CGPoint centerPoint = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    UIView* radar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.radarSize.width, self.radarSize.height)];
    radar.center = centerPoint;
    radar.layer.cornerRadius = self.radarSize.width/2.0;
    radar.backgroundColor = self.radarBgColor;
    [self insertSubview:radar belowSubview:maskView];
    [self scaleAnimateBegin:radar];
    [radar release];
}

- (void)scaleAnimateBegin:(UIView*)aView
{
    [UIView animateWithDuration:2.5f
                     animations:^{
                         aView.alpha = 0.0f;
                         [aView setTransform:CGAffineTransformScale(aView.transform, self.scaleSize.width, self.scaleSize.height)];
                     }
                     completion:^(BOOL finished) {
                         [aView removeFromSuperview];
                     }];
}

- (void)startRadar
{
    [self stopRadar];
    radarTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                  target:self
                                                selector:@selector(refreshRadar:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)stopRadar
{
    if(nil != radarTimer && [radarTimer isValid]){
        [radarTimer invalidate];
        radarTimer = nil;
    }
}

@end
