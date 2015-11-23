//
//  PlanNegotiationView.h
//  RTSS
//
//  Created by tiger on 14-11-7.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
@class TransPanelView;
@class ComboSlider;

@protocol PlanNegotiationViewDelegate <NSObject>

- (void)PlanNegotiationSliderValueChanged:(ComboSlider *)slider;
- (void)PlanNegotiationSliderTouchUpInside:(ComboSlider *)slider;
- (void)PlanNegotiationResetBtnTouchUpInside:(UIButton *)sender;
- (void)PlanNegotiationSubmitBtnTouchUpInside:(UIButton *)sender;

@end


#define TransformTableCellHeight        68.0
#define PANEL_HEIGHT                    157

@interface PlanNegotiationView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, readonly) UITableView* transformTable;
@property (nonatomic, retain) NSMutableArray* orderedItems;
@property (nonatomic, readonly)TransPanelView * panelView;
@property (nonatomic, readonly)NSMutableDictionary * transferInfo;
@property (nonatomic, assign)id<PlanNegotiationViewDelegate> delegate;

@end

