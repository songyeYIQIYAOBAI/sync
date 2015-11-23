//
//  EColumnDataModel.m
//  IOS7Test
//
//  Created by shengyp on 14-6-20.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "EColumnDataModel.h"

@implementation EColumnDataModel
@synthesize label,valueString,unit;

- (void)dealloc
{
	[label release];
	[unit release];
	[valueString release];
	
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.label = @"";
		self.valueString = @"";
		self.unit = @"";
		self.value = 0.0;
		self.averageValue = 0.0;
        self.maxValue = 0.0;
		self.index = 0;
    }
    return self;
}

- (id)initWithLabel:(NSString*)aLabel valueText:(NSString*)valueText value:(CGFloat)aValue averageValue:(CGFloat)aAverageValue maxValue:(CGFloat)aMaxValue index:(NSInteger)aIndex unit:(NSString*)aUnit groupId:(NSString *)groupId messureId:(NSInteger)messureId name:(NSString *)name
{
	self = [self init];
	if(self){
		if(nil != aLabel){
			self.label = aLabel;
		}
		if(nil != valueText){
			self.valueString = valueText;
		}
		if(nil != aUnit){
			self.unit = aUnit;
		}
		self.value          = aValue;
		self.averageValue   = aAverageValue;
        self.maxValue       = aMaxValue;
		self.index          = aIndex;
    
        self.groupId = groupId;
        self.messureId = messureId;
        self.name = name;
	}
	return self;
}

@end
