//
//  SJBKeyboardView.h
//  SJB
//
//  Created by sheng yinpeng on 13-8-13.
//  Copyright (c) 2013年 sheng yinpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    SJBKeyboardViewDecimals=0,
    SJBKeyboardViewNumber
}SJBKeyboardViewType;

@protocol SJBKeyboardDelegate;
@interface SJBKeyboardView : UIView

@property(nonatomic,assign)SJBKeyboardViewType viewType;
@property(nonatomic,assign)id<SJBKeyboardDelegate> delegate;

- (id)initWithFrame:(CGRect)frame columnCount:(int)columnCount;

- (id)initWithFrame:(CGRect)frame viewType:(SJBKeyboardViewType)type columnCount:(int)columnCount;


- (void)setDecimalsHidden:(BOOL)hidden;

@end

@protocol SJBKeyboardDelegate <NSObject>
@optional

- (void)didNumberKeyPressed:(NSString*)numberString;

- (void)didDecimalsKeyPressed;

- (void)didBackspaceKeyPressed;

@end
