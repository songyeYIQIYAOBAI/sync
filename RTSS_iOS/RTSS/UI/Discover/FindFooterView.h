//
//  FindFooterView.h
//  SJB2
//
//  Created by shengyp on 14-5-27.
//  Copyright (c) 2014年 ailk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FindFooterViewDelegate;
@interface FindFooterView : UIView
{
	
}

@property(nonatomic,assign,setter = setLoading:)BOOL isLoading;
@property(nonatomic,assign,setter = setMore:)BOOL isMore;

@property(nonatomic,retain,readonly)UIActivityIndicatorView* indicatorView;
@property(nonatomic,retain,readonly)UILabel* moreLabel;
@property(nonatomic,retain,readonly)UILabel* loadingLabel;
@property(nonatomic,retain,readonly)UIButton* moreButton;

@property(nonatomic,assign)id<FindFooterViewDelegate> delegete;

- (void)startLoading;
- (void)stopLoading;

- (void)findFooterScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)findFooterScrollViewDidEndDragging:(UIScrollView *)scrollView;

@end


@protocol FindFooterViewDelegate <NSObject>

@required
- (void)findFooterRefreshFinish;

@end

