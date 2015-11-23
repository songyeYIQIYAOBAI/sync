//
//  AppTurboBoostCell.m
//  RTSS
//
//  Created by 加富董 on 14-10-29.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "AppTurboBoostCell.h"
#import "CommonUtils.h"
#import "AppTurboBoostModel.h"
#import "RTSSAppStyle.h"
#import "ImageUtils.h"
#import "RTSSAppDefine.h"

typedef NS_ENUM(NSInteger, ContentViewType) {
    ContentViewTypeNone,
    ContentViewTypeProduct,
    ContentViewTypeResult
};

#define STANDARD_SUPER_VALUE 292.f
#define FLIP_ANIMATION_DURATION	0.75

#define CELL_FOLD_HEIGHT 51.f
#define CELL_UNFOLD_HEIGHT 161.f

#define APP_ICON_WIDTH 40.f
#define APP_ICON_HEIGHT 40.f
#define VIEW_PADDING_X 20.f
#define APP_NAME_LABEL_WIDHT 150.f
#define APP_BANDWIDTH_LABEL_WIDTH 70.f

#define SPEED_LABEL_WIDTH 52.f
#define SPEED_BUTTON_WIDTH 68.f
#define DURATION_LABEL_WIDTH 45.f
#define DURATION_BUTTON_WIDTH 68.f
#define FEE_LABEL_WIDTH 100.f
#define RESET_BUTTON_WIDTH 68.f
#define SUBMIT_BUTTON_WIDTH 68.f
#define PRODUCT_VIEW_HEIGHT 26.f

@interface AppTurboBoostCell () {
    //header
    UIView *headerView;
    UIImageView *appIconImageView;
    UILabel *appNameLabel;
    UILabel *appBandWidthLabel;
    
    //content
    UIView *animationContentView;//动画层，用来翻转
    
    UIView *purchaseProductView;//选择加速产品页面
    UIButton *selectSpeedButton;
    UIButton *selectTimeButton;
    UILabel *feeLabel;
    UIButton *resetButton;
    UIButton *submitButton;
    
    UIView *purchaseResultView;//购买结果页面
    UILabel *orderLabel;
    UILabel *countDownLabel;
    
    UITableView *belongToTableView;
    
    BOOL flipLeftRight;
    
    CGSize cellFoldSize;//cell 折叠时大小
    CGSize cellUnfoldSize;//cell 展开时大小
    
    UIImageView *seperateLineImageView;
}

@end

@implementation AppTurboBoostCell

@synthesize indexPath;
@synthesize appDataModel;
@synthesize speedButtonValue;
@synthesize hourButtonValue;
@synthesize belongToTableView;
@synthesize delegate;

#pragma mark getter
- (int64_t)speedButtonValue {
    NSString *speedStr = [selectSpeedButton.titleLabel.text  stringByReplacingOccurrencesOfString:@"Mbps"  withString:@""];
    return [speedStr longLongValue];
}

- (int)hourButtonValue {
    NSString *hourStr = [selectTimeButton.titleLabel.text stringByReplacingOccurrencesOfString:@" Hour" withString:@""];
    return [hourStr intValue];
}

- (void)setSpeedButtonValue:(int64_t)speedValue {
    NSString *speedStr = [NSString stringWithFormat:@"%lld Mbps",speedValue];
    [selectSpeedButton setTitle:speedStr forState:UIControlStateNormal];
}

- (void)setHourButtonValue:(int)hourValue {
    NSString *hourStr = [NSString stringWithFormat:@"%d Hour",hourValue];
    [selectTimeButton setTitle:hourStr forState:UIControlStateNormal];
}

#pragma mark init views
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier belongToTableView:(UITableView *)tableView {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.belongToTableView = tableView;
        [self initDefaultValue];
        [self initViews];
        
    }
    return self;
}

- (void)initViews {
    [self initHeaderView];
    [self initContentView];
    [self initSeperateLine];
}

- (void)initHeaderView {
    //bg header view
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, cellFoldSize.width, cellFoldSize.height)];
    headerView.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
    [self.contentView addSubview:headerView];
    
    //app icon
    appIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(VIEW_PADDING_X, (cellFoldSize.height - APP_ICON_HEIGHT) / 2.f, APP_ICON_WIDTH, APP_ICON_HEIGHT)];
    [headerView addSubview:appIconImageView];
    
    //app name
    appNameLabel = [CommonUtils labelWithFrame:CGRectMake(CGRectGetMaxX(appIconImageView.frame) + 10.f, 0.f, APP_NAME_LABEL_WIDHT, cellFoldSize.height) text:nil textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textFont:[RTSSAppStyle getRTSSFontWithSize:16.0f] tag:0];
    appNameLabel.textAlignment = NSTextAlignmentLeft;
    appNameLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:appNameLabel];
    
    //band width
    appBandWidthLabel = [CommonUtils labelWithFrame:CGRectMake(cellFoldSize.width - 10.f - APP_BANDWIDTH_LABEL_WIDTH, 0.f, APP_BANDWIDTH_LABEL_WIDTH, cellFoldSize.height) text:nil textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textFont:[RTSSAppStyle getRTSSFontWithSize:14.0f] tag:0];
    appBandWidthLabel.textAlignment = NSTextAlignmentRight;
    appBandWidthLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:appBandWidthLabel];
}

- (void) initContentView {
    //背景层
    UIView *gradualBgView = [[UIView alloc] initWithFrame:CGRectMake(0.f, cellFoldSize.height, cellUnfoldSize.width, cellUnfoldSize.height - cellFoldSize.height)];
    gradualBgView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    [self.contentView addSubview:gradualBgView];
    [gradualBgView release];
    
    //gradual bar
    UIImageView *gradualBar = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, cellUnfoldSize.width, 1.f)];
    gradualBar.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [gradualBgView addSubview:gradualBar];
    [gradualBar release];

    //动画层
//    CGRect viewRect = CGRectMake(0.f, cellFoldSize.height, cellFoldSize.width, cellUnfoldSize.height - cellFoldSize.height);
//    animationContentView = [[UIView alloc] initWithFrame:viewRect];
//    animationContentView.backgroundColor = [UIColor clearColor];
//    [self.contentView addSubview:animationContentView];
    CGRect viewRect = CGRectMake(0.f, 0.f, cellFoldSize.width, cellUnfoldSize.height - cellFoldSize.height);
    animationContentView = [[UIView alloc] initWithFrame:viewRect];
    animationContentView.backgroundColor = [UIColor clearColor];
    [gradualBgView addSubview:animationContentView];
    
    CGRect contentViewFrame = CGRectMake(0.f, 0.f, cellUnfoldSize.width, cellUnfoldSize.height - cellFoldSize.height);
    //购买层
    [self initPurchaseProductViewByAvailableFrame:contentViewFrame];
    
    //结果层
    [self initPurchaseResultViewByAvailableFrame:contentViewFrame];
}

- (void)initSeperateLine {
    seperateLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, cellFoldSize.height - SEPERATOR_LINE_HEIGHT, cellFoldSize.width, SEPERATOR_LINE_HEIGHT)];
    seperateLineImageView.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [self.contentView addSubview:seperateLineImageView];
}

- (void)initPurchaseProductViewByAvailableFrame:(CGRect)availableFrame {
    CGSize availableSize = availableFrame.size;

    //purchase view
    purchaseProductView = [[UIView alloc] initWithFrame:availableFrame];
    purchaseProductView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    purchaseProductView.backgroundColor = [UIColor clearColor];
    [animationContentView addSubview:purchaseProductView];
    
    //speed label
    CGFloat offsetY = ((CELL_UNFOLD_HEIGHT - CELL_FOLD_HEIGHT- SEPERATOR_LINE_HEIGHT) / 2.f - PRODUCT_VIEW_HEIGHT) / 2.f;
    CGRect speedLabelRect = CGRectMake(VIEW_PADDING_X, offsetY, SPEED_LABEL_WIDTH, PRODUCT_VIEW_HEIGHT);
    UILabel *speedLabel = [CommonUtils labelWithFrame:speedLabelRect text:NSLocalizedString(@"TurboBoost_Cell_Speed_Prompt", nil) textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textFont:[RTSSAppStyle getRTSSFontWithSize:14.0f] tag:0];
    speedLabel.backgroundColor = [UIColor clearColor];
    speedLabel.textAlignment = NSTextAlignmentLeft;
    [purchaseProductView addSubview:speedLabel];
    
    CGFloat topSpaceX = [self adaptiveFromCurrentSuperviewValue:STANDARD_SUPER_VALUE subviewValue:[self productViewTopSpaceX] toPurposeSuperviewValue:availableSize.width];
    
    //button 背景图片
    CGSize imageSize = CGSizeMake(SPEED_BUTTON_WIDTH, PRODUCT_VIEW_HEIGHT);
    UIImage *bgImageGray = [ImageUtils createImageWithColor:[RTSSAppStyle currentAppStyle].navigationBarColor size:imageSize];
   
    //speed button
    CGRect speedButtonRect = CGRectMake(CGRectGetMaxX(speedLabel.frame) + topSpaceX, offsetY, SPEED_BUTTON_WIDTH, PRODUCT_VIEW_HEIGHT);
    selectSpeedButton = [CommonUtils buttonWithType:UIButtonTypeCustom frame:speedButtonRect title:@"1Mbps" bgImageNormal:bgImageGray bgImageHighlighted:nil bgImageSelected:nil addTarget:self action:@selector(speedButtonClicked:) tag:0];
    [selectSpeedButton setTitleColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] forState:UIControlStateNormal];
    selectSpeedButton.titleLabel.font = [RTSSAppStyle getRTSSFontWithSize:14.0f];
    selectSpeedButton.layer.borderColor = [[RTSSAppStyle currentAppStyle] textFieldBorderColor].CGColor;
    selectSpeedButton.layer.borderWidth = 1.f;
    selectSpeedButton.layer.cornerRadius = 6.f;
    selectSpeedButton.layer.masksToBounds = YES;
    
    [purchaseProductView addSubview:selectSpeedButton];
    
    //time label
    CGRect timeLabelRect = CGRectMake(CGRectGetMaxX(selectSpeedButton.frame) + topSpaceX, offsetY, DURATION_LABEL_WIDTH, PRODUCT_VIEW_HEIGHT);
    UILabel *timeLabel = [CommonUtils labelWithFrame:timeLabelRect text:NSLocalizedString(@"TurboBoost_Cell_For_Prompt", nil) textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textFont:[UIFont systemFontOfSize:14.f] tag:0];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [purchaseProductView addSubview:timeLabel];
    
    //time button
    CGRect timeButtonRect = CGRectMake(CGRectGetMaxX(timeLabel.frame) + topSpaceX, offsetY, DURATION_BUTTON_WIDTH, PRODUCT_VIEW_HEIGHT);
    selectTimeButton = [CommonUtils buttonWithType:UIButtonTypeCustom frame:timeButtonRect title:@"4 Hour" bgImageNormal:bgImageGray bgImageHighlighted:nil bgImageSelected:nil addTarget:self action:@selector(timeButtonClicked:) tag:0];
    [selectTimeButton setTitleColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] forState:UIControlStateNormal];
    selectTimeButton.titleLabel.font = [RTSSAppStyle getRTSSFontWithSize:14.0f];
    selectTimeButton.layer.borderColor = [[RTSSAppStyle currentAppStyle] textFieldBorderColor].CGColor;
    selectTimeButton.layer.borderWidth = 1.f;
    selectTimeButton.layer.cornerRadius = 6.f;
    selectTimeButton.layer.masksToBounds = YES;
    [purchaseProductView addSubview:selectTimeButton];
    
    //content seperate line
    UIImageView *contentSeperateLine = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, (CELL_UNFOLD_HEIGHT - CELL_FOLD_HEIGHT) / 2.f - SEPERATOR_LINE_HEIGHT, cellUnfoldSize.width, SEPERATOR_LINE_HEIGHT)];
    contentSeperateLine.backgroundColor= [RTSSAppStyle currentAppStyle].separatorColor;
    [purchaseProductView addSubview:contentSeperateLine];
    CGFloat bottomSpaceX = [self adaptiveFromCurrentSuperviewValue:STANDARD_SUPER_VALUE subviewValue:[self productViewBottomSpacex] toPurposeSuperviewValue:availableSize.width];
    
    offsetY += (CELL_UNFOLD_HEIGHT - CELL_FOLD_HEIGHT)/ 2.f;
    
    //fee label
    CGRect feeLabelRect = CGRectMake(VIEW_PADDING_X, offsetY, FEE_LABEL_WIDTH, PRODUCT_VIEW_HEIGHT);
    feeLabel = [CommonUtils labelWithFrame:feeLabelRect text:@"€0.00" textColor:[[RTSSAppStyle currentAppStyle] textMajorGreenColor] textFont:[RTSSAppStyle getRTSSFontWithSize:16.0f] tag:0];
    feeLabel.textAlignment = NSTextAlignmentLeft;
    feeLabel.backgroundColor = [UIColor clearColor];
    [purchaseProductView addSubview:feeLabel];
    
    //reset button
    CGRect resetButtonRect = CGRectMake(CGRectGetMaxX(feeLabel.frame) + bottomSpaceX, offsetY, RESET_BUTTON_WIDTH, PRODUCT_VIEW_HEIGHT);
    resetButton =[RTSSAppStyle getMajorGreenButton:resetButtonRect target:self action:@selector(resetButtonClicked:) title:NSLocalizedString(@"TurboBoost_Reset_Button_Title", nil)];
     resetButton.titleLabel.font = [RTSSAppStyle getRTSSFontWithSize:14.0f];
    [purchaseProductView addSubview:resetButton];
    
    //submit button
    CGRect submitButtonRect = CGRectMake(CGRectGetMaxX(resetButton.frame) + bottomSpaceX, offsetY, SUBMIT_BUTTON_WIDTH, PRODUCT_VIEW_HEIGHT);
       submitButton =[RTSSAppStyle getMajorGreenButton:submitButtonRect target:self action:@selector(submitButtonClicked:) title:NSLocalizedString(@"TurboBoost_Submit_Button_Title", nil)];
     submitButton.titleLabel.font = [RTSSAppStyle getRTSSFontWithSize:14.0f];
    [purchaseProductView addSubview:submitButton];
}

- (void)initPurchaseResultViewByAvailableFrame:(CGRect)availableFrame {
    CGSize availableSize = availableFrame.size;
    //pruchase result view
    purchaseResultView = [[UIView alloc] initWithFrame:availableFrame];
    purchaseResultView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    purchaseResultView.backgroundColor = [UIColor clearColor];
    
    //gradual bar
//    UIImageView *gradualBar = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, cellUnfoldSize.width, 8.f)];
//    gradualBar.image = [UIImage imageNamed:@"turboboost_gradual_bar"];
//    [purchaseResultView addSubview:gradualBar];
    
    //marked image view
    UIImageView *markedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(VIEW_PADDING_X, 20.f, 6.f, 6.f)];
    markedImageView.image = [ImageUtils createImageWithColor:[[RTSSAppStyle currentAppStyle] buttonMajorColor] size:CGSizeMake(6.f, 6.f)];
    markedImageView.layer.cornerRadius = 3.f;
    markedImageView.layer.masksToBounds = YES;
    [purchaseResultView addSubview:markedImageView];
    [markedImageView release];
    
    //order label
    CGRect orderLabelRect = CGRectMake(CGRectGetMaxX(markedImageView.frame) + 5.f, CGRectGetMinY(markedImageView.frame) - 5.f, [self adaptiveFromCurrentSuperviewValue:STANDARD_SUPER_VALUE subviewValue:165.f toPurposeSuperviewValue:availableSize.width], 35.f);
    orderLabel = [CommonUtils labelWithFrame:orderLabelRect text:nil textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textFont:[RTSSAppStyle getRTSSFontWithSize:14.0f] tag:0];
    orderLabel.contentMode = UIViewContentModeTop;
    orderLabel.textAlignment = NSTextAlignmentLeft;
    orderLabel.backgroundColor = [UIColor clearColor];
    orderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    orderLabel.numberOfLines = 0;
    [purchaseResultView addSubview:orderLabel];
    
    //count down label
    CGRect countDownLabelRect = CGRectMake(CGRectGetMinX(orderLabel.frame), CGRectGetMaxY(orderLabel.frame) + 10.f, CGRectGetWidth(orderLabel.frame), PRODUCT_VIEW_HEIGHT);
    countDownLabel = [CommonUtils labelWithFrame:countDownLabelRect text:nil textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textFont:[RTSSAppStyle getRTSSFontWithSize:14.0f] tag:0];
    countDownLabel.textAlignment = NSTextAlignmentLeft;
    countDownLabel.backgroundColor = [UIColor clearColor];
    [purchaseResultView addSubview:countDownLabel];
    
   
    
    //purchase button
    CGRect purchaseButtonRect = CGRectMake(cellUnfoldSize.width - VIEW_PADDING_X - SUBMIT_BUTTON_WIDTH, 64.f, SUBMIT_BUTTON_WIDTH, PRODUCT_VIEW_HEIGHT);
    UIButton *purchaseButton =[RTSSAppStyle getMajorGreenButton:purchaseButtonRect target:self action:@selector(submitButtonClicked:) title:NSLocalizedString(@"TurboBoost_Cell_Buy_Button_Title", nil)];
    purchaseButton.titleLabel.font = [RTSSAppStyle getRTSSFontWithSize:14.0f];
    [purchaseResultView addSubview:purchaseButton];
    
}
#pragma mark default value
- (void)initDefaultValue {
    flipLeftRight = YES;
    cellFoldSize = CGSizeMake(CGRectGetWidth(belongToTableView.frame), CELL_FOLD_HEIGHT);
    cellUnfoldSize = CGSizeMake(CGRectGetWidth(belongToTableView.frame), CELL_UNFOLD_HEIGHT);
}

#pragma mark layout data
- (void)layoutCellHeaderViewWithAppData:(AppTurboBoostModel *)appData indexPath:(NSIndexPath *)cellIndexPath isEditing:(BOOL)isEditing{
    self.appDataModel = appData;
    self.indexPath = cellIndexPath;
    //app icon
    appIconImageView.image = [UIImage imageNamed:appData.appIcon];
    
    //app name
    appNameLabel.text = appData.appName;
    
    //app band width
    if (isEditing) {
        appBandWidthLabel.text = @"";
    } else {
        if (indexPath.row >= 3) {
            appBandWidthLabel.text = @"-";
        } else {
            if (appData.appRateValue > 0) {
                appBandWidthLabel.text = [NSString stringWithFormat:@"%lldMbps",appData.appRateValue];
            } else {
                appBandWidthLabel.text = @"-";
            }
        }
    }
}

- (void)reloadContentViewByCellActiveStatus {
    BOOL isActive = appDataModel.isActive;
    if (isActive) {
        //展开视图
        self.contentView.frame = CGRectMake(0.f, 0.f, cellUnfoldSize.width, cellUnfoldSize.height);
        int64_t bandWidth = self.appDataModel.appRateValue;
        if (bandWidth > 0) {
            [self loadContentViewByContentType:ContentViewTypeResult];
        } else {
            [self loadContentViewByContentType:ContentViewTypeProduct];
        }
        
    } else {
        //收起内容视图
        self.contentView.frame = CGRectMake(0.f, 0.f, cellFoldSize.width, cellFoldSize.height);
        [self loadContentViewByContentType:ContentViewTypeNone];
        [self resetControlValues];
    }
}

- (void)loadContentViewByContentType:(ContentViewType)type {
    if (type == ContentViewTypeProduct) {
        seperateLineImageView.frame = CGRectMake(0.f, cellUnfoldSize.height - SEPERATOR_LINE_HEIGHT, cellUnfoldSize.width, SEPERATOR_LINE_HEIGHT);
        if (purchaseResultView && purchaseResultView.superview) {
            [purchaseResultView removeFromSuperview];
        }
        [animationContentView addSubview:purchaseProductView];
    } else if (type == ContentViewTypeResult) {
        seperateLineImageView.frame = CGRectMake(0.f, cellUnfoldSize.height - SEPERATOR_LINE_HEIGHT, cellUnfoldSize.width, SEPERATOR_LINE_HEIGHT);
        if (purchaseProductView && purchaseProductView.superview) {
            [purchaseProductView removeFromSuperview];
        }
        [animationContentView addSubview:purchaseResultView];
        [self updateControlDisplay];
    } else {
        seperateLineImageView.frame = CGRectMake(0.f, cellFoldSize.height - SEPERATOR_LINE_HEIGHT, cellFoldSize.width, SEPERATOR_LINE_HEIGHT);
        if (purchaseResultView && purchaseResultView.superview) {
            [purchaseResultView removeFromSuperview];
        }
        if (purchaseProductView && purchaseProductView.superview) {
            [purchaseProductView removeFromSuperview];
        }
    }
}

- (void)resetControlValues {
    //speed
    NSString *speedValue = [NSString stringWithFormat:@"%lld Mbps",appDataModel.appRateValue];
    [selectSpeedButton setTitle:speedValue forState:UIControlStateNormal];
    
    //time
    NSString *timeValue = [NSString stringWithFormat:@"%d Hour",appDataModel.appHour];;
    [selectTimeButton setTitle:timeValue forState:UIControlStateNormal];
    
    //fee
    NSString *feeValue = @"€1.2";
    feeLabel.text = feeValue;
}

- (void)updateControlDisplay {
    int64_t bandWidth = appDataModel.appRateValue;
    if (bandWidth <= 0) {
        appBandWidthLabel.text = @"-";
    } else {
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *adjustDate = [dateFormatter dateFromString:appDataModel.expireDate];
        NSTimeInterval interval = [adjustDate timeIntervalSinceNow];

        int secTotal = interval;
        int day = secTotal / 86400;
        int hour = (secTotal - day * 86400) / 3600;
        int minute = (secTotal - day * 86400 - hour * 3600) / 60;
        int second = secTotal - day * 86400 - hour * 3600 - minute * 60;
        
        if (indexPath.row <= 2) {
            appBandWidthLabel.text = [NSString stringWithFormat:@"%lldMbps", bandWidth];
        }
        
        NSString* currentLanguage = NSLocalizedString(@"Common_Current_Language", nil);
        if (day == 1) {
            if([@"English" isEqualToString:currentLanguage]){
//                orderLabel.text = [NSString stringWithFormat:
//                                       @"You currently have %lldMbps lasting for next %d day %02d:%02d:%02d!",
//                                       bandWidth,
//                                       day,
//                                       hour,
//                                       minute,
//                                       second];
                orderLabel.text = [NSString stringWithFormat:@"You currently have %lldMbps lasting for next",bandWidth];
                countDownLabel.text = [NSString stringWithFormat:@"%d day %02d:%02d:%02d!",day,hour,minute,second];
            }else if([@"zh-Hans" isEqualToString:currentLanguage]){
//                orderLabel.text = [NSString stringWithFormat:
//                                       @"您目前有 %lldMbps 可持续时间 %d day %02d:%02d:%02d!",
//                                       bandWidth,
//                                       day,
//                                       hour,
//                                       minute,
//                                       second];
                orderLabel.text = [NSString stringWithFormat:@"您目前有 %lldMbps 可持续时间",bandWidth];
                countDownLabel.text = [NSString stringWithFormat:@"%d day %02d:%02d:%02d!",day,hour,minute,second];
            }
        }else if (day>1) {
            if([@"English" isEqualToString:currentLanguage]){
//                orderLabel.text = [NSString stringWithFormat:
//                                       @"You currently have %lldMbps lasting for next %d days %02d:%02d:%02d!",
//                                       bandWidth,
//                                       day,
//                                       hour,
//                                       minute,
//                                       second];
                orderLabel.text = [NSString stringWithFormat:@"You currently have %lldMbps lasting for next",bandWidth];
                countDownLabel.text = [NSString stringWithFormat:@"%d days %02d:%02d:%02d!",day,hour,minute,second];

            }else if([@"zh-Hans" isEqualToString:currentLanguage]){
//                orderLabel.text = [NSString stringWithFormat:
//                                       @"您目前有 %lldMbps 可持续时间 %d days %02d:%02d:%02d!",
//                                       bandWidth,
//                                       day,
//                                       hour,
//                                       minute,
//                                       second];
                orderLabel.text = [NSString stringWithFormat:@"您目前有 %lldMbps 可持续时间 ",bandWidth];
                countDownLabel.text = [NSString stringWithFormat:@"%d days %02d:%02d:%02d!",day,hour,minute,second];
            }
        }else{
            if([@"English" isEqualToString:currentLanguage]){
//                orderLabel.text = [NSString stringWithFormat:
//                                       @"You currently have %lldMbps lasting for next %02d:%02d:%02d!",
//                                       bandWidth,
//                                       hour,
//                                       minute,
//                                       second];
                orderLabel.text = [NSString stringWithFormat:@"You currently have %lldMbps lasting for next",bandWidth];
                countDownLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d!",hour,minute,second];
            }else if([@"zh-Hans" isEqualToString:currentLanguage]){
//                orderLabel.text = [NSString stringWithFormat:
//                                       @"您目前有 %lldMbps 可持续时间 %02d:%02d:%02d!",
//                                       bandWidth,
//                                       hour,
//                                       minute,
//                                       second];
                orderLabel.text = [NSString stringWithFormat:@"您目前有 %lldMbps 可持续时间",bandWidth];
                countDownLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d!",hour,minute,second];
            }
        }
    }
}

- (void)flipContentView {
    flipLeftRight = !flipLeftRight;
    [UIView transitionWithView:animationContentView
                        duration:FLIP_ANIMATION_DURATION
                        options:flipLeftRight ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight
                        animations:nil
                        completion:nil];
    if (purchaseProductView && purchaseProductView.superview) {
        [self loadContentViewByContentType:ContentViewTypeResult];
    } else if (purchaseResultView && purchaseResultView.superview) {
        [self loadContentViewByContentType:ContentViewTypeProduct];
    }
}

#pragma mark selected
//用户点击cell时，先调用willselect 然后调用该方法
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self reloadContentViewByCellActiveStatus];
}

#pragma mark button clicked
- (void)speedButtonClicked:(UIButton *)speedButton {
    if (delegate && [delegate respondsToSelector:@selector(turboBoostCell:indexPath:didSelectOperation:withParameters:)]) {
        [delegate turboBoostCell:self indexPath:indexPath didSelectOperation:ClickOperationTypeSelectBandWidth withParameters:nil];
        
    }
}

- (void)timeButtonClicked:(UIButton *)timeButton {
    if (delegate && [delegate respondsToSelector:@selector(turboBoostCell:indexPath:didSelectOperation:withParameters:)]) {
        [delegate turboBoostCell:self indexPath:indexPath didSelectOperation:ClickOperationTypeSelectTime withParameters:nil];
        
    }
}

- (void)resetButtonClicked:(UIButton *)resetButton {
    [self resetControlValues];
    if (delegate && [delegate respondsToSelector:@selector(turboBoostCell:indexPath:didSelectOperation:withParameters:)]) {
        [delegate turboBoostCell:self indexPath:indexPath didSelectOperation:ClickOperationTypeReset withParameters:nil];
        
    }
}

- (void)submitButtonClicked:(UIButton *)submitButton {
    if (delegate && [delegate respondsToSelector:@selector(turboBoostCell:indexPath:didSelectOperation:withParameters:)]) {
        [delegate turboBoostCell:self indexPath:indexPath didSelectOperation:ClickOperationTypeSubmit withParameters:nil];
        
    }
}

- (void)purchaseButtonClicked:(UIButton *)purchaseButton {
    [self flipContentView];
    if (delegate && [delegate respondsToSelector:@selector(turboBoostCell:indexPath:didSelectOperation:withParameters:)]) {
        [delegate turboBoostCell:self indexPath:indexPath didSelectOperation:ClickOperationTypePurchase withParameters:nil];
        
    }
}

#pragma mark dealloc
- (void)dealloc {
    [seperateLineImageView release];
    [headerView release];
    [appIconImageView release];
    [animationContentView release];
    self.indexPath = nil;
    self.appDataModel = nil;
    self.delegate = nil;
    [super dealloc];
}

#pragma mark others
- (CGFloat)adaptiveFromCurrentSuperviewValue:(CGFloat)fromSuperValue subviewValue:(CGFloat)subValue toPurposeSuperviewValue:(CGFloat)toSuperValue {
    return (subValue * 1.f) / (fromSuperValue * 1.f) * toSuperValue;
}

- (CGFloat)productViewTopSpaceX {
    CGFloat spaceX = (cellUnfoldSize.width - VIEW_PADDING_X * 2 - SPEED_LABEL_WIDTH - SPEED_BUTTON_WIDTH - DURATION_LABEL_WIDTH - DURATION_BUTTON_WIDTH) / 3.f;
    return spaceX;
}

- (CGFloat)productViewBottomSpacex {
    CGFloat spaceX = (cellUnfoldSize.width - FEE_LABEL_WIDTH - RESET_BUTTON_WIDTH - SUBMIT_BUTTON_WIDTH - VIEW_PADDING_X * 2.f) / 2.f;
    return spaceX;
}

@end
