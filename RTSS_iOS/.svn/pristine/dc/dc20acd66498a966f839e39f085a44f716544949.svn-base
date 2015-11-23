//
//  UsageAlertListModel.h
//  RTSS
//
//  Created by tiger on 14-11-26.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kMaxLayer 2
#define kMinLayer 1

@interface UsageAlertListModel : NSObject

@property(nonatomic,retain) NSMutableArray* children; //孩子
@property(nonatomic,assign) BOOL isOpen; //是否打开
@property(nonatomic,assign) NSInteger layer; //当前层
@property(nonatomic,copy) NSString* content; //内容
@property(nonatomic,copy) NSString* notificationValue; //提醒值

-(void)addChild:(UsageAlertListModel*)model;

@end
