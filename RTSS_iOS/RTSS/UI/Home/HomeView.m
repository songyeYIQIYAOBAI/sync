//
//  HomeView.m
//  RTSS
//
//  Created by shengyp on 14/10/23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "HomeView.h"
#import "RTSSAppDefine.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"
#import "PortraitImageView.h"

#pragma mark ========导航条目=====
@implementation HomeNavigationBar
@synthesize logoImageView, portraitImageView;

- (void)dealloc
{
    [logoImageView release];
    [portraitImageView release];
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutContent];
    }
    return self;
}

- (void)layoutContent
{
    // =====
     CGRect logoFrame = CGRectMake((CGRectGetWidth(self.bounds)-44)/2.0, 20+(CGRectGetHeight(self.bounds)-44-20)/2.0, 44, 44);
     logoImageView = [[UIImageView alloc] initWithFrame:logoFrame];
     logoImageView.backgroundColor = [UIColor clearColor];
     logoImageView.image = [UIImage imageNamed:@"common_rtss_launch_logo.png"];
     [self addSubview:logoImageView];
    
    // ====
    CGRect portraitFrame = CGRectMake((CGRectGetWidth(self.bounds)-60), 20+(CGRectGetHeight(self.bounds)-40-20)/2.0, 40, 40);
    portraitImageView = [[PortraitImageView alloc] initWithFrame:portraitFrame image:[UIImage imageNamed:@"friends_default_icon.png"] borderColor:[RTSSAppStyle currentAppStyle].portraitBorderColor borderWidth:1.0];
    [self addSubview:portraitImageView];
    
    // ====
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds)-1, CGRectGetWidth(self.bounds), 1)];
    lineView.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [self addSubview:lineView];
    [lineView release];
}

- (void)showHomeNavigationBar
{
    if(0.0 == self.alpha){
        [UIView animateWithDuration:1.0 animations:^{
            self.alpha = 1.0;
        }];
    }
}

- (void)dismissHomeNavigationBar
{
    if(1.0 == self.alpha){
        [UIView animateWithDuration:1.0 animations:^{
            self.alpha = 0.0;
        }];
    }
}

@end

#pragma mark ========宫格样式
@implementation HomeGridStyle

@synthesize gridItemWidth,gridItemHeight,gridItemX_SP,gridItemY_SP,gridItemX_H,gridItemY_H,gridItemSeparatorSize;
@synthesize gridItemIconWidth, gridItemIconHeight,gridItemTextHeight;
@synthesize rowCount,columnCount;

-(void)dealloc{
    [super dealloc];
}

-(id)init{
    self = [super init];
    if(self){
        
    }
    return self;
}

+ (HomeGridStyle*)defaultStyle{
    HomeGridStyle* styleTemp = [[[HomeGridStyle alloc] init] autorelease];
    
    styleTemp.gridItemWidth = 140;
    styleTemp.gridItemHeight = 90;
    styleTemp.gridItemX_SP = 0;
    styleTemp.gridItemY_SP = 0;
    styleTemp.gridItemX_H = 0;
    styleTemp.gridItemY_H = 0;
    styleTemp.gridItemIconWidth = 50;
    styleTemp.gridItemIconHeight = 50;
    styleTemp.gridItemTextHeight = 20;
    styleTemp.gridItemSeparatorSize = 0.5;
    
    styleTemp.rowCount = 4;
    styleTemp.columnCount = 2;
    
    if(PHONE_UISCREEN_IPHONE5){
        styleTemp.gridItemHeight    = 100;
        styleTemp.gridItemY_H       = 10;
    }else if(PHONE_UISCREEN_IPHONE6){
        styleTemp.gridItemWidth     = 167;
        styleTemp.gridItemHeight    = 120;
        styleTemp.gridItemY_H       = 20;
    }else if(PHONE_UISCREEN_IPHONE6PLUS){
        styleTemp.gridItemWidth     = 187;
        styleTemp.gridItemHeight    = 140;
        styleTemp.gridItemY_H       = 30;
        styleTemp.gridItemTextHeight = 30;
    }
    
    return styleTemp;
}

@end

#pragma mark ========一个宫格视图
@implementation HomeGridItemView
@synthesize gridItemButton, gridItemImageView, gridItemLabel, delegate, gridItemIndexTag;
@synthesize gridItemBottomSeparatorView, gridItemRightSeparatorView;
@synthesize isBottomSeparator, isRightSeparator;
@synthesize gridItemStyle;

- (void)dealloc{
    [gridItemImageView release];
    [gridItemBottomSeparatorView release];
    [gridItemRightSeparatorView release];
    
    [gridItemStyle release];
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.gridItemIndexTag = HomeGridViewIndexDefault;
        self.gridItemStyle = [HomeGridStyle defaultStyle];
        [self layoutContent];
    }
    return self;
}

- (void)layoutContent{
    HomeGridStyle* style = self.gridItemStyle;
    
    gridItemImageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.bounds)-style.gridItemIconWidth)/2.0, (CGRectGetHeight(self.bounds)-style.gridItemIconHeight-style.gridItemTextHeight)/2.0, style.gridItemIconWidth, style.gridItemIconHeight)];
    gridItemImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:gridItemImageView];
    
    gridItemLabel = [CommonUtils labelWithFrame:CGRectMake(0, CGRectGetMaxY(gridItemImageView.frame), CGRectGetWidth(self.bounds), style.gridItemTextHeight) text:@"" textColor:[RTSSAppStyle currentAppStyle].textMajorColor textFont:[RTSSAppStyle getRTSSFontWithSize:15.0] tag:0];
    gridItemLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:gridItemLabel];
    
    gridItemBottomSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds)-style.gridItemSeparatorSize, CGRectGetWidth(self.bounds), style.gridItemSeparatorSize)];
    gridItemBottomSeparatorView.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    gridItemBottomSeparatorView.hidden = YES;
    [self addSubview:gridItemBottomSeparatorView];
    
    gridItemRightSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds)-style.gridItemSeparatorSize, 0, style.gridItemSeparatorSize, CGRectGetHeight(self.bounds))];
    gridItemRightSeparatorView.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    gridItemRightSeparatorView.hidden = YES;
    [self addSubview:gridItemRightSeparatorView];
    
    gridItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    gridItemButton.frame = self.bounds;
    gridItemButton.exclusiveTouch = YES;
    [gridItemButton addTarget:self action:@selector(gridItemButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:gridItemButton];
}

- (void)gridItemButtonAction:(UIButton*)button{
    
    if(HomeGridViewIndexDefault == self.gridItemIndexTag) return;
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [UIView transitionWithView:self duration:0.6 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        
    } completion:^(BOOL finished) {
        if(nil != delegate && [delegate respondsToSelector:@selector(homeGridItemView:selectedIndex:)]){
            [delegate homeGridItemView:self selectedIndex:self.gridItemIndexTag];
        }
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}

- (void)setGridItemBottomSeparator:(BOOL)bottomSeparator
{
    isBottomSeparator = bottomSeparator;
    
    gridItemBottomSeparatorView.hidden = !bottomSeparator;
}

- (void)setGridItemRightSeparator:(BOOL)rightSeparator
{
    isRightSeparator = rightSeparator;
    
    gridItemRightSeparatorView.hidden = !rightSeparator;
}

- (void)setHomeGridItemFrame:(CGRect)frame style:(HomeGridStyle*)gridStyle
{
    [super setFrame:frame];
    
    self.gridItemStyle = gridStyle;
    
    CGFloat w = gridStyle.gridItemWidth;
    CGFloat h = gridStyle.gridItemHeight;
    CGFloat icon_w = gridStyle.gridItemIconWidth;
    CGFloat icon_h = gridStyle.gridItemIconHeight;
    CGFloat text_h = gridStyle.gridItemTextHeight;
    CGFloat separator = gridStyle.gridItemSeparatorSize;
    
    gridItemImageView.frame = CGRectMake((w-icon_w)/2.0, (h-icon_h-text_h)/2.0, icon_w, icon_h);
    gridItemLabel.frame = CGRectMake(0, CGRectGetMaxY(gridItemImageView.frame), w, text_h);
    gridItemBottomSeparatorView.frame = CGRectMake(0, h-separator, w, separator);
    gridItemRightSeparatorView.frame = CGRectMake(w-separator, 0, separator, h);
    gridItemButton.frame = CGRectMake(0, 0, w, h);
}

+ (NSNumber*)getHomeGridItemIndexTagByString:(NSString*)string
{
    NSInteger indexTag = HomeGridViewIndexDefault;
    
    if([@"HomeGridViewIndexUsageOverView" isEqualToString:string]){
        indexTag = HomeGridViewIndexUsageOverView;
    }else if([@"HomeGridViewIndexUsageExplore" isEqualToString:string]){
        indexTag = HomeGridViewIndexUsageExplore;
    }else if([@"HomeGridViewIndexUsageData" isEqualToString:string]){
        indexTag = HomeGridViewIndexUsageData;
    }else if([@"HomeGridViewIndexQuickOrder" isEqualToString:string]){
        indexTag = HomeGridViewIndexQuickOrder;
    }else if([@"HomeGridViewIndexTurboBoost" isEqualToString:string]){
        indexTag = HomeGridViewIndexTurboBoost;
    }else if([@"HomeGridViewIndexTransfer" isEqualToString:string]){
        indexTag = HomeGridViewIndexTransfer;
    }else if([@"HomeGridViewIndexTransform" isEqualToString:string]){
        indexTag = HomeGridViewIndexTransform;
    }else if([@"HomeGridViewIndexWallet" isEqualToString:string]){
        indexTag = HomeGridViewIndexWallet;
    }else if([@"HomeGridViewIndexBudgetControl" isEqualToString:string]){
        indexTag = HomeGridViewIndexBudgetControl;
    }else if([@"HomeGridViewIndexDiscovery" isEqualToString:string]){
        indexTag = HomeGridViewIndexDiscovery;
    }else if([@"HomeGridViewIndexMessages" isEqualToString:string]){
        indexTag = HomeGridViewIndexMessages;
    }else if([@"HomeGridViewIndexCustomerSupport" isEqualToString:string]){
        indexTag = HomeGridViewIndexCustomerSupport;
    }else if([@"HomeGridViewIndexServiceRequest" isEqualToString:string]){
        indexTag = HomeGridViewIndexServiceRequest;
    }else if([@"HomeGridViewIndexSettings" isEqualToString:string]){
        indexTag = HomeGridViewIndexSettings;
    }else{
        indexTag = HomeGridViewIndexDefault;
    }
    
    return [NSNumber numberWithInteger:indexTag];
}

+ (HomeGridItemView*)layoutHomeGridItemView:(HomeGridViewIndex)gridViewIndex delegate:(id)aDelegate{
    HomeGridItemView* homeGridItemView = [[HomeGridItemView alloc] initWithFrame:CGRectZero];
    homeGridItemView.backgroundColor = [UIColor clearColor];
    homeGridItemView.gridItemIndexTag = gridViewIndex;
    homeGridItemView.delegate = aDelegate;
    switch (gridViewIndex) {
        case HomeGridViewIndexUsageExplore:{
            homeGridItemView.gridItemImageView.image = [UIImage imageNamed:@"home_icon_myusage.png"];
            homeGridItemView.gridItemLabel.text = NSLocalizedString(@"Home_Menu_Usage_Explore", nil);
            break;
        }
        case HomeGridViewIndexUsageOverView:{
            homeGridItemView.gridItemImageView.image = [UIImage imageNamed:@"home_icon_balance.png"];
            homeGridItemView.gridItemLabel.text = NSLocalizedString(@"Home_Menu_Usage_Overview", nil);
            break;
        }
        case HomeGridViewIndexUsageData:{
            homeGridItemView.gridItemImageView.image = [UIImage imageNamed:@"home_icon_data_usage.png"];
            homeGridItemView.gridItemLabel.text = NSLocalizedString(@"Home_Menu_Usage_Data", nil);
            break;
        }
        case HomeGridViewIndexQuickOrder:{
            homeGridItemView.gridItemImageView.image = [UIImage imageNamed:@"home_icon_quick_order.png"];
            homeGridItemView.gridItemLabel.text = NSLocalizedString(@"Home_Menu_Quick_Order", nil);
            break;
        }
        case HomeGridViewIndexTurboBoost:{
            homeGridItemView.gridItemImageView.image = [UIImage imageNamed:@"home_icon_turboboost.png"];
            homeGridItemView.gridItemLabel.text = NSLocalizedString(@"Home_Menu_Turbo_Boost", nil);
            break;
        }
        case HomeGridViewIndexTransfer:{
            homeGridItemView.gridItemImageView.image = [UIImage imageNamed:@"home_icon_transfer.png"];
            homeGridItemView.gridItemLabel.text = NSLocalizedString(@"Home_Menu_Transfer", nil);
            break;
        }
        case HomeGridViewIndexTransform:{
            homeGridItemView.gridItemImageView.image = [UIImage imageNamed:@"home_icon_balance_transfer.png"];
            homeGridItemView.gridItemLabel.text = NSLocalizedString(@"Home_Menu_Transform", nil);
            break;
        }
        case HomeGridViewIndexWallet:{
            homeGridItemView.gridItemImageView.image = [UIImage imageNamed:@"home_icon_wallet.png"];
            homeGridItemView.gridItemLabel.text = NSLocalizedString(@"Home_Menu_Wallet", nil);
            break;
        }
        case HomeGridViewIndexBudgetControl:{
            homeGridItemView.gridItemImageView.image = [UIImage imageNamed:@"home_icon_budget.png"];
            homeGridItemView.gridItemLabel.text = NSLocalizedString(@"Home_Menu_Budget_Control", nil);
            break;
        }
        case HomeGridViewIndexDiscovery:{
            homeGridItemView.gridItemImageView.image = [UIImage imageNamed:@"home_icon_discovery.png"];
            homeGridItemView.gridItemLabel.text = NSLocalizedString(@"Home_Menu_Discover", nil);
            break;
        }
        case HomeGridViewIndexMessages:{
            homeGridItemView.gridItemImageView.image = [UIImage imageNamed:@"home_icon_message.png"];
            homeGridItemView.gridItemLabel.text = NSLocalizedString(@"Home_Menu_Messages", nil);
            break;
        }
        case HomeGridViewIndexCustomerSupport:{
            homeGridItemView.gridItemImageView.image = [UIImage imageNamed:@"home_icon_support.png"];
            homeGridItemView.gridItemLabel.text = NSLocalizedString(@"Home_Menu_Customer_Support", nil);
            break;
        }
        case HomeGridViewIndexServiceRequest:{
            homeGridItemView.gridItemImageView.image = [UIImage imageNamed:@"home_icon_service.png"];
            homeGridItemView.gridItemLabel.text = NSLocalizedString(@"Home_Menu_Service_Request", nil);
            break;
        }
        case HomeGridViewIndexSettings:{
            homeGridItemView.gridItemImageView.image = [UIImage imageNamed:@"home_icon_settings.png"];
            homeGridItemView.gridItemLabel.text = NSLocalizedString(@"Home_Menu_Settings", nil);
            break;
        }
        default:
            break;
    }
    
    return [homeGridItemView autorelease];
}

@end

#pragma mark ========多个宫格组合视图
@interface HomeGridView(){
    
    NSMutableArray* gridItemArray;
    
}

@end

@implementation HomeGridView

- (void)dealloc{
    [gridItemArray release];
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        gridItemArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)addGridItemView:(HomeGridItemView*)gridItemView{
    [gridItemArray addObject:gridItemView];
}

- (void)loadHomeGridView{
    HomeGridStyle* gridStyle = [HomeGridStyle defaultStyle];
    if ([gridItemArray count] > 0) {
        
        CGFloat w = gridStyle.gridItemWidth;
        CGFloat h = gridStyle.gridItemHeight;
        CGFloat x_sp = gridStyle.gridItemX_SP;
        CGFloat y_sp = gridStyle.gridItemY_SP;
        CGFloat x_h = gridStyle.gridItemX_H;
        CGFloat y_h = gridStyle.gridItemY_H;
        
        int rowCountTemp = [gridItemArray count]%gridStyle.columnCount == 0 ? [gridItemArray count]/gridStyle.columnCount : [gridItemArray count]/gridStyle.columnCount+1;
        
        for (int i = 0; i < gridStyle.rowCount; i ++) {
            
            for (int j = 0; j < gridStyle.columnCount; j ++) {
                int index = (j + i * gridStyle.columnCount);
                if(index >= [gridItemArray count]){
                    break;
                }
                HomeGridItemView* itemView = [gridItemArray objectAtIndex:index];
                if(nil != itemView){
                    [itemView setHomeGridItemFrame:CGRectMake(j*w+j*x_sp+x_h, i*h+i*y_sp+y_h, w, h) style:gridStyle];
                    itemView.isRightSeparator = (j%gridStyle.columnCount != (gridStyle.columnCount-1));
                    itemView.isBottomSeparator = (i%rowCountTemp != (rowCountTemp-1));
                    [self addSubview:itemView];
                }
            }
        }
    }
}

- (HomeGridItemView*)getHomeGridItemViewWithIndex:(HomeGridViewIndex)gridViewIndex{
    HomeGridItemView* gridItemView = nil;
    for (HomeGridItemView* itemView in gridItemArray) {
        if(itemView.gridItemIndexTag == gridViewIndex){
            gridItemView = itemView;
            break;
        }
    }
    return gridItemView;
}

@end

#pragma mark ========一页菜单视图
@implementation HomeMenuView
@synthesize gridView;

- (void)dealloc{
    [gridView release];
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutContent];
    }
    return self;
}

- (void)layoutContent{
    gridView = [[HomeGridView alloc] initWithFrame:CGRectZero];
    gridView.backgroundColor = [UIColor clearColor];
    [self addSubview:gridView];
}

@end

#pragma mark ========主页视图
@interface HomeView ()<UIScrollViewDelegate>{
    UIScrollView* homeScrollView;
    
    NSMutableArray* pageViewArray;
}

@end

@implementation HomeView
@synthesize homePageControl, delegate;

- (void)dealloc{
    
    [homeScrollView release];
    [homePageControl release];
    
    [pageViewArray release];
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        pageViewArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        [self layoutContent];
    }
    return self;
}

- (void)layoutContent{
    homeScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    homeScrollView.backgroundColor = [UIColor clearColor];
    homeScrollView.scrollEnabled = YES;
    homeScrollView.pagingEnabled = YES;
    homeScrollView.showsHorizontalScrollIndicator = NO;
    homeScrollView.showsVerticalScrollIndicator = NO;
    homeScrollView.delegate = self;
    [self addSubview:homeScrollView];
    
    homePageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-20, self.bounds.size.width, 20)];
    homePageControl.backgroundColor = [UIColor clearColor];
    homePageControl.pageIndicatorTintColor = [RTSSAppStyle currentAppStyle].pageIndicatorTintColor;
    homePageControl.currentPageIndicatorTintColor = [RTSSAppStyle currentAppStyle].currentPageIndicatorTintColor;
    homePageControl.hidesForSinglePage = YES;
    homePageControl.defersCurrentPageDisplay = YES;
    [self addSubview:homePageControl];
}

- (void)scrollEnabled:(BOOL)enabled{
    homeScrollView.scrollEnabled = enabled;
}

- (void)addPageView:(UIView*)pageView{
    [pageViewArray addObject:pageView];
}

- (void)addPageArrayView:(NSArray*)pageViews{
    for (int i = 0; i < [pageViews count]; i ++) {
        [self addPageView:[pageViews objectAtIndex:i]];
    }
}

- (void)removeAllPageView{
    [pageViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [pageViewArray removeAllObjects];
}

- (void)loadHomeView{
    [self loadHomeViewWithIndex:0];
}

- (void)loadHomeViewWithIndex:(NSInteger)index{
    for (int i = 0; i < [pageViewArray count]; i ++) {
        UIView* pageView = [pageViewArray objectAtIndex:i];
        pageView.frame = CGRectMake(i*homeScrollView.bounds.size.width, pageView.frame.origin.y, pageView.bounds.size.width, pageView.bounds.size.height);
        [homeScrollView addSubview:pageView];
    }
    
    homeScrollView.contentSize = CGSizeMake(homeScrollView.bounds.size.width*[pageViewArray count], homeScrollView.bounds.size.height);
    homePageControl.numberOfPages = [pageViewArray count];
    
    if(index >= 0 && index < [pageViewArray count]){
        homePageControl.currentPage = index;
    }else if(index >= [pageViewArray count]){
        homePageControl.currentPage = [pageViewArray count] == 0 ? 0 : [pageViewArray count]-1;
    }else{
        homePageControl.currentPage = 0;
    }
}

- (HomeGridItemView*)getHomeGridItemViewWithIndex:(HomeGridViewIndex)itemGridViewIndex{
    HomeGridItemView* gridItemView = nil;
    for (UIView* pageView in pageViewArray) {
        if([pageView isKindOfClass:[HomeMenuView class]]){
            HomeGridItemView* itemView = [((HomeMenuView*)pageView).gridView getHomeGridItemViewWithIndex:itemGridViewIndex];
            if(nil != itemView){
                gridItemView = itemView;
                break;
            }
        }
    }
    return gridItemView;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if(homePageControl.currentPage != page){
        if(nil != delegate && [delegate respondsToSelector:@selector(homeView:viewDisappear:)]){
            [delegate homeView:self viewDisappear:homePageControl.currentPage];
        }
        if(nil != delegate && [delegate respondsToSelector:@selector(homeView:viewWillAppear:)]){
            [delegate homeView:self viewWillAppear:page];
        }
    }
    homePageControl.currentPage = page;
}

@end
