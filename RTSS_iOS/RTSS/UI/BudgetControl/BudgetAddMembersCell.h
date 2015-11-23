//
//  BudgetAddMembersCell.h
//  RTSS
//
//  Created by 加富董 on 15/2/2.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PortraitImageView;

@interface BudgetAddMembersCell : UITableViewCell

@property (nonatomic, retain)PortraitImageView *iconImageView;
@property (nonatomic, retain)UILabel *methodTextLable;
@property (nonatomic, retain)UIImageView *arrowImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier availableSize:(CGSize)size;

@end
