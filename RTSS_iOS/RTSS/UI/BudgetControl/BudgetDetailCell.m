//
//  BudgetDetailCell.m
//  RTSS
//
//  Created by 加富董 on 15/2/4.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "BudgetDetailCell.h"
#import "BudgetDetailView.h"
#import "CommonUtils.h"

#define BUDGET_DETAIL_VIEW_BASE_CLASS_STRING @"BudgetDetailView"
#define BUDGET_DETAIL_VIEW_BUDGET_CLASS_STRING @"BudgetDetailBudgetView"
#define BUDGET_DETAIL_VIEW_NOTIFY_CLASS_STRING @"BudgetDetailNotifyView"
#define BUDGET_DETAIL_VIEW_BAR_CLASS_STRING @"BudgetDetailBarView"

@interface BudgetDetailCell () {

}

@property (nonatomic,assign) CGSize availableSize;

@end

@implementation BudgetDetailCell

@synthesize detailView;
@synthesize showArrow;
@synthesize contentType;
@synthesize availableSize;
@synthesize cellIndexPath;
@synthesize delegate;
@synthesize supportInteraction;

#pragma mark dealloc
- (void)dealloc {
    [detailView release];
    [cellIndexPath release];
    [super dealloc];
}

#pragma mark init
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier availableSize:(CGSize)size {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.availableSize = size;
    }
    return self;
}

#pragma mark init views
- (void)loadContentViewsByType:(DetailCellContentType)type showArrow:(BOOL)show supportInteraction:(BOOL)interaction indexPath:(NSIndexPath *)indexPath {
    if (detailView) {
        [detailView removeFromSuperview];
    }
    self.cellIndexPath = indexPath;
    self.showArrow = show;
    self.contentType = type;
    self.supportInteraction = interaction;
    NSString *viewClassName = [self getContentViewClass];
    if ([CommonUtils objectIsValid:viewClassName]) {
        CGRect contentRect = CGRectMake(0.0, 0.0, availableSize.width, availableSize.height);
        self.detailView = [[[NSClassFromString(viewClassName) alloc] initWithFrame:contentRect showArrow:self.showArrow] autorelease];
        if (type == DetailCellContentTypeBar) {
            [((BudgetDetailBarView *)self.detailView).budgetBarButton addTarget:self action:@selector(budgetBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            if (self.supportInteraction) {
                [((BudgetDetailBarView *)self.detailView).budgetBarButton setEnabled:YES];
            } else {
                [((BudgetDetailBarView *)self.detailView).budgetBarButton setEnabled:NO];
            }
            
        }
        [self.contentView addSubview:detailView];
    } else {
        NSLog(@"view class invalid");
    }
}

#pragma mark button clicked
- (void)budgetBarButtonClicked:(UIButton *)button {
    if (self.supportInteraction) {
        if (delegate && [delegate respondsToSelector:@selector(budgetDetailCell:didClickedActionButtonAtIndexPath:)]) {
            [delegate budgetDetailCell:self didClickedActionButtonAtIndexPath:self.cellIndexPath];
        }
    }
}

#pragma mark tools method
- (NSString *)getContentViewClass {
    NSString *setViewClassName = nil;
    switch (self.contentType) {
        case DetailCellContentTypeBudget:
            setViewClassName = BUDGET_DETAIL_VIEW_BUDGET_CLASS_STRING;
            break;
        case DetailCellContentTypeNotify:
            setViewClassName = BUDGET_DETAIL_VIEW_NOTIFY_CLASS_STRING;
            break;
        case DetailCellContentTypeBar:
            setViewClassName = BUDGET_DETAIL_VIEW_BAR_CLASS_STRING;
            break;
        default:
            setViewClassName = BUDGET_DETAIL_VIEW_BASE_CLASS_STRING;
            break;
    }
    return setViewClassName;
}

@end
