//
//  AcountTopupViewController.m
//  RTSS
//
//  Created by 蔡杰 on 14-10-26.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "ServiceTopupViewController.h"
#import "UIView+RTSSAddView.h"
#import "UILabel+LabelTextColor.h"
#import "UITextField+CheckState.h"
#import "SinglePickerController.h"
#import "Subscriber.h"
#import "ErrorMessage.h"

#import "Session.h"
#import "Account.h"
#import "BalanceTextFieldDeleagte.h"
#import "PayViewController.h"

#define kRTSSAcountTopUplrEdge 20
#define kRTSSAcountTopUpEdge  15 //距离顶部
#define kRTSSInfoLabelWidth   150
#define kRTSSInfoLabelHeight  20
#define kRTSSInfoLabelSpace   10

@interface ServiceTopupViewController ()<UITextFieldDelegate,SinglePickerDelegate,MappActorDelegate,AlertControllerDelegate,PaymentActionDelegate>
{
    UILabel *accountLabel;
    UILabel *serviceLabel;
    UITextField *payTextField;

    NSInteger currentService;//subCount
    
}

@property(retain,nonatomic)SinglePickerController *servicePicker;
@property(retain,nonatomic)NSArray *subAcountsArray;
@end

@implementation ServiceTopupViewController{
    
     UIButton *submitButton;
}
@synthesize subAcountsArray;
-(void)dealloc{
    
    if (subAcountsArray) {
         [subAcountsArray release];
    }
    if (_servicePicker) {
        [_servicePicker release];
    }
    
    [super dealloc];
}

#pragma mark --setter

-(SinglePickerController *)servicePicker{
    
    
    if (!_servicePicker) {
        
        _servicePicker = [[SinglePickerController alloc]init];
        _servicePicker.pickerType = SinglePickerTypeDefault;
        _servicePicker.delegate = self;
        //数据加载
        __block  NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:0];
        [self.subAcountsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Account *acount = (Account*)obj;
            NSDictionary *dic = [[RTSSAppStyle currentAppStyle]getServiceSourceWithServiceType:acount.mServiceType];
            NSString *message = [NSString stringWithFormat:@"%@(%@)",[dic objectForKey:@""],acount.mId];
            [array addObject:message];
        }];
        _servicePicker.pickerArrayData = array;
        [array release];
    }
    
    return _servicePicker;
    
}


#pragma mark --Life
-(void)loadView{
    
    [super loadView];
    [self.view setViewBlackColor];
    [self installSubviews];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Service_TopUp_Title", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --InstallSubviews

-(void)installSubviews{

    //1
    [self.view addBottomLineWithY:19];
    //1
    CGFloat intervalY = 20.0f;
    CGFloat serviceLabelHeight = 50;
    serviceLabel = [self.view serviceViewWithFrame:CGRectMake(0, intervalY, PHONE_UISCREEN_WIDTH, serviceLabelHeight) Title:NSLocalizedString(@"Service_TopUp_Service_TypeAndID", nil) isShowSelect:YES Target:self Action:@selector(selectService:)];
    
    //2
    accountLabel = [self.view balanceWithFrame:CGRectMake(0, intervalY+serviceLabelHeight, PHONE_UISCREEN_WIDTH, serviceLabelHeight) TextColor:[RTSSAppStyle currentAppStyle].textMajorColor TextAlignment:NSTextAlignmentLeft];
    //accountLabel.text = @"Balance:$300";
    //Credit
    
    //3
    [self.view addBottomLineWithY:intervalY*2+serviceLabelHeight*2-1];
    CGFloat height = 90;
    payTextField = [self.view addTextFieldWithFrame:CGRectMake(0, intervalY*2+serviceLabelHeight*2, PHONE_UISCREEN_WIDTH, height) Name:NSLocalizedString(@"Service_TopUp_Amount", nil) TextFieldDelegate:[[BalanceTextFieldDeleagte alloc] init] KeyboardType:UIKeyboardTypeDecimalPad isMoneySymbol:YES];
    [self addTextFieldEventEditingChanged:payTextField];
    
    //5
    CGFloat buttonBgViewY = (serviceLabelHeight+intervalY)*2+height;
    UIView *buttonBgView = [[UIView alloc]initWithFrame:CGRectMake(0,buttonBgViewY,PHONE_UISCREEN_WIDTH,PHONE_UISCREEN_HEIGHT-buttonBgViewY-64)];
    buttonBgView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    NSLog(@"buttonY= %@",NSStringFromCGRect(buttonBgView.frame));
    submitButton = [RTSSAppStyle getMajorGreenButton:CGRectMake(20, CGRectGetHeight(buttonBgView.frame)/2-45/2, CGRectGetWidth(buttonBgView.frame)-2*20, 45) target:self action:@selector(topUp) title:NSLocalizedString(@"Service_TopUp_Button_Title", nil)];
    submitButton.enabled = NO;
    [buttonBgView addSubview:submitButton];
    [self.view addSubview:buttonBgView];
    [buttonBgView release];

}

- (void)showEmptyAccountAlert{
    NSString* messageString = [NSString stringWithFormat:@"%@",NSLocalizedString(@"Service_TopUp_No_Child_Account_Alert", nil)];
    AlertController *alert = [[AlertController alloc]initWithTitle:nil message:messageString delegate:self tag:0 cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"UIAlertView_Confirm_String", nil),nil];
    [alert showInViewController:self];
    [alert release];
}

#pragma mark ---UpdateData
-(void)loadData{
    
    Session *session = [Session sharedSession];
    //nameLabel.text = session.mMyUser.mName;
  
    
    if (!session.mMyCustomer || !session.mMyCustomer.mMyAccount) {
        return;
    }

    if (!session.mMyCustomer.mMyAccount.mSubAccounts || ![session.mMyCustomer.mMyAccount.mSubAccounts count]>0) {
        [self performSelector:@selector(showEmptyAccountAlert) withObject:nil afterDelay:1.0];
        return;
    }
    
    self.subAcountsArray =session.mMyCustomer.mMyAccount.mSubAccounts;
    //获取第一条数据
    currentService = 0;
    Account *firstAcount = [self.subAcountsArray objectAtIndex:currentService];
    accountLabel.text =[NSString stringWithFormat:@"%@ %@%.2f",NSLocalizedString(@"Service_TopUp_Balance_Title", nil),NSLocalizedString(@"Currency_Unit", nil),[CommonUtils formatMoneyFromPennyToYuan:firstAcount.mAmount]];
    
    NSDictionary *dic = [[RTSSAppStyle currentAppStyle]getServiceSourceWithServiceType:firstAcount.mServiceType];
    NSString *message = [NSString stringWithFormat:@"%@(%@)",[dic objectForKey:@""],firstAcount.mId];
    serviceLabel.text = message;
    
}

#pragma mark --Touch

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self hideKeyBoard];
}

-(void)hideKeyBoard{
    [payTextField giveUpTheKeyboard];
}

#pragma mark --Action
-(void)topUp
{
    //判断为空
    if (![payTextField isTopupBalanceValid]) return;
    [self topupServie];
}
-(long long)getUserInputBalance{
    //用户金额
     CGFloat balance = [NSDecimalNumber decimalNumberWithString:payTextField.text].floatValue;
    long long penny = [CommonUtils formatMoneyFromYuanToPenny:balance];
    NSLog(@"input Balance = %lld",penny);
    return penny;
}

-(void)topupServie{
    NSLog(@"service 级别");
    if (!self.subAcountsArray || ![self.subAcountsArray count]>0) {
        return;
    }
    NSLog(@"input=====%lld",[self getUserInputBalance]);
    [APPLICATION_KEY_WINDOW makeToastActivity];
    Account *service =[self.subAcountsArray objectAtIndex:currentService];
    [service topup:[self getUserInputBalance] delegate:self];
}

-(void)selectService:(id)sender{
    
     [self hideKeyBoard];
     if (!self.subAcountsArray || ![self.subAcountsArray count]>0) {
        return;
     }
    [self.view.window addSubview:self.servicePicker.view];
}

#pragma mark --MActor Delagate
-(void)topupFinished:(NSInteger)status payParams:(NSString *)params{
    [APPLICATION_KEY_WINDOW hideToastActivity];
    
    if(MappActorFinishStatusOK == status){
        if (![params length]>0) {//判断回传是否为空
            [ APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Pay_Status_get_pay_url_failure", nil)];
        }
        PayViewController *payVC = [[PayViewController alloc]init];
        payVC.payUrlString = params;
        payVC.delegate = self;
        payVC.payAction = NSLocalizedString(@"Pay_Action_Topup", @"Topup");
        Account *service =[self.subAcountsArray objectAtIndex:currentService];
        payVC.payFor = service.mId;
        [self.navigationController pushViewController:payVC animated:YES];
        [payVC release];
        
    } else if(MappActorFinishStatusNetwork == status){
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"ErroMessage_Status_Network", nil)];
    }else {
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Service_TopUp_Failed", nil)];
    }

}
#pragma mark --SinglePickerDelegate
-(void)singlePickerWithCancel:(SinglePickerController *)controller{
    
    [controller.view removeFromSuperview];
}

-(void)singlePickerWithDone:(SinglePickerController *)controller selectedIndex:(NSInteger)index{
    
    //判断
    currentService = index;
    //更新页面数据
    Account *current =(Account*)[self.subAcountsArray objectAtIndex:index];
    accountLabel.text =[NSString stringWithFormat:@"%@ %@%.2f",NSLocalizedString(@"Service_TopUp_Balance_Title", nil),NSLocalizedString(@"Currency_Unit", nil),[CommonUtils formatMoneyFromPennyToYuan:current.mAmount]];
    
    NSDictionary *dic = [[RTSSAppStyle currentAppStyle]getServiceSourceWithServiceType:current.mServiceType];
    NSString *message = [NSString stringWithFormat:@"%@(%@)",[dic objectForKey:@""],current.mId];
    serviceLabel.text = message;
    
    [controller.view removeFromSuperview];
}
#pragma mark --AlertDelegate
-(void)alertController:(AlertController *)alertController didDismissWithButtonIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark payment delegate
- (void)paymentActionBackWithPaymentStatus:(BOOL)succeed andParameters:(NSDictionary *)parameters {
    [self performSelector:@selector(showPayResult:) withObject:parameters afterDelay:0.1];
}

- (void)showPayResult:(NSDictionary*)payResult {
    [PayViewController showPayResult:payResult inController:self delegate:nil];
}

#pragma mark --TextField
- (void)addTextFieldEventEditingChanged:(UITextField*)textField{
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
- (void)textFieldDidChange:(UITextField*)textField{
    
    NSInteger payLength = [payTextField.text length];
    submitButton.enabled = payLength > 0?YES:NO;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
