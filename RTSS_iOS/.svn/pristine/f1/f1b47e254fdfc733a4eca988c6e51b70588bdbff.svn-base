//
//  TransationBaseViewController.m
//  RTSS
//
//  Created by 蔡杰Alan on 15-2-3.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "TransationBaseViewController.h"

#define kAlertTipsTag 1000

@interface TransationBaseViewController ()<AlertControllerDelegate>

@end
@implementation TransationBaseViewController

#pragma mark --Life
-(void)dealloc{
    [_transactionView release];
    [_dataSourceList release];
    [_resourceUnitAndName release];
    [_storeCell release];
    [super dealloc];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    //定制化 板子的个性属性
    _transactionView.panelView.feeLabel.textColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
    _transactionView.panelView.feeValueLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    [_transactionView.panelView.resetButton setTitle:@"Reset" forState:UIControlStateNormal];
    [_transactionView.panelView.resetButton setTitleColor:[RTSSAppStyle currentAppStyle].textMajorColor forState:UIControlStateNormal];
    [_transactionView.panelView.resetButton addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    _transactionView.panelView.resetButton.exclusiveTouch = YES;
    [_transactionView.panelView.submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [_transactionView.panelView.submitButton setTitleColor:[RTSSAppStyle currentAppStyle].textMajorColor forState:UIControlStateNormal];
    [_transactionView.panelView.submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    //_transactionView.panelView.submitButton.enabled = NO;
    _transactionView.panelView.submitButton.exclusiveTouch = YES;
    [self installPanellData];
}
-(void)loadView{
    
    [super loadView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_transactionView panelViewShow:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_transactionView panelViewShow:NO];

}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(NSMutableArray *)dataSourceList{
    
    if (!_dataSourceList) {
        _dataSourceList = [[NSMutableArray alloc]init];
    }
    
    return _dataSourceList;
}

-(NSMutableDictionary *)resourceUnitAndName{
    
    if (!_resourceUnitAndName) {
        
        _resourceUnitAndName = [[NSMutableDictionary alloc]init];
    }
    return _resourceUnitAndName;
}

-(NSMutableDictionary *)storeCell{
    
    
    if (!_storeCell) {
        
        _storeCell = [[NSMutableDictionary alloc]init];
    }
    return _storeCell;
}

#pragma mark --Public
-(void)loadTransactionViewWtihFrame:(CGRect)frame bindTransationCell:(Class)cellClass bindTransactionView:(Class)transactionClass{
    
     _transactionView = [[TransactionView alloc]initWithFrame:frame];
   // _transactionView.layer.borderColor = [RTSSAppStyle currentAppStyle].transactionViewBorderColor.CGColor;
    _transactionView.delegate = self;
   // [_transactionView bindTransactionCell:cellClass];
    [_transactionView bindTransactionView:transactionClass];
    //[_transactionView setBackgroundColor:[RTSSAppStyle currentAppStyle].transactionViewBgColor];
    [_transactionView.tableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_transactionView];

}

#pragma mark --ACTION
-(void)reset{
    
    [_transactionView.tableView reloadData];
    //self.isReset = NO;
}
-(void)submit{
    NSLog(@"base submit");
    
    AlertController *alert = [[AlertController alloc]initWithTitle:nil message:@"Are you sure?" delegate:self tag:kAlertTipsTag cancelButtonTitle:NSLocalizedString(@"UIAlertView_Cancel_String", nil) otherButtonTitles:NSLocalizedString(@"UIAlertView_Confirm_String", nil),nil];
    [alert showInViewController:self];
    [alert release];
}

-(void)updateSubmitButtonState:(BOOL)state{
    
    _transactionView.panelView.submitButton.enabled = state;
}
-(void)installPanellData{
    
    
}

#pragma mark --TranctionView Delegate override

-(void)transactionView:(TransactionView *)transationView transationTableViewCell:(TransationBaseTableViewCell *)cell onSliderTouchUpInside:(ComboSlider *)comboSlider{
    
  
  
    
    
}
-(void)transactionView:(TransactionView *)transationView transationTableViewCell:(TransationBaseTableViewCell *)cell onSliderValueChanged:(ComboSlider *)comboSlider{
    
    if (comboSlider.showCurrentValue) {
        
       // comboSlider.currentValue = comboSlider.midSlider.sliderControl.value;
        comboSlider.currentValueLabel.text = [NSString stringWithFormat:@"%.0f",comboSlider.currentValue];
    }
    
    
}
-(CGFloat)transactionView_TableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 0.0f;
}
-(NSInteger)transactionView_TableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    

    
    return self.dataSourceList.count;
}

-(void)setCellProperty:(TransationBaseTableViewCell*)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
//    [cell setTransationBaseTableViewCellBgColor:[RTSSAppStyle currentAppStyle].transferTableCellBgColor];
    cell.comboSlider.minimumTrackColor = [RTSSAppStyle getFreeResourceColorWithIndex:indexPath.row];
    cell.comboSlider.midimumTrackColor = [[RTSSAppStyle getFreeResourceColorWithIndex:indexPath.row]colorWithAlphaComponent:0.5];
   // cell.comboSlider.maximumTrackColor = [RTSSAppStyle currentAppStyle].transferTableCellComboSliderMaximumTrackColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row;

}
//子类必须覆盖
-(TransationBaseTableViewCell *)transactionView_TableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   // NSString *CellIdentify = [NSString stringWithFormat:@"CellIDentify_Row%d_Section%d",indexPath.row,indexPath.section];
   // NSLog(@"%@",CellIdentify);
   // TransationBaseTableViewCell *cell =(TransationBaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentify];
   // if (cell == nil) {
        
       // NSLog(@"nil");
         //cell = [[[TransationBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentify]autorelease];
   // }
    
   
   // [self transactionView_TableView:tableView transationBaseTableViewCell:cell cellForRowAtIndexPath://indexPath];
   // return cell;
    return nil;
}

-(void)transactionView:(TransactionView *)transationView transationTableViewCell:(TransationBaseTableViewCell *)cell resourceEvent:(ComboSlider *)comboSlider{
    
}

-(void)transactionView:(TransactionView *)transationView transationTableViewCell:(TransationBaseTableViewCell *)cell rightItemEvent:(ComboSlider *)comboSlider{
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

-(void)alertController:(AlertController *)alertController didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (alertController.tag == kAlertTipsTag) {
        
        if (buttonIndex==0) {
            //用户取消不做任何处理
            
        }else if(buttonIndex == 1){
            //用户确认支付
            [self sureSubmit];
        }
        return;
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sureSubmit{

    AlertController *alert = [[AlertController alloc]initWithTitle:nil message:@"Successful transaction!" delegate:self tag:0 cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert showInViewController:self];
    [alert release];

}

@end
