//
//  ServiceRequestCell.m
//  RTSS
//
//  Created by 蔡杰Alan on 15-1-27.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "ServiceRequestCell.h"
#import "RTSSAppStyle.h"
#import "DateUtils.h"
#define kLabelHeight 15.0f
#define kLabelFront  12.0f

#define kLeftEdge  110.0f
#define kTopEdge   25.0f
#define kLabelSpace 0.0f
#define kShowButtonWH 30.0f

@interface ServiceRequestCell (){
    UIImageView *_lastLineImageView;
}


//@property(nonatomic,retain)UIImageView *lastLineImageView;

@end

@implementation ServiceRequestCell

-(void)dealloc{
    
    [_delegate release];
    [_idLabel release];
    [_titleLabel release];
    [_statusLabel release];
    [_lastLineImageView release];
    [super dealloc];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    //背景图
    _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [ServiceRequestCell serviceRequestCellFixedHeight])];
   // _bgImageView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    [self addSubview:_bgImageView];
    

    CGFloat width = [UIScreen mainScreen].bounds.size.width-kLeftEdge;
    //ID
    _idLabel = [[UILabel alloc]initWithFrame:CGRectMake(kLeftEdge, kTopEdge, width, kLabelHeight)];
   // _idLabel.text = @"ID:123234345435636";
    _idLabel.textAlignment = NSTextAlignmentLeft;

    _idLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    _idLabel.font = [RTSSAppStyle getRTSSFontWithSize:kLabelFront];
    [_bgImageView addSubview:_idLabel];
    
    //Title
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kLeftEdge,CGRectGetMaxY(_idLabel.frame)+kLabelSpace, width, kLabelHeight)];
  //  _titleLabel.text = @"Title:manmanananfADSFS";
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    _titleLabel.font = [RTSSAppStyle getRTSSFontWithSize:kLabelFront];
    [_bgImageView addSubview:_titleLabel];
    
    //status
    _statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(kLeftEdge, CGRectGetMaxY(_titleLabel.frame)+kLabelSpace, width, kLabelHeight)];
    //_statusLabel.text = @"Status:Closed";
    _statusLabel.textAlignment = NSTextAlignmentLeft;
    _statusLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    _statusLabel.font = [RTSSAppStyle getRTSSFontWithSize:kLabelFront];
    [_bgImageView addSubview:_statusLabel];
   
    //showButton
    _showButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat showButtonX = kLeftEdge - 10 -kShowButtonWH;
    CGFloat showButtonY = (CGRectGetMaxY(_statusLabel.frame)-CGRectGetMinY(_idLabel.frame)-kShowButtonWH)/2+kTopEdge;
    _showButton.frame = CGRectMake(showButtonX, showButtonY, kShowButtonWH, kShowButtonWH);
    //CGRectMake(85, 40, kShowButtonWH, kShowButtonWH);
    _showButton.layer.cornerRadius = kShowButtonWH/2;
    _showButton.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    [_bgImageView addSubview:_showButton];
    
    //细线  根据showButton 位置确定
    [self addLineViewWithPoint:CGPointMake(CGRectGetMidX(_showButton.frame), 0) lineHeight:CGRectGetMinY(_showButton.frame)-2];
   _lastLineImageView =  [[self addLineViewWithPoint:CGPointMake(CGRectGetMidX(_showButton.frame), CGRectGetMaxY(_showButton.frame)+2) lineHeight: [ServiceRequestCell serviceRequestCellFixedHeight]-CGRectGetMaxY(_showButton.frame)] retain];
//CGPointMake(100, 70)
    
    //dateLabel
    _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMidY(_showButton.frame)-kLabelHeight/2, CGRectGetMinX(_showButton.frame)-8, kLabelHeight)];
   // _dateLabel.text = @"12/01/2015";
    _dateLabel.textAlignment = NSTextAlignmentRight;
    _dateLabel.textColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
    _dateLabel.font = [RTSSAppStyle getRTSSFontWithSize:kLabelFront];
    [_bgImageView addSubview:_dateLabel];

    [self.contentView addSubview:_bgImageView];
    
}

-(UIImageView*)addLineViewWithPoint:(CGPoint)orign  lineHeight:(CGFloat)height{
    UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(orign.x, orign.y,2, height)];
    lineView.backgroundColor =[RTSSAppStyle currentAppStyle].navigationBarColor;
    [_bgImageView addSubview:lineView];
    
    return [lineView autorelease];
}

+(CGFloat)serviceRequestCellFixedHeight{
    
    return 90.0f;
}
-(void)setCellBlackColor:(UIColor*)color{
    
    _bgImageView.backgroundColor = color;

}

-(void)updateData:(NSDictionary *)dic{
    if (!dic) {
        return;
    }
    
    _dateLabel.text = [DateUtils getStringDateByDate:[DateUtils  dateByDateString:[dic objectForKey:@"raisedDate"] UseFormatString:@"yyyyMMddHHmmss"] dateFormat:@"dd/MM/yyyy"];
    
    _idLabel.text = [NSString stringWithFormat:@"%@ : %@",NSLocalizedString(@"Service_Request_Cell_IdLabel_Title", nil),[dic objectForKey:@"problemId"]];
    _titleLabel.text = [NSString stringWithFormat:@"%@ : %@",NSLocalizedString(@"Service_Request_Cell_TitleLabel_Title", nil),[dic objectForKey:@"title"]];
    NSInteger status = [[dic objectForKey:@"status"]integerValue];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"Service_Request_Cell_StatusLabel_Title", nil),[self covertStatus:status]]];
    [str addAttribute:NSForegroundColorAttributeName value:[self covertStatusColor:status] range:NSMakeRange(7, [str length]-7)];
    _statusLabel.attributedText =str;
    [str release];
    [_showButton setBackgroundColor:[self showButtonBgColor:status]];
    [_showButton setImage:[self showButtonImage:status] forState:UIControlStateNormal];
    
    
}

-(void)addLastLine {
    
    [_bgImageView addSubview:_lastLineImageView];
}
-(void)removeLastLine{
    
    [_lastLineImageView removeFromSuperview];
}

-(NSString*)covertStatus:(NSInteger)status{
    
    switch (status) {
            
            
        case 1:{
            
            return NSLocalizedString(@"Service_Request_categoryId_Open", nil);
            break;
        }
        case 2:{
            return NSLocalizedString(@"Service_Request_categoryId_Resolved", nil);
            break;
        }
        case 3:{
            return NSLocalizedString(@"Service_Request_categoryId_Rejected", nil);
            break;
        }
        case 4:{
            return NSLocalizedString(@"Service_Request_categoryId_ReOpen", nil);
            break;
        }
        case 5:{
            return NSLocalizedString(@"Service_Request_categoryId_Closed", nil);
            break;
        }
        default:
            return @"";
            break;
    }
}
-(UIColor*)covertStatusColor:(NSInteger)status{
    
    return [RTSSAppStyle getFreeResourceColorWithIndex:status-1];
}

-(UIColor*)showButtonBgColor:(NSInteger)status{
    
    return [RTSSAppStyle getFreeResourceColorWithIndex:status-1];
}


-(UIImage*)showButtonImage:(NSInteger)status{
    
    switch (status) {
        case 0:{
            return [UIImage imageNamed:@"service_request_wlan.png"];
            break;
        }
            
        case 1:{
            
            return [UIImage imageNamed:@"service_request_phone.png"];
            break;
        }
            
        default:
            return nil;
            break;
    }
}


#pragma mark --Action
-(void)tapIcon:(id)sender{
    
    if (_delegate && [_delegate respondsToSelector:@selector(tapActionWithserviceRequest:)]) {
        [_delegate tapActionWithserviceRequest:self];
    }
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
