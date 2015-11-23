//
//  CachePath.m
//  SJB
//
//  Created by sheng yinpeng on 13-8-26.
//  Copyright (c) 2013年 sheng yinpeng. All rights reserved.
//

#import "Cache.h"
#import "FileUtils.h"

@implementation CachePath

+ (NSString*)userPortraitCachePath
{
    return [FileUtils getCachesDirectoryByFile:@"UserPortrait"];
}

@end

static Cache* mCache = nil;

@implementation Cache

- (void)dealloc
{
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (Cache*)standardCache{
    @synchronized(self){
        if(nil == mCache){
            mCache = [[Cache alloc] init];
        }
    }
    return mCache;
}

- (UIImage*)getLargePortraitImageWithUrl:(NSString*)imageUrl completion:(completionWithImage)imageBlock{
    UIImage* largeImage = [UIImage imageNamed:@"common_head_icon_d.png"];
    UIImage* imageTemp = [[MultiDownloader standardMultiDownloader] imageWithPath:imageUrl
                                                                        cachePath:[CachePath userPortraitCachePath]
                                                                       completion:^(UIImage *image) {
                                                                           if(nil == image){
                                                                               image = [UIImage imageNamed:@"common_head_icon_d.png"];
                                                                           }
                                                                           if(imageBlock){
                                                                               imageBlock(image);
                                                                           }
                                                                       }];
    if(nil != imageTemp){
        largeImage = imageTemp;
    }
    return largeImage;
}

- (UIImage*)getSmallPortraitImageWithUrl:(NSString*)imageUrl completion:(completionWithImage)imageBlock{
    UIImage* smallImage = [UIImage imageNamed:@"friends_default_icon.png"];

    UIImage* imageTemp = [[MultiDownloader standardMultiDownloader] imageWithPath:imageUrl
                                                                        cachePath:[CachePath userPortraitCachePath]
                                                                       completion:^(UIImage *image) {
                                                                           if(nil == image){
                                                                               image = [UIImage imageNamed:@"friends_default_icon.png"];
                                                                           }
                                                                           if(imageBlock){
                                                                               imageBlock(image);
                                                                           }
                                                                       }];
    if(nil != imageTemp){
        smallImage = imageTemp;
    }
    return smallImage;
}

- (void)updateImageWithUrl:(NSString*)imageUrl data:(NSData*)imageData{
    if(nil != imageUrl && nil != imageData){
        [[MultiDownloader standardMultiDownloader] removeCacheObjectForKey:imageUrl];
        [[MultiDownloader standardMultiDownloader] setCacheObject:imageData forKey:imageUrl];
    }
}

- (UIImage*)getSmallPortraitImageWithUrl:(NSString*)imageUrl placeHolderImageName:(NSString *)holderImageName completion:(completionWithImage)imageBlock {
    UIImage* smallImage = [UIImage imageNamed:holderImageName];
    
    UIImage* imageTemp = [[MultiDownloader standardMultiDownloader] imageWithPath:imageUrl
                                                                        cachePath:[CachePath userPortraitCachePath]
                                                                       completion:^(UIImage *image) {
                                                                           if(nil == image){
                                                                               image = [UIImage imageNamed:holderImageName];
                                                                           }
                                                                           if(imageBlock){
                                                                               imageBlock(image);
                                                                           }
                                                                       }];
    if(nil != imageTemp){
        smallImage = imageTemp;
    }
    return smallImage;
}


@end
