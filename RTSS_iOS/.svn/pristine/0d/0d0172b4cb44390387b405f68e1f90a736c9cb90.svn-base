//
//  RequestOTPViewController.m
//  RTSS
//
//  Created by Lyu Ming on 11/24/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import "RequestOTPViewController.h"
#import "ActivationViewController.h"
#import "UserInfoComponentView.h"
#import "TPKeyboardAvoidingScrollView.h"

#import "User.h"

@interface RequestOTPViewController ()<MappActorDelegate>{
    TPKeyboardAvoidingScrollView*           requestOTPView;
    UserInfoComponentView*                  infoComponentView;
    UIButton*                               nextButton;
}

@property(nonatomic, retain) User*          requestOTPUser;

@end

@implementation RequestOTPViewController
@synthesize requestOTPUser;

- (void)dealloc{
    [requestOTPView release];
    [infoComponentView release];
    
    [requestOTPUser release];
    
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestOTPUser = [[[User alloc] init] autorelease];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addTextFieldEventEditingChanged:(UITextField*)textField{
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)layoutRequestOTPView{
    requestOTPView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-20-44)];
    requestOTPView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    [self.view addSubview:requestOTPView];
    
    infoComponentView = [[UserInfoComponentView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 0)
                                                                type:UserInfoComponentViewTypeRequestOTP];
    
    infoComponentView.userNameItemView.itemTextField.delegate = self;
    [self addTextFieldEventEditingChanged:infoComponentView.userNameItemView.itemTextField];
    
    infoComponentView.mdnItemView.itemTextField.delegate = self;
    [self addTextFieldEventEditingChanged:infoComponentView.mdnItemView.itemTextField];
    
    [requestOTPView addSubview:infoComponentView];
    
    CGRect buttonFrame = CGRectMake(20, CGRectGetMaxY(infoComponentView.frame)+40, (requestOTPView.bounds.size.width-20*2), 45);
    nextButton = [RTSSAppStyle getMajorGreenButton:buttonFrame
                                            target:self
                                            action:@selector(nextAction:)
                                             title:NSLocalizedString(@"UIButton_Next_String", nil)];
    
    nextButton.enabled = NO;
    [requestOTPView addSubview:nextButton];
    
    UILabel* promptLabel = [CommonUtils labelWithFrame:CGRectMake(CGRectGetMinX(nextButton.frame), CGRectGetMaxY(nextButton.frame),nextButton.bounds.size.width, 45) text:NSLocalizedString(@"RequestOTPView_OTP_Button_Prompt", nil) textColor:[RTSSAppStyle currentAppStyle].textFieldPlaceholderColor textFont:[RTSSAppStyle getRTSSFontWithSize:14.0] tag:0];
    [requestOTPView addSubview:promptLabel];
    
    [requestOTPView contentSizeToFit];
}

-(void)loadView{
    [super loadView];
    
    [self layoutRequestOTPView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"RequestOTPView_Title", nil);
}

-(void)loadData{
    
}

#pragma mark Error Handle
- (BOOL)verifyFormData:(VerifyFormDataType)dataType{
    BOOL result = NO;
    if(0 == infoComponentView.userNameItemView.itemTextField.text.length && VerifyFormDataTypeRequestOTP == dataType){
        [infoComponentView refreshInfoComponentView:infoComponentView.userNameItemView completion:^(BOOL finished) {
            infoComponentView.userNameItemView.itemErrorLabel.text = NSLocalizedString(@"UserInfoView_User_ID_Length_empty", nil);
            [requestOTPView contentSizeToFit];
        }];
    }else if(infoComponentView.mdnItemView.itemTextField.text.length != 10 && VerifyFormDataTypeRequestOTP == dataType){
        [infoComponentView refreshInfoComponentView:infoComponentView.mdnItemView completion:^(BOOL finished) {
            infoComponentView.mdnItemView.itemErrorLabel.text = NSLocalizedString(@"UserInfoView_MDN_Length_Error", nil);
            [requestOTPView contentSizeToFit];
        }];
    }else {
        result = YES;
    }
    return result;
}

- (void)startActivationViewController{
    ActivationViewController* activationVC = [[ActivationViewController alloc] init];
    activationVC.userId = infoComponentView.userNameItemView.itemTextField.text;
    activationVC.phoneMobile = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"UserInfoView_MDN_Country_Code", nil), infoComponentView.mdnItemView.itemTextField.text];
    [self.navigationController pushViewController:activationVC animated:YES];
    [activationVC release];
}

#pragma mark Action
- (void)nextAction:(UIButton*)button{
#ifdef APPLICATION_BUILDING_RELEASE
    if([self verifyFormData:VerifyFormDataTypeRequestOTP]){
        [infoComponentView dismissUserInfoComponentKeyboard];
        
        [APPLICATION_KEY_WINDOW makeToastActivity];
        
        NSString* mdnString = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"UserInfoView_MDN_Country_Code", nil), infoComponentView.mdnItemView.itemTextField.text];
        [requestOTPUser requestActivationOTP:infoComponentView.userNameItemView.itemTextField.text phoneNumber:mdnString delegate:self];
    }
#else
    [self startActivationViewController];
#endif
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidChange:(UITextField*)textField{
    NSUInteger userNameLength   = infoComponentView.userNameItemView.itemTextField.text.length;
    NSUInteger mdnLength        = infoComponentView.mdnItemView.itemTextField.text.length;
    
    if(userNameLength > 0 && mdnLength > 0){
        if(NO == nextButton.enabled) nextButton.enabled = YES;
    }else {
        if(YES == nextButton.enabled) nextButton.enabled = NO;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(infoComponentView.userNameItemView.expanding || infoComponentView.mdnItemView.expanding ){
        [infoComponentView refreshInfoComponentView:nil completion:^(BOOL finished) {
            [requestOTPView contentSizeToFit];
        }];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL basicTest = NO;
    NSInteger textLength = 30;
    if(infoComponentView.userNameItemView.itemTextField == textField){
        textLength = 30;
    }else if(infoComponentView.mdnItemView.itemTextField == textField){
        textLength = 10;
    }
    
    if(range.location < textLength){
        NSCharacterSet* cs = nil;
        if(infoComponentView.userNameItemView.itemTextField == textField){
            basicTest = YES;
        }else if(infoComponentView.mdnItemView.itemTextField == textField){
            cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBER_TEXT] invertedSet];
        }else{
            basicTest = YES;
        }
        if(nil != cs){
            NSString* filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            basicTest = [string isEqualToString:filtered];
        }
    }
    
    if ([string isEqualToString:@""]) {
        basicTest = YES;
    }
    
    return basicTest;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(infoComponentView.userNameItemView.itemTextField == textField){
        [infoComponentView.mdnItemView.itemTextField becomeFirstResponder];
    }else if(infoComponentView.mdnItemView.itemTextField == textField){
        [infoComponentView.mdnItemView.itemTextField resignFirstResponder];
         [self nextAction:nextButton];
    }
    
    return YES;
}

#pragma mark MappActorDelegate
- (void)requestOTPFinished:(NSInteger)status{
    [APPLICATION_KEY_WINDOW hideToastActivity];
    
    if(MappActorFinishStatusOK == status){
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"UserInfoView_Send_OTP_Successful", nil)];
        [self startActivationViewController];
    }else if (MappActorFinishStatusNetwork == status){
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"ErroMessage_Status_Network", nil)];
    }else if(MappActorFinishStatusAlreadyActivated == status){
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"ActivationView_Already_Activated", nil)];
    }else{
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"UserInfoView_Send_OTP_Failed_Error", nil)];
    }
}

@end
