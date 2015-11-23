//
//  ExpandTitleTableViewCell.m
//  RTSS
//
//  Created by 蔡杰Alan on 14-11-14.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "ExpandTitleTableViewCell.h"

#import "RTSSAppStyle.h"
#import "RTSSAppDefine.h"

@implementation ExpandTitleTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setup];
        
    }
    
    return self;
}

-(void)setup{
    
    
    //self.contentView.backgroundColor=[UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, self.bounds.size.height)];
    self.backgroundView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;

    self.textLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    self.textLabel.font = [RTSSAppStyle getRTSSFontWithSize:15.0f];
    self.textLabel.textAlignment = NSTextAlignmentLeft;
    self.textLabel.text = @"Plan Policies";

    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(5, 15, 20, 20)];
    arrow.image = [UIImage imageNamed:@"common_arrow_down.png"];
   // arrow.backgroundColor = [UIColor redColor];
    self.accessoryView = arrow;
    [self changeArrowWithUp:NO];
    [arrow release];
    
   // UIImageView *line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_separator_line"]];
    UIImageView *line = [[UIImageView alloc]init];
    line.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    line.frame = CGRectMake(0, self.bounds.size.height-1, PHONE_UISCREEN_WIDTH, 1);
    [self.contentView addSubview:line];
    [line release];
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(20, 12, 200, 20);
}

-(void)setupTitleInfo:(NSString *)title{
    
    self.textLabel.text = title;
}

-(void)changeArrowWithUp:(BOOL)up{
    
    
    if (up) {
        self.accessoryView.transform = CGAffineTransformIdentity;
        
    }else{
        self.accessoryView.transform = CGAffineTransformMakeRotation(-M_PI/2);
        
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
