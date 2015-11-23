//
//  MyServicesTableView.m
//  RTSS
//
//  Created by 宋野 on 14-11-14.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "MyServicesTableView.h"

#import "RTSSAppStyle.h"
#import "PlanManageModel.h"
#import "ProductOffer.h"
#import "ProductResource.h"


#define MYSERVICES_TABLEVIEW_CELL_HEIGHT            125.f
#define MYSERVICES_TABLEVIEW_CELL_INTERVAL          20.f


@interface MyServicesTableView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , retain)UITableView * myTableView;

@end

@implementation MyServicesTableView

@synthesize sections,rows;

-(void)dealloc{
    [self.myTableView release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.sections = [NSMutableArray array];
        self.rows = [NSMutableArray array];
        
        [self initViews];
    }
    return self;
}

- (void)initViews{
    self.myTableView = [[UITableView alloc] initWithFrame:self.bounds];
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.showsHorizontalScrollIndicator = NO;
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    [self addSubview:self.myTableView];
}

- (void)reloadData{
    [self.myTableView reloadData];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return MYSERVICES_TABLEVIEW_CELL_HEIGHT+ MYSERVICES_TABLEVIEW_CELL_INTERVAL;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return sections.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[rows objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"myServicesTableViewCell";
    MyServicesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[MyServicesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self setModelWith:indexPath Cell:cell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //不需要点击事件
    
//    if (self.delegate && [self.delegate respondsToSelector:@selector(myServicesTableViewDidSelectRowWithIndexPath:Tag:)]) {
//        [self.delegate myServicesTableViewDidSelectRowWithIndexPath:indexPath Tag:0];
//    }
}

- (void)setModelWith:(NSIndexPath *)indexPath Cell:(MyServicesTableViewCell *)cell{
    ProductOffer * productOffer = [[rows objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell.quickItemView layoutSubviewsByProductOffer:productOffer type:QuickOrderTypeNegotiation];
    
    [cell addSubview:cell.quickItemView];
}

@end

@implementation MyServicesTableViewCell
@synthesize quickItemView;

- (void)dealloc{
    [self.quickItemView release];
    [super dealloc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, self.bounds.size.width, MYSERVICES_TABLEVIEW_CELL_HEIGHT + MYSERVICES_TABLEVIEW_CELL_INTERVAL);
        self.backgroundColor = [UIColor clearColor];
        
        self.quickItemView = [[QuickOrderItemView alloc] initWithFrame:CGRectMake(14, MYSERVICES_TABLEVIEW_CELL_INTERVAL, self.frame.size.width-28, MYSERVICES_TABLEVIEW_CELL_HEIGHT)];
        self.quickItemView.layer.cornerRadius = 8.f;
        self.quickItemView.layer.borderColor = [RTSSAppStyle currentAppStyle].turboBoostBoderColor.CGColor;
        self.quickItemView.layer.borderWidth = 1.f;
        self.quickItemView.clipsToBounds = YES;
        self.quickItemView.actionButton.hidden = YES;
    }
    return self;
}



@end
