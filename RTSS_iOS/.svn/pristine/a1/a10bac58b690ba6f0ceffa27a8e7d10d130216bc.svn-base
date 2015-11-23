//
//  TransactionPanelBaseView.h
//  RTSS
//
//  Created by 蔡杰Alan on 15-2-3.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransationPanelInterface.h"
#define kTransactionPanelBaseViewHeight   108.0f  //140.0f
#define KTransactionPanelBaseViewDuration  0.5f
@class   TransactionPanelBaseView;
@protocol TransactionPanelViewDelegate <NSObject>

@optional

-(void)TransactionPanelPNView:(TransactionPanelBaseView*)transactionView changeMoth:(NSInteger)month;

@end


@interface TransactionPanelBaseView : UIView<TransationPanelInterface>

@property(nonatomic,assign)id<TransactionPanelViewDelegate>delegate;

@property(nonatomic, assign) CGRect initPanelBaseFrame;

@property(nonatomic, assign) CGRect initChangePanelBaseFrame;

//@property(nonatomic, readonly) UIImageView*         pointImageView;
//@property(nonatomic, readonly) UILabel*             detailLabel;

@property(nonatomic, readonly) UILabel*             feeLabel;
@property(nonatomic, readonly) UILabel*             feeValueLabel;

@property(nonatomic, readonly) UIButton*            resetButton;
@property(nonatomic, readonly) UIButton*            submitButton;

@end
