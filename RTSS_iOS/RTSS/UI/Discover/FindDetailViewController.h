//
//  FindDetailVC.h
//  SJB2
//
//  Created by shengyp on 14-6-7.
//  Copyright (c) 2014年 ailk. All rights reserved.
//

#import "BasicViewController.h"
#import "FindItemModel.h"

@interface FindDetailViewController : BasicViewController<UIWebViewDelegate>
{
	UIWebView* findDetailWebView;
}

@property(nonatomic, retain)FindItemModel* findItem;

@end
