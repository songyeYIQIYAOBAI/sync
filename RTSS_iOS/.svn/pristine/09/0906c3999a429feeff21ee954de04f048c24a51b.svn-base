//
//  FormBaseTableViewCell.m
//  RTSS
//
//  Created by 蔡杰Alan on 15-1-27.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "FormBaseTableViewCell.h"

@implementation FormBaseTableViewCell

-(void)dealloc{
    [_bgView release];
    [_rowDescriptor release];
    [super dealloc];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark --Set @property

-(void)setRowDescriptor:(FormRowDescriptor *)rowDescriptor{
    
    if (rowDescriptor == nil) {
        return;
    }
    
    if (_rowDescriptor != rowDescriptor) {
        [_rowDescriptor release];
        _rowDescriptor = [rowDescriptor retain];
        [self update];
      
    }
    
}
#pragma mark --subClass override
-(void)update{
    //override
    
}

-(void)configure{
    //override
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.bounds.size.height)];
    [self.contentView addSubview:_bgView];
}


#pragma mark --Public
-(void)setCellBlackViewColor:(UIColor *)color{
    
    _bgView.backgroundColor = color;
}
-(UIColor *)textMajorColor{
    
    return [RTSSAppStyle currentAppStyle].textMajorColor;
}
-(UIColor *)textSubordinateColor{
    return [RTSSAppStyle currentAppStyle].textSubordinateColor;
}
-(UIColor *)textFieldBorderColor{
    
    return [RTSSAppStyle currentAppStyle].textFieldBorderColor;
}
-(UIColor *)textFieldBgColor{
    return [RTSSAppStyle currentAppStyle].textFieldBgColor;
}

+(CGFloat)formBaseCellFiedHeightByFormRowType:(FormRowType)type{
    
    switch (type) {
        case FormRowTypeTextField:{
            return 85.0f;
            break;
        }
        case FormRowTypeTextView:{
            return 125.0f;
            break;
        }
            
        default:
            return 50.0f;
            break;
    }
}

-(void)addBottomLine{
//    UIImageView *line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"common_separator_line"]];
//    line.frame = CGRectMake(0, self.bgView.frame.size.height-2, [UIScreen mainScreen].bounds.size.width, 2);
//    [self addSubview:line];
//    [line release];
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bgView.frame.size.height-1, [UIScreen mainScreen].bounds.size.width, 1)];
    line.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [self addSubview:line];
    [line release];
}
@end
