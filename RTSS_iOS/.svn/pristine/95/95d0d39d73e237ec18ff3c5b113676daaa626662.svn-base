//
//  UsageAlertListCell.m
//  RTSS
//
//  Created by tiger on 14-11-26.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "UsageAlertListCell.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"

#define CONTROL_RIGHT_BADDING           10
#define CONTROL_LEFT_BADDING            10

@interface UsageAlertListCell()
{
    UILabel * titleLabel;
    UIImageView * flagImageView;
}
@end

@implementation UsageAlertListCell
@synthesize model , budgetBtn;

-(void)dealloc
{
    [self.model release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initObject];
        
    }
    return self;
}

-(void)initObject
{
    CGSize cellSize = self.bounds.size;
    
    //标题
    titleLabel = [CommonUtils labelWithFrame:CGRectMake(CONTROL_LEFT_BADDING, (cellSize.height-30)/2, 150, 30) text:nil textColor:[RTSSAppStyle currentAppStyle].textMajorColor textFont:[UIFont systemFontOfSize:18] tag:0];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titleLabel];
    
    //图标
    flagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(cellSize.width - CONTROL_RIGHT_BADDING -23,(cellSize.height-23)/2,23,23)];
    flagImageView.image = [UIImage imageNamed:@"common_arrow_down.png"];
    flagImageView.contentMode = UIViewContentModeCenter;
    flagImageView.hidden = YES;
    [self.contentView addSubview:flagImageView];
    [flagImageView release];

    
    //预算按钮
    budgetBtn = [CommonUtils buttonWithType:UIButtonTypeCustom
                                      frame:CGRectMake(cellSize.width-CONTROL_RIGHT_BADDING-65, (cellSize.height-25)/2, 65, 25)
                                      title:@"100%"
                                colorNormal:[RTSSAppStyle currentAppStyle].viewControllerBgColor
                           colorHighlighted:nil
                              colorSelected:nil
                                  addTarget:nil
                                     action:nil
                                        tag:0];
    budgetBtn.hidden = YES;
    [budgetBtn setTitleColor:[RTSSAppStyle currentAppStyle].textSubordinateColor forState:UIControlStateNormal];
    budgetBtn.layer.cornerRadius = 5.f;
    budgetBtn.layer.borderColor = [RTSSAppStyle currentAppStyle].budgetControlButtonStrokeColor.CGColor;
    budgetBtn.layer.borderWidth = 0.5f;
    budgetBtn.clipsToBounds = YES;
    [self addSubview:budgetBtn];

    //分割线
    UIImageView *line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_separator_line"]];
    line.frame = CGRectMake(0, cellSize.height-2, cellSize.width, 2);
    [self addSubview:line];
    [line release];
}

-(void)setModel:(UsageAlertListModel*)newModel
{
    if (model != newModel) {
        [model release];
        model = [newModel retain];
    }

    CGSize cellSize = self.bounds.size;
    int level = model.layer;

    if (level == 1) {
        flagImageView.hidden = NO;
        self.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
        titleLabel.text = newModel.content;
    }else if(level == 2)
    {
        titleLabel.text = newModel.content;
        titleLabel.frame = CGRectMake(CONTROL_LEFT_BADDING+5, (cellSize.height-30)/2, 150, 30);
        titleLabel.textColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
        self.backgroundColor = [RTSSAppStyle currentAppStyle].turboBoostUnfoldBgColor;
        budgetBtn.hidden = NO;
        [budgetBtn setTitle:newModel.notificationValue forState:UIControlStateNormal];
    }
}

-(void)setImageFold:(BOOL)status
{
    if (status) {
        [UIView animateWithDuration:0.5 animations:^{
            flagImageView.transform = CGAffineTransformMakeRotation(0);
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            flagImageView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    }
}
@end
