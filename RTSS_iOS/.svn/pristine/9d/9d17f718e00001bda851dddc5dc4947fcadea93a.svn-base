//
//  FindCenter.h
//  RTSS
//
//  Created by Jaffer on 15/4/9.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "MappActor.h"
#import "FindItemModel.h"

// 发现一次显示条目的粒度
static const NSInteger FindPageCapacity = 2;

// 发现数据来源
typedef NS_ENUM(NSInteger,FindItemSoruceType) {
    FindItemSoruceTypeLocal,                      //本地数据源
    FindItemSoruceTypeNetwork,                    //网络数据源
};

// 发现展现来源
typedef NS_ENUM(NSInteger, FindMode) {
    FindModeByDiscovery,                    //发现首页
    FindModeByTag,                          //发现标签页
    FindModeByCollection                    //发现收藏页
};


@protocol FindCenterDelegate <NSObject>

@optional

- (void)getItemsFinishedStatus:(int)status itmes:(NSArray *)items sourceType:(FindItemSoruceType)type findMode:(FindMode)mode currentPage:(NSInteger)currentPage;
- (void)updateItemPraiseStatusFinished:(int)status itemId:(NSInteger)itemId;
- (void)updateItemCollectStatusFinished:(int)status item:(FindItemModel *)item;

@end



@interface FindCenter : MappActor

@property (nonatomic, assign, readonly)FindMode curFindMode;
@property (nonatomic, assign, readonly)BOOL loadLocalData;
@property (nonatomic, assign)id<FindCenterDelegate>delegate;

// get items
- (void)getFindItemsByCurrentPage:(NSInteger)curPage pageCapacity:(NSInteger)pageCapacity findMode:(FindMode)mode;
- (void)getFindTagItemsByCurrentPage:(NSInteger)curPage pageCapacity:(NSInteger)pageCapacity itemTagId:(NSString *)tagId findMode:(FindMode)mode;
- (void)getCollectItemsByCurrentPage:(NSInteger)curPage pageCapacity:(NSInteger)pageCapacity findMode:(FindMode)mode;

//收藏
- (void)doCollectByItem:(FindItemModel *)item;
//取消收藏
- (void)cancelCollectByItem:(FindItemModel *)item;

//赞
- (void)doPraiseByItemId:(NSInteger)itemId;
//取消赞
- (void)cancelPraiseByItemId:(NSInteger)itemId;

//db
- (BOOL)insertItem:(FindItemModel *)item findMode:(FindMode)mode;
- (BOOL)insertItems:(NSArray *)items findMode:(FindMode)mode;
- (BOOL)deleteAllItemsByFindMode:(FindMode)mode;
- (BOOL)deleteItemByFindItem:(FindItemModel *)model findMode:(FindMode)mode;
- (BOOL)updateItem:(FindItemModel *)item findMode:(FindMode)mode;
- (NSArray *)queryItemsFromDBByCurrentPage:(NSInteger)curPage pageCapacity:(NSInteger)pageCapacity findMode:(FindMode)mode;
- (FindItemModel *)queryItemFromDBByItemId:(NSInteger)itemId findMode:(FindMode)mode;
- (BOOL)checkItemExistStatus:(FindItemModel *)item findMode:(FindMode)mode;

@end
