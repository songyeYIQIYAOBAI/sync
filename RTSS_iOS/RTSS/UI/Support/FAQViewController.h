//
//  FAQViewController.h
//  RTSS
//
//  Created by Liuxs on 15-1-16.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"
#import "FAQTableView.h"

@interface FAQViewController : BasicViewController<FAQTableViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate>

@property (nonatomic, retain) NSArray                   *mResultsArr;//搜索结果
@property (nonatomic, retain) NSMutableArray            *tempResults;//临时存储搜索结果
@property (nonatomic, retain) UISearchBar               *mSearch;    //搜索框
@property (nonatomic, retain) UISearchDisplayController *mSearchPlay;//搜索显示
@property (nonatomic, retain) FAQTableView              *mTableView;

@end
