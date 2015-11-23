//
//  CustomizedSlider.m
//  EasyTT
//
//  Created by lvming on 12-12-5.
//  Copyright (c) 2012年 lvming. All rights reserved.
//

#import "CustomizedSlider.h"

@implementation CustomizedSlider

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		// Initialization code
	}
	return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	// Drawing code
}
*/

- (CGRect)trackRectForBounds:(CGRect)bounds {
	CGRect modifiedBounds = [super trackRectForBounds:bounds];
	modifiedBounds.size.height = 37;
	
	return modifiedBounds;
}

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
	CGRect modifiedBounds = [super thumbRectForBounds:bounds trackRect:rect value:value];
	modifiedBounds.origin.y = 0;
	modifiedBounds.size.width = 37;
	modifiedBounds.size.height = 37;
	
	return modifiedBounds;
}

@end
