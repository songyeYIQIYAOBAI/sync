//
//  FindHomeVC.m
//  SJB2
//
//  Created by shengyp on 14-5-17.
//  Copyright (c) 2014年 ailk. All rights reserved.
//

#import "FindHomeVC.h"
#import "FindDetailVC.h"
#import "FindItemView.h"
#import "FindItemModel.h"
#import "FindItemFrame.h"
#import "AppDelegate.h"

#import "CommonUtils.h"
#import "Cache.h"
#import "MultiDownloader.h"


@interface FindHomeVC ()

@property(nonatomic, assign)BOOL isCellRefresh;

@end

@implementation FindHomeVC
@synthesize findTagId,isCellRefresh;

- (void)dealloc
{
	[findTableView release];
	
	[findMessageFrameArray release];
	
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
		findTagId = 0;
        downloader = [MultiDownloader standardMultiDownloader];
		findMessageFrameArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
	isCellRefresh = YES;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	
	isCellRefresh = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutFindTableView
{
	if(nil == findTableView){
		findTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-20-44)
													 style:UITableViewStylePlain];
        findTableView.backgroundColor = [UIColor clearColor];//[RTSSAppStyle currentAppStyle].viewControllerBgColor;
		findTableView.delegate = self;
		findTableView.dataSource = self;
		findTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self.view addSubview:findTableView];
	}
	if(nil == findFooterView){
		findFooterView = [[FindFooterView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 50)];
		findFooterView.delegete = self;
	}
	[findTableView setTableFooterView:findFooterView];
	findTableView.hidden = YES;
}

- (void)loadView
{
	[super loadView];

	[self layoutFindTableView];
}

- (void)testData
{
	NSMutableArray* findMessageArray = [[NSMutableArray alloc] initWithCapacity:0];
	
	{
		FindItemModel* item = [[FindItemModel alloc] init];
		item.itemName = @"《Free Spotify Premium and 2GB data》";
		item.itemTitle = @"Amazing Christmas gifts";
		item.itemDate = @"2015-01-22";
		item.itemType = 0;
		item.itemDescription = @"Right now, you can choose between two of the best-value phones around, loaded up with 3 months free Spotify Premium access, and a free $40 Cap Starter Pack packed with 2GB data.";
		item.itemIconURL = @"";
		item.itemPicURL = @"";
        item.itemTargetUrl = @"http://www.baidu.com";
        item.itemTagDic = @{@"0000001":@"发生了发达",@"00000002":@"大幅广",@"00000003":@"放大舒服",@"00000":@"福建大煞风景啦",@"0000001111122222":@"奋斗是垃圾分类积分",@"fdsafdfaf":@"fdffaff",@"gfgfgfg":@"gfgrtretre",@"jhjhgjfhg":@"ytryrty",@"tytryetry":@"jyjjry"};
		[findMessageArray addObject:item];
		[item release];
	}
    
    {
        FindItemModel* item = [[FindItemModel alloc] init];
        item.itemName = @"《Free Spotify Premium and 2GB data》";
        item.itemTitle = @"Amazing Christmas gifts";
        item.itemDate = @"2015-01-22";
        item.itemType = 0;
        item.itemDescription = @"Right now, you can choose between two of the best-value phones around, loaded up with 3 months free Spotify Premium access, and a free $40 Cap Starter Pack packed with 2GB data.";
        item.itemIconURL = @"";
        item.itemPicURL = @"";
        item.itemTargetUrl = @"http://www.baidu.com";
        item.itemTagDic = @{@"0000001":@"发生了发达"};
        [findMessageArray addObject:item];
        [item release];
    }
	
	{
		FindItemModel* item = [[FindItemModel alloc] init];
		item.itemName = @"织图";
		item.itemTitle = @"【织图】画中画讲故事";
		item.itemDate = @"2014-05-19";
		item.itemType = 1;
		item.itemDescription = @"旅游拍回的照片用织图编成故事给朋友看吧！织图用画中画的方式将现场真实地还原在手机上，同时也可以用它来制作自己的街景地图。独有的多图片编辑和浏览体验，第一眼就能惊艳。";
		item.itemIconURL = @"http://www.x.cn//discovery/app/zhitu/icon.png";
		item.itemPicURL = @"http://www.x.cn//discovery/app/zhitu/app.png";
        item.itemTagDic = @{@"0000001":@"发生了发达",@"00000002":@"大幅广"};
		[findMessageArray addObject:item];
		[item release];
	}
	
	{
		FindItemModel* item = [[FindItemModel alloc] init];
		item.itemName = @"星龙战记";
		item.itemTitle = @"【星龙战记】文/幻云子";
		item.itemDate = @"2014-05-17";
		item.itemType = 2;
		item.itemDescription = @"五千年足以使一个文明从萌芽到灭亡，但是五千年对于“乱流星河”来说不过是须臾。大劫的来临何时出现？若修这个时候更加想念老黑龙了，想念银河那两条绚烂的旋臂，想念宇宙源海的壮阔和波澜。";
		item.itemIconURL = @"http://www.x.cn//discovery/mv/xlwar/icon.png";
		item.itemPicURL = @"http://www.x.cn//discovery/mv/xlwar/xlwar1.jpg";
        item.itemTagDic = @{@"0000001":@"发生了发达",@"00000002":@"大幅广",@"00000003":@"放大舒服"};
		[findMessageArray addObject:item];
		[item release];
	}
	
	{
		FindItemModel* item = [[FindItemModel alloc] init];
		item.itemName = @"薄荷";
		item.itemTitle = @"【薄荷】她们都瘦了";
		item.itemDate = @"2014-05-17";
		item.itemType = 3;
		item.itemDescription = @"五月不减肥,六月羞露腿！薄荷拥有国内数据量最大，数据最权威的【薄荷食物库】，截止2013年12月，已经帮助500万用户成功减去2600万斤！来薄荷制定自己的减肥方案，与姐妹们一起有爱的减肥吧！";
		item.itemIconURL = @"http://www.x.cn//discovery/app/bohe/icon.png";
		item.itemPicURL = @"http://www.x.cn//discovery/app/bohe/app.jpg";
        item.itemTagDic = @{@"0000001dsj":@"发生了发达的时间发酵放辣椒水法拉盛的肌肤"};
		[findMessageArray addObject:item];
		[item release];
	}
	
	{
		FindItemModel* item = [[FindItemModel alloc] init];
		item.itemName = @"江苏移动";
		item.itemTitle = @"5月17日又白送流量啦！【江苏移动】";
		item.itemDate = @"2014-05-17";
		item.itemType = 0;
		item.itemDescription = @"5月17日江苏移动又白送流量啦！1000万份流量红包火爆瓜分中，最大红包11个G，届时请发送“抢流量”到10086来拼人品，看看你能抢到多少?";
		item.itemIconURL = @"http://www.x.cn//discovery/activity/10086.png";
		item.itemPicURL = @"http://www.x.cn//discovery/activity/10086js517/517js10086.jpg";
		[findMessageArray addObject:item];
		[item release];
	}
	
	{
		FindItemModel* item = [[FindItemModel alloc] init];
		item.itemName = @"无惧此夜";
		item.itemTitle = @"【无惧此夜】吉克隽逸";
		item.itemDate = @"2014-05-17";
		item.itemType = 0;
		item.itemDescription = @"吉克隽逸化身女战士倾情首唱姚谦填词的国内知名网络游戏主题曲《无惧此夜》，荡气回肠的旋律将她高亢自然、充满灵气的嗓 音表现的栩栩如生，与剧情中的史诗风格完美契合。";
		item.itemIconURL = @"http://www.x.cn//discovery/music/nofeartonight/icon.png";
		item.itemPicURL = @"http://www.x.cn//discovery/music/nofeartonight/music1.jpg";
		[findMessageArray addObject:item];
		[item release];
	}
	
    [self refreshFindMessage:findMessageArray];
	
	[findMessageArray release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Discover";
    
    [self testData];
}

- (void)refreshFindMessage:(NSMutableArray*)items
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
		if([items count] == 5){
        
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
	//[findFooterView findFooterScrollViewDidEndDragging:scrollView];
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
        itemModel.itemIconImage = [[Cache standardCache] getDiscoverAppImageWithUrl:itemModel.itemIconURL
                                                                         completion:^(UIImage *image) {
                                                                             if(isCellRefresh){
                                                                                 itemModel.itemIconImage = image;
                                                                                 
                                                                                 if([self isIndexPathVisible:indexPath]){
                                                                                     [cell setIconImage:itemModel.itemIconImage];
                                                                                 }
                                                                             }
                                                                         }];
	}

	NSLog(@"--->index:%d-------pic url:%@",[indexPath row],itemModel.itemPicURL);
	if(nil != itemModel.itemPicImage){
		[cell setPicImage:itemModel.itemPicImage];
	}else{
        itemModel.itemPicImage = [[Cache standardCache] getDiscoverPicImageWithUrl:itemModel.itemPicURL
                                                                        completion:^(UIImage *image) {
                                                                            if(isCellRefresh){
                                                                                itemModel.itemPicImage = image;
                                                                                
                                                                                if([self isIndexPathVisible:indexPath]){
                                                                                    [cell setPicImage:itemModel.itemPicImage];
                                                                                }
                                                                            }
                                                                        }];
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
	FindDetailVC* VC = [[FindDetailVC alloc] init];
	VC.findItem = ((FindItemFrame*)[findMessageFrameArray objectAtIndex:[indexPath row]]).itemModel;
	[self.navigationController pushViewController:VC animated:YES];
	[VC release];
}

@end
