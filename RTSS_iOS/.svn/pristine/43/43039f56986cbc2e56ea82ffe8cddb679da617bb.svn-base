//
//  Message.m
//  librtss
//
//  Created by 刘艳峰 on 4/20/15.
//  Copyright (c) 2015 Ming Lyu. All rights reserved.
//

#import "MessageItem.h"

@implementation MessageItem

@synthesize mMessageId;
@synthesize mMessageType;
@synthesize mFromCode;
@synthesize mFromName;
@synthesize mTimeStamp;

@synthesize mTitle;
@synthesize mContent;
@synthesize mHref;

@synthesize mHasRead;

@synthesize mMsgObject;

- (void)dealloc {
    [mMessageId release];
    [mFromCode release];
    [mFromName release];
    
    [mTitle release];
    [mContent release];
    [mHref release];
    
    [mMsgObject release];
    
    [super dealloc];
}

@end
