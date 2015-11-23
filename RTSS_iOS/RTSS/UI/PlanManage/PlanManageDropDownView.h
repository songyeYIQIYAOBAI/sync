//
//  PlanManageDropDownView.h
//  RTSS
//
//  Created by tiger on 14-11-4.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlanManageDropDownViewDelegate <NSObject>
@optional
-(void)adjustViewFrame:(float)offHeight IsDrop:(BOOL)isDrop;

@end

@interface PlanManageDropDownView : UIView

@property(nonatomic, retain)NSMutableArray *servicesArray;
@property(nonatomic, retain)UIButton * dropDownBtn;
@property(nonatomic, assign)id<PlanManageDropDownViewDelegate> delegate;

@end
