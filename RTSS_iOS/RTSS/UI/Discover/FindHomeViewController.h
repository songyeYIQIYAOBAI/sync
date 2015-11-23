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
#import "FindCenter.h"

@class MultiDownloader;
@interface FindHomeViewController : BasicViewController<UITableViewDelegate,UITableViewDataSource,FindFooterViewDelegate,FindItemCellDelegate>
{
	UITableView* findTableView;
	
	MultiDownloader* downloader;
	
	NSMutableArray* findMessageFrameArray;
	
	FindFooterView* findFooterView;
}

- (instancetype)initWithFindMode:(FindMode)mode findTag:(FindTagModel *)tag;

@end
