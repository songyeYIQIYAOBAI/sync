//
//  TransactionFootPrintTableViewCell.h
//  RTSS
//
//  Created by 蔡杰 on 14-10-29.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactionFootPrintHeaderView.h"

typedef enum{
    TransactionFootPrintTableViewCellTypeNomal,
    TransactionFootPrintTableViewCellTypeChange,
}TransactionFootPrintTableViewCellType;


@interface TransactionFootPrintTableViewCell : UITableViewCell

-(void)updateDate:(NSString *)date Info:(NSString*)info ImageString:(NSString *)imageString type:(TransactionFootPrintTableViewCellType)tag bgType:(ButtonItemViewType)type;

@end
