//
//  TransactionPanelBaseView.m
//  RTSS
//
//  Created by 蔡杰Alan on 15-2-3.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "TransactionPanelBaseView.h"
#import "RTSSAppStyle.h"

@interface TransactionPanelBaseView()


@end

@implementation TransactionPanelBaseView
@synthesize initPanelBaseFrame,initChangePanelBaseFrame;
@synthesize feeLabel, feeValueLabel, resetButton, submitButton;

-(void)dealloc{
    [feeLabel release];
    [feeValueLabel release];
    [resetButton release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.initPanelBaseFrame = frame;
        self.initChangePanelBaseFrame = CGRectMake(frame.origin.x, frame.origin.y-frame.size.height, frame.size.width, frame.size.height);
        
        //line
        UIImageView * line = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 0.5)] autorelease];
        line.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
        [self addSubview:line];
        
        
        // ===
        feeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 35, 20)];
        feeLabel.backgroundColor = [UIColor clearColor];
        feeLabel.textAlignment = NSTextAlignmentCenter;
        feeLabel.textColor = [UIColor whiteColor];
        feeLabel.numberOfLines = 1;
        feeLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        feeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        feeLabel.font = [RTSSAppStyle getRTSSFontWithSize:12.0];
        [self addSubview:feeLabel];
        
        // ===
        feeValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(feeLabel.frame), 15, CGRectGetWidth(self.bounds)-15*2, 20)];
        feeValueLabel.backgroundColor = [UIColor clearColor];
        feeValueLabel.textAlignment = NSTextAlignmentLeft;
        feeValueLabel.textColor = [UIColor whiteColor];
        feeValueLabel.numberOfLines = 1;
        feeValueLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        feeValueLabel.lineBreakMode = NSLineBreakByWordWrapping;
        feeValueLabel.font = [RTSSAppStyle getRTSSFontWithSize:17.0];
        [self addSubview:feeValueLabel];
        [self addBottomLine];
        
        // ===
        CGFloat interval = 30;
        CGFloat buttonWidth = (CGRectGetWidth(self.bounds)-interval*2-interval)/2;
        resetButton = [[UIButton alloc] initWithFrame:CGRectMake(interval, CGRectGetMaxY(feeValueLabel.frame)+ 15, buttonWidth, 40)];
        resetButton.backgroundColor = [RTSSAppStyle currentAppStyle].buttonMajorColor;
        resetButton.layer.masksToBounds = YES;
        resetButton.layer.cornerRadius = 20;
        [self addSubview:resetButton];
    
        // ===
        CGRect submitBtnRect = CGRectMake(interval+buttonWidth+interval, CGRectGetMaxY(feeValueLabel.frame)+ 15, buttonWidth, 40);
        submitButton = [RTSSAppStyle getMajorGreenButton:submitBtnRect
                                                  target:nil
                                                  action:nil
                                                   title:nil];
        submitButton.layer.masksToBounds = YES;
        submitButton.layer.cornerRadius = 20;
        [self addSubview:submitButton];
    }
    return self;
}

-(void)addBottomLine{
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 0.5)];
    line.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [self addSubview:line];
    [line release];
}

#pragma mark --Interface
-(NSString *)getMoth{
    
    return @"";
}

-(void)setMothDurtions:(NSArray*)durations;{
    
}

@end
