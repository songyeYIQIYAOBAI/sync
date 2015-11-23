//
//  MessageDetailViewController.m
//  RTSS
//
//  Created by dongjf on 14/10/23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "CommonUtils.h"
#import "DateUtils.h"
#import "RTSSAppStyle.h"
#import "MessageItem.h"

#define DATE_LABEL_WIDTH 75.f
#define DATE_LABEL_HEIGHT 60.f
#define VIEW_PADDING_X 14.f

@interface MessageDetailViewController () {
    UILabel *titleLabel;
    UILabel *dateLabel;
    UITextView *contentTextView;
}

@end

@implementation MessageDetailViewController

@synthesize messageData;

#pragma mark init
- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)loadView{
    [super loadView];
    [self layoutContentView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Message_Detail_Title", nil);
}

- (void)layoutContentView
{
    //title
    titleLabel = [CommonUtils labelWithFrame:CGRectMake(VIEW_PADDING_X, 0.f, PHONE_UISCREEN_WIDTH - VIEW_PADDING_X * 2.f  - DATE_LABEL_WIDTH - 5.f, DATE_LABEL_HEIGHT) text:self.messageData.mTitle textColor:[RTSSAppStyle currentAppStyle].textMajorColor textFont:[RTSSAppStyle getRTSSFontWithSize:18.f] tag:0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.numberOfLines = 1;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:titleLabel];
    
    //date
    dateLabel = [CommonUtils labelWithFrame:CGRectMake(PHONE_UISCREEN_WIDTH - VIEW_PADDING_X - DATE_LABEL_WIDTH , 0.f, DATE_LABEL_WIDTH, DATE_LABEL_HEIGHT) text:[DateUtils getStringDateByDate:[NSDate dateWithTimeIntervalSince1970:messageData.mTimeStamp/1000]] textColor:[RTSSAppStyle currentAppStyle].textSubordinateColor textFont:[RTSSAppStyle getRTSSFontWithSize:13.f] tag:1];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textAlignment = NSTextAlignmentRight;
    dateLabel.numberOfLines = 1;
    dateLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:dateLabel];
    
    //sepeartor line
    UIImageView* lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(VIEW_PADDING_X, DATE_LABEL_HEIGHT, PHONE_UISCREEN_WIDTH - VIEW_PADDING_X * 2.f, 1.f)];
    lineImageView.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
//    lineImageView.frame = CGRectMake(VIEW_PADDING_X, DATE_LABEL_HEIGHT, PHONE_UISCREEN_WIDTH - VIEW_PADDING_X * 2.f, 1.f);
    [self.view addSubview:lineImageView];
    [lineImageView release];
    
    //content
    contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(VIEW_PADDING_X - 5.f, CGRectGetMaxY(lineImageView.frame), PHONE_UISCREEN_WIDTH - VIEW_PADDING_X * 2.f + 10.f, PHONE_UISCREEN_HEIGHT - 20.f - 44.f - CGRectGetMaxY(lineImageView.frame))];
    contentTextView.backgroundColor = [UIColor clearColor];
    contentTextView.dataDetectorTypes = UIDataDetectorTypeLink;
    contentTextView.showsVerticalScrollIndicator = YES;
    contentTextView.editable = NO;
    contentTextView.returnKeyType = UIReturnKeyDone;
    contentTextView.keyboardType = UIKeyboardTypeDefault;
    contentTextView.font = [RTSSAppStyle getRTSSFontWithSize:13.f];
    contentTextView.textColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
    contentTextView.text = self.messageData.mContent;
    contentTextView.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:contentTextView];
}

#pragma mark dealloc
- (void)dealloc{
    [messageData release];
    [contentTextView release];
    [super dealloc];
}

#pragma mark others
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
