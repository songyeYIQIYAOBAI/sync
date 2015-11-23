//
//  AcountTopupViewController.m
//  RTSS
//
//  Created by 蔡杰 on 14-10-26.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "AcountTopupViewController.h"
#import "ChoicePayModeViewController.h"
#import "UIView+RTSSAddView.h"
#import "UILabel+LabelTextColor.h"
#import "UITextField+CheckState.h"
#import "SinglePickerController.h"
#import "Subscriber.h"
#import "ErrorMessage.h"
#import "Session.h"
#import "Account.h"
#import "MManager.h"
#import "BalanceTextFieldDeleagte.h"
#import "PayViewController.h"



#define kRTSSAcountTopUplrEdge 20
#define kRTSSAcountTopUpEdge  15 //距离顶部
#define kRTSSInfoLabelWidth   150
#define kRTSSInfoLabelHeight  20
#define kRTSSInfoLabelSpace   10

@interface AcountTopupViewController ()<UITextFieldDelegate,SinglePickerDelegate,MappActorDelegate,AlertControllerDelegate,PaymentActionDelegate>
{
    UILabel *accountLabel;
    UILabel *accountIDLabel;
    UITextField *payTextField;
    
    BOOL flag; //判断是否支付成功
}

@property(retain,nonatomic)NSArray *subAcountsArray;
@end

@implementation AcountTopupViewController{
    UIButton *submitButton;
}
@synthesize subAcountsArray;
-(void)dealloc{
   [subAcountsArray release];
    [super dealloc];
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
    self.title = NSLocalizedString(@"Account_TopUp_Title", nil);
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self hideKeyBoard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --InstallSubviews

-(void)installSubviews{
    
    [self.view addBottomLineWithY:19];
    CGFloat intervalY = 20.0f;
    //1
    CGFloat serviceLabelHeight = 50;
    accountIDLabel = [self.view addLabelWithFrame:CGRectMake(0, intervalY, PHONE_UISCREEN_WIDTH, serviceLabelHeight) Title:NSLocalizedString(@"Account_TopUp_AccountID", nil)];
    //2
    accountLabel = [self.view balanceWithFrame:CGRectMake(0, intervalY+serviceLabelHeight, PHONE_UISCREEN_WIDTH, serviceLabelHeight) TextColor:[RTSSAppStyle currentAppStyle].textMajorColor TextAlignment:NSTextAlignmentLeft];
    // accountLabel.text = @"Balance:$300";
    
    //3
    [self.view addBottomLineWithY:intervalY*2+serviceLabelHeight*2-1];
    CGFloat height = 90;
    payTextField = [self.view addTextFieldWithFrame:CGRectMake(0, serviceLabelHeight*2+intervalY*2, PHONE_UISCREEN_WIDTH, height) Name:NSLocalizedString(@"Account_TopUp_Amount", nil) TextFieldDelegate:[[BalanceTextFieldDeleagte alloc]init] KeyboardType:UIKeyboardTypeDecimalPad isMoneySymbol:YES];
    [self addTextFieldEventEditingChanged:payTextField];
    
    //5
    CGFloat buttonBgViewY =  buttonBgViewY = (serviceLabelHeight+intervalY)*2+height;
    UIView *buttonBgView = [[UIView alloc] initWithFrame:CGRectMake(0,buttonBgViewY,PHONE_UISCREEN_WIDTH,PHONE_UISCREEN_HEIGHT-buttonBgViewY-64)];
    buttonBgView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    NSLog(@"buttonY= %@",NSStringFromCGRect(buttonBgView.frame));
    submitButton = [RTSSAppStyle getMajorGreenButton:CGRectMake(20,CGRectGetHeight(buttonBgView.frame)/2-45/2, CGRectGetWidth(buttonBgView.frame)-2*20, 45) target:self action:@selector(topUp) title:NSLocalizedString(@"Account_TopUp_Button_Title", nil)];
    submitButton.enabled = NO;
    [buttonBgView addSubview:submitButton];
    [self.view addSubview:buttonBgView];
    [buttonBgView release];
}

#pragma mark ---UpdateData
-(void)loadData{

    flag = NO;
    
    Session *session = [[MManager sharedMManager] getSession];
    //获取第一条数据
//    if (!session.mCurrentSubscriber) {
//        return;
//    }
    Account *acount = session.mCurrentAccount;
    if (!acount) {//用户账户不存在
        return;
    }

    NSString *mCustomerType = @"";
    if (acount.mPaidType == 1) {
        mCustomerType = NSLocalizedString(@"Account_TopUp_Balance_Title", nil);
    }else if (acount.mPaidType == 2){
        mCustomerType = NSLocalizedString(@"Account_TopUp_Credit_Title", nil);
    }
    accountLabel.text =[NSString stringWithFormat:@"%@ %@%.2f",mCustomerType,NSLocalizedString(@"Currency_Unit", nil),[CommonUtils formatMoneyFromPennyToYuan:acount.mRemainAmount]];
    [accountLabel sizeToFit];
    accountIDLabel.text = acount.mId;
    
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
        //打开 账户充值
        [self topupAccount];
}
-(long long)getUserInputBalance{
    //用户金额
    CGFloat balance = [NSDecimalNumber decimalNumberWithString:payTextField.text].floatValue;
    long long penny = [CommonUtils formatMoneyFromYuanToPenny:balance];
     NSLog(@"input Balance = %lld",penny);
    return penny;
}
-(void)topupAccount{
    NSLog(@"account 级别");
    
    NSLog(@"input=====%lld",[self getUserInputBalance]);

    [APPLICATION_KEY_WINDOW makeToastActivity];
    Account *account = [[MManager sharedMManager] getSession].mCurrentAccount;
    [account topup:[self getUserInputBalance] delegate:self];
    
//    AlertController *alert = [[AlertController alloc]initWithTitle:nil message:@"Ok to top up?" delegate:self tag:2000 cancelButtonTitle:NSLocalizedString(@"UIAlertView_Cancel_String", nil) otherButtonTitles:NSLocalizedString(@"UIAlertView_Confirm_String", nil),nil];
//    [alert showInViewController:self];
//    [alert release];
 
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
        Account *account = [[MManager sharedMManager] getSession].mCurrentAccount;
        payVC.payFor = account.mId;
        [self.navigationController pushViewController:payVC animated:YES];
        [payVC release];

        
    } else if(MappActorFinishStatusNetwork == status){
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"ErroMessage_Status_Network", nil)];
    }else {
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"Account_TopUp_Failed", nil)];
    }
}
#pragma mark --AlertDelegate
-(void)alertController:(AlertController *)alertController didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
//    if (alertController.tag == 2000) {
//        
//        if (buttonIndex==0) {
//            //用户取消不做任何处理
//            
//        }else if(buttonIndex == 1){
//            //用户确认支付
//            NSLog(@"用户确认支付");
//            [APPLICATION_KEY_WINDOW makeToastActivity];
//            Account *account = [Session sharedSession].mCurrentSubscriber.mDefaultAccount;
//            [account topup:[self getUserInputBalance] delegate:self];
//        }
//        return;
//    }
//
//    [self.navigationController popViewControllerAnimated:YES];
    
    if (flag) {
        //支付成功  sysc
        [APPLICATION_KEY_WINDOW makeToastActivity];
        Session *session = [[MManager sharedMManager] getSession];
        Customer *customer = session.mMyCustomer;
        [customer sync:self];
    }else{
        [APPLICATION_KEY_WINDOW hideToastActivity];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

#pragma mark payment delegate
- (void)paymentActionBackWithPaymentStatus:(BOOL)succeed andParameters:(NSDictionary *)parameters {
    [self performSelector:@selector(showPayResult:) withObject:parameters afterDelay:0.1];
}

- (void)showPayResult:(NSDictionary*)payResult {
    NSString* status = [payResult objectForKey:@"Status"];
    if (YES == [status isEqualToString:@"000"]) {
        flag = YES;
    } else {
        
    }
    
    [PayViewController showPayResult:payResult inController:self delegate:self];
//    [PayViewController showPayResult:payResult inController:self delegate:nil];
}

-(void)syncFinished:(NSInteger)status{
    [APPLICATION_KEY_WINDOW hideToastActivity];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark --UItextField

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