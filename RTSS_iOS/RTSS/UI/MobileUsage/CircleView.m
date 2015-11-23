//
//  CircleView.m
//  EasyTT
//
//  Created by 蔡杰 on 14-10-22.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import "CircleView.h"

#import "CircleProgressView.h"
#import "RTSSAppStyle.h"

#define ETTCircleEdge 5


@interface CircleView ()
{
    CircleProgressView *circleProgress;
    
    UILabel *markLabel;//height = 20
    
    CGFloat lineWid;
}

@property(nonatomic,retain)UIButton *tapButton;
@end

@implementation CircleView

-(instancetype)initWithFrame:(CGRect)frame line:(CGFloat)lineWidth{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self installCircleViewWithLineWidth:lineWidth];
        lineWid= lineWidth;
    }
    
    return self;

}

-(void)installCircleViewWithLineWidth:(CGFloat)lineWidth{
    
    circleProgress = [[CircleProgressView alloc]initWithFrame:CGRectMake(ETTCircleEdge-5, ETTCircleEdge-5, self.bounds.size.width-ETTCircleEdge*2 + 10, self.bounds.size.width-ETTCircleEdge*2 + 10) line:lineWidth];
    [self addSubview:circleProgress];
    
    markLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width/2-35, CGRectGetMaxY(circleProgress.frame), 70, 35)];
    markLabel.textAlignment = NSTextAlignmentCenter;
    markLabel.font = [RTSSAppStyle getRTSSFontWithSize:10.f];
    markLabel.adjustsFontSizeToFitWidth = YES;
    markLabel.numberOfLines = 0;
    markLabel.lineBreakMode = NSLineBreakByWordWrapping;
    markLabel.text =@"Data";
//    markLabel.backgroundColor = [UIColor redColor];
    [self addSubview:markLabel];
}

-(void)setMarkText:(NSString *)aMark{
       markLabel.text = aMark;
}
-(void)updateDataLeft:(NSString *)aLeft Total:(NSString *)aTotal Unit:(NSString *)aUnit Color:(UIColor *)aColor{
    
    if (lineWid <=0) {
        [circleProgress setRemainingAmount:aLeft total:aTotal Unit:aUnit Color:aColor];
        [circleProgress setProgressColor:aColor];
        //[circleProgress setProgress:0 animated:YES];
        [circleProgress.allroundView setAllBgViewColor:aColor];
        markLabel.textColor = aColor;
        return;
    }
    
    //CGFloat proportion = [aLeft floatValue] / [aTotal floatValue];
    [circleProgress setRemainingAmount:aLeft total:aTotal Unit:aUnit Color:aColor];
   // [circleProgress setProgressColor:aColor];
     markLabel.textColor = aColor;
}
- (void)setProgress:(CGFloat)aProgress duration:(CGFloat)aDuration animated:(BOOL)animated;{
    
    [circleProgress setProgress:aProgress duration:aDuration animated:animated];
}

-(void)addTarget:(id)aTarget Action:(SEL)aSel{
    [circleProgress.circleButton addTarget:aTarget action:aSel forControlEvents:UIControlEventTouchUpInside];
}
-(void)setAllBgViewColor:(UIColor*)aColor{
    
    [circleProgress.allroundView setAllBgViewColor:aColor];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
