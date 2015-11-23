//
//  AppTurboBoostCell.h
//  RTSS
//
//  Created by 加富董 on 14-10-29.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ClickOperationType) {
    ClickOperationTypeSelectBandWidth,
    ClickOperationTypeSelectTime,
    ClickOperationTypeReset,
    ClickOperationTypeSubmit,
    ClickOperationTypePurchase
};

@class AppTurboBoostModel;
@class AppTurboBoostCell;

@protocol AppTurboBoostCellDelegate <NSObject>

@optional
- (void)turboBoostCell:(AppTurboBoostCell *)cell indexPath:(NSIndexPath *)cellIndexPath didSelectOperation:(ClickOperationType)operationType withParameters:(NSDictionary *)parameters;

@end


@interface AppTurboBoostCell : UITableViewCell

@property (nonatomic,retain) NSIndexPath *indexPath;

@property (nonatomic,assign) id <AppTurboBoostCellDelegate> delegate;

@property (nonatomic,retain) AppTurboBoostModel *appDataModel;

@property (nonatomic,assign) int64_t speedButtonValue;

@property (nonatomic,assign) int hourButtonValue;

@property (nonatomic,retain) UITableView *belongToTableView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier belongToTableView:(UITableView *)tableView;

- (void)layoutCellHeaderViewWithAppData:(AppTurboBoostModel *)appData indexPath:(NSIndexPath *)cellIndexPath isEditing:(BOOL)isEditing;

- (void)updateControlDisplay;

- (void)resetControlValues;

- (void)flipContentView;

@end
