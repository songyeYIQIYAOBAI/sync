//
//  RTSSLocation.h
//  RTSS
//
//  Created by shengyp on 14/12/3.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol RTSSLocationDelegate <NSObject>

- (void)locationServicesEnabled:(BOOL)enabled;
- (void)locationFinished:(CLLocation*)location;
- (void)locationFailed:(NSError*)error;

@end

@interface RTSSLocation : NSObject<CLLocationManagerDelegate>

@property(nonatomic, assign) id<RTSSLocationDelegate> delegate;

@property(nonatomic, assign) BOOL updatingLocationFinishedStopLocation;//更新定位成功之后是否停止更新 default NO

@property(nonatomic, assign) BOOL updatingLocationFinishedCloseLocation;//更新定位成功之后是否关闭定位 default NO

- (void)startUpdatingLocation;

- (void)stopUpdatingLocation;

@end
