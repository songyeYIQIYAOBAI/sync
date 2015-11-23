//
//  ActionSheetController.h
//  RTSS
//
//  Created by shengyp on 14/10/27.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1

@interface ActionSheetAction : UIAlertAction

@property(nonatomic, assign) NSInteger tag;

@end

#endif


@interface ActionSheetController : UIView

@property(nonatomic, readonly) UIActionSheet        *actionSheet;

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
@property(nonatomic, readonly) UIAlertController    *actionController;
#endif

@property(nonatomic, readonly) NSInteger numberOfButtons;
@property(nonatomic, readonly) NSInteger cancelButtonIndex;         // default is -1 or 0 if cancelButtonTitle
@property(nonatomic, readonly) NSInteger destructiveButtonIndex;    // default is -1 or 0 if destructiveButtonTitle
@property(nonatomic, readonly) NSInteger firstOtherButtonIndex;     // -1 if no otherButtonTitles

// init
- (instancetype)initWithTitle:(NSString *)title delegate:(id)delegate tag:(NSInteger)sheetTag cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

// show (viewController is valid in ios8, not ios8 is nil)
- (void)showInViewController:(UIViewController*)viewController;

@end

@protocol ActionSheetControllerDelegate <NSObject>

@optional
- (void)actionSheetController:(ActionSheetController *)controller didDismissWithButtonIndex:(NSInteger)buttonIndex;

@end
