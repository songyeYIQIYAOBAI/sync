//
//  ActivationViewController.h
//  RTSS
//
//  Created by Lyu Ming on 11/24/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import "BasicViewController.h"

@interface ActivationViewController : BasicViewController<UITextFieldDelegate>

@property(nonatomic, retain) NSString* userId;
@property(nonatomic, retain) NSString* phoneMobile;

@end
