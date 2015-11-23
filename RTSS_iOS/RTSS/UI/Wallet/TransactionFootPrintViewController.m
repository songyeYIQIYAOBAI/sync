//
//  TransactionFootPrintViewController.m
//  RTSS
//
//  Created by caijie on 14/10/23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "TransactionFootPrintViewController.h"

#import "UIView+RTSSAddView.h"

#import "TransactionFootPrintHeaderView.h"
#import "TransactionFootPrintBottomView.h"

#import "RTSSAppStyle.h"

#import "CommonUtils.h"

#import "DateUtils.h"

#import "Session.h"
#import "Cache.h"
#import "User.h"

@interface TransactionFootPrintViewController ()<TransactionFootPrintHeaderDelegate,TransactionFootPrintHeaderDataSource,TransactionFootPrintBottomViewDataSource>{
    
    TransactionFootPrintHeaderView *headerView;
    TransactionFootPrintBottomView *bottomView;
    
    NSMutableArray * buttonItems;
    NSMutableArray * bussinessItems;
    
    TransactionFootPrintHeaderViewButtonType myType;

}

@end

@implementation TransactionFootPrintViewController

#pragma mark -- life
- (void)dealloc{
    [buttonItems release];
    [bussinessItems release];
    [headerView release];
    [bottomView release];
    [super dealloc];
}

- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView{
    [super loadView];
    [self.view setBackgroundColor:[RTSSAppStyle currentAppStyle].viewControllerBgColor];
    
    //stausBar
    UIView * statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 20)];
    statusView.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    [self.view addSubview:statusView];
    [statusView release];
    
    //navi
    [self.view addSubview:[self addNavigationBarView:@"My History" bgColor:[RTSSAppStyle currentAppStyle].navigationBarColor separator:NO]];
    [self installViews];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated{
    
    //[super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [headerView updateUserIncome:680.0 expenditure:700.0];
}
-(void)viewWillDisappear:(BOOL)animated{
    //[super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}


#pragma mark -- loadViews

-(void)installViews{
    
    CGFloat navHeight = CGRectGetMaxY(navigationBarView.frame);
    
    //headView
    headerView = [[TransactionFootPrintHeaderView alloc]initWithFrame:CGRectMake(0, navHeight, PHONE_UISCREEN_WIDTH, 220)];
    headerView.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    headerView.headerDelagate = self;
    headerView.headDataSource = self;
    [headerView updateSubViews];
    [self.view addSubview:headerView];
    
    //bottomView
    bottomView = [[TransactionFootPrintBottomView alloc]initWithFrame:CGRectMake(0, 220+navHeight, PHONE_UISCREEN_WIDTH,PHONE_UISCREEN_HEIGHT-220-navHeight)];
    bottomView.dataSource = self;
    [bottomView updateData];
    [self.view addSubview:bottomView];
}

#pragma maek --data
- (void)loadData{
    //获取用户的 name 和 头像
//    if([CommonUtils objectIsValid:[Session sharedSession].mCurrentSubscriber.mPortrait] || [CommonUtils objectIsValid:[Session sharedSession].mMyCustomer.mCustomerName]){
//        __block UIImage * headImage = nil;
//        headImage = [[Cache standardCache] getSmallPortraitImageWithUrl:[Session sharedSession].mCurrentSubscriber.mPortrait completion:^(UIImage *image) {
//            headImage = image;
//        }];
//        [headerView setUserName:[Session sharedSession].mMyCustomer.mCustomerName Avatar:headImage];
//    }
}

#pragma mark - TransactionFootPrintHeaderDelegate
-(void)updateUserMothDate:(NSDate *)aDate{
      NSLog(@"日期:%@",[DateUtils getStringDateByDate:aDate dateFormat:@"yyyy/MM" ]);
     [headerView updateUserIncome:618.0 expenditure:700];
     [bottomView refreshData:[@[@"1"]mutableCopy]];
}

- (void)buttonViewsClickButtonIndex:(NSInteger)index indexTag:(NSInteger)tag{
    //TODO处理事件
    myType = tag;
    [bottomView updateData];
}

#pragma mark - TransactionFootPrintHeaderDataSource
- (NSInteger)numberOfPerformButtons{
    if (!buttonItems) {
        buttonItems = [[NSMutableArray alloc] initWithCapacity:0];
        
        TransactionFootPrintHeaderViewButtonItem * item1 = [[TransactionFootPrintHeaderViewButtonItem alloc] init];
        item1.bgImage = @"personcenter_history_right_d";
        item1.selectBgImage = @"personcenter_history_right";
        item1.tag = TransactionFootPrintHeaderViewButtonTypeRight;
        [buttonItems addObject:item1];
        [item1 release];
        
        TransactionFootPrintHeaderViewButtonItem * item2 = [[TransactionFootPrintHeaderViewButtonItem alloc] init];
        item2.bgImage = @"personcenter_history_book_d";
        item2.selectBgImage = @"personcenter_history_book";
        item2.tag = TransactionFootPrintHeaderViewButtonTypeBook;
        [buttonItems addObject:item2];
        [item2 release];
        
        TransactionFootPrintHeaderViewButtonItem * item3 = [[TransactionFootPrintHeaderViewButtonItem alloc] init];
        item3.bgImage = @"personcenter_history_message_d";
        item3.selectBgImage = @"personcenter_history_message";
        item3.tag = TransactionFootPrintHeaderViewButtonTypeMessage;
        [buttonItems addObject:item3];
        [item3 release];
        
        TransactionFootPrintHeaderViewButtonItem * item4 = [[TransactionFootPrintHeaderViewButtonItem alloc] init];
        item4.bgImage = @"personcenter_history_photo_d";
        item4.selectBgImage = @"personcenter_history_photo";
        item4.tag = TransactionFootPrintHeaderViewButtonTypePhoto;
        [buttonItems addObject:item4];
        [item4 release];
        

    }
    
    return buttonItems.count;
}

- (TransactionFootPrintHeaderViewButtonItem *)itemOfIndex:(NSInteger)index{
    TransactionFootPrintHeaderViewButtonItem * item = [buttonItems objectAtIndex:index];
    return item;
}

#pragma mark - TransactionFootPrintBottomViewDataSource

- (NSInteger)numberOfItems{
    
    TransactionFootPrintBottomViewModel * item1 = [[TransactionFootPrintBottomViewModel alloc] init];
    item1.dateString = @"2014/09/27";
    item1.businessString = @"VVM VOLTE €30";
    item1.imageString = @"personcenter_history_book_d";
    item1.type = TransactionFootPrintTableViewCellTypeNomal;
    item1.bgType = ButtonItemViewTypeGreen;
    
    TransactionFootPrintBottomViewModel * item2 = [[TransactionFootPrintBottomViewModel alloc] init];
    item2.dateString = @"2014/09/26";
    item2.businessString = @"Wi-Fi 3G €30";
    item2.imageString = @"personcenter_history_message_d";
    item2.type = TransactionFootPrintTableViewCellTypeNomal;
    item2.bgType = ButtonItemViewTypeBlue;

    
    
    TransactionFootPrintBottomViewModel * item3 = [[TransactionFootPrintBottomViewModel alloc] init];
    item3.dateString = @"2014/09/25";
    item3.businessString = @"YOUKU €30";
    item3.imageString = @"personcenter_history_photo_d";
    item3.type = TransactionFootPrintTableViewCellTypeNomal;
    item3.bgType = ButtonItemViewTypeOrangle;

    
    if (!bussinessItems) {
        bussinessItems = [[NSMutableArray alloc] initWithCapacity:0];
    }else{
        [bussinessItems removeAllObjects];
    }
    
    switch (myType) {
        case TransactionFootPrintHeaderViewButtonTypeRight:
        {
            [bussinessItems addObject:item1];
            [bussinessItems addObject:item2];
            [bussinessItems addObject:item3];

        }
            break;
        case TransactionFootPrintHeaderViewButtonTypeBook:
        {
            [bussinessItems addObject:item1];
        }
            break;
        case TransactionFootPrintHeaderViewButtonTypeMessage:
        {
            [bussinessItems addObject:item2];
        }
            break;
        case TransactionFootPrintHeaderViewButtonTypePhoto:
        {
            [bussinessItems addObject:item3];
        }
            break;
    }
    
    [item1 release];
    [item2 release];
    [item3 release];
    
    return bussinessItems.count;
}

- (TransactionFootPrintBottomViewModel *)transactionFootPrintBottomViewIndexItem:(NSInteger)index{
    TransactionFootPrintBottomViewModel * item = [bussinessItems objectAtIndex:index];
    return item;
}

@end
