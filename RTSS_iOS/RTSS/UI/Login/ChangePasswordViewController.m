//
//  ChangePasswordViewController.m
//  RTSS
//
//  Created by shengyp on 14/10/23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "UserInfoComponentView.h"
#import "ActionSheetController.h"
#include "TPKeyboardAvoidingScrollView.h"

#import "User.h"
#import "Session.h"

@interface ChangePasswordViewController ()<MappActorDelegate>{
    
    TPKeyboardAvoidingScrollView*           changePasswordView;
    UserInfoComponentView*                  infoComponentView;
    UIButton*                               changeButton;
}

@end

@implementation ChangePasswordViewController

- (void)dealloc{
    [changePasswordView release];
    [infoComponentView release];
    
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

- (void)addTextFieldEventEditingChanged:(UITextField*)textField{
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)layoutChangePassWordView{
    changePasswordView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-20-44)];
    changePasswordView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    [self.view addSubview:changePasswordView];
    
    infoComponentView = [[UserInfoComponentView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 0)
                                                                type:UserInfoComponentViewTypeModifPw];
    infoComponentView.backgroundColor = [RTSSAppStyle currentAppStyle].userInfoComponentBgColor;
    
    infoComponentView.oldPwItemView.itemTextField.delegate = self;
    [self addTextFieldEventEditingChanged:infoComponentView.oldPwItemView.itemTextField];
    
    infoComponentView.lastPwItemView.itemTextField.delegate = self;
    [self addTextFieldEventEditingChanged:infoComponentView.lastPwItemView.itemTextField];
    [infoComponentView.lastPwItemView.itemHelpButton addTarget:self action:@selector(helpButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    infoComponentView.confirmPwItemView.itemTextField.delegate = self;
    [self addTextFieldEventEditingChanged:infoComponentView.confirmPwItemView.itemTextField];
    
    UIView* spaceLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, infoComponentView.bounds.size.width, 1)];
    spaceLineView.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [infoComponentView addSubview:spaceLineView];
    [spaceLineView release];
    
    [changePasswordView addSubview:infoComponentView];
    
    CGRect buttonFrame = CGRectMake(20, CGRectGetMaxY(infoComponentView.frame)+((CGRectGetHeight(changePasswordView.frame)-CGRectGetMaxY(infoComponentView.frame)-45)/2.0), (changePasswordView.bounds.size.width-20*2), 45);
    changeButton = [RTSSAppStyle getMajorGreenButton:buttonFrame target:self action:@selector(changeAction:) title:NSLocalizedString(@"UIButton_Submit_String", nil)];
    changeButton.enabled = NO;
    [changePasswordView addSubview:changeButton];
    
    [changePasswordView contentSizeToFit];
}

- (void)loadView{
    [super loadView];
    
    [self layoutChangePassWordView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"ChangePasswordView_Title", nil);
}

- (void)loadData{
    
}

- (BOOL)verifyFormData:(VerifyFormDataType)dataType{
    BOOL result = NO;
    if(0 == infoComponentView.oldPwItemView.itemTextField.text.length && VerifyFormDataTypeChangePw == dataType){
        [infoComponentView refreshInfoComponentView:infoComponentView.oldPwItemView completion:^(BOOL finished) {
            infoComponentView.oldPwItemView.itemErrorLabel.text = NSLocalizedString(@"UserInfoView_Old_PW_Length_Empty", nil);
            [changePasswordView contentSizeToFit];
        }];
    }else if((infoComponentView.lastPwItemView.itemTextField.text.length < 8 || infoComponentView.lastPwItemView.itemTextField.text.length > 30) && VerifyFormDataTypeChangePw == dataType){
        [infoComponentView refreshInfoComponentView:infoComponentView.lastPwItemView completion:^(BOOL finished) {
            infoComponentView.lastPwItemView.itemErrorLabel.text = NSLocalizedString(@"UserInfoView_LastPassword_Length_Error", nil);
            [changePasswordView contentSizeToFit];
        }];
    }else if(NO == [CommonUtils checkNewUserPassword:infoComponentView.lastPwItemView.itemTextField.text] && VerifyFormDataTypeChangePw == dataType){
        [infoComponentView refreshInfoComponentView:infoComponentView.lastPwItemView completion:^(BOOL finished) {
            infoComponentView.lastPwItemView.itemErrorLabel.text = NSLocalizedString(@"UserInfoView_LastPassword_Check_Error", nil);
        }];
    }else if(NO == [infoComponentView.lastPwItemView.itemTextField.text isEqualToString:infoComponentView.confirmPwItemView.itemTextField.text] && VerifyFormDataTypeChangePw == dataType){
        [infoComponentView refreshInfoComponentView:infoComponentView.confirmPwItemView completion:^(BOOL finished) {
            infoComponentView.confirmPwItemView.itemErrorLabel.text = NSLocalizedString(@"UserInfoView_Confirm_Last_Password_Differ_Error", nil);
            [changePasswordView contentSizeToFit];
        }];
    }else{
        result = YES;
    }
    return result;
}

#pragma mark Action
- (void)helpButtonAction:(UIButton*)button{
    [infoComponentView dismissUserInfoComponentKeyboard];
    [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"UserInfoView_UserPassword_Help_Prompt", nil) duration:4.0 position:CSToastPositionBottom];
}

- (void)changeAction:(UIButton*)button{
    if([self verifyFormData:VerifyFormDataTypeChangePw]){
        [infoComponentView dismissUserInfoComponentKeyboard];
        
        [APPLICATION_KEY_WINDOW makeToastActivity];
        [[Session sharedSession].mMyUser changePassword:infoComponentView.oldPwItemView.itemTextField.text desiredPassword:infoComponentView.confirmPwItemView.itemTextField.text delegate:self];
    }
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidChange:(UITextField*)textField{
    NSUInteger oldPwLength      = infoComponentView.oldPwItemView.itemTextField.text.length;
    NSUInteger lastPwLength     = infoComponentView.lastPwItemView.itemTextField.text.length;
    NSUInteger confirmPwLength  = infoComponentView.confirmPwItemView.itemTextField.text.length;
    
    if(oldPwLength > 0 && lastPwLength > 0 && confirmPwLength > 0){
        if(NO == changeButton.enabled) changeButton.enabled = YES;
    }else {
        if(YES == changeButton.enabled) changeButton.enabled = NO;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(infoComponentView.oldPwItemView.expanding || infoComponentView.lastPwItemView.expanding || infoComponentView.confirmPwItemView.expanding){
        [infoComponentView refreshInfoComponentView:nil completion:^(BOOL finished) {
            [changePasswordView contentSizeToFit];
        }];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL basicTest = NO;
    NSInteger textLength = 30;
    if(range.location < textLength){
        basicTest = YES;
    }
    
    if ([string isEqualToString:@""]) {
        basicTest = YES;
    }
    
    return basicTest;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(infoComponentView.oldPwItemView.itemTextField == textField){
        [infoComponentView.lastPwItemView.itemTextField becomeFirstResponder];
    }else if(infoComponentView.lastPwItemView.itemTextField == textField){
        [infoComponentView.confirmPwItemView.itemTextField becomeFirstResponder];
    }else if(infoComponentView.confirmPwItemView.itemTextField == textField){
        [infoComponentView.confirmPwItemView.itemTextField resignFirstResponder];
        [self changeAction:changeButton];
    }
    
    return YES;
}

#pragma mark MappActorDelegate
- (void)changePasswordFinished:(NSInteger)status{
    [APPLICATION_KEY_WINDOW hideToastActivity];
    
    if(MappActorFinishStatusOK == status){
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"UserInfoView_change_Password_successful", nil)];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (MappActorFinishStatusNetwork == status){
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"ErroMessage_Status_Network", nil)];
    }else{
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"UserInfoView_change_Password_Failed_Error", nil)];
    }
}

@end
