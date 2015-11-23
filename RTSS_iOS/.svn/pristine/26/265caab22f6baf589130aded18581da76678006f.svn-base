//
//  QuickOrderItemView.m
//  EasyTT
//
//  Created by tiger on 14-11-4.
//  Copyright (c) 2013年 lvming. All rights reserved.
//

#import "QuickOrderItemView.h"
#import "RTSSAppStyle.h"
#import "CommonUtils.h"
#import "PlanManageModel.h"
#import "DropDownItemView.h"
#import "ProductOffer.h"
#import "ProductResource.h"
#import "SegmentControlView.h"
#import "ProductResourceView.h"

#define HEADER_VIEW_HEIGHT 40.f

#define VIEWS_PADDING_X 10.f

#define ACTION_BUTTON_WIDTH 60.f
#define ACTION_BUTTON_HEIGHT 25.f
#define ACTION_BUTTON_CORNER_RADIUS 4.f

#define PACKAGE_FEE_LABEL_WIDTH 75.f

#define THICK_SEPERATE_LINE_HEIGHT 1.f
#define THIN_SEPERATE_LINE_HEIGHT 1.f

#define RESOURCE_VIEW_WIDTH 60.f
#define RESOURCE_VIEW_OFFSET_X 5.f
#define RESOURCE_VIEW_COUNT_EACH_LINE 3

@interface QuickOrderItemView() {
    CGRect viewFrame;
    UIView *headerView;
    UIView *detailView;
    UIView *packageView;
    UILabel* packageTitleLabel;
    UILabel* packageFeeLable;
}

@end

@implementation QuickOrderItemView

@synthesize actionButton;
@synthesize selectButton;
@synthesize productOffer;

#pragma mark dealloc
- (void)dealloc
{
    [headerView release];
    [detailView release];
    [packageView release];
    [productOffer release];
    [super dealloc];
}

#pragma mark init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        viewFrame = frame;
        [self initContentView:frame];
    }
    return self;
}

#pragma mark init views
- (void)initContentView:(CGRect)frame
{
    [self loadPackageHeaderView];
    
    [self loadPackageDetailView];
}

- (void)loadPackageHeaderView {
    //bg view
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(viewFrame), HEADER_VIEW_HEIGHT)];
    headerView.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
    [self addSubview:headerView];
    
    //action button
   CGRect buttonRect = CGRectMake(CGRectGetWidth(viewFrame) - VIEWS_PADDING_X - ACTION_BUTTON_WIDTH, (HEADER_VIEW_HEIGHT - ACTION_BUTTON_HEIGHT) / 2.f, ACTION_BUTTON_WIDTH, ACTION_BUTTON_HEIGHT);
//    actionButton = [CommonUtils buttonWithType:UIButtonTypeCustom frame:buttonRect title:nil colorNormal:[[RTSSAppStyle currentAppStyle] commonGreenButtonNormalColor] colorHighlighted:[[RTSSAppStyle currentAppStyle] commonGreenButtonHighlightColor] colorSelected:nil addTarget:nil action:nil tag:0];
//    actionButton.layer.cornerRadius = ACTION_BUTTON_CORNER_RADIUS;
//    actionButton.layer.masksToBounds = YES;
    
    
    actionButton = [RTSSAppStyle getMajorGreenButton:buttonRect target:nil action:nil title:nil];
    
    
    [headerView addSubview:actionButton];
    
    //title label
    CGRect titleRect = CGRectMake(VIEWS_PADDING_X, 0.f, CGRectGetWidth(viewFrame) - VIEWS_PADDING_X - VIEWS_PADDING_X - ACTION_BUTTON_WIDTH, HEADER_VIEW_HEIGHT);
    packageTitleLabel = [CommonUtils labelWithFrame:titleRect text:nil textColor:[[RTSSAppStyle currentAppStyle] textMajorColor] textFont:[RTSSAppStyle getRTSSFontWithSize:16.0f] tag:0];
    packageTitleLabel.backgroundColor = [UIColor clearColor];
    packageTitleLabel.textAlignment = NSTextAlignmentLeft;
    packageTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [headerView addSubview:packageTitleLabel];
    
    //seperate line
    UIImageView *seperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, CGRectGetMaxY(headerView.frame), CGRectGetWidth(viewFrame), THICK_SEPERATE_LINE_HEIGHT)];
    seperateLine.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [self addSubview:seperateLine];
    [seperateLine release];
}

- (void)loadPackageDetailView {
    //bg view
    CGRect detailFrame = CGRectMake(0.f, CGRectGetMaxY(headerView.frame) + THICK_SEPERATE_LINE_HEIGHT, CGRectGetWidth(viewFrame), CGRectGetHeight(viewFrame) - CGRectGetMaxY(headerView.frame) - THICK_SEPERATE_LINE_HEIGHT);
    detailView = [[UIView alloc] initWithFrame:detailFrame];
    detailView.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
    [self addSubview:detailView];
    
    //fee label
    CGRect feeRect = CGRectMake(VIEWS_PADDING_X, 0.f, PACKAGE_FEE_LABEL_WIDTH, CGRectGetHeight(detailFrame));
    packageFeeLable = [CommonUtils labelWithFrame:feeRect text:nil textColor:[[RTSSAppStyle currentAppStyle] textMajorGreenColor] textFont:[RTSSAppStyle getRTSSFontWithSize:24] tag:0];
    packageFeeLable.backgroundColor = [UIColor clearColor];
    packageFeeLable.textAlignment = NSTextAlignmentLeft;
    packageFeeLable.lineBreakMode = NSLineBreakByWordWrapping;
    [detailView addSubview:packageFeeLable];
        
    //package view
    CGRect packageFrame = CGRectMake(CGRectGetMaxX(packageFeeLable.frame), 0.f, CGRectGetWidth(viewFrame) - CGRectGetWidth(packageFeeLable.frame), CGRectGetHeight(detailView.frame));
    packageView = [[UIView alloc] initWithFrame:packageFrame];
    packageView.backgroundColor = [UIColor clearColor];
    [detailView addSubview:packageView];
    
    //seperate line
    UIImageView *seperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, (CGRectGetMaxY(packageView.frame) - THIN_SEPERATE_LINE_HEIGHT) / 2.f, CGRectGetWidth(packageView.frame), THIN_SEPERATE_LINE_HEIGHT)];
    seperateLine.image = [UIImage imageNamed:@"common_separator_line"];
    [packageView addSubview:seperateLine];
    [seperateLine release];
    
    //add select button
    selectButton = [CommonUtils buttonWithType:UIButtonTypeCustom frame:CGRectMake(0.f, 0.f, CGRectGetWidth(viewFrame), CGRectGetHeight(viewFrame)) title:nil bgImageNormal:nil bgImageHighlighted:nil bgImageSelected:nil addTarget:nil action:nil tag:0];
    
    
    
    
    [self addSubview:selectButton];
    
    //change hierarchy of buttons
    CGRect convertActionButtonRect = [headerView convertRect:actionButton.frame toView:selectButton];
    NSLog(@"convert former rect == %@,later rect == %@",NSStringFromCGRect(actionButton.frame),NSStringFromCGRect(convertActionButtonRect));
    convertActionButtonRect.origin.x -= 15;
    convertActionButtonRect.size.width +=15;
    actionButton.frame = convertActionButtonRect;
    [selectButton addSubview:actionButton];
}

#pragma mark layout views by data
- (void)layoutSubviewsByProductOffer:(ProductOffer *)product type:(QuickOrderType)orderType{
    if (!product) {
        return;
    }
    self.productOffer = product;
    
    //title
    packageTitleLabel.text = productOffer.mName;
    
    //button title
    NSString *buttonTitle = nil;
//    if (orderType == QuickOrderTypeNegotiation) {
//        buttonTitle = NSLocalizedString(@"QuickOrder_Button_Title_Nego", nil);
//    } else if (orderType == QuickOrderTypeRecharge) {
//        buttonTitle = NSLocalizedString(@"QuickOrder_Button_Title_Recharge", nil);
//    }
    if (product.mNegotiable) {
        buttonTitle = NSLocalizedString(@"QuickOrder_Button_Title_Nego", nil);
    }else{
         buttonTitle = NSLocalizedString(@"QuickOrder_Button_Title_Recharge", nil);
        
    }
    
    actionButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
    [actionButton setTitle:buttonTitle forState:UIControlStateNormal];
    [actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //fee label
    packageFeeLable.adjustsFontSizeToFitWidth = YES;
    packageFeeLable.text = [NSString stringWithFormat:@"%@%.0f",NSLocalizedString(@"Currency_Unit", nil),[CommonUtils formatMoneyFromPennyToYuan:product.mPrice]];
   
    if (product.mResources && product.mResources.count) {
        [packageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        //seperate line
        UIImageView *seperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, (CGRectGetMaxY(packageView.frame) - THIN_SEPERATE_LINE_HEIGHT) / 2.f, CGRectGetWidth(packageView.frame), THIN_SEPERATE_LINE_HEIGHT)];
        seperateLine.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
        [packageView addSubview:seperateLine];
        [seperateLine release];
        [self layoutPackageViewData];
    }
}

- (void)layoutPackageViewData {
    NSArray *resources = productOffer.mResources;
    CGFloat viewSpaceX = (CGRectGetWidth(packageView.frame) - RESOURCE_VIEW_OFFSET_X - RESOURCE_VIEW_WIDTH * RESOURCE_VIEW_COUNT_EACH_LINE) / RESOURCE_VIEW_COUNT_EACH_LINE;
    CGFloat viewHeight = (CGRectGetHeight(packageView.frame) - THIN_SEPERATE_LINE_HEIGHT) / 2.f;
    for (int i = 0; i < [resources count]; i ++) {
        ProductResource *resource = [productOffer.mResources objectAtIndex:i];
        CGFloat xp = RESOURCE_VIEW_OFFSET_X + (i % RESOURCE_VIEW_COUNT_EACH_LINE) * (RESOURCE_VIEW_WIDTH + viewSpaceX);
        CGFloat yp = (i / RESOURCE_VIEW_COUNT_EACH_LINE) * (0.f + viewHeight + THIN_SEPERATE_LINE_HEIGHT);
        CGRect viewRect = CGRectMake(xp, yp, RESOURCE_VIEW_WIDTH, viewHeight);
        ProductResourceView *resourceView = [[ProductResourceView alloc] initWithFrame:viewRect productResourceData:resource];
        [packageView addSubview:resourceView];
        [resourceView release];
    }
}


@end
