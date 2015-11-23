//
//  SegmentControlView.h
//  RTSS
//
//  Created by 加富董 on 14/11/13.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SegmentControlIndex) {
    SegmentControlIndexFirst,
    SegmentControlIndexSecond,
};

@class SegmentControlView;

@protocol  SegmentControlViewDelegate <NSObject>

@optional

- (void)segmentControlView:(SegmentControlView *)segmentView didSelectedSegmentAtIndex:(SegmentControlIndex)index;

@end

@interface SegmentControlView : UIView

//selected index
@property (nonatomic, assign) SegmentControlIndex currentSelectedIndex;

//delegate
@property (nonatomic, assign) id <SegmentControlViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame
            firstSegmentTitle:(NSString *)firstTitle
           secondSegmentTitle:(NSString *)secondTitle
              normalTextColor:(UIColor *)nomTextColor
            selectedTextColor:(UIColor *)selTextColor
         normalControlBgColor:(UIColor *)nomBgColor
       selectedControlBgColor:(UIColor *)selBgColor
                  borderColor:(UIColor *)bdColor
         defaultSelectedIndex:(NSInteger)selIndex;

@end
