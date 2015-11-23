//
//  DNDViewController.m
//  RTSS
//
//  Created by shengyp on 14/10/23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "DNDViewController.h"
#import "DNDTableView.h"

@interface DNDViewController ()<DNDTableViewDelegate>{
    DNDTableView * dndTableView;
    NSMutableArray * sections;
    NSInteger  clickIndex;
    BOOL       needSubView;
}

@end

@implementation DNDViewController

- (void)dealloc{
    [dndTableView release];
    [sections release];
    [super dealloc];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        clickIndex = -1;
        needSubView = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView{
    [super loadView];
    dndTableView = [[DNDTableView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT - 64)];
    dndTableView.DNDTableViewDelegate = self;
    [self.view addSubview:dndTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"DND";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)loadData{
    sections = [[NSMutableArray alloc] initWithCapacity:0];
    {
        DNDModel * model0 = [[DNDModel alloc] init];
        model0.title = @"In case,you dont wish to receive any promo-tional SMS/Calls please select the “Stop all” option below.";
        NSMutableArray * subModels = [[NSMutableArray alloc] initWithCapacity:0];
        DNDSubModel * subModel = [[DNDSubModel alloc] init];
        subModel.title = [NSString stringWithFormat:@"stop all"];
        subModel.selected = NO;
        [subModels addObject:subModel];
        model0.subModes = subModels;
        
        [subModel release];
        [subModels release];
        
        [sections addObject:model0];
        [model0 release];

    }
    
    {
        DNDModel * model1 = [[DNDModel alloc] init];
        model1.title = @"If you wish to receive promotional SMS/Calls for some categories and block others then please selcet approprite option from list";
        NSMutableArray * subModels = [[NSMutableArray alloc] initWithCapacity:0];
        
        DNDSubModel * subModel1 = [[DNDSubModel alloc] init];
        subModel1.title = [NSString stringWithFormat:@"Banking/Insurance/Financial products/Credit cards"];
        subModel1.selected = NO;
        [subModels addObject:subModel1];
        [subModel1 release];
        
        DNDSubModel * subModel2 = [[DNDSubModel alloc] init];
        subModel2.title = [NSString stringWithFormat:@"Communication/Broadcasting/Entertainment/It"];
        subModel2.selected = NO;
        [subModels addObject:subModel2];
        [subModel2 release];
        
        DNDSubModel * subModel3 = [[DNDSubModel alloc] init];
        subModel3.title = [NSString stringWithFormat:@"Education"];
        subModel3.selected = NO;
        [subModels addObject:subModel3];
        [subModel3 release];
        
        model1.subModes = subModels;
        [sections addObject:model1];
        
        [model1 release];
        [subModels release];
    }
    
    
}

#pragma mark - DNDTableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DNDModel * model = [sections objectAtIndex:indexPath.row];
    CGFloat height = [DNDTableViewCell cellHeight:model];
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"section:%d   row:%d    subrow:%d",indexPath.section,indexPath.row,indexPath.subRow);

    DNDModel * model = [sections objectAtIndex:indexPath.row];
    DNDSubModel * subModel = [model.subModes objectAtIndex:indexPath.subRow - 1];
    return [DNDTableViewCellSubViewCell cellHeight:subModel];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath{
    DNDModel * model = [sections objectAtIndex:indexPath.row];
    return model.subModes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier1 = @"DNDTableViewCell";
    DNDTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
    if (cell == nil) {
        cell = [[[DNDTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setCell:cell indexPath:(NSIndexPath *)indexPath];
    return cell;
}

- (DNDTableViewCellSubViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier2 = @"DNDTableViewCellSubViewCell";
    DNDTableViewCellSubViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
    if (cell == nil) {
        cell = [[[DNDTableViewCellSubViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2] autorelease];
    }
    [cell.button addTarget:self action:@selector(DNDTableViewCellSubViewCellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    NSLog(@"indexPath.section : %d    indexPath.row : %d    indexPath.subRow : %d",indexPath.section,indexPath.row,indexPath.subRow);
    [self setSubCell:cell indexPath:(NSIndexPath *)indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"indexPath.section : %d    indexPath.row : %d    indexPath.subRow : %d",indexPath.section,indexPath.row,indexPath.subRow);
}

- (void)setCell:(DNDTableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    DNDModel * model = [sections objectAtIndex:indexPath.row];
    cell.isExpandable = YES;
    cell.title = model.title;
}

- (void)setSubCell:(DNDTableViewCellSubViewCell *)cell indexPath:(NSIndexPath *)indexPath{
     NSLog(@"indexPath.section : %d    indexPath.row : %d    indexPath.subRow : %d",indexPath.section,indexPath.row,indexPath.subRow);
    DNDModel * model = [sections objectAtIndex:indexPath.row];
    DNDSubModel * subModel = [model.subModes objectAtIndex:indexPath.subRow - 1];
    cell.title = subModel.title;
    cell.showSelected = subModel.selected;
}

- (void)expandButtonClicked:(id)sender event:(id)event{
    UIButton * button = sender;
    DNDTableViewCell * cell = (DNDTableViewCell *)button.superview;
    NSIndexPath * index = [dndTableView indexPathForCell:cell];
    NSLog(@"button.superview : %@   index.section : %d  index.row : %d ",button.superview,index.section,index.row);
}

- (void)DNDTableViewCellSubViewCellButtonClick:(UIButton *)button{
    DNDTableViewCellSubViewCell * cell = (DNDTableViewCellSubViewCell *)button.superview;
    cell.showSelected = !button.selected;
    NSIndexPath * indexPath = [dndTableView indexPathForCell:cell];
    NSIndexPath * subIndexPath = [dndTableView correspondingIndexPathForSubRowAtIndexPath:indexPath];
    NSLog(@"button.superview : %@   index.section : %d  index.row : %d  index.subRow : %d",button.superview,subIndexPath.section,subIndexPath.row,subIndexPath.subRow);
    
    DNDModel * model = [sections objectAtIndex:subIndexPath.row];
    DNDSubModel * subModel = [model.subModes objectAtIndex:subIndexPath.subRow - 1];
    subModel.selected = cell.showSelected;

}

@end
