//
//  FindItemModel.m
//  SJB2
//
//  Created by shengyp on 14-5-19.
//  Copyright (c) 2014年 ailk. All rights reserved.
//

#import "FindItemModel.h"

@implementation FindTagModel

@synthesize tagId,tagName;

#pragma mark dealloc
- (void)dealloc {
    self.tagName = nil;
    self.tagId = nil;
    
    [super dealloc];
}

@end


@implementation FindItemModel

@synthesize itemId,itemType,itemCatalog,itemName,itemTitle,itemDate,itemIconURL,itemPicURL,itemDescription,itemTargetUrl;
@synthesize itemHotCount,itemHasHot,itemCommentCount,itemTagDic;
@synthesize itemIconImage,itemPicImage,itemHasCollect;
@synthesize itemTagsArray;

- (void)dealloc
{
	[itemName release];
	[itemTitle release];
	[itemDate release];
	[itemIconURL release];
	[itemPicURL release];
	[itemDescription release];
	[itemTargetUrl release];
	[itemTagDic release];
	
	[itemIconImage release];
	[itemPicImage release];
    [itemTagsArray release];
	
    [super dealloc];
}

@end
