//
//  MultiDownloader.m
//  SJB2
//
//  Created by shengyp on 14-5-15.
//  Copyright (c) 2014年 ailk. All rights reserved.
//

#import "MultiDownloader.h"
#import "FileUtils.h"
#import "CommonUtils.h"

#define MultiMaxURLCount                200
#define MultiTotalCostCache 			50 * 1024 * 1024

static MultiDownloader* 				_multiDownloader = nil;

@interface MultiDownloader()
{
	NSCache*                            _dataCache;
    NSMutableDictionary*                _urlDataDictionary;
}

@end

@implementation MultiDownloader

- (void)dealloc
{
	[_dataCache release];
    [_urlDataDictionary release];
	
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataCache = [[NSCache alloc] init];
		[_dataCache setName:@"Multi_Data_Cache"];
		[_dataCache setCountLimit:MultiMaxURLCount];
        [_dataCache setTotalCostLimit:MultiTotalCostCache];
        
        _urlDataDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

+ (MultiDownloader*)standardMultiDownloader
{
	@synchronized(self){
		if(nil == _multiDownloader){
			_multiDownloader = [[MultiDownloader alloc] init];
		}
	}
	return _multiDownloader;
}

+ (void)destroy
{
	@synchronized(self){
		if(nil != _multiDownloader){
			[_multiDownloader release];
			_multiDownloader = nil;
		}
	}
}

- (void)setCacheSizeLimit:(NSUInteger)sizeLimit
{
	[_dataCache setCountLimit:sizeLimit];
}

- (NSUInteger)getCacheSizeLimit
{
	return [_dataCache countLimit];
}

- (void)setCacheObject:(NSData*)data forKey:(id)key
{
    if(nil != data && nil != key){
        [_dataCache setObject:data forKey:key cost:data.length];
    }
}

- (void)removeCacheObjectForKey:(id)key
{
    [_dataCache removeObjectForKey:key];
}

- (void)clearCache
{
	[_dataCache removeAllObjects];
}

- (NSString*)filterUrl:(NSString*)urlPath
{
	NSString* filterUrl = [urlPath stringByReplacingOccurrencesOfString:@"\\W"
															 withString:@"_"
																options:NSRegularExpressionSearch
																  range:NSMakeRange(0, [urlPath length])];
	return filterUrl;
}

- (BOOL)writeToFile:(NSString*)urlPath cachePath:(NSString*)cachePath fileData:(NSData*)data
{
	if((nil != urlPath && 0 != urlPath.length) && (nil != urlPath && 0 != cachePath.length)){
		if(nil != data && data.length > 0){
			NSString* fileName = [self filterUrl:urlPath];
			NSString* filePath = [NSString stringWithFormat:@"%@/%@",cachePath,fileName];
			if([FileUtils creatFilePath:cachePath]){
				return [data writeToFile:filePath atomically:YES];
			}
		}
	}
	return NO;
}

- (NSData*)fileCache:(NSString*)urlPath cachePath:(NSString*)cachePath
{
	if((nil != urlPath && 0 != urlPath.length) && (nil != urlPath && 0 != cachePath.length)){
		NSString* fileName = [self filterUrl:urlPath];
		NSString* filePath = [NSString stringWithFormat:@"%@/%@",cachePath,fileName];
		NSFileManager* fileManager = [NSFileManager defaultManager];
		if([fileManager fileExistsAtPath:filePath]){
			return [NSData dataWithContentsOfFile:filePath];
		}
	}
	return nil;
}

- (void)request:(NSString*)urlPath cachePath:(NSString*)cachePath completion:(downloadData)completionDownloadDataBlock
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
		// 文件缓存文件
		NSData* data = [self fileCache:urlPath cachePath:cachePath];
		if(nil != data && data.length > 0){
			[_dataCache setObject:data forKey:urlPath cost:data.length];
			if(completionDownloadDataBlock){
                completionDownloadDataBlock(data, CacheDataStatusFileCache);
			}
			return ;
		}
		// 网络数据文件
		NSData* netData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlPath]];
		if(nil != netData && netData.length > 0){
			[_dataCache setObject:netData forKey:urlPath cost:netData.length];
            if([self writeToFile:urlPath cachePath:cachePath fileData:netData]){
                if(nil != completionDownloadDataBlock){
                    completionDownloadDataBlock(netData,CacheDataStatusNetworkCache);
                }
            }
			return;
		}
        // 网络异常
        if(nil != completionDownloadDataBlock){
            completionDownloadDataBlock(nil, CacheDataStatusError);
        }
    });
}

//- (void)imageWithPath:(NSString*)urlPath cachePath:(NSString*)cachePath completion:(completionWithImageFromCache)imageBlock
//{
//	[self dataWithPath:urlPath cachePath:cachePath completion:^(NSData* data, BOOL fromCache){
//		if(nil != imageBlock){
//			UIImage *image = [UIImage imageWithData:data];
//			imageBlock(image, fromCache);
//		}
//	}];
//}

- (UIImage*)imageWithPath:(NSString*)urlPath cachePath:(NSString*)cachePath completion:(completionWithImage)imageBlock
{
    NSData* data = [self dataWithPath:urlPath cachePath:cachePath completion:^(NSData *data) {
        if(imageBlock){
            UIImage* image = [UIImage imageWithData:data];
            imageBlock(image);
        }
    }];
    return [UIImage imageWithData:data];
}

- (NSData*)dataWithPath:(NSString*)urlPath cachePath:(NSString*)cachePath completion:(completionWithData)dataBlock
{
	if(YES != [CommonUtils objectIsValid:urlPath]){
		return nil;
	}
    
    // 内存缓存数据，直接返回数据对象
	NSData* data = [_dataCache objectForKey:urlPath];
	if(nil != data && data.length > 0){
        return data;
	}else{
        // 块回调缓存，针对同一个URL地址
        completionWithData dataBlockCopy = Block_copy(dataBlock);
        NSMutableArray* blockArray = [_urlDataDictionary objectForKey:urlPath];
        if(nil == blockArray){
            NSMutableArray* blocks = [[NSMutableArray alloc] initWithCapacity:0];
            [blocks addObject:dataBlockCopy];
            [_urlDataDictionary setObject:blocks forKey:urlPath];
            [blocks release];
            
            // 文件或者网络文件
            [self request:urlPath cachePath:cachePath completion:^(NSData* data, NSInteger status) {
                
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    
                    if(CacheDataStatusError == status || nil == data){
                        if(dataBlock){
                            dataBlock(nil);
                        }
                    }else if((CacheDataStatusNetworkCache == status || CacheDataStatusFileCache == status) && nil != data){
                        
                        for (int i = 0; i < [[_urlDataDictionary objectForKey:urlPath] count]; i ++) {
                            completionWithData completionBlock = [[_urlDataDictionary objectForKey:urlPath] objectAtIndex:i];
                            if(completionBlock){
                                completionBlock(data);
                            }
                        }
                    }else {
                        if(dataBlock){
                            dataBlock(nil);
                        }
                    }
                    
                    [[_urlDataDictionary objectForKey:urlPath] removeAllObjects];
                    [_urlDataDictionary removeObjectForKey:urlPath];
                });
            }];
        }else{
            [blockArray addObject:dataBlockCopy];
        }
        CFRelease(dataBlockCopy);
    }
    
    return nil;
}

@end
