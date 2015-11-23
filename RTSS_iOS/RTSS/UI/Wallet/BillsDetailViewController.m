//
//  BillsDetailViewController.m
//  RTSS
//
//  Created by 宋野 on 15-4-14.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "BillsDetailViewController.h"
#import "SinglePickerController.h"
#import "CommonUtils.h"
#import "DateUtils.h"
#import "Session.h"
#import "Customer.h"

#define TITLE_LABEL_LEFT_INTERVAL           15
#define CELL_TITLE_LABEL_HEITHT             12
#define SESSTION_TITLE_LABEL_HEITHT         17
#define TITLE_LABEL_Y                       8

#define IS_NEED_EXPEND_IMAGE_WIDTH          20


#define CELL_HEIGHT                         40
#define SESSION_HEIGHT                      45
#define TITLE_LABEL_WIDTH_MAX              PHONE_UISCREEN_WIDTH - 2 * TITLE_LABEL_LEFT_INTERVAL - 50

@protocol DatePickerViewDelegate <NSObject>

- (void)datePickerViewChooseDate:(NSDate *)date;

@end

@interface DatePickerView : UIView{
    UIDatePicker * pickerControl;
    
    CGRect initPickerViewFrame;
    CGRect choosePickerViewFrame;
}

@property (nonatomic ,assign)id<DatePickerViewDelegate>delegate;

- (void)choosePickerViewFrame:(BOOL)ischoose;

@end

@implementation DatePickerView

- (void)dealloc{
    [pickerControl release];
    [super dealloc];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews{
    initPickerViewFrame = CGRectMake(0, PHONE_UISCREEN_HEIGHT, PHONE_UISCREEN_WIDTH, 259);
    choosePickerViewFrame = CGRectMake(0, PHONE_UISCREEN_HEIGHT-259, PHONE_UISCREEN_WIDTH, 259);
    self.frame = initPickerViewFrame;
    self.backgroundColor = [UIColor clearColor];
    
    UINavigationBar* navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 44)];
    navBar.barStyle = UIBarStyleBlack;
    
    UIBarButtonItem* cancelPicker = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self
                                                                                  action:@selector(cancelPicker:)];
    
    
    UIBarButtonItem* donePicker = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(donePicker:)];
    
    UINavigationItem* navItem = [[UINavigationItem alloc] init];
    navItem.rightBarButtonItem = donePicker;
    navItem.leftBarButtonItem = cancelPicker;
    [donePicker release];
    [cancelPicker release];
    
    [navBar pushNavigationItem:navItem animated:YES];
    [navItem release];
    
    [self addSubview:navBar];
    [navBar release];
    
    pickerControl = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,44, PHONE_UISCREEN_WIDTH, 215)];
    NSDate * today = [NSDate date];
    pickerControl.date = today;
    pickerControl.datePickerMode = UIDatePickerModeDate;
    
    //set minDate maxDate
    NSDate * minimumDate = [DateUtils dateBySubtractingMonths:6 by:today];
    NSDate * maximumDate = [DateUtils dateBySubtractingMonths:1 by:today];
    pickerControl.minimumDate = [DateUtils dateAtStartOfDayByDate:minimumDate];
    pickerControl.maximumDate = [DateUtils dateAtEndOfDayByDate:maximumDate];
    
    pickerControl.backgroundColor = [UIColor clearColor];
    [pickerControl setDatePickerMode:UIDatePickerModeDate];
    [self addSubview:pickerControl];
    
}

- (void)cancelPicker:(id)action
{
    [self choosePickerViewFrame:NO];
}

- (void)donePicker:(id)action
{
    [self choosePickerViewFrame:NO];
    
    NSDate* date = [pickerControl date];
    
    if (_delegate && [_delegate respondsToSelector:@selector(datePickerViewChooseDate:)]) {
        [_delegate datePickerViewChooseDate:date];
    }
}

- (void)choosePickerViewFrame:(BOOL)ischoose{
    CGRect frame = CGRectZero;
    if (ischoose) {
        frame = choosePickerViewFrame;
    }else{
        frame = initPickerViewFrame;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = frame;
    }];
}

@end



@interface BillsDetailTableViewCell : UITableViewCell{
    UILabel * myTitleLabel;
    UILabel * messageLabel;
}

@property (nonatomic ,retain)NSString * titleString;
@property (nonatomic ,retain)NSString * messageString;

@end

@implementation BillsDetailTableViewCell

- (void)dealloc{
    [_titleString release];
    [_messageString release];
    [myTitleLabel release];
    [messageLabel release];
    [super dealloc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
        self.frame = CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, CELL_HEIGHT);
        [self initViews];
    }
    return self;
}

- (void)setTitleString:(NSString *)titleString{
    if (_titleString != titleString) {
        [_titleString release];
        _titleString = [titleString retain];
    }
    CGFloat textWidth = [CommonUtils calculateTextSize:_titleString constrainedSize:CGSizeMake(TITLE_LABEL_WIDTH_MAX, TITLE_LABEL_Y) textFont:[RTSSAppStyle getRTSSFontWithSize:12] lineBreakMode:NSLineBreakByWordWrapping].width;
    myTitleLabel.frame = CGRectMake(CGRectGetMinX(myTitleLabel.frame), CGRectGetMinY(myTitleLabel.frame), textWidth, CGRectGetHeight(myTitleLabel.frame));
    myTitleLabel.text = _titleString;
    
    
}

- (void)setMessageString:(NSString *)messageString{
    if (_messageString != messageString) {
        [_messageString release];
        _messageString = [messageString retain];
    }
    
    CGFloat textWidth = [CommonUtils calculateTextSize:_messageString constrainedSize:CGSizeMake(TITLE_LABEL_WIDTH_MAX, TITLE_LABEL_Y) textFont:[RTSSAppStyle getRTSSFontWithSize:12] lineBreakMode:NSLineBreakByWordWrapping].width;
    
    messageLabel.frame = CGRectMake(PHONE_UISCREEN_WIDTH - TITLE_LABEL_LEFT_INTERVAL - textWidth, CGRectGetMinY(messageLabel.frame), textWidth, CGRectGetHeight(messageLabel.frame));
    messageLabel.text = _messageString;
}

- (void)initViews{
    
    CGFloat y = (CGRectGetHeight(self.frame) - CELL_TITLE_LABEL_HEITHT) / 2.0;
    //myTitleLabel
    myTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_LABEL_LEFT_INTERVAL, y, 10, CELL_TITLE_LABEL_HEITHT)];
    myTitleLabel.backgroundColor = [UIColor clearColor];
    myTitleLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    myTitleLabel.font = [RTSSAppStyle getRTSSFontWithSize:12];
    [self.contentView addSubview:myTitleLabel];
    

    //messageLabel
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(PHONE_UISCREEN_WIDTH - TITLE_LABEL_LEFT_INTERVAL - 10 , y, 10, CELL_TITLE_LABEL_HEITHT)];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.textColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
    messageLabel.font = [RTSSAppStyle getRTSSFontWithSize:12];
    [self.contentView addSubview:messageLabel];

    
    //line
    UIImageView * line = [[[UIImageView alloc] initWithFrame:CGRectMake(0, CELL_HEIGHT, PHONE_UISCREEN_WIDTH , 1)] autorelease];
    line.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [self.contentView addSubview:line];

}


@end

@protocol BillsSectionViewDeleage <NSObject>

- (void)billsSectionViewExpendBtnClick:(BOOL)expend section:(NSInteger)section;

@end

@interface BillsSectionView : UIView{
    UILabel * myTitleLabel;
    UILabel * messageLabel;
    UIButton * isNeedExpendImageView;
}

@property (nonatomic ,retain)NSString * titleString;
@property (nonatomic ,retain)NSString * messageString;
@property (nonatomic ,assign)BOOL       isNeedExpend;
@property (nonatomic ,assign)NSInteger  section;
@property (nonatomic ,assign)id <BillsSectionViewDeleage> delegate;


@end

@implementation BillsSectionView

- (void)dealloc{
    [_titleString release];
    [_messageString release];
    [myTitleLabel release];
    [messageLabel release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
        [self initViews];
    }
    return self;
}

- (void)setTitleString:(NSString *)titleString{
    if (_titleString != titleString) {
        [_titleString release];
        _titleString = [titleString retain];
    }
    CGFloat textWidth = [CommonUtils calculateTextSize:_titleString constrainedSize:CGSizeMake(TITLE_LABEL_WIDTH_MAX, TITLE_LABEL_Y) textFont:[RTSSAppStyle getRTSSFontWithSize:16] lineBreakMode:NSLineBreakByWordWrapping].width;
    myTitleLabel.frame = CGRectMake(CGRectGetMinX(myTitleLabel.frame), CGRectGetMinY(myTitleLabel.frame), textWidth, CGRectGetHeight(myTitleLabel.frame));
    myTitleLabel.text = _titleString;
    
    
}

- (void)setMessageString:(NSString *)messageString{
    if (_messageString != messageString) {
        [_messageString release];
        _messageString = [messageString retain];
    }
    
    CGFloat textWidth = [CommonUtils calculateTextSize:_messageString constrainedSize:CGSizeMake(TITLE_LABEL_WIDTH_MAX, TITLE_LABEL_Y) textFont:[RTSSAppStyle getRTSSFontWithSize:16] lineBreakMode:NSLineBreakByWordWrapping].width;
    
    CGFloat x = 0;
    if (isNeedExpendImageView) {
        x = CGRectGetMinX(isNeedExpendImageView.frame) - textWidth - 5;
    }else{
        x = PHONE_UISCREEN_WIDTH - TITLE_LABEL_LEFT_INTERVAL - textWidth;
    }
    
    messageLabel.frame = CGRectMake(x, CGRectGetMinY(messageLabel.frame),textWidth, CGRectGetHeight(messageLabel.frame));
    messageLabel.text = _messageString;
}

- (void)setIsNeedExpend:(BOOL)isNeedExpend{
    _isNeedExpend = isNeedExpend;
    
    if (_isNeedExpend) {
        if (isNeedExpendImageView == nil) {
            CGFloat y = (CGRectGetHeight(self.frame) - IS_NEED_EXPEND_IMAGE_WIDTH) / 2.0;

            
            isNeedExpendImageView = [UIButton buttonWithType:UIButtonTypeCustom];
            isNeedExpendImageView.frame = CGRectMake(PHONE_UISCREEN_WIDTH -  TITLE_LABEL_LEFT_INTERVAL - IS_NEED_EXPEND_IMAGE_WIDTH , y, IS_NEED_EXPEND_IMAGE_WIDTH, IS_NEED_EXPEND_IMAGE_WIDTH);
            isNeedExpendImageView.selected = NO;
            [isNeedExpendImageView setImage:[UIImage imageNamed:@"common_arrow_down.png"] forState:UIControlStateNormal];
            [self addSubview:isNeedExpendImageView];
            
            [isNeedExpendImageView addTarget:self action:@selector(expendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }else{
        if (isNeedExpendImageView) {
            [isNeedExpendImageView removeFromSuperview];
            isNeedExpendImageView = nil;
        }
    }
    
    CGFloat x = 0;
    if (isNeedExpendImageView) {
        x = CGRectGetMinX(isNeedExpendImageView.frame) - CGRectGetWidth(messageLabel.frame) - 5;
    }else{
        x = PHONE_UISCREEN_WIDTH - TITLE_LABEL_LEFT_INTERVAL - CGRectGetWidth(messageLabel.frame);
    }
    
    messageLabel.frame = CGRectMake(x, CGRectGetMinY(messageLabel.frame), CGRectGetWidth(messageLabel.frame), CGRectGetHeight(messageLabel.frame));
}

- (void)initViews{
    
    CGFloat y = (CGRectGetHeight(self.frame) - SESSTION_TITLE_LABEL_HEITHT) / 2.0;
    
    //myTitleLabel
    myTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_LABEL_LEFT_INTERVAL, y, 10, SESSTION_TITLE_LABEL_HEITHT)];
    myTitleLabel.backgroundColor = [UIColor clearColor];
    myTitleLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    myTitleLabel.font = [RTSSAppStyle getRTSSFontWithSize:16];
    [self addSubview:myTitleLabel];

    //messageLabel
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(PHONE_UISCREEN_WIDTH - TITLE_LABEL_LEFT_INTERVAL - 10 , y, 10, SESSTION_TITLE_LABEL_HEITHT)];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.textColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
    messageLabel.font = [RTSSAppStyle getRTSSFontWithSize:16];
    [self addSubview:messageLabel];
    
    //line
    UIImageView * line = [[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 1, PHONE_UISCREEN_WIDTH, 1)] autorelease];
    line.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [self addSubview:line];
}

- (void)expendBtnClick:(UIButton *)button{
    NSLog(@" !button.selected : %d",!button.selected);

    button.selected = !button.selected;
    NSLog(@"button.selected : %d",button.selected);
    if (_delegate && [_delegate respondsToSelector:@selector(billsSectionViewExpendBtnClick: section:)]) {
        [_delegate billsSectionViewExpendBtnClick:button.selected section:self.section];;
    }
    
    float angle = 0;
    if (button.selected == YES) {
        angle = M_PI;
    }else{
        angle = -M_PI;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
       button.transform = CGAffineTransformRotate(button.transform, angle);

    }];
}

@end

@interface BillsDetailTableFootView : UIView{
    UILabel * myTitleLabel;
    UILabel * messageLabel;
    UIImageView * line;
}

@property (nonatomic ,retain)NSString * titleString;
@property (nonatomic ,retain)NSString * messageString;

- (void)lineShow:(BOOL)show;


@end

@implementation BillsDetailTableFootView

- (void)dealloc{
    [_titleString release];
    [_messageString release];
    [myTitleLabel release];
    [messageLabel release];
    [line release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
        [self initViews];
    }
    return self;
}

- (void)setTitleString:(NSString *)titleString{
    if (_titleString != titleString) {
        [_titleString release];
        _titleString = [titleString retain];
    }
    CGFloat textWidth = [CommonUtils calculateTextSize:_titleString constrainedSize:CGSizeMake(TITLE_LABEL_WIDTH_MAX, TITLE_LABEL_Y) textFont:[RTSSAppStyle getRTSSFontWithSize:16] lineBreakMode:NSLineBreakByWordWrapping].width;
    myTitleLabel.frame = CGRectMake(CGRectGetMinX(myTitleLabel.frame), CGRectGetMinY(myTitleLabel.frame), textWidth, CGRectGetHeight(myTitleLabel.frame));
    myTitleLabel.text = _titleString;
    
}

- (void)setMessageString:(NSString *)messageString{
    if (_messageString != messageString) {
        [_messageString release];
        _messageString = [messageString retain];
    }
    
    CGFloat textWidth = [CommonUtils calculateTextSize:_messageString constrainedSize:CGSizeMake(TITLE_LABEL_WIDTH_MAX, TITLE_LABEL_Y) textFont:[RTSSAppStyle getRTSSFontWithSize:16] lineBreakMode:NSLineBreakByWordWrapping].width;
    
    messageLabel.frame = CGRectMake(PHONE_UISCREEN_WIDTH - TITLE_LABEL_LEFT_INTERVAL - textWidth, CGRectGetMinY(messageLabel.frame), textWidth, CGRectGetHeight(messageLabel.frame));
    messageLabel.text = _messageString;
}


- (void)initViews{
    //line
    line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 1)];
    line.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    line.hidden = YES;
    [self addSubview:line];
    
    //myTitleLabel
    CGFloat y = 10;
    myTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_LABEL_LEFT_INTERVAL, y, 10, SESSTION_TITLE_LABEL_HEITHT)];
    myTitleLabel.backgroundColor = [UIColor clearColor];
    myTitleLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    myTitleLabel.font = [RTSSAppStyle getRTSSFontWithSize:16];
    [self addSubview:myTitleLabel];
    
    //messageLabel
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(PHONE_UISCREEN_WIDTH - TITLE_LABEL_LEFT_INTERVAL - 10 , y, 10, SESSTION_TITLE_LABEL_HEITHT)];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.textColor = [RTSSAppStyle currentAppStyle].textBlueColor;
    messageLabel.font = [RTSSAppStyle getRTSSFontWithSize:16];
    [self addSubview:messageLabel];

}

- (void)lineShow:(BOOL)show{
    if (show) {
        line.hidden = NO;
    }else{
        line.hidden = YES;
    }
}

@end

@interface BillsDetailTableHeadView : UIView{
    UILabel * fromLabel;
    UILabel * toLabel;
    UILabel * fromDateLabel;
    UILabel * toDateLabel;
}
@property(nonatomic ,retain)NSString * fromDateString;
@property(nonatomic ,retain)NSString * toDateString;

@end

@implementation BillsDetailTableHeadView

- (void)dealloc{
    [fromLabel release];
    [toLabel release];
    [fromDateLabel release];
    [toDateLabel release];
    [_fromDateString release];
    [_toDateString release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
        [self initViews];
    }
    return self;
}

- (void)setFromDateString:(NSString *)fromDateString{
    if (_fromDateString != fromDateString) {
        [_fromDateString release];
        _fromDateString = [fromDateString retain];
    }
    
    fromDateLabel.text = _fromDateString;
}

- (void)setToDateString:(NSString *)toDateString{
    if (_toDateString != toDateString) {
        [_toDateString release];
        _toDateString = [toDateString retain];
    }
    
    toDateLabel.text = _toDateString;
}

- (void)initViews{
    CGFloat width = 30;
    CGFloat height = 13;
    CGFloat leftInterval = 50;
    CGFloat y = (CGRectGetHeight(self.frame) - height) / 2.0;

    //fromLabel
    fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftInterval, y, width, height)];
    fromLabel.backgroundColor = [UIColor clearColor];
    fromLabel.font = [RTSSAppStyle getRTSSFontWithSize:12];
    fromLabel.textColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
    fromLabel.text = @"From";
    [self addSubview:fromLabel];
    
    //fromDateLabel
    width = 60;
    fromDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(fromLabel.frame) + 5, y, width, height)];
    fromDateLabel.backgroundColor = [UIColor clearColor];
    fromDateLabel.font = [RTSSAppStyle getRTSSFontWithSize:12];
    fromDateLabel.textColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
    fromDateLabel.text = @"01/02/2015";
    [self addSubview:fromDateLabel];
    
    //toDateLabel
    toDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(PHONE_UISCREEN_WIDTH - leftInterval - width , y, width, height)];
    toDateLabel.backgroundColor = [UIColor clearColor];
    toDateLabel.font = [RTSSAppStyle getRTSSFontWithSize:12];
    toDateLabel.textColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
    toDateLabel.text = @"31/03/2015";
    [self addSubview:toDateLabel];
    
    //toLabel
    width = 20;
    toLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(toDateLabel.frame) - width - 5, y, width, height)];
    toLabel.backgroundColor = [UIColor clearColor];
    toLabel.font = [RTSSAppStyle getRTSSFontWithSize:12];
    toLabel.textColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
    toLabel.text = @"To";
    [self addSubview:toLabel];
    
    //line
    UIImageView * line = [[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 1, PHONE_UISCREEN_WIDTH, 1)] autorelease];
    line.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [self addSubview:line];
}

@end


@interface BillsDetailTableView : UITableView

@end

@implementation BillsDetailTableView

- (void)dealloc{
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
    }
    return self;
}

@end

@interface BillsDetailViewController ()<BillsSectionViewDeleage,UITableViewDelegate,UITableViewDataSource,DatePickerViewDelegate,MappActorDelegate>{
    BillsDetailTableView * myTableView;
    BillsDetailTableHeadView * myTableHeadView;
    BillsDetailTableFootView * myTableFootView;
    DatePickerView * myPicker;

    NSArray * infoDatas;
    NSMutableArray * arrDatas;
    NSMutableArray * sectionsArray;
    
    NSString * startDateString;
    NSString * endDateString;
    
    NSInteger  expandedSection;
    BOOL expanded;
}

@end


@implementation BillsDetailViewController

- (void)dealloc{
    [myTableView release];
    [myTableHeadView release];
    [myTableFootView release];
    [arrDatas release];
    [sectionsArray release];
    [myPicker release];
    [infoDatas release];
    [startDateString release];
    [endDateString release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    if (myPicker) {
        [myPicker choosePickerViewFrame:NO];
        [myPicker removeFromSuperview];

    }
}

- (void)loadView{
    [super loadView];
    [self initViews];
}

- (void)initViews{
    self.view.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    //add navi bar
    UIView * navi = [self addNavigationBarView:NSLocalizedString(@"Bills_Detail_Navi_Title", nil) bgColor:[RTSSAppStyle currentAppStyle].navigationBarColor separator:YES];
    [self.view addSubview:navi];
    
    //add rightItemButton
    CGFloat rightInterval = 20;
    CGFloat btnwidth = 26;
    
    UIButton * rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItemButton.frame = CGRectMake(CGRectGetWidth(navi.frame) - rightInterval - btnwidth, 27, btnwidth, btnwidth);
    [rightItemButton setImage:[UIImage imageNamed:@"Bills_Detail_right_btn_image.png"] forState:UIControlStateNormal];
    [rightItemButton addTarget:self action:@selector(rightBarButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [navi addSubview:rightItemButton];
    
    //foot view
    CGFloat footViewHeight = 50;
    myTableFootView = [[BillsDetailTableFootView alloc] initWithFrame:CGRectMake(0, PHONE_UISCREEN_HEIGHT - footViewHeight, PHONE_UISCREEN_WIDTH, footViewHeight)];
    [self.view addSubview:myTableFootView];

    //tableView
    myTableView = [[BillsDetailTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(navi.frame), PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT - 64 - CGRectGetHeight(myTableFootView.frame)) style:UITableViewStylePlain];
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    
    myTableHeadView = [[BillsDetailTableHeadView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 35)];
    NSDate * lastMonthDate = [DateUtils dateBySubtractingMonths:1 by:[NSDate date]];
    NSDate * lastMonthDateFirstDay = [DateUtils dateAtStartOfDayByDate:lastMonthDate];
    NSDate * lastMonthDateEndDay = [DateUtils dateAtEndOfDayByDate:lastMonthDate];
    myTableHeadView.fromDateString = [DateUtils getStringDateByDate:lastMonthDateFirstDay dateFormat:@"dd-MM-yyyy"];
    myTableHeadView.toDateString = [DateUtils getStringDateByDate:lastMonthDateEndDay dateFormat:@"dd-MM-yyyy"];
    startDateString = [[DateUtils getStringDateByDate:lastMonthDateFirstDay dateFormat:@"yyyyMMddHHmmss"] retain];
    endDateString = [[DateUtils getStringDateByDate:lastMonthDateEndDay dateFormat:@"yyyyMMddHHmmss"] retain];
    
    myTableView.tableHeaderView = myTableHeadView;
    [self updateTableHeadViewData:[DateUtils dateBySubtractingMonths:1 by:[NSDate date]]];
    
    [self.view addSubview:myTableView];
    
}

- (void)loadData{
    
    
    [[Session sharedSession].mMyCustomer getMyBillWithAccountId:[Session sharedSession].mCurrentAccount.mId andType:1 andStartDate:startDateString andEndDate:endDateString andDelegate:self];
    arrDatas = [[NSMutableArray alloc] initWithCapacity:0];
    
}

- (void)updateTableHeadViewData:(NSDate *)date{
    NSDate * firstDate = [DateUtils dateAtStartOfDayByDate:date];
    NSDate * endDate = [DateUtils dateAtEndOfDayByDate:date];
    
    NSString* first = [DateUtils getStringDateByDate:firstDate dateFormat:@"dd/MM/yyyy"];
    NSString* end = [DateUtils getStringDateByDate:endDate dateFormat:@"dd/MM/yyyy"];
    startDateString = [[DateUtils getStringDateByDate:firstDate dateFormat:@"yyyyMMddHHmmss"] retain];
    endDateString = [[DateUtils getStringDateByDate:endDate dateFormat:@"yyyyMMddHHmmss"] retain];

    
    myTableHeadView.fromDateString = first;
    myTableHeadView.toDateString = end;
    
    [[Session sharedSession].mMyCustomer queryUsageDetailWithSubscriberId:[Session sharedSession].mCurrentAccount.mId andType:1 andStartDate:startDateString andEndDate:endDateString andDelegate:self];

}

- (void)updateTableFootViewData:(NSString *)string{
    
    myTableFootView.titleString = NSLocalizedString(@"Bills_Detail_FootView_Label_Title", nil);
    myTableFootView.messageString = string;

}

- (void)viewDidLoad{
    [super viewDidLoad];
}

#pragma mark - Action

- (void)rightBarButtonItemClick:(UIButton *)button{
    
    if (myPicker == nil) {
        myPicker = [[DatePickerView alloc] init];
        myPicker.delegate = self;
        myPicker.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    }
    
    [self.view.window addSubview:myPicker];
    [myPicker choosePickerViewFrame:YES];
    
}

#pragma mark - DatePickerViewDelegate
- (void)datePickerViewChooseDate:(NSDate *)date{
    [self updateTableHeadViewData:date];
    [self updateDatas];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SESSION_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSDictionary * data = [arrDatas objectAtIndex:section];
    NSString * key = [[data allKeys] firstObject];
    NSString * value = [data objectForKey:key];
    
    
    BillsSectionView * sectionView = nil;
    NSString * identifier = [NSString stringWithFormat:@"%@%d",@"section",section];
    if (sectionsArray == nil) {
        sectionsArray = [[NSMutableArray alloc] initWithCapacity:0];
    }else{
        for (NSDictionary * sectionDic in sectionsArray) {
            if ([[sectionDic allKeys] containsObject:identifier]) {
                sectionView = [sectionDic objectForKey:identifier];
                
            }
        }
    }
    
    if (sectionView == nil) {
        sectionView = [[[BillsSectionView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, SESSION_HEIGHT)] autorelease];
        sectionView.section = section;
        
        NSDictionary * sectionDic = [[[NSDictionary alloc] initWithObjectsAndKeys:sectionView,identifier, nil] autorelease];
        [sectionsArray addObject:sectionDic];
        
    }
    
    sectionView.titleString = [NSString stringWithFormat:@"%@:",key];
    sectionView.messageString = value;


    NSInteger row = [[data objectForKey:@"datas"] count];
    if (row > 0) {
        sectionView.isNeedExpend = YES;
        sectionView.delegate = self;
    }else{
        sectionView.isNeedExpend = NO;
    }
    
    return sectionView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return arrDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (expanded == NO) {
        return 0;
    }else{
        if (expandedSection == section) {
            NSDictionary * data = [arrDatas objectAtIndex:section];
            NSArray * subDatas = [data objectForKey:@"datas"];
            
            return subDatas.count;
        }else{
            return NO;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"BillsDetailCell";
    
    BillsDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[BillsDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [self setCell:cell indexPath:indexPath];
    
    return cell;
}

- (void)setCell:(BillsDetailTableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    NSDictionary * data = [arrDatas objectAtIndex:indexPath.section];
    NSArray * subDatas = [data objectForKey:@"datas"];
    
    NSDictionary * subData = [subDatas objectAtIndex:indexPath.row];
    NSString * key = [[subData allKeys] lastObject];
    NSString * value = [subData objectForKey:key];
    
    cell.titleString = [NSString stringWithFormat:@"%@:",key];
    cell.messageString = value;

}

#pragma mark - BillsSectionViewDeleage

- (void)billsSectionViewExpendBtnClick:(BOOL)expend section:(NSInteger)section{
    expanded = expend;
    expandedSection = section;
    
    NSIndexSet * set = [[[NSIndexSet alloc] initWithIndex:section] autorelease];
    [myTableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - MappActorDelegate

- (void)getMyBillFinished:(NSInteger)status andInfo:(NSArray *)info{
    if (status == MappActorFinishStatusOK) {
        infoDatas = [[NSMutableArray alloc] initWithArray:info];
        [self updateDatas];
    }else{
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Bills_Detail_Get_My_Bill_Faild_Text", nil)];
    }
}

- (void) updateDatas{
    NSDictionary * currentMonthData = nil;
    
    NSDateFormatter * formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    
    for (NSDictionary * dic in infoDatas) {
        NSString * dateString = [dic objectForKey:@"startDate"];
        
        NSDate * date = [formatter dateFromString:dateString];
        NSDate * currentMonthDate = [formatter dateFromString:startDateString];
        
        NSInteger month = [DateUtils monthBy:date];
        NSInteger currentMonth = [DateUtils monthBy:currentMonthDate];
        if (month == currentMonth) {
            currentMonthData = [[[NSDictionary alloc] initWithDictionary:dic] autorelease];
            break;
        }
    }
    if (currentMonthData) {
        [arrDatas removeAllObjects];
        
        if ([[currentMonthData  allKeys] containsObject:@"outstandingAmount"]) {
            long str = [[currentMonthData objectForKey:@"outstandingAmount"] longValue];
            NSString * value = [CommonUtils formatMoneyWithPenny:str decimals:2 unitEnable:YES];
            NSDictionary * dic = [[[NSDictionary alloc] initWithObjectsAndKeys:value,@"OutstandingAmount", nil] autorelease];
            [arrDatas addObject:dic];
        }
        
        if ([[currentMonthData  allKeys] containsObject:@"previousAmount"]) {
            long str = [[currentMonthData objectForKey:@"previousAmount"] longValue];
            NSString * value = [CommonUtils formatMoneyWithPenny:str decimals:2 unitEnable:YES];

            NSDictionary * dic = [[[NSDictionary alloc] initWithObjectsAndKeys:value,@"Prev_INV_Amount", nil] autorelease];
            [arrDatas addObject:dic];
            
        }
        
        if ([[currentMonthData  allKeys] containsObject:@"previousPayment"]) {
            long str = [[currentMonthData objectForKey:@"previousPayment"] longValue];
            NSString * value = [CommonUtils formatMoneyWithPenny:str decimals:2 unitEnable:YES];

            NSDictionary * dic = [[[NSDictionary alloc] initWithObjectsAndKeys:value,@"Prev_Payment", nil] autorelease];
            [arrDatas addObject:dic];
        }
        
        if ([[currentMonthData  allKeys] containsObject:@"currentCharges"] && [[currentMonthData  allKeys] containsObject:@"chargeSummaryArray"]) {
            NSMutableArray * subDatasArr = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
            
            long num = [[currentMonthData objectForKey:@"currentCharges"] longValue];
            NSString * value = [CommonUtils formatMoneyWithPenny:num decimals:2 unitEnable:YES];
            NSArray * arrValue = [currentMonthData objectForKey:@"chargeSummaryArray"];
            
            if (arrValue.count > 0) {
                
                for (NSDictionary * dic in arrValue) {
                    NSString * key = nil;
                    NSString * sub_value = nil;
                    if (dic && [dic isKindOfClass:[NSDictionary class]]) {
                        NSArray * dicAllKeys = [dic allKeys];
                        if ([dicAllKeys containsObject:@"chargeName"]) {
                            key = [dic objectForKey:@"chargeName"];
                        }
                        if ([dicAllKeys containsObject:@"chargeAmount"]) {
                            long str = [[dic objectForKey:@"chargeAmount"] longValue];
                            sub_value = [CommonUtils formatMoneyWithPenny:str decimals:2 unitEnable:YES];
                        }
                    }
                    
                    if (key.length > 0 && value.length > 0) {
                        NSDictionary * subDatas = [[[NSDictionary alloc] initWithObjectsAndKeys:sub_value,key, nil] autorelease];
                        [subDatasArr addObject:subDatas];
                    }
                }
            }
            NSDictionary * dic = [[[NSDictionary alloc] initWithObjectsAndKeys:value,@"Current Changes",subDatasArr,@"datas", nil] autorelease];
            [arrDatas addObject:dic];
            
        }
        
        if ([[currentMonthData  allKeys] containsObject:@"totalBillAmount"]) {
            long value = [[currentMonthData objectForKey:@"totalBillAmount"] longValue];
            [self updateTableFootViewData:[CommonUtils formatMoneyWithPenny:value decimals:2 unitEnable:YES]];
            
        }
    }
    
    [myTableView reloadData];
}



@end
