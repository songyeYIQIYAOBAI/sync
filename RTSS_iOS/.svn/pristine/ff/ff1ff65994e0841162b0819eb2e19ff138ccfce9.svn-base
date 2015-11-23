//
//  ELineDataModel.m
//  SJB2
//
//  Created by shengyp on 14-6-19.
//  Copyright (c) 2014年 ailk. All rights reserved.
//

#import "ELineDataModel.h"

@implementation ELineDataModel
@synthesize label,valueString,value,index;

- (void)dealloc
{
	[label release];
	[valueString release];
	
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.label = @"";
		self.valueString = @"";
		self.value = 0;
		self.index = 0;
    }
    return self;
}

- (id)initWithLabel:(NSString*)aLabel valueText:(NSString*)valueText value:(CGFloat)aValue index:(NSInteger)aIndex
{
	self = [self init];
	if(self){
		if(nil != aLabel){
			self.label = aLabel;
		}
		if(nil != valueText){
			self.valueString = valueText;
		}
		self.value = aValue;
		self.index = aIndex;
	}
	return self;
}

@end
