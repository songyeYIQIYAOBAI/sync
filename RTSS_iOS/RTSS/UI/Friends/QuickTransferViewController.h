//
//  QuickTransferViewController.h
//  RTSS
//
//  Created by 加富董 on 14-11-3.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "BasicViewController.h"

typedef NS_ENUM(NSInteger, SelectType) {
    SelectTypeBySingle,
    SelectTypeByMultiple,
};

@interface QuickTransferViewController : BasicViewController

@property (nonatomic, retain) NSMutableArray *historyArray;
@property (nonatomic, copy) void (^fetchFriendsInfoBlock) (NSMutableArray *friendsArray);
@property (nonatomic, assign) SelectType selectType;

@end