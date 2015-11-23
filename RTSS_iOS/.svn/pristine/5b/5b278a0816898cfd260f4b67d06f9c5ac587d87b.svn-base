//
//  FindItemCell.h
//  SJB2
//
//  Created by shengyp on 14-5-21.
//  Copyright (c) 2014年 ailk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindItemModel.h"
#import "FindItemView.h"

@class FindItemFrame;

@protocol FindItemCellDelegate;

@interface FindItemCell : UITableViewCell

@property(nonatomic, strong, setter = setFindItemFrame:)FindItemFrame* findItemFrame;

@property(nonatomic, assign)id<FindItemCellDelegate> delegate;
@property(nonatomic, retain) NSIndexPath *cellIndexPath;

- (void)setIconImage:(UIImage*)iconImage;

- (void)setPicImage:(UIImage*)picImage;

- (void)updateActionOptionViewStatusByType:(ActionOptionType)type completion:(void(^)(NSIndexPath *))completion;

@end

@protocol FindItemCellDelegate <NSObject>

@optional
- (void)didSelectRowAtIndexPath:(NSIndexPath*)indexPath;

- (void)didClickedItemTagWithTagModel:(FindTagModel *)tag indexPath:(NSIndexPath *)indexPath;

- (void)didClickedItemActionWithType:(ActionOptionType)type indexPath:(NSIndexPath *)indexPath;

@end
