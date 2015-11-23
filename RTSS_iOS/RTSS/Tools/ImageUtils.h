//
//  ImageUtils.h
//  SJB
//
//  Created by sheng yinpeng on 13-7-25.
//  Copyright (c) 2013年 sheng yinpeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageUtils : NSObject

// 按比例旋转图片
+ (UIImage*)scaleAndRotateImage:(UIImage *)image;

// 按比例缩放图片
+ (UIImage*)scaleImage:(UIImage*)image scaleWidth:(CGFloat)scaleWidth;

// 按手机屏幕尺寸获取图片
+ (UIImage*)imageNamed:(NSString*)name ofType:(NSString*)ext;

//创建纯色图片
+(UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size;

// 将View转换成图片
+ (UIImage*)convertViewToImage:(UIView*)view;

@end
