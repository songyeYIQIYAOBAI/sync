//
//  ExpandDetailTableViewCell.h
//  RTSS
//
//  Created by 蔡杰Alan on 14-11-14.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ExpandBaseTableViewCell.h"

@interface ExpandDetailTableViewCell : ExpandBaseTableViewCell

-(void)setTitle:(NSString*)aTitle DetailInfo:(NSString*)aInfo;

-(void)setTitle:(NSString*)aTitle;

-(void)addGradualBar;

-(void)removeGradualBar;

@end
