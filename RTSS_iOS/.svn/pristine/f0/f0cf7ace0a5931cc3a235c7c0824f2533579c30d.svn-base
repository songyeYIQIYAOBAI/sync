//
//  FindHomeVC.m
//  SJB2
//
//  Created by shengyp on 14-5-17.
//  Copyright (c) 2014年 ailk. All rights reserved.
//

#import "FindHomeViewController.h"
#import "FindDetailViewController.h"
#import "FindItemView.h"
#import "FindItemModel.h"
#import "FindItemFrame.h"
#import "AppDelegate.h"

#import "CommonUtils.h"
#import "Cache.h"
#import "MultiDownloader.h"
#import "FindCommentListViewController.h"
#import "FindShareMethodsViewController.h"
#import "FindCenter.h"

@interface FindHomeViewController () <FindCenterDelegate>

@property (nonatomic, assign) BOOL isCellRefresh;
@property (nonatomic, assign) NSInteger curPageIndex;
@property (nonatomic, assign) FindMode findMode;
@property (nonatomic, retain) FindTagModel *findTag;
@property (nonatomic, retain) FindCenter *findCenter;

@end

@implementation FindHomeViewController
@synthesize findTag,isCellRefresh,findMode;
@synthesize curPageIndex,findCenter;

- (void)dealloc
{
	[findTableView release];
    [findFooterView release];
	[findMessageFrameArray release];
    [findCenter release];
    [findTag release];
	
    [super dealloc];
}

#pragma mark init
- (instancetype)initWithFindMode:(FindMode)mode findTag:(FindTagModel *)tag
{
    self = [super init];
    if (self) {
        findMode = mode;
        self.findTag = tag;
        curPageIndex = 0;
        downloader = [MultiDownloader standardMultiDownloader];
		findMessageFrameArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

#pragma mark life cycle
- (void)loadView
{
    [super loadView];
    [self layoutFindTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    isCellRefresh = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    isCellRefresh = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.findMode == FindModeByCollection) {
        self.title = NSLocalizedString(@"Find_Title_From_Collection", nil);
    } else if (self.findMode == FindModeByDiscovery) {
        self.title = NSLocalizedString(@"Find_Title_From_Discover", nil);
    } else if (self.findMode == FindModeByTag) {
        self.title = self.findTag.tagName;
    }
}

#pragma mark init views
- (void)layoutFindTableView
{
	if(nil == findTableView){
		findTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-20-44)
													 style:UITableViewStylePlain];
        findTableView.backgroundColor = [UIColor clearColor];//[RTSSAppStyle currentAppStyle].viewControllerBgColor;
		findTableView.delegate = self;
		findTableView.dataSource = self;
		findTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        findTableView.showsHorizontalScrollIndicator = NO;
        findTableView.showsVerticalScrollIndicator = NO;
		[self.view addSubview:findTableView];
	}
	if(nil == findFooterView){
		findFooterView = [[FindFooterView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 50)];
		findFooterView.delegete = self;
	}
	[findTableView setTableFooterView:findFooterView];
}


- (void)refreshFindMessage:(NSArray *)items
{
	[findFooterView stopLoading];
	
	if(nil != items && [items count] > 0){
		findFooterView.isMore = YES;

		// 组装要显示的数据
		for (int i = 0; i < [items count]; i++) {
			FindItemModel* itemModel = [items objectAtIndex:i];
			NSLog(@"----->%@",itemModel.itemTagDic);
			FindItemFrame* itemFrame = [[FindItemFrame alloc] init];
			itemFrame.itemWidth = PHONE_UISCREEN_WIDTH-10*2;
			itemFrame.itemModel = itemModel;
			[findMessageFrameArray addObject:itemFrame];
			[itemFrame release];
		}
		// 判断是否还有数据要显示
		if([items count] == FindPageCapacity){
            curPageIndex += 1;
		}else{
			findFooterView.isMore = NO;
		}
		// 显示并刷新界面
		if(YES == findTableView.hidden){
			findTableView.hidden = NO;
		}
		[findTableView reloadData];
	}else{
		findFooterView.isMore = NO;
	}
}

#pragma mark FindFooterViewDelegate
- (void)findFooterRefreshFinish
{
    [self loadFindItemData];
}

#pragma mark UIScrollViewDelegate
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
	return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	//[findFooterView findFooterScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[findFooterView findFooterScrollViewDidEndDragging:scrollView];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	FindItemFrame* itemFrame = [findMessageFrameArray objectAtIndex:[indexPath row]];
	return itemFrame.itemCellHeight+10;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [findMessageFrameArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString* cellIdentifier = @"FindHomeCellIdentifier";
	FindItemCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil){
		cell = [[[FindItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
		cell.delegate = self;
	}
	
	FindItemFrame* findItemFrame = [findMessageFrameArray objectAtIndex:[indexPath row]];
	FindItemModel* itemModel = findItemFrame.itemModel;
	
	cell.findItemFrame = findItemFrame;
    cell.cellIndexPath = indexPath;
		
	NSLog(@"--->index:%d-------icon url:%@",[indexPath row],itemModel.itemIconURL);
	if(nil != itemModel.itemIconImage){
		[cell setIconImage:itemModel.itemIconImage];
	}else{
//        itemModel.itemIconImage = [[Cache standardCache] getDiscoverAppImageWithUrl:itemModel.itemIconURL
//                                                                         completion:^(UIImage *image) {
//                                                                             if(isCellRefresh){
//                                                                                 itemModel.itemIconImage = image;
//                                                                                 
//                                                                                 if([self isIndexPathVisible:indexPath]){
//                                                                                     [cell setIconImage:itemModel.itemIconImage];
//                                                                                 }
//                                                                             }
//                                                                         }];
	}

	NSLog(@"--->index:%d-------pic url:%@",[indexPath row],itemModel.itemPicURL);
	if(nil != itemModel.itemPicImage){
		[cell setPicImage:itemModel.itemPicImage];
	}else{
//        itemModel.itemPicImage = [[Cache standardCache] getDiscoverPicImageWithUrl:itemModel.itemPicURL
//                                                                        completion:^(UIImage *image) {
//                                                                            if(isCellRefresh){
//                                                                                itemModel.itemPicImage = image;
//                                                                                
//                                                                                if([self isIndexPathVisible:indexPath]){
//                                                                                    [cell setPicImage:itemModel.itemPicImage];
//                                                                                }
//                                                                            }
//                                                                        }];
	}

	return cell;
}

- (BOOL)isIndexPathVisible:(NSIndexPath *)indexPath
{
    NSArray *visibleIndexPaths = [findTableView indexPathsForVisibleRows];
    return [visibleIndexPaths containsObject:indexPath];
}

- (void)reloadRowsAtIndexPath:(NSIndexPath*)indexPath withRowAnimation:(UITableViewRowAnimation)animation
{
	[findTableView canCancelContentTouches];
	[findTableView beginUpdates];
	[findTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:animation];
	[findTableView endUpdates];
}

#pragma mark FindItemCellDelegate
- (void)didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	FindDetailViewController* VC = [[FindDetailViewController alloc] init];
	VC.findItem = ((FindItemFrame*)[findMessageFrameArray objectAtIndex:[indexPath row]]).itemModel;
	[self.navigationController pushViewController:VC animated:YES];
	[VC release];
}

- (void)didClickedItemTagWithTagModel:(FindTagModel *)tag indexPath:(NSIndexPath *)indexPath {
    if (tag) {
        FindHomeViewController *findTagVC = [[FindHomeViewController alloc] initWithFindMode:FindModeByTag findTag:tag];
        [self.navigationController pushViewController:findTagVC animated:YES];
        [findTagVC release];
    } else {
        NSLog(@"FindHomeViewController::didClickedItemTagWithTagModel::find tag error");
    }
}

- (void)didClickedItemActionWithType:(ActionOptionType)type indexPath:(NSIndexPath *)indexPath {
    FindItemFrame *itemFrame = [findMessageFrameArray objectAtIndex:indexPath.row];
    FindItemModel *dataModel = itemFrame.itemModel;
    FindItemCell *itemCell = (FindItemCell *)[findTableView cellForRowAtIndexPath:indexPath];
    if (!dataModel || !itemCell) {
        return;
    }
    
    switch (type) {
        case ActionOptionTypeComment:
        {
            FindCommentListViewController *comListVC = [[FindCommentListViewController alloc] init];
            [self.navigationController pushViewController:comListVC animated:YES];
            [comListVC release];
        }
            break;
        case ActionOptionTypeShare:
        {
            FindShareMethodsViewController *shareVC = [[FindShareMethodsViewController alloc] init];
            [self.navigationController pushViewController:shareVC animated:YES];
            [shareVC release];
        }
            break;
        case ActionOptionTypePraise:
        {
            if (dataModel.itemHasHot == 0) {
                [findCenter doPraiseByItemId:dataModel.itemId];
            } else if (dataModel.itemHasHot == 1) {
                [findCenter cancelPraiseByItemId:dataModel.itemId];
            }
        }
            break;
        case ActionOptionTypeCollect:
        {
            if (dataModel.itemHasCollect == 0) {
                [findCenter doCollectByItem:dataModel];
            } else if (dataModel.itemHasCollect == 1) {
                [findCenter cancelCollectByItem:dataModel];
            }
        }
            break;
        default:
            break;
    }
}


#pragma mark FindCenter delegate
- (void)getItemsFinishedStatus:(int)succeed itmes:(NSArray *)items sourceType:(FindItemSoruceType)type findMode:(FindMode)mode currentPage:(NSInteger)currentPage{
    if (succeed == 0) {
        if (self.findCenter.loadLocalData == NO && type == FindItemSoruceTypeNetwork && currentPage == 0) {
            //此时返回的数据是网络上返回的数据，需要将现有数据删除
            [findMessageFrameArray removeAllObjects];
        }
        [self refreshFindMessage:items];
        [self changeTableFooterView];
    } else {
        NSLog(@"find home view controller::getFindItemsFinishedStatus===failied");
        [findFooterView stopLoading];
    }
}

- (void)updateItemPraiseStatusFinished:(int)status itemId:(NSInteger)itemId {
    if (status == 0) {
        NSIndexPath *temIndexPath = [self getIndexPathViaItemId:itemId];
        if (temIndexPath) {
            FindItemCell *itemCell = (FindItemCell *)[findTableView cellForRowAtIndexPath:temIndexPath];
            FindItemFrame *frameModel = itemCell.findItemFrame;
            FindItemModel *itemModel = frameModel.itemModel;
            if (itemModel.itemHasHot == 1) {
                //之前已经被赞，现在是要取消赞
                itemModel.itemHasHot = 0;
                if (itemModel.itemHotCount > 0) {
                    itemModel.itemHotCount -= 1;
                }
            } else if (itemModel.itemHasHot == 0) {
                //之前没有赞，现在是要赞
                itemModel.itemHasHot = 1;
                itemModel.itemHotCount += 1;
            }
            //更新find表中的数据
            [findCenter updateItem:itemModel findMode:FindModeByDiscovery];
            //查看当前item在collect表中是否存在，若存在，需要更新collect表数据
            BOOL haveCollected = [findCenter checkItemExistStatus:itemModel findMode:FindModeByCollection];
            if (haveCollected) {
                //已经被收藏过，所以需要将最新的praise数据更新到collect表中
                [findCenter updateItem:itemModel findMode:FindModeByCollection];
            }
            [itemCell updateActionOptionViewStatusByType:ActionOptionTypePraise completion:^(NSIndexPath *indexPath) {
                
            }];
        }
    }
}

- (void)updateItemCollectStatusFinished:(int)status item:(FindItemModel *)item {
    if (status == 0 && item) {
        NSIndexPath *tempIndexPath = [self getIndexPathViaItemId:item.itemId];
        if (tempIndexPath) {
            FindItemCell *itemCell = (FindItemCell *)[findTableView cellForRowAtIndexPath:tempIndexPath];
            if (itemCell) {
                FindItemFrame *frameModel = itemCell.findItemFrame;
                FindItemModel *itemModel = frameModel.itemModel;
                itemModel.itemHasCollect = item.itemHasCollect;
                [itemCell updateActionOptionViewStatusByType:ActionOptionTypeCollect completion:^(NSIndexPath *indexPath) {
                    NSLog(@"收藏状态改变");
                    //如果当前是在收藏页面，用户取消收藏后需要将当前条目删除掉
                    if (self.findMode == FindModeByCollection) {
                        if (itemModel.itemHasCollect == 0) {
                            //已取消收藏,删除当前条目
                            [findMessageFrameArray removeObject:frameModel];
                            [self changeTableFooterView];
                            [findTableView deleteRowsAtIndexPaths:@[tempIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                            [findTableView reloadData];
                            NSLog(@"table view content size===%@",NSStringFromCGRect(findTableView.frame));
                        }
                    }
                }];
            }
        }
    }
}

- (void)changeTableFooterView {
    if ([findMessageFrameArray count] == 0) {
        UIView *footerBgView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT - 64.0)];
        findTableView.tableFooterView = footerBgView;
        [footerBgView release];
        
        //prompt label
        NSString *promptText = NSLocalizedString(@"Find_Have_No_Collection_Item", nil);
        CGSize textSize = [CommonUtils calculateTextSize:promptText constrainedSize:CGSizeMake(PHONE_UISCREEN_WIDTH - 80.0, CGFLOAT_MAX) textFont:[UIFont systemFontOfSize:18.] lineBreakMode:NSLineBreakByWordWrapping];
        CGRect labelRect = CGRectMake((CGRectGetWidth(footerBgView.frame) - textSize.width) / 2.0, (CGRectGetHeight(footerBgView.frame) - textSize.height) / 2.0, textSize.width, textSize.height);
        UILabel *promptLabel = [CommonUtils labelWithFrame:labelRect text:promptText textColor:[RTSSAppStyle currentAppStyle].textMajorColor textFont:[UIFont systemFontOfSize:18.0] tag:0];
        promptLabel.numberOfLines = 0;
        promptLabel.textAlignment = NSTextAlignmentCenter;
        [footerBgView addSubview:promptLabel];
    }
}

#pragma mark load data
- (void)loadData {
    self.findCenter = [[[FindCenter alloc] init] autorelease];
    findCenter.delegate = self;
    [self loadFindItemData];
}

- (void)loadFindItemData {
    switch (self.findMode) {
        case FindModeByDiscovery:
        {
            [findCenter getFindItemsByCurrentPage:curPageIndex pageCapacity:FindPageCapacity findMode:findMode];
        }
            break;
        case FindModeByTag:
        {
            [findCenter getFindTagItemsByCurrentPage:curPageIndex pageCapacity:FindPageCapacity itemTagId:self.findTag.tagId findMode:findMode];
        }
            break;
        case FindModeByCollection:
        {
            [findCenter getCollectItemsByCurrentPage:curPageIndex pageCapacity:FindPageCapacity findMode:findMode];
        }
            break;
        default:
            break;
    }
}

#pragma mark tools
//通过itemid查询cell的indexpath
- (NSIndexPath *)getIndexPathViaItemId:(NSInteger)itemId {
    NSIndexPath *indexPath = nil;
    for (int i = 0; i < [findMessageFrameArray count]; i ++) {
        FindItemFrame *itemFrameModel = [findMessageFrameArray objectAtIndex:i];
        if (itemFrameModel) {
            FindItemModel *itemModel = itemFrameModel.itemModel;
            if (itemModel) {
                if (itemModel.itemId == itemId) {
                    //在内存中找到该item，生成indexpath
                    indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    break;
                }
            }
        }
    }
    return indexPath;
}

#pragma mark others
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
