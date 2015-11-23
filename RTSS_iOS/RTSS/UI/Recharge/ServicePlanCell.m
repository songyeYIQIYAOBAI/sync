//
//  ServicePlanCell.m
//  RTSS
//
//  Created by 加富董 on 14/11/26.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "ServicePlanCell.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"
#import "ProductOffer.h"
#import "Product.h"
#import "DateUtils.h"

#define VIEW_PADDING_X_LEFT 14.0
#define VIEW_PADDING_X_RIGHT 14.0

#define VIEW_PADDING_Y_TOP 10.0
#define VIEW_PADDING_Y_BOTTOM 10.0

#define VIEW_SPACE_X 5.0
#define VIEW_SPACE_Y 5.0

#define PURCHASE_BUTTON_WIDTH 70.0
#define PURCHASE_BUTTON_HEIGHT 25.0
#define PURCHASE_BUTTON_CORNER_RADIUS 12.0

@interface ServicePlanCell () {
    CGSize cellAvailableSize;
    UILabel *planDescriptionLabel;
    UILabel *planPriceLabel;
    UILabel *planExpiredLabel;
    UIButton *purchaseButton;
    UIImageView *seperatorLineImageView;
}

@property(nonatomic,retain)NSIndexPath *cellIndexPath;
@property(nonatomic,retain)UITableView *currentTableView;

@end

@implementation ServicePlanCell

@synthesize cellIndexPath;
@synthesize delegate;
@synthesize currentTableView;

#pragma mark dealloc
- (void)dealloc {
    [cellIndexPath release];
    [currentTableView release];
    [seperatorLineImageView release];
    [super dealloc];
}

#pragma mark init views
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier availableSize:(CGSize)size delegate:(id<ServicePlanCellDelegate>)del {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        cellAvailableSize = size;
        self.delegate = del;
        [self initCellViews];
    }
    return self;
}

- (void)initCellViews {
    //describe label
    planDescriptionLabel = [CommonUtils labelWithFrame:CGRectZero text:nil textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textFont:[RTSSAppStyle getRTSSFontWithSize:14.0] tag:0];
    planDescriptionLabel.backgroundColor = [UIColor clearColor];
    planDescriptionLabel.textAlignment = NSTextAlignmentLeft;
    planDescriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:planDescriptionLabel];
    
    //price label
    planPriceLabel = [CommonUtils labelWithFrame:CGRectZero text:nil textColor:[[RTSSAppStyle currentAppStyle] textMajorColor] textFont:[RTSSAppStyle getRTSSFontWithSize:15.0] tag:0];
    planPriceLabel.backgroundColor = [UIColor clearColor];
    planPriceLabel.textAlignment = NSTextAlignmentLeft;
    planPriceLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:planPriceLabel];
    
    //expried label
    planExpiredLabel = [CommonUtils labelWithFrame:CGRectZero text:nil textColor:[RTSSAppStyle currentAppStyle].textMajorColor textFont:[RTSSAppStyle getRTSSFontWithSize:15.0] tag:0];
    planExpiredLabel.backgroundColor = [UIColor clearColor];
    planExpiredLabel.textAlignment = NSTextAlignmentLeft;
    planExpiredLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:planExpiredLabel];
    
    //purchase button
    CGRect purRect = CGRectMake(cellAvailableSize.width - VIEW_PADDING_X_RIGHT - PURCHASE_BUTTON_WIDTH, (cellAvailableSize.height - PURCHASE_BUTTON_HEIGHT) / 2.0, PURCHASE_BUTTON_WIDTH, PURCHASE_BUTTON_HEIGHT);
    purchaseButton = [CommonUtils buttonWithType:UIButtonTypeCustom frame:purRect title:NSLocalizedString(@"Recharge_Recharge_Button_Title", nil) colorNormal:[[RTSSAppStyle currentAppStyle] buttonMajorColor] colorHighlighted:[[RTSSAppStyle currentAppStyle] buttonMajorColor] colorSelected:nil addTarget:self action:@selector(purchaseButtonClicked:) tag:0];
    purchaseButton.layer.cornerRadius = PURCHASE_BUTTON_CORNER_RADIUS;
    purchaseButton.layer.masksToBounds = YES;
    purchaseButton.titleLabel.font = [RTSSAppStyle getRTSSFontWithSize:13.0];
    [purchaseButton setTitleColor:[[RTSSAppStyle currentAppStyle] textMajorColor] forState:UIControlStateNormal];
    [self.contentView addSubview:purchaseButton];
    
    //seperator line
    seperatorLineImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    seperatorLineImageView.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [self.contentView addSubview:seperatorLineImageView];
}


#pragma mark layout by data
- (void)layoutSubviewsByData:(id)planData contentType:(ContentType)contentType atIndexPath:(NSIndexPath *)indexPath belongToTableView:(UITableView *)tableView showSeperateLine:(BOOL)show {
    self.currentTableView = tableView;
    self.cellIndexPath = indexPath;
    show ? seperatorLineImageView.hidden = NO : YES;
    if (planData) {
        CGFloat availableWidth = cellAvailableSize.width - VIEW_PADDING_X_LEFT - VIEW_PADDING_X_RIGHT - PURCHASE_BUTTON_WIDTH - VIEW_SPACE_X;

        NSString *descript = nil;
        NSString *accessoryButtonTitle = nil;
        CGFloat price = 0.;
        if (contentType == ContentTypeRecharge) {
            descript = [(ProductOffer *)planData mDescription];
            price = [CommonUtils formatMoneyFromPennyToYuan:[(ProductOffer *)planData mPrice]];
            accessoryButtonTitle = NSLocalizedString(@"Recharge_Recharge_Button_Title", nil);
        } else {
            descript = [(Product *)planData mName];
            price = [CommonUtils formatMoneyFromPennyToYuan:[(ProductOffer *)planData mPrice]];
            accessoryButtonTitle = NSLocalizedString(@"Recharge_My_Plan_Button_Title", nil);
        }
        //describe
        CGSize desSize = [CommonUtils calculateTextSize:descript constrainedSize:CGSizeMake(availableWidth, CGFLOAT_MAX) textFont:[RTSSAppStyle getRTSSFontWithSize:14.0] lineBreakMode:NSLineBreakByWordWrapping];
        CGRect desFrame = CGRectMake(VIEW_PADDING_X_LEFT, VIEW_PADDING_Y_TOP, desSize.width, desSize.height);
        planDescriptionLabel.frame = desFrame;
        planDescriptionLabel.text = descript;
        
        //price
        NSString *priceStr = [NSString stringWithFormat:@"%@%.2f",NSLocalizedString(@"Currency_Unit", nil),price];
        CGSize priceSize = [CommonUtils calculateTextSize:priceStr constrainedSize:CGSizeMake(availableWidth, CGFLOAT_MAX) textFont:[RTSSAppStyle getRTSSFontWithSize:15.0] lineBreakMode:NSLineBreakByWordWrapping];
        CGRect priceFrame = CGRectMake(VIEW_PADDING_X_LEFT, CGRectGetMaxY(planDescriptionLabel.frame) + VIEW_SPACE_Y, priceSize.width, priceSize.height);
        planPriceLabel.frame = priceFrame;
        planPriceLabel.text = priceStr;
        
        //expried
        if (contentType == ContentTypeMyPlan) {
            NSString *endDateStr = ((Product *)planData).mEndDate;
            //endDateStr = @"20150801000000";
            if ([CommonUtils objectIsValid:endDateStr]) {
                NSDate *endDate = [self dateFromString:endDateStr dataFormatter:@"yyyyMMddHHmmss"];
                if (endDate) {
                    planExpiredLabel.frame = CGRectMake(VIEW_PADDING_X_LEFT + 75, CGRectGetMinY(planPriceLabel.frame), availableWidth - VIEW_PADDING_X_LEFT - 60.0, CGRectGetHeight(planPriceLabel.frame));
                    NSTimeInterval expiredInterval = [endDate timeIntervalSince1970];
                    NSTimeInterval nowInterval = [[NSDate date] timeIntervalSince1970];
                    NSString *expiredInfoStr = nil;
                    if (expiredInterval > nowInterval) {
                        //未过期
                        expiredInfoStr = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Recharge_Product_Unexpired", nil),[DateUtils getStringDateByDate:endDate dateFormat:@"dd/MM/yyyy"]];
                        planExpiredLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
                    } else {
                        //过期
                        expiredInfoStr = NSLocalizedString(@"Recharge_Product_Expired", nil);
                        planExpiredLabel.textColor = [RTSSAppStyle currentAppStyle].userInfoComponentErrorColor;
                    }
                    planExpiredLabel.text = expiredInfoStr;
                }
            }
        }
        
        //accessory button title
        [purchaseButton setTitle:accessoryButtonTitle forState:UIControlStateNormal];
        
        //reset sepserate line
        CGRect lineFrame = CGRectMake(0.0, CGRectGetMaxY(planPriceLabel.frame) + VIEW_PADDING_Y_BOTTOM , cellAvailableSize.width, 1.0);
        seperatorLineImageView.frame = lineFrame;
    }
}

#pragma mark calculate cell height
+ (CGFloat)getPlanCellHeightByData:(id)cellData contentType:(ContentType)contentType availableWidth:(CGFloat)totalWidth {
    CGFloat totalHeight = VIEW_PADDING_Y_TOP + VIEW_PADDING_Y_BOTTOM + VIEW_SPACE_Y + 1.0;
    CGFloat availableWidth = totalWidth - VIEW_PADDING_X_LEFT - VIEW_PADDING_X_RIGHT - PURCHASE_BUTTON_WIDTH - VIEW_SPACE_X;
    if (cellData) {
        NSString *descript = nil;
        CGFloat price = 0.;
        if (contentType == ContentTypeRecharge) {
            descript = [(ProductOffer *)cellData mDescription];
            price = [CommonUtils formatMoneyFromPennyToYuan:[(ProductOffer *)cellData mPrice]];
        } else {
            descript = [(Product *)cellData mName];
            price = [CommonUtils formatMoneyFromPennyToYuan:[(ProductOffer *)cellData mPrice]];
        }
        
        //descript
        CGSize desSize = [CommonUtils calculateTextSize:descript constrainedSize:CGSizeMake(availableWidth, CGFLOAT_MAX) textFont:[RTSSAppStyle getRTSSFontWithSize:14.0] lineBreakMode:NSLineBreakByWordWrapping];
        totalHeight += desSize.height;
        
        //price
        NSString *priceStr = [NSString stringWithFormat:@"%@%.0f",NSLocalizedString(@"Currency_Unit", nil),price];
        CGSize priceSize = [CommonUtils calculateTextSize:priceStr constrainedSize:CGSizeMake(availableWidth, CGFLOAT_MAX) textFont:[RTSSAppStyle getRTSSFontWithSize:15.0] lineBreakMode:NSLineBreakByWordWrapping];
        totalHeight += priceSize.height;
    }
    return totalHeight;
}

#pragma mark purchase action
- (void)purchaseButtonClicked:(UIButton *)purchaseButton {
    if (delegate && [delegate respondsToSelector:@selector(servicePlanCell:didClickedPurchaseButtonAtIndexPath: inTableView:)]) {
        [delegate servicePlanCell:self didClickedPurchaseButtonAtIndexPath:cellIndexPath inTableView:currentTableView];
    }
}

#pragma mark others
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma mark tools
- (NSDate *)dateFromString:(NSString *)dateStr dataFormatter:(NSString *)format {
    NSDate *date = nil;
    @try {
        NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        [formatter setTimeZone:zone];
        [formatter setDateFormat:format];
        date = [formatter dateFromString:dateStr];
//        //纠正时间偏差
//        NSTimeInterval interval = [zone secondsFromGMTForDate:date];
//        date = [date dateByAddingTimeInterval:interval];
    }
    @catch (NSException *exception) {
        NSLog(@"service plan cell=== dateFromString===%@",exception.description);
    }
    @finally {
        return date;
    }
}

@end
