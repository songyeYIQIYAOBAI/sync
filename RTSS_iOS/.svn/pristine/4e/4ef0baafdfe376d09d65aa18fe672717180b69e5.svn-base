//
//  TransationBaseTableViewCell+BussinessLogic.m
//  RTSS
//
//  Created by 蔡杰Alan on 15-2-3.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "TransationBaseTableViewCell+BussinessLogic.h"
#import "CommonUtils.h"
#import "TTRule.h"
#import "RuleManager.h"
@implementation TransationBaseTableViewCell (BussinessLogic)

-(void)transationTableViewCellBind_PiceNegotiationModel:(ProductResource *)model{
    
    self.identify = model.mResourceId;
    
    self.comboSlider.resourceTitleLabel.text = [NSString stringWithFormat:@"%@ (%@)",model.mName, [CommonUtils getUnitName:model.mUnit]];
    
    NSLog(@"name = %@--resID =%@",model.mName,model.mResourceId);
    NSLog(@"unit = %d",model.mUnit);
    
    RuleManager *ruleManeger = [RuleManager sharedRuleManager];
    TTRule *ttRule = [ruleManeger transferRule:model.mResourceId];
    
    self.comboSlider.showMinimumValue = YES;
    self.comboSlider.minimumValue =0;//[CommonUtils getUnitConverteValue:ttRule.mMinOrgAmount AndUnit:model.mUnit];
    self.comboSlider.minimumValueLabel.text = [NSString stringWithFormat:@"%.0f",self.comboSlider.minimumValue ];
    NSLog(@"ttRule Min = %lld--解析后--%f",ttRule.mMinOrgAmount, self.comboSlider.minimumValue );
    
    self.comboSlider.showMaximumValue = YES;
    self.comboSlider.maximumValue = [CommonUtils getUnitConverteValue:model.mTotal AndUnit:model.mUnit];//MIN(model.mTotal, ttRule.mMinOrgAmount);
    self.comboSlider.maximumValueLabel.text = [NSString stringWithFormat:@"%.0f",self.comboSlider.maximumValue];
    NSLog(@"ttRule Max = %lld---解析后max=%f",ttRule.mMaxOrgAmount,[CommonUtils getUnitConverteValue:ttRule.mMaxOrgAmount AndUnit:model.mUnit]);
    NSLog(@"resourcemax = %lld,解析后max=%f",model.mTotal, [CommonUtils getUnitConverteValue:model.mTotal AndUnit:model.mUnit]);
    
    
    self.comboSlider.showResetValue = YES;
   // self.comboSlider.resetValue = [CommonUtils getUnitConverteValue:MIN(model.mRemain, ttRule.mMaxOrgAmount) AndUnit:model.mUnit];
    //self.comboSlider.resetValueLabel.text = [NSString stringWithFormat:@"%.0f",  self.comboSlider.resetValue];
    
    NSLog(@"reset=%lld 解析后reset = %f", model.mRemain,[CommonUtils getUnitConverteValue:model.mRemain AndUnit:model.mUnit]);
    
    
    self.comboSlider.showHistoryValue = NO;
    //  self.comboSlider.historyValue = model.mUsed;
    //  self.comboSlider.historyValueLabel.text = [NSString stringWithFormat:@"%lld", model.mUsed];
    NSLog(@"mused = %lld ,解析后=%.f",model.mUsed,[CommonUtils getUnitConverteValue:model.mUsed AndUnit:model.mUnit]);
    
    self.comboSlider.showCurrentValue = YES;
    self.comboSlider.currentValue =   self.comboSlider.minimumValue;
    self.comboSlider.currentValueLabel.text =[NSString stringWithFormat:@"%.f",self.comboSlider.minimumValue ];
}


-(void)transationTableViewCellBind_PiceNegotiationModel:(ProductResource*)model Rule:(PriceRuleItem*)ruleItem{
    
    self.identify = model.mResourceId;
    self.comboSlider.resourceTitleLabel.text = [NSString stringWithFormat:@"%@ (%@)",model.mName, [CommonUtils getUnitName:model.mUnit]];

    self.comboSlider.showMinimumValue = YES;
    self.comboSlider.minimumValue =[CommonUtils getUnitConverteValue:ruleItem.mMinValue AndUnit:model.mUnit];
    self.comboSlider.minimumValueLabel.text = [NSString stringWithFormat:@"%.0f",self.comboSlider.minimumValue ];
   
    self.comboSlider.showMaximumValue = YES;
    self.comboSlider.maximumValue = [CommonUtils getUnitConverteValue:ruleItem.mMaxValue  AndUnit:model.mUnit];
    self.comboSlider.maximumValueLabel.text = [NSString stringWithFormat:@"%.0f",self.comboSlider.maximumValue];
    
    self.comboSlider.showResetValue = NO;
    self.comboSlider.resetValue = [CommonUtils getUnitConverteValue:model.mTotal AndUnit:model.mUnit];
    self.comboSlider.resetValueLabel.text = [NSString stringWithFormat:@"%.0f",  self.comboSlider.resetValue];
    
   // NSLog(@"total=%lld 解析后total = %f", model.mTotal,[CommonUtils getUnitConverteValue:model.mTotal AndUnit:model.mUnit]);
    self.comboSlider.showHistoryValue = NO;
    //  self.comboSlider.historyValue = model.mUsed;
    //  self.comboSlider.historyValueLabel.text = [NSString stringWithFormat:@"%lld", model.mUsed];
   // NSLog(@"mused = %lld ,解析后=%.f",model.mUsed,[CommonUtils getUnitConverteValue:model.mUsed AndUnit:model.mUnit]);
    
    self.comboSlider.showCurrentValue = YES;
    self.comboSlider.currentValue =   self.comboSlider.resetValue;
    self.comboSlider.currentValueLabel.text =[NSString stringWithFormat:@"%.f", self.comboSlider.currentValue];

}


-(void)transationTableViewCellBind_TransferModel:(ProductResource *)model{
    
    self.identify = model.mResourceId;
    
    self.comboSlider.resourceTitleLabel.text = [NSString stringWithFormat:@"%@ (%@)",model.mName, [CommonUtils getUnitName:model.mUnit]];
    
    NSLog(@"name = %@--resID =%@",model.mName,model.mResourceId);
    NSLog(@"unit = %d",model.mUnit);

    self.comboSlider.showMinimumValue = YES;
    self.comboSlider.minimumValue =0;//[CommonUtils getUnitConverteValue:ttRule.mMinOrgAmount AndUnit:model.mUnit];
    self.comboSlider.minimumValueLabel.text = [NSString stringWithFormat:@"%.0f",self.comboSlider.minimumValue ];
    
    
    self.comboSlider.showMaximumValue = YES;
    self.comboSlider.maximumValue = [CommonUtils getUnitConverteValue:model.mTotal AndUnit:model.mUnit];//MIN(model.mTotal, ttRule.mMinOrgAmount);
    self.comboSlider.maximumValueLabel.text = [NSString stringWithFormat:@"%.0f",self.comboSlider.maximumValue];
    
    NSLog(@"resourcemax = %lld,解析后max=%f",model.mTotal, [CommonUtils getUnitConverteValue:model.mTotal AndUnit:model.mUnit]);
    

    self.comboSlider.showResetValue = YES;
    self.comboSlider.resetValue = [CommonUtils getUnitConverteValue:model.mRemain AndUnit:model.mUnit];
    self.comboSlider.resetValueLabel.text = [NSString stringWithFormat:@"%.0f",  self.comboSlider.resetValue];
    
     NSLog(@"reset=%lld 解析后reset = %f", model.mRemain,[CommonUtils getUnitConverteValue:model.mRemain AndUnit:model.mUnit]);
    
    
    self.comboSlider.showHistoryValue = NO;
 
    NSLog(@"mused = %lld ,解析后=%.f",model.mUsed,[CommonUtils getUnitConverteValue:model.mUsed AndUnit:model.mUnit]);
    
    self.comboSlider.showCurrentValue = YES;
    self.comboSlider.currentValue =   self.comboSlider.minimumValue;
    self.comboSlider.currentValueLabel.text =[NSString stringWithFormat:@"%.f",self.comboSlider.minimumValue ];
    
    

    
    
}

//-(void)transationTableViewCellBind_TransferFormModel:(ProductResource*)model{
//    
//    self.identify = model.mResourceId;
//    
//    self.comboSlider.resourceTitleLabel.text = [NSString stringWithFormat:@"%@ (%@)",model.mName, [CommonUtils getUnitName:model.mUnit]];
//    
//  //  RuleManager *ruleManeger = [RuleManager sharedRuleManager];
//   // TTRule *ttRule = [ruleManeger transferRule:model.mResourceId];
//    
//    self.comboSlider.showMinimumValue = YES;
//    self.comboSlider.minimumValue =0;//[CommonUtils getUnitConverteValue:ttRule.mMinOrgAmount AndUnit:model.mUnit];
//    self.comboSlider.minimumValueLabel.text = [NSString stringWithFormat:@"%.0f",self.comboSlider.minimumValue ];
// //   NSLog(@"ttRule Min = %lld--解析后--%f",ttRule.mMinOrgAmount, self.comboSlider.minimumValue );
//    
//    self.comboSlider.showMaximumValue = YES;
//    self.comboSlider.maximumValue = [CommonUtils getUnitConverteValue:model.mTotal AndUnit:model.mUnit];//MIN(model.mTotal, ttRule.mMinOrgAmount);
//    self.comboSlider.maximumValueLabel.text = [NSString stringWithFormat:@"%.0f",self.comboSlider.maximumValue];
//   // NSLog(@"ttRule Max = %lld---解析后max=%f",ttRule.mMaxOrgAmount,[CommonUtils getUnitConverteValue:ttRule.mMaxOrgAmount AndUnit:model.mUnit]);
//  //  NSLog(@"resourcemax = %lld,解析后max=%f",model.mTotal, [CommonUtils getUnitConverteValue:model.mTotal AndUnit:model.mUnit]);
//    
//    
//    self.comboSlider.showResetValue = YES;
//    self.comboSlider.resetValue = [CommonUtils getUnitConverteValue:model.mRemain AndUnit:model.mUnit];
//    self.comboSlider.resetValueLabel.text = [NSString stringWithFormat:@"%.0f",  self.comboSlider.resetValue];
//    
//   // NSLog(@"reset=%lld 解析后reset = %f", model.mRemain,[CommonUtils getUnitConverteValue:model.mRemain AndUnit:model.mUnit]);
//    
//    
//    self.comboSlider.showHistoryValue = NO;
//    //  self.comboSlider.historyValue = model.mUsed;
//    //  self.comboSlider.historyValueLabel.text = [NSString stringWithFormat:@"%lld", model.mUsed];
//   // NSLog(@"mused = %lld ,解析后=%.f",model.mUsed,[CommonUtils getUnitConverteValue:model.mUsed AndUnit:model.mUnit]);
//    
//    self.comboSlider.showCurrentValue = YES;
//    self.comboSlider.currentValue  = self.comboSlider.resetValue ;
//    self.comboSlider.currentValueLabel.text = [NSString stringWithFormat:@"0"];
//
//   // self.comboSlider.midSlider.sliderControl.value =
//
//    [self.comboSlider.rightItemButton setImage:[UIImage imageNamed:@"common_checked_d"] forState:UIControlStateNormal];
//    [self.comboSlider.rightItemButton setImage:[UIImage imageNamed:@"common_checked_a"] forState:UIControlStateSelected];
//    
//    self.comboSlider.showResourceItemButton = YES;
//    self.comboSlider.showRightItemButton = YES;
//}

//================
#pragma mark --service  Transfer
-(void)transationTableViewCellBind_TransferItemModel:(id <ITransferable> )item{
    
    self.identify = [item getItemId];
    
    self.comboSlider.resourceTitleLabel.text = [item getItemName];
    
    self.comboSlider.showMinimumValue = YES;
    self.comboSlider.minimumValue = 0;
    self.comboSlider.minimumValueLabel.text = [NSString stringWithFormat:@"%.0f",self.comboSlider.minimumValue ];
    
    
    self.comboSlider.showMaximumValue = YES;
    self.comboSlider.maximumValue = [CommonUtils getUnitConverteValue:[item getTotalAmount] AndUnit:[item getUnit]];
    self.comboSlider.maximumValueLabel.text = [NSString stringWithFormat:@"%.0f",self.comboSlider.maximumValue];
    
    
    
    self.comboSlider.showResetValue = NO;
    self.comboSlider.resetValue = [CommonUtils getUnitConverteValue:[item getRemainAmount] AndUnit:[item getUnit]];
    //    self.comboSlider.resetValueLabel.text = [NSString stringWithFormat:@"%.0f",  self.comboSlider.resetValue];
    
    
    
    self.comboSlider.showHistoryValue = NO;
    
    
    self.comboSlider.showCurrentValue = YES;
    self.comboSlider.currentValue = self.comboSlider.minimumValue;
    self.comboSlider.currentValueLabel.text =[NSString stringWithFormat:@"%.f",self.comboSlider.minimumValue ];
    
}
#pragma mark--service TransferForm
-(void)transationTableViewCellBind_TransferFormModel:(id<ITransferable>)model{
    
    self.identify = [model getItemId];
    
    self.comboSlider.resourceTitleLabel.text = [NSString stringWithFormat:@"%@ (%@)",[model getItemName],[CommonUtils getUnitName:[model getUnit]]];
    
    self.comboSlider.showMinimumValue = YES;
    self.comboSlider.minimumValue =0;//[CommonUtils getUnitConverteValue:ttRule.mMinOrgAmount AndUnit:model.mUnit];
    self.comboSlider.minimumValueLabel.text = [NSString stringWithFormat:@"%.0f",self.comboSlider.minimumValue];
    
    self.comboSlider.showMaximumValue = YES;
    self.comboSlider.maximumValue = [model getTotalAmount];
    self.comboSlider.maximumValueLabel.text = [NSString stringWithFormat:@"%.0f", [CommonUtils getUnitConverteValue:[model getTotalAmount] AndUnit:[model getUnit]]];
    
    
    self.comboSlider.showResetValue = YES;
    self.comboSlider.resetValue = [model getRemainAmount];
    self.comboSlider.resetValueLabel.text = [NSString stringWithFormat:@"%.0f", [CommonUtils getUnitConverteValue:[model getRemainAmount] AndUnit:[model getUnit]]];
    NSLog(@"resertvalue = %f",self.comboSlider.resetValue);
    self.comboSlider.showHistoryValue = NO;
    //  self.comboSlider.historyValue = model.mUsed;
    //  self.comboSlider.historyValueLabel.text = [NSString stringWithFormat:@"%lld", model.mUsed];
    //     NSLog(@"mused = %lld ,解析后=%.f",model.mUsed,[CommonUtils getUnitConverteValue:model.mUsed AndUnit:model.mUnit]);
    
    self.comboSlider.showCurrentValue = YES;
    self.comboSlider.currentValue  =  self.comboSlider.resetValue ;
    self.comboSlider.currentValueLabel.text = @"0";
    
    // self.comboSlider.midSlider.sliderControl.value =
    
    [self.comboSlider.rightItemButton setImage:[UIImage imageNamed:@"common_checked_d"] forState:UIControlStateNormal];
    [self.comboSlider.rightItemButton setImage:[UIImage imageNamed:@"common_checked_a"] forState:UIControlStateSelected];
    
    self.comboSlider.showResourceItemButton = YES;
    self.comboSlider.showRightItemButton = YES;
}

-(void)transationTableViewCellBind_PiceNegotiationModelWithTitle:(NSString *)title Array:(NSArray*)productOffers{
    NSString * mUnit = nil;
    float totalAmount = .0;
    if (productOffers.count > 0 ) {
        ProductOffer * productOffer = [productOffers lastObject];
        if (productOffer.mResources.count > 0) {
            ProductResource * resource = [productOffer.mResources firstObject];
            mUnit = [CommonUtils getUnitName:resource.mUnit];
            totalAmount = resource.mTotal;
        }
    }
    self.comboSlider.resourceTitleLabel.text = [NSString stringWithFormat:@"%@ (%@)",title,mUnit];
    
    //
    ProductOffer * productOffer = nil;
    if (productOffers.count > 0) {
        productOffer = [productOffers lastObject];
    }
    
    //minimumValue
    self.comboSlider.showMinimumValue = YES;
    self.comboSlider.minimumValue = 0.0;
    self.comboSlider.minimumValueLabel.text = [NSString stringWithFormat:@"%.0f",self.comboSlider.minimumValue];
    
    
    //maximumValue
    self.comboSlider.showMaximumValue = YES;
    self.comboSlider.maximumValue = totalAmount;
    self.comboSlider.maximumValueLabel.text = [NSString stringWithFormat:@"%.0f",self.comboSlider.maximumValue];
    
    //resetValue
    self.comboSlider.showResetValue = NO;
    self.comboSlider.resetValue = 0;
    
    //currentValue
    self.comboSlider.showCurrentValue = YES;
    self.comboSlider.currentValue =   self.comboSlider.minimumValue;
    self.comboSlider.currentValueLabel.text =[NSString stringWithFormat:@"%.f", self.comboSlider.minimumValue];
    
    
}



@end
