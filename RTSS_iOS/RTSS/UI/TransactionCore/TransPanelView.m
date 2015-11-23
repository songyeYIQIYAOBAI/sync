//
//  PanelView.m
//  EasyTT
//
//  Created by tiger on 14-10-28.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import "TransPanelView.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"

@interface TransPanelView()
{
    UIView* point2;
    UILabel* feeNoteLabel;
}

@end

@implementation TransPanelView
@synthesize submitButton, resetButton, feeValueLabel,transformData, panelType;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutPanelView];
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

- (void)layoutPanelView
{
    RTSSAppStyle * colorMgr = [RTSSAppStyle currentAppStyle];
    //sepraterline
    UIImageView *seprater = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 2)];
    seprater.image = [UIImage imageNamed:@"common_separator_line.png"];
    [self addSubview:seprater];
    [seprater release];

    //圆点
    point2 = [[UIView alloc] init];
    point2.layer.cornerRadius = 5;
    point2.backgroundColor = colorMgr.textBlueColor;
    point2.frame = CGRectMake(16, 23, 10, 10);
    [self addSubview:point2];
    [point2 release];
    
    transformData = [CommonUtils labelWithFrame:CGRectMake(32, 15, 250, 40) text:@"" textColor:colorMgr.textMajorColor textFont:[UIFont systemFontOfSize:10] tag:0];
    [self addSubview:transformData];
    
    //feeNoteLabel
    feeNoteLabel = [CommonUtils labelWithFrame:CGRectMake(3, 55, 53, 30) text:NSLocalizedString(@"Transform_Fee_Label", nil) textColor:colorMgr.textMajorColor textFont:[UIFont systemFontOfSize:14.0] tag:0];
    [self addSubview:feeNoteLabel];
    
    // fee value
    feeValueLabel = [CommonUtils labelWithFrame:CGRectMake(53, 55, 150, 30) text:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Currency_Unit", nil),@"0.00"] textColor:colorMgr.textMajorColor textFont:[UIFont systemFontOfSize:28] tag:0];
    feeValueLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:feeValueLabel];
    
    
    // OK
    submitButton = [CommonUtils buttonWithType:UIButtonTypeCustom
                                         frame:CGRectMake(18+118+20, 102, 118, 39)
                                         title:NSLocalizedString(@"UIButton_Submit_String", nil)
                                   colorNormal:colorMgr.textBlueColor
                              colorHighlighted:colorMgr.textMajorColor
                                 colorSelected:nil
                                     addTarget:nil
                                        action:nil
                                           tag:0];
    submitButton.layer.cornerRadius = 4.f;
    submitButton.clipsToBounds = YES;
    [self addSubview:submitButton];
    submitButton.enabled = FALSE;
    
    // reset
    resetButton = [CommonUtils buttonWithType:UIButtonTypeCustom
                                        frame:CGRectMake(23, 102, 118, 39) title:NSLocalizedString(@"UIButton_Reset_String", nil)
                                  colorNormal:colorMgr.textBlueColor
                             colorHighlighted:colorMgr.textBlueColor
                                colorSelected:nil
                                    addTarget:nil
                                       action:nil
                                          tag:0];
    resetButton.layer.cornerRadius = 4.f;
    resetButton.clipsToBounds = YES;
    [self addSubview:resetButton];
    
}

-(void)setPanelType:(TransPanelType)type
{
    switch (type) {
        case TransFormPanel:
        {
            transformData.numberOfLines = 2;
            transformData.font = [UIFont systemFontOfSize:13];
            transformData.textAlignment = NSTextAlignmentLeft;
            transformData.lineBreakMode = NSLineBreakByWordWrapping;
            [self addSubview:transformData];
            break;
        }
        case TransFerPanel:
        {
            transformData.numberOfLines = 3;
            transformData.font = [UIFont systemFontOfSize:10];
            transformData.adjustsFontSizeToFitWidth = YES;
            transformData.lineBreakMode = NSLineBreakByWordWrapping;
            transformData.textAlignment = NSTextAlignmentLeft;
            [self addSubview:transformData];
            
            point2.frame = CGRectMake(16, 29, 10, 10);
            break;
        }
        case PriceNegotiationPanel:
        {
            transformData.numberOfLines = 1;
            transformData.font = [UIFont systemFontOfSize:13];
            transformData.adjustsFontSizeToFitWidth = YES;
            transformData.lineBreakMode = NSLineBreakByWordWrapping;
            transformData.textAlignment = NSTextAlignmentLeft;
            [self addSubview:transformData];
            point2.frame = CGRectMake(16, 29, 10, 10);
            
            feeValueLabel.hidden = YES;
            feeNoteLabel.hidden = YES;
            break;
        }
        default:
            break;
    }
}

@end
