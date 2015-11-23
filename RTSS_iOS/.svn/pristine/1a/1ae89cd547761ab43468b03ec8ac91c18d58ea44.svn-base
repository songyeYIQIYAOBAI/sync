//
//  FindPasswordViewController.h
//  RTSS
//
//  Created by shengyp on 14/10/23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "BasicViewController.h"
#import "UserInfoComponentView.h"

@interface FindPasswordDataModel : NSObject

@property(nonatomic, retain) NSString* userId;
@property(nonatomic, retain) NSString* otp;
@property(nonatomic, retain) NSString* desiredPassword;

@end

@interface FindPasswordViewController : BasicViewController<UITextFieldDelegate>

@property(nonatomic, assign) UserInfoComponentViewType viewType;

@property(nonatomic, retain) FindPasswordDataModel* dataModel;

@end
