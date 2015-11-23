//
//  TransferHistoryModel.m
//  EasyTT
//
//  Created by 加富董 on 14-10-22.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import "TransferHistoryModel.h"

@implementation TransferHistoryModel

@synthesize transferDate = _transferDate,transferAbstract = _transferAbstract,transferCategory = _transferCategory,transferUserIcon = _transferUserIcon;

- (void) dealloc
{
    self.transferDate = nil;
    self.transferAbstract = nil;
    self.transferCategory = nil;
    self.transferUserIcon = nil;
    
    [super dealloc];
}

@end
