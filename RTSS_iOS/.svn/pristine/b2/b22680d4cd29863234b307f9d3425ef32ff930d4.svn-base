//
//  MyFavoritesViewController.m
//  RTSS
//
//  Created by 宋野 on 15-1-19.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "MyFavoritesViewController.h"
#import "MyFavoritesView.h"

@interface MyFavoritesViewController ()<MyFavoritesViewDataSource,MyFavoritesViewDelegate>{
    NSMutableArray * buttonItems;
    MyFavoritesView * myFavoriteView;
}

@end

@implementation MyFavoritesViewController

- (void)dealloc{
    [buttonItems release];
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)loadView{
    [super loadView];
    [self layoutBgImageView];
}

- (void)layoutBgImageView{
    
    //bgImageView
    UIImage * bgImage = [UIImage imageNamed:@"personcenter_myfavorites"];
    UIImageView * bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    bgImageView.image = bgImage;
    [self.view addSubview:bgImageView];
    [bgImageView release];
    
    //此view盖住状态栏
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 20)];
    view.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    [bgImageView addSubview:view];
    [view release];
    
    [self.view addSubview:[self addNavigationBarView:@"My Favorites" bgColor:[RTSSAppStyle currentAppStyle].navigationBarColor separator:NO]];
//    CGFloat x = 10;
//    CGFloat y = 15;
//    myFavoriteView = [[MyFavoritesView alloc] initWithFrame:CGRectMake(x, y, PHONE_UISCREEN_WIDTH - 2 * x, PHONE_UISCREEN_HEIGHT - 2 * y)];
//    myFavoriteView.titleImage = @"discover_item_icon";
//    myFavoriteView.firstTitle = @"<<Free Spotify Premium and 2GB data>>";
//    myFavoriteView.firstTitleContent = @"Amazing Christmas gifts";
//    myFavoriteView.contentImage = @"discover_item_pic";
//    myFavoriteView.secondTitle = @"<<Free Spotify Premium and 2GB data>>";
//    myFavoriteView.secondTitleContent = @"alskdjflaskjdflkajsldkfjalskdjflaskdjflaskjdflaskdjfasdjflasdkjfalsdkjfalsdjkalsdjfalsdkjflaskdjflasjdflasjdfasjdflskjdflaksjdflaskdjflakdjflasdjfaldjsldkfj;sldkfjaslkdjfalsdjfa;";
//    myFavoriteView.typeImage = @"wallet_service_topup";
//    myFavoriteView.type = @"Device";
//    myFavoriteView.dateString = @"23/12";
//    myFavoriteView.delegate = self;
//    myFavoriteView.dataSource = self;
//    [myFavoriteView updateSubViews];
//    [self.view addSubview:myFavoriteView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"My Favorites";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MyFavoritesViewDataSource
- (NSInteger)numberOfPerformButtons{
    if (!buttonItems) {
        buttonItems = [[NSMutableArray alloc] initWithCapacity:0];
        
        MyFavoritesViewButtonItem * item1 = [[MyFavoritesViewButtonItem alloc] init];
        item1.bgImage = @"common_ question_icon";
        item1.selectBgImage = @"personcenter_cell_myfavorites";
        item1.tag = MyFavoritesViewButtonTypeOne;
        item1.needNum = YES;
        [buttonItems addObject:item1];
        [item1 release];
        
        MyFavoritesViewButtonItem * item2 = [[MyFavoritesViewButtonItem alloc] init];
        item2.bgImage = @"common_ question_icon";
        item2.selectBgImage = @"personcenter_cell_myfavorites";
        item2.tag = MyFavoritesViewButtonTypeTwo;
        [buttonItems addObject:item2];
        [item2 release];
        
        MyFavoritesViewButtonItem * item3 = [[MyFavoritesViewButtonItem alloc] init];
        item3.bgImage = @"common_ question_icon";
        item3.selectBgImage = @"personcenter_cell_myfavorites";
        item3.tag = MyFavoritesViewButtonTypeThree;
        item3.needNum = YES;
        [buttonItems addObject:item3];
        [item3 release];
        
        MyFavoritesViewButtonItem * item4 = [[MyFavoritesViewButtonItem alloc] init];
        item4.bgImage = @"common_ question_icon";
        item4.selectBgImage = @"personcenter_cell_myfavorites";
        item4.tag = MyFavoritesViewButtonTypeFour;
        [buttonItems addObject:item4];
        [item4 release];
    }
    
    return buttonItems.count;
}

- (MyFavoritesViewButtonItem *)itemOfIndex:(NSInteger)index{
    MyFavoritesViewButtonItem * item = [buttonItems objectAtIndex:index];
    return item;
}

#pragma mark - MyFavoritesViewDelegate

- (void)myFavoritesViewBuyButtonClick{
    NSLog(@" my favorites view buy button click");
}

- (void)myFavoritesViewButtonViewsIndexButtonClick:(NSInteger)index IndexTag:(NSInteger)indexTag{
    switch (indexTag) {
        case MyFavoritesViewButtonTypeOne:
        {
            NSLog(@"MyFavoritesViewButtonTypeOne");
        }
            break;
        case MyFavoritesViewButtonTypeTwo:
        {
            NSLog(@"MyFavoritesViewButtonTypeTwo");
        }
            break;
        case MyFavoritesViewButtonTypeThree:
        {
            NSLog(@"MyFavoritesViewButtonTypeThree");
        }
            break;
        case MyFavoritesViewButtonTypeFour:
        {
            NSLog(@"MyFavoritesViewButtonTypeFour");
        }
            break;
 
    }
}


@end
