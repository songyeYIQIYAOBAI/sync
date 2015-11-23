//
//  BudgetVicinityViewController.m
//  RTSS
//
//  Created by 加富董 on 15/2/7.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "BudgetVicinityViewController.h"
#import "Subscriber.h"
#import "Cache.h"
#import "PortraitImageView.h"
#import "RTSSAppDefine.h"
#import "RTSSAppStyle.h"
#import "SJBKeyboardView.h"
#import "CommonUtils.h"
#import "BudgetGroupMemberView.h"
#import "BudgetGroup.h"

#define VICINITY_VIEW_PADDING_X_LEFT 14.0
#define VICINITY_VIEW_PADDING_X_RIGHT 14.0

#define VICINITY_PROMPT_LABEL_FONT_SIZE 14.0
#define VICINITY_PROMPT_LABEL_PADDING_L 14.0
#define VICINITY_PROMPT_LABEL_PADDING_R 14.0
#define VICINITY_PROMPT_LABEL_HEIGHT 40.0

#define VICINITY_NUM_LABEL_PADDING_L 60.0
#define VICINITY_NUM_LABEL_PADDING_R 60.0
#define VICINITY_NUM_LABEL_HEIGHT 35.0
#define VICINITY_NUM_LABEL_FONT_SIZE 30.0
#define VICINITY_NUM_LABEL_MAX_LENGTH 4
#define VICINITY_NUM_LABEL_CORNER_RADIUS 6.0
#define VICINITY_NUM_LABEL_BORDER_WIDTH 1.0

#define VICINITY_CONFIRM_BTN_PADDING_L 35.0
#define VICINITY_CONFIRM_BTN_PADDING_R 35.0
#define VICINITY_CONFIRM_BTN_HEIGHT 45.0
#define VICINITY_CONFIRM_BTN_CORNER_RADIUS 6.0

#define VICINITY_KEYBOARD_HEIGHT 216.0
#define VICINITY_KEYBOARD_COLUMN_COUNT 3

#define VICINITY_REFRESH_ANIMATION_DURATION 0.3

#define VICINITY_MEMBERS_VIEW_COLUMN_COUNT 3

@interface BudgetVicinityViewController () <SJBKeyboardDelegate, BudgetGroupMemberViewDelegate> {
    UILabel *promptLabel;
    UILabel *numberDisplayLabel;
    SJBKeyboardView *numberKeyboard;
    UIScrollView *contentScrollView;
    BudgetGroupMemberView *vicinityMembersView;
    UIButton *confirmButton;
}

@property (nonatomic, assign) BOOL inputFinished;
@property (nonatomic, retain) NSMutableArray *vicinityMembersArr;

@end

@implementation BudgetVicinityViewController

@synthesize groupType;
@synthesize inputFinished;
@synthesize delegate;
@synthesize vicinityMembersArr;
@synthesize currentGroup;

#pragma mark dealloc
- (void)dealloc {
    [vicinityMembersView release];
    [contentScrollView release];
    [vicinityMembersArr release];
    [currentGroup release];
    [super dealloc];
}

#pragma mark life cycle
- (void)loadView {
    [super loadView];
    [self loadNavBarView];
    [self loadContentView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inputFinished = NO;
}

#pragma mark load views
- (void)loadNavBarView {
    self.view.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
    NSString *title = groupType == GroupTypeCreated ? NSLocalizedString(@"Budget_Vicinity_Add_Member_Title", nil) : NSLocalizedString(@"Budget_Vicinity_Join_Group_Title", nil);
    navigationBarView = [self addNavigationBarView:title bgColor:[[RTSSAppStyle currentAppStyle] navigationBarColor] separator:YES];
    [self.view addSubview:navigationBarView];
}

- (void)loadContentView {
    CGRect contentRect = CGRectMake(0.0, CGRectGetMaxY(navigationBarView.frame), PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT - CGRectGetMaxY(navigationBarView.frame));
    contentScrollView = [[UIScrollView alloc] initWithFrame:contentRect];
    contentScrollView.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    contentScrollView.contentSize = contentRect.size;
    [self.view addSubview:contentScrollView];
    
    [self loadPromptLabel];
    [self loadNumberLabel];
    [self loadConfrimButton];
    [self loadKeyboardView];
}

- (void)loadPromptLabel {
    CGRect promptRect = CGRectMake(VICINITY_PROMPT_LABEL_PADDING_L, [self getPromptLabelOffsetY], PHONE_UISCREEN_WIDTH - VICINITY_PROMPT_LABEL_PADDING_L - VICINITY_PROMPT_LABEL_PADDING_R, VICINITY_NUM_LABEL_HEIGHT);
    NSString *promptMessage = nil;
    if (groupType == GroupTypeCreated) {
        promptMessage = NSLocalizedString(@"Budget_Vicinity_Add_Member_Prompt_Message", nil);
    } else if (groupType == GroupTypeJoined) {
        promptMessage = NSLocalizedString(@"Budget_Vicinity_Join_Group_Prompt_Message", nil);
    }
    promptLabel = [CommonUtils labelWithFrame:promptRect text:promptMessage textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textFont:[RTSSAppStyle getRTSSFontWithSize:VICINITY_PROMPT_LABEL_FONT_SIZE] tag:0];
    promptLabel.backgroundColor = [UIColor clearColor];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.lineBreakMode = NSLineBreakByWordWrapping;
    promptLabel.numberOfLines = 0;
    [contentScrollView addSubview:promptLabel];
}

- (void)loadNumberLabel {
    CGRect numberRect = CGRectMake(VICINITY_NUM_LABEL_PADDING_L, [self getNumberLabelOffsetY], PHONE_UISCREEN_WIDTH - VICINITY_NUM_LABEL_PADDING_L - VICINITY_NUM_LABEL_PADDING_R, VICINITY_NUM_LABEL_HEIGHT);
    numberDisplayLabel = [CommonUtils labelWithFrame:numberRect text:nil textColor:[[RTSSAppStyle currentAppStyle] textMajorColor] textFont:[RTSSAppStyle getRTSSFontWithSize:VICINITY_PROMPT_LABEL_FONT_SIZE] tag:0];
    numberDisplayLabel.layer.cornerRadius = VICINITY_NUM_LABEL_CORNER_RADIUS;
    numberDisplayLabel.layer.borderColor = [[RTSSAppStyle currentAppStyle] textFieldBorderColor].CGColor;
    numberDisplayLabel.layer.borderWidth = VICINITY_NUM_LABEL_BORDER_WIDTH;
    numberDisplayLabel.layer.masksToBounds = YES;
    numberDisplayLabel.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
    numberDisplayLabel.textAlignment = NSTextAlignmentCenter;
    numberDisplayLabel.lineBreakMode = NSLineBreakByWordWrapping;
    numberDisplayLabel.numberOfLines = 0;
    [contentScrollView addSubview:numberDisplayLabel];
}

- (void)loadConfrimButton {
    CGRect confrimButtonRect = CGRectMake(VICINITY_CONFIRM_BTN_PADDING_L, contentScrollView.contentSize.height - [self getConfirmButtonBottom] - VICINITY_CONFIRM_BTN_HEIGHT, PHONE_UISCREEN_WIDTH - VICINITY_CONFIRM_BTN_PADDING_L - VICINITY_CONFIRM_BTN_PADDING_R, VICINITY_CONFIRM_BTN_HEIGHT);
    NSString *confirmTitle = nil;
    if (groupType == GroupTypeCreated) {
        confirmTitle = NSLocalizedString(@"Budget_Vicinity_Confirm_Button_Title_Invite", nil);
    } else if (groupType == GroupTypeJoined) {
        confirmTitle = NSLocalizedString(@"Budget_Vicinity_Confirm_Button_Title_Join", nil);
    }
    confirmButton =[RTSSAppStyle getMajorGreenButton:confrimButtonRect target:self action:@selector(confirmButtonAction:) title:confirmTitle];
    
    [contentScrollView addSubview:confirmButton];
}

- (void)loadKeyboardView {
    CGRect keyboardRect = CGRectMake(0.0, PHONE_UISCREEN_HEIGHT - VICINITY_KEYBOARD_HEIGHT, PHONE_UISCREEN_WIDTH, VICINITY_KEYBOARD_HEIGHT);
    numberKeyboard = [[SJBKeyboardView alloc] initWithFrame:keyboardRect viewType:SJBKeyboardViewNumber columnCount:VICINITY_KEYBOARD_COLUMN_COUNT];
    numberKeyboard.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    numberKeyboard.delegate = self;
    [self.view addSubview:numberKeyboard];
}

- (void)loadVicinityMembersView {
    CGRect membersViewRect = CGRectMake(0.0, [self getVicinityMembersViewOffsetY], PHONE_UISCREEN_WIDTH, [self getVicinityMembersViewDefaultHeight]);
    vicinityMembersView = [[BudgetGroupMemberView alloc] initWithFrame:membersViewRect canEdit:NO columnCount:VICINITY_MEMBERS_VIEW_COLUMN_COUNT delegate:self];
    vicinityMembersView.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    [vicinityMembersView loadContentWithData:[self loadTempMemberData]];
    [contentScrollView addSubview:vicinityMembersView];
}

- (void)refreshView {
    [UIView animateWithDuration:VICINITY_REFRESH_ANIMATION_DURATION animations:^ {
        confirmButton.alpha = 1.0;
        promptLabel.alpha = 0.0;
        numberKeyboard.alpha = 0.0;
        CGRect labelRect = numberDisplayLabel.frame;
        labelRect.origin.y = [self getNumberLabelOffsetY];
        numberDisplayLabel.frame = labelRect;
    } completion:^ (BOOL finished) {
        [self loadVicinityMembersView];
    }];
}

#pragma mark layout tools 
- (CGFloat)getPromptLabelOffsetY {
    CGFloat y = 14.0;
    if (PHONE_UISCREEN_IPHONE5) {
        y = 24.0;
    } else if (PHONE_UISCREEN_IPHONE6) {
        y = 34.0;
    }
    return y;
}

- (CGFloat)getNumberLabelOffsetY {
    CGFloat y = inputFinished ? 20.0 : 80.0;
    if (PHONE_UISCREEN_IPHONE5) {
        y = inputFinished ? 40.0 : 100.0;
    } else if (PHONE_UISCREEN_IPHONE6) {
        y = inputFinished ? 60.0 : 120.0;
    }
    return y;
}

- (CGFloat)getVicinityMembersViewOffsetY {
    CGFloat y = 80.0;
    if (PHONE_UISCREEN_IPHONE5) {
        
    } else if (PHONE_UISCREEN_IPHONE6) {
    
    }
    return y;
}

- (CGFloat)getVicinityMembersViewDefaultHeight {
    CGFloat h = 150;
    if (PHONE_UISCREEN_IPHONE5) {
        
    } else if (PHONE_UISCREEN_IPHONE6) {
    
    }
    return h;
}

- (CGFloat)getConfirmButtonBottom {
    CGFloat bottom = 30.0;
    if (PHONE_UISCREEN_IPHONE5) {
        bottom = 45.0;
    } else if (PHONE_UISCREEN_IPHONE6) {
        bottom = 60.0;
    }
    return bottom;
}

#pragma mark budget group member delegate
- (void)budgetGroupMemberView:(BudgetGroupMemberView *)mbsView didSelectMemberAtIndex:(NSInteger)index {
    NSLog(@"budget vicinity budgetGroupMemberView  didSelectMemberAtIndex:%d",index);
}

#pragma mark keyboard delegate
- (void)didNumberKeyPressed:(NSString *)numberString {
    if (numberDisplayLabel.text.length < VICINITY_NUM_LABEL_MAX_LENGTH && [CommonUtils objectIsValid:numberString]) {
        NSString *textStr = numberDisplayLabel.text;
        if ([CommonUtils objectIsValid:textStr]) {
            textStr = [NSString stringWithFormat:@"%@%@",numberDisplayLabel.text,numberString];
        } else {
            textStr = numberString;
        }
        numberDisplayLabel.text = textStr;
        if ([CommonUtils objectIsValid:textStr] && textStr.length == VICINITY_NUM_LABEL_MAX_LENGTH) {
            self.inputFinished = YES;
            [self refreshView];
        }
    }
}

#pragma mark button clicked
- (void)confirmButtonAction:(UIButton *)button {
    NSLog(@"confirm button clicked");
    if (delegate && [delegate respondsToSelector:@selector(budgetVicinityViewController:didClickedConfirmButtonWithMembersData:)]) {
        [delegate budgetVicinityViewController:self didClickedConfirmButtonWithMembersData:vicinityMembersArr];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)didBackspaceKeyPressed
{
    NSString *currentString = numberDisplayLabel.text;
    if ([CommonUtils objectIsValid:currentString] && currentString.length > 0) {
        NSString *textStr = [NSString stringWithFormat:@"%@",[currentString substringToIndex:currentString.length - 1]];
        numberDisplayLabel.text = textStr;
    }
}

#pragma mark load data
- (NSMutableArray *)loadTempMemberData {
    self.vicinityMembersArr = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    NSArray *names = @[@"Jack",@"Jim",@"Kite",@"Tom",@"Jaf"];
    NSArray *numbers = @[@"700651523",@"700651524",@"700651525",@"700651526",@"700651527"];
    for (int i = 0; i < 5; i ++) {
        Subscriber *sub = [[Subscriber alloc] init];
//        sub.mPhoneNumber = [numbers objectAtIndex:i];
//        sub.mSubscriberName = [names objectAtIndex:i];
//        sub.mSubscriberId = [numbers objectAtIndex:i];
        [vicinityMembersArr addObject:sub];
        [sub release];
    }
    return vicinityMembersArr;
}

#pragma mark others
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
