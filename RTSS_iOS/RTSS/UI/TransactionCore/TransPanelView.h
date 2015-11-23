//
//  PanelView.h
//  EasyTT
//
//  Created by tiger on 14-10-28.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TransPanelType){
    TransFormPanel = 1,
    TransFerPanel,
    PriceNegotiationPanel
};

@interface TransPanelView : UIView
{
    CGRect initPanelFrame;
    CGRect hiddenPanelFrame;
}

@property(nonatomic, readonly)UIButton* submitButton;
@property(nonatomic, readonly)UIButton* resetButton;
@property(nonatomic, readonly)UILabel* feeValueLabel;
@property(nonatomic, readonly)UILabel* transformData;
@property(nonatomic, assign)TransPanelType panelType;


@end
