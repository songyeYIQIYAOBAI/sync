//
//  UnlockView.m
//  graphUnlockCodeDemo
//
//  Created by tiger on 14-8-22.
//  Copyright (c) 2014年 tiger. All rights reserved.
//

#import "PatternUnlockView.h"

@interface PatternUnlockView ()
-(void)setBrushColorRed:(float)r Green:(float)g Blue:(float)b Alpha:(float)alpha;
@end

@implementation PatternUnlockView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
     if (self=[super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

-(void)setup{
    buttons = [[NSMutableArray alloc]initWithCapacity:9];
    selectedTagsArray = [[NSMutableArray alloc]initWithCapacity:9];
    [self setBrushColorRed:152/255.0 Green:200/255.0 Blue:36/255.0 Alpha:1];
    isDrawing = NO;
    isFisrtDrawPath = YES;
    
    //1.创建9个按钮
    for (int i = 0; i<9; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //2.设置按钮的状态背景

        UIImage * normalImage = [UIImage imageNamed:@"common_gesture_unselected.png"];
        UIImage * selectedImage = [UIImage imageNamed:@"common_gesture_selected.png"];
        
        [btn setImage:normalImage forState:UIControlStateNormal];
        [btn setImage:selectedImage forState:UIControlStateSelected];
        
        //3.把按钮添加到视图中
        [self addSubview:btn];
        //4.禁止按钮的点击事件
        btn.userInteractionEnabled = NO;
        //5.设置每个按钮的tag
        btn.tag = i;
    }
}

//设置按钮的frame
-(void)layoutSubviews{
    //1.需要先调用父类的方法
    [super layoutSubviews];
    NSLog(@"self.subviews.count = %d", self.subviews.count);
    for (int i = 0; i < self.subviews.count; i++) {
        //2.取出按钮
        UIButton * btn = self.subviews[i];
        
        //3.九宫格计算每个按钮的frame
        CGFloat row = i/3;
        CGFloat loc = i%3;
        CGFloat btnW = 100;
        CGFloat btnH = 100;
        CGFloat padding = (self.frame.size.width - 3 * btnW)/4;
        NSLog(@"self.frame.size.width = %f", self.frame.size.width);
        CGFloat btnX = padding + (btnW + padding) * loc;
        CGFloat btnY = padding + (btnW + padding) * row;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}

//5.监听手指的移动

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint starPoint = [self getCurrentPoint:touches];
    UIButton * btn =  [self getCurrentBtnWithPoint:starPoint];
    
    if (btn && btn.selected != YES) {
        
        //记录当前点（不在按钮的范围内）
        currentPoint = btn.center;
        isDrawing = YES;
        
        btn.selected = YES;
        //把按钮添加到数组中
        [buttons addObject:btn];
        [selectedTagsArray addObject:[NSNumber numberWithInt:btn.tag]];
    }
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint movePoint = [self getCurrentPoint:touches];
    UIButton * btn = [self getCurrentBtnWithPoint:movePoint];
    
    //存储按钮
    //已经连过的按钮，不可再连
    if (btn && btn.selected != YES) {
        
        isDrawing = YES;
        //设置按钮的选中状态
        btn.selected = YES;
        //把按钮添加到数组中
        [buttons addObject:btn];
        [selectedTagsArray addObject:[NSNumber numberWithInt:btn.tag]];
    }
    //记录当前点（不在按钮的范围内）
    currentPoint = movePoint;
    [self setNeedsDisplay];
}

//手指离开的时候清除线条
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    isDrawing = NO;
    
    //取出用户输入的密码
    //创建一个可变的字符串，用来保存用户密码
    NSMutableString * result = [NSMutableString string];
    for (UIButton * btn in buttons) {
        [result appendFormat:@"%ld",(long)btn.tag];
    }
    
    if (result.length < 3){
        [self resetGesturesContent];
        return;
    }

    //通知代理，告知用户输入的密码.密码正解执行成功流程
    if ([self.delegate respondsToSelector:@selector(LockViewDidClick:andPwd:)]) {
        BOOL isLoginSuccess = [self.delegate LockViewDidClick:self andPwd:result];
        
        if([self.delegate respondsToSelector:@selector(drawPatternHandPath:isFinished:)])
        {
            [self.delegate drawPatternHandPath:selectedTagsArray isFinished:isFisrtDrawPath];
            isFisrtDrawPath = NO;
        }
        
        //登录成功
        if (isLoginSuccess) {
            [self resetGesturesContent];
        }else//登录失败
        {
            [self setBrushColorRed:255/255.0 Green:0 Blue:0 Alpha:1];
            [self setNeedsDisplay];
            
            [self performSelector:@selector(resetGesturesContent) withObject:nil afterDelay:0.3f];
        }
    }
}

-(void)resetGesturesContent
{
    //重置颜色
    [self setBrushColorRed:152/255.0 Green:200/255.0 Blue:36/255.0 Alpha:1];
    
    //调用该方法，它就会让数组中的每一个元素都调用setSelected:方法，并给每一个元素传递一个NO参数
    [buttons makeObjectsPerformSelector:@selector(setSelected:) withObject:@(NO)];
    
    //清空数组
    [buttons removeAllObjects];
    [selectedTagsArray removeAllObjects];
    [self setNeedsDisplay];
    //清空当前点
    currentPoint = CGPointZero;
}

//对功能点进行封装
-(CGPoint)getCurrentPoint:(NSSet * )touches{
    UITouch * touch =[touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    return point;
}

-(UIButton *)getCurrentBtnWithPoint:(CGPoint)point{
    for (UIButton * btn in self.subviews) {
        
        if (CGRectContainsPoint(CGRectInset(btn.frame, 13, 13), point)) {
            return btn;
        }
    }
    return Nil;
}

//重写drawrect:方法
-(void)drawRect:(CGRect)rect
{
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //在每次绘制前，清空上下文
    //    CGContextClearRect(ctx, rect);
    
    //绘图（线段）
    for (int i = 0; i < buttons.count; i++) {
        UIButton * btn = buttons[i];
        if (0 == i) {
            //设置起点（注意连接的是中点）
            //CGContextMoveToPoint(ctx, btn.frame.origin.x, btn.frame.origin.y);
            CGContextMoveToPoint(ctx, btn.center.x, btn.center.y);
            
        }else
        {
            //CGContextAddLineToPoint(ctx, btn.frame.origin.x, btn.frame.origin.y);
            CGContextAddLineToPoint(ctx, btn.center.x, btn.center.y);
        }
    }
    //当所有按钮的中点都连接好之后，再连接手指当前的位置
    //判断数组中是否有按钮，只有有按钮的时候才绘制
    if (buttons.count != 0 && isDrawing) {
        CGContextAddLineToPoint(ctx, currentPoint.x, currentPoint.y);
        
    }
    
    //渲染
    //设置线®条的属性
    CGContextSetLineWidth(ctx, 10);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    CGContextSetRGBStrokeColor(ctx, lineColor.red, lineColor.green, lineColor.blue, lineColor.alpha);
    
    CGContextStrokePath(ctx);
}   

-(void)dealloc
{
    [super dealloc];
    [buttons release];
    [selectedTagsArray release];
}

// primate mothod
-(void)setBrushColorRed:(float)r Green:(float)g Blue:(float)b Alpha:(float)alpha
{
    lineColor.red = r;
    lineColor.green = g;
    lineColor.blue = b;
    lineColor.alpha = alpha;
}

@end
