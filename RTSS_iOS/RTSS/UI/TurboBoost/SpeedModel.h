//
//  SpeedModel.h
//  RTSS
//
//  Created by 加富董 on 14/12/1.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpeedModel : NSObject

@property (nonatomic,assign) CGFloat speedValue;
@property (nonatomic,retain) NSString *speedUnit;
@property (nonatomic,assign) CGFloat speedPrice;

@end
