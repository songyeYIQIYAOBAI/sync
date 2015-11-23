//
//  MyUsageTableViewCell.m
//  RTSS
//
//  Created by 蔡杰Alan on 14-11-28.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "MyUsageTableViewCell.h"
#import "CommonUtils.h"
#import  "RTSSAppStyle.h"
#import "UsageModel.h"
#import "DateUtils.h"
#import "UsageModel.h"
#import  "EColumnDataModel.h"

#import "RTSSAppDefine.h"
#define kRTSSBasicLabelTag 100
@interface MyUsageTableViewCell (){
    
    UIView *bgImageView;
    
}

@end


@implementation MyUsageTableViewCell
-(void)dealloc{
    [bgImageView release];
    [super dealloc];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self installSubviews];
    }
    return self;
}
-(void)installSubviews{
    
     bgImageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, self.bounds.size.height)];
     bgImageView.backgroundColor =[RTSSAppStyle currentAppStyle].viewControllerBgColor;
     [self.contentView addSubview:bgImageView];

}


-(void)setBackgroundViewColor:(UIColor *)color{
    bgImageView.backgroundColor = color;
}
#pragma mark --private
-(UIImageView*)createLineImageViewWithY:(CGFloat)lineY{
    
    UIImageView *line = [[UIImageView alloc]init];
    line.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    line.frame = CGRectMake(0, lineY, [UIScreen mainScreen].bounds.size.width, 1);
    
    return [line autorelease];
    
}

-(void)setMessureId:(RTSSMessureId)messureId Amount:(long long)amount Tag:(NSInteger)aTag{
    
    CGFloat number = [UsageModel transformeWithNumerical:amount byMessureId:messureId];
    NSString *numberString = [NSString stringWithFormat:@"%.0f",number];
    UILabel *label =(UILabel*)[bgImageView viewWithTag:aTag];
    label.text = numberString;
}


-(void)dynamicInstallLabelWithCount:(NSInteger)count AllEmpty:(BOOL)empty{

    [bgImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat height = 30;
    CGFloat font = 12.0;
    CGFloat width = [UIScreen mainScreen].bounds.size.width/count;
    if (empty) {
        UILabel *label = [CommonUtils labelWithFrame:CGRectMake(0, 7, 120, height) text:@"" textColor:nil textFont:[UIFont systemFontOfSize:font] tag:kRTSSBasicLabelTag];
        [bgImageView addSubview:label];
        return;
    }
    
    
    for (int i = 0; i< count; i++) {
        
        UILabel *label = [CommonUtils labelWithFrame:CGRectMake(width*i, 7, width, height) text:@"" textColor:nil textFont:[UIFont systemFontOfSize:font] tag:i+kRTSSBasicLabelTag];
        label.font = [RTSSAppStyle getRTSSFontWithSize:15.0f];
        //label.backgroundColor = [UIColor redColor];
        [bgImageView addSubview:label];
    }
    [bgImageView addSubview:[self createLineImageViewWithY:bgImageView.bounds.size.height-1]];
    
}
-(void)showTitle:(NSArray *)typeList{
    
    UILabel *dateLabel = (UILabel*)[bgImageView viewWithTag:kRTSSBasicLabelTag];
    dateLabel.textColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
    dateLabel.text = @"DATE";
    
    if (![typeList count]>0) {
        return;
    }
    
    for (int i = 0; i < [typeList count]; i++) {
        
        UILabel *label = (UILabel*)[bgImageView viewWithTag:i+1+kRTSSBasicLabelTag];
        NSDictionary *sub = [typeList objectAtIndex:i];
        NSString *name = [sub objectForKey:@"groupName"];
        NSInteger messureId = [(NSNumber*)[sub objectForKey:@"measureId"]integerValue];
        NSString *unit = [UsageModel unitByMessureId:messureId];
        NSLog(@"unit = %@",unit);
        label.text = [unit length]>0?[NSString stringWithFormat:@"%@(%@)",name,unit]:name;
        label.textColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
        label.font = [RTSSAppStyle getRTSSFontWithSize:15.0f];
    }
}
-(void)showUserDayWithDictionay:(NSDictionary *)dayDictionary{
    
    
    if (!dayDictionary || ![dayDictionary count]>0) {
        return;
    }
    //NSLog(@"day==%@",dayDictionary);
    NSString *dateKey = [dayDictionary.allKeys objectAtIndex:0];
    NSDate *date = [DateUtils dateByDateString:dateKey UseFormatString:@"YYYY-MM-dd"];
    NSString *dateString = [DateUtils getStringDateByDate:date dateFormat:@"dd/MM"];
    UILabel *dateLabel = (UILabel*)[bgImageView viewWithTag:kRTSSBasicLabelTag];
    dateLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    dateLabel.text = dateString;
    
    NSArray *modelArray = [dayDictionary objectForKey:dateKey];
    
    for (int i = 0 ;i < [modelArray count];i++) {
        
        UILabel *label = (UILabel*)[bgImageView viewWithTag:i+1+kRTSSBasicLabelTag];
        EColumnDataModel *model = [modelArray objectAtIndex:i];
        label.text = [NSString stringWithFormat:@"%.0f",[UsageModel transformeWithNumerical:model.value byMessureId:model.messureId]];
        label.textColor = [RTSSAppStyle getFreeResourceColorWithIndex:i];
        label.font = [RTSSAppStyle getRTSSFontWithSize:15.0f];
        
    }

}
@end
