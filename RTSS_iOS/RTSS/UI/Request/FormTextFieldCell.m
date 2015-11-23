//
//  FormTextFieldCell.m
//  RTSS
//
//  Created by 蔡杰Alan on 15-1-27.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "FormTextFieldCell.h"

@interface FormTextFieldCell ()<UITextFieldDelegate>

@property(nonatomic,retain)UILabel *titleLabel;

@property(nonatomic,retain)UITextField *titleField;

@end

@implementation FormTextFieldCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)configure{
    [super configure];
    CGRect rect = self.bgView.frame;
    rect.size.height = 90;
    self.bgView.frame = rect;

    //标题
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kFormCellLeftEddge,5,120, kFormCellLabelHeight)];
    _titleLabel.textColor = [self textMajorColor];
    _titleLabel.font = [UIFont systemFontOfSize:kFormCellLabelFont];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.bgView addSubview:_titleLabel];
    
    //标题文本框
    _titleField = [[UITextField alloc]initWithFrame:CGRectMake(kFormCellLeftEddge, CGRectGetMaxY(_titleLabel.frame), CGRectGetWidth(self.bgView.frame)-2*kFormCellLeftEddge, 40)];
    _titleField.layer.borderWidth = 1.0;
    _titleField.layer.borderColor = [self textFieldBorderColor].CGColor;
    _titleField.layer.cornerRadius = 5.0;
    _titleField.backgroundColor = [self textFieldBgColor];
    _titleField.textColor = [self textSubordinateColor];
    [_titleField addTarget:self action:@selector(enditChanges:) forControlEvents:UIControlEventEditingChanged];
    [self.bgView addSubview:_titleField];
    
    [self addBottomLine];

    //  self.contentView.frame = rect;
    //self.bgView.backgroundColor= [UIColor redColor];
}

-(void)update{
    [super update];
    _titleLabel.text = self.rowDescriptor.title;
    
    
}

-(void)enditChanges:(id)sender{
    UITextField *textField = (UITextField*)sender;
    self.rowDescriptor.contentText = textField.text;
    
    NSLog(@"999---%@",textField.text);
}
@end
