//
//  SJBKeyboardView.m
//  SJB
//
//  Created by sheng yinpeng on 13-8-13.
//  Copyright (c) 2013年 sheng yinpeng. All rights reserved.
//

#import "SJBKeyboardView.h"
#import "RTSSAppStyle.h"

#define ONE_KEY_WIDTH      107.0
#define ONE_KEY_HEIGHT     54.0
#define KEY_COLUMN_COUNT   3

@interface SJBKeyboardView()

@property (nonatomic, assign) int colCount;

@end

@implementation SJBKeyboardView

@synthesize viewType,delegate,colCount;

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.viewType = SJBKeyboardViewDecimals;
        self.colCount = KEY_COLUMN_COUNT;
        [self layoutKeyboardView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame columnCount:(int)columnCount
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = SJBKeyboardViewDecimals;
        self.colCount = columnCount;
        [self layoutKeyboardView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame viewType:(SJBKeyboardViewType)type columnCount:(int)columnCount
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.viewType = type;
        self.colCount = columnCount;
        [self layoutKeyboardView];
    }
    return self;
}

- (void)layoutKeyboardView
{
    for (int i = 1; i <= 12; i ++) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        button.tag = i;
        CGFloat keyWidth = CGRectGetWidth(self.frame) * 1.0 / colCount;
        if(i >= 1 && i <= 3){
            button.frame = CGRectMake(keyWidth*(i-1), ONE_KEY_HEIGHT*0, keyWidth, ONE_KEY_HEIGHT);
        }else if(i >= 4 && i <= 6){
            button.frame = CGRectMake(keyWidth*(i-4), ONE_KEY_HEIGHT*1, keyWidth, ONE_KEY_HEIGHT);
        }else if(i >= 7 && i <= 9){
            button.frame = CGRectMake(keyWidth*(i-7), ONE_KEY_HEIGHT*2, keyWidth, ONE_KEY_HEIGHT);
        }else if(i >= 10 && i <= 12){
            button.frame = CGRectMake(keyWidth*(i-10), ONE_KEY_HEIGHT*3, keyWidth, ONE_KEY_HEIGHT);
        }
        button.titleLabel.font = [UIFont boldSystemFontOfSize:28.0];
        [button setTitleColor:[RTSSAppStyle currentAppStyle].textMajorColor forState:UIControlStateNormal];
        [button setTitleColor:[RTSSAppStyle currentAppStyle].textSubordinateColor forState:UIControlStateHighlighted];
        
        UIImage* buttonImage = [UIImage imageNamed:@"common_button_keyboard_d.png"];
        UIImage* buttonPressedImage = [UIImage imageNamed:@"common_button_keyboard_d.png"];
        [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
        
        if(i >= 1 && i <= 9){
            [button setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        }else if(10 == i){
            if(SJBKeyboardViewNumber == self.viewType){
                button.enabled = NO;
                [button setTitle:@"" forState:UIControlStateNormal];
            }else{
                [button setTitle:@"." forState:UIControlStateNormal];
            }
        }else if(11 == i){
            [button setTitle:@"0" forState:UIControlStateNormal];
        }else if(12 == i){
            UIImage* deleteImage = [UIImage imageNamed:@"common_button_keyboard_delete_d.png"];
            [button setImage:deleteImage forState:UIControlStateNormal];
            [button setImage:deleteImage forState:UIControlStateHighlighted];
        }
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)setDecimalsHidden:(BOOL)hidden
{
    UIButton* button = (UIButton*)[self viewWithTag:10];
    if(nil != button){
        if(hidden){
            button.enabled = NO;
            [button setTitle:@"" forState:UIControlStateNormal];
        }else{
            button.enabled = YES;
            [button setTitle:@"." forState:UIControlStateNormal];
        }
    }
}

- (void)buttonAction:(UIButton*)button
{
    int tag = button.tag;
    if(tag >= 1 && tag <= 9){
        if(nil != delegate && [delegate respondsToSelector:@selector(didNumberKeyPressed:)]){
            [delegate didNumberKeyPressed:[NSString stringWithFormat:@"%d",tag]];
        }
    }else if(10 == tag){
        if(nil != delegate && [delegate respondsToSelector:@selector(didDecimalsKeyPressed)]){
            [delegate didDecimalsKeyPressed];
        }
    }else if(11 == tag){
        if(nil != delegate && [delegate respondsToSelector:@selector(didNumberKeyPressed:)]){
            [delegate didNumberKeyPressed:@"0"];
        }
    }else if(12 == tag){
        if(nil != delegate && [delegate respondsToSelector:@selector(didBackspaceKeyPressed)]){
            [delegate didBackspaceKeyPressed];
        }
    }
}

@end
