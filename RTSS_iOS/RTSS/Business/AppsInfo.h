//
//  AppsInfo.h
//  RTSS
//
//  Created by 刘艳峰 on 5/19/15.
//  Copyright (c) 2015 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppsInfo : NSObject

@property (nonatomic, retain) NSString *mAppId;
@property (nonatomic, retain) NSString *mPackageName;   //optional
@property (nonatomic, retain) NSString *mName;
@property (nonatomic, retain) NSString *mIconUrl;
@property (nonatomic, assign) int mSpeededUp;
@property (nonatomic, assign) int mPriority;

@end
