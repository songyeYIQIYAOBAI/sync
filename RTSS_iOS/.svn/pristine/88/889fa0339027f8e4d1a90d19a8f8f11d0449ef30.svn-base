//
//  AlertController.m
//  IOS7Test
//
//  Created by shengyp on 14/10/26.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "AlertController.h"
#import "RTSSAppDefine.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1

@implementation AlertAction

@synthesize tag;

@end

#endif

@interface AlertController()<UIAlertViewDelegate, UITextFieldDelegate>

@property(nonatomic, retain) id<AlertControllerDelegate> _delegate;

@property(nonatomic, assign) AlertControllerTextMode textMode;

@property(nonatomic, assign) NSInteger textMaxLength;

@end

@implementation AlertController
@synthesize alertView, cancelButtonIndex, firstOtherButtonIndex, numberOfButtons, _delegate, alertTextFields,textMode,textMaxLength;
@synthesize titleTextAlignment, messageTextAlignment;

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
@synthesize alertController;

#endif

- (void)dealloc{
    [_delegate release];
    [alertTextFields release];
    
    [super dealloc];
}

- (instancetype)initWithTitle:(NSString*)title message:(NSString *)message delegate:(id)delegate tag:(NSInteger)alertTag cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    self = [super init];
    if (self) {
        self._delegate = delegate;
        self.tag = alertTag;
        numberOfButtons = 0;
        cancelButtonIndex = -1;
        firstOtherButtonIndex = -1;
        textMaxLength = -1;
        titleTextAlignment = NSTextAlignmentCenter;
        messageTextAlignment = NSTextAlignmentCenter;
        
        alertTextFields = [[NSMutableArray alloc] initWithCapacity:0];
        
        // 遍历函数参数列表
        NSMutableArray* argsArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        id arg;
        va_list argList;
        if(nil != otherButtonTitles){
            va_start(argList, otherButtonTitles);
            while ((arg = va_arg(argList,id))) {
                [argsArray addObject:arg];
            }
            va_end(argList);
        }
        
        // 根据版本创建相应的提示框
        if([[UIDevice currentDevice].systemVersion floatValue] >= 8.0){
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
            alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
#endif
        }else{
            alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:(nil == _delegate ? nil : self) cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
        }
        
        if(nil != cancelButtonTitle){
            cancelButtonIndex = 0;
            numberOfButtons ++;
            
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
            if(nil != alertController){
                AlertAction *alertAction = [AlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    // TODO
                    [self callBackWithButtonIndex:cancelButtonIndex];
                }];
                [alertController addAction:alertAction];
            }
#endif
        }
        
        if(nil != otherButtonTitles){
            firstOtherButtonIndex = cancelButtonIndex == -1 ? 0 : 1;
            numberOfButtons ++;
            
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
            if(nil != alertController){
                AlertAction *alertAction = [AlertAction actionWithTitle:otherButtonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    // TODO
                    [self callBackWithButtonIndex:firstOtherButtonIndex];
                }];
                [alertController addAction:alertAction];
            }
#endif
        }
        
        for (int i = 0; i < [argsArray count]; i ++) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
            if(nil != alertController){
                AlertAction * alertAction = [AlertAction actionWithTitle:[argsArray objectAtIndex:i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    // TODO
                    [self callBackWithButtonIndex:((AlertAction*)action).tag];
                }];
                alertAction.tag = firstOtherButtonIndex+1+i;
                [alertController addAction:alertAction];
            }else{
                [alertView addButtonWithTitle:[argsArray objectAtIndex:i]];
            }
#else
            [alertView addButtonWithTitle:[argsArray objectAtIndex:i]];
#endif
        }
        
        numberOfButtons += [argsArray count];
        
        [argsArray release];
    }
    return self;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment text:(NSString*)text textKey:(NSString*)textKey{
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = textAlignment;
    
    NSMutableDictionary* attributeDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [attributeDic setObject:style forKey:NSParagraphStyleAttributeName];
    
    [style release];
    
    NSMutableAttributedString* attibuteString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributeDic];
    [alertController setValue:attibuteString forKey:textKey];
    [attibuteString release];
}

- (void)setAlertViewMessageLabel{
    CGSize size = CGSizeMake(PHONE_UISCREEN_WIDTH-80, MAXFLOAT);
    
    NSDictionary* messageDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0],NSFontAttributeName, nil];
    CGSize messageSize = [alertView.message boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:messageDic context:nil].size;
    
    UILabel* messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, messageSize.height)];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.font = [UIFont systemFontOfSize:15.0];
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = self.messageTextAlignment;
    messageLabel.text = alertView.message;
    [alertView setValue:messageLabel forKey:@"accessoryView"];
    [messageLabel release];
    
    alertView.message = @"";
}

- (void)showTextAlignment{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if(nil != alertController){
        if(NSTextAlignmentCenter != self.titleTextAlignment){
            [self setTextAlignment:self.titleTextAlignment text:alertController.title textKey:@"attributedTitle"];
        }
        if(NSTextAlignmentCenter != self.messageTextAlignment){
            [self setTextAlignment:self.messageTextAlignment text:alertController.message textKey:@"attributedMessage"];
        }
    }else{
        if(NSTextAlignmentCenter != self.messageTextAlignment){
            [self setAlertViewMessageLabel];
        }
    }
#else
    if(NSTextAlignmentCenter != self.messageTextAlignment){
        [self setAlertViewMessageLabel];
    }
#endif
}

- (void)showInViewController:(UIViewController*)viewController{
    [viewController.view.window addSubview:self];
    
    [self showTextAlignment];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if(nil != alertController){
        [viewController presentViewController:alertController animated:YES completion:nil];
    }else{
        [alertView show];
        [alertView release];
        alertView = nil;
    }
#else
    [alertView show];
    [alertView release];
    alertView = nil;
#endif
}

- (void)addTextFieldWithStyle:(AlertControllerStyle)style holder:(NSString*)holder leftView:(UIView*)leftView rightView:(UIView*)rightView textLength:(NSInteger)textLength textColor:(UIColor*)textColor textMode:(AlertControllerTextMode)mode{
    switch (style) {
        case AlertControllerStylePlainTextInput:{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
            if(nil != alertController){
                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    textField.secureTextEntry = NO;
                    textField.placeholder = holder;
                    textField.delegate = self;
                    textField.keyboardType = UIKeyboardTypeNumberPad;
                    textField.textColor = textColor;
                    if(nil != leftView){
                        textField.leftViewMode = UITextFieldViewModeAlways;
                        textField.leftView = leftView;
                    }
                    if(nil != rightView){
                        textField.rightViewMode = UITextFieldViewModeAlways;
                        textField.rightView = rightView;
                    }
                    self.textMaxLength = textLength;
                    self.textMode = mode;
                }];
            }else{
                alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                UITextField* textField = [alertView textFieldAtIndex:0];
                if(nil != textField){
                    [alertTextFields addObject:textField];
                    textField.secureTextEntry = NO;
                    textField.placeholder = holder;
                    textField.delegate = self;
                    textField.keyboardType = UIKeyboardTypeNumberPad;
                    textField.textColor = textColor;
                    if(nil != leftView){
                        textField.leftViewMode = UITextFieldViewModeAlways;
                        textField.leftView = leftView;
                    }
                    if(nil != rightView){
                        textField.rightViewMode = UITextFieldViewModeAlways;
                        textField.rightView = rightView;
                    }
                    self.textMaxLength = textLength;
                    self.textMode = mode;
                }
            }
#else
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField* textField = [alertView textFieldAtIndex:0];
            if(nil != textField){
                [alertTextFields addObject:textField];
                textField.secureTextEntry = NO;
                textField.placeholder = holder;
                textField.delegate = self;
                textField.keyboardType = UIKeyboardTypeNumberPad;
                textField.textColor = textColor;
                if(nil != leftView){
                    textField.leftViewMode = UITextFieldViewModeAlways;
                    textField.leftView = leftView;
                }
                if(nil != rightView){
                    textField.rightViewMode = UITextFieldViewModeAlways;
                    textField.rightView = rightView;
                }
                self.textMaxLength = textLength;
                self.textMode = mode;
            }
#endif
            break;
        }
        case AlertControllerStyleSecureTextInput:{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
            if(nil != alertController){
                [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                    textField.secureTextEntry = YES;
                    textField.placeholder = holder;
                    textField.keyboardType = UIKeyboardTypeNumberPad;
                }];
            }else{
                alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
                UITextField* textField = [alertView textFieldAtIndex:0];
                if(nil != textField){
                    [alertTextFields addObject:textField];
                    textField.secureTextEntry = YES;
                    textField.placeholder = holder;
                    textField.keyboardType = UIKeyboardTypeNumberPad;
                }
            }
#else
            alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
            UITextField* textField = [alertView textFieldAtIndex:0];
            if(nil != textField){
                [alertTextFields addObject:textField];
                textField.secureTextEntry = YES;
                textField.placeholder = holder;
                textField.keyboardType = UIKeyboardTypeNumberPad;
            }
#endif
            break;
        }
        default:
            break;
    }
}

- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if(nil != alertController){
        if(textFieldIndex < [alertController.textFields count]){
            return [alertController.textFields objectAtIndex:textFieldIndex];
        }
    }else{
        if(textFieldIndex < [alertTextFields count]){
            return [alertTextFields objectAtIndex:textFieldIndex];
        }
    }
    return nil;
#else
    if(textFieldIndex < [alertTextFields count]){
        return [alertTextFields objectAtIndex:textFieldIndex];
    }
    return nil;
#endif
}

+ (void)showSimpleAlertWithTitle:(NSString*)title message:(NSString*)message buttonTitle:(NSString*)buttonTitle inViewController:(UIViewController*)viewController{
    AlertController* alert = [[AlertController alloc] initWithTitle:title message:message delegate:self tag:0 cancelButtonTitle:buttonTitle otherButtonTitles:nil,nil];
    [alert showInViewController:viewController];
    [alert release];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL basicTest = NO;
    if(-1 == self.textMaxLength || range.location < self.textMaxLength){
        NSCharacterSet* cs = nil;
        if(AlertControllerTextModeNumber == self.textMode){
            cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBER_TEXT] invertedSet];
        }else if(AlertControllerTextModeDecimals == self.textMode){
            cs = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        }else if(AlertControllerTextModeAlphanumeric == self.textMode){
            cs = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        }else{
            basicTest = YES;
        }
        if(nil != cs){
            NSString* filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            basicTest = [string isEqualToString:filtered];
            if((nil == textField.text || 0 == textField.text.length) && [string isEqualToString:@"0"]){
                basicTest = NO;
            }
        }
    }
    if ([string isEqualToString:@""]) {
        basicTest = YES;
    }
    
    return basicTest;
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    [self callBackWithButtonIndex:buttonIndex];
}

- (void)callBackWithButtonIndex:(NSInteger)buttonIndex{
    
    if(nil != _delegate && [_delegate respondsToSelector:@selector(alertController:didDismissWithButtonIndex:)]){
        [_delegate alertController:self didDismissWithButtonIndex:buttonIndex];
    }
    
    if (nil != [self superview]) {
         [self removeFromSuperview];
    }
}

@end
