//
//  AppTurboBoostModel.h
//  RTSS
//
//  Created by 加富董 on 14-10-29.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppTurboBoostModel : NSObject

@property (nonatomic,retain) NSString *appName;
@property (nonatomic,retain) NSString *appIcon;
@property (nonatomic,assign) int64_t appRateValue;
@property (nonatomic,assign) NSInteger appHour;
@property (nonatomic,assign) BOOL isActive;
@property (nonatomic,retain) NSString *expireDate; //时间格式yyyyMmdd HH:mm:ss

@end
