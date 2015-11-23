//
//  RTSSKeyBoardView.m
//  RTSS
//
//  Created by 蔡杰 on 14-10-28.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "RTSSKeyBoardView.h"

#import "RTSSAppDefine.h"
#import "RTSSAppStyle.h"
#import "CommonUtils.h"

#import "AlertController.h"



#define kRTSSButtonWidth 35.0f

#define kRTSSButtonEdge  5.0f

@interface RTSSKeyBoardView ()<UITextFieldDelegate>

@end

@implementation RTSSKeyBoardView
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];

    [_textField release];
    _textField = nil;
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self installSubviews:frame];
    }
    return self;
}

-(void)installSubviews:(CGRect)aFrame{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    //payButton
    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payButton.frame = CGRectMake(PHONE_UISCREEN_WIDTH-kRTSSButtonWidth-kRTSSButtonEdge, 5, kRTSSButtonWidth, kRTSSButtonWidth);
    [payButton setTitle:@"Pay" forState:UIControlStateNormal];
    [payButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [payButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [payButton addTarget:self action:@selector(payTranfer) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:payButton];
    //文本框
    self.textField = [[UITextField alloc]init];
    self.textField.delegate = self;
    self.textField.frame = CGRectMake(kRTSSButtonEdge*3, 10, PHONE_UISCREEN_WIDTH-kRTSSButtonWidth-kRTSSButtonEdge*5, 30);
    
    UILabel *moneySymbol =[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 10, 20)];
    moneySymbol.text = @"€";
    moneySymbol.textColor =[UIColor whiteColor];
    
    self.textField.leftView = moneySymbol;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    //设置layer外层框
    self.textField.layer.borderColor = [RTSSAppStyle currentAppStyle].textFieldBorderColor.CGColor;
    self.textField.layer.borderWidth = 2.0;
    self.textField.layer.cornerRadius = 5.0;
    [self addSubview:self.textField];
}


#pragma mark --Action
-(void)payTranfer{
    BOOL flag = NO;
    NSString *message = nil;
    
    if (![self.textField.text length]>0) {
        flag = YES;
        message = @"Balance should not be empty.";
    }
    
    if ([self.textField.text integerValue] == 0) {
        flag = YES;
        message = @"Balance should not be 0.";
    }
    
    if (flag) {
        UIViewController *vc  = [self getViewController];
        if (!vc) {
            return;
        }
        [AlertController showSimpleAlertWithTitle:nil message:message buttonTitle:@"Sure" inViewController:vc];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardViewPayBalance:)]) {
        CGFloat balance = [self.textField.text floatValue];
        NSLog(@"balance = %f",balance);
        [_delegate keyBoardViewPayBalance:balance];
    }
    
    
}

#pragma mark --UITextFielDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //NSLog(@"sss%@",string);
    return YES;
}

#pragma mark --UIKeyBoard 响应
-(void)keyboardShow:(NSNotification *)notification{
    //Get begin, ending rect and animation duration
    CGRect beginRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat animDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //坐标转换为本地坐标
    beginRect = [self fixKeyboardRect:beginRect];
    endRect = [self fixKeyboardRect:endRect];
    //Get this view begin and end rect
    CGRect selfBeginRect = CGRectMake(beginRect.origin.x,
                                      beginRect.origin.y - self.frame.size.height,
                                      beginRect.size.width,
                                      self.frame.size.height);
    CGRect selfEndingRect = CGRectMake(endRect.origin.x,
                                       endRect.origin.y - self.frame.size.height,
                                       endRect.size.width,
                                       self.frame.size.height);
    
    //Set view position and hidden
    self.frame = selfBeginRect;
    self.alpha = 0.0f;
    [self setHidden:NO];
    UIViewAnimationOptions options = UIViewAnimationOptionAllowAnimatedContent;
    [UIView animateWithDuration:animDuration delay:0.0f
                        options:options
                     animations:^(void){
                         self.frame = selfEndingRect;
                         self.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                         self.frame = selfEndingRect;
                         self.alpha = 1.0f;
                     }];

}
-(void)keyboardHide:(NSNotification *)notification{

        //Get begin, ending rect and animation duration
        CGRect beginRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        CGRect endRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat animDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        
        //坐标转换为本地坐标
        beginRect = [self fixKeyboardRect:beginRect];
        endRect = [self fixKeyboardRect:endRect];
        //Get this view begin and end rect
        CGRect selfBeginRect = CGRectMake(beginRect.origin.x,
                                          beginRect.origin.y - self.frame.size.height,
                                          beginRect.size.width,
                                          self.frame.size.height);
        CGRect selfEndingRect = CGRectMake(endRect.origin.x,
                                           endRect.origin.y - self.frame.size.height,
                                           endRect.size.width,
                                           self.frame.size.height);
        
        //Set view position and hidden
        self.frame = selfBeginRect;
        self.alpha = 1.0f;
    
    //Animation options
    UIViewAnimationOptions options = UIViewAnimationOptionAllowAnimatedContent;
    [UIView animateWithDuration:animDuration delay:0.0f
                        options:options
                     animations:^(void){
                         self.frame = selfEndingRect;
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.frame = selfEndingRect;
                         self.alpha = 0.0f;
                         [self setHidden:YES];
                        
                     }];

}






#pragma mark - Private methods
- (CGRect) fixKeyboardRect:(CGRect)originalRect{
    //通过superView 得到Window
    UIView * referenceView = self.superview;
    while ((referenceView != nil) && ![referenceView isKindOfClass:[UIWindow class]]){
        referenceView = referenceView.superview;
    }
    //取到window
    CGRect newRect = originalRect;
    if ([referenceView isKindOfClass:[UIWindow class]]){
        //转换
        UIWindow * myWindow = (UIWindow*)referenceView;
        newRect = [myWindow convertRect:originalRect toView:self.superview];
    }
    return newRect;
}

- (UIViewController *)getViewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
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
