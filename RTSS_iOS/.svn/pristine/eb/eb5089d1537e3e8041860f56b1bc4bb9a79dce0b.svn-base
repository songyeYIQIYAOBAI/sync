//
//  MyPlanTableView.m
//  RTSS
//
//  Created by 宋野 on 14-11-22.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "MyPlanTableView.h"
#import "RTSSAppStyle.h"
#import "CommonUtils.h"
#import "Subscriber.h"
#import "Product.h"


#define MYPLAN_TABLEVIEW_CELL_HEIGHT                    72
#define TABLE_SECTION_HEADER_HEIGHT                     30

@interface MyPlanTableView ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray * modelArray;
    UITableView * myTableView;
}

@end

@implementation MyPlanTableView

- (void)dealloc{
    [myTableView release];
    [modelArray release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initTableView];
    }
    return self;
}

- (void)initTableView{
    myTableView = [[UITableView alloc] initWithFrame:self.bounds];
    myTableView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self addSubview:myTableView];
}

- (void)initViewsWithArray:(NSArray *)modelsArray{
    modelArray = [modelsArray retain];
    [myTableView reloadData];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return MYPLAN_TABLEVIEW_CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return TABLE_SECTION_HEADER_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    Subscriber * subscriber = [modelArray objectAtIndex:section];
    
    return subscriber.mProducts.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"myPlanTableViewCell";
    MyPlanTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[MyPlanTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    cell.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.updateBtn addTarget:self action:@selector(upGradeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    Subscriber * subscriber = [modelArray objectAtIndex:indexPath.section];
    Product * itemModel = [subscriber.mProducts objectAtIndex:indexPath.row];
    [self setCell:cell model:itemModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(myPlanTableViewCellTapIndex:)]) {
        [self.delegate myPlanTableViewCellTapIndex:indexPath];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    Subscriber * itemModel = [modelArray objectAtIndex:section];
    MyPlanTableHeadView * headView = [[[MyPlanTableHeadView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, TABLE_SECTION_HEADER_HEIGHT)] autorelease];
    headView.title.text = itemModel.mName;
    
    return headView;
}

- (void)setCell:(MyPlanTableViewCell *)cell model:(Product *)itemModel{
    cell.titleLabel.text = itemModel.mName;
    cell.priceLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Currency_Unit", nil),itemModel.mServiceId];
}

- (void)upGradeBtnClick:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(myPlanTableViewClickUpdateButtonIndex:)]) {
        UITableViewCell * cell = (UITableViewCell *)button.superview;
        
        NSIndexPath * path = [myTableView indexPathForCell:cell];
        NSLog(@" section:%d row:%d",path.section,path.row);
        [self.delegate myPlanTableViewClickUpdateButtonIndex:path];
    }
}

@end

#define LABEL_HEIGHT                            20.0
#define LABEL_CONTENT_WIDTH                     235.0

#define BUTTON_WIDTH                            50.0
#define BUTTON_HEIGHT                           25.0

#define LABEL_TOP_INTERVAL                      10.0
#define LABEL_LEAT_INTERVAL                     10.0
#define TITLELABEL_CONTENTLABEL_INTERVAL        5.0
#define CONTENTLABEL_PRICELABEL_INTERVAL        10.0
#define LABEL_PRICE_STRING_WIDTH                40.0

#define TITLE_TEXT_FONT                         14.0
#define TITLE_CONTENT_FONT                      13.0


@interface MyPlanTableViewCell (){
    UILabel * priceString;
    UIImageView * line;
}

@end
@implementation MyPlanTableViewCell
@synthesize titleLabel,priceLabel,updateBtn;

- (void)dealloc{
    [line release];
    [super dealloc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        //titleLabel
        titleLabel = [CommonUtils labelWithFrame:CGRectMake(LABEL_LEAT_INTERVAL, LABEL_TOP_INTERVAL,  self.bounds.size.width - 3 * LABEL_LEAT_INTERVAL - BUTTON_WIDTH, LABEL_HEIGHT) text:@"" textColor:[RTSSAppStyle currentAppStyle].textMajorColor textFont:[UIFont systemFontOfSize:TITLE_TEXT_FONT] tag:0];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:titleLabel];
        
        //priceString
        priceString = [CommonUtils labelWithFrame:CGRectMake(LABEL_LEAT_INTERVAL, CGRectGetMaxY(titleLabel.frame) + CONTENTLABEL_PRICELABEL_INTERVAL,LABEL_PRICE_STRING_WIDTH, LABEL_HEIGHT) text:@"Price" textColor:[RTSSAppStyle currentAppStyle].textMajorColor textFont:[UIFont systemFontOfSize:TITLE_TEXT_FONT] tag:0];
        [self addSubview:priceString];
        
        //priceLabel
        priceLabel = [CommonUtils labelWithFrame:CGRectMake(CGRectGetMaxX(priceString.frame)+LABEL_LEAT_INTERVAL, priceString.frame.origin.y,LABEL_CONTENT_WIDTH, LABEL_HEIGHT) text:@"" textColor:[RTSSAppStyle currentAppStyle].textMajorGreenColor textFont:[UIFont systemFontOfSize:TITLE_TEXT_FONT] tag:0];
        priceLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:priceLabel];
        
        //line
        line = [[UIImageView alloc] initWithFrame:CGRectMake(0, priceLabel.frame.origin.y + priceLabel.bounds.size.height + CONTENTLABEL_PRICELABEL_INTERVAL, self.bounds.size.width, 2)];
        line.image = [UIImage imageNamed:@"common_separator_line"];
        [self addSubview:line];
        
        // ==
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, line.frame.origin.y + line.bounds.size.height);
        
        //updateBtn
        updateBtn = [CommonUtils buttonWithType:UIButtonTypeCustom frame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+LABEL_LEAT_INTERVAL,(self.bounds.size.height-BUTTON_HEIGHT)/2.0, BUTTON_WIDTH, BUTTON_HEIGHT) title:@"update" colorNormal:[RTSSAppStyle currentAppStyle].commonGreenButtonNormalColor colorHighlighted:[RTSSAppStyle currentAppStyle].commonGreenButtonHighlightColor colorSelected:nil addTarget:nil action:nil tag:0];
        updateBtn.titleLabel.font = [UIFont systemFontOfSize:TITLE_TEXT_FONT];
        updateBtn.layer.cornerRadius = 5.0;
        updateBtn.layer.masksToBounds = YES;
        [self addSubview:updateBtn];
        
    }
    return self;
}

@end

@implementation MyPlanTableHeadView
@synthesize title;

- (void)dealloc{
    [title release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
        [self initViews];
    }
    return self;
}

- (void)initViews{
    CGFloat leftInterval = 10;
    CGFloat height = 17.0;
    title = [[UILabel alloc] initWithFrame:CGRectMake(leftInterval, (CGRectGetHeight(self.bounds) - height)/2.0, CGRectGetWidth(self.bounds)-2*leftInterval, 17)];
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont systemFontOfSize:15];
    title.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    [self addSubview:title];
    
    // ==
    UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - 2, CGRectGetWidth(self.bounds), 2)];
    line.image = [UIImage imageNamed:@"common_separator_line"];
    [self addSubview:line];
    [line release];
}

@end
