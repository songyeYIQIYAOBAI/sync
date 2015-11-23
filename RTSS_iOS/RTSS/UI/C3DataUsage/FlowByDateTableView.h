//
//  FlowByDateTableView.h
//  EasyTT
//
//  Created by sheng yinpeng on 13-6-3.
//  Copyright (c) 2013年 lvming. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FlowByDateTableViewDelegate;
@interface FlowByDateTableView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* myTableView;
    NSMutableArray* rowArray;
    NSInteger selectedRow;
    
    id<FlowByDateTableViewDelegate> delegate;
}

@property(nonatomic,retain)UITableView* myTableView;
@property(nonatomic,retain)NSMutableArray* rowArray;
@property(nonatomic,assign)id<FlowByDateTableViewDelegate> delegate;
@property(nonatomic,retain)NSNumber* totalAppFlow;
@property(nonatomic,assign)NSInteger rowType;//0显示右箭头(默认),1不显示右箭头

- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame row:(NSMutableArray*)rows;
- (void)reloadTableViewRow:(NSMutableArray*)rows;

@end

@protocol FlowByDateTableViewDelegate <NSObject>
@required
- (void)flowByDateTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end