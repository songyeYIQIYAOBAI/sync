//
//  UITextField+CheckState.m
//  EasyTT
//
//  Created by 蔡杰 on 14-10-24.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import "UITextField+CheckState.h"
#import "AlertController.h"

@implementation UITextField (CheckState)

-(void)giveUpTheKeyboard{
    if ([self isFirstResponder]) {
        [self resignFirstResponder];
    }
}
-(void)clearupInpuView{
    UIView *inputView = [[UIView alloc]initWithFrame:CGRectZero];
    self.inputView = inputView;
    [inputView release];
}
-(void)addRightViewWithFrame:(CGRect)aFrame BlackImage:(UIImage *)aImage Target:(id)aTarget Action:(SEL)aSel{

    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = aFrame;
    button.backgroundColor = [UIColor greenColor];
    [button setBackgroundImage:aImage forState:UIControlStateNormal];
    [button addTarget:aTarget action:aSel forControlEvents:UIControlEventTouchUpInside];
    self.rightView = button;
    self.rightViewMode = UITextFieldViewModeAlways;
}
#pragma mark --Balance
-(BOOL)isBalanceValid{
    
    return (![self isEmptyShowMessage:NSLocalizedString(@"Balance_Transfer_Amount_NotEmpty_Alert", nil)]&&[self isBalacceValueValid]);
}

-(BOOL)isBalacceValueValid{
    
    NSString *regex = @"^[1-9]\\d*";
    NSPredicate *prd = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [prd evaluateWithObject:self.text];
    
   
    if (!isMatch) {
        NSString *message = NSLocalizedString(@"Balance_Transfer_Amount_NotValid_Alert", nil);
        [AlertController showSimpleAlertWithTitle:nil message:message buttonTitle:NSLocalizedString(@"UIAlertView_Confirm_String", nil) inViewController:[self viewController]];
    }
    
    return isMatch;
    
}
#pragma mark --Acount
-(BOOL)isAccountValid{
    return (![self isEmptyShowMessage:NSLocalizedString(@"Balance_Transfer_Select_Recipient_Alert", nil)] && [self isAccountValueValid]);
}
-(BOOL)isAccountValueValid{
    
    return YES;
//    NSInteger lenth = [self.text length];
//    if (lenth<=12) {
//        
//         return YES;
//    }
//     [AlertController showSimpleAlertWithTitle:nil message:NSLocalizedString(@"Balance_Transfer_Select_Recipient_UserID_Valid_Alert", nil) buttonTitle:NSLocalizedString(@"UIAlertView_Confirm_String", nil) inViewController:[self viewController]];
//    return NO;
   
}
#pragma mark --empty
-(BOOL)isEmptyShowMessage:(NSString *)message{
    
    BOOL isEmpty = ![self.text length]>0;
    
    if (isEmpty) {

        [AlertController showSimpleAlertWithTitle:nil message:message buttonTitle:NSLocalizedString(@"UIAlertView_Confirm_String", nil) inViewController:[self viewController]];
    }
    return isEmpty;

}

- (UIViewController *)viewController {
    /// Finds the view's view controller.
    UIResponder *responder = self;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    // If the view controller isn't found, return nil.
    return nil;
}
//top up
-(BOOL)isTopupBalanceValid{
    
      return (![self isEmptyShowMessage:NSLocalizedString(@"Balance_Transfer_Amount_NotEmpty_Alert", nil)]&&[self isTopupBalacceValueValid]);
}

-(BOOL)isTopupBalacceValueValid{
    
    CGFloat value = [self.text floatValue];
    
    if (value <=0) {
        
        NSString *message =NSLocalizedString(@"Balance_Transfer_Amount_NotValid_Alert", nil);
        [AlertController showSimpleAlertWithTitle:nil message:message buttonTitle:NSLocalizedString(@"UIAlertView_Confirm_String", nil) inViewController:[self viewController]];
        return NO;
    }
    
    return YES;
}

@end
