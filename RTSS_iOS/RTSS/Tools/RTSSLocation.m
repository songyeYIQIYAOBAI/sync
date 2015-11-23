//
//  RTSSLocation.m
//  RTSS
//
//  Created by shengyp on 14/12/3.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "RTSSLocation.h"
#import "RTSSAppDefine.h"

@interface RTSSLocation ()

@property(nonatomic, readonly) CLLocationManager*   locationManager;

@end

@implementation RTSSLocation
@synthesize locationManager,delegate;
@synthesize updatingLocationFinishedStopLocation,updatingLocationFinishedCloseLocation;

- (void)dealloc
{
    [self stopUpdatingLocation];
    [locationManager release];
    
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.updatingLocationFinishedStopLocation = NO;
        self.updatingLocationFinishedCloseLocation = NO;
        [self initLocationManager];
    }
    return self;
}

- (void)initLocationManager
{
    if(nil == locationManager){
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        locationManager.distanceFilter = 100;
        locationManager.delegate = self;
    }
}

- (void)startUpdatingLocation{
    
    CLAuthorizationStatus authorizationAlways       = kCLAuthorizationStatusAuthorized;
    CLAuthorizationStatus authorizationWhenInUse    = kCLAuthorizationStatusAuthorized;
    if(SYSTEM_VERSION_IOS8){
        authorizationAlways    = kCLAuthorizationStatusAuthorizedAlways;
        authorizationWhenInUse = kCLAuthorizationStatusAuthorizedWhenInUse;
    }

    if([CLLocationManager locationServicesEnabled] &&
       ([CLLocationManager authorizationStatus] == authorizationAlways ||
        [CLLocationManager authorizationStatus] == authorizationWhenInUse)){
        if(nil != delegate && [delegate respondsToSelector:@selector(locationServicesEnabled:)]){
            [delegate locationServicesEnabled:YES];
        }
    }else{
        if(nil != delegate && [delegate respondsToSelector:@selector(locationServicesEnabled:)]){
            [delegate locationServicesEnabled:NO];
        }
    }
    
    [self initLocationManager];
    
    if(nil != locationManager){
        if([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
            [locationManager requestWhenInUseAuthorization];
        }
        [locationManager startUpdatingLocation];
    }
}

- (void)stopUpdatingLocation{
    if(nil != locationManager){
        [locationManager stopUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    if (self.updatingLocationFinishedStopLocation) {
        [self stopUpdatingLocation];
    }
    if(self.updatingLocationFinishedCloseLocation){
        if(NO == self.updatingLocationFinishedStopLocation){
            [self stopUpdatingLocation];
        }
        [locationManager release];
    }
    
    if(nil != delegate && [delegate respondsToSelector:@selector(locationFinished:)]){
        [delegate locationFinished:[locations lastObject]];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if(self.updatingLocationFinishedStopLocation){
        [self stopUpdatingLocation];
    }
    if(self.updatingLocationFinishedCloseLocation){
        if(NO == self.updatingLocationFinishedStopLocation){
            [self stopUpdatingLocation];
        }
        [locationManager release];
    }
    if(nil != delegate && [delegate respondsToSelector:@selector(locationFailed:)]){
        [delegate locationFailed:error];
    }
}

@end
