//
//  WaitingView.m
//  RTSS
//
//  Created by shengyp on 14/10/31.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "WaitingView.h"

@implementation WaitingView
@synthesize activityIndicator;

- (void)dealloc
{
    [activityIndicator release];
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.5;
        
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.frame = CGRectMake(0, 0, 60, 60);
        activityIndicator.center = self.center;
        [self addSubview:activityIndicator];
    }
    return self;
}

- (void)startWaiting
{
    if(NO == [activityIndicator isAnimating]){
        [activityIndicator startAnimating];
    }
}

- (void)stopWaiting
{
    if(YES == [activityIndicator isAnimating]){
        [activityIndicator stopAnimating];
    }
}

@end
