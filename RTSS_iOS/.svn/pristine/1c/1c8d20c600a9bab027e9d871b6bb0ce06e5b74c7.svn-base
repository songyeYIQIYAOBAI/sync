//
//  FormPickerCell.m
//  RTSS
//
//  Created by 蔡杰Alan on 15-1-28.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "FormPickerCell.h"

#import "SinglePickerController.h"

#define kFormButtonHeiht 30.0f
@interface FormPickerCell ()<SinglePickerDelegate>

@property(nonatomic,retain)UILabel *titleLabel;

@property(nonatomic,retain)UILabel *contentLabel;

@property(nonatomic,retain)SinglePickerController *singlePicker;

@property(nonatomic,assign)UIButton *arrowButton;

@end


@implementation FormPickerCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)dealloc{
    [_titleLabel release];
    [_contentLabel release];
    [_singlePicker release];
    [super dealloc];
}
#pragma mark-Set @property
-(SinglePickerController *)singlePicker{
    if (!_singlePicker) {
        _singlePicker = [[SinglePickerController alloc]init];
        _singlePicker.pickerType = SinglePickerTypeDefault;
        _singlePicker.delegate = self;
    }
    return _singlePicker;
}

#pragma mark--OverRide
-(void)configure{
    [super configure];
    
    CGRect rect = self.bgView.frame;
    rect.size.height = [FormBaseTableViewCell formBaseCellFiedHeightByFormRowType:self.rowDescriptor.rowType];
    self.bgView.frame = rect;

    //标题
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kFormCellLeftEddge, kFormCellTopEdge, 120, kFormCellLabelHeight)];
    _titleLabel.textColor = [self textMajorColor];
    _titleLabel.font = [RTSSAppStyle getRTSSFontWithSize:kFormCellLabelFont];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.bgView addSubview:_titleLabel];
    
    //选择
    _arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _arrowButton.frame = CGRectMake(CGRectGetWidth(self.bgView.frame)-kFormCellTopEdge-kFormButtonHeiht, kFormCellTopEdge, kFormButtonHeiht, kFormButtonHeiht);
    [_arrowButton setImage:[UIImage imageNamed:@"common_arrow_down"] forState:UIControlStateNormal];
    _arrowButton.tag = self.pickerButtonTag;
    [_arrowButton addTarget:self action:@selector(bringUpPicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:_arrowButton];
    
    //文本内容
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleLabel.frame)+10, kFormCellTopEdge,CGRectGetMinX(_arrowButton.frame)-CGRectGetMaxX(_titleLabel.frame)-10, kFormCellLabelHeight)];
    [_contentLabel setTextColor:[self textSubordinateColor]];
    [_contentLabel setFont:[RTSSAppStyle getRTSSFontWithSize:kFormCellLabelFont]];
    [_contentLabel setTextAlignment:NSTextAlignmentRight];
    [self.bgView addSubview:_contentLabel];
    // self.bgView.backgroundColor= [UIColor greenColor];
    [self addBottomLine];
    
    
}

-(void)update{
    [super update];
    _titleLabel.text = self.rowDescriptor.title;
    _contentLabel.text = self.rowDescriptor.contentText;
    
    if ( self.rowDescriptor.rowType ==FormRowTypeSelect && [self.rowDescriptor.pickerArray count] > 0) {
        self.singlePicker.pickerArrayData = self.rowDescriptor.pickerArray;
       
    }
    [self.singlePicker selectRow:0 inComponent:0 animated:NO];
    
}
#pragma mark --Action
-(void)bringUpPicker:(UIButton *)button{
    //弹出选择器
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(pickerButtonDone:)]) {
        [self.delegate pickerButtonDone:button.tag];
    }
    if (![self.rowDescriptor.pickerArray count]>0) {
        return;
    }
    [[self viewController].view.window addSubview:self.singlePicker.view];
    
}
#pragma mark -- SingleDelegate
-(void)singlePickerWithCancel:(SinglePickerController *)controller{
    
    [controller.view removeFromSuperview];
}
-(void)singlePickerWithDone:(SinglePickerController *)controller selectedIndex:(NSInteger)index{
    
    NSString *text = [controller.pickerArrayData objectAtIndex:index];
    BOOL isChange = [text isEqualToString:self.rowDescriptor.contentText] ? NO:YES;

    _contentLabel.text = text;
    self.rowDescriptor.contentText = text;
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(singlePickerWithButtonTag:DoneWithselectedIndex:isChange:)]) {
        [self.delegate singlePickerWithButtonTag:_arrowButton.tag DoneWithselectedIndex:index isChange:isChange];
    }
    
    [controller.view removeFromSuperview];
    
}

#pragma mark --Private
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

#pragma mark --
-(void)setPickerButtonTag:(int)pickerButtonTag{
    _arrowButton.tag = pickerButtonTag;
}

@end
