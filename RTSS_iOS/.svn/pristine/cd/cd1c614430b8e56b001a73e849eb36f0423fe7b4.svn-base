//
//  ActivationViewController.m
//  RTSS
//
//  Created by Lyu Ming on 11/24/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import "ActivationViewController.h"
#import "UserInfoComponentView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "AppDelegate.h"

#import "User.h"
#import "Session.h"

@interface ActivationViewController ()<MappActorDelegate>{
    TPKeyboardAvoidingScrollView*           activationView;
    UserInfoComponentView*                  infoComponentView;
    UIButton*                               confirmButton;
}

@property (nonatomic, retain) User*         activationUser;

@end

@implementation ActivationViewController
@synthesize activationUser, userId, phoneMobile;

- (void)dealloc{
    [userId release];
    [phoneMobile release];
    
    [activationView release];
    [infoComponentView release];
    
    [activationUser release];
    
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.activationUser = [[User alloc] init];
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

- (void)layoutActivationView{
    activationView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-20-44)];
    activationView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    [self.view addSubview:activationView];
    
    infoComponentView = [[UserInfoComponentView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 0)
                                                                type:UserInfoComponentViewTypeActivation];
    
    infoComponentView.otpItemView.itemTextField.delegate = self;
    [self addTextFieldEventEditingChanged:infoComponentView.otpItemView.itemTextField];
    TimerButton* optItemButton = (TimerButton*)infoComponentView.otpItemView.itemButton;
    if(nil != optItemButton){
        [optItemButton setTitle:NSLocalizedString(@"UserInfoView_OTP_Send_Button", nil) forState:UIControlStateNormal];
        [optItemButton start:NSLocalizedString(@"UserInfoView_OTP_Send_Button", nil) resend:NSLocalizedString(@"UserInfoView_OTP_Resend_Button", nil)];
        [optItemButton addTarget:self action:@selector(sendOTPAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    infoComponentView.userNameItemView.itemTextField.delegate = self;
    [self addTextFieldEventEditingChanged:infoComponentView.userNameItemView.itemTextField];
    TimerButton* userNameButton = (TimerButton*)infoComponentView.userNameItemView.itemButton;
    if(nil != userNameButton){
        userNameButton.enabled = NO;
        [userNameButton setTitle:NSLocalizedString(@"ActivationView_Verify_User_ID_Button", nil) forState:UIControlStateNormal];
        [userNameButton addTarget:self action:@selector(verifyUserIdAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    infoComponentView.lastPwItemView.itemTextField.delegate = self;
    [self addTextFieldEventEditingChanged:infoComponentView.lastPwItemView.itemTextField];
    [infoComponentView.lastPwItemView.itemHelpButton addTarget:self action:@selector(helpButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    infoComponentView.confirmPwItemView.itemTextField.delegate = self;
    [self addTextFieldEventEditingChanged:infoComponentView.confirmPwItemView.itemTextField];
    [activationView addSubview:infoComponentView];
    
    CGRect buttonFrame = CGRectMake(20, CGRectGetMaxY(infoComponentView.frame)+30, (activationView.bounds.size.width-20*2), 45);
    confirmButton = [RTSSAppStyle getMajorGreenButton:buttonFrame
                                               target:self
                                               action:@selector(confirmAction:)
                                                title:NSLocalizedString(@"UIButton_Confirm_String", nil)];
    confirmButton.enabled = NO;
    [activationView addSubview:confirmButton];
    
    [activationView contentSizeToFit];
}

-(void)loadView{
    [super loadView];
    
    [self layoutActivationView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"ActivationView_Title", nil);
}

-(void)loadData{
    
}

- (void)stopOTPButton{
    TimerButton* otpButton = (TimerButton* )infoComponentView.otpItemView.itemButton;
    if(nil != otpButton){
        [otpButton stop:NSLocalizedString(@"UserInfoView_OTP_Resend_Button", nil)];
    }
}

- (void)stopUserNameButton{
    TimerButton* userNameButton = (TimerButton* ) infoComponentView.userNameItemView.itemButton;
    if(nil != userNameButton){
        [userNameButton stop];
    }
}

#pragma mark Error Handle
- (BOOL)verifyFormData:(VerifyFormDataType)dataType{
    BOOL result = NO;
    if(0 == infoComponentView.otpItemView.itemTextField.text.length && VerifyFormDataTypeActication == dataType){
        [infoComponentView refreshInfoComponentView:infoComponentView.otpItemView completion:^(BOOL finished) {
            infoComponentView.otpItemView.itemErrorLabel.text = NSLocalizedString(@"UserInfoView_OTP_Length_Empty", nil);
            [activationView contentSizeToFit];
        }];
    }else if(6 != infoComponentView.otpItemView.itemTextField.text.length && VerifyFormDataTypeActication == dataType){
        [infoComponentView refreshInfoComponentView:infoComponentView.otpItemView completion:^(BOOL finished) {
            infoComponentView.otpItemView.itemErrorLabel.text = NSLocalizedString(@"UserInfoView_OTP_Length_Error", nil);
            [activationView contentSizeToFit];
        }];
    }else if((infoComponentView.userNameItemView.itemTextField.text.length < 8 || infoComponentView.userNameItemView.itemTextField.text.length > 30) && (VerifyFormDataTypeActication == dataType || VerifyFormDataTypeVerifyUserID == dataType)){
        [infoComponentView refreshInfoComponentView:infoComponentView.userNameItemView completion:^(BOOL finished) {
            infoComponentView.userNameItemView.itemErrorLabel.text = NSLocalizedString(@"UserInfoView_UserName_Length_Error", nil);
            [activationView contentSizeToFit];
        }];
    }else if(NO == [CommonUtils checkNewUserID:infoComponentView.userNameItemView.itemTextField.text]){
        [infoComponentView refreshInfoComponentView:infoComponentView.userNameItemView completion:^(BOOL finished) {
            infoComponentView.userNameItemView.itemErrorLabel.text = NSLocalizedString(@"UserInfoView_New_UserName_Chech_Error", nil);
            [activationView contentSizeToFit];
        }];
    }else if((infoComponentView.lastPwItemView.itemTextField.text.length < 8 || infoComponentView.lastPwItemView.itemTextField.text.length > 30) && VerifyFormDataTypeActication == dataType){
        [infoComponentView refreshInfoComponentView:infoComponentView.lastPwItemView completion:^(BOOL finished) {
            infoComponentView.lastPwItemView.itemErrorLabel.text = NSLocalizedString(@"UserInfoView_LastPassword_Length_Error", nil);
            [activationView contentSizeToFit];
        }];
    }else if(NO == [CommonUtils checkNewUserPassword:infoComponentView.lastPwItemView.itemTextField.text] && VerifyFormDataTypeActication == dataType){
        [infoComponentView refreshInfoComponentView:infoComponentView.lastPwItemView completion:^(BOOL finished) {
            infoComponentView.lastPwItemView.itemErrorLabel.text = NSLocalizedString(@"UserInfoView_LastPassword_Check_Error", nil);
            [activationView contentSizeToFit];
        }];
    }else if(NO == [infoComponentView.lastPwItemView.itemTextField.text isEqualToString:infoComponentView.confirmPwItemView.itemTextField.text] && VerifyFormDataTypeActication == dataType){
        [infoComponentView refreshInfoComponentView:infoComponentView.confirmPwItemView completion:^(BOOL finished) {
            infoComponentView.confirmPwItemView.itemErrorLabel.text = NSLocalizedString(@"UserInfoView_Confirm_Last_Password_Differ_Error", nil);
            [activationView contentSizeToFit];
        }];
    }else{
        result = YES;
    }
    return result;
}

#pragma mark Action
- (void)verifyUserIdAction:(TimerButton*)button{
    if([self verifyFormData:VerifyFormDataTypeVerifyUserID]){
        [self textFieldDidBeginEditing:nil];
        if(![button isStart]){
            [button start];
            [infoComponentView dismissUserInfoComponentKeyboard];
            [APPLICATION_KEY_WINDOW makeToastActivity];
            [activationUser verifyUserId:infoComponentView.userNameItemView.itemTextField.text delegate:self];
        }
    }
}

- (void)sendOTPAction:(TimerButton*)button{
    if(![button isStart]){
        [self textFieldDidBeginEditing:nil];
        [infoComponentView dismissUserInfoComponentKeyboard];
        [button start:NSLocalizedString(@"UserInfoView_OTP_Send_Button", nil) resend:NSLocalizedString(@"UserInfoView_OTP_Resend_Button", nil)];
        [activationUser requestActivationOTP:self.userId phoneNumber:self.phoneMobile delegate:self];
    }
}

- (void)helpButtonAction:(UIButton*)button{
    [infoComponentView dismissUserInfoComponentKeyboard];
    [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"UserInfoView_UserPassword_Help_Prompt", nil) duration:4.0 position:CSToastPositionBottom];
}

- (void)confirmAction:(UIButton*)button{
    if([self verifyFormData:VerifyFormDataTypeActication]){
        [APPLICATION_KEY_WINDOW makeToastActivity];
        [infoComponentView dismissUserInfoComponentKeyboard];
        [activationUser activation:self.userId otp:infoComponentView.otpItemView.itemTextField.text desiredUserId:infoComponentView.userNameItemView.itemTextField.text desiredPassword:infoComponentView.confirmPwItemView.itemTextField.text delegate:self];
    }
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidChange:(UITextField*)textField{
    NSUInteger otpLength            = infoComponentView.otpItemView.itemTextField.text.length;
    NSUInteger userNameLength       = infoComponentView.userNameItemView.itemTextField.text.length;
    NSUInteger lastPWLength         = infoComponentView.lastPwItemView.itemTextField.text.length;
    NSUInteger confirmPWLength      = infoComponentView.confirmPwItemView.itemTextField.text.length;
    UIButton* userNameButton        = infoComponentView.userNameItemView.itemButton;
    //UIButton* otpButton             = infoComponentView.otpItemView.itemButton;
    
    if(otpLength > 0 && userNameLength > 0 && lastPWLength > 0 && confirmPWLength > 0){
        if(NO == confirmButton.enabled) confirmButton.enabled = YES;
    }else {
        if(YES == confirmButton.enabled) confirmButton.enabled = NO;
    }
    if(userNameLength > 0){
        if(NO == userNameButton.enabled) userNameButton.enabled = YES;
    }else{
        if(YES == userNameButton.enabled) userNameButton.enabled = NO;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(infoComponentView.otpItemView.expanding || infoComponentView.userNameItemView.expanding || infoComponentView.lastPwItemView.expanding || infoComponentView.confirmPwItemView.expanding){
        [infoComponentView refreshInfoComponentView:nil completion:^(BOOL finished) {
            [activationView contentSizeToFit];
        }];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL basicTest = NO;
    NSInteger textLength = 0;
    if(infoComponentView.otpItemView.itemTextField == textField){
        textLength = 6;
    }else if(infoComponentView.userNameItemView.itemTextField == textField){
        textLength = 30;
    }else if(infoComponentView.lastPwItemView.itemTextField == textField || infoComponentView.confirmPwItemView.itemTextField == textField){
        textLength = 30;
    }
    
    if(range.location < textLength){
        
        NSCharacterSet* cs = nil;
        if(infoComponentView.otpItemView.itemTextField == textField){
            cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBER_TEXT] invertedSet];
        }else if(infoComponentView.userNameItemView.itemTextField == textField){
            cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHADECIMAL_TEXT] invertedSet];
        }else if(infoComponentView.lastPwItemView.itemTextField == textField ||
                 infoComponentView.confirmPwItemView.itemTextField == textField){
            basicTest = YES;
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
    if(infoComponentView.otpItemView.itemTextField == textField){
        [infoComponentView.userNameItemView.itemTextField becomeFirstResponder];
    }else if(infoComponentView.userNameItemView.itemTextField == textField){
        [infoComponentView.lastPwItemView.itemTextField becomeFirstResponder];
    }else if(infoComponentView.lastPwItemView.itemTextField == textField){
        [infoComponentView.confirmPwItemView.itemTextField becomeFirstResponder];
    }else if(infoComponentView.confirmPwItemView.itemTextField == textField){
        [infoComponentView.confirmPwItemView.itemTextField resignFirstResponder];
        [self confirmAction:confirmButton];
    }
    
    return YES;
}

#pragma mark MappActorDelegate
- (void)verifyUserIdFinished:(NSInteger)status suggestedUserIds:(NSArray*)suggestedUserIds{
    [APPLICATION_KEY_WINDOW hideToastActivity];
    [self stopUserNameButton];
    if(MappActorFinishStatusOK == status){
        [infoComponentView refreshInfoComponentView:infoComponentView.userNameItemView completion:^(BOOL finished) {
            infoComponentView.userNameItemView.itemErrorLabel.text = NSLocalizedString(@"UserInfoView_Verify_User_ID_Available", nil);
            [activationView contentSizeToFit];
        }];
    }else if(MappActorFinishStatusUserIdDuplicate == status){
        [infoComponentView refreshInfoComponentView:infoComponentView.userNameItemView completion:^(BOOL finished) {
            infoComponentView.userNameItemView.itemErrorLabel.text = NSLocalizedString(@"UserInfoView_Verify_User_ID_Duplicate", nil);
            [activationView contentSizeToFit];
        }];
    }else if(MappActorFinishStatusNetwork == status){
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"ErroMessage_Status_Network", nil)];
    }else{
        [infoComponentView refreshInfoComponentView:infoComponentView.userNameItemView completion:^(BOOL finished) {
            infoComponentView.userNameItemView.itemErrorLabel.text = NSLocalizedString(@"UserInfoView_Verify_User_ID_Invalid", nil);
            [activationView contentSizeToFit];
        }];
    }
}

- (void)requestOTPFinished:(NSInteger)status{
    
    if(MappActorFinishStatusOK == status){
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"UserInfoView_Resend_OTP_Successful", nil)];
    }else if(MappActorFinishStatusOTPMissMatch == status){
        [self stopOTPButton];
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"UserInfoView_OTP_Wrong_Error", nil)];
    }else if (MappActorFinishStatusNetwork == status){
        [self stopOTPButton];
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"ErroMessage_Status_Network", nil)];
    }else{
        [self stopOTPButton];
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"UserInfoView_Send_OTP_Failed_Error", nil)];
    }
}

- (void)activationFinished:(NSInteger)status suggestedUserIds:(NSArray*)suggestedUserIds{
    [APPLICATION_KEY_WINDOW hideToastActivity];
    
    if(MappActorFinishStatusOK == status){
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"ActivationView_Activation_Successful", nil)];
        [APPLICATION_KEY_WINDOW makeToastActivity];
        [activationUser login:infoComponentView.userNameItemView.itemTextField.text password:infoComponentView.confirmPwItemView.itemTextField.text rememberMe:NO delegate:self];
    }else if (MappActorFinishStatusNetwork == status){
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"ErroMessage_Status_Network", nil)];
    } else if (MappActorFinishStatusAlreadyActivated == status) {
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"ActivationView_Already_Activated", nil)];
    }else{
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"ActivationView_Activation_Failed", nil)];
    }
}

- (void)loginFinished:(NSInteger)status customer:(NSObject*)customer{
    [APPLICATION_KEY_WINDOW hideToastActivity];
    
    if(MappActorFinishStatusOK == status){
        [Session sharedSession].mMyUser     = self.activationUser;
        [Session sharedSession].mMyCustomer = (Customer*)customer;
        [[AppDelegate shareAppDelegate] startRTSSViewControllerType:RTSSViewControllerTypeHome];
    }else if (MappActorFinishStatusNetwork == status){
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"ErroMessage_Status_Network", nil)];
    }else{
        [[AppDelegate shareAppDelegate] startRTSSViewControllerType:RTSSViewControllerTypeLogin];
    }
}

@end
