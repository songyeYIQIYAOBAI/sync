//
//  FlowDateSearchVC.h
//  EasyTT
//
//  Created by sheng yinpeng on 13-6-4.
//  Copyright (c) 2013年 lvming. All rights reserved.
//

#import "BasicViewController.h"

@protocol FlowDateSearchDelegate;
@interface FlowDateSearchVC : BasicViewController
{
    CGRect initPickerViewFrame;
    CGRect choosePickerViewFrame;
    UIView* pickerView;
    UIDatePicker* pickerControl;
    UIButton* startTimeButton;
    UIButton* endTimeButton;
    UIButton* currentSelectButton;
    NSDate* startDate;
    NSDate* endDate;
    
    id<FlowDateSearchDelegate> delegate;
}

@property(nonatomic,retain)NSDate* startDate;
@property(nonatomic,retain)NSDate* endDate;
@property(nonatomic,assign)id<FlowDateSearchDelegate> delegate;

@end

@protocol FlowDateSearchDelegate <NSObject>
@required
- (void)flowDateStart:(NSDate*)start dateEnd:(NSDate*)end;

@end
