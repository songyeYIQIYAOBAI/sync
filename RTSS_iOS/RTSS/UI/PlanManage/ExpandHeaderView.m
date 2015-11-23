//
//  ExpandHeaderView.m
//  RTSS
//
//  Created by 蔡杰Alan on 14-11-14.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "ExpandHeaderView.h"
#import "UIView+RTSSAddView.h"

#import "RTSSAppStyle.h"
#import "CommonUtils.h"

@interface HeaderCard: UIView

-(void)updateTitle:(NSString*)title Detail:(NSString*)detail;

-(void)updateDetailInfo:(NSString*)info;

@end

@interface HeaderCard (){
    UILabel *titleLabel;
    UILabel *detailLabel;
  
}

@end

@implementation HeaderCard

-(void)dealloc{
    
    [titleLabel release];
    [detailLabel release];
    
    [super dealloc];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self installSubviewsWithFrame:frame];
    }
    return self;
}



-(void)installSubviewsWithFrame:(CGRect)frame{
    CGFloat labelWidth = 150;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, labelWidth, 20)];
    titleLabel.textColor =  [RTSSAppStyle currentAppStyle].textMajorColor;
    titleLabel.font = [RTSSAppStyle getRTSSFontWithSize:15.0f];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.numberOfLines = 1;
    [self addSubview:titleLabel];
    
    detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+10, 10, labelWidth, 20)];
    detailLabel.textColor =  [RTSSAppStyle currentAppStyle].textSubordinateColor;
    detailLabel.font = [RTSSAppStyle getRTSSFontWithSize:13.0f];
    detailLabel.textAlignment = NSTextAlignmentLeft;
    detailLabel.numberOfLines = 1;
    [self addSubview:detailLabel];
    
    UIImageView *line = [[UIImageView alloc]init];
    line.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    line.frame = CGRectMake(0, self.bounds.size.height-1, self.bounds.size.width, 1);
    [self addSubview:line];
    [line release];
}

-(void)updateTitle:(NSString *)title Detail:(NSString *)detail{
    titleLabel.text = title;
    detailLabel.text = detail;
}

-(void)updateDetailInfo:(NSString *)info{
    if (!info || ![info length] > 0 ) {
        return;
    }
    detailLabel.text = info;
}

@end

@interface ExpandHeaderView (){
    
    UIScrollView *scrollView;
}

@end
@implementation ExpandHeaderView{
      NSInteger subCount;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self installSubViewsWithFrame:frame];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame subViewCount:(NSInteger)count{
    self = [super initWithFrame:frame];
    if (self) {
        subCount = count;
        scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        scrollView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
        scrollView.bounces = NO;
        [self addSubview:scrollView];
        [self installSubviewsWithCount:count];
    }
    return self;
}
-(void)installSubviewsWithCount:(NSInteger)count{
    CGFloat height = 40.0f;
   
    for (NSInteger i = 0; i<count; i++) {
        
        HeaderCard *headerCard = [[HeaderCard alloc]initWithFrame:CGRectMake(0, height*i, self.bounds.size.width, height)];
        [headerCard updateTitle:@"Billing Type" Detail:@"PREPAID"];
        headerCard.tag = count;
        [scrollView addSubview:headerCard];
        [headerCard release];
        
    }
    [self updateFrame];
    
}
-(void)updateFrame{
    CGFloat height = 40.0f;
    scrollView.contentSize = CGSizeMake(self.bounds.size.width, height*subCount);
    CGRect bounds = self.bounds;
    bounds.size = scrollView.contentSize;
    self.bounds = bounds;
    scrollView.frame = self.bounds;
}
-(void)installSubViewsWithFrame:(CGRect)frame{
//    HeaderCard *card1 = [[HeaderCard alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 40)];
//    card1.backgroundColor = [UIColor clearColor];
//    card1.tag = 1;
//    [card1 updateTitle:@"" Detail:@""];
//    [self addSubview:card1];
//    [card1 release];
    CGFloat height = 40.0f;
    
    HeaderCard *card2 = [[HeaderCard alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, height)];
    card2.tag = 2;
    card2.backgroundColor = [UIColor clearColor];
    [card2 updateTitle:NSLocalizedString(@"Plan_Detail_Header_Type", nil) Detail:@""];
    [self addSubview:card2];
    [card2 release];
    
    HeaderCard *card3 = [[HeaderCard alloc]initWithFrame:CGRectMake(0, 40, self.bounds.size.width, height)];
    card3.tag = 3;
    [card3 updateTitle:NSLocalizedString(@"Plan_Detail_Header_Billing_Type", nil) Detail:@""];
    card3.backgroundColor = [UIColor clearColor];
    [self addSubview:card3];
    [card3 release];
    
    HeaderCard *card4 = [[HeaderCard alloc]initWithFrame:CGRectMake(0, 80, self.bounds.size.width, height)];
     card4.tag = 4;
    [card4 updateTitle:NSLocalizedString(@"Plan_Detail_Header_Changes", nil) Detail:@""];
     card4.backgroundColor = [UIColor clearColor];
    [self addSubview:card4];
    [card4 release];
}

-(void)setPlanName:(NSString *)name Type:(NSString *)aType BillingType:(NSString *)aBilling Changes:(NSString *)aChanges{
    HeaderCard *card1 = (HeaderCard*)[self viewWithTag:1];
    [card1 updateDetailInfo:name];
    //HeaderCard *card2 = (HeaderCard*)[self viewWithTag:2];
    //[card2 updateDetailInfo:aType];
    //HeaderCard *card3 = (HeaderCard*)[self viewWithTag:3];
    //[card3 updateDetailInfo:aBilling];
    HeaderCard *card4 = (HeaderCard*)[self viewWithTag:4];
    [card4 updateDetailInfo:aChanges];
}
-(void)setType:(NSInteger)iType{
    
    NSString *title;
    switch (iType) {
        case 1:{
            title = @"connective Recharge";
        }
            break;
        case 2:{
             title = @"SLA";
            break;
        }
            
        default:{
            title = @"";
        }
            break;
    }
    [self updateWithtag:2 title:title];
    
}
-(void)setBillingType:(NSInteger)iBillingType{
    
    NSString *title;
    switch (iBillingType) {
        case 1:{
            title = @"PREPAID";
        }
            break;
        case 2:{
            title = @"POSTPAID";
        }
            
        default:{
            title = @"";
        }
            break;
    }
    [self updateWithtag:3 title:title];
}

-(void)setPrice:(long long)llPrice{
    
    NSString *title = [NSString stringWithFormat:@"%@%.0f",NSLocalizedString(@"Currency_Unit", nil),[CommonUtils formatMoneyFromPennyToYuan:llPrice]];
    [self updateWithtag:4 title:title];
}
-(void)updateWithtag:(NSInteger)tag title:(NSString*)aTitle{
     HeaderCard *card = (HeaderCard*)[self viewWithTag:tag];
    [card updateDetailInfo:aTitle];
}

@end