//
//  LoginViewController.h
//  RTSS
//
//  Created by shengyp on 14/10/23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "BasicViewController.h"

@interface LoginViewController : BasicViewController<UITextFieldDelegate, UIGestureRecognizerDelegate>

@property(nonatomic, assign) BasicViewControllerFunctionType functionType;

@end
