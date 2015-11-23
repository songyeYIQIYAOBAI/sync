//
//  FindFooterView.m
//  SJB2
//
//  Created by shengyp on 14-5-27.
//  Copyright (c) 2014年 ailk. All rights reserved.
//

#import "FindFooterView.h"
#import "CommonUtils.h"
#import "RTSSAppDefine.h"
#import "RTSSAppStyle.h"

@implementation FindFooterView
@synthesize indicatorView,moreLabel,loadingLabel,moreButton;
@synthesize delegete;

- (void)dealloc
{
	[indicatorView release];
//	[moreLabel release];
//	[loadingLabel release];
//	[moreButton release];
	
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self layoutContent:frame];
    }
    return self;
}

- (UILabel*)layoutLabel:(CGRect)aFrame font:(UIFont*)font color:(UIColor*)color
{
    UILabel* templateLabel = [[[UILabel alloc] initWithFrame:aFrame] autorelease];
    templateLabel.backgroundColor = [UIColor clearColor];
    templateLabel.textColor = color;
    templateLabel.font = font;
    templateLabel.numberOfLines = 1;
    templateLabel.lineBreakMode = NSLineBreakByWordWrapping;
    templateLabel.textAlignment = NSTextAlignmentCenter;
    return templateLabel;
}

- (void)layoutContent:(CGRect)frame
{
	// 点击加载更多
	moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
	moreButton.backgroundColor = [RTSSAppStyle currentAppStyle].textFieldBgColor;
	moreButton.layer.cornerRadius = 8;
	moreButton.layer.borderWidth = 0.5;
	moreButton.layer.borderColor = [CommonUtils colorWithHexString:@"#B2B2B2"].CGColor;
	moreButton.frame = CGRectMake(10, 5, frame.size.width-10*2, frame.size.height-5*2);
	[moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:moreButton];
	
	// 点击加载更多/没有更多数据
	moreLabel = [self layoutLabel:CGRectMake(0, 0, CGRectGetWidth(moreButton.frame), CGRectGetHeight(moreButton.frame))
							 font:[UIFont systemFontOfSize:15.0]
							color:[RTSSAppStyle currentAppStyle].textMajorColor];
	[moreButton addSubview:moreLabel];
	
	// 正在载入...
	loadingLabel = [self layoutLabel:CGRectMake(120, 0, CGRectGetWidth(moreButton.frame)-120, CGRectGetHeight(moreButton.frame))
								font:[UIFont systemFontOfSize:15.0]
							   color:[RTSSAppStyle currentAppStyle].textMajorColor];
	loadingLabel.hidden = YES;
	loadingLabel.textAlignment = NSTextAlignmentLeft;
	loadingLabel.text = NSLocalizedString(@"Find_Footer_View_Loading_prompt", nil);
	[moreButton addSubview:loadingLabel];
	
	// 等待的旋转图标
	indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(120-30, (CGRectGetHeight(moreButton.frame)-30)/2.0, 30, 30)];
	indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
	[moreButton addSubview:indicatorView];
	
	self.isMore = YES;
}

- (void)setLoading:(BOOL)isLoading
{
	_isLoading = isLoading;
	
	if(_isLoading){
		moreLabel.hidden = YES;
		loadingLabel.hidden = NO;
		moreButton.enabled = NO;
	}else{
		moreLabel.hidden = NO;
		loadingLabel.hidden = YES;
		moreButton.enabled = YES;
	}
}

- (void)setMore:(BOOL)isMore
{
	_isMore = isMore;
	
	if(_isMore){
		moreLabel.text = NSLocalizedString(@"Find_Footer_View_Clicked_To_Load", nil);
		moreButton.enabled = YES;
	}else{
		moreLabel.text = NSLocalizedString(@"Find_Footer_View_No_More_Data", nil);
		moreButton.enabled = NO;
	}
}

- (void)startLoading
{
	self.isLoading = YES;

	if(![indicatorView isAnimating]){
        [indicatorView startAnimating];
    }
	
	if(nil != delegete && [delegete respondsToSelector:@selector(findFooterRefreshFinish)]){
		[delegete findFooterRefreshFinish];
	}
}

- (void)stopLoading
{
	self.isLoading = NO;
	
	if([indicatorView isAnimating]){
        [indicatorView stopAnimating];
    }
}

- (void)moreButtonAction:(UIButton*)button
{
	[self startLoading];
}

- (void)findFooterScrollViewDidScroll:(UIScrollView *)scrollView
{
	if(_isLoading || !_isMore) return;
	
	if((scrollView.contentSize.height - (scrollView.contentOffset.y+scrollView.bounds.size.height-scrollView.contentInset.bottom)) <= self.frame.size.height && (scrollView.contentOffset.y > 0)){
		[self startLoading];
	}
}

- (void)findFooterScrollViewDidEndDragging:(UIScrollView *)scrollView
{
	if(_isLoading || !_isMore) return;
		
	if((scrollView.contentSize.height - (scrollView.contentOffset.y+scrollView.bounds.size.height-scrollView.contentInset.bottom)) <= self.frame.size.height && (scrollView.contentOffset.y > 0)){
		[self startLoading];
	}
}

@end
