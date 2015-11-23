//
//  CachePath.h
//  SJB
//
//  Created by sheng yinpeng on 13-8-26.
//  Copyright (c) 2013年 sheng yinpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MultiDownloader.h"

@interface CachePath : NSObject

// 头像缓存目录
+ (NSString*)userPortraitCachePath;

@end

@interface Cache : NSObject

+ (Cache*)standardCache;

- (UIImage*)getLargePortraitImageWithUrl:(NSString*)imageUrl completion:(completionWithImage)imageBlock;

- (UIImage*)getSmallPortraitImageWithUrl:(NSString*)imageUrl completion:(completionWithImage)imageBlock;

- (void)updateImageWithUrl:(NSString*)imageUrl data:(NSData*)imageData;

- (UIImage*)getSmallPortraitImageWithUrl:(NSString*)imageUrl placeHolderImageName:(NSString *)holderImageName completion:(completionWithImage)imageBlock;

@end
