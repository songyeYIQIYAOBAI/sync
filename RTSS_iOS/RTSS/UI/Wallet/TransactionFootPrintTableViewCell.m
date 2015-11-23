//
//  TransactionFootPrintTableViewCell.m
//  RTSS
//
//  Created by 蔡杰 on 14-10-29.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "TransactionFootPrintTableViewCell.h"
#import "CommonUtils.h"
#import "UILabel+LabelTextColor.h"
#import "RTSSAppStyle.h"
#import "RTSSAppDefine.h"
#import "DateUtils.h"

#define kRTSSLineHeight 30
#define kRTSSImageViewHeight  30





@interface TransactionFootPrintTableViewCell (){
    ButtonItemView *markImageView;
}
@property(retain,nonatomic)UILabel *dateLael;
@property(retain,nonatomic)UILabel *infoLabel;
@end

@implementation TransactionFootPrintTableViewCell


-(void)dealloc{
    [_dateLael release];
    [_infoLabel release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 44);
        UIImageView * iv = [[UIImageView alloc]init];
        self.backgroundView = iv;
        [iv release];
        self.backgroundView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    }
    return self;
}

#pragma mark --Setter

-(UILabel *)dateLael{
    
    if (!_dateLael) {
        _dateLael = [[UILabel alloc]initWithFrame:CGRectZero];
        //_dateLael.text = @"20141009";
        [_dateLael setTextAuxiliaryColor];
        _dateLael.textAlignment = NSTextAlignmentRight;
        _dateLael.font = [RTSSAppStyle getRTSSFontWithSize:12.0f];
        _dateLael.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    }
    return _dateLael;
    
}

-(UILabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        //_infoLabel.text = @"EnglishEnglish";
        [_infoLabel setTextMainColor];
        _infoLabel.textAlignment = NSTextAlignmentLeft;
        _infoLabel.font = [RTSSAppStyle getRTSSFontWithSize:12.0f];
       _dateLael.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    }
    return _infoLabel;
}

-(ButtonItemView *)markImageView{
    
    if (!markImageView) {
        markImageView.layer.cornerRadius = kRTSSImageViewHeight/2;
        markImageView = [ButtonItemView buttonItemViewWithFrame:CGRectMake(self.bounds.size.width/2-kRTSSImageViewHeight/2, kRTSSLineHeight, kRTSSImageViewHeight, kRTSSImageViewHeight) interval:10 Image:nil backGroundType:ButtonItemViewTypeDefaule buttonType:ButtonItemViewButtonTypeImageView Tag:100];
        
    }
      return markImageView;
    
}

-(void)updateDate:(NSString *)date Info:(NSString*)info ImageString:(NSString *)imageString type:(TransactionFootPrintTableViewCellType)tag bgType:(ButtonItemViewType)type{
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake((self.bounds.size.width - 2)/2.0, 0, 2, kRTSSLineHeight)];
    line.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    [self addSubview:line];
    [line release];
    
    [self markImageView].imageString = imageString;
    [self markImageView].layer.cornerRadius = self.markImageView.bounds.size.width/2.0;
    
    switch (type) {
        case ButtonItemViewTypeGreen:
            self.markImageView.type = ButtonItemViewTypeGreen;
            break;
        case ButtonItemViewTypeBlue:
            self.markImageView.type = ButtonItemViewTypeBlue;
            break;
        case ButtonItemViewTypeOrangle:
            self.markImageView.type = ButtonItemViewTypeOrangle;
            break;
        default:
            break;
    }
    [self.contentView addSubview:[self markImageView]];
    
    CGRect leftFrame = CGRectMake(0, CGRectGetMinY(self.markImageView.frame)+5, self.bounds.size.width/2-kRTSSImageViewHeight/2-10, 20);
    CGRect rightFrame = CGRectMake(self.bounds.size.width/2+kRTSSImageViewHeight/2+10, CGRectGetMinY(self.markImageView.frame)+5, self.bounds.size.width/2-kRTSSImageViewHeight/2-10, 20);
    if (tag == TransactionFootPrintTableViewCellTypeChange) {
        self.dateLael.frame = rightFrame;
        self.infoLabel.frame = leftFrame;
        self.dateLael.textAlignment = NSTextAlignmentLeft;
        self.infoLabel.textAlignment = NSTextAlignmentRight;
    }else{
        self.dateLael.frame = leftFrame;
        self.infoLabel.frame = rightFrame;
        self.dateLael.textAlignment = NSTextAlignmentRight;
        self.infoLabel.textAlignment = NSTextAlignmentLeft;
    }
    NSDateFormatter * formart = [[NSDateFormatter alloc] init];
    self.dateLael.text = date;
    self.infoLabel.text = info;
    [self.contentView addSubview:self.dateLael];
    [self.contentView addSubview:self.infoLabel];
}



- (void)awakeFromNib{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
