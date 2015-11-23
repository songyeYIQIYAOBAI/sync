//
//  Friends.h
//  RTSS
//
//  Created by Lyu Ming on 11/3/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"

@interface Friends : NSObject

//获取全局唯一单利对象
+ (Friends *)shareFriends;

//获取friends数据
- (NSArray*)friends:(int)limit;

//添加friend
- (void)add:(User*)person;

//删除friend
- (void)remove:(User*)person;

@end
