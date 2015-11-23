//
//  UnlockView.h
//  graphUnlockCodeDemo
//
//  Created by tiger on 14-8-22.
//  Copyright (c) 2014年 tiger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PatternUnlockView;

struct BrushColor
{
    float red;
    float green;
    float blue;
    float alpha;
};

@protocol UnLockViewDelegate <NSObject>
//自定义一个协议
//协议方法，把当前视图作为参数
-(BOOL)LockViewDidClick:(PatternUnlockView *)lockView andPwd:(NSString *)pwd;
-(void)drawPatternHandPath:(NSMutableArray *)tags isFinished:(BOOL)on;
@end

@interface PatternUnlockView : UIView
{
    NSMutableArray * buttons;
    NSMutableArray * selectedTagsArray;
    CGPoint currentPoint;
    struct BrushColor lineColor;
    BOOL isDrawing;
    BOOL isFisrtDrawPath;
}
 //代理
@property(nonatomic,assign)id<UnLockViewDelegate>delegate;

@end
