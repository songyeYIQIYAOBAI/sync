//
//  DateFootprintDelegate.h
//  RTSS
//
//  Created by 蔡杰Alan on 15-3-4.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ServiceRequestActionType) {
    
    ServiceRequestActionTypeBegin       = 99,
    ServiceRequestActionTypeAdd        =  100,
    ServiceRequestActionTypeAll        =  101,
    ServiceRequestActionTypeOpen       =  102,
    ServiceRequestActionTypeClosed     =  103,
    ServiceRequestActionTypeQueries    =  104,
    ServiceRequestActionTypeRequests   =  105,
    ServiceRequestActionTypeComplains  =  106,
    ServiceRequestActionTypeEnd        = 1000
};


@protocol DateFootprintDelegate<NSObject>

- (void)updateUserDate:(NSDate*)aDate;

@optional

-(void)serviceRequestActionType:(NSString *)actionType;

@end

static NSString *ServiceRequestActionTypeToString(ServiceRequestActionType type){
    
    switch((int)type){
        case ServiceRequestActionTypeAll:{
            return @"All";
            break;
        }
        case ServiceRequestActionTypeClosed:{
            return @"Closed";
            break;
        }
        case ServiceRequestActionTypeComplains:{
            return @"Complains";
            break;
        }
        case ServiceRequestActionTypeQueries:{
            return @"Queries";
            break;
        }
        case ServiceRequestActionTypeRequests:{
            return @"Requests";
            break;
        }
        case ServiceRequestActionTypeOpen:{
            return @"Open";
            break;
        }
        default:
            return @"";
    }
    return nil;
    
}