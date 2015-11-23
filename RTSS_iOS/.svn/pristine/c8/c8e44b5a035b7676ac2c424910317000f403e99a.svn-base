//
//  BudgetHistoryViewController.h
//  RTSS
//
//  Created by 加富董 on 15/1/18.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "BasicViewController.h"

typedef NS_ENUM(NSInteger, HistoryMainType) {
    HistoryMainTypeCreate = 1,
    HistoryMainTypeJoin,
};

typedef NS_ENUM(NSInteger, HistorySubType) {
    HistorySubTypeWallet = 1,
    HistorySubTypeUsage,
};


@interface BudgetHistoryModel : NSObject

@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSString *nameNumStr;
@property (nonatomic, retain) NSString *usageStr;
@property (nonatomic, assign) CGFloat percent;

@end

@interface BudgetHistoryViewController : BasicViewController

@property (nonatomic,assign)HistoryMainType historyMainType;
@property (nonatomic,assign)HistorySubType historySubType;

@end
