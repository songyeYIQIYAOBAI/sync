//
//  MobileUsageView.m
//  RTSS
//
//  Created by tiger on 14-11-28.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "MobileUsageView.h"
#import "CircleView.h"
#import "SwitchView.h"
#import "RTSSAppStyle.h"
#import "CommonUtils.h"
#import "MobileUsageModel.h"
#import "SKBounceAnimation.h"
#import "CircleViewItem.h"
#import  "RTSSAppDefine.h"

#define SWITCH_DIAMETER       110   //125
#define SWITCH_HEIGHT         130   //150
#define CIRCLE_HEIGH          90
#define CIRCLE_WIDTH          90

@interface MobileUsageView()
{
    NSMutableArray * frameArray;
    NSMutableArray * circleArray;
}
@end

@implementation MobileUsageView
@synthesize switchView, actionBtn;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //生成切换按钮
        switchView = [[SwitchView alloc]initWithFrame:CGRectMake((frame.size.width-SWITCH_DIAMETER)/2, (frame.size.height-SWITCH_DIAMETER)/2, SWITCH_DIAMETER, SWITCH_HEIGHT)];
        switchView.backgroundColor = [UIColor clearColor];
        [self addSubview:switchView];
        
        //初始化数组
        [self initObject];
    }
    return self;
}

-(void)initObject
{
    frameArray =  [[NSMutableArray alloc]init];

    //第一个圆位置
    CGFloat x1 = 0;
    CGFloat y1 = 0;
    if (PHONE_UISCREEN_IPHONE6) {
        
        x1 = 20;
        y1 = 80;
    }else if (PHONE_UISCREEN_IPHONE6PLUS){
        
        x1 = 50;
        y1 = 100;
        
    }
    CGPoint point = CGPointMake(180+x1,60+y1);//50, 50 浅绿--210,70  //180,60 up
    [frameArray addObject:[NSValue value:&point withObjCType:@encode(struct CGPoint)]];
    //第二个圆位置
    CGFloat x2 = 0;
    CGFloat y2 = 0;
    if (PHONE_UISCREEN_IPHONE6) {
        x2 = 15;
        y2 = 95;
    }else if (PHONE_UISCREEN_IPHONE6PLUS){
        
        x2 =35;
        y2 = 145;
    }
    point = CGPointMake(53+x2,250+y2);//10,160 lan --53,250
    [frameArray addObject:[NSValue value:&point withObjCType:@encode(struct CGPoint)]];
    //第三个圆位置
    CGFloat x3 = 0;
    CGFloat y3 = 0;
    if (PHONE_UISCREEN_IPHONE6) {
        x3 = 35;
        y3 = 70;
    }else if (PHONE_UISCREEN_IPHONE6PLUS){
        
        x3 = 75;
        y3 = 90;
    }
    point = CGPointMake(265+x3,155+y3);//230,105 橙色 -- 265,155   up
    [frameArray addObject:[NSValue value:&point withObjCType:@encode(struct CGPoint)]];
    //第四个圆位置
    CGFloat x4 = 0;
    CGFloat y4 = 0;
    if (PHONE_UISCREEN_IPHONE6) {
        x4 = 25;
        y4 = 90;
    }else if (PHONE_UISCREEN_IPHONE6PLUS){
        
        x4 = 45;
        y4 = 130;
    }
    point = CGPointMake(50+x4,80+y4);//35,20 深绿  ---85,80   --55,80   up
    [frameArray addObject:[NSValue value:&point withObjCType:@encode(struct CGPoint)]];
    //第五个圆位置
    CGFloat x5 = 0;
    CGFloat y5 = 0;
    
    if (PHONE_UISCREEN_IPHONE5) {
        y5 = 50;
    }else if (PHONE_UISCREEN_IPHONE6) {
        x5 = 25;
        y5 = 100;
    }else if (PHONE_UISCREEN_IPHONE6PLUS){
        
        x5 = 55;
        y5 = 155;
    }
    point = CGPointMake(140+x5,340+y5);//60,310 黄色  ---120,340
    [frameArray addObject:[NSValue value:&point withObjCType:@encode(struct CGPoint)]];
    //第六个圆位置
    CGFloat x6 = 0;
    CGFloat y6 = 0;
    if (PHONE_UISCREEN_IPHONE5) {
        y6 = 20;
    }else if (PHONE_UISCREEN_IPHONE6) {
        x6 = 45;
        y6 = 110;
    }else if (PHONE_UISCREEN_IPHONE6PLUS){
        
        x6 = 85;
        y6 = 140;
    }
    point = CGPointMake(250+x6,320+y6);//205,255 more  --250,320
    [frameArray addObject:[NSValue value:&point withObjCType:@encode(struct CGPoint)]];
    
    circleArray = [[NSMutableArray alloc]init];
}


-(void)dealloc
{
    [actionBtn release];
    [switchView release];
    [frameArray release];
    [circleArray release];
    [super dealloc];
}

-(void)loadDataAndInitCircleView:(NSMutableArray *)array
{
    if (array == nil) {
        return;
    }
    MobileUsageModel * model = nil;
    
    //示图中心点
    CGPoint centerPoint = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    if(array.count <=6)
    {
        for (int index = 0; index < array.count; index++) {
            //数据模型
            model = (MobileUsageModel *)[array objectAtIndex:index];
            
            CircleViewItem * itemView = [[CircleViewItem alloc]initWithFrame:CGRectMake(0, 0, CIRCLE_WIDTH, CIRCLE_HEIGH)];
            itemView.iteType = ItemViewCircleType;
            //初始化圆圈
            [itemView.circle updateDataLeft:[NSString stringWithFormat:@"%lld", model.remain] Total:[NSString stringWithFormat:@"%lld %@", model.total, model.unitForTotal] Unit:[NSString stringWithFormat:@"%@ left", model.unitForRemain] Color:model.color];
            [itemView.circle setProgress:(CGFloat)model.remain/model.total  duration:1.5f animated:YES];
            [itemView.circle setMarkText:model.title];
            [circleArray addObject:itemView];
            //中心点
            itemView.center = centerPoint;
            [self insertSubview:itemView belowSubview:switchView];
            
            [itemView release];
        }
    }else{
        for (int index = 0; index < 5; index++) {
            //数据模型
            model = (MobileUsageModel *)[array objectAtIndex:index];
            
            CircleViewItem * itemView = [[CircleViewItem alloc]initWithFrame:CGRectMake(0, 0, CIRCLE_WIDTH, CIRCLE_HEIGH)];
            itemView.iteType = ItemViewCircleType;
            //初始化圆圈
            [itemView.circle updateDataLeft:[NSString stringWithFormat:@"%lld", model.remain] Total:[NSString stringWithFormat:@"%lld %@", model.total, model.unitForTotal] Unit:[NSString stringWithFormat:@"%@ %@", model.unitForRemain,NSLocalizedString(@"MoBileUsage_Detail_Left", nil)] Color:model.color];
            NSLog(@"remai =%lld,tatal=%lld---%lld",model.remain,model.total,model.remain/model.total);
            [itemView.circle setProgress:(CGFloat)model.remain/model.total  duration:1.5f animated:YES];
            [itemView.circle setMarkText:model.title];
            [circleArray addObject:itemView];
            
            //中心点
            itemView.center = centerPoint;
            [self insertSubview:itemView belowSubview:switchView];
            
            [itemView release];
        }
        
        //添加更多按钮
        CircleViewItem * itemView = [[CircleViewItem alloc]initWithFrame:CGRectMake(0, 0, CIRCLE_WIDTH, CIRCLE_HEIGH)];
        itemView.iteType = ItemViewButtonType;
        itemView.center = centerPoint;
        [circleArray addObject:itemView];
        actionBtn = [itemView retain];
        [self insertSubview:itemView belowSubview:switchView];
        
        [itemView release];
    }
}

-(BOOL)removeAllCircleFromSupperView
{
    for (CircleView *circle in circleArray) {
        [circle removeFromSuperview];
    }
    [circleArray removeAllObjects];
    return  YES;
}

-(NSMutableArray *)getAllCircleViewWithPoint:(CGPoint)point
{
    CircleView * circle = nil;
    for (int index = 0; index < circleArray.count; index++) {
        
        circle = [circleArray objectAtIndex:index];
        circle.center = point;
    }
    
    return circleArray;
}

-(NSMutableArray *)LayoutCircleToAssignPosition
{
    for (int index = 0; index < circleArray.count; index++) {
        //获得坐标
        struct CGPoint point;
        [[frameArray objectAtIndex:index] getValue:&point];
        
        CircleViewItem * itemView = [circleArray objectAtIndex:index];
        
        [itemView openfromPoint:switchView.center to:point withDuration:1.2];
        //circle.center = point;
    }
    
    return circleArray;
}

#pragma mark - 动画操作
-(void)openCircleAnimation:(BOOL)anima completion:(void (^)(BOOL finished))openCircleFinished
{
    [self LayoutCircleToAssignPosition];
    
     if (openCircleFinished != nil) {
         openCircleFinished(YES);
     }
}

-(void)shrinkCircleAnimation:(BOOL)animation completion:(void (^)(BOOL finished))shrinkCircleFinished
{
    NSLog(@"收缩-shrinkCircleAnimation");
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         NSLog(@"收缩动画");
                         // Compute buttons' frame and set for them, based on |buttonCount|
                         [self getAllCircleViewWithPoint:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)];
                     }
                     completion:^(BOOL finished) {
                         if (shrinkCircleFinished != nil) {
                            shrinkCircleFinished(YES);
                         }
                     }];
    
//    for (int index = 0; index < circleArray.count; index++) {
//        //获得坐标
//        struct CGPoint point;
//        [[frameArray objectAtIndex:index] getValue:&point];
//        
//        CircleViewItem * itemView = [circleArray objectAtIndex:index];
//        
//        [itemView closefromPoint:point to:switchView.center withDuration:1.2];
//    }
//    
//     if (shrinkCircleFinished != nil) {
//        shrinkCircleFinished(YES);
//     }
}

@end
