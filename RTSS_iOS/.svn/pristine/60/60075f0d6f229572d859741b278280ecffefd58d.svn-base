//
//  EPieDataModel.m
//  IOS7Test
//
//  Created by shengyp on 14-6-24.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "EPieDataModel.h"

@implementation EPieDataModel
@synthesize label,value,realValue,valueString;

- (void)dealloc
{
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.label = @"";
		self.value = 0.0;
		self.realValue = 0.0;
		self.valueString = @"";
    }
    return self;
}

- (id)initWithLabel:(NSString*)aLabel valueText:(NSString*)valueText value:(CGFloat)aValue realValue:(CGFloat)aRealValue index:(NSInteger)aIndex detailDatas:(NSArray*)aDetailDatas
{
	self = [self init];
	if(self){
		if(nil != aLabel){
			self.label = aLabel;
		}
		if(nil != valueText){
			self.valueString = valueText;
		}
		if(nil != aDetailDatas){
			self.detailArray = aDetailDatas;
		}
		self.value = aValue;
		self.realValue = aRealValue;
		self.index = aIndex;
	}
	return self;
}

@end
