//
//  FindItemModel.h
//  SJB2
//
//  Created by shengyp on 14-5-19.
//  Copyright (c) 2014年 ailk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FindItemModeType) {
    FindItemModeTypeBrowser,
    FindItemModeTypeDownload,
	FindItemModeTypeWatch,
	FindItemModeTypeListen
};

@interface FindTagModel : NSObject

@property (nonatomic, retain) NSString *tagId;
@property (nonatomic, retain) NSString *tagName;

@end


@interface FindItemModel : NSObject

@property (nonatomic, assign) NSInteger itemId;
@property (nonatomic, assign) NSInteger itemType;
@property (nonatomic, assign) NSInteger itemCatalog;

@property (nonatomic, copy) NSString* itemName;
@property (nonatomic, copy) NSString* itemTitle;
@property (nonatomic, copy) NSString* itemDate;
@property (nonatomic, copy) NSString* itemIconURL;
@property (nonatomic, copy) NSString* itemPicURL;
@property (nonatomic, copy) NSString* itemDescription;
@property (nonatomic, copy) NSString* itemTargetUrl;

@property (nonatomic, assign) NSInteger itemHotCount;
@property (nonatomic, assign) NSInteger itemHasHot;//0:no 1:yes
@property (nonatomic, assign) NSInteger itemCommentCount;
@property (nonatomic, copy) NSDictionary* itemTagDic;

@property (nonatomic, assign) NSInteger itemHasCollect;//0:no 1:yes
@property (nonatomic, retain) UIImage* itemIconImage;
@property (nonatomic, retain) UIImage* itemPicImage;
@property (nonatomic, retain) NSMutableArray *itemTagsArray;

@end


