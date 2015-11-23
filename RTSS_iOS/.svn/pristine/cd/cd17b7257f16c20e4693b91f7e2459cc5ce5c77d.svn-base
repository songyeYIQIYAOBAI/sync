//
//  TransactionFootPrintHeaderView.m
//  RTSS
//
//  Created by 蔡杰 on 14-10-29.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "TransactionFootPrintHeaderView.h"
#import "PortraitImageView.h"
#import "UIView+RTSSAddView.h"
#import "UILabel+LabelTextColor.h"
#import "RTSSAppDefine.h"
#import "LabelNumberJump.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"
#import "DateUtils.h"

#define kRTSSAvatarItemWidth                    80
#define kRTSSAvatarItemHeight                   110
#define kRTSSAvatarItemTopEdge                  30
#define kRTSSInfoLabelWidth                     100
#define kRTSSButtonsViewHeight                  60             //buttonView高 60
#define kRTSSButtonWidthHeight                  40             //button等宽 40
#define kRTSSButtonsViewButtonToButton          20             //button间距 10

#define KRTSSMothLimit   6   //仅显示半年数据


typedef NS_ENUM(NSInteger, RTSSButtonType){
    RTSSButtonTypeLeft,
    RTSSButtonTypeRight
};



@interface MothButton : UIButton
@property(retain,nonatomic)NSDate *mothDate;
@end

@implementation MothButton

- (void)dealloc{
    [_mothDate release];
    [super dealloc];
}

-(void)setMothDate:(NSDate *)mothDate
{
    if (mothDate == _mothDate) {
        return;
    }
    
   //_month = [DateUtils];
    [self setTitle:[DateUtils getStringDateByDate:mothDate dateFormat:@"MM"] forState:UIControlStateNormal];
    _mothDate = [mothDate retain];
}

@end

#pragma mark --AvatarItemView
@interface AvatarItemView : UIView{
    UILabel *nameLabel;
    PortraitImageView *avatarImageView;
}

-(void)setName:(NSString*)name AvatarUrl:(UIImage*)aUrlstring;

@end


@implementation AvatarItemView

-(void)dealloc{
    [avatarImageView release];
    [super dealloc];
}
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self ) {
        //头像设置
        avatarImageView = [[PortraitImageView alloc] initWithFrame:CGRectMake(0, 0, kRTSSAvatarItemWidth, kRTSSAvatarItemWidth) image:[UIImage imageNamed:@"common_head_icon_d.png"] borderColor:[RTSSAppStyle currentAppStyle].portraitBorderColor borderWidth:1.0];
        [self addSubview:avatarImageView];
        
        //名字
        nameLabel = [CommonUtils labelWithFrame:CGRectMake(CGRectGetMinX(avatarImageView.frame), CGRectGetMaxY(avatarImageView.frame)+10, CGRectGetWidth(avatarImageView.frame), 20) text:@"Ken" textColor:[UIColor whiteColor] textFont:[RTSSAppStyle getRTSSFontWithSize:15.0f] tag:0];
        [nameLabel setTextMainColor];
        [self addSubview:nameLabel];
    }
    return self;
}
-(void)setName:(NSString*)name AvatarUrl:(UIImage*)aUrlstring{
    nameLabel.text = name;
    if (aUrlstring) {
         [avatarImageView setImage:aUrlstring];
    }
}

@end


#pragma mark --UserInfoItemView
@interface BalanceInfoItemView : UIView{
    
    LabelNumberJump *dataLabel;
    UILabel   *infoLabel;
}

-(void)setInfoLabelText:(NSString*)aText;

-(void)setJumpEndNumber:(CGFloat)endNumber;

@end

@implementation BalanceInfoItemView

- (void)dealloc{
    [dataLabel release];
    
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        infoLabel = [CommonUtils labelWithFrame:CGRectMake((self.frame.size.width - kRTSSInfoLabelWidth)/2.0,0, kRTSSInfoLabelWidth, 12) text:@"" textColor:[UIColor whiteColor] textFont:[RTSSAppStyle getRTSSFontWithSize:12.0f] tag:0];
        [infoLabel setTextAuxiliaryColor];
        [self addSubview:infoLabel];
        
        dataLabel = [[LabelNumberJump alloc] init];
        dataLabel.backgroundColor = [UIColor clearColor];
        dataLabel.frame = CGRectMake(12, CGRectGetMaxY(infoLabel.frame)+15, CGRectGetWidth(self.frame)-2*12, 40);
        dataLabel.textAlignment = NSTextAlignmentCenter;
        dataLabel.font = [RTSSAppStyle getRTSSFontWithSize:20.0f];
        dataLabel.adjustsFontSizeToFitWidth = YES;
        dataLabel.decimalsCount = 2;
        dataLabel.unitFront = YES;
        dataLabel.unitString = NSLocalizedString(@"Currency_Unit", nil);
        [dataLabel setTextMainColor];
        [self addSubview:dataLabel];
    }
    return self;
}


-(void)setInfoLabelText:(NSString *)aText{
    infoLabel.text = aText;
}

-(void)setJumpEndNumber:(CGFloat)endNumber{
    [dataLabel jumpNumberWithDuration:3 fromNumber:0.0 toNumber:endNumber isJump:YES];
}

@end

#pragma mark -- TransactionFootPrintHeaderViewButtonItem

@implementation TransactionFootPrintHeaderViewButtonItem
@synthesize bgImage,tag,selectBgImage;

- (void)dealloc{
    [bgImage release];
    [selectBgImage release];
    [super dealloc];
}

@end

@interface ButtonItemView (){
    UIImageView * mImageView;
}
@end

@implementation ButtonItemView

- (void)dealloc{
    [mImageView release];
    [super dealloc];
}

- (void)setType:(ButtonItemViewType)type{
    if (_type != type) {
        _type = type;
        switch (type) {
            case ButtonItemViewTypeDefaule:
                self.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
                break;
            case ButtonItemViewTypeGreen:
                self.backgroundColor = [RTSSAppStyle currentAppStyle].pouringWatterColor;
                break;
            case ButtonItemViewTypeBlue:
                self.backgroundColor = [RTSSAppStyle getFreeResourceColorWithIndex:1];
                break;
            case ButtonItemViewTypeOrangle:
                self.backgroundColor = [RTSSAppStyle currentAppStyle].walletTitleOrgangeColor;
                break;
            case ButtonItemViewTypeClear:
                self.backgroundColor = [UIColor clearColor];
                break;
            default:
                break;
        }
    }
}

- (void)setSelected:(BOOL)selected{
    if (_selected != selected) {
        _selected = selected;
        if (selected) {
            self.type = ButtonItemViewTypeDefaule;
        }else{
            self.type = ButtonItemViewTypeClear;
        }
    }
}

- (void)setImageString:(NSString *)imageString{
    switch (_buttonType) {
        case ButtonItemViewButtonTypeButton:
        {
            [_button setImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
        }
            break;
        case ButtonItemViewButtonTypeImageView:
        {
            [mImageView setImage:[UIImage imageNamed:imageString]];
        }
            break;
    }
}

- (instancetype)initWithFrame:(CGRect)frame interval:(CGFloat)interval Image:(NSString *)imageString backGroundType:(ButtonItemViewType)type buttonType:(ButtonItemViewButtonType)buttonType Tag:(NSInteger)tag{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        self.layer.cornerRadius = self.bounds.size.width/2.0;
        self.layer.masksToBounds = YES;
        self.tag = tag;
        self.buttonType = buttonType;
        switch (buttonType) {
            case ButtonItemViewButtonTypeButton:
            {
                // button
                _button = [UIButton buttonWithType:UIButtonTypeCustom];
                [_button setImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
                _button.frame = CGRectMake(0, 0, self.bounds.size.width - interval, self.bounds.size.width - interval);
                _button.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
                _button.backgroundColor = [UIColor clearColor];
                _button.tag = self.tag;
                [self addSubview:_button];
            }
                break;
            case ButtonItemViewButtonTypeImageView:
            {
                // button
                mImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - interval, self.bounds.size.width - interval)];
                mImageView.image = [UIImage imageNamed:imageString];
                mImageView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
                mImageView.backgroundColor = [UIColor clearColor];
                mImageView.tag = self.tag;
                [self addSubview:mImageView];
            }
                break;
        }
    }
    return self;
}
+ (instancetype)buttonItemViewWithFrame:(CGRect)frame interval:(CGFloat)interval Image:(NSString *)imageString backGroundType:(ButtonItemViewType)type buttonType:(ButtonItemViewButtonType)buttonType Tag:(NSInteger)tag{
    ButtonItemView * item = [[[ButtonItemView alloc] initWithFrame:frame interval:interval Image:imageString backGroundType:type buttonType:buttonType Tag:tag] autorelease];
    return item;
}

@end

#pragma mark  --TransactionFootPrintHeaderView
@interface TransactionFootPrintHeaderView (){
    
    AvatarItemView *avatarView;
    BalanceInfoItemView *incomeView;
    BalanceInfoItemView *expenditureView;
    MothButton *leftButton;
    MothButton *rightButton;
    UILabel *dateLabel;
    UIView * btnsView;
    NSMutableArray * buttonItems;
}

@end

@implementation TransactionFootPrintHeaderView

-(void)dealloc{
    [buttonItems release];
    [btnsView release];
    [avatarView release];
    [incomeView release];
    [expenditureView release];
    [super dealloc];
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

#pragma mark --InstallSubviews

-(void)updateSubViews{
    CGRect aFrame = self.frame;
    
    //dateLable
    dateLabel = [CommonUtils labelWithFrame:CGRectMake(PHONE_UISCREEN_WIDTH/2-50, 5, 100,20) text:@"" textColor:[UIColor whiteColor] textFont:[RTSSAppStyle getRTSSFontWithSize:12.0f] tag:0];
    [dateLabel setTextAuxiliaryColor];
    dateLabel.text = [DateUtils getStringDateByDate:[NSDate date] dateFormat:@"yyyy / MM"];
    [self addSubview:dateLabel];
    
    //
    avatarView = [[AvatarItemView alloc]initWithFrame:CGRectMake(aFrame.size.width/2-kRTSSAvatarItemWidth/2, kRTSSAvatarItemTopEdge, kRTSSAvatarItemWidth, kRTSSAvatarItemHeight)];
    [self addSubview:avatarView];
    
    //距离头像间距  10
    incomeView = [[BalanceInfoItemView alloc]initWithFrame:CGRectMake(0,kRTSSAvatarItemTopEdge+20, PHONE_UISCREEN_WIDTH/2-kRTSSAvatarItemWidth/2-5, 55)];
    [incomeView setInfoLabelText:NSLocalizedString(@"Transaction_Foot_Print_Header_View_Left_Label_Text", nil)];
    [self addSubview:incomeView];
    
    //
    expenditureView = [[BalanceInfoItemView alloc]initWithFrame:CGRectMake(PHONE_UISCREEN_WIDTH/2+5+kRTSSAvatarItemWidth/2,kRTSSAvatarItemTopEdge+20, PHONE_UISCREEN_WIDTH/2-kRTSSAvatarItemWidth/2-5, 55)];
    [expenditureView setInfoLabelText:NSLocalizedString(@"Transaction_Foot_Print_Header_View_Right_Label_Text", nil)];
    [self addSubview:expenditureView];
    
    //
    CGFloat buttonHeight = 30;
    leftButton = [self createButtonWithFrame:CGRectMake(0, 10, buttonHeight, buttonHeight) Type:RTSSButtonTypeLeft];
    leftButton.titleLabel.font = [RTSSAppStyle getRTSSFontWithSize:13.0f];
    leftButton.mothDate = [DateUtils dateBySubtractingMonths:1 by:[NSDate date]];
    [leftButton setTitle:[DateUtils getStringDateByDate:leftButton.mothDate dateFormat:@"MM"] forState:UIControlStateNormal];
    [leftButton setTitleColor:[RTSSAppStyle currentAppStyle].textSubordinateColor forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"service_request_month_left.png"] forState:UIControlStateNormal];
    [self addSubview:leftButton];
    
    //
    rightButton = [self createButtonWithFrame:CGRectMake(PHONE_UISCREEN_WIDTH-buttonHeight, 10, buttonHeight, buttonHeight)Type:RTSSButtonTypeRight];
    rightButton.titleLabel.font = [RTSSAppStyle getRTSSFontWithSize:13.0f];
    rightButton.mothDate = [DateUtils dateByAddingMonths:1 by:[NSDate date]];
    [rightButton setTitle:[DateUtils getStringDateByDate:rightButton.mothDate dateFormat:@"MM"] forState:UIControlStateNormal];
    [rightButton setTitleColor:[RTSSAppStyle currentAppStyle].textSubordinateColor forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"service_request_month_right.png"] forState:UIControlStateNormal];
    rightButton.hidden = YES;
     [self addSubview:rightButton];
    
    if (_headDataSource && [_headDataSource respondsToSelector:@selector(numberOfPerformButtons)] && [_headDataSource respondsToSelector:@selector(itemOfIndex:)]) {
        
        NSInteger num = [_headDataSource numberOfPerformButtons];
        if (num < 0) return;
        
        //buttonsView
       btnsView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(avatarView.frame), aFrame.size.width, kRTSSButtonsViewHeight)];
        btnsView.backgroundColor = [UIColor clearColor];
        [self addSubview:btnsView];
        
        //buttonItems
        if (!buttonItems) {
            buttonItems = [[NSMutableArray alloc] initWithCapacity:0];
        }
        
        //buttonsView add button
        CGFloat leftX = ((PHONE_UISCREEN_WIDTH - num * kRTSSButtonWidthHeight) - (num - 1) * kRTSSButtonsViewButtonToButton)/2.0;
        CGFloat y = (kRTSSButtonsViewHeight - kRTSSButtonWidthHeight) / 2.0;
        for (int i = 0; i < num; i++) {
            TransactionFootPrintHeaderViewButtonItem * btnItem = [_headDataSource itemOfIndex:i];
            [buttonItems addObject:btnItem];
            CGRect frame = CGRectMake(leftX + i * (kRTSSButtonWidthHeight + kRTSSButtonsViewButtonToButton),  y, kRTSSButtonWidthHeight, kRTSSButtonWidthHeight);
            ButtonItemView * item = [ButtonItemView buttonItemViewWithFrame:frame interval:20 Image:btnItem.bgImage backGroundType:ButtonItemViewTypeClear buttonType:ButtonItemViewButtonTypeButton Tag:i];
            [item.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [btnsView addSubview:item];
            
            if (i == 0) {
                item.selected = YES;
            }
        }
    }
    
    //line
    UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
    line.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [self addSubview:line];
    [line release];
}
#pragma mark --Public

-(void)setUserName:(NSString *)name Avatar:(UIImage *)aUrlString{
    
    [avatarView setName:name AvatarUrl:aUrlString];
}

-(void)updateUserIncome:(CGFloat)aIncome expenditure:(CGFloat)aExpenditure{
    [incomeView setJumpEndNumber:aIncome];
    [expenditureView setJumpEndNumber:aExpenditure];
}
-(void)updateCurrentDate{
    
    dateLabel.text = [DateUtils getStringDateByDate:[NSDate date] dateFormat:@"YYYY/MM"];
    leftButton.mothDate = [DateUtils dateBySubtractingMonths:1 by:[NSDate date]];
    //左边button 不显示
    rightButton.hidden = YES;
}

#pragma mark --Action

- (void)buttonClick:(UIButton *)button{
    for (ButtonItemView * item in btnsView.subviews) {
        if ([item isKindOfClass:[ButtonItemView class]]) {
            item.selected = NO;
        }
    }
    ButtonItemView * buttonItem = (ButtonItemView *)button.superview;
    buttonItem.selected = YES;
    
    TransactionFootPrintHeaderViewButtonItem * item = [buttonItems objectAtIndex:buttonItem.tag];
    NSInteger index = buttonItem.tag;
    NSInteger indexTag = item.tag;
    if (_headerDelagate && [_headerDelagate respondsToSelector:@selector(buttonViewsClickButtonIndex:indexTag:)]) {
        [_headerDelagate buttonViewsClickButtonIndex:index indexTag:indexTag];
    }
}

-(void)updateUserDate:(id)sender{
    MothButton *button = (MothButton*)sender;
    //button时间
    NSDate *updateDate = button.mothDate;
    [self updateInterfaceDate:updateDate];
    if (_headerDelagate!= nil && [_headerDelagate respondsToSelector:@selector(updateUserMothDate:)]) {
        [_headerDelagate updateUserMothDate:updateDate];
        
    }
}

-(void)updateInterfaceDate:(NSDate*)aDate{
    
    dateLabel.text = [DateUtils getStringDateByDate:aDate dateFormat:@"YYYY/MM"];
    NSDate *subtracteDate = [DateUtils dateBySubtractingMonths:1 by:aDate];
    
    //判断是否以达上线
    /**
     *  两个时间比较(早,晚,相等)(mask YES代表年月日时分秒全量比较,NO代表只按年月日比较)
     *(fromDate > toDate:NSOrderedDescending)降序
     *(fromDate < toDate:NSOrderedAscending)升序
     *(fromDate = toDate:NSOrderedSame)相等
     */
    
    //leftButton
    //subrtactreDate >= 限制年月
    if (NSOrderedAscending ==[DateUtils compareFromDate:subtracteDate toDate:[DateUtils dateBySubtractingMonths:KRTSSMothLimit by:[NSDate date]] isAll:NO]) {
        //<
        leftButton.hidden = YES;
  
    }else{
        leftButton.mothDate = subtracteDate;
        leftButton.hidden = NO;
    }

    NSDate *addDate = [DateUtils dateByAddingMonths:1 by:aDate];
    //addDate <=[NSDate date]
    if (NSOrderedDescending ==[DateUtils compareFromDate:addDate toDate:[NSDate date] isAll:NO]) {
        //>
        rightButton.hidden = YES;
    }else{
        rightButton.mothDate = addDate;
        rightButton.hidden = NO;
    }
}

#pragma mark --Private

-(MothButton*)createButtonWithFrame:(CGRect)fame Type:(RTSSButtonType)aType{
    MothButton *button = [MothButton buttonWithType:UIButtonTypeCustom];
    button.tag = aType;
    button.frame = fame;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(updateUserDate:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end
