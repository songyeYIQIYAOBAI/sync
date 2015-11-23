//
//  BalanceTransferViewController.m
//  RTSS
//
//  Created by caijie on 14/10/23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "BalanceTransferViewController.h"
#import "UIView+RTSSAddView.h"
#import "UILabel+LabelTextColor.h"
#import "UITextField+CheckState.h"
#import "FriendsViewController.h"
#import "SinglePickerController.h"
#import "User.h"
#import "TPKeyboardAvoidingScrollView.h"

#import "Session.h"
#import "Account.h"
#import "User.h"
#import "ErrorMessage.h"
#import "ITransferable.h"
#import "MManager.h"
#import "BalanceTextFieldDeleagte.h"
#import "AcountTextFieldDelegate.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

//label距离左or右边界的距离
#define kRTSSlrEdge  20
#define kRTSSTopEdge 10
#define kRTSSLabelWidth 150
#define kRTSSButtonEdge 20
#define kPayAlertTag 100
#define kAccountTextFieldTag 200

#define kTransferSuccessTag 1000

@interface BalanceTransferViewController ()<MappActorDelegate,AlertControllerDelegate,UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate,SinglePickerDelegate>{
    
    UILabel *balanceLabel;
    UILabel *serviceLabel;
    UITextField *accountTextFiled;
    UITextField *tranferTextField;
    TPKeyboardAvoidingScrollView *keyboardScrollView;
    
    NSInteger currentService;//当前service位置

}

@property(retain,nonatomic)SinglePickerController *serviceTypePicker;//tag = 300;
@property(retain,nonatomic)NSMutableArray *subAcountsArray;


@property(copy,nonatomic)NSString *serviceType;

@end

@implementation BalanceTransferViewController{
    long long inputBalance;
     UIButton *submitButton;
    long long remainAmount;
}
@synthesize subAcountsArray;

- (void)dealloc{
    
    if (subAcountsArray) {
        [subAcountsArray release];
    }
    if (_serviceTypePicker) {
        [_serviceTypePicker release];
    }
    
    [keyboardScrollView release];
    [super dealloc];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView{
    [super loadView];
    [self.view setBackgroundColor:[RTSSAppStyle currentAppStyle].viewControllerBgColor];
    UIView *navView = [self addNavigationBarView:NSLocalizedString(@"Balance_Transfer_Title", nil) bgColor:[RTSSAppStyle currentAppStyle].viewControllerBgColor separator:YES];
    [self.view addSubview:navView];
    
    keyboardScrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(navigationBarView.frame), self.view.frame.size.width, self.view.frame.size.height-CGRectGetMaxY(navigationBarView.frame))];
     //keyboardScrollView.bounces = NO;
    keyboardScrollView.alwaysBounceHorizontal = NO;
    keyboardScrollView.showsHorizontalScrollIndicator = NO;
  // keyboardScrollView.scrollEnabled = NO;
    [self.view addSubview:keyboardScrollView];
    [self installInfoView];
    //[keyboardScrollView contentSizeToFit];

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    //self.navigationController.navigationBar.tintColor = [UIColor redColor];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
  
    self.navigationController.navigationBarHidden = NO;
    [self hideKeyBoard];
    
    
}

- (void)showEmptyAccountAlert{
    NSString* messageString = [NSString stringWithFormat:@"%@",NSLocalizedString(@"Service_TopUp_No_Child_Account_Alert", nil)];
    AlertController *alert = [[AlertController alloc]initWithTitle:nil message:messageString delegate:self tag:0 cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"UIAlertView_Confirm_String", nil),nil];
    [alert showInViewController:self];
    [alert release];
}

-(void)loadData{
/*
    Session *session= [Session sharedSession];
    if (!session.mCurrentSubscriber || !session.mCurrentSubscriber.mDefaultAccount) {
                return;
    }
    Account *current = session.mCurrentSubscriber.mDefaultAccount;
    
    if ([self.mdn length] > 0 ) {
        
        accountTextFiled.text = self.mdn;
    }

    NSLog(@"current=%@",current);
    serviceLabel.text = current.mId;
    balanceLabel.text =[NSString stringWithFormat:@"%@ %@%.2f",NSLocalizedString(@"Balance_Transfer_Balance", nil),NSLocalizedString(@"Currency_Unit", nil),[CommonUtils formatMoneyFromPennyToYuan:current.mAmount]];
//
*/
    //获取用户账户以及serviceType
    Session *session= [[MManager sharedMManager] getSession];
    currentService = 0;
    NSArray *products = session.mTransferables;
    
    
    
    NSMutableArray * datas = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (![products count] > 0) {
        return;
    }
    for (id<ITransferable> item in products) {
        if ([item getTypeCode] == 2) {
            [datas addObject:item];
        }
    }
    self.subAcountsArray = datas;
    [datas release];
    
    if (![self.subAcountsArray count] > 0) {
        return;
    }
    
    id<ITransferable> current = self.subAcountsArray[currentService];
    NSLog(@"current=%@",current);
    balanceLabel.text =[NSString stringWithFormat:@"%@ %@%.2f",NSLocalizedString(@"Balance_Transfer_Balance", nil),NSLocalizedString(@"Currency_Unit", nil),[CommonUtils formatMoneyFromPennyToYuan:[current getRemainAmount]]];
    [balanceLabel sizeToFit];
    self.serviceType = [current getSubscriberId];
    
    NSString *message = [NSString stringWithFormat:@"%@(%@)",[current getSubscriberTypeName],[current getSubscriberId]];
    serviceLabel.text =message;
    remainAmount = [current getRemainAmount];
    if ([self.mdn length] > 0 ) {
        
        accountTextFiled.text = self.mdn;
    }
}

#pragma mark --setter
-(SinglePickerController *)serviceTypePicker{
    
    
    if (!_serviceTypePicker) {
        
        _serviceTypePicker = [[SinglePickerController alloc]init];
        _serviceTypePicker.pickerType = SinglePickerTypeDefault;
        _serviceTypePicker.delegate = self;
        //数据加载
        __block  NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:0];
        [self.subAcountsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            id<ITransferable> current = (id<ITransferable>)obj;
            NSString *message = [NSString stringWithFormat:@"%@(%@)",[current getSubscriberTypeName],[current getSubscriberId]];
            [array addObject:message];
        }];
        _serviceTypePicker.pickerArrayData = array;
        [array release];
    }
    
    return _serviceTypePicker;
    
}



#pragma mark -- Insatll Subviews

-(void)installInfoView{
 /*
    CGFloat IntervalHeight = 15.0f;
    
    UIView *darkView1 = [keyboardScrollView addIntervalViewWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, IntervalHeight)];
    //darkView1.backgroundColor = [UIColor redColor];
    CGFloat serviceHeight = 50.0f;
    serviceLabel = [keyboardScrollView serviceViewWithFrame:CGRectMake(0, CGRectGetMaxY(darkView1.frame), PHONE_UISCREEN_WIDTH, serviceHeight) Title:@"Account" isShowSelect:NO Target:self Action:nil];

     balanceLabel = [keyboardScrollView balanceWithFrame:CGRectMake(0, IntervalHeight+serviceHeight, PHONE_UISCREEN_WIDTH, serviceHeight) TextColor:[RTSSAppStyle currentAppStyle].textMajorColor TextAlignment:NSTextAlignmentLeft];
    
    
    
    [keyboardScrollView addBottomLineWithY:99+IntervalHeight];

     UIView  *darkView2=[keyboardScrollView addIntervalViewWithFrame:CGRectMake(0, IntervalHeight+100, PHONE_UISCREEN_WIDTH, IntervalHeight)];
    
    //from
    CGFloat height = 80;
   
    //CGFloat edge = 10;
    accountTextFiled =   [keyboardScrollView addTextFieldWithFrame:CGRectMake(0,CGRectGetMaxY(darkView2.frame)+5,PHONE_UISCREEN_WIDTH , height) Name:NSLocalizedString(@"Balance_Transfer_ToFriend", nil) TextFieldDelegate:[[AcountTextFieldDelegate alloc]init] KeyboardType:UIKeyboardTypeNumberPad isMoneySymbol:NO];
    
    accountTextFiled.userInteractionEnabled = !self.flag;
    
    [self addTextFieldEventEditingChanged:accountTextFiled];

    if (!self.flag) {
        //添加朋友账号
        UIButton *friendButton =[UIButton buttonWithType:UIButtonTypeCustom];
        friendButton.frame = CGRectMake(0, 0, 30, 30);
        [friendButton setImage:[UIImage imageNamed:@"common_contacts"] forState:UIControlStateNormal];
        [friendButton addTarget:self action:@selector(addFiendAccount) forControlEvents:UIControlEventTouchUpInside];
        accountTextFiled.rightViewMode = UITextFieldViewModeAlways;
        accountTextFiled.rightView = friendButton;
    }
    
    UIView  *darkView3=[keyboardScrollView addIntervalViewWithFrame:CGRectMake(0, CGRectGetMaxY(darkView2.frame)+5+height, PHONE_UISCREEN_WIDTH, IntervalHeight)];
    
    tranferTextField  =  [keyboardScrollView addTextFieldWithFrame:CGRectMake(0,CGRectGetMaxY(darkView3.frame)+5,PHONE_UISCREEN_WIDTH, height) Name:NSLocalizedString(@"Balance_Transfer_Amount_Value", nil) TextFieldDelegate:self KeyboardType:UIKeyboardTypeNumberPad isMoneySymbol:YES];
    tranferTextField.delegate =self;
    //提交
    CGFloat buttonBgViewY = CGRectGetMaxY(darkView3.frame)+5+height;
    UIView *buttonBgView = [[UIView alloc]initWithFrame:CGRectMake(0,buttonBgViewY,PHONE_UISCREEN_WIDTH,PHONE_UISCREEN_HEIGHT-buttonBgViewY-CGRectGetMaxY(navigationBarView.frame))];
    buttonBgView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    submitButton =[RTSSAppStyle getMajorGreenButton:CGRectMake((PHONE_UISCREEN_WIDTH-253)/2,CGRectGetHeight(buttonBgView.frame)/2-45/2, 253, 45) target:self action:@selector(submitInfo) title:NSLocalizedString(@"Balance_Transfer_Button_Title", nil)];
    [buttonBgView addSubview:submitButton];
    [keyboardScrollView addSubview:buttonBgView];
    [buttonBgView release];
    [keyboardScrollView contentSizeToFit];
  */
    
    
    [keyboardScrollView addBottomLineWithY:19];
    
    //1
    CGFloat intervalY = 20.0f;
    CGFloat serviceLabelHeight = 50;
    serviceLabel = [keyboardScrollView serviceViewWithFrame:CGRectMake(0, intervalY, PHONE_UISCREEN_WIDTH, serviceLabelHeight) Title:NSLocalizedString(@"Balance_Transfer_Service_TypeAndID", nil) isShowSelect:YES Target:self Action:@selector(selectService:)];
    
    //2
    balanceLabel = [keyboardScrollView balanceWithFrame:CGRectMake(0, intervalY+serviceLabelHeight, PHONE_UISCREEN_WIDTH, serviceLabelHeight) TextColor:[RTSSAppStyle currentAppStyle].textMajorColor TextAlignment:NSTextAlignmentLeft];
    
    //3
    
    [keyboardScrollView addBottomLineWithY:intervalY*2+serviceLabelHeight*2-1];
    //from
    CGFloat height = 90;
    accountTextFiled =   [keyboardScrollView addTextFieldWithFrame:CGRectMake(0,intervalY*2+serviceLabelHeight*2,PHONE_UISCREEN_WIDTH , height) Name:NSLocalizedString(@"Balance_Transfer_ToFriend", nil) TextFieldDelegate:[[AcountTextFieldDelegate alloc]init] KeyboardType:UIKeyboardTypeNumberPad isMoneySymbol:NO];
    
    [self addTextFieldEventEditingChanged:accountTextFiled];
    
    accountTextFiled.userInteractionEnabled = !self.flag;
    if (!self.flag) {
        //添加朋友账号
        UIButton *friendButton =[UIButton buttonWithType:UIButtonTypeCustom];
        friendButton.frame = CGRectMake(0, 0, 30, 30);
        [friendButton setImage:[UIImage imageNamed:@"common_contacts"] forState:UIControlStateNormal];
        [friendButton addTarget:self action:@selector(addFiendAccount) forControlEvents:UIControlEventTouchUpInside];
        accountTextFiled.rightViewMode = UITextFieldViewModeAlways;
        accountTextFiled.rightView = friendButton;
    }
    //4
    [keyboardScrollView addBottomLineWithY:intervalY*3+serviceLabelHeight*2+height-1];
    
    tranferTextField  =  [keyboardScrollView addTextFieldWithFrame:CGRectMake(0,intervalY*3+serviceLabelHeight*2+height,PHONE_UISCREEN_WIDTH, height) Name:NSLocalizedString(@"Balance_Transfer_Amount_Value", nil) TextFieldDelegate:self KeyboardType:UIKeyboardTypeNumberPad isMoneySymbol:YES];
    tranferTextField.delegate =self;
    [self addTextFieldEventEditingChanged:tranferTextField];
    //提交
    CGFloat buttonBgViewY = intervalY*3+serviceLabelHeight*2+height*2;
    UIView *buttonBgView = [[UIView alloc]initWithFrame:CGRectMake(0,buttonBgViewY,PHONE_UISCREEN_WIDTH,PHONE_UISCREEN_HEIGHT-buttonBgViewY-64)];
    buttonBgView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    submitButton = [RTSSAppStyle getMajorGreenButton:CGRectMake(20,CGRectGetHeight(buttonBgView.frame)/2-45/2, CGRectGetWidth(buttonBgView.frame)-2*20, 45) target:self action:@selector(submitInfo) title:NSLocalizedString(@"Balance_Transfer_Button_Title", nil)];
    submitButton.enabled = NO;
    [buttonBgView addSubview:submitButton];
    [keyboardScrollView addSubview:buttonBgView];
    [buttonBgView release];
    [keyboardScrollView contentSizeToFit];

}

#pragma mark -- Action

-(void)selectService:(id)sender{
    
    [self hideKeyBoard];
    
    if (!self.subAcountsArray &&![self.subAcountsArray count]>0) {
        return;
    }
    
    [self.view.window addSubview:self.serviceTypePicker.view];
    [self.serviceTypePicker selectRow:currentService inComponent:0 animated:NO];
}


-(void)addFiendAccount
{
    NSLog(@"添加朋友");
//    FriendsViewController *quickTransferVC = [[FriendsViewController alloc] init];
//    quickTransferVC.actionType = FriendsActionTypePickFriends;
//    quickTransferVC.transferFriendInfoBlock =^(User *friendInfo){
//        
//        NSString *phoneNumber = friendInfo.mPhoneNumber;
////        NSString *phoneNumber = nil;
//        accountTextFiled.text = phoneNumber;
//       [self textFieldDidChange:accountTextFiled];
//    };
//    [self.navigationController pushViewController:quickTransferVC animated:YES];
//    [quickTransferVC release];
    
    ABPeoplePickerNavigationController* picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];
    [picker release];
}

-(void)submitInfo
{
    [self hideKeyBoard];
    //没账户 提交无效
//     Session *session= [Session sharedSession];
//    if (!session.mCurrentSubscriber || !session.mCurrentSubscriber.mDefaultAccount) {
//        return;
//    }
    if (!self.subAcountsArray || ![self.subAcountsArray count]>0) {
        return;
    }
    NSLog(@"信息提交");
    //判断TextField 值是否有效
    if (![accountTextFiled isAccountValid]) return;

    //增加判断是否与当前serviceID相同 20150211
    id<ITransferable> selectAccount = self.subAcountsArray[currentService];
    NSString *currentSelectServiceID = [selectAccount getSubscriberId];
    
    if ([accountTextFiled.text isEqualToString:currentSelectServiceID]) {
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Balance_Transfer_FailTo_Myself", nil)];
        return;
    }
    
    
    if (![tranferTextField isBalanceValid]) return;
        //判断金额是否有效
    long long userInput = [CommonUtils formatMoneyFromYuanToPenny:[tranferTextField.text floatValue]];
//    Account *acount = session.mCurrentSubscriber.mDefaultAccount;
    id<ITransferable> current = self.subAcountsArray[currentService];
    long long userHave = [current getRemainAmount];
//    long long userHave = acount.mAmount;
    
     NSLog(@"userInput = %lld--userhave=%lld",userInput,userHave);
   if (userInput > userHave) {//判断转换值是否超
       
//        [AlertController showSimpleAlertWithTitle:nil message:[NSString stringWithFormat:@"%@ %@%.2f",NSLocalizedString(@"Balance_Transfer_Account_Balance_insufficient_Alert", nil),NSLocalizedString(@"Currency_Unit", nil),[CommonUtils formatMoneyFromPennyToYuan:userHave]] buttonTitle:NSLocalizedString(@"UIAlertView_Confirm_String", nil) inViewController:self] ;
       //NSLocalizedString(@"Balance_Transfer_Account_Balance_insufficient_Alert", nil)
    [APPLICATION_KEY_WINDOW makeToast:[NSString stringWithFormat:@"%@ %@%.2f",NSLocalizedString(@"Balance_Transfer_Account_Balance_insufficient_Alert", nil),NSLocalizedString(@"Currency_Unit", nil),[CommonUtils formatMoneyFromPennyToYuan:userHave]]];
        return;
   }
    
    inputBalance = userInput;
    
    // 调用获取手续费方法
    [APPLICATION_KEY_WINDOW makeToastActivity];
    [(id<ITransferable>)self.subAcountsArray[currentService] queryChargeWithTransactionType:1 andDelegate:self];
    
    //添加确认提示框
//    AlertController *alert = [[AlertController alloc]initWithTitle:nil message:NSLocalizedString(@"Balance_Transfer_Confirm_Payment_Alert", nil) delegate:self tag:kPayAlertTag cancelButtonTitle:NSLocalizedString(@"UIAlertView_Cancel_String", nil) otherButtonTitles:NSLocalizedString(@"UIAlertView_Confirm_String", nil),nil];
//    [alert showInViewController:self];
//    [alert release];

}


// 手续费回调
- (void)queryChargeFinished:(NSInteger)status andInfo:(double)info
{
    [APPLICATION_KEY_WINDOW hideToastActivity];
    // 手续费接口回调
    // 调用alert显示手续费
    // 添加确认提示框
    AlertController *alert = [[AlertController alloc]initWithTitle:NSLocalizedString(@"Balance_Transfer_Confirm_Payment_Alert", nil) message:[NSString stringWithFormat:@"%@:%@%.2f",NSLocalizedString(@"Balance_Transfer_Fee", nil),NSLocalizedString(@"Currency_Unit", nil),[CommonUtils formatMoneyFromPennyToYuan:inputBalance *[CommonUtils formatMoneyFromPennyToYuan:info]]] delegate:self tag:kPayAlertTag cancelButtonTitle:NSLocalizedString(@"UIAlertView_Cancel_String", nil) otherButtonTitles:NSLocalizedString(@"UIAlertView_Confirm_String", nil),nil];
    [alert showInViewController:self];
    [alert release];

}




#pragma mark --Touch

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self hideKeyBoard];
}

-(void)hideKeyBoard{
    //点击页面  放弃第一响应
    [accountTextFiled giveUpTheKeyboard];
    [tranferTextField giveUpTheKeyboard];
}

#pragma mark -- Account MappActorDelegate
//支付
-(void)transferBalanceFinished:(NSInteger)status result:(NSDictionary *)result{
    
//   [APPLICATION_KEY_WINDOW hideToastActivity];
    if(MappActorFinishStatusOK == status){
        
        
//        if (!result || ![result count]>0) {
//            [APPLICATION_KEY_WINDOW hideToastActivity];
//            [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Balance_Transfer_Failed", nil)];
//            return;
//        }
        NSLog(@"获取支付信息成功");
        [APPLICATION_KEY_WINDOW hideToastActivity];
        //提示用户转换成功
        AlertController *alert = [[AlertController alloc]initWithTitle:nil message:NSLocalizedString(@"Balance_Transfer_Successful_Alert", nil) delegate:self tag:kTransferSuccessTag cancelButtonTitle:NSLocalizedString(@"UIAlertView_Confirm_String", nil) otherButtonTitles:nil];
        [alert showInViewController:self];
        [alert release];
      
        
        
    } else if(MappActorFinishStatusNetwork == status){
        [APPLICATION_KEY_WINDOW hideToastActivity];
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"ErroMessage_Status_Network", nil)];
    }else {
        [APPLICATION_KEY_WINDOW hideToastActivity];
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Balance_Transfer_Failed", nil)];
    }
    
}
-(void)syncFinished:(NSInteger)status{
    NSLog(@"syncFinished");
    [APPLICATION_KEY_WINDOW hideToastActivity];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)beginPay{
    //删除空格字符串   从fiend返回字符串有空字符串
    NSString *serviceID = accountTextFiled.text;
    //[accountTextFiled.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"servcieID = %@",serviceID);
    id<ITransferable> current = [self.subAcountsArray objectAtIndex:currentService];
    [current transferWithPeerId:serviceID andAmount:inputBalance andDelegate:self];
    [APPLICATION_KEY_WINDOW makeToastActivity];
    
//     Session *session= [Session sharedSession];
//    Account *account =session.mCurrentSubscriber.mDefaultAccount;
//    NSLog(@"acountBalance =%lld",account.mAmount);
//    [account transferBalance:inputBalance toPeer:serviceID  delegate:self];
   
   
}

#pragma mark --AlertDelagate

-(void)alertController:(AlertController *)alertController didDismissWithButtonIndex:(NSInteger)buttonIndex{

    if (alertController.tag == kPayAlertTag) {
        
        if (buttonIndex==0) {
            //用户取消不做任何处理
            
        }else if(buttonIndex == 1){
            //用户确认支付
            NSLog(@"用户确认支付");
            [self beginPay];
        }
        return;
    } else if (alertController.tag == kTransferSuccessTag){
        
        [APPLICATION_KEY_WINDOW makeToastActivity];
        //重新获取数据,刷新账户
        Session *session = [[MManager sharedMManager] getSession];
        [session.mMyCustomer sync:self];
        
        return;
        
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
//    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark --SinglePickerDelegate
-(void)singlePickerWithCancel:(SinglePickerController *)controller{
    [controller.view removeFromSuperview];
}

-(void)singlePickerWithDone:(SinglePickerController *)controller selectedIndex:(NSInteger)index{
    
    if (controller == self.serviceTypePicker) {//选择自己的service
        
        if (index < [self.subAcountsArray count]){
            
            currentService = index;
            id<ITransferable> current =(id<ITransferable>)[self.subAcountsArray objectAtIndex:index];
            balanceLabel.text =[NSString stringWithFormat:@"%@ %@%.2f",NSLocalizedString(@"Balance_Transfer_Balance", nil),NSLocalizedString(@"Currency_Unit", nil),[CommonUtils formatMoneyFromPennyToYuan:[current getRemainAmount]]];
            [balanceLabel sizeToFit];
            NSString *message = [NSString stringWithFormat:@"%@(%@)",[current getSubscriberTypeName],[current getSubscriberId]];
            self.serviceType = [current getItemId];
            serviceLabel.text = message;
        }else{
            NSLog(@"数组subAcountsArray越界");
            
        }
    }
    [controller.view removeFromSuperview];
}


#pragma mark --UItextField
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    BOOL isMatch = YES;
    
    if (![string length]>0) {
        return YES;
    }
    unichar single = [string characterAtIndex:0];
    
    if ([textField.text length]==0) {
        
        if (single == '0') {
            isMatch = NO;
        }
    }else{
        
        NSInteger strLength = textField.text.length - range.length + string.length;
        isMatch =  (strLength <= 8);
    }
    
    
    return isMatch;
}

#pragma mark people picker delegate
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    [self pickUpPeopleInfoFromController:peoplePicker selectedPerson:person property:property inentifier:identifier];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    [self pickUpPeopleInfoFromController:peoplePicker selectedPerson:person property:property inentifier:identifier];
    
    return NO;
}

- (void)pickUpPeopleInfoFromController:(ABPeoplePickerNavigationController *)peoplePicker selectedPerson:(ABRecordRef)person property:(ABPropertyID)property inentifier:(ABMultiValueIdentifier)identifier {
    BOOL canAdd = NO;
    
    NSString *text=@"";
    
    NSString* name = nil;
    NSString* phoneNum = nil;
    if (property == kABPersonPhoneProperty) {
        
        CFStringRef firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFStringRef middleName = ABRecordCopyValue(person, kABPersonMiddleNameProperty);
        CFStringRef lastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        
        name = [[NSString alloc] initWithFormat:@"%@%@%@",firstName ? (NSString *)firstName : @"",middleName ? (NSString *)middleName : @"",lastName ? (NSString *)lastName : @""];
        
        if (firstName) {
            CFRelease(firstName);
        }
        if (middleName) {
            CFRelease(middleName);
        }
        if (lastName) {
            CFRelease(lastName);
        }
        
        ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, property);
        CFIndex index = ABMultiValueGetIndexForIdentifier(phoneMulti,identifier);
        CFStringRef phone = ABMultiValueCopyValueAtIndex(phoneMulti, index);
        NSString *phoneStr = [[NSString alloc] initWithString:(NSString *)phone];
        CFRelease(phoneMulti);
        CFRelease(phone);
        
        phoneNum = [phoneStr stringByReplacingOccurrencesOfString:@"[^\\d]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0,[phoneNum length])];
        [phoneStr release];
    }
    
    
    if ([CommonUtils objectIsValid:name]) {
        
        canAdd = YES;
        
        text = name;
        
        // [name release];
        
    }else{
        
        if ([CommonUtils objectIsValid:phoneNum]) {
            
            
            text = phoneNum;
            
            canAdd = YES;
            
        }
    }
    
    
    
    [peoplePicker dismissViewControllerAnimated:YES completion:^ {
        if (canAdd ) {
            accountTextFiled.text= text;
            [self textFieldDidChange:accountTextFiled];
        }
    }];
}

#pragma mark --UItextField
- (void)addTextFieldEventEditingChanged:(UITextField*)textField{
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
- (void)textFieldDidChange:(UITextField*)textField{
    
    NSInteger accountLength = [accountTextFiled.text length];
    NSInteger balanceLength = [tranferTextField.text length];
    submitButton.enabled = accountLength>0 && balanceLength>0;
}

@end
