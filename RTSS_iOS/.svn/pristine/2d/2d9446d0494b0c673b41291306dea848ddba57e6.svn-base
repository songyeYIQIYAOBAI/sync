//
//  AboutView.m
//  RTSS
//
//  Created by 宋野 on 14-12-4.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "AboutView.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"

#define IMAGEVIEW_WIDTH                         100.0
#define IMAGEVIEW_HEIGHT                        150.0

#define VERSION_LABEL_HEIGHT                    15.0
#define TEXT_FONT                               12.0
#define VERSION_FONT                            10.0

@implementation AboutView
@synthesize versionLabel;
@synthesize companyNameLabel;

- (void)dealloc{
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews{
    // imageView
//    UIImageView * logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, self.bounds.size.width, 80)];
//    logo.contentMode = UIViewContentModeCenter;
    UIImageView * logo = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width - IMAGEVIEW_WIDTH)/2.0, self.bounds.size.height * 0.15, IMAGEVIEW_WIDTH, IMAGEVIEW_HEIGHT)];
    logo.image = [UIImage imageNamed:@"common_about_reliance_jio_logo"];
//    logo.image = [UIImage imageNamed:@"common_super_operator_logo.png"];
    [self addSubview:logo];
    [logo release];
    
    // versionLabel
//    versionLabel = [CommonUtils labelWithFrame:CGRectMake(0, CGRectGetMaxY(logo.frame), self.bounds.size.width , VERSION_LABEL_HEIGHT) text:@"" textColor:[UIColor blackColor] textFont:[UIFont systemFontOfSize:VERSION_FONT] tag:10];
    versionLabel = [CommonUtils labelWithFrame:CGRectMake(0, CGRectGetMaxY(logo.frame), self.bounds.size.width , VERSION_LABEL_HEIGHT) text:@"" textColor:[RTSSAppStyle currentAppStyle].textMajorColor textFont:[RTSSAppStyle getRTSSFontWithSize:VERSION_FONT] tag:10];
    [self addSubview:versionLabel];
    
    // companyLabel
//    companyNameLabel = [CommonUtils labelWithFrame:CGRectMake(0, CGRectGetMaxY(versionLabel.frame)+10, self.bounds.size.width, VERSION_LABEL_HEIGHT) text:@"" textColor:[UIColor blackColor] textFont:[UIFont systemFontOfSize:TEXT_FONT] tag:11];
    companyNameLabel = [CommonUtils labelWithFrame:CGRectMake(0, CGRectGetMaxY(versionLabel.frame)+50, self.bounds.size.width, VERSION_LABEL_HEIGHT) text:@"" textColor:[RTSSAppStyle currentAppStyle].textMajorColor textFont:[RTSSAppStyle getRTSSFontWithSize:TEXT_FONT] tag:11];
    [self addSubview:companyNameLabel];
 
}

@end
