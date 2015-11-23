//
//  MyFavoritesView.m
//  RTSS
//
//  Created by 宋野 on 15-1-21.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "MyFavoritesView.h"
#import "RTSSAppStyle.h"

#define LEFT_VIEW_INTERVAL              10.0
#define TOP_VIEW_INTERVAL               15.0
#define TITLE_IMAGE_WIDTH               40.0
#define TITLE_HEIGHT                    20.0
#define CONTENT_IMAGE_HEIGHT            150.0
#define BUTTON_WIDTH                    70.0
#define BUTTON_HEIGHT                   15.0

#define ITEM_INTERVAL                   8.0

#define TITLE_FONT                      12.0
#define CONTENT_FONT                    10.0

#define BUTTONS_VIEW_HEIGHT             50.0
#define BUTTONSVIEW_BUTTON_WIDTH        40.0
#define BUTTONSVIEW_BUTTON_TO_BUTTON    25.0



@implementation MyFavoritesViewButtonItem
@synthesize bgImage,selectBgImage,tag,needNum;

- (void)dealloc{
    [bgImage release];
    [selectBgImage release];
    [super dealloc];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        needNum = NO;
    }
    return self;
}

@end

@interface MyFavoritesView (){
    UIView * btnsView;
    NSMutableArray * buttonItems;
}

@end

@implementation MyFavoritesView
@synthesize titleImage,firstTitle,firstTitleContent,contentImage,secondTitle,secondTitleContent,typeImage,type,dateString;

- (void)dealloc{
    [btnsView release];
    [titleImage release];
    [firstTitle release];
    [firstTitleContent release];
    [contentImage release];
    [secondTitle release];
    [secondTitleContent release];
    [typeImage release];
    [type release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
        self.layer.cornerRadius = 7.0;
        self.layer.borderWidth = 2.0;
        self.layer.borderColor = [RTSSAppStyle currentAppStyle].navigationBarColor.CGColor;
    }
    return self;
}

- (void)updateSubViews{
    //titleImage
    UIImageView * tImage = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_VIEW_INTERVAL, TOP_VIEW_INTERVAL, TITLE_IMAGE_WIDTH, TITLE_IMAGE_WIDTH)];
    tImage.image = [UIImage imageNamed:titleImage];
    tImage.layer.cornerRadius = 5.0;
    [self addSubview:tImage];
    [tImage release];
    
    //firstTitle
    UILabel * fTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tImage.frame)+ITEM_INTERVAL, TOP_VIEW_INTERVAL, self.bounds.size.width - TITLE_IMAGE_WIDTH - 2 * LEFT_VIEW_INTERVAL - ITEM_INTERVAL, TITLE_HEIGHT)];
    fTitle.font = [UIFont systemFontOfSize:TITLE_FONT];
    fTitle.backgroundColor = [UIColor clearColor];
    fTitle.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    fTitle.textAlignment = NSTextAlignmentLeft;
    fTitle.text = firstTitle;
    [self addSubview:fTitle];
    [fTitle release];
    
    //date
    UILabel * date = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - LEFT_VIEW_INTERVAL - 30, 5, 30, 13)];
    date.font = [UIFont systemFontOfSize:CONTENT_FONT];
    date.backgroundColor = [UIColor clearColor];
    date.textColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
    date.textAlignment = NSTextAlignmentRight;
    date.text = dateString;
    [self addSubview:date];
    [date release];
    
    //firstTitleContent
    UILabel * ftContent = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(fTitle.frame), CGRectGetMaxY(fTitle.frame), CGRectGetWidth(fTitle.frame), 12)];
    ftContent.font = [UIFont systemFontOfSize:CONTENT_FONT];
    ftContent.backgroundColor = [UIColor clearColor];
    ftContent.textColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
    ftContent.textAlignment = NSTextAlignmentLeft;
    ftContent.text = firstTitleContent;
    [self addSubview:ftContent];
    [ftContent release];
    
    //contentImage
    UIImageView * cImageView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_VIEW_INTERVAL, CGRectGetMaxY(tImage.frame)+ITEM_INTERVAL, self.bounds.size.width - 2 * LEFT_VIEW_INTERVAL, CONTENT_IMAGE_HEIGHT)];
    cImageView.image = [UIImage imageNamed:contentImage];
    [self addSubview:cImageView];
    [cImageView release];
    
    //secondTitle
    UILabel * sTitle = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_VIEW_INTERVAL, CGRectGetMaxY(cImageView.frame)+10, self.bounds.size.width - 2 * LEFT_VIEW_INTERVAL, TITLE_HEIGHT)];
    sTitle.font = [UIFont systemFontOfSize:TITLE_FONT];
    sTitle.backgroundColor = [UIColor clearColor];
    sTitle.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    sTitle.textAlignment = NSTextAlignmentLeft;
    sTitle.text = secondTitle;
    [self addSubview:sTitle];
    [sTitle release];
    
    //secondTitleContent
    CGSize size = [self contentSize:secondTitleContent];
    UILabel * stContent = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_VIEW_INTERVAL, CGRectGetMaxY(sTitle.frame)+5, self.bounds.size.width - 2 * LEFT_VIEW_INTERVAL,size.height)];
    stContent.numberOfLines = 0;
    stContent.font = [UIFont systemFontOfSize:CONTENT_FONT];
    stContent.backgroundColor = [UIColor clearColor];
    stContent.textColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
    stContent.textAlignment = NSTextAlignmentLeft;
    stContent.text = secondTitleContent;
    [self addSubview:stContent];
    [stContent release];
    
    //typeImage
    UIImageView * tImageView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT_VIEW_INTERVAL, CGRectGetMaxY(stContent.frame)+20, 20, 20)];
    tImageView.image = [UIImage imageNamed:typeImage];
    [self addSubview:tImageView];
    [tImageView release];
    
    //typeLable
    UILabel * tTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tImageView.frame)+ITEM_INTERVAL, CGRectGetMinY(tImageView.frame), self.bounds.size.width - 2 * LEFT_VIEW_INTERVAL - CGRectGetWidth(tImageView.frame) - ITEM_INTERVAL - BUTTON_WIDTH, CGRectGetHeight(tImageView.frame))];
    tTitle.font = [UIFont systemFontOfSize:CONTENT_FONT];
    tTitle.backgroundColor = [UIColor clearColor];
    tTitle.textColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
    tTitle.textAlignment = NSTextAlignmentLeft;
    tTitle.text = type;
    [self addSubview:tTitle];
    [tTitle release];
    
    //button
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.bounds.size.width - LEFT_VIEW_INTERVAL - BUTTON_WIDTH, tImageView.center.y - BUTTON_HEIGHT/2.0, BUTTON_WIDTH, BUTTON_HEIGHT);
    button.titleLabel.font = [UIFont systemFontOfSize:CONTENT_FONT];
    button.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    button.layer.cornerRadius = 3.0;
    [button setTitle:@"To Buy" forState:UIControlStateNormal];
    [button setTitleColor:[RTSSAppStyle currentAppStyle].textSubordinateColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    //line
    UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame)+20, self.bounds.size.width, 2)];
    line.image = [UIImage imageNamed:@"common_separator_line.png"];
    [self addSubview:line];
    [line release];
    
    if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfPerformButtons)] && [_dataSource respondsToSelector:@selector(itemOfIndex:)]) {
        NSInteger num = [_dataSource numberOfPerformButtons];
        if (num < 0) return;
        
        //buttonsView
        btnsView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), self.bounds.size.width, BUTTONS_VIEW_HEIGHT)];
        btnsView.backgroundColor = [UIColor clearColor];
        [self addSubview:btnsView];
        
        //buttonItems
        if (!buttonItems) {
            buttonItems = [[NSMutableArray alloc] initWithCapacity:0];
        }
        
        //buttonsView add button
        CGFloat leftX = ((self.bounds.size.width - num * BUTTONSVIEW_BUTTON_WIDTH) - (num - 1) * BUTTONSVIEW_BUTTON_TO_BUTTON)/2.0;
        CGFloat y = (BUTTONS_VIEW_HEIGHT - BUTTONSVIEW_BUTTON_WIDTH) / 2.0;
        for (int i = 0; i < num; i++) {
            MyFavoritesViewButtonItem * btnItem = [_dataSource itemOfIndex:i];
            [buttonItems addObject:btnItem];
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(leftX + i * (BUTTONSVIEW_BUTTON_WIDTH + BUTTONSVIEW_BUTTON_TO_BUTTON),  y, BUTTONSVIEW_BUTTON_WIDTH, BUTTONSVIEW_BUTTON_WIDTH);
            [button setBackgroundImage:[UIImage imageNamed:btnItem.bgImage] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:btnItem.selectBgImage] forState:UIControlStateSelected];
            button.backgroundColor = [UIColor clearColor];
            //            [button setImage:[UIImage imageNamed:btnItem.bgImage] forState:UIControlStateNormal];
            //            [button setImage:[UIImage imageNamed:btnItem.selectBgImage] forState:UIControlStateSelected];
            button.tag = i;
            [button addTarget:self action:@selector(buttonViewIndexClick:) forControlEvents:UIControlEventTouchUpInside];
            [btnsView addSubview:button];
            
            //如果需要数字 添加数字
            if (btnItem.needNum) {
                UILabel * numLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame),CGRectGetMinY(button.frame),20,8)];
                numLabel.font = [UIFont systemFontOfSize:CONTENT_FONT];
                numLabel.backgroundColor = [UIColor clearColor];
                numLabel.textColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
                numLabel.textAlignment = NSTextAlignmentLeft;
                numLabel.text = @"88+";
                [btnsView addSubview:numLabel];
                [numLabel release];
            }
        }
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, CGRectGetMaxY(btnsView.frame));
}

#pragma mark - Events

- (void)buyButtonClick:(UIButton *)button{
    if (_delegate && [_delegate respondsToSelector:@selector(myFavoritesViewBuyButtonClick)]) {
        [_delegate myFavoritesViewBuyButtonClick];
    }
}

- (void)buttonViewIndexClick:(UIButton *)button{
    if (_delegate && [_delegate respondsToSelector:@selector(myFavoritesViewButtonViewsIndexButtonClick:IndexTag:)]) {
        MyFavoritesViewButtonItem * btnItem = [buttonItems objectAtIndex:button.tag];
        [_delegate myFavoritesViewButtonViewsIndexButtonClick:button.tag IndexTag:btnItem.tag];
    }
}

#pragma mark - Private

- (CGSize)contentSize:(NSString *)content{
    CGSize contentSize;
    if([[[UIDevice currentDevice]  systemVersion] floatValue]<= 7.0)
    {
        
        CGSize maximumLabelSize = CGSizeMake(self.frame.size.width - 2 * LEFT_VIEW_INTERVAL,9999);
        contentSize = [content sizeWithFont:[UIFont systemFontOfSize:CONTENT_FONT] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    }
    else
    {
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        NSDictionary * attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:CONTENT_FONT],
                                      NSParagraphStyleAttributeName : paragraphStyle};
        CGSize size = CGSizeMake(self.bounds.size.width - 2 * LEFT_VIEW_INTERVAL, 9999);
        contentSize = [content boundingRectWithSize:size
                                              options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                           attributes:attributes
                                              context:nil].size;
    }
    return contentSize;
}

@end
