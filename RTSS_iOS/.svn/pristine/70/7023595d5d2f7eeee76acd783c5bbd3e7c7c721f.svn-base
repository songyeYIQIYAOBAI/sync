//
//  ETTMonthflowTableViewCell.m
//  EasyTT
//
//  Created by 蔡杰 on 14-10-22.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import "MonthflowTableViewCell.h"

#import "CommonUtils.h"
#import "UIView+RTSSAddView.h"

#import "RTSSAppStyle.h"

#define kETTEdge  10

#define kETTDetailWidth  250

#define kETTDataWidth    100


@interface MonthflowTableViewCell ()
{
    UILabel *detailInfoLabel;
    
    UILabel *dataLabel;
    
    UIView *bgView;
}

@end

@implementation MonthflowTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
       
        [self installSubviews];
    }
    
    return self;
    
}

-(void)installSubviews
{
    UIView *blackView = [[UIView alloc]initWithFrame:self.bounds];
    
    bgView = blackView;
    
    NSLog(@"bounds = %f",self.frame.size.height);
    blackView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    [self.contentView addSubview:blackView];
    
    //line
    
    [blackView addSubview:[self createLineImageViewWithY:blackView.bounds.size.height-2]];
    
    
    //detailLabel
    detailInfoLabel  = [[UILabel alloc]initWithFrame:CGRectMake(kETTEdge, kETTEdge, kETTDetailWidth,self.bounds.size.height-kETTEdge*2)];
    [blackView addSubview:detailInfoLabel];
    
    detailInfoLabel.textAlignment = NSTextAlignmentLeft;
    detailInfoLabel.font = [UIFont systemFontOfSize:18];
    detailInfoLabel.backgroundColor = [UIColor clearColor];
    detailInfoLabel.textColor = [CommonUtils colorWithHexString:@"#929396"];
    detailInfoLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    
    //dataLabel
    dataLabel  = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width-kETTEdge-kETTDataWidth, kETTEdge, kETTDataWidth,self.bounds.size.height-kETTEdge*2)];
     dataLabel.textAlignment = NSTextAlignmentRight;
    dataLabel.font = [UIFont systemFontOfSize:15];
    dataLabel.backgroundColor = [UIColor clearColor];
    dataLabel.textColor = [CommonUtils colorWithHexString: @"#818285"];
    dataLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;

    [blackView addSubview:dataLabel];
    [blackView addBottomLine];
    [blackView release];
     blackView = nil;
    
}

-(void)updateDetailInfo:(NSString *)detailInfo DataLeft:(NSString *)aDataLeft
{
    detailInfoLabel.text = detailInfo;
    dataLabel.text = aDataLeft;
}


-(UIImageView*)createLineImageViewWithY:(CGFloat)lineY{
    
    UIImageView *line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line"]];
    line.frame = CGRectMake(0, lineY, [UIScreen mainScreen].bounds.size.width, 2);
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
