//
//  MultiDownloader.h
//  SJB2
//
//  Created by shengyp on 14-5-15.
//  Copyright (c) 2014年 ailk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^completionWithImage)(UIImage* image);

typedef void (^completionWithData)(NSData* data);

typedef void (^downloadData)(NSData* data, NSInteger status);

typedef NS_ENUM(NSInteger, CacheDataStatus) {
    CacheDataStatusError            = -1,
    CacheDataStatusFileCache        = 0,
    CacheDataStatusNetworkCache     = 1
};

@interface MultiDownloader : NSObject

+ (MultiDownloader*)standardMultiDownloader;

+ (void)destroy;

- (void)clearCache;

- (void)setCacheSizeLimit:(NSUInteger)sizeLimit;

- (NSUInteger)getCacheSizeLimit;

- (void)removeCacheObjectForKey:(id)key;

- (void)setCacheObject:(NSData*)data forKey:(id)key;

- (UIImage*)imageWithPath:(NSString*)urlPath cachePath:(NSString*)cachePath completion:(completionWithImage)imageBlock;

- (NSData*)dataWithPath:(NSString*)urlPath cachePath:(NSString*)cachePath completion:(completionWithData)dataBlock;

@end
