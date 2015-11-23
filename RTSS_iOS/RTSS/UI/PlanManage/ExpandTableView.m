//
//  ExpandTableView.m
//  RTSS
//
//  Created by 蔡杰Alan on 14-11-14.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "ExpandTableView.h"

#import "ExpandTitleTableViewCell.h"
#import "ExpandDetailTableViewCell.h"

#import "RTSSAppStyle.h"

#define kRTSSCellHeight 44.0f

@interface ExpandTableView ()<UITableViewDataSource,UITableViewDelegate>

@property (assign)BOOL isOpen;

@property (nonatomic,retain)NSIndexPath *selectIndex;

@end

@implementation ExpandTableView

@synthesize isOpen,selectIndex;

@synthesize dataSourceList;
-(void)dealloc{
    [dataSourceList release];
    [self.selectIndex release];
    [super dealloc];
}


-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        
        [self setup];
        
    }
    return self;

}
//配置属性
-(void)setup{
    
    self.dataSource = self;
    self.delegate = self;

    self.sectionFooterHeight = 0;
    self.sectionHeaderHeight = 0;
    self.isOpen = NO;
    
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;

}

#pragma mark --UITabelViewDateSource && UItableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    if (self.isOpen) {
        
        if (self.selectIndex.section == section) {
            
            if (section < self.dataSourceList.count) {
                NSInteger count = [(NSArray*)[self.dataSourceList objectAtIndex:section] count];
                return count+1;

            }
            return 1;
            
        }
    }
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kRTSSCellHeight;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isOpen && self.selectIndex.section == indexPath.section && indexPath.row != 0){
        
        static NSString *CellTitleDetailIdentify = @"CellTitleDetailIdentify";
        
        ExpandDetailTableViewCell *expandDetailCell = [tableView dequeueReusableCellWithIdentifier:CellTitleDetailIdentify];
        if (expandDetailCell == nil) {
            expandDetailCell = [[[ExpandDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellTitleDetailIdentify]autorelease];
        }
        [expandDetailCell removeGradualBar];
        if (indexPath.row == 1) {
            //[expandDetailCell addGradualBar];
        }
        if (indexPath.section < [self.dataSourceList count]) {
            
            if (indexPath.row - 1 <[(NSArray*)[self.dataSourceList objectAtIndex:indexPath.section] count]) {
                NSString *str = [(NSArray*)[self.dataSourceList objectAtIndex:indexPath.section]objectAtIndex:indexPath.row-1];
                [expandDetailCell setTitle:str];
            }
            
        }
        
        return expandDetailCell;
        
    }else{
        
        static NSString *CellTitleIdentify = @"CellTitleIdentify";
        ExpandTitleTableViewCell *expandTitleCell =[tableView dequeueReusableCellWithIdentifier:CellTitleIdentify];
        if (expandTitleCell == nil) {
            expandTitleCell =[[[ExpandTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTitleIdentify]autorelease];
        }
        
        switch (indexPath.section) {
            case 0:
            {
                [expandTitleCell setupTitleInfo:NSLocalizedString(@"Plan Circles", nil)];
            }
                break;
            case 1:{
                 [expandTitleCell setupTitleInfo:NSLocalizedString(@"Plan_Detail_Product_Specifications", nil)];
            }
                
            default:
                break;
        }
        
        [expandTitleCell changeArrowWithUp:([self.selectIndex isEqual:indexPath]?YES:NO)];
        return expandTitleCell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {

        if ([indexPath isEqual:self.selectIndex]) {
            //第二次点击
            self.isOpen = NO;
            [self didSelectCellRowFirstDo:NO nextDo:NO];
            self.selectIndex = nil;
            
        }else{
            
            if (!self.selectIndex) {
                //用户第一次点击
                self.selectIndex = indexPath;
                [self didSelectCellRowFirstDo:YES nextDo:NO];
                
            }else{
                //用户切换点击
                [self didSelectCellRowFirstDo:NO nextDo:YES];
            }
            
        }
        
    }else{
       //无任何动作
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}

- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert{
    self.isOpen = firstDoInsert;
    
    ExpandTitleTableViewCell *cell = (ExpandTitleTableViewCell *)[self cellForRowAtIndexPath:self.selectIndex];
    [cell changeArrowWithUp:firstDoInsert];
    
    [self beginUpdates];
    
    NSInteger section = self.selectIndex.section;
    
    if (!(section < [self.dataSourceList count])) {
        return;
    }
    //子cell数量
    int contentCount = [(NSArray*)[self.dataSourceList objectAtIndex:section] count];//子cell数量
    
    NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
    for (NSUInteger i = 1; i < contentCount + 1; i++) {
        NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
        [rowToInsert addObject:indexPathToInsert];
    }
    
    if (firstDoInsert){
        [self insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }else{
        [self deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    [rowToInsert release];
    [self endUpdates];
    
    if (nextDoInsert) {
        self.isOpen = YES;
        self.selectIndex = [self indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
    if (self.isOpen) [self scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
