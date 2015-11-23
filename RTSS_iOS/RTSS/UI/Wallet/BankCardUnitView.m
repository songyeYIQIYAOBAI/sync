//
//  BankCardUnitView.m
//  RTSS
//
//  Created by 蔡杰Alan on 15-1-26.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "BankCardUnitView.h"
#import "BankUnitCell.h"
#import "RTSSAppStyle.h"
#define kBanlanceViewHeight  60.0f
#define kAddCardButtonHeight 40.0f
#define kSubViewEdge  10.0f //子视图到两边的距离
#define kSubViewWidth  self.bounds.size.width-2*kSubViewEdge
#define kBankCardCellSpace  10.0f
#define kOtherSpace  15.0f //balanceView  距离顶部距离  以及添加按钮距离上一个视图的距离
#define kBankCardCellHeight 120.0f

@interface BankCardUnitView ()<BankUnitCellDelegate,UIScrollViewDelegate>
/**
 *   @abstract 用于显示成员
 */
@property(nonatomic,retain)UIScrollView *scrollView;
/**
 *   @abstract 用于管理成员
 */
@property(nonatomic,retain)NSMutableArray *unitList;

@property(nonatomic,retain)NSMutableArray *unitCellList;


/**
 *  添加卡片操作
 */
@property(nonatomic,retain)AddCardButton *defaultAddCardButton;

@end


@implementation BankCardUnitView
-(void)dealloc{
    
    [_scrollView release];
    [_unitList release];
    [_defaultAddCardButton release];
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        [self setProperty];
    }
    return self;
}
- (void) setProperty
{
    _unitList = [[NSMutableArray alloc] init];
    _cardTouch = NO;
    //scrollView
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.frame = self.bounds;
    _scrollView.scrollEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.alwaysBounceHorizontal = NO;
   // _scrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    [self scrollViewAddCardButton];
    _scrollView.contentSize = [self contentSizeForUIScrollView:0];
    [self addSubview:_scrollView];
}
-(void)scrollViewAddCardButton{
    _defaultAddCardButton = [[AddCardButton alloc]initWithFrame:CGRectMake(kSubViewEdge,kOtherSpace, kSubViewWidth, kAddCardButtonHeight)];
        [_defaultAddCardButton addTarget:self action:@selector(addBankCard) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_defaultAddCardButton];
}
#pragma mark --Action
-(void)addBankCard{
    
    if (_delagte && [_delagte respondsToSelector:@selector(bankCardUnitAddcard)]) {
        [_delagte bankCardUnitAddcard];
    }
}

#pragma mark --Public

-(void)setScrollViewBgColor:(UIColor *)bgColor{
    
    [_scrollView setBackgroundColor:bgColor];
}

-(void)setAddButtonBgColor:(UIColor*)bgColor{
    [_defaultAddCardButton setBackgroundColor:bgColor];
}
-(void)reloaDataWithArray:(NSArray *)array{
    self.unitList = [array mutableCopy];
    
    for (int i = 0; i< self.unitList.count; i++) {
        [self addBankCardView:i];
    }
  _scrollView.contentSize=[self contentSizeForUIScrollView:self.unitList.count];
    
}

#pragma mark --Private
/**
 *  计算scrollView ContentSize
 *
 *  @param index 计算size
 *
 *  @return ContentSize
 */

- (CGSize)contentSizeForUIScrollView:(int)index
{
    float height = (kBankCardCellSpace + kBankCardCellHeight) * index+(kAddCardButtonHeight+kOtherSpace);
    if (height < _scrollView.bounds.size.height)
        height = _scrollView.bounds.size.height;
    return CGSizeMake(_scrollView.bounds.size.width, height);
}
/**
 *  向后移动伴随移动效果
 *
 */
-(void)addBankCardView:(int)index{
    
    __block BankUnitCell *newUnitCell;
    CGFloat y = (kBankCardCellSpace + kBankCardCellHeight) * index+kBankCardCellSpace;
    newUnitCell = [[BankUnitCell alloc] initWithFrame:CGRectMake(kSubViewEdge, y, kSubViewWidth, kBankCardCellHeight)];
    newUnitCell.backgroundColor = [UIColor colorWithRed:183.0/255 green:58.0/255 blue:68.0/255 alpha:0.5];
    newUnitCell.alpha = 0.1;
    newUnitCell.delegate = self;
    [_scrollView addSubview:newUnitCell];
   
    _defaultAddCardButton.alpha = 0.5;
    
    [UIView animateWithDuration:0.5 animations:^(){
        CGRect rect = _defaultAddCardButton.frame;
        rect.origin.y += (kBankCardCellSpace + kBankCardCellHeight);
        _defaultAddCardButton.frame = rect;
        _defaultAddCardButton.alpha = 1.0;
        newUnitCell.alpha = 0.8;
        
    } completion:^(BOOL finished){
        newUnitCell.alpha = 1.0;
        
    }];
    [newUnitCell release];

}
- (void)bankUnitCellTouched:(BankUnitCell *)unitCell;{
    
    if (!_cardTouch) {
        return;
    }
}
- (void)isNeedResetFrame{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
