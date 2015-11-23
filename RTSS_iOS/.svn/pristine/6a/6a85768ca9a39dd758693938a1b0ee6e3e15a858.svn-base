//
//  FindPasswordViewController.m
//  RTSS
//
//  Created by shengyp on 14/10/23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "ActionSheetController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "AppDelegate.h"

#import "User.h"
#import "Session.h"

@implementation FindPasswordDataModel
@synthesize userId, otp, desiredPassword;

- (void)dealloc
{
    [userId release];
    [otp release];
    [desiredPassword release];
    
    [super dealloc];
}

@end

@interface FindPasswordViewController ()<AlertControllerDelegate,ActionSheetControllerDelegate,MappActorDelegate>{
    TPKeyboardAvoidingScrollView*           forgotPasswordView;
    UserInfoComponentView*                  infoComponentView;
    UIButton*                               submitButton;
}

@property(nonatomic, retain) User*          findPasswordUser;

@end

@implementation FindPasswordViewController
@synthesize findPasswordUser, viewType, dataModel;

- (void)dealloc{
    [forgotPasswordView release];
    [infoComponentView release];
    
    [findPasswordUser release];
    [dataModel release];
    
    [super dealloc];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.findPasswordUser = [[[User alloc] init] autorelease];
        self.viewType = UserInfoComponentViewTypeForgotUserID;
        self.dataModel = [[[FindPasswordDataModel alloc] init] autorelease];
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

- (void)layoutForgotPwView{
    forgotPasswordView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-20-44)];
    forgotPasswordView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    [self.view addSubview:forgotPasswordView];
    
    if(UserInfoComponentViewTypeForgotUserID == self.viewType){
        infoComponentView = [[UserInfoComponentView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 0)
                                                                    type:UserInfoComponentViewTypeForgotUserID];
        
        infoComponentView.userNameItemView.itemTextField.delegate = self;
        [self addTextFieldEventEditingChanged:infoComponentView.userNameItemView.itemTextField];
        
    }else if(UserInfoComponentViewTypeForgotOTP == self.viewType){
        infoComponentView = [[UserInfoComponentView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 0)
                                                                    type:UserInfoComponentViewTypeForgotOTP];
        
        infoComponentView.otpItemView.itemTextField.delegate = self;
        [self addTextFieldEventEditingChanged:infoComponentView.otpItemView.itemTextField];
        TimerButton* optItemButton = (TimerButton*)infoComponentView.otpItemView.itemButton;
        if(nil != optItemButton){
            [optItemButton setTitle:NSLocalizedString(@"UserInfoView_OTP_Send_Button", nil) forState:UIControlStateNormal];
            [optItemButton start:NSLocalizedString(@"UserInfoView_OTP_Send_Button", nil) resend:NSLocalizedString(@"UserInfoView_OTP_Resend_Button", nil)];
            [optItemButton addTarget:self action:@selector(sendOTPAction:) forControlEvents:UIControlEventTouchUpInside];
        }

        infoComponentView.lastPwItemView.itemTextField.delegate = self;
        [self addTextFieldEventEditingChanged:infoComponentView.lastPwItemView.itemTextField];
        [infoComponentView.lastPwItemView.itemHelpButton addTarget:self action:@selector(helpButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        infoComponentView.confirmPwItemView.itemTextField.delegate = self;
        [self addTextFieldEventEditingChanged:infoComponentView.confirmPwItemView.itemTextField];
    }
    infoComponentView.backgroundColor = [RTSSAppStyle currentAppStyle].userInfoComponentBgColor;
    [forgotPasswordView addSubview:infoComponentView];
    
    CGRect buttonFrame = CGRectMake(30, CGRectGetMaxY(infoComponentView.frame)+60, (forgotPasswordView.bounds.size.width-30*2), 45);
    submitButton = [RTSSAppStyle getMajorGreenButton:buttonFrame
                                              target:self
                                              action:@selector(submitAction:)
                                               title:NSLocalizedString(@"UIButton_Submit_String", nil)];
    submitButton.enabled = NO;
    submitButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [forgotPasswordView addSubview:submitButton];
    
    if(UserInfoComponentViewTypeForgotUserID == self.viewType){
        UILabel* promptLabel = [CommonUtils labelWithFrame:CGRectMake(10, CGRectGetMaxY(submitButton.frame), (forgotPasswordView.bounds.size.width-10*2), 40) text:NSLocalizedString(@"FindPasswordView_User_ID_Button_Prompt", nil) textColor:[RTSSAppStyle currentAppStyle].textFieldPlaceholderColor textFont:[RTSSAppStyle getRTSSFontWithSize:14.0] tag:0];
//        promptLabel.adjustsFontSizeToFitWidth = YES;
        [forgotPasswordView addSubview:promptLabel];
    }
    
    [forgotPasswordView contentSizeToFit];
}

- (void)loadView{
    [super loadView];
    
    [self layoutForgotPwView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"FindPasswordView_Title", nil);
}

- (void)loadData{
    
}

- (void)stopOTPButton{
    TimerButton* otpButton = (TimerButton* )infoComponentView.otpItemView.itemButton;
    if(nil != otpButton){
        [otpButton stop:NSLocalizedString(@"UserInfoView_OTP_Resend_Button", nil)];
    }
}

- (void)startViewController:(UserInfoComponentViewType)type{
    FindPasswordViewController* viewController = [[FindPasswordViewController alloc] init];
    viewController.viewType = type;
    viewController.dataModel = self.dataModel;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

#pragma mark Error Handle
- (BOOL)verifyFormData:(VerifyFormDataType)dataType{
    BOOL result = NO;
    
    if(UserInfoComponentViewTypeForgotUserID == self.viewType){
        if(0 == infoComponentView.userNameItemView.itemTextField.text.length){
            [infoComponentView refreshInfoComponentView:infoComponentView.userNameItemView completion:^(BOOL finished) {
                infoComponentView.userNameItemView.itemErrorLabel.text = NSLocalizedString(@"UserInfoView_User_ID_Length_empty", nil);
                [forgotPasswordView contentSizeToFit];
            }];
        }else {
           result = YES;
        }
    }else if(UserInfoComponentViewTypeForgotOTP == self.viewType){
        if(0 == infoComponentView.otpItemView.itemTextField.text.length && VerifyFormDataTypeForgotOTP == dataType){
            [infoComponentView refreshInfoComponentView:infoComponentView.otpItemView completion:^(BOOL finished) {
                infoComponentView.otpItemView.itemErrorLabel.text = NSLocalizedString(@"UserInfoView_OTP_Length_Empty", nil);
                [forgotPasswordView contentSizeToFit];
            }];
        }else if(6 != infoComponentView.otpItemView.itemTextField.text.length && VerifyFormDataTypeForgotOTP == dataType){
            [infoComponentView refreshInfoComponentView:infoComponentView.otpItemView completion:^(BOOL finished) {
                infoComponentView.otpItemView.itemErrorLabel.text = NSLocalizedString(@"UserInfoView_OTP_Length_Error", nil);
                [forgotPasswordView contentSizeToFit];
            }];
        }else if((infoComponentView.lastPwItemView.itemTextField.text.length < 8 || infoComponentView.lastPwItemView.itemTextField.text.length > 30) && VerifyFormDataTypeForgotOTP == dataType){
            [infoComponentView refreshInfoComponentView:infoComponentView.lastPwItemView completion:^(BOOL finished) {
                infoComponentView.lastPwItemView.itemErrorLabel.text = NSLocalizedString(@"UserInfoView_LastPassword_Length_Error", nil);
                [forgotPasswordView contentSizeToFit];
            }];
        }else if(NO == [CommonUtils checkNewUserPassword:infoComponentView.lastPwItemView.itemTextField.text] && VerifyFormDataTypeForgotOTP == dataType){
            [infoComponentView refreshInfoComponentView:infoComponentView.lastPwItemView completion:^(BOOL finished) {
                infoComponentView.lastPwItemView.itemErrorLabel.text = NSLocalizedString(@"UserInfoView_LastPassword_Check_Error", nil);
                [forgotPasswordView contentSizeToFit];
            }];
        }else if(NO == [infoComponentView.lastPwItemView.itemTextField.text isEqualToString:infoComponentView.confirmPwItemView.itemTextField.text] && VerifyFormDataTypeForgotOTP == dataType){
            [infoComponentView refreshInfoComponentView:infoComponentView.confirmPwItemView completion:^(BOOL finished) {
                infoComponentView.confirmPwItemView.itemErrorLabel.text = NSLocalizedString(@"UserInfoView_Confirm_Last_Password_Differ_Error", nil);
                [forgotPasswordView contentSizeToFit];
            }];
        }else{
            result = YES;
        }
    }

    return result;
}

#pragma mark Action
- (void)helpButtonAction:(UIButton*)button{
    [infoComponentView dismissUserInfoComponentKeyboard];
    [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"UserInfoView_UserPassword_Help_Prompt", nil) duration:4.0 position:CSToastPositionBottom];
}

- (void)sendOTPAction:(TimerButton*)button{
    if(![button isStart]){
        [self textFieldDidBeginEditing:nil];
        [button start:NSLocalizedString(@"UserInfoView_OTP_Send_Button", nil) resend:NSLocalizedString(@"UserInfoView_OTP_Resend_Button", nil)];
        [findPasswordUser requestResetPasswordOTP:dataModel.userId delegate:self];
    }
}

- (void)submitAction:(UIButton*)button{
    if(UserInfoComponentViewTypeForgotUserID == self.viewType){
#ifdef APPLICATION_BUILDING_RELEASE
        if([self verifyFormData:VerifyFormDataTypeForgotUserID]){
            [infoComponentView dismissUserInfoComponentKeyboard];
            [APPLICATION_KEY_WINDOW makeToastActivity];
            
            dataModel.userId = infoComponentView.userNameItemView.itemTextField.text;
            [findPasswordUser requestResetPasswordOTP:dataModel.userId delegate:self];
        }
#else
        [self startViewController:UserInfoComponentViewTypeForgotOTP];
#endif
    }else if(UserInfoComponentViewTypeForgotOTP == self.viewType){
#ifdef APPLICATION_BUILDING_RELEASE
        if([ self verifyFormData:VerifyFormDataTypeForgotOTP]){
            [infoComponentView dismissUserInfoComponentKeyboard];
            [APPLICATION_KEY_WINDOW makeToastActivity];
            
            dataModel.otp = infoComponentView.otpItemView.itemTextField.text;
            dataModel.desiredPassword = infoComponentView.confirmPwItemView.itemTextField.text;
            [findPasswordUser resetPassword:dataModel.userId otp:dataModel.otp desiredPassword:dataModel.desiredPassword delegate:self];
        }
#else
        
#endif
    }
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidChange:(UITextField*)textField{
    BOOL isRight = NO;
    if(UserInfoComponentViewTypeForgotUserID == self.viewType){
        NSUInteger userNameLength = infoComponentView.userNameItemView.itemTextField.text.length;
        if(userNameLength > 0){
            isRight = YES;
        }
    }else if (UserInfoComponentViewTypeForgotOTP == self.viewType){
        NSUInteger otpLength = infoComponentView.otpItemView.itemTextField.text.length;
        NSUInteger lastPwLength     = infoComponentView.lastPwItemView.itemTextField.text.length;
        NSUInteger confirmPwLength  = infoComponentView.confirmPwItemView.itemTextField.text.length;
        if(otpLength > 0 && lastPwLength > 0 && confirmPwLength > 0){
            isRight = YES;
        }
    }
    
    if(isRight){
        if(NO == submitButton.enabled) submitButton.enabled = YES;
    }else{
        if(YES == submitButton.enabled) submitButton.enabled = NO;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(infoComponentView.userNameItemView.expanding || infoComponentView.otpItemView.expanding || infoComponentView.lastPwItemView.expanding || infoComponentView.confirmPwItemView.expanding){
        [infoComponentView refreshInfoComponentView:nil completion:^(BOOL finished) {
            [forgotPasswordView contentSizeToFit];
        }];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL basicTest = NO;
    NSInteger textLength = 30;
    if(infoComponentView.userNameItemView.itemTextField == textField){
        textLength = 30;
    }else if(infoComponentView.otpItemView.itemTextField == textField){
        textLength = 6;
    }else if (infoComponentView.lastPwItemView.itemTextField == textField || infoComponentView.confirmPwItemView.itemTextField == textField){
        textLength = 30;
    }

    if(range.location < textLength){
        NSCharacterSet* cs = nil;
        if(infoComponentView.userNameItemView.itemTextField == textField){
            basicTest = YES;
        }else if(infoComponentView.otpItemView.itemTextField == textField){
            cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBER_TEXT] invertedSet];
        }else if(infoComponentView.lastPwItemView.itemTextField == textField || infoComponentView.confirmPwItemView.itemTextField == textField){
            basicTest = YES;
        }else {
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(UserInfoComponentViewTypeForgotUserID == self.viewType){
        if(infoComponentView.userNameItemView.itemTextField == textField){
            [infoComponentView.userNameItemView.itemTextField resignFirstResponder];
            [self submitAction:submitButton];
        }
    }else if(UserInfoComponentViewTypeForgotOTP == self.viewType){
        if(infoComponentView.otpItemView.itemTextField == textField){
            [infoComponentView.userNameItemView.itemTextField becomeFirstResponder];
        }else if(infoComponentView.userNameItemView.itemTextField == textField){
            [infoComponentView.lastPwItemView.itemTextField becomeFirstResponder];
        }else if(infoComponentView.lastPwItemView.itemTextField == textField){
            [infoComponentView.confirmPwItemView.itemTextField becomeFirstResponder];
        }else if(infoComponentView.confirmPwItemView.itemTextField == textField){
            [infoComponentView.confirmPwItemView.itemTextField resignFirstResponder];
            [self submitAction:submitButton];
        }
    }
    
    return YES;
}

#pragma mark MappActorDelegate
- (void)requestOTPFinished:(NSInteger)status{
    [APPLICATION_KEY_WINDOW hideToastActivity];

    if(MappActorFinishStatusOK == status && UserInfoComponentViewTypeForgotUserID == self.viewType){
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"UserInfoView_Send_OTP_Successful", nil)];
        [self startViewController:UserInfoComponentViewTypeForgotOTP];
    }else if(MappActorFinishStatusOK == status && UserInfoComponentViewTypeForgotOTP == self.viewType){
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"UserInfoView_Resend_OTP_Successful", nil)];
    }else if(MappActorFinishStatusOTPMissMatch == status){
        [self stopOTPButton];
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"UserInfoView_OTP_Wrong_Error", nil)];
    }else if(MappActorFinishStatusNetwork == status){
        [self stopOTPButton];
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"ErroMessage_Status_Network", nil)];
    }else{
        if(UserInfoComponentViewTypeForgotUserID == self.viewType){
            [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"UserInfoView_Send_OTP_Failed_Error", nil)];
        }else if(UserInfoComponentViewTypeForgotOTP == self.viewType){
            [self stopOTPButton];
            [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"UserInfoView_Send_OTP_Failed_Error", nil)];
        }else {
            [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"UserInfoView_Send_OTP_Failed_Error", nil)];
        }
    }
}

- (void)resetPasswordFinished:(NSInteger)status{
    [APPLICATION_KEY_WINDOW hideToastActivity];
    
    if(MappActorFinishStatusOK == status){
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"UserInfoView_Reset_Password_successful", nil)];
        [APPLICATION_KEY_WINDOW makeToastActivity];
        [findPasswordUser login:dataModel.userId password:dataModel.desiredPassword rememberMe:NO delegate:self];
    }else if(MappActorFinishStatusNetwork == status){
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"ErroMessage_Status_Network", nil)];
    } else{
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"UserInfoView_Reset_Password_Failed_Error", nil)];
    }
}

- (void)loginFinished:(NSInteger)status customer:(NSObject*)customer{
    [APPLICATION_KEY_WINDOW hideToastActivity];
    
    if(MappActorFinishStatusOK == status){
        [Session sharedSession].mMyUser = self.findPasswordUser;
        [Session sharedSession].mMyCustomer = (Customer*)customer;
        [[AppDelegate shareAppDelegate] startRTSSViewControllerType:RTSSViewControllerTypeHome];
    }else if(MappActorFinishStatusNetwork == status){
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"ErroMessage_Status_Network", nil)];
    } else {
        [[AppDelegate shareAppDelegate] startRTSSViewControllerType:RTSSViewControllerTypeLogin];
    }
}

@end
