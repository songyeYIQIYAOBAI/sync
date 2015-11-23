//
//  FindItemCell.m
//  SJB2
//
//  Created by shengyp on 14-5-21.
//  Copyright (c) 2014年 ailk. All rights reserved.
//

#import "FindItemCell.h"
#import "FindItemView.h"
#import "FindItemFrame.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"

@interface FindItemCell()
{
	FindItemView* _findItemView;
}

@end

@implementation FindItemCell
@synthesize delegate;
@synthesize cellIndexPath;

- (void)dealloc
{
    self.cellIndexPath = nil;
	[_findItemView release];
	
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		self.clipsToBounds = YES;
		self.backgroundColor = [UIColor clearColor];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		_findItemView = [[FindItemView alloc] initWithFrame:CGRectZero];
		[self.contentView addSubview:_findItemView];
    }
    return self;
}

- (void)setFindItemFrame:(FindItemFrame*)findItemFrame
{
	_findItemFrame = findItemFrame;
	
	FindItemModel* itemModel = _findItemFrame.itemModel;
	
	//icom
	_findItemView.itemIconImageView.frame = _findItemFrame.itemIconRect;
	[self setIconImage:itemModel.itemIconImage];
	
	//name
	_findItemView.itemNameLabel.frame = _findItemFrame.itemNameRect;
	_findItemView.itemNameLabel.text = itemModel.itemName;
	
	//date
	_findItemView.itemDateLabel.frame = _findItemFrame.itemDateRect;
	_findItemView.itemDateLabel.text = itemModel.itemDate;
	
	//pic
	_findItemView.itemPicImageView.frame = _findItemFrame.itemPicRect;
	[self setPicImage:itemModel.itemPicImage];
	
	//title
	_findItemView.itemTitleLabel.frame = _findItemFrame.itemTitleRect;
	_findItemView.itemTitleLabel.text = itemModel.itemTitle;
	
	//des
	_findItemView.itemDescriptionTextView.frame = _findItemFrame.itemDescRect;
	_findItemView.itemDescriptionTextView.text = itemModel.itemDescription;
    
	//type button
	_findItemView.itemTypeButton.frame = _findItemFrame.itemTypeRect;
	[self setType:itemModel.itemType];
    
    //tag mark
    _findItemView.itemTagImageView.frame = _findItemFrame.itemTagImageViewRect;
    _findItemView.itemTagImageView.image = [UIImage imageNamed:@"discover_item_tag.png"];
    
    //tag views
    _findItemView.itemTagsView.frame = _findItemFrame.itemTagsViewRect;
    [_findItemView.itemTagsView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self layoutTagsView];
    
    //sep line
    _findItemView.itemSepLineImageView.frame = _findItemFrame.itemSepLineRect;
    _findItemView.itemSepLineImageView.backgroundColor = [[RTSSAppStyle currentAppStyle] textSubordinateColor];
    
    //action view
    _findItemView.itemActionsPanelView.frame = _findItemFrame.itemActionsViewRect;
    [self layoutActionsPanelView];
    
	//
	_findItemView.frame = CGRectMake(10, 10, _findItemFrame.itemWidth, _findItemFrame.itemCellHeight);
}

- (void)layoutActionsPanelView {
    CGFloat optionWidth = CGRectGetWidth(_findItemFrame.itemActionsViewRect) * 1.0 / 4;
    CGFloat optionHeight = CGRectGetHeight(_findItemFrame.itemActionsViewRect);
    
    //comment
    CGRect commentRect = CGRectMake(0.0, 0.0, optionWidth, optionHeight);
    _findItemView.itemActionsPanelView.commentView.frame = commentRect;
    _findItemView.itemActionsPanelView.commentView.valueLabel.frame = _findItemFrame.itemCommentCountLabelRect;
    _findItemView.itemActionsPanelView.commentView.actionButton.frame = CGRectMake(0.0, 0.0, optionWidth, optionHeight);
    [_findItemView.itemActionsPanelView.commentView.actionButton setImage:[UIImage imageNamed:@"discover_item_comment_d.png"] forState:UIControlStateNormal];
    [_findItemView.itemActionsPanelView.commentView.actionButton setImage:[UIImage imageNamed:@"discover_item_comment_a.png"] forState:UIControlStateHighlighted];
    [_findItemView.itemActionsPanelView.commentView.actionButton addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self setValueByType:ActionOptionTypeComment];
    
//    _findItemView.itemActionsPanelView.commentView.backgroundColor = [UIColor redColor];
//    _findItemView.itemActionsPanelView.commentView.valueLabel.backgroundColor = [UIColor greenColor];
    
    //share
    CGRect shareRect = CGRectMake(optionWidth * 1.0, 0.0, optionWidth, optionHeight);
    _findItemView.itemActionsPanelView.shareView.frame = shareRect;
    _findItemView.itemActionsPanelView.shareView.actionButton.frame = CGRectMake(0.0, 0.0, optionWidth, optionHeight);
    [_findItemView.itemActionsPanelView.shareView.actionButton setImage:[UIImage imageNamed:@"discover_item_share_d.png"] forState:UIControlStateNormal];
    [_findItemView.itemActionsPanelView.shareView.actionButton setImage:[UIImage imageNamed:@"discover_item_share_a.png"] forState:UIControlStateHighlighted];
    [_findItemView.itemActionsPanelView.shareView.actionButton addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //praise
    CGRect praiseRect = CGRectMake(optionWidth * 2.0, 0.0, optionWidth, optionHeight);
    _findItemView.itemActionsPanelView.praiseView.frame = praiseRect;
    _findItemView.itemActionsPanelView.praiseView.valueLabel.frame = _findItemFrame.itemPraiseCountLabelRect;
    _findItemView.itemActionsPanelView.praiseView.actionButton.frame = CGRectMake(0.0, 0.0, optionWidth, optionHeight);
    [_findItemView.itemActionsPanelView.praiseView.actionButton setImage:[UIImage imageNamed:@"discover_item_praise_d.png"] forState:UIControlStateNormal];
    [_findItemView.itemActionsPanelView.praiseView.actionButton setImage:[UIImage imageNamed:@"discover_item_praise_a.png"] forState:UIControlStateHighlighted];
    [_findItemView.itemActionsPanelView.praiseView.actionButton setImage:[UIImage imageNamed:@"discover_item_praise_a.png"] forState:UIControlStateSelected];
    [_findItemView.itemActionsPanelView.praiseView.actionButton addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self setValueByType:ActionOptionTypePraise];
    [self setSelectedStatusByType:ActionOptionTypePraise animate:NO];
    
//    _findItemView.itemActionsPanelView.praiseView.backgroundColor = [UIColor redColor];
//    _findItemView.itemActionsPanelView.praiseView.valueLabel.backgroundColor = [UIColor greenColor];
    
    //collect
    CGRect collectRect = CGRectMake(optionWidth * 3.0, 0.0, optionWidth, optionHeight);
    _findItemView.itemActionsPanelView.collectView.frame = collectRect;
    _findItemView.itemActionsPanelView.collectView.actionButton.frame = CGRectMake(0.0, 0.0, optionWidth, optionHeight);
    [_findItemView.itemActionsPanelView.collectView.actionButton setImage:[UIImage imageNamed:@"discover_item_collect_d.png"] forState:UIControlStateNormal];
    [_findItemView.itemActionsPanelView.collectView.actionButton setImage:[UIImage imageNamed:@"discover_item_collect_a.png"] forState:UIControlStateHighlighted];
    [_findItemView.itemActionsPanelView.collectView.actionButton setImage:[UIImage imageNamed:@"discover_item_collect_a.png"] forState:UIControlStateSelected];
    [_findItemView.itemActionsPanelView.collectView.actionButton addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self setSelectedStatusByType:ActionOptionTypeCollect animate:NO];
}

- (void)layoutTagsView {
    @try {
        NSArray *tagsArray = _findItemFrame.itemModel.itemTagsArray;
        NSArray *framesArray = _findItemFrame.itemTagsFrameArray;
        if ([CommonUtils objectIsValid:tagsArray] && [CommonUtils objectIsValid:framesArray]) {
            for (int i = 0; i < [framesArray count]; i ++) {
                FindTagModel *tagModel = [tagsArray objectAtIndex:i];
                NSString *title = tagModel.tagName;
                NSString *tagId = tagModel.tagId;
                NSValue *frame = [framesArray objectAtIndex:i];
                if (frame && [CommonUtils objectIsValid:title]) {
                    //temp
                    CGRect tagFrame = [frame CGRectValue];
                    TagButton *tag = [TagButton buttonWithType:UIButtonTypeCustom];
                    tag.frame = tagFrame;
                    tag.backgroundColor = [UIColor clearColor];
                    tag.tagModel = tagModel;
                    [tag setTitle:title forState:UIControlStateNormal];
                    tag.titleLabel.font = [UIFont systemFontOfSize:14.0];
                    [tag setTitleColor:[RTSSAppStyle currentAppStyle].textSubordinateColor forState:UIControlStateNormal];
                    [tag setTitleColor:[[RTSSAppStyle currentAppStyle] textMajorColor] forState:UIControlStateHighlighted];
                    [tag addTarget:self action:@selector(itemTagClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [_findItemView.itemTagsView addSubview:tag];
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"find item cell::layoutTagsView exception::%@",exception);
    }
}

- (void)setIconImage:(UIImage*)iconImage
{
	if(nil != iconImage && iconImage.size.width > 0){
		_findItemView.itemIconImageView.image = iconImage;
	}else{
		_findItemView.itemIconImageView.image = [UIImage imageNamed:@"discover_item_icon.png"];
	}
}

- (void)setPicImage:(UIImage*)picImage
{
	if(nil != picImage && picImage.size.width > 0){
		_findItemView.itemPicImageView.image = picImage;
	}else{
		_findItemView.itemPicImageView.image = [UIImage imageNamed:@"discover_item_pic.png"];
	}
}

- (void)setType:(FindItemModeType)type
{
	switch (type) {
		case FindItemModeTypeBrowser:{
			
			[_findItemView.itemTypeButton setTitle:NSLocalizedString(@"Find_Item_Title_By_Type_Browse", nil) forState:UIControlStateNormal];
			[_findItemView.itemTypeButton setTitle:NSLocalizedString(@"Find_Item_Title_By_Type_Browse", nil) forState:UIControlStateHighlighted];
			
			break;
		}
		case FindItemModeTypeDownload:{
			
			[_findItemView.itemTypeButton setTitle:NSLocalizedString(@"Find_Item_Title_By_Type_Download", nil) forState:UIControlStateNormal];
			[_findItemView.itemTypeButton setTitle:NSLocalizedString(@"Find_Item_Title_By_Type_Download", nil) forState:UIControlStateHighlighted];
			
			break;
		}
		case FindItemModeTypeWatch:{

			[_findItemView.itemTypeButton setTitle:NSLocalizedString(@"Find_Item_Title_By_Type_Watch", nil) forState:UIControlStateNormal];
			[_findItemView.itemTypeButton setTitle:NSLocalizedString(@"Find_Item_Title_By_Type_Watch", nil) forState:UIControlStateHighlighted];
			
			break;
		}
		case FindItemModeTypeListen:{
			
			[_findItemView.itemTypeButton setTitle:NSLocalizedString(@"Find_Item_Title_By_Type_Listen", nil) forState:UIControlStateNormal];
			[_findItemView.itemTypeButton setTitle:NSLocalizedString(@"Find_Item_Title_By_Type_Listen", nil) forState:UIControlStateHighlighted];
			
			break;
		}
		default:
			break;
	}
	
	[_findItemView.itemTypeButton setTag:type];
	
	UIImage* normalImage = [UIImage imageNamed:@"discover_item_arrow_a.png"];
	UIImage* lightedImage = [UIImage imageNamed:@"discover_item_arrow_d.png"];
	
	[_findItemView.itemTypeButton setImage:normalImage forState:UIControlStateNormal];
	[_findItemView.itemTypeButton setImage:lightedImage forState:UIControlStateHighlighted];
	
	[_findItemView.itemTypeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
	[_findItemView.itemTypeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 55, 0, 0)];
	[_findItemView.itemTypeButton addTarget:self action:@selector(actionButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setValueByType:(ActionOptionType)type {
    switch (type) {
        case ActionOptionTypeComment:
        {
            if (_findItemFrame.itemModel.itemCommentCount > 0) {
                _findItemView.itemActionsPanelView.commentView.value = [NSString stringWithFormat:@"%d",_findItemFrame.itemModel.itemCommentCount];
            } else {
                _findItemView.itemActionsPanelView.commentView.value = nil;
            }
        }
            break;
        case ActionOptionTypePraise:
        {
            if (_findItemFrame.itemModel.itemHotCount > 0) {
                _findItemView.itemActionsPanelView.praiseView.value = [NSString stringWithFormat:@"%d",_findItemFrame.itemModel.itemHotCount];
            } else {
                _findItemView.itemActionsPanelView.praiseView.value = nil;
                
            }
        }
            break;
        default:
            break;
    }
}

- (void)setSelectedStatusByType:(ActionOptionType)type animate:(BOOL)animate completion:(void (^)(NSIndexPath *))callBack {
    switch (type) {
        case ActionOptionTypePraise:
        {
            NSInteger hasHot = _findItemFrame.itemModel.itemHasHot;
            if (hasHot > 0) {
                _findItemView.itemActionsPanelView.praiseView.actionButton.selected = YES;
            } else {
                _findItemView.itemActionsPanelView.praiseView.actionButton.selected = NO;
            }
            if (animate) {
                NSString *tempImageName = hasHot > 0 ? @"discover_item_praise_d.png" : @"discover_item_praise_a.png";
                CGRect orginalRect = _findItemView.itemActionsPanelView.praiseView.actionButton.frame;
                UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:orginalRect];
                tempImageView.image = [UIImage imageNamed:tempImageName];
                tempImageView.contentMode = UIViewContentModeCenter;
                [_findItemView.itemActionsPanelView.praiseView addSubview:tempImageView];
                [tempImageView release];
                _findItemView.itemActionsPanelView.praiseView.actionButton.enabled = NO;
                
                [UIView animateWithDuration:0.5 animations:^ {
                    tempImageView.transform = CGAffineTransformScale(tempImageView.transform, 0.5, 0.5);
                    tempImageView.transform = CGAffineTransformTranslate(tempImageView.transform, 0.0, - 2.5 * CGRectGetHeight(tempImageView.frame));
                } completion:^ (BOOL finished) {
                    [tempImageView removeFromSuperview];
                    _findItemView.itemActionsPanelView.praiseView.actionButton.enabled = YES;
                    if (callBack) {
                        callBack(cellIndexPath);
                    }
                }];
            } else {
                if (callBack) {
                    callBack(cellIndexPath);
                }
            }
        }
            break;
        case ActionOptionTypeCollect:
        {
            NSInteger hasCollect = _findItemFrame.itemModel.itemHasCollect;
            if (hasCollect > 0) {
                _findItemView.itemActionsPanelView.collectView.actionButton.selected = YES;
            } else {
                _findItemView.itemActionsPanelView.collectView.actionButton.selected = NO;
            }
            if (animate) {
                NSString *tempImageName = hasCollect > 0 ? @"discover_item_collect_d.png" : @"discover_item_collect_a.png";
                CGRect orginalRect = _findItemView.itemActionsPanelView.collectView.actionButton.frame;
                UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:orginalRect];
                tempImageView.image = [UIImage imageNamed:tempImageName];
                tempImageView.contentMode = UIViewContentModeCenter;
                [_findItemView.itemActionsPanelView.collectView addSubview:tempImageView];
                [tempImageView release];
                _findItemView.itemActionsPanelView.collectView.actionButton.enabled = NO;
                
                [UIView animateWithDuration:0.5 animations:^ {
                    tempImageView.transform = CGAffineTransformScale(tempImageView.transform, 0.5, 0.5);
                    tempImageView.transform = CGAffineTransformTranslate(tempImageView.transform, 0.0, - 2.5 * CGRectGetHeight(tempImageView.frame));
                } completion:^ (BOOL finished) {
                    [tempImageView removeFromSuperview];
                    _findItemView.itemActionsPanelView.collectView.actionButton.enabled = YES;
                    if (callBack) {
                        callBack(cellIndexPath);
                    }
                }];
            } else {
                if (callBack) {
                    callBack(cellIndexPath);
                }
            }
        }
            break;
        default:
            break;
    }
}

- (void)setSelectedStatusByType:(ActionOptionType)type animate:(BOOL)animate {
    [self setSelectedStatusByType:type animate:animate completion:nil];
}

#pragma mark update action option status
- (void)updateActionOptionViewStatusByType:(ActionOptionType)type completion:(void(^)(NSIndexPath *))completion {
    switch (type) {
        case ActionOptionTypeComment:
        {
            [self setValueByType:ActionOptionTypeComment];
        }
            break;
        case ActionOptionTypeShare:
        {
        
        }
            break;
        case ActionOptionTypePraise:
        {
            
            [self setValueByType:ActionOptionTypePraise];
            [self setSelectedStatusByType:ActionOptionTypePraise animate:YES completion:completion];
            
        }
            break;
        case ActionOptionTypeCollect:
        {
            [self setSelectedStatusByType:ActionOptionTypeCollect animate:YES completion:completion];
        }
            break;
        default:
            break;
    }
}

#pragma mark button clicked method
- (void)actionButton:(UIButton*)button
{
    if(nil != delegate && [delegate respondsToSelector:@selector(didSelectRowAtIndexPath:)]){
        [delegate didSelectRowAtIndexPath:cellIndexPath];
    }
}

- (void)itemTagClicked:(TagButton *)tagButton {
    FindTagModel *tagModel = tagButton.tagModel;
    NSLog(@"item tag clicked::tagId==%@,tagName==%@",tagModel.tagId,tagModel.tagName);
    if (delegate && [delegate respondsToSelector:@selector(didClickedItemTagWithTagModel:indexPath:)]) {
        [delegate didClickedItemTagWithTagModel:tagModel indexPath:cellIndexPath];
    }
}

- (void)actionButtonClicked:(UIButton *)btn {
    NSLog(@"action button clicked");
    ActionOptionType type = btn.tag;
    if (delegate && [delegate respondsToSelector:@selector(didClickedItemActionWithType:indexPath:)]) {
        [delegate didClickedItemActionWithType:type indexPath:cellIndexPath];
    }
}

@end
