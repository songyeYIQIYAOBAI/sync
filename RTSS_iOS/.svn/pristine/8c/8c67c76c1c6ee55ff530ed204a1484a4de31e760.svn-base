//
//  AllRoundView.m
//  RTSS
//
//  Created by 蔡杰Alan on 14-11-28.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "AllRoundView.h"
#import "RTSSAppStyle.h"

static CGFloat const kBottomToCenterY  = 10.0f;

static CGFloat const kBottonLabelHeight = 10.0f;

static CGFloat  const kUpDownEdge  = 3.0f;

@interface AllRoundView (){
    
   // UILabel *remainLabel;
   // UILabel *describeLabel;
   // UIView  *bottomView;
   // UILabel *bottomLabel;
    
    CGFloat alineWidth;
    
}

@end

@implementation AllRoundView
@synthesize remainLabel,describeLabel,bottomLabel,bottomView;
-(void)dealloc{
    
    [bottomLabel release];
    if (bottomView) [bottomView release];
    [remainLabel release];
    [describeLabel release];
    [super dealloc];
}

-(instancetype)initWithFrame:(CGRect)frame line:(CGFloat)line{
    
    CGRect aFrame = CGRectMake(line/2, line/2, frame.size.height-line, frame.size.height-line);
    
    NSLog(@"frame = %@---%@",NSStringFromCGRect(aFrame),NSStringFromCGRect(self.bounds));
    self = [super initWithFrame:aFrame];
    if (self) {
        self.layer.cornerRadius = self.bounds.size.height/2;
        self.layer.masksToBounds = YES;
       self.clipsToBounds = YES;
        alineWidth = line;
      [self installSubviews:line];
    }
    
    return self;
}

-(void)installSubviews:(CGFloat)line{
    
    if(line <= 0){
        
        [self installSubViewsWhenLineZero];
        return;
    }
    
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 + 5);
    NSLog(@"center = %f--%f",center.x,center.y);
    //bottomView
    CGRect bottomRect = CGRectZero;
    if (line == 0) {
        bottomRect = CGRectMake(0, center.y, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-center.y);
        
    }else{
        bottomRect = CGRectMake(0, center.y+kBottomToCenterY, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-center.y-kBottomToCenterY);
    }
    NSLog(@"bottomn= %@",NSStringFromCGRect(bottomRect));
    bottomView = [[UIView alloc]initWithFrame:bottomRect];
   // bottomView.backgroundColor = [UIColor greenColor];
    [self addSubview:bottomView];
    
    bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kUpDownEdge, bottomRect.size.width, kBottonLabelHeight+10)];
    if (line != 0) {
        [bottomView addSubview:[self createLineImageViewWithY:0]];
        
    }
   // bottomLabel.text = @"1000MBs";
    bottomLabel.numberOfLines = 0;
    [bottomLabel setTextColor:[UIColor whiteColor]];
    bottomLabel.font = [RTSSAppStyle getRTSSFontWithSize:10.0f];
    bottomLabel.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    bottomLabel.adjustsFontSizeToFitWidth = YES;
   [bottomView addSubview:bottomLabel];
    
     CGFloat y = (self.frame.size.height/2) -(self.frame.size.height/2) *sin(60*180/M_PI);
    describeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMinY(
                                                             bottomView.frame)-kBottonLabelHeight-10, CGRectGetWidth(self.bounds), kBottonLabelHeight+10)];
    
    NSLog(@"describeLabel=%@",NSStringFromCGRect(describeLabel.frame));
    describeLabel.text = @"MBs Left";
    describeLabel.numberOfLines = 0;
    describeLabel.textColor = [UIColor whiteColor];
    describeLabel.font = [RTSSAppStyle getRTSSFontWithSize:12.0f];
//    describeLabel.backgroundColor = [UIColor orangeColor];
    describeLabel.textAlignment = NSTextAlignmentCenter;
    describeLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    describeLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:describeLabel];
    
    remainLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, y - 5, CGRectGetWidth(self.bounds), CGRectGetMinY(describeLabel.frame)-y + 5)];
    
    NSLog(@"remian = %@",NSStringFromCGRect(remainLabel.frame));
    //remainLabel.text = @"750";
    remainLabel.numberOfLines = 0;
    remainLabel.textColor = [UIColor whiteColor];
    //remainLabel.backgroundColor = [UIColor grayColor];
     remainLabel.textAlignment = NSTextAlignmentCenter;
    remainLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    remainLabel.adjustsFontSizeToFitWidth = YES;
    remainLabel.font = [RTSSAppStyle getRTSSFontWithSize:35.0f];
    [self addSubview:remainLabel];
    
    self.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    bottomView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    
    
}
-(void)installSubViewsWhenLineZero{
    
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    NSLog(@"center = %f--%f",center.x,center.y);
    //bottomView
    CGFloat y = (self.frame.size.height/2) -(self.frame.size.height/2) *sin(60*180/M_PI);
    remainLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, y, CGRectGetWidth(self.bounds), 30)];
    NSLog(@"remian = %@",NSStringFromCGRect(remainLabel.frame));
    //remainLabel.text = @"750";
    remainLabel.numberOfLines = 0;
    remainLabel.textColor = [UIColor whiteColor];
    //remainLabel.backgroundColor = [UIColor grayColor];
    remainLabel.textAlignment = NSTextAlignmentCenter;
    remainLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    remainLabel.adjustsFontSizeToFitWidth = YES;
       remainLabel.font = [RTSSAppStyle getRTSSFontWithSize:20.0f];
    [self addSubview:remainLabel];
    

    describeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(remainLabel.frame)-5, CGRectGetWidth(self.bounds), 10)];
    
    NSLog(@"describeLabel=%@",NSStringFromCGRect(describeLabel.frame));
    //describeLabel.text = @"MBs Left";
    describeLabel.numberOfLines = 0;
    describeLabel.textColor = [UIColor whiteColor];
    describeLabel.font = [RTSSAppStyle getRTSSFontWithSize:10.0f];
    describeLabel.textAlignment = NSTextAlignmentCenter;
    describeLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    describeLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:describeLabel];
    
    bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(describeLabel.frame), CGRectGetWidth(self.bounds), 8)];
   
    // bottomLabel.text = @"1000MBs";
    bottomLabel.numberOfLines = 0;
    [bottomLabel setTextColor:[UIColor whiteColor]];
    bottomLabel.font = [RTSSAppStyle getRTSSFontWithSize:8.0f];
   bottomLabel.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    bottomLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:bottomLabel];
}

#pragma mark --public
-(void)setAllBgViewColor:(UIColor *)aColor{
    
    self.backgroundColor = aColor;
    bottomView.backgroundColor = aColor;
}

-(void)setRemainingAmount:(NSString *)aRemaining total:(NSString *)aTotal Unit:(NSString *)aUnit Color:(UIColor *)aColor{
    
    remainLabel.text = aRemaining;
    describeLabel.text=aUnit;
    bottomLabel.text = aTotal;
    bottomLabel.textColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
    
    if (alineWidth>0) {
        remainLabel.textColor = aColor;
        describeLabel.textColor = aColor;
    }else{
        [self setBackgroundColor:aColor];
    }
    
    
}
-(UIImageView*)createLineImageViewWithY:(CGFloat)lineY{
    
    UIImageView *line = [[UIImageView alloc]init];
    line.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    line.frame = CGRectMake(0, lineY, [UIScreen mainScreen].bounds.size.width, 1);
    
    return [line autorelease];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
