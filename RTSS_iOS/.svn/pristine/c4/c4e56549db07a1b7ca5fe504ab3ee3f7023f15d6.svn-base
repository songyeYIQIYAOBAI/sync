//
//  ServiceRequestTableViewCell.m
//  EasyTT
//
//  Created by 蔡杰 on 14-10-14.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import "ServiceRequestTableViewCell.h"
#import "RTSSAppStyle.h"

@interface ServiceRequestTableViewCell ()
{
    UIView *_backgroundView;
    UILabel *_categoryLabel;
    UILabel *_infoLabel;

}

@end

@implementation ServiceRequestTableViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self installView];
    }
    return self;
}


-(void)installView
{
    
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    
    _backgroundView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    //_backgroundView.layer.cornerRadius = 4.0f;
    //_backgroundView.layer.masksToBounds = YES;
    [self.contentView addSubview:_backgroundView];
    
    _categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10,120, 30)];
    [_categoryLabel setTextColor:[RTSSAppStyle currentAppStyle].textMajorColor];
     [_categoryLabel setTextAlignment:NSTextAlignmentLeft];
    [_categoryLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [_categoryLabel setNumberOfLines:0];
    [_backgroundView addSubview:_categoryLabel];
    
    //下箭头
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake(140, 10, 30, 30);
    [button setImage:[UIImage imageNamed:@"common_arrow_down"] forState:UIControlStateNormal];
    
    [_backgroundView addSubview:button];
    
    
    _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 10, 120, 30)];
    [_infoLabel setTextColor:[RTSSAppStyle currentAppStyle].textSubordinateColor];
    [_infoLabel setFont:[UIFont systemFontOfSize:14]];
    [_infoLabel setTextAlignment:NSTextAlignmentLeft];
    [_backgroundView addSubview:_infoLabel];
}

-(void)updateCategory:(NSString *)title info:(NSString *)info
{
    _categoryLabel.text =  title;
    
    _infoLabel.text = info;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
