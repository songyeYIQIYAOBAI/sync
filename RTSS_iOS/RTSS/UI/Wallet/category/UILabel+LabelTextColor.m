//
//  UILabel+LabelTextColor.m
//  RTSS
//
//  Created by 蔡杰 on 14-10-30.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "UILabel+LabelTextColor.h"

#import "RTSSAppStyle.h"

@implementation UILabel (LabelTextColor)

-(void)setTextMainColor{
    self.textColor =  [RTSSAppStyle currentAppStyle].textMajorColor;
}
-(void)setTextAuxiliaryColor{
    self.textColor =  [RTSSAppStyle currentAppStyle].textSubordinateColor;
}

@end
