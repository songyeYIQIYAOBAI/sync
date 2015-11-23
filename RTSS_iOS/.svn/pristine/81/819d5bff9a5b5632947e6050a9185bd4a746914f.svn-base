//
//  LoginViewController.m
//  RTSS
//
//  Created by shengyp on 14/10/23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "LoginViewController.h"
#import "FindPasswordViewController.h"
#import "RequestOTPViewController.h"
#import "UserInfoComponentView.h"
#import "ActionSheetController.h"
#import "PortraitImageView.h"
#import "AppDelegate.h"

#import "Settings.h"
#import "User.h"
#import "Cache.h"
#import "Session.h"

#define LoginMaxFailCount       5

@interface LoginViewController ()<ActionSheetControllerDelegate, MappActorDelegate>

@property(nonatomic, readonly) UIView*                  loginView;
@property(nonatomic, readonly) UIButton*                autoLoginButton;
@property(nonatomic, readonly) UIButton*                loginButton;
@property(nonatomic, readonly) UserInfoComponentView*   infoComponentView;

@property(nonatomic, retain) User*                      loginUser;
@property(nonatomic, assign) NSUInteger                 loginFailCount;

@property(nonatomic, assign) BOOL                       isRefreshImage;

@end

@implementation LoginViewController
@synthesize loginView, autoLoginButton, loginButton, infoComponentView, loginUser,loginFailCount,isRefreshImage,functionType;

- (void)dealloc{
    [loginUser release];
    [loginView release];
    [infoComponentView release];
    
    [super dealloc];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.isRefreshImage      = NO;
        self.loginFailCount      = 0;
        self.functionType        = BasicViewControllerFunctionTypeDefault;
        self.loginUser           = [[[User alloc] init] autorelease];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.isRefreshImage = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.isRefreshImage = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutLoginView{
    loginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-20-44)];
    loginView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:loginView];
    
    // ==
    CGRect portraitRect = CGRectMake((PHONE_UISCREEN_WIDTH-85)/2, 20, 85, 85);
    CGRect infoComponentRect = CGRectMake(30, 120, (loginView.bounds.size.width-30*2), 97);
    CGRect autoLoginRect = CGRectMake(CGRectGetMinX(infoComponentRect)+5, CGRectGetMaxY(infoComponentRect)+10, 90, 30);
    CGRect loginButtonRect = CGRectMake(30, 290, (loginView.bounds.size.width-30*2), 45);
    CGRect helpButtonRect = CGRectMake((loginView.bounds.size.width-200)/2, 360, 200, 30);
    if(PHONE_UISCREEN_IPHONE5){
        portraitRect.origin.y += 10;
        infoComponentRect.origin.y += 20;
        autoLoginRect.origin.y += 20;
        loginButtonRect.origin.y += 20;
        helpButtonRect.origin.y += 20;
    }else if(PHONE_UISCREEN_IPHONE6){
        portraitRect.origin.y += 30;
        infoComponentRect.origin.y += 40;
        autoLoginRect.origin.y += 40;
        loginButtonRect.origin.y += 40;
        helpButtonRect.origin.y += 40;
    }
    PortraitImageView* headerImageView = [[PortraitImageView alloc] initWithFrame:portraitRect image:nil borderColor:[RTSSAppStyle currentAppStyle].textFieldBorderColor borderWidth:1.0];
    headerImageView.backgroundColor = [RTSSAppStyle currentAppStyle].loginPortraitBgColor;
    headerImageView.portraitImage = [[Cache standardCache] getLargePortraitImageWithUrl:[Session sharedSession].mMyUser.mPortrait completion:^(UIImage *image) {
        if(self.isRefreshImage){
            headerImageView.portraitImage = image;
        }
    }];
    [loginView addSubview:headerImageView];
    [headerImageView release];
    
    // ==
    infoComponentView = [[UserInfoComponentView alloc] initWithFrame:infoComponentRect
                                                                type:UserInfoComponentViewTypeLogin];
    infoComponentView.userNameItemView.itemTextField.delegate = self;
    [infoComponentView.userNameItemView.itemTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    infoComponentView.pwItemView.itemTextField.delegate = self;
    [infoComponentView.pwItemView.itemTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [loginView addSubview:infoComponentView];
    
    // ==
    autoLoginButton = [CommonUtils buttonWithType:UIButtonTypeCustom
                                            frame:autoLoginRect
                                            title:NSLocalizedString(@"LoginView_RememberMe_Button", nil)
                                      imageNormal:[UIImage imageNamed:@"common_checked_d.png"]
                                 imageHighlighted:nil
                                    imageSelected:[UIImage imageNamed:@"common_checked_a.png"]
                                        addTarget:self
                                           action:@selector(autoLoginAction:)
                                              tag:0];
    autoLoginButton.backgroundColor = [UIColor clearColor];
    autoLoginButton.titleLabel.font = [RTSSAppStyle getRTSSFontWithSize:14.0];
    [autoLoginButton setTitleColor:[RTSSAppStyle currentAppStyle].textSubordinateColor forState:UIControlStateNormal];
    [autoLoginButton setImageEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 0)];
    [loginView addSubview:autoLoginButton];
    
    // ==
    loginButton = [RTSSAppStyle getMajorGreenButton:loginButtonRect
                                             target:self
                                             action:@selector(loginAction:)
                                              title:NSLocalizedString(@"LoginView_Login_Button", nil)];
    loginButton.enabled = NO;
    [loginView addSubview:loginButton];
    
    // ==
    UIButton *helpButton = [CommonUtils buttonWithType:UIButtonTypeCustom
                                                 frame:helpButtonRect
                                                 title:NSLocalizedString(@"LoginView_Help_Button", nil)
                                           imageNormal:nil
                                      imageHighlighted:nil
                                         imageSelected:nil
                                             addTarget:self
                                                action:@selector(helpAction:)
                                                   tag:0];
    helpButton.titleLabel.font = [RTSSAppStyle getRTSSFontWithSize:14.0];
    [helpButton setTitleColor:[RTSSAppStyle currentAppStyle].textSubordinateColor forState:UIControlStateNormal];
    [loginView addSubview:helpButton];
    
    // ==
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    tap.delegate = self;
    [tap setNumberOfTapsRequired:1];
    [loginView addGestureRecognizer:tap];
    [tap release];
    
    // for debug
    infoComponentView.userNameItemView.itemTextField.text = @"andy";
    //infoComponentView.pwItemView.itemTextField.text = @"Ril@1234";
}

- (void)loadView{
    [super loadView];

    [self layoutLoginView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"LoginView_Title", nil);
}

- (void)loadData{
    if(BasicViewControllerFunctionTypeLogout == self.functionType){
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"PersonCenterView_Logout_Successful", nil)];
    }
}

- (void)showKeyboard{
    BOOL animated = [infoComponentView showUserInfoComponentKeyboard];
    if(PHONE_UISCREEN_IPHONE4){
        if(animated){
            [UIView animateWithDuration:0.4 animations:^{
                loginView.frame = CGRectMake(0, -20, loginView.bounds.size.width, loginView.bounds.size.height);
            }];
        }
    }
}

- (void)dismissKeyboard{
    BOOL animated = [infoComponentView dismissUserInfoComponentKeyboard];
    if(PHONE_UISCREEN_IPHONE4){
        if(animated){
            [UIView animateWithDuration:0.4 animations:^{
                loginView.frame = CGRectMake(0, 0, loginView.bounds.size.width, loginView.bounds.size.height);
            }];
        }
    }
}

#pragma mark Action
- (void)autoLoginAction:(UIButton*)button{
    button.selected = !button.selected;
}

- (void)loginAction:(UIButton*)button{
#ifdef APPLICATION_BUILDING_RELEASE
    [self dismissKeyboard];
    
    NSString* userName = infoComponentView.userNameItemView.itemTextField.text;
    NSString* password = infoComponentView.pwItemView.itemTextField.text;
    
    if(0 == infoComponentView.userNameItemView.itemTextField.text.length){
        [AlertController showSimpleAlertWithTitle:nil message:NSLocalizedString(@"UserInfoView_User_ID_Length_empty", nil) buttonTitle:NSLocalizedString(@"UIAlertView_Confirm_String", nil) inViewController:self];
    }else if(0 == infoComponentView.pwItemView.itemTextField.text.length){
        [AlertController showSimpleAlertWithTitle:nil message:NSLocalizedString(@"UserInfoView_User_Password_Length_empty", nil) buttonTitle:NSLocalizedString(@"UIAlertView_Confirm_String", nil) inViewController:self];
    }else{

        [APPLICATION_KEY_WINDOW makeToastActivity];
        
        BOOL isRememberMe = self.autoLoginButton.selected;
        [loginUser login:userName password:password rememberMe:isRememberMe delegate:self];
    }
#else
    [[AppDelegate shareAppDelegate] startRTSSViewControllerType:RTSSViewControllerTypeHome];
#endif
}

- (void)helpAction:(UIButton*)button{
    ActionSheetController *helpActionSheet = [[ActionSheetController alloc] initWithTitle:nil
                                                                                 delegate:self
                                                                                      tag:0
                                                                        cancelButtonTitle:NSLocalizedString(@"UIAlertView_Cancel_String", nil)
                                                                   destructiveButtonTitle:nil
                                                                        otherButtonTitles:NSLocalizedString(@"LoginView_Forgot_Password_Sheet", nil), NSLocalizedString(@"LoginView_First_Time_Activation_Sheet", nil), nil];
    [helpActionSheet showInViewController:self];
    [helpActionSheet release];
}

#pragma mark ActionSheetControllerDelegate
- (void)actionSheetController:(ActionSheetController *)controller didDismissWithButtonIndex:(NSInteger)buttonIndex{

    if(controller.firstOtherButtonIndex == buttonIndex){
        FindPasswordViewController* findPWVC = [[FindPasswordViewController alloc] init];
        findPWVC.viewType = UserInfoComponentViewTypeForgotUserID;
        [self.navigationController pushViewController:findPWVC animated:YES];
        [findPWVC release];
    }else if(controller.firstOtherButtonIndex+1 == buttonIndex){
        RequestOTPViewController* requestOTPVC = [[RequestOTPViewController alloc] init];
        [self.navigationController pushViewController:requestOTPVC animated:YES];
        [requestOTPVC release];
    }
}

#pragma mark UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (![[touch view] isKindOfClass:[UITextField class]] && ![[touch view] isKindOfClass:[UIButton class]]) {
        [self dismissKeyboard];
        return YES;
    }
    return NO;
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidChange:(UITextField*)textField{
    NSUInteger userNameLength   = infoComponentView.userNameItemView.itemTextField.text.length;
    NSUInteger pwLength         = infoComponentView.pwItemView.itemTextField.text.length;
    
    if(userNameLength > 0 && pwLength > 0 ){
        if(NO == loginButton.enabled) loginButton.enabled = YES;
    }else {
        if(YES == loginButton.enabled) loginButton.enabled = NO;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self showKeyboard];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL basicTest = NO;
    NSInteger textLength = 30;
    if(range.location < textLength){
        if(infoComponentView.userNameItemView.itemTextField == textField){
            basicTest = YES;
        }else if(infoComponentView.pwItemView.itemTextField == textField){
            basicTest = YES;
        }
    }
    
    if ([string isEqualToString:@""]) {
        basicTest = YES;
    }
    
    return basicTest;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(infoComponentView.userNameItemView.itemTextField == textField){
        [infoComponentView.pwItemView.itemTextField becomeFirstResponder];
    }else if(infoComponentView.pwItemView.itemTextField == textField){
        [self loginAction:loginButton];
    }
    
    return YES;
}

#pragma mark MappActorDelegate
- (void)loginFinished:(NSInteger)status customer:(NSObject*)customer{
    [APPLICATION_KEY_WINDOW hideToastActivity];
    
    if(MappActorFinishStatusOK == status){
        [[Settings standardSettings] setAutoLoginSwitch:self.autoLoginButton.selected];
        [[AppDelegate shareAppDelegate] startRTSSViewControllerType:RTSSViewControllerTypeHome];
    } else if(MappActorFinishStatusNetwork == status){
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"ErroMessage_Status_Network", nil)];
    } else if(MappActorFinishStatusUserLocked == status){
        FindPasswordViewController* findPWVC = [[FindPasswordViewController alloc] init];
        findPWVC.viewType = UserInfoComponentViewTypeForgotUserID;
        [self.navigationController pushViewController:findPWVC animated:YES];
        [findPWVC release];
    }else {
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"LoginView_Login_Failed", nil)];
    }
}

@end
