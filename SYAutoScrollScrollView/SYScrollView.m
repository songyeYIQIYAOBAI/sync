//
//  SYScrollView.m
//  animationDemo
//
//  Created by Dragon on 15/9/11.
//  Copyright (c) 2015年 SY. All rights reserved.
//

#import "SYScrollView.h"
#import "UIImageView+BindItemModel.h"
#import "NSTimer+SYScrollView.h"


static NSString * scorll_direction_left = @"左";
static NSString * scorll_direction_right = @"右";
static NSString * scorll_direction_middle = @"中间";


@interface SYScrollView ()<UIScrollViewDelegate>{
    UIScrollView * mScrollView;
    NSMutableArray * mTotalItems;
    
    NSInteger mCurrentIndex;                        //当前展示图片的index
    NSInteger mCacheIndex;                          //缓存一个index用来记录当前mCurrentIndex的值
    CGFloat mItemWidth;                             //图片的width
    CGFloat mLast_scrollView_content_off_set_x;     //用于scrollView判断滑动方向
    NSString * mScrollDirection;                    //用于判断滑动方向
    BOOL mScrollToImportRect;                       //用bool值来辨别显示的图片的index是否增加1或者减1
    
    CGRect mLeftVacancyFrame;                       //左边空位
    CGRect mLastImageViewFrame;                     //第一个imageView的frame
    CGRect mMiddleImageViewFrame;                   //第二个imageView的frame
    CGRect mNextImageViewFrame;                     //第三个imageView的frame
    CGRect mRightVacancyFrame;                      //右边空位

}

@property (nonatomic , assign)NSTimer * autoScrollTimer;

@end

@implementation SYScrollView


- (void)setAutoScrollEnable:(BOOL)autoScrollEnable{
    _autoScrollEnable = autoScrollEnable;
    
    if (_autoScrollEnable) {
        [self addTimerToAutoScroll];
    }
}

- (void)setAutoScrollSecond:(NSInteger)autoScrollSecond{
    _autoScrollSecond = autoScrollSecond;
}

- (void)addTimerToAutoScroll{
    if (self.autoScrollTimer) {
        [self.autoScrollTimer invalidate];
        self.autoScrollTimer = nil;
    }
    
    NSInteger animationSecond = 3;
    if (self.autoScrollSecond > 0) {
        animationSecond = self.autoScrollSecond;
    }
    
    self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:animationSecond target:self selector:@selector(autoScrollContentViews:) userInfo:nil repeats:YES];
}

- (void)autoScrollContentViews:(NSTimer *)timer{
    [mScrollView setContentOffset:CGPointMake(3 * mItemWidth, 0) animated:YES];
}

- (void)setDataSource:(id<SYScrollViewDataSource>)dataSource{
    _dataSource = dataSource;
    
    [self initData];
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        
    }
    return self;
}

- (void)initViews{
    mScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    mScrollView.backgroundColor = [UIColor clearColor];
    mScrollView.pagingEnabled = YES;
    mScrollView.delegate = self;
    [self addSubview:mScrollView];
  
    mItemWidth = CGRectGetWidth(mScrollView.frame);
    CGFloat height = CGRectGetHeight(mScrollView.frame);

    mLeftVacancyFrame = CGRectMake(0, 0, mItemWidth, height);
    mLastImageViewFrame = CGRectMake(mItemWidth, 0, mItemWidth, height);
    mMiddleImageViewFrame = CGRectMake(2 * mItemWidth, 0, mItemWidth, height);
    mNextImageViewFrame = CGRectMake(3 * mItemWidth, 0, mItemWidth, height);
    mRightVacancyFrame = CGRectMake(4 * mItemWidth, 0, mItemWidth, height);

    //设置scrollView的实际大小
    mScrollView.contentSize = CGSizeMake(5 * mItemWidth, 0);

}

- (void)initData{
    NSInteger totalCount = 0;
    mScrollToImportRect = NO;
    mTotalItems = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfItems)]) {
        totalCount = [_dataSource numberOfItems];
    }
    
    for (int i = 0; i < totalCount; i++) {
        if (_dataSource && [_dataSource respondsToSelector:@selector(itemAtIndex:)]) {
            SYScroll_Item_Model * model = [_dataSource itemAtIndex:i];
            [mTotalItems addObject:model];
        }
    }
    
    //添加imageView 当前的展示的图片的index为0
    mCurrentIndex = 0;
    
    if (mTotalItems.count >= 2) {
        
        UIImageView * lastImageView = [[UIImageView alloc] initWithFrame:mLastImageViewFrame];
        UIImageView * middleImageView = [[UIImageView alloc] initWithFrame:mMiddleImageViewFrame];
        UIImageView * nextImageView = [[UIImageView alloc] initWithFrame:mNextImageViewFrame];
        
        [lastImageView loadImageWithBindingItemModel:[mTotalItems lastObject]];
        [middleImageView loadImageWithBindingItemModel:[mTotalItems firstObject]];
        [nextImageView loadImageWithBindingItemModel:[mTotalItems objectAtIndex:1]];
        
        lastImageView.tag = 99;
        middleImageView.tag = 100;
        nextImageView.tag = 101;
        
        lastImageView.userInteractionEnabled = YES;
        middleImageView.userInteractionEnabled = YES;
        nextImageView.userInteractionEnabled = YES;
        
        [mScrollView addSubview:lastImageView];
        [mScrollView addSubview:middleImageView];
        [mScrollView addSubview:nextImageView];
        
        [mScrollView setContentOffset:CGPointMake(2 * mItemWidth, 0) animated:NO];
        mLast_scrollView_content_off_set_x = 2 * mItemWidth;
        
        
        UITapGestureRecognizer * tapOne  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEventClick:)];
        UITapGestureRecognizer * tapTwo  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEventClick:)];
        UITapGestureRecognizer * tapThree  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEventClick:)];
        
        [lastImageView addGestureRecognizer:tapOne];
        [middleImageView addGestureRecognizer:tapTwo];
        [nextImageView addGestureRecognizer:tapThree];
        
        UILabel * oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 20, 20)];
        oneLabel.backgroundColor = [UIColor yellowColor];
        oneLabel.text = @"1";
        [lastImageView addSubview:oneLabel];
        
        UILabel * twoLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 20, 20)];
        twoLabel.backgroundColor = [UIColor yellowColor];
        twoLabel.text = @"2";
        [middleImageView addSubview:twoLabel];
        
        UILabel * threeLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 20, 20)];
        threeLabel.backgroundColor = [UIColor yellowColor];
        threeLabel.text = @"3";
        [nextImageView addSubview:threeLabel];
        
    }else{
        UIImageView * iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mItemWidth, CGRectGetHeight(mScrollView.frame))];
        [iv loadImageWithBindingItemModel:[mTotalItems objectAtIndex:0]];
        
        [mScrollView addSubview:iv];
        mScrollView.contentSize = CGSizeMake(mItemWidth, 0);
    }
    
}

- (void)tapEventClick:(UITapGestureRecognizer *)tap{
    UIImageView * imageView = (UIImageView *)tap.view;
    NSInteger index = 0;
    
    switch (imageView.tag) {
        case 99:
        {
            index = [self calculateCurrentShowIndexWithOriginValue:mCurrentIndex willAddOneOrMinusOne:-1];
        }
            break;
        case 100:
        {
            index = mCurrentIndex;
        }
            break;
        case 101:
        {
            index = [self calculateCurrentShowIndexWithOriginValue:mCurrentIndex willAddOneOrMinusOne:1];
        }
            break;
            
        default:
            break;
    }
    
    if (self.tapContentViewIndexBlock) {
        self.tapContentViewIndexBlock(index);
    }
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat now_scrollView_content_off_set_x = scrollView.contentOffset.x;
    if (now_scrollView_content_off_set_x > mLast_scrollView_content_off_set_x) {
        mScrollDirection = scorll_direction_left;
    }else{
        mScrollDirection = scorll_direction_right;
    }
    
    
    if (scrollView.contentOffset.x <= (mItemWidth * 3 / 2.0) && !mScrollToImportRect){
        mScrollToImportRect = YES;
        
        //计算当前要显示的图片的index
        mCurrentIndex = [self calculateCurrentShowIndexWithOriginValue:mCurrentIndex willAddOneOrMinusOne:-1];
        [self configerContentViews];
        
//        NSLog(@"当前的currentIndex减小11111 currentIndex :: %ld",mCurrentIndex);

    }else if (scrollView.contentOffset.x > (mItemWidth * 3 / 2.0) && scrollView.contentOffset.x < (mItemWidth * 5 / 2.0)){
        if (!mScrollToImportRect) {
            mCacheIndex = mCurrentIndex;
            
//            NSLog(@"缓存下当前的 currentIndex :: %ld",mCurrentIndex);
        }else{
            
            mScrollDirection = scorll_direction_middle;
            mCurrentIndex = mCacheIndex;
            mScrollToImportRect = NO;
            [self configerContentViews];
            
//            NSLog(@"又回到原始的区域  从缓存获取当前的 currentIndex :: %ld",mCurrentIndex);
        }
    }else if (scrollView.contentOffset.x >= (mItemWidth * 5 / 2.0) && !mScrollToImportRect){
        mScrollToImportRect = YES;
        
        //计算当前要显示的图片的index
        mCurrentIndex = [self calculateCurrentShowIndexWithOriginValue:mCurrentIndex willAddOneOrMinusOne:1];
        [self configerContentViews];
        
//        NSLog(@"当前的currentIndex增加11111 currentIndex :: %ld",mCurrentIndex);

    }
    
    mLast_scrollView_content_off_set_x = scrollView.contentOffset.x;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self.autoScrollTimer pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    [self.autoScrollTimer resumeTimerAfterTimerInterval:self.autoScrollSecond];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    mScrollToImportRect = NO;
    UIImageView * ago_last_imageview = (UIImageView *)[mScrollView viewWithTag:99];
    UIImageView * ago_middle_imageview = (UIImageView *)[mScrollView viewWithTag:100];
    UIImageView * ago_next_imageview = (UIImageView *)[mScrollView viewWithTag:101];

    ago_last_imageview.frame = mLastImageViewFrame;
    ago_middle_imageview.frame = mMiddleImageViewFrame;
    ago_next_imageview.frame = mNextImageViewFrame;
    [mScrollView setContentOffset:CGPointMake(2 * mItemWidth, 0)];

}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];
}

#pragma mark - 计算
- (void)configerContentViews{
    UIImageView * ago_last_imageview = (UIImageView *)[mScrollView viewWithTag:99];
    UIImageView * ago_middle_imageview = (UIImageView *)[mScrollView viewWithTag:100];
    UIImageView * ago_next_imageview = (UIImageView *)[mScrollView viewWithTag:101];
    
    
    if (mScrollDirection == scorll_direction_right) {
        //把最右边的imageView移动到最左边的空位
        ago_next_imageview.frame = mLeftVacancyFrame;
        
        //重新定义它们的tag
        ago_next_imageview.tag = 99;
        ago_last_imageview.tag = 100;
        ago_middle_imageview.tag = 101;

        
        NSInteger now_laster_imageview_index = mCurrentIndex - 1;
        if (now_laster_imageview_index < 0) {
            now_laster_imageview_index = mTotalItems.count - 1;
        }
        [ago_next_imageview loadImageWithBindingItemModel:[mTotalItems objectAtIndex:now_laster_imageview_index]];
        
//        NSLog(@"我已进入计算 contentViews  当前向右右右右右右滑 ");
        
    }else if (mScrollDirection == scorll_direction_left){
        
        //把最右边的imageView移动到最左边的空位
        ago_last_imageview.frame = mRightVacancyFrame;
        
        //重新定义它们的tag
        ago_middle_imageview.tag = 99;
        ago_next_imageview.tag = 100;
        ago_last_imageview.tag = 101;
        
        NSInteger now_laster_imageview_index = mCurrentIndex + 1;
        if (now_laster_imageview_index > mTotalItems.count - 1){
            now_laster_imageview_index = 0;
        }
        [ago_last_imageview loadImageWithBindingItemModel:[mTotalItems objectAtIndex:now_laster_imageview_index]];
        
//        NSLog(@"我已进入计算 contentViews  当前向左左左左左滑 ");
        
    }else if (mScrollDirection == scorll_direction_middle){
        ago_last_imageview.frame = mLastImageViewFrame;
        ago_middle_imageview.frame = mMiddleImageViewFrame;
        ago_next_imageview.frame = mNextImageViewFrame;
        
        [ago_last_imageview loadImageWithBindingItemModel:[mTotalItems objectAtIndex:[self calculateCurrentShowIndexWithOriginValue:mCurrentIndex willAddOneOrMinusOne:-1]]];
        [ago_middle_imageview loadImageWithBindingItemModel:[mTotalItems objectAtIndex:mCurrentIndex]];
        [ago_next_imageview loadImageWithBindingItemModel:[mTotalItems objectAtIndex:[self calculateCurrentShowIndexWithOriginValue:mCurrentIndex willAddOneOrMinusOne:1]]];

    }
}

- (NSInteger)calculateCurrentShowIndexWithOriginValue:(NSInteger)value willAddOneOrMinusOne:(NSInteger)addedIndex{
    //计算将要显示的图片的index
    NSInteger index = value;
    index += addedIndex;
    
    if (index < 0) {
        index = mTotalItems.count - 1;
    }else if (index > mTotalItems.count - 1) {
        index = 0;
    }
    return index;
}

#pragma mark - Block
- (void)setSYScrollViewTapContentViewIndexFinishedBlock:(SYScrollViewTapContentViewIndexFinishedBlock)block{
    self.tapContentViewIndexBlock = block;
}


@end
