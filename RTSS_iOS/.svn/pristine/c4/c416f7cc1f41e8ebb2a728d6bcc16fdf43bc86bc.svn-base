//
//  AlertController.h
//  IOS7Test
//
//  Created by shengyp on 14/10/26.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AlertControllerStyle) {
    AlertControllerStyleDefault = 0,
    AlertControllerStyleSecureTextInput,
    AlertControllerStylePlainTextInput
};

typedef NS_ENUM(NSInteger, AlertControllerTextMode) {
    AlertControllerTextModeDefault = 0,
    AlertControllerTextModeNumber,
    AlertControllerTextModeDecimals,
    AlertControllerTextModeAlphanumeric,
};

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1

@interface AlertAction : UIAlertAction

@property(nonatomic, assign) NSInteger tag;

@end

#endif

@interface AlertController : UIView

@property(nonatomic, readonly)UIAlertView       *alertView;
@property(nonatomic, readonly)NSMutableArray    *alertTextFields;

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
@property(nonatomic, readonly)UIAlertController *alertController;
#endif

@property(nonatomic, readonly) NSInteger numberOfButtons;           //
@property(nonatomic, readonly) NSInteger cancelButtonIndex;         // default is -1 or 0 if cancelButtonTitle
@property(nonatomic, readonly) NSInteger firstOtherButtonIndex;     // -1 if no otherButtonTitles

@property(nonatomic, assign) NSTextAlignment titleTextAlignment;
@property(nonatomic, assign) NSTextAlignment messageTextAlignment;

// init
- (instancetype)initWithTitle:(NSString*)title message:(NSString *)message delegate:(id)delegate tag:(NSInteger)alertTag cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

// show (viewController is valid in ios8, not ios8 is nil)
- (void)showInViewController:(UIViewController*)viewController;

// add TextField
- (void)addTextFieldWithStyle:(AlertControllerStyle)style holder:(NSString*)holder leftView:(UIView*)leftView rightView:(UIView*)rightView textLength:(NSInteger)textLength textColor:(UIColor*)textColor textMode:(AlertControllerTextMode)mode;

// Retrieve a text field at an index
- (UITextField *)textFieldAtIndex:(NSInteger)textFieldIndex;

// viewController is valid in ios8, not ios8 is nil
+ (void)showSimpleAlertWithTitle:(NSString*)title message:(NSString*)message buttonTitle:(NSString*)buttonTitle inViewController:(UIViewController*)viewController;

@end

@protocol AlertControllerDelegate <NSObject>

@optional
- (void)alertController:(AlertController *)alertController didDismissWithButtonIndex:(NSInteger)buttonIndex;

@end




