//
//  BudgetControlViewController.h
//  RTSS
//
//  Created by baisw on 14/10/23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "BasicViewController.h"
#import "JoinGroupViewController.h"
#import "SinglePickerController.h"
#import "MemberScrollView.h"

typedef NS_ENUM(NSInteger, BudgetViewStyle){
    BudgetViewFamily = 0,
    BudgetViewMember = 1,
};

@interface BudgetControlViewController : BasicViewController <FaceToFaceVCDelegate, SinglePickerDelegate, MemberScrollViewDelegate>

@end
