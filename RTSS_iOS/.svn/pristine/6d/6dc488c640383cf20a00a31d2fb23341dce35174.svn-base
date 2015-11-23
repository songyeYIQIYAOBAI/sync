//
//  DateSelectionViewController.h
//  RTSS
//
//  Created by 蔡杰Alan on 14-11-25.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  DateSelctionDelegate;

@interface DateSelectionViewController : UIViewController

@property(nonatomic,assign)id<DateSelctionDelegate> delegate;

- (void)showFromViewController:(UIViewController *)parentViewController;

- (void)dismiss;

- (void)setMinDate:(NSDate*)minDate MaxDate:(NSDate*)maxDate;

@end

@protocol DateSelctionDelegate <NSObject>

- (void)dateSelectionViewController:(DateSelectionViewController *)vc didSelectDate:(NSDate *)aDate;

@end
