//
//  FriendsViewController.h
//  RTSS
//
//  Created by dongjf on 14/10/23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "BasicViewController.h"

typedef NS_ENUM(NSInteger, FriendsActionType) {
    FriendsActionTypePickFriends,
    FriendsActionTypeDisplayHistory,
};

@class User;

@interface FriendsViewController : BasicViewController

@property (nonatomic, assign) FriendsActionType actionType;
@property (nonatomic, copy) void (^transferFriendInfoBlock) (User *friendInfo);

@end
