//
//  DateFootprintBaseView.m
//  RTSS
//
//  Created by 蔡杰Alan on 15-3-4.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "DateFootprintBaseView.h"

#define  KRTSSDateMothLimit  6

typedef NS_ENUM(NSInteger, DateButtonType){
    DateButtonTypeLeft,
    DateButtonTypeRight
};

//===========DateButton
@interface DateButton : UIButton
@property(retain,nonatomic)NSDate *date;
@end

@implementation DateButton
- (void)dealloc{
   // [_date release];
    [super dealloc];
}
-(void)updateMothDate:(NSDate *)aDate dateFormat:(NSString*)format
{
    if (aDate == _date) {
        return;
    }
    [self setTitle:[DateUtils getStringDateByDate:aDate dateFormat:format] forState:UIControlStateNormal];
    
    _date = [aDate retain];
}

@end

@interface DateFootprintBaseView (){
    
    
}
@property(nonatomic,retain,readwrite)UILabel *dateLabel;
@property(nonatomic,retain,readwrite)DateButton *leftButton;
@property(nonatomic,retain,readwrite)DateButton *rightButton;

@end
@implementation DateFootprintBaseView
@synthesize dateLabel;
@synthesize leftButton,rightButton;
-(void)dealloc{
    //[leftButton release];
    //[rightButton release];
    [super dealloc];
}
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self updateSubViews];
    }
    
    return self;
}

-(void)updateSubViews{

    CGFloat buttonHeight = 25;
    CGFloat buttonWidth  = 25;
    CGFloat buttonTextFontSize = 11.f;
    CGFloat dateLabelTextFontSize = 12.f;
    if (PHONE_UISCREEN_IPHONE6PLUS) {
        buttonHeight = 30;
        buttonWidth  = 30;
        buttonTextFontSize = 13.f;
        dateLabelTextFontSize = 14;
    }
    //dateLable
    dateLabel = [CommonUtils labelWithFrame:CGRectMake(PHONE_UISCREEN_WIDTH/2-50, 10, 100,20) text:@"" textColor:[UIColor whiteColor] textFont:[RTSSAppStyle getRTSSFontWithSize:dateLabelTextFontSize] tag:0];
    [dateLabel setTextAuxiliaryColor];
    dateLabel.text = [DateUtils getStringDateByDate:[NSDate date] dateFormat:@"MM/yyyy"];
    [self addSubview:dateLabel];
     //

    leftButton = [self createButtonWithFrame:CGRectMake(0, 10, buttonWidth, buttonHeight) Type:DateButtonTypeLeft];
    leftButton.titleLabel.font = [RTSSAppStyle getRTSSFontWithSize:buttonTextFontSize];
    leftButton.date = [DateUtils dateBySubtractingMonths:1 by:[NSDate date]];
    [leftButton setTitle:[DateUtils getStringDateByDate:leftButton.date dateFormat:@"MM"] forState:UIControlStateNormal];
    [leftButton setTitleColor:[RTSSAppStyle currentAppStyle].textSubordinateColor forState:UIControlStateNormal];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"service_request_month_left.png"] forState:UIControlStateNormal];
    [self addSubview:leftButton];
    
    //
    rightButton = [self createButtonWithFrame:CGRectMake(PHONE_UISCREEN_WIDTH-buttonWidth, 10, buttonWidth, buttonHeight)Type:DateButtonTypeRight];
    rightButton.titleLabel.font = [RTSSAppStyle getRTSSFontWithSize:buttonTextFontSize];
    rightButton.date = [DateUtils dateByAddingMonths:1 by:[NSDate date]];
    [rightButton setTitle:[DateUtils getStringDateByDate:rightButton.date dateFormat:@"MM"] forState:UIControlStateNormal];
    [rightButton setTitleColor:[RTSSAppStyle currentAppStyle].textSubordinateColor forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"service_request_month_right.png"] forState:UIControlStateNormal];
    rightButton.hidden = YES;
    [self addSubview:rightButton];
    
    //line
    UIImageView *line = [[UIImageView alloc] init];
    line.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    line.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
    [self addSubview:line];
    [line release];
}
#pragma mark --Public
-(void)updateCurrentDate{
    NSDate* begin = [DateUtils dateBySubtractingMonths:self.dateInterval by:[NSDate date]];
    dateLabel.text = [DateUtils getStringDateByDate:begin dateFormat:@"YYYY/MM"];
   // leftButton.date = [DateUtils dateBySubtractingMonths:1 by:[NSDate date]];
    [leftButton updateMothDate:[DateUtils dateBySubtractingMonths:1 by:begin] dateFormat:@"MM"];
    //左边button 不显示
    rightButton.hidden = YES;
}

#pragma mark --Action
-(void)updateActionUserDate:(id)sender{
    DateButton *button = (DateButton*)sender;

    //button时间
    NSDate *updateDate = button.date;
    [self updateInterfaceDate:updateDate];
    if (_delegate!= nil && [_delegate respondsToSelector:@selector(updateUserDate:)]) {
        [_delegate updateUserDate:updateDate];
    }
}

-(void)updateInterfaceDate:(NSDate*)aDate{
    
    dateLabel.text = [DateUtils getStringDateByDate:aDate dateFormat:@"MM/yyyy"];
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
    if (NSOrderedAscending ==[DateUtils compareFromDate:subtracteDate toDate:[DateUtils dateBySubtractingMonths:KRTSSDateMothLimit by:[NSDate date]] isAll:NO]) {
        //<
        leftButton.hidden = YES;
        
    }else{
        //leftButton.date = subtracteDate;
        [leftButton updateMothDate:subtracteDate dateFormat:@"MM"];
        leftButton.hidden = NO;
    }
    
    NSDate *addDate = [DateUtils dateByAddingMonths:1 by:aDate];
    NSDate* begin = [DateUtils dateBySubtractingMonths:self.dateInterval by:[NSDate date]];

    //addDate <=[NSDate date]
    if (NSOrderedDescending ==[DateUtils compareFromDate:addDate toDate:begin isAll:NO]) {
        //>
        rightButton.hidden = YES;
    }else{
        //rightButton.date = addDate;
        [rightButton updateMothDate:addDate dateFormat:@"MM"];

        rightButton.hidden = NO;
    }
}

#pragma mark --Private

-(DateButton*)createButtonWithFrame:(CGRect)fame Type:(DateButtonType)aType{
    DateButton *button = [DateButton buttonWithType:UIButtonTypeCustom];
    button.tag = aType;
    button.frame = fame;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(updateActionUserDate:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
@end
