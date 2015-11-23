//
//  PortraitView.h
//  RTSS
//
//  Created by 加富董 on 14-11-5.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PortraitView : UIView

@property (nonatomic, readonly) UIButton *portraitButton;

- (id)         initWithFrame:(CGRect)frame
      placeholderImageNormal:(UIImage *)normalImage
 placeHolderImageHighlighted:(UIImage *)highlightedImage
                 borderColor:(UIColor *)borderColor
                 borderWidth:(CGFloat)borderWidth
                cornerRadius:(CGFloat)radius
                       title:(NSString *)title
                   addTarget:(id)targer
                      action:(SEL)actionSelector
                         tag:(NSInteger)tag;



@end
