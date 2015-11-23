//
//  DNDTableView.h
//  RTSS
//
//  Created by 宋野 on 15-1-30.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DNDSubModel;
@interface DNDTableViewCellSubViewCell : UITableViewCell
@property (nonatomic ,retain)NSString * title;
@property (nonatomic ,retain)UIButton * button;
@property (nonatomic ,assign)BOOL showSelected;
+ (CGFloat)cellHeight:(DNDSubModel *)model;
@end


@class DNDModel;
@interface DNDTableViewCell : UITableViewCell
/*
 这两个参数必须设置
 */
@property (nonatomic ,assign)BOOL isExpandable;
@property (nonatomic ,assign)BOOL isExpand;

// 下面是自定义的属性
@property (nonatomic ,retain)NSString * title;
@property (nonatomic ,readonly)UIButton * expandButton;
+ (CGFloat)cellHeight:(DNDModel *)model;
@end

//
@protocol DNDTableViewDelegate <UITableViewDataSource,UITableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath;
- (DNDTableViewCellSubViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)tableView:(UITableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (void)expandButtonClicked:(id)sender event:(id)event;

- (void)tableView:(UITableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface DNDTableView : UITableView
@property (nonatomic ,assign)id<DNDTableViewDelegate>DNDTableViewDelegate;
//cell indexPath转换成 subCell IndexPath
- (NSIndexPath *)correspondingIndexPathForSubRowAtIndexPath:(NSIndexPath *)indexPath;
@end

//
@interface NSIndexPath (DNDTableView)
@property (nonatomic ,assign)NSInteger subRow;

+ (NSIndexPath *)indexPathForSubRow:(NSInteger)subrow inRow:(NSInteger)row inSection:(NSInteger)section;
@end

//
@interface DNDModel : NSObject
@property (nonatomic ,retain)NSString * title;
@property (nonatomic ,retain)NSArray * subModes;
@end

//
@interface DNDSubModel : NSObject
@property (nonatomic ,retain)NSString * title;
@property (nonatomic ,assign)BOOL selected;

@end
