//
//  FindHomeVC.h
//  SJB2
//
//  Created by shengyp on 14-5-17.
//  Copyright (c) 2014年 ailk. All rights reserved.
//

#import "BasicViewController.h"
#import "FindFooterView.h"
#import "FindItemCell.h"

@class MultiDownloader;
@interface FindHomeVC : BasicViewController<UITableViewDelegate,UITableViewDataSource,FindFooterViewDelegate,FindItemCellDelegate>
{
	UITableView* findTableView;
	
	MultiDownloader* downloader;
	
	NSMutableArray* findMessageFrameArray;
	
	FindFooterView* findFooterView;
}

@property(nonatomic,assign)NSInteger findTagId;

@end
