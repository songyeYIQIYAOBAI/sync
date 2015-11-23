//
//  UsageModel.m
//  RTSS
//
//  Created by 蔡杰Alan on 14-12-6.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "UsageModel.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"

@implementation UsageModel

+(float)transformeWithNumerical:(long long)numer byMessureId:(RTSSMessureId)messureId{
    
    CGFloat transformion = 0;
    switch (messureId) {
        case RTSSMessureIdData:{
            transformion = [CommonUtils formatDataFromByteToMB:numer];
             break;
        }
        case RTSSMessureIdSMS:{
            transformion =(CGFloat)numer;
            break;
        }
        case RTSSMessureIdTime:{
            transformion = [CommonUtils formatTimeFromSecondToMinute:numer];
            break;
        }
        case RTSSMessureIdAmount:{
            transformion = [CommonUtils formatMoneyFromPennyToYuan:numer];
        }
            
        default:
            break;
    }
    
    return transformion;
}

+(NSString*)unitByMessureId:(RTSSMessureId)MessureId{
    
    switch (MessureId) {
        case RTSSMessureIdData:{
            return @"MB";
            break;
        }
        case RTSSMessureIdAmount:{
            return @"";
            break;
        }
        case RTSSMessureIdTime:{
            return @"Min";
            break;
        }
        case RTSSMessureIdSMS:{
            return @"";
            break;
        }
            
        default:
            return @"";
            break;
    }
    
    return @"";
}


@end
