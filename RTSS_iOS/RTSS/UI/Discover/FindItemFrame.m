//
//  FindItemFrame.m
//  SJB2
//
//  Created by shengyp on 14-5-21.
//  Copyright (c) 2014年 ailk. All rights reserved.
//

#import "FindItemFrame.h"
#import "FindItemModel.h"
#import "FindItemView.h"
#import "RTSSAppDefine.h"
#import "CommonUtils.h"

static const CGFloat FindItemTopMargin				= 7.0;
static const CGFloat FindItemBottomMargin			= 7.0;
static const CGFloat FindItemLeftMargin				= 7.0;
static const CGFloat FindItemRightMargin			= 7.0;

static const CGFloat FindItemNameLeftMargin			= 5.0;
static const CGFloat FindItemPicTopMargin			= 5.0;
static const CGFloat FindItemTitleLeftMargin		= 2.0;
static const CGFloat FindItemTitleRightMargin		= 2.0;
static const CGFloat FindItemTitleTopMargin			= 5.0;
static const CGFloat FindItemDescTopMargin			= 2.0;
static const CGFloat FindItemDescLeftMargin			= 2.0;
static const CGFloat FindItemDescRightMargin		= 2.0;

static const CGFloat FindItemTagMarkTopMargin       = 10.0;
static const CGFloat FindItemTagMarkLeftMargin      = 2.0;
static const CGFloat FindItemTagMarkWidth           = 10.0;
static const CGFloat FindItemTagMarkHeight          = 10.0;

static const CGFloat FindItemTagsViewLeftMargin     = 2.0;
static const CGFloat FindItemTagsViewRightMargin    = 2.0;
static const CGFloat FindItemTagsViewTopMargin      = 5.0;

static const CGFloat FindItemTagPaddingXLeft        = 2.0;
static const CGFloat FindItemTagPaddingXRight       = 2.0;
static const CGFloat FindItemTagPaddingYTop         = 2.0;
static const CGFloat FindItemTagPaddingYBottom      = 2.0;
static const CGFloat FindItemTagSpacingX            = 10.0;
static const CGFloat FindItemTagSpacingY            = 6.0;
static const CGFloat FindItemTagHeight              = 20.0;

static const CGFloat FindItemSepLineTopMargin       = 2.0;
static const CGFloat FindItemSepLineLeftMargin      = 2.0;
static const CGFloat FindItemSepLineRightMargin     = 2.0;
static const CGFloat FindItemSepLineHeight          = 1.0;

static const CGFloat FindItemActionViewTopMargin    = 2.0;
static const CGFloat FindItemActionViewLeftMargin   = 2.0;
static const CGFloat FindItemActionViewRightMargin  = 2.0;
static const CGFloat FindItemActionViewHeight       = 44.0;

static const CGFloat FindItemTypeTopMargin			= 15;
static const CGFloat FindItemTypeRightMargin		= 5.0;

static const CGFloat FindItemIconWidth				= 38.0;
static const CGFloat FindItemIconHeight				= 38.0;

static const CGFloat FindItemNameHeight				= 38.0;

static const CGFloat FindItemDateWidth				= 80.0;
static const CGFloat FindItemDateHeight				= 38.0;

static const CGFloat FindItemPicHeight				= 152.5;

static const CGFloat FindItemTitleHeight			= 25.0;

static const CGFloat FindItemDescHeight				= 20.0;

static const CGFloat FindItemTypeWidth				= 100.0;
static const CGFloat FindItemTypeHeight				= 25.0;

static const CGFloat FindItemCommentLabelHeight     = 10.0;
static const CGFloat FindItemCommentLabelTopMargin  = 10.0;


static const CGFloat FindItemPraiseLabelHeight      = 10.0;
static const CGFloat FindItemPraiseLabelTopMargin   = 10.0;

@implementation FindItemFrame

@synthesize itemTagsFrameArray;

- (void)dealloc
{
	[_itemModel release];
	
    [super dealloc];
}

- (void)setItemWidth:(CGFloat)itemWidth
{
	_itemWidth = itemWidth;
}

- (void)setItemModel:(FindItemModel*)itemModel
{
	_itemModel = [itemModel retain];
	
	// 发现ICON
	_itemIconRect = CGRectMake(FindItemLeftMargin, FindItemTopMargin, FindItemIconWidth, FindItemIconHeight);
	
	// 发现名字
    _itemNameRect = CGRectMake(FindItemLeftMargin + FindItemIconWidth + FindItemNameLeftMargin, FindItemTopMargin, _itemWidth - FindItemLeftMargin - FindItemIconWidth - FindItemNameLeftMargin - FindItemNameLeftMargin - FindItemRightMargin - FindItemDateWidth, FindItemNameHeight);
	
	// 发现日期
	_itemDateRect = CGRectMake(_itemWidth - FindItemRightMargin - FindItemDateWidth, FindItemTopMargin, FindItemDateWidth, FindItemDateHeight);
	
	// 发现图片
	_itemPicRect = CGRectMake(FindItemLeftMargin, FindItemTopMargin + FindItemIconHeight +FindItemPicTopMargin, _itemWidth - FindItemLeftMargin - FindItemRightMargin, FindItemPicHeight);

	// 发现标题
	_itemTitleRect = CGRectMake(FindItemLeftMargin + FindItemTitleLeftMargin, _itemPicRect.origin.y +_itemPicRect.size.height + FindItemTitleTopMargin, _itemWidth - FindItemLeftMargin -FindItemRightMargin - FindItemTitleLeftMargin - FindItemTitleRightMargin, FindItemTitleHeight);
		
	// 发现描述
	CGFloat itemDescWidth = _itemWidth - FindItemLeftMargin - FindItemRightMargin -FindItemDescLeftMargin-FindItemDescRightMargin;
	CGFloat itemDescHeight = FindItemDescHeight;
	NSString* descText = itemModel.itemDescription;
	if(nil != descText && descText.length > 0){
        CGSize descSize = [CommonUtils calculateTextSize:descText constrainedSize:CGSizeMake(itemDescWidth - 16.0, CGFLOAT_MAX) textFont:FindItemDescFont lineBreakMode:NSLineBreakByWordWrapping];
        descSize.height += 16.0;
		if(itemDescHeight < descSize.height){
			itemDescHeight = descSize.height;
		}
	}
	_itemDescRect = CGRectMake(FindItemLeftMargin + FindItemDescLeftMargin, CGRectGetMaxY(_itemTitleRect) + FindItemDescTopMargin, itemDescWidth, itemDescHeight);
	
	_itemTypeRect = CGRectMake(_itemWidth - FindItemRightMargin - FindItemTypeRightMargin -FindItemTypeWidth, CGRectGetMaxY(_itemDescRect) + FindItemTypeTopMargin, FindItemTypeWidth, FindItemTypeHeight);
    if (itemModel && [CommonUtils objectIsValid:itemModel.itemTagsArray] ) {
        // 发现tag icon
        _itemTagImageViewRect = CGRectMake(FindItemLeftMargin + FindItemTagMarkLeftMargin, CGRectGetMaxY(_itemTypeRect) + FindItemTagMarkTopMargin, FindItemTagMarkWidth , FindItemTagMarkHeight);
        
        // 发现所有tag的frame
        itemTagsFrameArray = [[NSMutableArray alloc] initWithCapacity:0];
        CGFloat x = FindItemTagPaddingXLeft;
        CGFloat y = FindItemTagPaddingYTop;
        CGFloat availableWidth = _itemWidth - CGRectGetMaxX(_itemTagImageViewRect) - FindItemTagsViewLeftMargin - FindItemTagsViewRightMargin - FindItemRightMargin;
        for (int i = 0; i < [itemModel.itemTagsArray count]; i ++) {
            FindTagModel *tag = [itemModel.itemTagsArray objectAtIndex:i];
            NSString *tagName = tag.tagName;
            if ([CommonUtils objectIsValid:tagName]) {
                CGRect tagRect = CGRectZero;
                CGSize nameSize = [CommonUtils calculateTextSize:tagName constrainedSize:CGSizeMake(CGFLOAT_MAX, FindItemTagMarkHeight) textFont:[UIFont systemFontOfSize:14.0] lineBreakMode:NSLineBreakByWordWrapping];
                if (x + nameSize.width + FindItemTagPaddingXRight <= availableWidth) {
                    //当前行可以放下该tag
                    tagRect = CGRectMake(x, y, nameSize.width, FindItemTagHeight);
                    //修改x,y值
                    x += (nameSize.width + FindItemTagSpacingX);
                } else {
                    //当前行放不下该tag,需要换行
                    //此时分情况：该行目前是不是只有这个tag，如果该tag是此行的第一个，那么该tag的最大宽度即为改行最大宽度；如果不是第一个，认为该行放不下该tag，此时应该换行
                    if (x == FindItemTagPaddingXLeft) {
                        //强制放在此行
                        tagRect = CGRectMake(x, y, availableWidth - x - FindItemTagPaddingXRight, FindItemTagHeight);
                        //直接跳到下一行，修改x,y值
                        x = FindItemTagPaddingXLeft;
                        y = CGRectGetMaxY(tagRect) + FindItemTagSpacingY;
                    } else {
                        //换到下一行
                        x = FindItemTagPaddingXLeft;
                        y += (FindItemTagHeight + FindItemTagSpacingY);
                        CGFloat w = (nameSize.width > availableWidth - x - FindItemTagPaddingXRight ? availableWidth - x - FindItemTagPaddingXRight : nameSize.width);
                        tagRect = CGRectMake(x, y, w, FindItemTagHeight);
                        //修改x,y值
                        x += (w + FindItemTagSpacingX);
                    }
                }
                NSValue *tagRectVal = [NSValue valueWithCGRect:tagRect];
                [itemTagsFrameArray addObject:tagRectVal];
            }
        }
        //tags view frame
        CGRect lastRect = [(NSValue *)[itemTagsFrameArray lastObject] CGRectValue];
        CGFloat finalHeight = CGRectGetMaxY(lastRect) + FindItemTagPaddingYBottom;
        _itemTagsViewRect = CGRectMake(CGRectGetMaxX(_itemTagImageViewRect) + FindItemTagsViewLeftMargin, CGRectGetMaxY(_itemTypeRect) + FindItemTagsViewTopMargin, availableWidth, finalHeight);
        
    } else {
        //不显示
        _itemTagImageViewRect = CGRectZero;
        _itemTagsViewRect = CGRectZero;
    }
    
    // 发现 sepline
    CGFloat offsetY = CGRectEqualToRect(_itemTagsViewRect, CGRectZero) ? CGRectGetMaxY(_itemTypeRect) : CGRectGetMaxY(_itemTagsViewRect);
    _itemSepLineRect = CGRectMake(FindItemLeftMargin + FindItemSepLineLeftMargin, offsetY + FindItemSepLineTopMargin, _itemWidth - FindItemLeftMargin - FindItemSepLineLeftMargin - FindItemRightMargin - FindItemSepLineRightMargin, FindItemSepLineHeight);
    
    // 发现 action view
    _itemActionsViewRect = CGRectMake(FindItemLeftMargin + FindItemActionViewLeftMargin, CGRectGetMaxY(_itemSepLineRect) + FindItemActionViewTopMargin, _itemWidth - FindItemLeftMargin - FindItemActionViewLeftMargin - FindItemRightMargin - FindItemActionViewRightMargin, FindItemActionViewHeight);
    
    // 发现 comment label
    _itemCommentCountLabelRect = CGRectMake([self getValueLabelOffsetX], FindItemCommentLabelTopMargin, [self getValueLabelWidth], FindItemCommentLabelHeight);
    
    // 发现 praise label
    _itemPraiseCountLabelRect = CGRectMake([self getValueLabelOffsetX], FindItemPraiseLabelTopMargin, [self getValueLabelWidth], FindItemPraiseLabelHeight);
	 
	// 发现ItemCell的高度
    _itemCellHeight = CGRectGetMaxY(_itemActionsViewRect) + FindItemBottomMargin;
}

- (CGFloat)getValueLabelOffsetX {
    CGFloat x = 48.0;
    if (PHONE_UISCREEN_IPHONE6) {
        x = 53.0;
    } else if (PHONE_UISCREEN_IPHONE6PLUS) {
        x = 58.0;
    }
    return x;
}

- (CGFloat)getValueLabelWidth {
    CGFloat w = 22.0;
    if (PHONE_UISCREEN_IPHONE6) {
        w = 30.0;
    } else if (PHONE_UISCREEN_IPHONE6PLUS) {
        w = 36.0;
    }
    return w;
}

@end
