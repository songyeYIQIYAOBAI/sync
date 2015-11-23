//
//  PlanNegotiationView.m
//  RTSS
//
//  Created by tiger on 14-11-7.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//
#import "ComboSlider.h"
#import "AppDelegate.h"
#import "TransformTableCell.h"
#import "TransPanelView.h"
#import "CommonUtils.h"
#import "PlanNegotiationView.h"
#import "ProductResource.h"
#import "RuleManager.h"
#import "StaticData.h"

@implementation PlanNegotiationView
@synthesize transformTable, orderedItems, panelView, delegate, transferInfo/*, tranResult*/;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initObject];
        [self layoutContextView];
    }
    return self;
}

-(void)initObject
{
    transferInfo = [[NSMutableDictionary alloc]init];
}

-(void)layoutContextView
{
    //table
    transformTable = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    transformTable.backgroundColor = [UIColor clearColor];
    transformTable.delegate = self;
    transformTable.dataSource = self;
    transformTable.separatorStyle  = UITableViewCellSeparatorStyleNone;
    transformTable.layer.cornerRadius = 8;
    [self addSubview:transformTable];
    
    //panel
    panelView = [[TransPanelView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, PANEL_HEIGHT)];
    panelView.backgroundColor = [CommonUtils colorWithHexString:@"#46484C"];
    panelView.panelType = PriceNegotiationPanel;
    
    panelView.hidden = YES;
    [panelView.submitButton addTarget:self action:@selector(onSubmitBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [panelView.resetButton addTarget:self action:@selector(onResetBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:panelView];
}

-(void)dealloc
{
    [transformTable release];
    [orderedItems release];
    [transferInfo release];
    [panelView release];
    [super dealloc];
}

- (float)calculateTransferCharge
{
    float chargeTotal=0.0;

    NSArray* allKeys = [transferInfo allKeys];
    for(int i = 0; i < [allKeys count]; i ++){
        int itemId = [[allKeys objectAtIndex:i] intValue];
        NSNumber *valueNumber = [self getCurrentValueWithSliderID:itemId];
        int value = [valueNumber intValue];
        if (value <=0 ) {
            continue;
        }
        
        
    }
    
    return chargeTotal;
}

-(NSNumber *)getCurrentValueWithSliderID:(int)sliderID
{
    NSMutableDictionary * itemDic = [transferInfo objectForKey:[NSString stringWithFormat:@"%d", sliderID]];
    if (itemDic != nil) {
        return [itemDic objectForKey:_SLIDER_CURRENT_VALUE_];
    }
    return nil;
}

-(void)setTableCellStatus:(TransformTableCell *)cell
{
    [cell.slider showThumb:YES];
    
    cell.unSelectedCell.hidden = YES;
    cell.selectedCell.hidden = YES;
    
    cell.unSelectedCellBg.hidden = YES;
    cell.selectedCellBg.hidden = NO;
    cell.tapView.alpha = 0;
}

-(void)initSlider:(ComboSlider*)slider withData:(ProductResource *)productResoursce withRow:(int)row
{
    slider.tag = [productResoursce.mResourceId intValue];
    slider.itemId = [productResoursce.mResourceId intValue];
    slider.unitType = productResoursce.mUnit;
    slider.itemLabel = @"name";
    slider.itemUnit = [slider getUnitString:productResoursce.mUnit];
    slider.markImageName = @"slider_ruler_mark.png";
    slider.restMarkImageName =  @"slider_green_triangle_mark.png";
    slider.historyMarkImageName = @"slider_red_triangle_mark.png";
    slider.useBigFloatMarkImage = YES;
    slider.maxTrackImageName = @"slider_bg_right_track.png";
    slider.minTrackImageName = [[StaticData getAssetsRegistry] valueForKey:[NSString stringWithFormat:@"SLIDER_MINTRACK_NAME_%d", row%10]];
    slider.restTrackImageName = [[StaticData getAssetsRegistry] valueForKey:[NSString stringWithFormat:@"SLIDER_RESTTRACK_NAME_%d", row%10]];
    slider.thumbImageName = [[StaticData getAssetsRegistry] valueForKey:[NSString stringWithFormat:@"SLIDER_THUMB_NAME_%d", row%10]];
    [slider disableSelector];
    
    slider.minValue = 0;//productResoursce.mMinNegotiableAmount;
    slider.maxValue = productResoursce.mTotal;
    slider.restValue = 1024000000;//productResoursce.mRemain;
    slider.historyValue = 3024000000;//productResoursce.mUsed;
    [slider setCurrentValue:slider.restValue animated:YES];
}

#pragma mark - UITableViewDelegate implement
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TransferTableCell";
    TransformTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[[TransformTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.userInteractionEnabled = YES;
        
        [cell.slider addTarget:self action:@selector(onSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [cell.slider addTarget:self action:@selector(onSliderTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    int row = [indexPath row];
    
    ComboSlider* slider = cell.slider;
    
    ProductResource * productResource = [orderedItems objectAtIndex:row];
    //初始化slider
    [self initSlider:slider withData:productResource withRow:row];
    
    //设置单元格状态
    [self setTableCellStatus:cell];
    
    //更新步进值
    [self updateSliderStep:slider];
    
    NSNumber * currentNumber = nil;
    NSMutableDictionary * itemDic = [transferInfo objectForKey:[NSString stringWithFormat:@"%d", slider.itemId]];
    if (itemDic != nil) {
        [itemDic setObject:slider forKey:_SLIDER_];
        currentNumber = [itemDic objectForKey:_SLIDER_CURRENT_VALUE_];
    }
    
    if (currentNumber != nil) {
        [slider setCurrentValue:[currentNumber longLongValue] animated:YES];
    }else{
        [slider setCurrentValue:slider.restValue animated:YES];//设置成最小值
    }
    
    return cell;
}

- (void)updateSliderStep:(ComboSlider*)slider
{
    TTRule* rule = [[RuleManager sharedRuleManager] transferRule:slider.itemId];
    slider.negtiveStep = rule.mOrgAmount;
    slider.activeStep = rule.mOrgAmount;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [orderedItems count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TransformTableCellHeight;
}

#pragma mark - event
- (void)onResetBtnTouchUpInside:(id)sender
{
    UIButton * button = (UIButton *)sender;
    if ([delegate respondsToSelector:@selector(PlanNegotiationResetBtnTouchUpInside:)]) {
        [delegate PlanNegotiationResetBtnTouchUpInside:button];
    }
}

- (void)onSubmitBtnTouchUpInside:(id)sender
{
    UIButton * button = (UIButton *)sender;
    if ([delegate respondsToSelector:@selector(PlanNegotiationSubmitBtnTouchUpInside:)]) {
        [delegate PlanNegotiationSubmitBtnTouchUpInside:button];
    }
}

#pragma mark - TransformTableCellDelegate implement
- (void)onSliderValueChanged:(id)sender
{
    ComboSlider* slider = (ComboSlider*)sender;
    if ([delegate respondsToSelector:@selector(PlanNegotiationSliderValueChanged:)]) {
        [delegate PlanNegotiationSliderValueChanged:slider];
    }
}

- (void)onSliderTouchUpInside:(id)sender
{
    ComboSlider* slider = (ComboSlider*)sender;
    if ([delegate respondsToSelector:@selector(PlanNegotiationSliderTouchUpInside:)]) {
        [delegate PlanNegotiationSliderTouchUpInside:slider];
    }
}

@end