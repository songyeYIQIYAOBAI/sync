//
//  FlowDateSearchVC.m
//  EasyTT
//
//  Created by sheng yinpeng on 13-6-4.
//  Copyright (c) 2013年 lvming. All rights reserved.
//

#import "FlowDateSearchVC.h"
#import "CommonUtils.h"
#import "DateUtils.h"

@interface FlowDateSearchVC ()

@end

@implementation FlowDateSearchVC
@synthesize startDate,endDate,delegate;

- (void)dealloc
{
    [pickerView release];
    [pickerControl release];
    
    //[startTimeButton release];
    //[endTimeButton release];
    
    [startDate release];
    [endDate release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutNavigationBar
{
//    UIBarButtonItem* cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
//                                                                                target:self
//                                                                                action:@selector(barCancel:)];
//    self.navigationItem.leftBarButtonItem = cancelItem;
//    [cancelItem release];
//    
//    UIBarButtonItem* doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
//                                                                              target:self
//                                                                              action:@selector(barDone:)];
//    self.navigationItem.rightBarButtonItem = doneItem;
//    [doneItem release];
    
    
    UIButton *cancelPickerButton = [CommonUtils buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 7, 60, 30) title:NSLocalizedString(@"DataUsgae_Setting_LeftItem_Cancel", nil) bgImageNormal:nil bgImageHighlighted:nil bgImageSelected:nil addTarget:self action:@selector(barCancel:) tag:0];
    cancelPickerButton.backgroundColor = [UIColor clearColor];
    cancelPickerButton.titleLabel.font = [RTSSAppStyle getRTSSFontWithSize:18.f];
    [cancelPickerButton setTitleColor:[CommonUtils colorWithHexString:@"#54565C"] forState:UIControlStateNormal];
    
    UIButton *donePickerButton = [CommonUtils buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 7, 40, 30) title:NSLocalizedString(@"DataUsgae_Setting_RightItem_Done", nil) bgImageNormal:nil bgImageHighlighted:nil bgImageSelected:nil addTarget:self action:@selector(barDone:) tag:0];
    donePickerButton.backgroundColor = [UIColor clearColor];
    donePickerButton.titleLabel.font = [RTSSAppStyle getRTSSFontWithSize:18.f];
    [donePickerButton setTitleColor:[CommonUtils colorWithHexString:@"#54565C"] forState:UIControlStateNormal];

    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelPickerButton];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithCustomView:donePickerButton];
    self.navigationItem.leftBarButtonItem = cancelItem;
    self.navigationItem.rightBarButtonItem = doneItem;

    [cancelItem release];
    [doneItem release];
}

-(void)layoutPickerView
{
    initPickerViewFrame = CGRectMake(0, PHONE_UISCREEN_HEIGHT-20-44, 320, 259);
    choosePickerViewFrame = CGRectMake(0, PHONE_UISCREEN_HEIGHT-20-44-259, 320, 259);
    pickerView = [[UIView alloc] initWithFrame:initPickerViewFrame];
    pickerView.backgroundColor = [UIColor clearColor];
    
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
    
    [pickerView addSubview:navBar];
    [navBar release];
    
    pickerControl = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,44, PHONE_UISCREEN_WIDTH, 215)];
    pickerControl.date = [NSDate date];
    //pickerControl.maximumDate = [NSDate new];
    pickerControl.backgroundColor = [UIColor clearColor];
    [pickerControl setDatePickerMode:UIDatePickerModeDate];
    [pickerView addSubview:pickerControl];
    
    [self.view addSubview:pickerView];
}

- (void)layoutContentView
{    
    if(nil == self.startDate || nil == self.endDate){
        self.startDate = [NSDate date];
        self.endDate = [NSDate date];
    }
        
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, PHONE_UISCREEN_WIDTH, 100)];
    contentView.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    UIImageView *upLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 1)];
    upLine.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [contentView addSubview:upLine];
    
    
    
    //start time:
    UILabel* startLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10,100,30)];
    startLabel.backgroundColor = [UIColor clearColor];
    startLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    startLabel.text = NSLocalizedString(@"DataUsgae_Setting_StartTimeLabel_Text", nil);
    startLabel.textAlignment = NSTextAlignmentCenter;
    startLabel.font = [RTSSAppStyle getRTSSFontWithSize:14.f];
    startLabel.numberOfLines = 1;
    startLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [contentView addSubview:startLabel];
    [startLabel release];
    
    //start button
    //startTimeButton = [[UIButton alloc] initWithFrame:CGRectMake(10+100+10, 10, 150, 30)];
    startTimeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    startTimeButton.frame = CGRectMake(10+100+10, 10, 150, 30);
    startTimeButton.backgroundColor = [UIColor clearColor];
    startTimeButton.tag = 101010;
    NSString* startDateString = [DateUtils getStringDateByDate:self.startDate];
	[startTimeButton setTitle:startDateString forState:UIControlStateNormal];
	startTimeButton.titleLabel.font = [RTSSAppStyle getRTSSFontWithSize:14.f];
    [startTimeButton setTitleColor:[RTSSAppStyle currentAppStyle].textBlueColor forState:UIControlStateNormal];
	[startTimeButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
	[contentView addSubview:startTimeButton];
    
    UIImageView *centerLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, contentView.frame.size.height/2, PHONE_UISCREEN_WIDTH, 1)];
    centerLine.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [contentView addSubview:centerLine];
    
    //end time:
    UILabel* endLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,60,100,30)];
    endLabel.backgroundColor = [UIColor clearColor];
    endLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    endLabel.text = NSLocalizedString(@"DataUsgae_Setting_EndTimeLabel_Text", nil);
    endLabel.textAlignment = NSTextAlignmentCenter;
    endLabel.font = [RTSSAppStyle getRTSSFontWithSize:14.f];
    endLabel.numberOfLines = 1;
    endLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [contentView addSubview:endLabel];
    [endLabel release];
    
    //end button
    //endTimeButton = [[UIButton alloc] initWithFrame:CGRectMake(10+100+10, 60, 150, 30)];
    endTimeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    endTimeButton.frame = CGRectMake(10+100+10, 60, 150, 30);
    endTimeButton.backgroundColor = [UIColor clearColor];
    endTimeButton.tag = 101011;
    NSString* endDateString = [DateUtils getStringDateByDate:self.endDate];
	[endTimeButton setTitle:endDateString forState:UIControlStateNormal];
	endTimeButton.titleLabel.font = [RTSSAppStyle getRTSSFontWithSize:14.f];
    endTimeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [endTimeButton setTitleColor:[RTSSAppStyle currentAppStyle].textBlueColor forState:UIControlStateNormal];
	[endTimeButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
	[contentView addSubview:endTimeButton];
    
    UIImageView *DownLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, contentView.frame.size.height-1, PHONE_UISCREEN_WIDTH, 1)];
    DownLine.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [contentView addSubview:DownLine];
    
    [self.view addSubview:contentView];
    [contentView release];
}

- (void)loadView
{
    [super loadView];
    
    [self layoutNavigationBar];
    [self layoutContentView];
    [self layoutPickerView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"DataUsage_Setting_Title", nil);
}

- (void)choosePickerViewFrame:(BOOL)isChoose
{
    float Durationtime = 0.5;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:Durationtime];
    if(isChoose){
        pickerView.frame = choosePickerViewFrame;
    }else{
        pickerView.frame = initPickerViewFrame;
    }
    [UIView commitAnimations];
}

- (void)cancelPicker:(id)action
{
    [self choosePickerViewFrame:NO];
}

- (void)donePicker:(id)action
{
    [self choosePickerViewFrame:NO];
    
    NSDate* date = [pickerControl date];
    NSString* dateString = [DateUtils getStringDateByDate:date];
    
    if(currentSelectButton == startTimeButton){
        self.startDate = date;
        [startTimeButton setTitle:dateString forState:UIControlStateNormal];
    }else if(currentSelectButton == endTimeButton){
        self.endDate = date;
        [endTimeButton setTitle:dateString forState:UIControlStateNormal];
    }
}

- (void)barCancel:(id)action
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)barDone:(id)action
{
    BOOL isFinish = NO;
    if(nil != startDate && nil != endDate){
        NSComparisonResult result = [startDate compare:endDate];
        if(NSOrderedSame == result){
            //相同时间
            //[MyAlertView showSimpleAlertView:NSLocalizedString(@"FlowDateSearch_Same_Time_Alert", nil)];
        }else if(NSOrderedAscending == result){
            //endDate 大
            isFinish = YES;
//            BOOL isSame = [ToolsFactory isSameYearMonth:self.startDate endDate:self.endDate];
//            if(isSame){
//                isFinish = YES;
//            }else{
//                [MyAlertView showSimpleAlertView:NSLocalizedString(@"FlowDateSearch_Same_Year_Month_Alert", nil)];
//            }
        }else if(NSOrderedDescending == result){
            //endDate 小
            //[MyAlertView showSimpleAlertView:NSLocalizedString(@"FlowDateSearch_End_Time_Descending_Alert", nil)];
        }
    }
    
    if(isFinish){
        if(nil != delegate && [delegate respondsToSelector:@selector(flowDateStart:dateEnd:)]){
            [delegate flowDateStart:startDate dateEnd:endDate];
        }
    
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)buttonAction:(id)action
{
    UIButton* button = (UIButton*)action;
    if(101010 == button.tag){
        currentSelectButton = button;
        [self choosePickerViewFrame:YES];
    }else if(101011 == button.tag){
        currentSelectButton = button;
        [self choosePickerViewFrame:YES];
    }
}

@end
