//
//  TransationBaseTableViewCell.m
//  RTSS
//
//  Created by 蔡杰Alan on 15-2-2.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "TransationBaseTableViewCell.h"

@implementation TransationBaseTableViewCell
-(void)dealloc{
    [_identify release];
    [_comboSlider release];
    [super dealloc];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self configure];
    }
    
    return self;
}
-(void)configure{
    
    _comboSlider = [[ComboSlider alloc]initWithFrame:CGRectMake(10,0,PHONE_UISCREEN_WIDTH-20, [TransationBaseTableViewCell transationTableViewCellFixHeight])];
    _comboSlider.resourceTitleLabel.textColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
    _comboSlider.resourceTitleLabel.font = [RTSSAppStyle getRTSSFontWithSize:10];
    
    _comboSlider.minimumMarkView.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    _comboSlider.minimumValueLabel.textColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
    
    _comboSlider.maximumMarkView.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    _comboSlider.maximumValueLabel.textColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;

    _comboSlider.currentValueLabel.textColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;

    [_comboSlider addTarget:self action:@selector(onSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_comboSlider addTarget:self action:@selector(onSliderTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    [_comboSlider.rightItemButton addTarget:self action:@selector(rightItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_comboSlider.resourceItemButton addTarget:self action:@selector(resourceEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    _comboSlider.backgroundColor = [UIColor clearColor];
    
    _comboSlider.thumbColor = [UIColor whiteColor];
    _comboSlider.thumbSize  = CGSizeMake(20, 20);
    [self.contentView addSubview:_comboSlider];
    
    [self addBottomLine];

}

-(void)addBottomLine{
    UIImageView *line = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_separator_line"]] autorelease];
    line.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    line.frame = CGRectMake(0, [[self class] transationTableViewCellFixHeight] - 0.5, PHONE_UISCREEN_WIDTH, 0.5);
    [self.contentView addSubview:line];
}

+(CGFloat)transationTableViewCellFixHeight{
    
    return 90.0;
}

-(void)setTransationBaseTableViewCellBgColor:(UIColor *)color{
    
    _comboSlider.backgroundColor = color;
    self.contentView.backgroundColor = color;

}
#pragma mark --Action

- (void)onSliderValueChanged:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(transationTableViewCell:onSliderValueChanged:)]) {
        [_delegate transationTableViewCell:self onSliderValueChanged:(ComboSlider*)sender];
    }
    
}

- (void)onSliderTouchUpInside:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(transationTableViewCell:onSliderTouchUpInside:)]) {
        [_delegate transationTableViewCell:self onSliderTouchUpInside:(ComboSlider*)sender];
    }
}

-(void)resourceEvent:(id)sender{
    
    if (_delegate && [_delegate respondsToSelector:@selector(transationTableViewCell:resourceEvent:)]) {
        [_delegate transationTableViewCell:self resourceEvent:self.comboSlider];
    }
    
}

-(void)rightItemEvent:(id)sender{
    
    if (_delegate && [_delegate respondsToSelector:@selector(transationTableViewCell:rightItemEvent:)]) {
        [_delegate transationTableViewCell:self rightItemEvent:self.comboSlider];
    }
    
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
