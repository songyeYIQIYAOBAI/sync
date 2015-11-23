//
//  FlowByAppTableView.h
//  EasyTT
//
//  Created by sheng yinpeng on 13-6-3.
//  Copyright (c) 2013年 lvming. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FlowByAppTableViewDelegate;
@interface FlowByAppTableView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* myTableView;
    NSMutableArray* rowArray;
    NSInteger selectedRow;
    
    id<FlowByAppTableViewDelegate> delegate;
}

@property(nonatomic,retain)UITableView* myTableView;
@property(nonatomic,retain)NSMutableArray* rowArray;
@property(nonatomic,assign)id<FlowByAppTableViewDelegate> delegate;
@property(nonatomic,retain)NSNumber* totalAppFlow;
@property(nonatomic,assign)NSInteger rowType;//0显示右箭头(默认),1不显示右箭头

- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame row:(NSMutableArray*)rows;
- (void)reloadTableViewRow:(NSMutableArray*)rows;

@end

@protocol FlowByAppTableViewDelegate <NSObject>
@required
- (void)flowByAppTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end