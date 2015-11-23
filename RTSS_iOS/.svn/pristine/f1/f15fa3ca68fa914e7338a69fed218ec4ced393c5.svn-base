//
//  PopView.m
//  EasyTT
//
//  Created by tiger on 14-11-1.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import "PopView.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"

@implementation PopItemView
@synthesize popItemButton,isSeparate;

- (void)dealloc
{
	[popItemButton release];
	[spaceLineView release];
	
	[super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		isSeparate = YES;
		
		popItemButton = [[UIButton alloc] initWithFrame:self.bounds];
		popItemButton.backgroundColor = [UIColor clearColor];
        [popItemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [popItemButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
		[self addSubview:popItemButton];
		
		spaceLineView = [[UIView alloc] initWithFrame:CGRectMake(10, self.bounds.size.height-0.5, self.bounds.size.width-10*2, 0.5)];
        spaceLineView.backgroundColor = [RTSSAppStyle currentAppStyle].textFieldBorderColor;
        spaceLineView.hidden = !isSeparate;
		[self addSubview:spaceLineView];
        
	}
	return self;
}

- (void)setSeparate:(BOOL)aSeparate
{
	isSeparate = aSeparate;
	
	spaceLineView.hidden = !isSeparate;
}

@end

@implementation PopView

- (void)dealloc
{
	[bgImageView release];
	[itemsView release];
	
	[super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		isShow = NO;
		self.alpha = 0.0;
		itemsView = [[NSMutableArray alloc] initWithCapacity:0];
		
		bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
		[self addSubview:bgImageView];
	}
	return self;
}

- (void)setBackgroundImage:(UIImage*)bgImage
{
	bgImageView.image = bgImage;
}

- (void)addPopItemView:(PopItemView*)itemView
{
	[itemsView addObject:itemView];
	[self addSubview:itemView];
}

- (void)removeAllItemView
{
	[itemsView makeObjectsPerformSelector:@selector(removeFromSuperview)];
	[itemsView removeAllObjects];
}

- (BOOL)isShowPopView
{
	return isShow;
}

- (void)showPopView:(BOOL)animated
{
	if(animated){
		[UIView animateWithDuration:0.4 animations:^{
			self.alpha = 1.0;
		}];
	}else{
		self.alpha = 1.0;
	}
	isShow = YES;
}

- (void)dismissPopView:(BOOL)animated
{
	if(animated){
		[UIView animateWithDuration:0.4 animations:^{
			self.alpha = 0.0;
		}];
	}else{
		self.alpha = 0.0;
	}
	isShow = NO;
}

@end
