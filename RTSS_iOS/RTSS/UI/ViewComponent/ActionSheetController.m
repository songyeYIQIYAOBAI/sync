//
//  ActionSheetController.m
//  RTSS
//
//  Created by shengyp on 14/10/27.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "ActionSheetController.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1

@implementation ActionSheetAction

@synthesize tag;

@end

#endif

@interface ActionSheetController ()<UIActionSheetDelegate>

@property(nonatomic, assign) id<ActionSheetControllerDelegate> _delegate;

@end

@implementation ActionSheetController
@synthesize actionSheet, cancelButtonIndex, destructiveButtonIndex, firstOtherButtonIndex, numberOfButtons, _delegate;

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
@synthesize actionController;
#endif

- (void)dealloc{
    
    [super dealloc];
}

- (instancetype)initWithTitle:(NSString *)title delegate:(id)delegate tag:(NSInteger)sheetTag cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    
    self = [super init];
    if(self){
        _delegate = delegate;
        self.tag = sheetTag;
        numberOfButtons = 0;
        cancelButtonIndex = -1;
        destructiveButtonIndex = -1;
        firstOtherButtonIndex = -1;
        
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
            actionController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
#endif
        }else{
            actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:(nil == _delegate ? nil : self) cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil,nil];
            actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        }
        
        if(nil != destructiveButtonTitle){
            destructiveButtonIndex = 0;
            numberOfButtons ++;
            
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
            if(nil != actionController){
                ActionSheetAction *sheetAction = [ActionSheetAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    [self callBackWithButtonIndex:destructiveButtonIndex];
                }];
                [actionController addAction:sheetAction];
            }else{
                actionSheet.destructiveButtonIndex = [actionSheet addButtonWithTitle:destructiveButtonTitle];
            }
#else
            actionSheet.destructiveButtonIndex = [actionSheet addButtonWithTitle:destructiveButtonTitle];
#endif
        }
        
        if(nil != otherButtonTitles){
            firstOtherButtonIndex = destructiveButtonIndex == -1 ? 0 : 1;
            numberOfButtons ++;
            
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
            if(nil != actionController){
                ActionSheetAction *sheetAction = [ActionSheetAction actionWithTitle:otherButtonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self callBackWithButtonIndex:firstOtherButtonIndex];
                }];
                [actionController addAction:sheetAction];
            }else {
                [actionSheet addButtonWithTitle:otherButtonTitles];
            }
#else
            [actionSheet addButtonWithTitle:otherButtonTitles];
#endif
        }
        
        for (int i = 0; i < [argsArray count]; i ++) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
            if(nil != actionController){
                ActionSheetAction *sheetAction = [ActionSheetAction actionWithTitle:[argsArray objectAtIndex:i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [self callBackWithButtonIndex:((ActionSheetAction*)action).tag];
                }];
                sheetAction.tag = firstOtherButtonIndex+1+i;
                [actionController addAction:sheetAction];
            }else{
                [actionSheet addButtonWithTitle:[argsArray objectAtIndex:i]];
            }
#else
            [actionSheet addButtonWithTitle:[argsArray objectAtIndex:i]];
#endif
        }
        
        if(nil != cancelButtonTitle){
            numberOfButtons ++;
            
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
            if(nil != actionController){
                ActionSheetAction *sheetAction = [ActionSheetAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [self callBackWithButtonIndex:cancelButtonIndex];
                }];
                [actionController addAction:sheetAction];
            }else{
                cancelButtonIndex = [actionSheet addButtonWithTitle:cancelButtonTitle];
                actionSheet.cancelButtonIndex = cancelButtonIndex;
            }
#else
            cancelButtonIndex = [actionSheet addButtonWithTitle:cancelButtonTitle];
            actionSheet.cancelButtonIndex = cancelButtonIndex;
#endif
        }
        
        numberOfButtons += [argsArray count];

        [argsArray release];
    }
    
    return self;
}


- (void)showInViewController:(UIViewController*)viewController{
    [viewController.view.window addSubview:self];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if(nil != actionController){
        [viewController presentViewController:actionController animated:YES completion:nil];
    }else{
        [actionSheet showInView:viewController.view];
        [actionSheet release];
        actionSheet = nil;
    }
#else
    [actionSheet showInView:viewController.view];
    [actionSheet release];
    actionSheet = nil;
#endif
}
 

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    [self callBackWithButtonIndex:buttonIndex];
}

- (void)callBackWithButtonIndex:(NSInteger)buttonIndex{
    if(nil != _delegate && [_delegate respondsToSelector:@selector(actionSheetController:didDismissWithButtonIndex:)]){
        [_delegate actionSheetController:self didDismissWithButtonIndex:buttonIndex];
    }
    
    if(nil != [self superview]){
        [self removeFromSuperview];
    }
}

@end
