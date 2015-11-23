//
//  TransactionPanelPNView.m
//  RTSS
//
//  Created by 蔡杰Alan on 15-2-3.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "TransactionPanelPNView.h"
#import "SinglePickerController.h"
#import "RTSSAppStyle.h"
@interface TransactionPanelPNView ()<SinglePickerDelegate>

@property(nonatomic,retain)SinglePickerController *singlePicker;
@property(nonatomic,assign)UIButton *monthButton;

@property(nonatomic,retain)NSArray *durations;
@end
@implementation TransactionPanelPNView
-(void)dealloc{
    
    [_singlePicker release];
    [_durations release];
    [super dealloc];
}
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self intallSubview ];
    }
    return self;
}

-(void)intallSubview{
    
    //==
    _monthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _monthButton.frame = CGRectMake(CGRectGetWidth(self.bounds)-45-15, 10, 45, 30);
    _monthButton.backgroundColor = [UIColor grayColor];
   // [_monthButton setTitle:@"12" forState:UIControlStateNormal];
    [_monthButton addTarget:self action:@selector(selectMonth) forControlEvents:UIControlEventTouchUpInside];
    _monthButton.layer.masksToBounds = YES;
    _monthButton.layer.cornerRadius = 2;
    [self addSubview:_monthButton];
    //===
     UILabel *mothLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_monthButton.frame)-50-15, 5, 50, 40)];
     mothLabel.textColor = [UIColor whiteColor];
     mothLabel.font =[RTSSAppStyle getRTSSFontWithSize:14.0f];
     mothLabel.text = @"Month:";
     [self addSubview:mothLabel];
}

-(void)selectMonth{
    
    if (!self.durations || ![self.durations count] >0) {
        return;
    }
    
    [[self viewController].view.window addSubview:self.singlePicker.view];
}

#pragma mark--
-(SinglePickerController *)singlePicker{
    
    if (!_singlePicker) {
        _singlePicker = [[SinglePickerController alloc]init];
        _singlePicker.delegate = self;
        _singlePicker.pickerType = SinglePickerTypeDefault;

        _singlePicker.pickerArrayData = self.durations;
    }
    
    return _singlePicker;
}
-(void)singlePickerWithCancel:(SinglePickerController *)controller{
    
    [controller.view removeFromSuperview];
}
-(void)singlePickerWithDone:(SinglePickerController *)controller selectedIndex:(NSInteger)index{
    
    NSString *text = [controller.pickerArrayData objectAtIndex:index];
    [_monthButton setTitle:text forState:UIControlStateNormal];
    [controller.view removeFromSuperview];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(TransactionPanelPNView:changeMoth:)]) {
        
        [self.delegate TransactionPanelPNView:self changeMoth:[text integerValue]];
    }
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

#pragma mark  --Interface
-(NSString *)getMoth{
    
    return _monthButton.titleLabel.text;
}


-(void)setMothDurtions:(NSArray*)aDurations{
    
    
    if (aDurations && [aDurations count] > 0) {
        
       
         self.durations = aDurations;
    }
    
    NSString *month;
    
    if ([self.durations count] >0) {
        
        month = [self.durations firstObject];
    }else{
        month = @"12";
    }
    
    [_monthButton setTitle:month forState:UIControlStateNormal];

}
@end
