//
//  UsageAlertListModel.m
//  RTSS
//
//  Created by tiger on 14-11-26.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "UsageAlertListModel.h"

@implementation UsageAlertListModel
@synthesize layer,isOpen,children,content,notificationValue;

-(void)addChild:(UsageAlertListModel *)model
{
    if (!self.children) {
        self.children = [NSMutableArray array];
    }
    [self.children addObject:model];
}

-(void)dealloc
{
    self.children = nil;
    self.content = nil;
    self.notificationValue = nil;
    [super dealloc];
}
@end
