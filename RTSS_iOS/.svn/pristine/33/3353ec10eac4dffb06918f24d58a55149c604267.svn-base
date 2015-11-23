//
//  FindCommentListViewController.m
//  RTSS
//
//  Created by Jaffer on 15/4/2.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "FindCommentListViewController.h"
#import "FindItemCommentModel.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"
#import "FindCommentCell.h"
#import "FindCommentCellFrame.h"
#import "Cache.h"
#import "DateUtils.h"
#import "FindWriteCommentViewController.h"

@interface FindCommentListViewController () <UITableViewDataSource, UITableViewDelegate> {
    UIButton *sendCommentButton;
    UIView *contentView;
}

@property (nonatomic, retain) NSMutableArray *commentsFrameArray;
@property (nonatomic, retain) UITableView *commentListTablView;

@end

@implementation FindCommentListViewController

@synthesize commentListTablView;
@synthesize commentsFrameArray;

#pragma mark dealloc
- (void)dealloc {
    self.commentsFrameArray = nil;
    self.commentListTablView = nil;
    [contentView release];
    
    [super dealloc];
}

#pragma mark life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)loadView {
    [super loadView];
    [self loadNavView];
    [self loadContentView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark load views
- (void)loadNavView {
    self.view.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
    navigationBarView = [self addNavigationBarView:NSLocalizedString(@"Find_Comment_List_Title", nil) bgColor:[[RTSSAppStyle currentAppStyle] navigationBarColor] separator:YES];
    [self.view addSubview:navigationBarView];
    
    UIFont *titleFont = [UIFont systemFontOfSize:14.0];
    CGSize sendTiteSize = [CommonUtils calculateTextSize:NSLocalizedString(@"Find_Comment_List_Send_Comment_Title", nil) constrainedSize:CGSizeMake(CGFLOAT_MAX, 44.0) textFont:titleFont lineBreakMode:NSLineBreakByWordWrapping];
    CGRect sendRect = CGRectMake(CGRectGetWidth(navigationBarView.frame) - 16.0 - sendTiteSize.width, 20.0, sendTiteSize.width, 44.0);
    sendCommentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendCommentButton.frame = sendRect;
    [sendCommentButton setTitle:NSLocalizedString(@"Find_Comment_List_Send_Comment_Title", nil) forState:UIControlStateNormal];
    sendCommentButton.titleLabel.font = titleFont;
    [sendCommentButton setTitleColor:[[RTSSAppStyle currentAppStyle] textMajorColor] forState:UIControlStateNormal];
    [sendCommentButton setTitleColor:[[RTSSAppStyle currentAppStyle] textMajorColor] forState:UIControlStateHighlighted];
    [sendCommentButton addTarget:self action:@selector(writeComment:) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarView addSubview:sendCommentButton];
}

- (void)loadContentView {
    CGRect contentRect = CGRectMake(0.0, CGRectGetMaxY(navigationBarView.frame), PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT - CGRectGetMaxY(navigationBarView.frame));
    contentView = [[UIView alloc] initWithFrame:contentRect];
    contentView.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    [self.view addSubview:contentView];
    
    [self loadCommentsListTablView];
}

- (void)loadCommentsListTablView {
    CGRect tableFrame = CGRectMake(0.0, 0.0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT - CGRectGetMaxY(navigationBarView.frame));
    self.commentListTablView = [[[UITableView alloc] initWithFrame:tableFrame] autorelease];
    commentListTablView.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    commentListTablView.separatorStyle = UITableViewCellSeparatorStyleNone;
    commentListTablView.allowsSelection = NO;
    commentListTablView.delegate = self;
    commentListTablView.dataSource = self;
    commentListTablView.showsHorizontalScrollIndicator = NO;
    commentListTablView.showsVerticalScrollIndicator = NO;
    [contentView addSubview:commentListTablView];
}

#pragma mark tabel view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return commentsFrameArray ? [commentsFrameArray count] : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FindCommentCellFrame *layoutFrame = [commentsFrameArray objectAtIndex:indexPath.row];
    return layoutFrame ? layoutFrame.cellHeight : 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"commentCellIdentifier";
    FindCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[[FindCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    }
    FindCommentCellFrame *frameModel = [commentsFrameArray objectAtIndex:indexPath.row];
    [self layoutCommentCell:cell byLayoutFrame:frameModel];
    
    return cell;
}

- (void)layoutCommentCell:(FindCommentCell *)cell byLayoutFrame:(FindCommentCellFrame *)frameModel {
    if (nil == frameModel) {
        return;
    }
    FindItemCommentModel *commentInfo = frameModel.commentModel;
    
    //icon
    cell.comFromIconImageView.frame = frameModel.commentFromIconRect;
    cell.comFromIconImageView.portraitImage = [[Cache standardCache] getSmallPortraitImageWithUrl:commentInfo.commentFromIconUrl completion:^ (UIImage *image) {
        cell.comFromIconImageView.portraitImage = image;
    }];
    
    //nick
    cell.comFromNickLabel.frame = frameModel.commentFromNickRect;
    cell.comFromNickLabel.text = commentInfo.commentFromNick;
    
    //date
    cell.comDateLabel.frame = frameModel.commentDateRect;
    cell.comDateLabel.text = [DateUtils getStringDateByDate:[NSDate dateWithTimeIntervalSince1970:commentInfo.commentTimeStamp] dateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //content
    cell.comContentLabel.frame = frameModel.commentContentRect;
    cell.comContentLabel.text = commentInfo.commentContent;
    
    //sep
    cell.comSepImageView.frame = frameModel.commentSepRect;
}

#pragma mark button clicked
- (void)writeComment:(UIButton *)btn {
    NSLog(@"write comment");
    //present
    FindWriteCommentViewController *writeVC = [[FindWriteCommentViewController alloc] init];
    writeVC.commentFinishedBlock = ^(FindItemCommentModel *com) {
        if (com) {
            //temp 暂时插入假数据
            FindCommentCellFrame *cellFrame = [[FindCommentCellFrame alloc] initWithAvailalbeWidth:CGRectGetWidth(commentListTablView.frame)];
            [cellFrame calculateViewFramesByCommentData:com];
            [commentsFrameArray insertObject:cellFrame atIndex:0];
            [cellFrame release];
            [commentListTablView reloadData];
        }
    };
    [self presentViewController:writeVC animated:YES completion:nil];
    [writeVC release];
}

#pragma mark load data
- (void)loadData {
#ifdef APPLICATION_BUILDING_RELEASE
    
#else
    [self calculateCommentCellFrameByCommentsData:[self fakeData]];
    [commentListTablView reloadData];
#endif
}

- (void)calculateCommentCellFrameByCommentsData:(NSArray *)comments {
    if ([CommonUtils objectIsValid:comments]) {
        self.commentsFrameArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        for (int i = 0; i < [comments count]; i ++) {
            FindItemCommentModel *com = [comments objectAtIndex:i];
            FindCommentCellFrame *layoutFrame = [[FindCommentCellFrame alloc] initWithAvailalbeWidth:CGRectGetWidth(commentListTablView.frame)];
            [layoutFrame calculateViewFramesByCommentData:com];
            [commentsFrameArray addObject:layoutFrame];
            [layoutFrame release];
        }
    }
}

- (NSMutableArray *)fakeData {
    NSMutableArray *commentsArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    NSArray *contents = @[@"热瓦惹午饭时间发牢骚房间打开老师放假啊放假发决定是否了解",
                          @"福建大煞风景啊风急浪大撒娇法律界激发电视剧法律界的肌肤垃圾地方垃圾放假啊对方理解啊对方了解大煞风景啊弗拉加地方",
                          @"而我去人情味入发生的激发肌肤激发了手机发了假发减肥了就发生老骥伏枥发牢骚积分",
                          @"但是防守打法减肥了；科技经费累计撒放辣椒飞机阿隆索飞机垃圾积分里卡多减肥啦",
                          @"fdf法定身份",
                          @"反对撒放假了",
                          @"俄武器若即若离为空间人气流入金额为家人为桥口隆吉人情味了就俄加入了加热器今日巨额我确认情节恶劣人家老人家饿了我居然去为了让家里人家里人贾庆林近日机器人发生纠纷解放军队书法家",
                          @"风刀霜剑发生纠纷的数据分类考试的减肥啦大家罚款积分里卡多减肥啦的减肥啦大家弗里敦附近啊立法局阿里风景fdlkajfladjsfaldjfaldsjfaldfjalfjalfjajfalfjldjfdfjalfj",
                          @"的发放健康的卷发可减肥反馈啦圣诞节法律框架分卷发快乐的风景啊离开积分放假啊看来大煞风景阿里风景飞机阿莱克斯的风景啊理解法律框架法律",
                          @"风刀霜剑副科级撒的饭卡是江东父老卡手机发链接放飞机了肯德基发电量放假啊大家放假放辣椒弗拉加地方的卷发决定是否垃圾分类家啊",
                          @""];
    for (int i = 0; i < 11; i ++) {
        FindItemCommentModel *com = [[FindItemCommentModel alloc] init];
        com.commentFromUid = [NSString stringWithFormat:@"0000%d",i + 1];
        com.commentFromNick = [NSString stringWithFormat:@"John%d",i + 1];
        com.commentFromIconUrl = @"http://www.x.cn//discovery/music/nofeartonight/icon.png";
        com.commentToUid = [NSString stringWithFormat:@"11111%d",i + 1];
        com.commentToNick = [NSString stringWithFormat:@"Jack%d",i + 1];
        com.commentContent = [contents objectAtIndex:i];
        com.commentPicId = [NSString stringWithFormat:@"2222%d",i + 1];
        com.commentTimeStamp = [[NSDate date] timeIntervalSince1970];
        [commentsArray addObject:com];
    }
    return commentsArray;
}

#pragma mark others
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
