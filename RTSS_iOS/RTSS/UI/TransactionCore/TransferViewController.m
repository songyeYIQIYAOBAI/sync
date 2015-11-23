//
//  TransferViewController.m
//  RTSS
//
//  Created by 蔡杰Alan on 15-2-3.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "TransferViewController.h"
#import "FriendsViewController.h"
#import "UserInfoComponentView.h"
#import "Session.h"
#import "ITransferable.h"
#import "MyBillsViewController.h"
#import "RuleManager.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


#define TITLE_LABEL_LEFT_INTERVAL       10.0


@interface TransferViewController ()<UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate>{
    id <ITransferable> currentItem;
    ComboSlider * currentComboSlider;
    NSInteger currentValue;
}


@property(nonatomic,retain)UserInfoItemView *textField;
@end

@implementation TransferViewController
#pragma mark --Life

-(void)dealloc{
    
    [_textField  release];
    [super dealloc];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.transactionView addGestureRecognizer:tap];
    [tap release];
    
    self.title = NSLocalizedString(@"Service_Transfer_Navi_Title", nil);
    //定制业务
    self.transactionView.panelView.submitButton.enabled = NO;
}
-(void)tap{
    [self.view endEditing:YES];
}
-(void)loadView{
    [super loadView];
    [self loadHeaderView];
}

-(void)loadHeaderView{
    
    
    CGFloat y =  kTransactionViewTopEdge;
    CGFloat wh = 30.0f;
    
    //titleLabel
    UILabel *titleLabel = [[[UILabel alloc]initWithFrame:CGRectMake(TITLE_LABEL_LEFT_INTERVAL,y, wh, wh)] autorelease];
    //titleLabel.font = [RTSSAppStyle currentAppStyle].transactionViewHeaderViewTitleLabelFont;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"Service_Transfer_To_Label_Title", nil);
    titleLabel.textColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
    [self.view addSubview:titleLabel];
    
    //addButton
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setBackgroundImage:[UIImage imageNamed:@"common_contacts"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addTransferFriend:) forControlEvents:UIControlEventTouchUpInside];
    addButton.frame = CGRectMake(PHONE_UISCREEN_WIDTH-TITLE_LABEL_LEFT_INTERVAL-wh, y, wh, wh);
    [self.view addSubview:addButton];
    
    //textField
    _textField = [[UserInfoItemView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), y, CGRectGetMinX(addButton.frame)-CGRectGetMaxX(titleLabel.frame)-10, wh) style:UserInfoItemViewStyleTextFieldIn];
    _textField.isSeparate = NO;
    _textField.layer.borderWidth = .5;
    _textField.layer.borderColor = [RTSSAppStyle currentAppStyle].textFieldBorderColor.CGColor;
    _textField.layer.cornerRadius = 8.0;
    _textField.itemTextField.frame = CGRectMake(7, CGRectGetMinY(_textField.itemTextField.frame), CGRectGetWidth(_textField.itemTextField.frame) + 33, CGRectGetHeight(_textField.itemTextField.frame));
    NSMutableAttributedString* attributedString = [[[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Service_Transfer_TextField_Placeholder_Text", nil)] autorelease];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[RTSSAppStyle currentAppStyle].textFieldPlaceholderColor
                             range:NSMakeRange(0, attributedString.length)];
    _textField.itemTextField.attributedPlaceholder = attributedString;
    [_textField.itemTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    _textField.itemTextField.delegate = self;
    [self.view addSubview:_textField];
    
    //line
    UIImageView * line = [[[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_textField.frame) + kTransactionViewTopEdge - 0.5, PHONE_UISCREEN_WIDTH, .5)] autorelease];
    line.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [self.view addSubview:line];
    
    //
    CGFloat yy = y+wh;
    [self loadTransactionViewWtihFrame:CGRectMake(kTransactionViewLREdge, yy+kTransactionViewTopEdge, PHONE_UISCREEN_WIDTH-2*kTransactionViewLREdge, PHONE_UISCREEN_HEIGHT-kTransactionViewTopEdge-kTransactionViewBottomEdge-64-yy) bindTransationCell:[TransationBaseTableViewCell class] bindTransactionView:[TransactionPanelBaseView class]];
}

-(void)loadData{

    Session *session = [Session sharedSession];
    NSArray *products = session.mTransferables;
    
    
    for (id<ITransferable> item in products) {
        int codeType = [item getTypeCode];
        if (codeType != 1 && codeType != 2) {
            [self.dataSourceList addObject:item];
        }else{
            NSLog(@"code type %d",codeType);
        }
    }

    [self.transactionView.tableView reloadData];
    
}

#pragma mark --Action
-(void)addTransferFriend:(id)sender{
    
    FriendsViewController *quickTransferVC = [[FriendsViewController alloc] init];
    quickTransferVC.actionType = FriendsActionTypePickFriends;
    quickTransferVC.transferFriendInfoBlock =^(User *friendInfo){
        
        NSString *phoneNumer = friendInfo.mPhoneNumber;
        self.textField.itemTextField.text = phoneNumer;
        
        [self updateTransactionSubmitBtn];
    };
    [self.navigationController pushViewController:quickTransferVC animated:YES];
    [quickTransferVC release];

}

-(void)textFieldChange:(id)sender{
    
    static BOOL flag = YES;
    
    UITextField *textField = (UITextField*)sender;
    if ([textField.text length] > 0 ) {
     
        if (flag == YES) {
            [self updateTransactionSubmitBtn];
            flag = NO;
        }
    }else{
         [self updateTransactionSubmitBtn];
          flag = YES;
    }

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    return YES;
}

#pragma mark -transactionView Delegate override



-(TransationBaseTableViewCell *)transactionView_TableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     NSString *CellIdentify = [NSString stringWithFormat:kCellIndentify,indexPath.row,indexPath.section];
     NSLog(@"%@",CellIdentify);
     TransationBaseTableViewCell *cell =(TransationBaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentify];
    
    if (cell == nil) {
         NSLog(@"nil");
          cell = [[[TransationBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentify]autorelease];
         //数据模型绑定
         if ([self.dataSourceList count] >0 ) {
             id <ITransferable> item = [self.dataSourceList objectAtIndex:indexPath.row];
             [cell transationTableViewCellBind_TransferItemModel:item];
             
             [self.storeCell setObject:cell forKey:CellIdentify];
         }
         cell.tag = indexPath.row;
         [self setCellProperty:cell cellForRowAtIndexPath:indexPath];
     }else{
         
         
         
     }

     return cell;
}


-(void)transactionView:(TransactionView *)transationView transationTableViewCell:(TransationBaseTableViewCell *)cell onSliderTouchUpInside:(ComboSlider *)comboSlider{
    
    /*===========宋野============*/
    //判断submit button state
    [self updateTransactionSubmitBtn];
    currentComboSlider = comboSlider;
    
    //获取哪个滑动的是哪个id <ITransferable> item
    NSIndexPath * indexPath = [self.transactionView.tableView indexPathForCell:cell];
    id<ITransferable> item = [self.dataSourceList objectAtIndex:indexPath.row];
    currentItem = item;
    
    
    //获取手续费
    if (comboSlider.midSlider.sliderControl.value > 0) {
        NSString * iTransferableID = [item getItemId];
        TTRule * rule = [[RuleManager sharedRuleManager] transferRule:iTransferableID];
        self.transactionView.panelView.feeValueLabel.text = [CommonUtils formatMoneyWithPenny:rule.mChargeAmount decimals:2 unitEnable:YES];
    }else{
        self.transactionView.panelView.feeValueLabel.text = [CommonUtils formatMoneyWithPenny:0 decimals:2 unitEnable:YES];
    }
    /*===========宋野============*/

}

-(void)transactionView:(TransactionView *)transationView transationTableViewCell:(TransationBaseTableViewCell *)cell onSliderValueChanged:(ComboSlider *)comboSlider{
    
    /*===========宋野============*/
    
    //判断其它comboSlider 是否是在初始值
    NSArray * allCellKeys = [self.storeCell allKeys];
    for (NSString * key in allCellKeys) {
        
        TransationBaseTableViewCell * otherCell = [self.storeCell objectForKey:key];
        if (![otherCell isEqual:cell]) {
            [otherCell.comboSlider setCurrentValue:0 animated:NO];
            otherCell.comboSlider.currentValueLabel.text = [NSString stringWithFormat:@"%.0f",otherCell.comboSlider.currentValue];
        }
    }
    
    //show current label value
    float showValue = comboSlider.midSlider.sliderControl.value;
    comboSlider.currentValue = showValue;
    comboSlider.currentValueLabel.text = [NSString stringWithFormat:@"%.0f",showValue];
    
    /*===========宋野============*/

}

#pragma mark --logic show

- (BOOL)judgementTranserValueActive{
    BOOL enable = NO;
    
    NSArray * allKeys = [self.storeCell allKeys];
    for (NSString * key in allKeys) {
        TransationBaseTableViewCell * cell = [self.storeCell objectForKey:key];
        if (cell.comboSlider.currentValue > 0) {
            enable = YES;
            break;
        }
    }
    return enable;
}

- (void)updateTransactionSubmitBtn{
    BOOL enable = [self judgementTranserValueActive];
    
    if (![_textField.itemTextField.text length] > 0 || !enable) {
        [self updateSubmitButtonState:NO];
    }else{
        [self updateSubmitButtonState:YES];
    }
}


#pragma mark--OverRide
-(void)reset{
    [self installPanellData];
    
    for (NSString *cellIdentigy in [self.storeCell allKeys]) {
        
        TransationBaseTableViewCell *cell = (TransationBaseTableViewCell*)[self.storeCell objectForKey:cellIdentigy];
        [cell.comboSlider setCurrentValue:cell.comboSlider.minimumValue animated:NO];
        cell.comboSlider.currentValueLabel.text = [NSString stringWithFormat:@"%.0f",cell.comboSlider.currentValue];
    }
    
    [self updateTransactionSubmitBtn];
}
-(void)submit{
    //暂时先把MyBills的入口放这
//    MyBillsViewController * myBillViewController = [[MyBillsViewController alloc] init];
//    [self.navigationController pushViewController:myBillViewController animated:YES];
    [super submit];
}
-(void)sureSubmit{

    [APPLICATION_KEY_WINDOW makeToastActivity];
    [currentItem transferWithPeerId:self.textField.itemTextField.text andAmount:currentValue andDelegate:self];
}




-(void)installPanellData{
    
    self.transactionView.panelView.feeLabel.text = NSLocalizedString(@"Service_Transfer_Fee_Label_Text", nil);
    self.transactionView.panelView.feeValueLabel.text = [CommonUtils formatMoneyWithPenny:0 decimals:2 unitEnable:YES];
}


#pragma mark - MappActorDelegate

- (void)transferBalanceFinished:(NSInteger)status result:(NSDictionary*)result{
    [APPLICATION_KEY_WINDOW hideToastActivity];
    
    if (status == MappActorFinishStatusOK) {
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Service_Transfer_Submit_Success_Text", nil)];
    }else{
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Service_Transfer_Submit_Faild_Text", nil)];
    }
}

@end
