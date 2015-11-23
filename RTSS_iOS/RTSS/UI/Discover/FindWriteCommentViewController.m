//
//  FindCommentViewController.m
//  RTSS
//
//  Created by Jaffer on 15/4/2.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "FindWriteCommentViewController.h"
#import "RTSSAppStyle.h"
#import "CommonUtils.h"

#define COMMENT_TEXT_MAX_LENGTH 50


@interface FindWriteCommentViewController () <UITextViewDelegate> {
    UIButton *cancelButton;
    UIButton *commitButton;
    UITextView *commentTextView;
    UILabel *holderLabel;
    UIView *contentView;
}

@end

@implementation FindWriteCommentViewController

@synthesize commentFinishedBlock;

#pragma mark dealloc
- (void)dealloc {
    [commentTextView release];
    [contentView release];
    self.commentFinishedBlock = nil;
    
    [super dealloc];
}

#pragma mark life cycle
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

- (void)loadView {
    [super loadView];
    [self loadNavView];
    [self loadContentView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark load views
- (void)loadNavView {
    self.view.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
    navigationBarView = [self addNavigationBarView:NSLocalizedString(@"Find_Comment_List_Title", nil) bgColor:[[RTSSAppStyle currentAppStyle] navigationBarColor] separator:YES];
    [self.view addSubview:navigationBarView];
    
    //cancel
    UIFont *titleFont = [UIFont systemFontOfSize:14.0];
    CGSize cancelTitleSize = [CommonUtils calculateTextSize:NSLocalizedString(@"Find_Write_Comment_Cancel", nil) constrainedSize:CGSizeMake(CGFLOAT_MAX, 44.0) textFont:titleFont lineBreakMode:NSLineBreakByWordWrapping];
    CGRect cancelRect = CGRectMake(16.0, 20.0, cancelTitleSize.width, 44.0);
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = cancelRect;
    [cancelButton setTitle:NSLocalizedString(@"Find_Write_Comment_Cancel", nil) forState:UIControlStateNormal];
    cancelButton.titleLabel.font = titleFont;
    [cancelButton setTitleColor:[[RTSSAppStyle currentAppStyle] textMajorColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[[RTSSAppStyle currentAppStyle] textMajorColor] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(cancelComment:) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarView addSubview:cancelButton];

    //commit
    CGSize commitTiteSize = [CommonUtils calculateTextSize:NSLocalizedString(@"Find_Write_Comment_Commit", nil) constrainedSize:CGSizeMake(CGFLOAT_MAX, 44.0) textFont:titleFont lineBreakMode:NSLineBreakByWordWrapping];
    CGRect commitRect = CGRectMake(CGRectGetWidth(navigationBarView.frame) - 16.0 - commitTiteSize.width, 20.0, commitTiteSize.width, 44.0);
    commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = commitRect;
    [commitButton setTitle:NSLocalizedString(@"Find_Write_Comment_Commit", nil) forState:UIControlStateNormal];
    commitButton.titleLabel.font = titleFont;
    [commitButton setTitleColor:[[RTSSAppStyle currentAppStyle] textMajorColor] forState:UIControlStateNormal];
    [commitButton setTitleColor:[[RTSSAppStyle currentAppStyle] textMajorColor] forState:UIControlStateHighlighted];
    [commitButton addTarget:self action:@selector(commitComment:) forControlEvents:UIControlEventTouchUpInside];
    [navigationBarView addSubview:commitButton];
}

- (void)loadContentView {
    CGRect contentRect = CGRectMake(0.0, CGRectGetMaxY(navigationBarView.frame), PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT - CGRectGetMaxY(navigationBarView.frame));
    contentView = [[UIView alloc] initWithFrame:contentRect];
    contentView.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    [self.view addSubview:contentView];
    
    [self loadCommentTextView];
    [self loadHolderLabel];
    
}
- (void)loadCommentTextView {
    CGRect textViewRect = CGRectMake([self getTectViewSpaceX], [self getTextViewSpaceYTop], PHONE_UISCREEN_WIDTH - [self getTectViewSpaceX] * 2.0, [self getTextViewHeight]);
    commentTextView = [[UITextView alloc] initWithFrame:textViewRect];
    commentTextView.backgroundColor = [[RTSSAppStyle currentAppStyle] textMajorColor];
    commentTextView.backgroundColor = [UIColor whiteColor];
    commentTextView.textColor = [[RTSSAppStyle currentAppStyle] textMajorColor];
    commentTextView.layer.masksToBounds = YES;
    commentTextView.layer.cornerRadius = 5.0;
    commentTextView.layer.borderWidth = 0.5;
    commentTextView.layer.borderColor = [[RTSSAppStyle currentAppStyle] textFieldBorderColor].CGColor;
    commentTextView.delegate = self;
    [commentTextView becomeFirstResponder];
    commentTextView.returnKeyType = UIReturnKeyDone;
    [contentView addSubview:commentTextView];
}

- (void)loadHolderLabel {
    holderLabel = [CommonUtils labelWithFrame:[self getHolderLabelRect] text:NSLocalizedString(@"Find_Write_Comment_Holder_Text", nil) textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textFont:[UIFont systemFontOfSize:14.0] tag:0];
    holderLabel.backgroundColor = [UIColor clearColor];
    holderLabel.textAlignment = NSTextAlignmentLeft;
    holderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    holderLabel.numberOfLines = 1;
    [commentTextView addSubview:holderLabel];
}

- (CGFloat)getTectViewSpaceX {
    CGFloat x = 10.0;
    if (PHONE_UISCREEN_IPHONE6) {
        x = 10.0;
    } else if (PHONE_UISCREEN_IPHONE6PLUS) {
        x = 10.0;
    }
    return x;
}

- (CGFloat)getTextViewSpaceYTop {
    CGFloat y = 15.0;
    if (PHONE_UISCREEN_IPHONE6) {
        y = 20;
    } else if (PHONE_UISCREEN_IPHONE6PLUS) {
        
    }
    return y;
}

- (CGFloat)getTextViewHeight {
    CGFloat h = 150.0;
    if (PHONE_UISCREEN_IPHONE5) {
        h = 200;
    } else if (PHONE_UISCREEN_IPHONE6) {
        h = 300;
    } else if (PHONE_UISCREEN_IPHONE6PLUS) {
    
    }
    return h;
}

- (CGRect)getHolderLabelRect {
    CGRect rect = CGRectMake(5.0, 0.0, CGRectGetWidth(commentTextView.frame) - 10.0, 30.0);
    if (PHONE_UISCREEN_IPHONE6) {
        
    } else if (PHONE_UISCREEN_IPHONE6PLUS) {
    
    }
    return rect;
}

#pragma mark button action
- (void)cancelComment:(UIButton *)cancelBtn {
    NSLog(@"will cancel comment");
    [commentTextView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:^ {
        NSLog(@"did cancel comment");
    }];
}

- (void)commitComment:(UIButton *)commitBtn {
    NSLog(@"commit comment");
    [commentTextView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:^ {
        if (commentFinishedBlock) {
            //temp 暂时本地生成findItemCommentModel
            FindItemCommentModel *com = [[FindItemCommentModel alloc] init];
            com.commentFromUid = @"99999";
            com.commentFromNick = @"Kite";
            com.commentFromIconUrl = @"http://www.x.cn//discovery/music/nofeartonight/icon.png";
            com.commentToUid = @"888888";
            com.commentToNick = @"Jack";
            com.commentContent = commentTextView.text;
            com.commentPicId = @"77777";
            com.commentTimeStamp = [[NSDate date] timeIntervalSince1970];
            
            commentFinishedBlock(com);
            [com release];
        }
    }];
}

#pragma mark uitextview
- (void)textViewDidBeginEditing:(UITextView *)textView {

}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length > COMMENT_TEXT_MAX_LENGTH) {
        textView.text = [textView.text substringToIndex:COMMENT_TEXT_MAX_LENGTH];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    NSString *language = [[textView textInputMode] primaryLanguage];
    NSInteger textLength = [textView.text length];
    if ([language isEqualToString:@"zh-Hans"]) {//中文键盘
        NSString *text = textView.text;
        UITextRange *textRange = textView.markedTextRange;//markedTextRange用来辨别中文输入时的被标记的拼音
        if (!textRange || textRange.empty) {
            if (textLength > COMMENT_TEXT_MAX_LENGTH) {
                text = [text substringToIndex:COMMENT_TEXT_MAX_LENGTH];
                textView.text = text;
            }
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    NSUInteger textLength = [textView.text length];
    if (textLength >= COMMENT_TEXT_MAX_LENGTH && ![text isEqualToString:@""]) {
        return NO;
    }

    if (textView.text.length == 0) {
        if ([text isEqualToString:@""]) {
             holderLabel.hidden = NO;
        } else {
            holderLabel.hidden = YES;
        }
    } else {
        if (textView.text.length == 1) {
            if ([text isEqualToString:@""]) {
                holderLabel.hidden = NO;
            } else {
                holderLabel.hidden = YES;
            }
        } else {
            holderLabel.hidden = YES;
        }
    }
    return YES;
}


#pragma mark others
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
