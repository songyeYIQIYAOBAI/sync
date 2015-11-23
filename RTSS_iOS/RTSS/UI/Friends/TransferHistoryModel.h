//
//  TransferHistoryModel.h
//  EasyTT
//
//  Created by 加富董 on 14-10-22.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TransferDirection) {
    TransferDirectionFromMe,
    TransferDirectionFromOther
};

@interface TransferHistoryModel : NSObject

@property (nonatomic,copy) NSString    *transferDate;
@property (nonatomic,copy) NSString    *transferAbstract;
@property (nonatomic,copy) NSString    *transferCategory;
@property (nonatomic,copy) NSString    *transferUserIcon;
@property (nonatomic,assign) TransferDirection transferDirection;

@end
