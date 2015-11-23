//
//  FormTextViewCell.m
//  RTSS
//
//  Created by 蔡杰Alan on 15-1-28.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "FormTextViewCell.h"

#define kFormTextViewHeight  40.0f

@interface FormTextViewCell ()<UITextViewDelegate>

@property(nonatomic,retain)UILabel *titleLabel;

@property(nonatomic,retain)UITextView *titleTextView;

@end

@implementation FormTextViewCell

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
    rect.size.height = 125.0f;
    
    //[FormBaseTableViewCell formBaseCellFiedHeightByFormRowType:self.rowDescriptor.rowType];
    self.bgView.frame = rect;
    //标题
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kFormCellLeftEddge, 5, 120, kFormCellLabelHeight)];
    _titleLabel.textColor = [self textMajorColor];
    _titleLabel.font = [UIFont systemFontOfSize:kFormCellLabelFont];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.bgView addSubview:_titleLabel];
    
    //标题文本框
    _titleTextView = [[UITextView alloc]initWithFrame:CGRectMake(kFormCellLeftEddge, CGRectGetMaxY(_titleLabel.frame), CGRectGetWidth(self.bgView.frame)-2*kFormCellLeftEddge, 80)];
    _titleTextView.delegate = self;
    _titleTextView.showsVerticalScrollIndicator = YES;
    _titleTextView.showsHorizontalScrollIndicator = YES;
    _titleTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
     _titleTextView.backgroundColor = [self textFieldBgColor];
    _titleTextView.textColor = [self textSubordinateColor];
    _titleTextView.layer.borderWidth = 1.0;
    _titleTextView.layer.borderColor = [self textFieldBorderColor].CGColor;
    _titleTextView.layer.cornerRadius = 5.0;
    [self.bgView addSubview:_titleTextView];
    
    [self addBottomLine];

   
}

-(void)update{
    [super update];
    _titleLabel.text = self.rowDescriptor.title;
}

#pragma mark --UItextView DeLegate

-(void)textViewDidChange:(UITextView *)textView{

    //字数限制
    NSInteger number = [textView.text length];
    if (number > kFormTextViewLength) {
            return;
        }
    self.rowDescriptor.contentText = textView.text;
    
//    CGSize contentSize = textView.contentSize;
//    
//    if (contentSize.height < kFormTextViewHeight){
//        //return;
//    }
//    
//    
//    CGRect txtFrame = textView.frame;
//   CGFloat textViewContentHeight = txtFrame.size.height =[[NSString stringWithFormat:@"%@\n ",textView.text]
//                                                   boundingRectWithSize:CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
//                                                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//                                                   attributes:[NSDictionary dictionaryWithObjectsAndKeys:textView.font,NSFontAttributeName, nil] context:nil].size.height;
//    
    
    
}

- (UITableView*)parentTableView {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UITableView class]]) {
            return (UITableView*)nextResponder;
        }
    }
    return nil;
}


@end
