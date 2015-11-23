//
//  PriceNegotiationViewController.m
//  RTSS
//
//  Created by 蔡杰Alan on 15-2-3.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "PriceNegotiationViewController.h"

#import "TransactionPanelPNView.h"
#import "PriceRule.h"
#import "PriceRuleItem.h"

@interface PriceNegotiationViewController ()<TransactionPanelViewDelegate,AlertControllerDelegate>
@property(nonatomic,retain)NSMutableDictionary *resourceIDDic;

@property(nonatomic,assign)NSInteger month;
@end

@implementation PriceNegotiationViewController

#pragma mark --Life
-(void)dealloc{
   // [_priceRule release];
    [_resourceIDDic release];
    [super dealloc];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"Price Negotiation";
    
     [self.transactionView.panelView.submitButton setTitle:@"Buy" forState:UIControlStateNormal];
}


-(void)loadView{
    
    [super loadView];
    
//    [self loadTransactionViewWtihFrame:CGRectMake(kTransactionViewLREdge, kTransactionViewTopEdge, PHONE_UISCREEN_WIDTH-2*kTransactionViewLREdge, PHONE_UISCREEN_HEIGHT-kTransactionViewTopEdge-kTransactionViewBottomEdge-64) bindTransationCell:[TransationBaseTableViewCell class] bindTransactionView:[TransactionPanelPNView class]];
    
    [self loadTransactionViewWtihFrame:CGRectMake(kTransactionViewLREdge, kTransactionViewTopEdge, PHONE_UISCREEN_WIDTH-2*kTransactionViewLREdge, PHONE_UISCREEN_HEIGHT-kTransactionViewTopEdge-kTransactionViewBottomEdge-64) bindTransationCell:[TransationBaseTableViewCell class] bindTransactionView:[TransactionPanelBaseView class]];

}


-(void)loadProductResourceData:(NSArray*)productResources {
    
    for (ProductResource *productResource in productResources) {
        
        [self.dataSourceList addObject:productResource];
        
        NSDictionary *dic = @{kResourceName:productResource.mName,
                              kResourceUnit:[NSNumber numberWithInt:productResource.mUnit],
                              kResourceAmount:[NSNumber numberWithLongLong:productResource.mTotal]};
        
        [self.resourceUnitAndName setObject:dic forKey:productResource.mResourceId];
    }
    [self.transactionView.tableView reloadData];
    
}
-(void)loadData{
    
    
    for (ProductResource *productRes in self.dataSourceList) {
        
        
//        NSDictionary *dic = [self.resourceUnitAndName objectForKey:productRes.mResourceId];
//        
//        NSInteger unit = [[dic objectForKey:kResourceUnit]integerValue];
//        
//        PriceRuleItem *ruleItem = [(NSDictionary*)self.priceRule.mRuleItems objectForKey:productRes.mResourceId];
//        
//        [self.resourceIDDic setObject:[NSNumber numberWithFloat:[CommonUtils getUnitConverteValue:ruleItem.mMinValue AndUnit:unit]]forKey:productRes.mResourceId];
        
    }
    
    
    self.transactionView.panelView.delegate = self;
    
    //mDurations 数据类型NSNumber
    
    __block NSMutableArray *numberToString = [NSMutableArray array];
    [self.priceRule.mDurations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSNumber *number = (NSNumber*)obj;
        NSString *string = [NSString stringWithFormat:@"%@",number];
        
        [numberToString addObject:string];
        
        
    }];

    if (numberToString && numberToString.count > 0) {
        self.month = [[numberToString objectAtIndex:0]integerValue];

    }
    
    [self.transactionView.panelView setMothDurtions:numberToString];
    
    [self.transactionView.tableView reloadData];
}

#pragma mark --setProperty
-(NSMutableDictionary *)resourceIDDic{
    
    if (!_resourceIDDic) {
        _resourceIDDic = [[NSMutableDictionary alloc]init];
    }
    return _resourceIDDic;
}
#pragma mark -transactionView Delegate override

-(TransationBaseTableViewCell *)transactionView_TableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentify = [NSString stringWithFormat:@"CellIDentify_Row%d_Section%d",indexPath.row,indexPath.section];
    NSLog(@"%@",CellIdentify);
    TransationBaseTableViewCell *cell =(TransationBaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentify];
    
    if (cell == nil) {
        NSLog(@"nil");
        cell = [[[TransationBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentify]autorelease];
        //数据模型绑定
                if ([self.dataSourceList count] >0 ) {
                    ProductResource *product = [self.dataSourceList objectAtIndex:indexPath.row];
                    
                    PriceRuleItem *ruleItem = [self.priceRule.mRuleItems objectForKey:product.mResourceId];
                    
                    [cell transationTableViewCellBind_PiceNegotiationModel:product Rule:ruleItem];
                }
        
        [self.storeCell setObject:cell forKey:CellIdentify];
        [self setCellProperty:cell cellForRowAtIndexPath:indexPath];
        
      
        
    }else{
        
      
        
    }
    
    return cell;
}


-(void)transactionView:(TransactionView *)transationView transationTableViewCell:(TransationBaseTableViewCell *)cell onSliderTouchUpInside:(ComboSlider *)comboSlider{
    
    //这里进行数据的变更
   // [super transactionView:transationView transationTableViewCell:cell onSliderTouchUpInside:comboSlider];
    
    
    //抬手时判断
    CGFloat delta = comboSlider.currentValue - comboSlider.resetValue;
    
    if (fabs(delta) > 0) {
    
        [self.resourceIDDic setValue:[NSNumber numberWithFloat:delta] forKey:cell.identify];
        
    }else{
        
        [self.resourceIDDic removeObjectForKey:cell.identify];
    }
    
    [self installPanellData];
}

-(void)transactionView:(TransactionView *)transationView transationTableViewCell:(TransationBaseTableViewCell *)cell onSliderValueChanged:(ComboSlider *)comboSlider{
    
   //改变当前的值
    comboSlider.currentValue = comboSlider.midSlider.sliderControl.value;
    comboSlider.currentValueLabel.text = [NSString stringWithFormat:@"%.0f",comboSlider.currentValue];
    
    
    //CGFloat delta = fabsf(comboSlider.currentValue - comboSlider.resetValue);

    
   // [self.resourceIDDic setValue:[NSNumber numberWithFloat:delta] forKey:cell.identify];
    
   //[self installPanellData];
    
}

#pragma mark--OverRide
-(void)reset{
    
    for (NSString *cellIdentify in self.storeCell.allKeys) {
        TransationBaseTableViewCell *cell = [self.storeCell objectForKey:cellIdentify];
        
        [cell.comboSlider setCurrentValue:cell.comboSlider.resetValue animated:NO];
        
        cell.comboSlider.currentValueLabel.text = [NSString stringWithFormat:@"%.0f",cell.comboSlider.resetValue];
    }
    
    CGFloat money = [CommonUtils getUnitConverteValue:self.currentProductPrice AndUnit:UnitForMoney];
    self.transactionView.panelView.feeValueLabel.text = [NSString stringWithFormat:@"€%.2f",money];
}
-(void)submit{
    
    [super submit];
    
}

-(void)sureSubmit{
    
     [super sureSubmit];
}


-(void)installPanellData{
    
    //self.transactionView.panelView.detailLabel.text = @"Please select a Month!";
    self.transactionView.panelView.feeLabel.text = @"Fee:";
    
    CGFloat money = [CommonUtils getUnitConverteValue:self.currentProductPrice AndUnit:UnitForMoney];

   
    for (__unused NSString * key in self.resourceIDDic) {
        
        NSDictionary *dic = [self.resourceUnitAndName objectForKey:key];
        NSInteger unit = [[dic objectForKey:kResourceUnit]integerValue];
        CGFloat amount = [[self.resourceIDDic objectForKey:key] floatValue];
        if (0 < amount) {
            if (1 == unit) {
                money += ((int)(amount + 0.5)) * 0.015;
            } else if (3 == unit) {
                money += ((int)(amount + 0.5)) * 0.05;
            } else {
                money += ((int)(amount + 0.5)) * 0.01;
            }
        } else {
            if (1 == unit) {
                money += ((int)(amount - 0.5)) * 0.015;
            } else if (3 == unit) {
                money += ((int)(amount - 0.5)) * 0.05;
            } else {
                money += ((int)(amount - 0.5)) * 0.01;
            }
        }
    }
  // money =  [CommonUtils getUnitConverteValue:self.priceRule.mCharge AndUnit:UnitForMoney];
    
    money = money *(1-(self.month-12)*0.014);
    
    self.transactionView.panelView.feeValueLabel.text = [NSString stringWithFormat:@"€%.2f",money];
}
#pragma mark ---panelDelegate
-(void)TransactionPanelPNView:(TransactionPanelBaseView *)transactionView changeMoth:(NSInteger)month{
    
    
    self.month = month;
    
    [self installPanellData];
}


@end
