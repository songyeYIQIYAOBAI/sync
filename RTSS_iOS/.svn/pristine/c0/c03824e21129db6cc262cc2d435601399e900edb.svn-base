//
//  FindCenter.m
//  RTSS
//
//  Created by Jaffer on 15/4/9.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "FindCenter.h"
#import "CommonUtils.h"
#import "SBJSON.h"
#import "RTSSUserDataDB.h"
#import "RTSSDBModel.h"
#import "FMResultSet.h"
#import "MappClient.h"
#import "FindItemModel.h"

#define __TEST_FIRST__

@interface FindCenter () <MappActorDelegate>{
    NSInteger netWorkDataCurrentPage;
}

@end

@implementation FindCenter

@synthesize loadLocalData;
@synthesize delegate;

#pragma mark dealloc
- (void)dealloc {
    [super dealloc];
}

#pragma mark init
- (instancetype)init {
    if (self = [super init]) {
        loadLocalData = YES;
        netWorkDataCurrentPage = -1;
        [RTSSUserDataDB standardRTSSUserDataDB];
    }
    return self;
}

#pragma mark query praise collect
//discover mode
- (void)getFindItemsByCurrentPage:(NSInteger)curPage pageCapacity:(NSInteger)pageCapacity findMode:(FindMode)mode {
    if (loadLocalData) {
        //先从数据库返回数据
        /*********************
        NSArray *localItems = [self queryItemsFromDBByCurrentPage:curPage pageCapacity:pageCapacity findMode:mode];
        [self executeCallBackStatus:0 data:localItems dataType:FindItemSoruceTypeLocal findMode:mode];
        **********************/
        
        //由于现在网络接口还没有，数据同步会出现问题，所以暂时不掉用真正的网络接口，数据全部由数据库返回，如果数据库没有数据，此时再生成家啊数据，插入数据库，再查询
        NSArray *localItems = [self queryItemsFromDBByCurrentPage:curPage pageCapacity:pageCapacity findMode:mode];
        if ([CommonUtils objectIsValid:localItems]) {
            [self executeCallBackStatus:0 data:localItems dataType:FindItemSoruceTypeLocal findMode:mode];
        } else {
            [self insertItems:[self fakeData] findMode:mode];
            //从数据库中读取数据
            NSArray *localItems = [self queryItemsFromDBByCurrentPage:curPage pageCapacity:pageCapacity findMode:mode];
            [self executeCallBackStatus:0 data:localItems dataType:FindItemSoruceTypeLocal findMode:mode];
        }

    }
    //从网络请求数据
    [self requestItemsFromServerByCurrentPage:curPage pageCapacity:pageCapacity itemTagId:@"0" findMode:mode delegate:self];
}

//tag mode
- (void)getFindTagItemsByCurrentPage:(NSInteger)curPage pageCapacity:(NSInteger)pageCapacity itemTagId:(NSString *)tagId findMode:(FindMode)mode {
    //从网络获取数据
    [self requestItemsFromServerByCurrentPage:curPage pageCapacity:pageCapacity itemTagId:tagId findMode:mode delegate:self];
}

//collect mode
- (void)getCollectItemsByCurrentPage:(NSInteger)curPage pageCapacity:(NSInteger)pageCapacity findMode:(FindMode)mode {
    //从数据库获取数据
    NSArray *collectItems = [self queryItemsFromDBByCurrentPage:curPage pageCapacity:pageCapacity findMode:mode];
    [self executeCallBackStatus:0 data:collectItems dataType:FindItemSoruceTypeLocal findMode:mode];
}

//do praise
- (void)doPraiseByItemId:(NSInteger)itemId {
    //先发送网络请求，使服务器做更新计算，然后跟新本地数据表，需要判断当前item在collect表中是否存在，如果在collect表中存在此item，那么也需要更新collect表，最后通知页面
    [self updateFindItemPraiseStatusByItemId:itemId praiseValue:1 delegate:self];
}

//cancel praise
- (void)cancelPraiseByItemId:(NSInteger)itemId {
    [self updateFindItemPraiseStatusByItemId:itemId praiseValue:-1 delegate:self];
}

//do collect
- (void)doCollectByItem:(FindItemModel *)item {
    //在此修改item的收藏字段值，再更新find和collect表，如果操作成功，回调页面，页面根据status结果，决定是否刷新本地数据
    int status = 0;
    @try {
        item.itemHasCollect = 1;
        //更新find表
        BOOL succeed = [self updateItem:item findMode:FindModeByDiscovery];
        if (succeed) {
            BOOL haveExist = [self checkItemExistStatus:item findMode:FindModeByCollection];
            if (haveExist) {
                //从collect表移除当前item
                [self deleteItemByFindItem:item findMode:FindModeByCollection];
            }
            //插入当前item到collect表
            succeed = [self insertItem:item findMode:FindModeByCollection];
            if (succeed == NO) {
                status = -1;
                //恢复find表数据
                item.itemHasCollect = 0;
                [self updateItem:item findMode:FindModeByDiscovery];
            }
        } else {
            status = -1;
            item.itemHasCollect = 0;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"find center::doCollectByItem::exception===%@",exception.description);
        status = -1;
    }
    @finally {
        if (delegate && [delegate respondsToSelector:@selector(updateItemCollectStatusFinished:item:)]) {
            [delegate updateItemCollectStatusFinished:status item:item];
        }
    }
}

//cancel collect
- (void)cancelCollectByItem:(FindItemModel *)item {
    //在此修改item的收藏字段值，再更新find和collect表，如果操作成功，回调页面，页面根据status结果，决定是否刷新本地数据
    int status = 0;
    @try {
        item.itemHasCollect = 0;
        //更新find表
        BOOL succeed = [self updateItem:item findMode:FindModeByDiscovery];
        if (succeed) {
            //从collect表中移除item
            succeed = [self deleteItemByFindItem:item findMode:FindModeByCollection];
            if (succeed == NO) {
                //恢复find表数据
                item.itemHasCollect = 1;
                [self updateItem:item findMode:FindModeByDiscovery];
            }
        } else {
            status = -1;
            item.itemHasCollect = 1;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"find center::cancelCollectByItem::exception===%@",exception);
        status = -1;
    }
    @finally {
        if (delegate && [delegate respondsToSelector:@selector(updateItemCollectStatusFinished:item:)]) {
            [delegate updateItemCollectStatusFinished:status item:item];
        }
    }
}

#pragma mark mapp actor interface
- (int)updateFindItemPraiseStatusByItemId:(NSInteger)itemId praiseValue:(NSInteger)praiseValue delegate:(id<MappActorDelegate>)del {
    int status = MappActorFinishStatusOK;
    @try {
//#ifndef APPLICATION_BUILDING_RELEASE
#if 0
        NSMutableDictionary *busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:[NSNumber numberWithInteger:itemId] forKey:@""];
        [busiParams setObject:[NSNumber numberWithInteger:praiseValue] forKey:@""];
        NSString *transactionId = [MappClient generateTransactionId];
        NSString *busiCode = @"";
        
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            NSInteger itemId = 0;
            @try {
                if (status == 0) {
                    if ([CommonUtils objectIsValid:responseEntity]) {
                        int code = [[responseEntity objectForKey:@"code"] intValue];
                        if (code == 0) {
                            //TODO
                            
                        } else {
                            NSDictionary* message = [responseEntity objectForKey:@"message"];
                            NSLog(@"find center::requestItemsFromServerByCurrentPage error message===%@", message);
                            status = code;
                        }
                    } else {
                        status = MappActorFinishStatusNetwork;
                    }
                }
            }
            @catch (NSException *exception) {
                status = MappActorFinishStatusInternalError;
                NSLog(@"find center::requestItemsFromServerByCurrentPage::exception===%@",exception.description);
            }
            @finally {
                if (del && [del respondsToSelector:@selector(updateFindItemPraiseStatusFinished:itemId:)]) {
                    [del updateFindItemPraiseStatusFinished:status itemId:itemId];
                }
            }
        }];
#else
        status = 0;
        if (del && [del respondsToSelector:@selector(updateFindItemPraiseStatusFinished:itemId:)]) {
            [del updateFindItemPraiseStatusFinished:status itemId:itemId];
        }
#endif
    }
    @catch (NSException *exception) {
        status = MappActorFinishStatusInternalError;
        NSLog(@"find center::requestItemsFromServerByCurrentPage::exception===%@",exception.description);
    }
    return status;
}

- (int)requestItemsFromServerByCurrentPage:(NSInteger)curPage pageCapacity:(NSInteger)pageCapacity itemTagId:(NSString *)tagId findMode:(FindMode)mode delegate:(id<MappActorDelegate>)del {
    int status = MappActorFinishStatusOK;
    @try {
//#ifdef APPLICATION_BUILDING_RELEASE
#if 0
        NSMutableDictionary* busiParams = [NSMutableDictionary dictionaryWithCapacity:0];
        [busiParams setObject:[NSNumber numberWithInteger:curPage] forKey:@""];
        [busiParams setObject:[NSNumber numberWithInteger:pageCapacity] forKey:@""];
        NSString* transactionId = [MappClient generateTransactionId];
        
        NSMutableDictionary* requestEntity = [NSMutableDictionary dictionaryWithCapacity:0];
        [requestEntity setObject:busiParams forKey:@"busiParams"];
        [requestEntity setObject:[NSNumber numberWithBool:__ENCRYPTION_ENABLED__] forKey:@"isEncrypt"];
        [requestEntity setObject:busiCode forKey:@"busiCode"];
        [requestEntity setObject:transactionId forKey:@"transactionId"];
        
        [self execute:busiCode requestEntity:requestEntity callback:^(int execStatus, NSDictionary *responseEntity) {
            int status = execStatus;
            NSMutableArray *itemsArray = [NSMutableArray arrayWithCapacity:0];
            @try {
                if (status == 0) {
                    if ([CommonUtils objectIsValid:responseEntity]) {
                        int code = [[responseEntity objectForKey:@"code"] intValue];
                        if (code == 0) {
                            //TODO
                            
                        } else {
                            NSDictionary* message = [responseEntity objectForKey:@"message"];
                            NSLog(@"find center::requestItemsFromServerByCurrentPage error message===%@", message);
                            status = code;
                        }
                    } else {
                        status = MappActorFinishStatusNetwork;
                    }
                }
            }
            @catch (NSException *exception) {
                status = MappActorFinishStatusInternalError;
                NSLog(@"find center::requestItemsFromServerByCurrentPage::exception===%@",exception.description);
            }
            @finally {
                if (del && [del respondsToSelector:@selector(queryFindItemsFromServerFinished:items:curPage:pageCapacitity:findMode:)]) {
                    [del queryFindItemsFromServerFinished:status items:itemsArray curPage:curPage pageCapacity:pageCapacity findMode:mode];
                }
            }
        }];
#else
        NSMutableArray *itemsArray = [NSMutableArray array];
        NSArray *itemData = [self fakeData];
        [itemsArray addObjectsFromArray:itemData];
        if (del && [del respondsToSelector:@selector(queryFindItemsFromServerFinished:items:curPage:pageCapacity:findMode:)]) {
            [del queryFindItemsFromServerFinished:status items:itemsArray curPage:curPage pageCapacity:pageCapacity findMode:mode];
        }
#endif
    }
    @catch (NSException *exception) {
        status = MappActorFinishStatusInternalError;
        NSLog(@"find center::requestItemsFromServerByCurrentPage::exception===%@",exception.description);
    }
    return status;
}

#pragma mark mapp actor delegate
- (void)updateFindItemPraiseStatusFinished:(NSInteger)status itemId:(NSInteger)itemId {
    /*
    //如果服务器更新数据成功，然而在更新本地数据库时出现问题，此时也应该通知页面刷新最新数据
    //下面的处理代码不应该放在此处，因为不能确定当前用户的当前请求的contentMode,也就无法准确获取item，会出现问题。所以，该部分代码移至vc中，由vc来获取item
    FindItemModel *item = [self queryItemFromDBByItemId:itemId findMode:FindModeByDiscovery];
    @try {
        if (status == 0) {
            if (item.itemHasHot == 1) {
                //之前已经被赞，现在是要取消赞
                item.itemHasHot = 0;
                if (item.itemHotCount > 0) {
                    item.itemHotCount -= 1;
                }
            } else if (item.itemHasHot == 0) {
                //之前没有赞，现在是要赞
                item.itemHasHot = 1;
                item.itemHotCount += 1;
            }
            //更新find表中的数据
            [self updateItem:item findMode:FindModeByDiscovery];
            //查看当前item在collect表中是否存在，若存在，需要更新collect表数据
            BOOL haveCollected = [self checkItemExistStatus:item findMode:FindModeByCollection];
            if (haveCollected) {
                //已经被收藏过，所以需要将最新的praise数据更新到collect表中
                [self updateItem:item findMode:FindModeByCollection];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Find center::updateFindItemPraiseStatusFinished::exception===%@",exception.description);
    }
    @finally {
        if (delegate && [delegate respondsToSelector:@selector(updateItemPraiseStatusFinished:item:)]) {
            [delegate updateItemPraiseStatusFinished:status item:item];
        }
    }
     */
    if (delegate && [delegate respondsToSelector:@selector(updateItemPraiseStatusFinished:itemId:)]) {
        [delegate updateItemPraiseStatusFinished:status itemId:itemId];
    }
}

- (void)queryFindItemsFromServerFinished:(NSInteger)status items:(NSArray *)items curPage:(NSInteger)pageIndex pageCapacity:(NSInteger)capacity findMode:(NSInteger)mode {
    NSMutableArray *resultItems = [NSMutableArray arrayWithCapacity:0];
    @try {
        //此处需要根据FindMode来决定数据如何处理
        if (status == MappActorFinishStatusOK && [CommonUtils objectIsValid:items]) {
            //请求的当前的页数赋值
            netWorkDataCurrentPage = pageIndex;
            if (mode == FindModeByDiscovery) {
                //discover页面请求的数据，需要先入库，再从库中取
                if (loadLocalData) {
                    //首次请求的数据，入库前需要先将数据库中数据清除
                    [self deleteAllItemsByFindMode:mode];
                }
                //先判断每一条数据在collection表中是否已经存在，以此修改model的hascollection状态，这样页面在刷新数据时，就不需要再做判断。
                [self updateItemCollectStatus:items];
                //插入数据
                [self insertItems:items findMode:mode];
                //从数据库中读取数据
                NSArray *itemsFormDB = [self queryItemsFromDBByCurrentPage:pageIndex pageCapacity:capacity findMode:mode];
                [resultItems addObjectsFromArray:itemsFormDB];
                loadLocalData = NO;
            } else if (mode == FindModeByTag) {
                //tag页面请求的数据，直接返回，不做数据库操作
                [resultItems addObjectsFromArray:items];
            }
        }
    }
    @catch (NSException *exception) {
        status = MappActorFinishStatusInternalError;
        NSLog(@"find center::queryFindItemsFromServerFinished::exception===%@",exception);
    }
    @finally {
        //执行回调
        [self executeCallBackStatus:status data:resultItems dataType:FindItemSoruceTypeNetwork findMode:mode];
    }
}

#pragma mark call back
- (void)executeCallBackStatus:(int)status data:(NSArray *)data dataType:(FindItemSoruceType)type findMode:(FindMode)mode{
    //callback 回调的时候判断是否是网络数据，如果是网络数据就要把当前请求的页数返回，界面根据页数时候删除内存当中的数据
    NSInteger currentPage = -1;
    if (type == FindItemSoruceTypeLocal) {
        
    }else if (type == FindItemSoruceTypeNetwork){
        currentPage = netWorkDataCurrentPage;
    }
    if (delegate && [delegate respondsToSelector:@selector(getItemsFinishedStatus:itmes:sourceType:findMode:currentPage:)]) {
        
        [delegate getItemsFinishedStatus:status itmes:data sourceType:type findMode:mode currentPage:currentPage];
    }
}

#pragma mark db operate method
- (BOOL)insertItem:(FindItemModel *)item findMode:(FindMode)mode {
    if (NO == [self optimizeFindItem:item]) {
        return NO;
    }
    BOOL status = YES;
    @try {
        NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO %@ (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",[self getTableNameByFindMode:mode],FIND_COLUMS_ID,FIND_COLUMS_TYPE,FIND_COLUMS_CATALOG,FIND_COLUMS_NAME,FIND_COLUMS_TITLE,FIND_COLUMS_DATE,FIND_COLUMS_ICON_URL,FIND_COLUMS_PIC_URL,FIND_COLUMS_DESCRIPTION,FIND_COLUMS_TARGET_URL,FIND_COLUMS_HOT_COUNT,FIND_COLUMS_HAS_HOT,FIND_COLUMS_COMMENT_COUNT,FIND_COLUMS_TAG_INFO,FIND_COLUMS_HAS_COLLECT];
        
        status = [[RTSSUserDataDB standardRTSSUserDataDB] update:sqlStr
                                                            args:@[
                                                                   [NSNumber numberWithInteger:item.itemId],
                                                                   [NSNumber numberWithInteger:item.itemType],
                                                                   [NSNumber numberWithInteger:item.itemCatalog],
                                                                   item.itemName,
                                                                   item.itemTitle,
                                                                   item.itemDate,
                                                                   item.itemIconURL,
                                                                   item.itemPicURL,
                                                                   item.itemDescription,
                                                                   item.itemTargetUrl,
                                                                   [NSNumber numberWithInteger:item.itemHotCount],
                                                                   [NSNumber numberWithInteger:item.itemHasHot],
                                                                   [NSNumber numberWithInteger:item.itemCommentCount],
                                                                   [self archiveItemParameters:item.itemTagDic],
                                                                   [NSNumber numberWithInteger:item.itemHasCollect]]];

    }
    @catch (NSException *exception) {
        NSLog(@"find center::insertItem::exception===%@",exception.description);
        status = NO;
    }
    return status;
}

- (BOOL)insertItems:(NSArray *)items findMode:(FindMode)mode {
    BOOL status = YES;
    @try {
        for (int i = 0; i < [items count]; i ++) {
            if (NO == [self insertItem:[items objectAtIndex:i] findMode:mode]) {
                continue;
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"find center::insertItems::exception===%@",exception.description);
        status = NO;
    }
    return status;
}

- (BOOL)deleteAllItemsByFindMode:(FindMode)mode {
    BOOL status = YES;
    @try {
        NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM %@",[self getTableNameByFindMode:mode]];
        status = [[RTSSUserDataDB standardRTSSUserDataDB] update:sqlStr args:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"find center::deleteAllItems::exception===%@",exception.description);
        status = NO;
    }
    return status;
}

- (BOOL)deleteItemByFindItem:(FindItemModel *)model findMode:(FindMode)mode {
    BOOL status = YES;
    @try {
        NSString *sqlString = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",[self getTableNameByFindMode:mode],FIND_COLUMS_ID];
        status = [[RTSSUserDataDB standardRTSSUserDataDB] update:sqlString args:@[[NSNumber numberWithInteger:model.itemId]]];
    }
    @catch (NSException *exception) {
        NSLog(@"find center::deleteItemByFindItem::exception===%@",exception.description);
        status = NO;
    }
    @finally {
        return status;
    }
}

- (BOOL)updateItem:(FindItemModel *)item findMode:(FindMode)mode {
    if (NO == [self optimizeFindItem:item]) {
        return NO;
    }
    BOOL status = YES;
    @try {
        NSString *sqlString = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ? WHERE %@ = ?",[self getTableNameByFindMode:mode],FIND_COLUMS_TYPE,FIND_COLUMS_CATALOG,FIND_COLUMS_NAME,FIND_COLUMS_TITLE,FIND_COLUMS_DATE,FIND_COLUMS_ICON_URL,FIND_COLUMS_PIC_URL,FIND_COLUMS_DESCRIPTION,FIND_COLUMS_TARGET_URL,FIND_COLUMS_HOT_COUNT,FIND_COLUMS_HAS_HOT,FIND_COLUMS_COMMENT_COUNT,FIND_COLUMS_HAS_COLLECT,FIND_COLUMS_TAG_INFO, FIND_COLUMS_ID];
        status = [[RTSSUserDataDB standardRTSSUserDataDB] update:sqlString
                                                            args:@[
                                                                   [NSNumber numberWithInteger:item.itemType],
                                                                   [NSNumber numberWithInteger:item.itemCatalog],
                                                                   item.itemName,
                                                                   item.itemTitle,
                                                                   item.itemDate,
                                                                   item.itemIconURL,
                                                                   item.itemPicURL,
                                                                   item.itemDescription,
                                                                   item.itemTargetUrl,
                                                                   [NSNumber numberWithInteger:item.itemHotCount],
                                                                   [NSNumber numberWithInteger:item.itemHasHot],
                                                                   [NSNumber numberWithInteger:item.itemCommentCount],
                                                                   [NSNumber numberWithInteger:item.itemHasCollect],
                                                                   [self archiveItemParameters:item.itemTagDic],
                                                                   [NSNumber numberWithInteger:item.itemId]]];
    }
    @catch (NSException *exception) {
        NSLog(@"find center::updateItem::exception===%@",exception.description);
        status = NO;
    }
    return status;
}

- (NSArray *)queryItemsFromDBByCurrentPage:(NSInteger)curPage pageCapacity:(NSInteger)pageCapacity findMode:(FindMode)mode {
    NSMutableArray *items = [NSMutableArray array];
    NSInteger queryStartIndex = pageCapacity * curPage;
    NSString *sqlStr = nil;
    if (mode == FindModeByCollection) {
        sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@ LIMIT %d,%d",[self getTableNameByFindMode:mode],queryStartIndex,pageCapacity];
    } else if (mode == FindModeByDiscovery) {
        sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@ ASC LIMIT %d,%d",[self getTableNameByFindMode:mode],FIND_COLUMS_SN,queryStartIndex,pageCapacity];
    }
    @try {
        FMResultSet *resSet = [[RTSSUserDataDB standardRTSSUserDataDB] query:sqlStr args:nil];
        NSArray *itemsArray = [self bulidFindItemModelByQueryResult:resSet];
        if ([CommonUtils objectIsValid:itemsArray]) {
            [items addObjectsFromArray:itemsArray];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"find center::getItems::exception===%@",exception.description);
    }
    return items;
}

- (FindItemModel *)queryItemFromDBByItemId:(NSInteger)itemId findMode:(FindMode)mode {
    NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?",[self getTableNameByFindMode:mode],FIND_COLUMS_ID];
    FindItemModel *itemModel = nil;
    @try {
        FMResultSet *result = [[RTSSUserDataDB standardRTSSUserDataDB] query:sqlStr args:@[[NSNumber numberWithInteger:itemId]]];
        NSArray *resultItems = [self bulidFindItemModelByQueryResult:result];
        if ([CommonUtils objectIsValid:resultItems]) {
            itemModel = [resultItems objectAtIndex:0];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"find center::queryItemFromDBByItemId");
    }
    @finally {
        return itemModel;
    }
}

- (BOOL)checkItemExistStatus:(FindItemModel *)item findMode:(FindMode)mode {
    BOOL status = NO;
    if (item.itemId) {
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?",[self getTableNameByFindMode:mode],FIND_COLUMS_ID];
        @try {
            FMResultSet *result = [[RTSSUserDataDB standardRTSSUserDataDB] query:sqlStr args:@[[NSNumber numberWithInteger:item.itemId]]];
            while ([result next]) {
                //have exist
                status = YES;
                break;
            }
        }
        @catch (NSException *exception) {
            NSLog(@"find center::checkItemExistStatus::exception===%@",exception.description);
        }
    }
    return status;
}

- (NSArray *)bulidFindItemModelByQueryResult:(FMResultSet *)resSet {
    NSMutableArray *items = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    while ([resSet next]) {
        FindItemModel* item = [[FindItemModel alloc] init];
        item.itemId = [resSet intForColumn:FIND_COLUMS_ID];
        item.itemType = [resSet intForColumn:FIND_COLUMS_TYPE];
        item.itemCatalog = [resSet intForColumn:FIND_COLUMS_CATALOG];
        item.itemName = [resSet stringForColumn:FIND_COLUMS_NAME];
        item.itemTitle = [resSet stringForColumn:FIND_COLUMS_TITLE];
        item.itemDate = [resSet stringForColumn:FIND_COLUMS_DATE];
        item.itemIconURL = [resSet stringForColumn:FIND_COLUMS_ICON_URL];
        item.itemPicURL = [resSet stringForColumn:FIND_COLUMS_PIC_URL];
        item.itemDescription = [resSet stringForColumn:FIND_COLUMS_DESCRIPTION];
        item.itemTargetUrl = [resSet stringForColumn:FIND_COLUMS_TARGET_URL];
        item.itemHotCount = [resSet intForColumn:FIND_COLUMS_HOT_COUNT];
        item.itemHasHot = [resSet intForColumn:FIND_COLUMS_HAS_HOT];
        item.itemCommentCount = [resSet intForColumn:FIND_COLUMS_COMMENT_COUNT];
        item.itemTagDic = [self unarchiveItemParameters:[resSet stringForColumn:FIND_COLUMS_TAG_INFO]];
        if ([CommonUtils objectIsValid:item.itemTagDic]) {
            item.itemTagsArray = [self bulidTagModel:item.itemTagDic];
        }
        item.itemHasCollect = [resSet intForColumn:FIND_COLUMS_HAS_COLLECT];
        [items addObject:item];
        [item release];
    }
    return items;
}

//#ifndef APPLICATION_BUILDING_RELEASE
- (NSArray *)fakeData {
    NSMutableArray* findMessageArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    {
        FindItemModel* item = [[FindItemModel alloc] init];
        item.itemName = @"《Free Spotify Premium and 2GB data》";
        item.itemTitle = @"Amazing Christmas gifts";
        item.itemDate = @"2015-01-22";
        item.itemType = 0;
        item.itemDescription = @"Right now, you can choose between two of the best-value phones around, loaded up with 3 months free Spotify Premium access, and a free $40 Cap Starter Pack packed with 2GB data.";
        item.itemIconURL = @"";
        item.itemPicURL = @"";
        item.itemTargetUrl = @"http://www.baidu.com";
        item.itemTagDic = @{@"0000001":@"发生了发达",@"00000002":@"大幅广",@"00000003":@"放大舒服",@"00000":@"福建大煞风景啦",@"0000001111122222":@"奋斗是垃圾分类积分",@"fdsafdfaf":@"fdffaff",@"gfgfgfg":@"gfgrtretre",@"jhjhgjfhg":@"ytryrty",@"tytryetry":@"jyjjry"};
        
        item.itemTagsArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        FindTagModel *tagModel1 = [[FindTagModel alloc] init];
        tagModel1.tagId = @"0000001";
        tagModel1.tagName = @"发生了发达";
        [item.itemTagsArray addObject:tagModel1];
        [tagModel1 release];
        
        FindTagModel *tagModel2 = [[FindTagModel alloc] init];
        tagModel2.tagId = @"00000002";
        tagModel2.tagName = @"大幅广";
        [item.itemTagsArray addObject:tagModel2];
        [tagModel2 release];
        
        FindTagModel *tagModel3 = [[FindTagModel alloc] init];
        tagModel3.tagId = @"00000003";
        tagModel3.tagName = @"放大舒服";
        [item.itemTagsArray addObject:tagModel3];
        [tagModel3 release];
       
        FindTagModel *tagModel4 = [[FindTagModel alloc] init];
        tagModel4.tagId = @"00000";
        tagModel4.tagName = @"福建大煞风景啦";
        [item.itemTagsArray addObject:tagModel4];
        [tagModel4 release];
        
        FindTagModel *tagModel5 = [[FindTagModel alloc] init];
        tagModel5.tagId = @"0000001111122222";
        tagModel5.tagName = @"奋斗是垃圾分类积分";
        [item.itemTagsArray addObject:tagModel5];
        [tagModel5 release];
        
        FindTagModel *tagModel6 = [[FindTagModel alloc] init];
        tagModel6.tagId = @"fdsafdfaf";
        tagModel6.tagName = @"fdffaff";
        [item.itemTagsArray addObject:tagModel6];
        [tagModel6 release];
        
        FindTagModel *tagModel7 = [[FindTagModel alloc] init];
        tagModel7.tagId = @"gfgfgfg";
        tagModel7.tagName = @"gfgrtretre";
        [item.itemTagsArray addObject:tagModel7];
        [tagModel7 release];
        
        FindTagModel *tagModel8 = [[FindTagModel alloc] init];
        tagModel8.tagId = @"jhjhgjfhg";
        tagModel8.tagName = @"ytryrty";
        [item.itemTagsArray addObject:tagModel8];
        [tagModel8 release];
        
        item.itemHasHot = 0;
        item.itemHotCount = 100;
        item.itemCommentCount = 5;
        item.itemId = 1;
        item.itemHasCollect = 0;
        [findMessageArray addObject:item];
        [item release];
    }
    
    {
        FindItemModel* item = [[FindItemModel alloc] init];
        item.itemName = @"《Free Spotify Premium and 2GB data》";
        item.itemTitle = @"Amazing Christmas gifts";
        item.itemDate = @"2015-01-22";
        item.itemType = 0;
        item.itemDescription = @"Right now, you can choose between two of the best-value phones around, loaded up with 3 months free Spotify Premium access, and a free $40 Cap Starter Pack packed with 2GB data.";
        item.itemIconURL = @"";
        item.itemPicURL = @"";
        item.itemTargetUrl = @"http://www.baidu.com";
        item.itemTagDic = @{@"0000001":@"发生了发达"};
        
        item.itemTagsArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        FindTagModel *tagModel1 = [[FindTagModel alloc] init];
        tagModel1.tagId = @"8954324";
        tagModel1.tagName = @"riwoprr发地方";
        [item.itemTagsArray addObject:tagModel1];
        [tagModel1 release];
        
        FindTagModel *tagModel2 = [[FindTagModel alloc] init];
        tagModel2.tagId = @"428349032890";
        tagModel2.tagName = @"f发觉疯狂的世界啊发的撒";
        [item.itemTagsArray addObject:tagModel2];
        [tagModel2 release];
        
        item.itemHasHot = 1;
        item.itemHotCount = 10;
        item.itemCommentCount = 50;
        item.itemId = 2;
        [findMessageArray addObject:item];
        [item release];
    }
    
    {
        FindItemModel* item = [[FindItemModel alloc] init];
        item.itemName = @"织图";
        item.itemTitle = @"【织图】画中画讲故事";
        item.itemDate = @"2014-05-19";
        item.itemType = 1;
        item.itemDescription = @"旅游拍回的照片用织图编成故事给朋友看吧！织图用画中画的方式将现场真实地还原在手机上，同时也可以用它来制作自己的街景地图。独有的多图片编辑和浏览体验，第一眼就能惊艳。";
        item.itemIconURL = @"http://www.x.cn//discovery/app/zhitu/icon.png";
        item.itemPicURL = @"http://www.x.cn//discovery/app/zhitu/app.png";
        item.itemTagDic = @{@"0000001":@"发生了发达",@"00000002":@"大幅广"};
        item.itemTagsArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        FindTagModel *tagModel1 = [[FindTagModel alloc] init];
        tagModel1.tagId = @"9876";
        tagModel1.tagName = @"风刀霜剑法律撒娇";
        [item.itemTagsArray addObject:tagModel1];
        [tagModel1 release];
        
        FindTagModel *tagModel2 = [[FindTagModel alloc] init];
        tagModel2.tagId = @"000000090";
        tagModel2.tagName = @"v现在就看风景防空洞里撒娇";
        [item.itemTagsArray addObject:tagModel2];
        [tagModel2 release];
        
        FindTagModel *tagModel3 = [[FindTagModel alloc] init];
        tagModel3.tagId = @"00000003456";
        tagModel3.tagName = @"v 发的撒可减肥反馈到拉萨积分";
        [item.itemTagsArray addObject:tagModel3];
        [tagModel3 release];
        
        item.itemHasHot = 1;
        item.itemHotCount = 1000;
        item.itemCommentCount = 500;
        item.itemHasCollect = 0;
        item.itemId = 3;
        [findMessageArray addObject:item];
        [item release];
    }
    
    {
        FindItemModel* item = [[FindItemModel alloc] init];
        item.itemName = @"星龙战记";
        item.itemTitle = @"【星龙战记】文/幻云子";
        item.itemDate = @"2014-05-17";
        item.itemType = 2;
        item.itemDescription = @"五千年足以使一个文明从萌芽到灭亡，但是五千年对于“乱流星河”来说不过是须臾。大劫的来临何时出现？若修这个时候更加想念老黑龙了，想念银河那两条绚烂的旋臂，想念宇宙源海的壮阔和波澜。";
        item.itemIconURL = @"http://www.x.cn//discovery/mv/xlwar/icon.png";
        item.itemPicURL = @"http://www.x.cn//discovery/mv/xlwar/xlwar1.jpg";
        item.itemTagDic = @{@"0000001":@"发生了发达",@"00000002":@"大幅广",@"00000003":@"放大舒服"};
        
        item.itemTagsArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        FindTagModel *tagModel1 = [[FindTagModel alloc] init];
        tagModel1.tagId = @"0000001222";
        tagModel1.tagName = @"reqiruq热哇";
        [item.itemTagsArray addObject:tagModel1];
        [tagModel1 release];
        
        FindTagModel *tagModel2 = [[FindTagModel alloc] init];
        tagModel2.tagId = @"00000002555";
        tagModel2.tagName = @"肉球热情热舞ee";
        [item.itemTagsArray addObject:tagModel2];
        [tagModel2 release];
        
        FindTagModel *tagModel3 = [[FindTagModel alloc] init];
        tagModel3.tagId = @"00000003444";
        tagModel3.tagName = @"热舞潜入 u 认为 i";
        [item.itemTagsArray addObject:tagModel3];
        [tagModel3 release];
        
        FindTagModel *tagModel4 = [[FindTagModel alloc] init];
        tagModel4.tagId = @"000034520";
        tagModel4.tagName = @"咖啡大师";
        [item.itemTagsArray addObject:tagModel4];
        [tagModel4 release];
        
        item.itemHasHot = 0;
        item.itemHotCount = 0;
        item.itemCommentCount = 0;
        item.itemId = 4;
        item.itemHasCollect = 0;
        [findMessageArray addObject:item];
        [item release];
    }
    
    {
        FindItemModel* item = [[FindItemModel alloc] init];
        item.itemName = @"商业推销";
        item.itemTitle = @"商业资讯";
        item.itemDate = @"2014-06-18";
        item.itemType = 2;
        item.itemDescription = @"他补充称，空间基础设施既是未来空间活动的关键，也是为地面生活探索更好未来的关键。目前，技术和市场都更倾向于选择小型卫星。";
        item.itemIconURL = @"http://www.x.cn//discovery/mv/xlwar/icon.png";
        item.itemPicURL = @"http://www.x.cn//discovery/mv/xlwar/xlwar1.jpg";
        item.itemTagDic = @{@"0000001":@"发生了发达",@"00000002":@"大幅广",@"00000003":@"放大舒服"};
        
        item.itemTagsArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        FindTagModel *tagModel1 = [[FindTagModel alloc] init];
        tagModel1.tagId = @"0000001222";
        tagModel1.tagName = @"reqiruq热哇";
        [item.itemTagsArray addObject:tagModel1];
        [tagModel1 release];
        
        FindTagModel *tagModel2 = [[FindTagModel alloc] init];
        tagModel2.tagId = @"00000002555";
        tagModel2.tagName = @"肉球热情热舞ee";
        [item.itemTagsArray addObject:tagModel2];
        [tagModel2 release];
        
        FindTagModel *tagModel3 = [[FindTagModel alloc] init];
        tagModel3.tagId = @"00000003444";
        tagModel3.tagName = @"热舞潜入 u 认为 i";
        [item.itemTagsArray addObject:tagModel3];
        [tagModel3 release];
        
        FindTagModel *tagModel4 = [[FindTagModel alloc] init];
        tagModel4.tagId = @"000034520";
        tagModel4.tagName = @"咖啡大师";
        [item.itemTagsArray addObject:tagModel4];
        [tagModel4 release];
        
        item.itemHasHot = 0;
        item.itemHotCount = 0;
        item.itemCommentCount = 0;
        item.itemId = 5;
        item.itemHasCollect = 0;
        [findMessageArray addObject:item];
        [item release];
    }

    {
        FindItemModel* item = [[FindItemModel alloc] init];
        item.itemName = @"商业推销";
        item.itemTitle = @"商业资讯";
        item.itemDate = @"2014-06-18";
        item.itemType = 2;
        item.itemDescription = @"他补充称，空间基础设施既是未来空间活动的关键，也是为地面生活探索更好未来的关键。目前，技术和市场都更倾向于选择小型卫星。";
        item.itemIconURL = @"http://www.x.cn//discovery/mv/xlwar/icon.png";
        item.itemPicURL = @"http://img2.cache.netease.com/stock/2015/4/29/201504290815442d083_550.jpg";
        item.itemTagDic = @{@"0000001":@"发生了发达",@"00000002":@"大幅广",@"00000003":@"放大舒服"};
        
        item.itemTagsArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        FindTagModel *tagModel1 = [[FindTagModel alloc] init];
        tagModel1.tagId = @"0000001222";
        tagModel1.tagName = @"reqiruq热哇";
        [item.itemTagsArray addObject:tagModel1];
        [tagModel1 release];
        
        FindTagModel *tagModel2 = [[FindTagModel alloc] init];
        tagModel2.tagId = @"00000002555";
        tagModel2.tagName = @"肉球热情热舞ee";
        [item.itemTagsArray addObject:tagModel2];
        [tagModel2 release];
        
        FindTagModel *tagModel3 = [[FindTagModel alloc] init];
        tagModel3.tagId = @"00000003444";
        tagModel3.tagName = @"热舞潜入 u 认为 i";
        [item.itemTagsArray addObject:tagModel3];
        [tagModel3 release];
        
        FindTagModel *tagModel4 = [[FindTagModel alloc] init];
        tagModel4.tagId = @"000034520";
        tagModel4.tagName = @"咖啡大师";
        [item.itemTagsArray addObject:tagModel4];
        [tagModel4 release];
        
        item.itemHasHot = 0;
        item.itemHotCount = 0;
        item.itemCommentCount = 0;
        item.itemId = 6;
        item.itemHasCollect = 0;
        [findMessageArray addObject:item];
        [item release];
    }

    {
        FindItemModel* item = [[FindItemModel alloc] init];
        item.itemName = @"乐视概念车何时落地";
        item.itemTitle = @"乐视概念车何时落地";
        item.itemDate = @"2014-06-18";
        item.itemType = 2;
        item.itemDescription = @"汽车行业正处于变革时期，新能源+、互联网+当仁不让地成为本届上海车展的风向标，这一背景下，上海车展亮相的北汽乐视概念车备受关注。然而，乐视蓝图中的超级汽车何时落地仍未确定。";
        item.itemIconURL = @"http://www.x.cn//discovery/mv/xlwar/icon.png";
        item.itemPicURL = @"http://img1.cache.netease.com/stock/2015/4/29/201504290804288f6c0_550.jpg";
        item.itemTagDic = @{@"0000001":@"发生了发达",@"00000002":@"大幅广",@"00000003":@"放大舒服"};
        
        item.itemTagsArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
        FindTagModel *tagModel1 = [[FindTagModel alloc] init];
        tagModel1.tagId = @"0000001222";
        tagModel1.tagName = @"reqiruq热哇";
        [item.itemTagsArray addObject:tagModel1];
        [tagModel1 release];
        
        FindTagModel *tagModel2 = [[FindTagModel alloc] init];
        tagModel2.tagId = @"00000002555";
        tagModel2.tagName = @"肉球热情热舞ee";
        [item.itemTagsArray addObject:tagModel2];
        [tagModel2 release];
        
        FindTagModel *tagModel3 = [[FindTagModel alloc] init];
        tagModel3.tagId = @"00000003444";
        tagModel3.tagName = @"热舞潜入 u 认为 i";
        [item.itemTagsArray addObject:tagModel3];
        [tagModel3 release];
        
        FindTagModel *tagModel4 = [[FindTagModel alloc] init];
        tagModel4.tagId = @"000034520";
        tagModel4.tagName = @"咖啡大师";
        [item.itemTagsArray addObject:tagModel4];
        [tagModel4 release];
        
        item.itemHasHot = 0;
        item.itemHotCount = 0;
        item.itemCommentCount = 0;
        item.itemId = 7;
        item.itemHasCollect = 0;
        [findMessageArray addObject:item];
        [item release];
    }

    return findMessageArray;
}

#pragma mark tools
- (NSMutableArray *)bulidTagModel:(NSDictionary *)tagDict {
    NSMutableArray *tagsArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    NSEnumerator *enumer = [tagDict keyEnumerator];
    NSString *key = nil;
    while (key = [enumer nextObject]) {
        FindTagModel *tag = [[FindTagModel alloc] init];
        tag.tagId = key;
        tag.tagName = [tagDict objectForKey:key];
        [tagsArray addObject:tag];
        [tag release];
    }
    return tagsArray;
}

- (BOOL)optimizeFindItem:(FindItemModel *)item {
    if (item == nil) {
        return NO;
    }
    item.itemName = [CommonUtils objectIsValid:item.itemName] ? item.itemName : @"";
    item.itemTitle = [CommonUtils objectIsValid:item.itemTitle] ? item.itemTitle : @"";
    item.itemDate = [CommonUtils objectIsValid:item.itemDate] ? item.itemDate : @"";
    item.itemIconURL = [CommonUtils objectIsValid:item.itemIconURL] ? item.itemIconURL : @"";
    item.itemPicURL = [CommonUtils objectIsValid:item.itemPicURL] ? item.itemPicURL : @"";
    item.itemDescription = [CommonUtils objectIsValid:item.itemDescription] ? item.itemDescription : @"";
    item.itemTargetUrl = [CommonUtils objectIsValid:item.itemTargetUrl] ? item.itemTargetUrl : @"";
    return YES;
}

- (NSDictionary *)unarchiveItemParameters:(NSString *)jsonStr {
    NSDictionary *parameters = nil;
    @try {
        if ([CommonUtils objectIsValid:jsonStr]) {
            SBJSON *parser = [[[SBJSON alloc] init] autorelease];
            parameters = [parser objectWithString:jsonStr];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"find center::unarchiveItemParameters::exception===%@",exception.description);
    }
    return parameters;
}

- (NSString *)archiveItemParameters:(NSDictionary *)params {
    NSString *objectStr = @"";
    @try {
        if ([CommonUtils objectIsValid:params]) {
            SBJSON *parser = [[[SBJSON alloc] init] autorelease];
            objectStr = [parser stringWithObject:params];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"find center::archiveItemParameters::exception===%@",exception.description);
    }
    return objectStr;
}

- (NSString *)getTableNameByFindMode:(FindMode)mode {
    NSString *tableName = nil;
    if (mode == FindModeByDiscovery || mode == FindModeByTag) {
        tableName = FIND_TABLE_NAME;
    } else if (mode == FindModeByCollection) {
        tableName = COLLECTION_TABLE_NAME;
    }
    return tableName;
}

- (void)updateItemCollectStatus:(NSArray *)items {
    if ([CommonUtils objectIsValid:items]) {
        for (FindItemModel *item in items) {
            BOOL haveExist = [self checkItemExistStatus:item findMode:FindModeByCollection];
            if (haveExist) {
                item.itemHasCollect = 1;
            } else {
                item.itemHasCollect = 0;
            }
        }
    }
}


@end
