//
//  EPieChart.m
//  IOS7Test
//
//  Created by shengyp on 14-6-24.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "EPieChart.h"
#import "EPie.h"
#import "EPieRotated.h"

@interface EPieChart()<EPieDelegate,EPieDataSource,EPieRotatedDataSource,EPieRotatedDelegate>
{
	EPie* ePieView;
	EPieRotated* ePieRotatedView;
	BOOL isRotated;
}

@end

@implementation EPieChart
@synthesize dataSource,delegate;

- (void)dealloc
{
	[ePieView release];
	[ePieRotatedView release];
	
	self.dataSource = nil;
	self.delegate = nil;
	
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame isRotated:(BOOL)rotated
{
	self = [super initWithFrame:frame];
	if(self){
		isRotated = rotated;
		if(rotated){
			ePieRotatedView = [[EPieRotated alloc] initWithFrame:self.bounds];
			ePieRotatedView.backgroundColor = [UIColor clearColor];
			ePieRotatedView.dataSource = self;
			ePieRotatedView.delegate = self;
			[self addSubview:ePieRotatedView];
		}else{
			ePieView = [[EPie alloc] initWithFrame:self.bounds];
			ePieView.backgroundColor = [UIColor clearColor];
			ePieView.dataSource = self;
			ePieView.delegate = self;
			[self addSubview:ePieView];
		}
	}
	return self;
}

- (void)reloadChart
{
	if(isRotated){
		[ePieRotatedView reloadPieRotated];
	}else{
		[ePieView reloadPie];
	}
}

- (NSInteger)numberOfSlicesInEPie:(EPie*)pie
{
	return [dataSource numberOfSlicesInEPieChart:self];
}

- (EPieDataModel*)pie:(EPie*)pie valueForSliceAtIndex:(NSInteger)index
{
	return [dataSource pieChart:self valueForSliceAtIndex:index];
}

- (UIColor*)pie:(EPie*)pie colorForSliceAtIndex:(NSInteger)index
{
	return [dataSource pieChart:self colorForSliceAtIndex:index];
}

- (NSInteger)numberOfSlicesInEPieRotated:(EPieRotated*)pieRotated
{
	return [dataSource numberOfSlicesInEPieChart:self];
}

- (EPieDataModel*)pieRotated:(EPieRotated*)pieRotated valueForSliceAtIndex:(NSInteger)index
{
	return [dataSource pieChart:self valueForSliceAtIndex:index];
}

- (UIColor*)pieRotated:(EPieRotated*)pieRotated colorForSliceAtIndex:(NSInteger)index
{
	return [dataSource pieChart:self colorForSliceAtIndex:index];
}

- (void)selectedFinish:(EPieRotated*)pieRotated index:(NSInteger)index percent:(CGFloat)per
{
	if(nil != delegate && [delegate respondsToSelector:@selector(selectedPieChart:index:percent:)]){
		[delegate selectedPieChart:self index:index percent:per];
	}
}

- (void)pieRotated:(EPieRotated*)pieRotated willSelectSliceAtIndex:(NSUInteger)index
{
	if(nil != delegate && [delegate respondsToSelector:@selector(pieChart:willSelectSliceAtIndex:)]){
		[delegate pieChart:self willSelectSliceAtIndex:index];
	}
}

- (void)pieRotated:(EPieRotated*)pieRotated didSelectSliceAtIndex:(NSUInteger)index
{
	if(nil != delegate && [delegate respondsToSelector:@selector(pieChart:didSelectSliceAtIndex:)]){
		[delegate pieChart:self didSelectSliceAtIndex:index];
	}
}

- (void)pieRotated:(EPieRotated*)pieRotated willDeselectSliceAtIndex:(NSUInteger)index
{
	if(nil != delegate && [delegate respondsToSelector:@selector(pieChart:willDeselectSliceAtIndex:)]){
		[delegate pieChart:self willDeselectSliceAtIndex:index];
	}
}

- (void)pieRotated:(EPieRotated*)pieRotated didDeselectSliceAtIndex:(NSUInteger)index
{
	if(nil != delegate && [delegate respondsToSelector:@selector(pieChart:didDeselectSliceAtIndex:)]){
		[delegate pieChart:self didDeselectSliceAtIndex:index];
	}
}

@end
