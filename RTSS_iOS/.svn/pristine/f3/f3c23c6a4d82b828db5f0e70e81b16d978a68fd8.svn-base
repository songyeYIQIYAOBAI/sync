//
//  ExpandDetailTableViewCell.m
//  RTSS
//
//  Created by 蔡杰Alan on 14-11-14.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "ExpandDetailTableViewCell.h"
#include "RTSSAppStyle.h"
#import "RTSSAppDefine.h"

#define kRTSSTag 100

@implementation ExpandDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setup];
        
    }
    
    return self;
}

-(void)setup{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, self.bounds.size.height)];
    self.backgroundView.backgroundColor =[RTSSAppStyle currentAppStyle].navigationBarColor;
    self.textLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    self.textLabel.font = [RTSSAppStyle getRTSSFontWithSize:12.0f];
    self.textLabel.textAlignment = NSTextAlignmentLeft;
    //self.textLabel.text = @"UPLOAD SPEED:";
    
    self.detailTextLabel.textColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
    self.detailTextLabel.font = [RTSSAppStyle getRTSSFontWithSize:12.0f];
    self.detailTextLabel.textAlignment = NSTextAlignmentRight;
  //  self.detailTextLabel.text = @"2004";
    
    UIImageView *line = [[UIImageView alloc]init];
    line.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    line.frame = CGRectMake(0, self.bounds.size.height-1, PHONE_UISCREEN_WIDTH,1);
    [self.contentView addSubview:line];
    [line release];

    
}

-(void)layoutSubviews{
    
   [super layoutSubviews];
    self.textLabel.frame = CGRectMake(20, 12, PHONE_UISCREEN_WIDTH, 20);
    self.detailTextLabel.frame = CGRectMake(self.bounds.size.width-20-100, 12, PHONE_UISCREEN_WIDTH, 20);

}

-(void)setTitle:(NSString*)aTitle DetailInfo:(NSString*)aInfo{
    
    self.textLabel.text = aTitle;
    self.detailTextLabel.text = aInfo;
    
}
-(void)setTitle:(NSString*)aTitle {
    
    self.textLabel.text = aTitle;
}

-(void)addGradualBar{
    
    UIImageView *graduaBar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 8)];
    graduaBar.image = [UIImage imageNamed:@"turboboost_gradual_bar"];
    graduaBar.tag = kRTSSTag;
    [self.contentView addSubview:graduaBar];
    [graduaBar release];
    
}

-(void)removeGradualBar{
    
    UIView *view = [self viewWithTag:kRTSSTag];
    if (view) {
        
        [view removeFromSuperview];
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
