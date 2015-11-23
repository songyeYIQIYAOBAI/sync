//
//  ETTModuleView.m
//  EasyTT
//
//  Created by 蔡杰 on 14-10-23.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import "RTSSModuleView.h"

#import "RTSSWalletManagerRes.h"
#import "RTSSAppStyle.h"


#define kRTSSControlsEdge 5

#define kRTSSButtonHeight  50

@interface RTSSModuleView ()

{
    UIButton *toggleButton;
    UILabel  *titleLabel;
}

@end

@implementation RTSSModuleView

-(void)dealloc{
    [titleLabel release];
    titleLabel = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self installSubViews];
    }
    return self;
}

-(void)installSubViews{
    //add toggleButton
    toggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat x = self.bounds.size.width/2 - kRTSSButtonHeight/2;
    CGFloat y =  (self.bounds.size.height - kRTSSButtonHeight)/2;
    toggleButton.frame = CGRectMake(x, y, kRTSSButtonHeight, kRTSSButtonHeight);
    toggleButton.backgroundColor = [UIColor clearColor];
    [self addSubview:toggleButton];
    //add titleLabel
    titleLabel = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(CGRectGetMidX(toggleButton.frame)-self.bounds.size.width/2, CGRectGetMaxY(toggleButton.frame)+5, self.bounds.size.width, 15);
    titleLabel.font = [RTSSAppStyle getRTSSFontWithSize:11.0f];
    titleLabel.textColor =  [UIColor colorWithRed:132.0/255 green:139.0/255 blue:143.0/255 alpha:1.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 1;
    [self addSubview:titleLabel];
    
}

-(void)setButtonTag:(NSInteger)aTag Target:(id)aTarget Action:(SEL)aSel{
    toggleButton.tag = aTag;
    [toggleButton addTarget:aTarget  action:aSel forControlEvents:UIControlEventTouchUpInside];
    [toggleButton setBackgroundImage:[RTSSWalletManagerRes obtainComponentImageWithWalletType:(WalletType)aTag-kRTSSBasicButtonTag] forState:UIControlStateNormal];
    titleLabel.text = [RTSSWalletManagerRes obtainComponentTitleWithWalletType:aTag - kRTSSBasicButtonTag];
}

-(void)setTitleColor:(UIColor *)color{
    titleLabel.textColor = color;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
