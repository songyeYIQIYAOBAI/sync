//
//  BalanceDetailCell.m
//  RTSS
//
//  Created by tiger on 14-11-29.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "BalanceDetailCell.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"
#import "RTSSAppDefine.h"

#define CONTROL_LEFT_BADDING    15
#define CONTROL_RIGHT_BADDING   15
#define INTER_PADDING           60
#define LABLE_WIDTH             80
#define LABLE_HEIGHT            30


@interface BalanceDetailCell()
{
    UILabel * title;
    UILabel * total;
    UIImageView *line;
}
@end

@implementation BalanceDetailCell
@synthesize  model, retainLabel;

- (void)awakeFromNib {
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutContentView];
    }
    return self;
}

-(void)layoutContentView
{
    title = [CommonUtils labelWithFrame:CGRectZero text:nil textColor:[RTSSAppStyle currentAppStyle].textMajorColor textFont:[RTSSAppStyle getRTSSFontWithSize:12.0f] tag:0];
    title.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:title];

    retainLabel = [CommonUtils labelWithFrame:CGRectZero text:nil textColor:[RTSSAppStyle currentAppStyle].textMajorColor textFont:[RTSSAppStyle getRTSSFontWithSize:12.0f] tag:0];
    [self.contentView addSubview:retainLabel];
    
    total = [CommonUtils labelWithFrame:CGRectZero text:nil textColor:[RTSSAppStyle currentAppStyle].textMajorColor textFont:[RTSSAppStyle getRTSSFontWithSize:12.0f] tag:0];
    [self.contentView addSubview:total];
    
    //分割线
    line = [[UIImageView alloc]init];
    line.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    line.frame = CGRectZero;
    [self addSubview:line];
   
}

-(void)setModel:(MobileUsageModel *)newModel
{
    if (model!=nil&&model != newModel) {
        [model release];
        model = nil;
    }
    model = [newModel retain];

    CGFloat height = [BalanceDetailCell heightForTitle:newModel]-20;
    self.bounds = CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, height+20);
    CGSize cellSize = self.bounds.size;
    CGFloat labelwidth = (PHONE_UISCREEN_WIDTH-120)/2;
    title.frame = CGRectMake(20, (cellSize.height-height)/2, 120, height);
    retainLabel.frame = CGRectMake(140, (cellSize.height-height)/2, labelwidth, height);
    total.frame = CGRectMake(labelwidth+130, (cellSize.height-height)/2, labelwidth, height);
    line.frame = CGRectMake(0, self.bounds.size.height-1,PHONE_UISCREEN_WIDTH, 1);
    title.text = newModel.title;
    retainLabel.text = [NSString stringWithFormat:@"%lld%@", newModel.remain ,newModel.unitForRemain];
    total.text = [NSString stringWithFormat:@"%lld%@", newModel.total ,newModel.unitForTotal];
    
}
+(CGFloat)heightForTitle:(MobileUsageModel *)model{
    
   return  [CommonUtils calculateTextSize:model.title constrainedSize:CGSizeMake(120, MAXFLOAT) textFont:[RTSSAppStyle getRTSSFontWithSize:12.0f] lineBreakMode:NSLineBreakByWordWrapping].height+32 ;
}

-(void)dealloc
{
    [model release];
    [super dealloc];
}

@end
