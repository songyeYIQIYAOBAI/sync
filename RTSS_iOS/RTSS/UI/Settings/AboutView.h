//
//  AboutView.h
//  RTSS
//
//  Created by 宋野 on 14-12-4.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutView : UIView

@property (nonatomic ,readonly)UILabel * versionLabel;
@property (nonatomic ,readonly)UILabel * companyNameLabel;

- (void)initViews;

@end
