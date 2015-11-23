//
//  RequestCallViewController.m
//  RTSS
//
//  Created by Liuxs on 15-2-3.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "RequestCallViewController.h"
#import "InternationalControl.h"
#import "SupportModuleView.h"




@interface RequestCallViewController ()
{
    CGRect  pickerViewUpRect;
    CGRect  pickerViewDownRect;
    CGSize  mScrollViewContentSize;
}
@property (nonatomic, retain) TextInputView   *textInputService;
@property (nonatomic, retain) TextInputView   *textInputName;
@property (nonatomic, retain) TextInputView   *textInputPhone;
@property (nonatomic, retain) TextInputView   *textInputEmail;
@property (nonatomic, retain) TextInputView   *textInputCallTime;
@property (nonatomic, retain) TextInputView   *textInputSubmit;

@property (nonatomic, assign) NSInteger       pickerSelectorType;
@property (nonatomic, retain) UIScrollView    *scrollView;
@property (nonatomic, retain) NSArray         *serviceData;
@property (nonatomic, retain) NSArray         *callTimeData;

@property (nonatomic, retain) NSString        *serviceString;
@property (nonatomic, retain) NSString        *nameString;
@property (nonatomic, retain) NSString        *phoneString;
@property (nonatomic, retain) NSString        *emailString;
@property (nonatomic, retain) NSString        *callTimeString;



@property (nonatomic, retain) UITextField     *mTextField;

@property (nonatomic, retain) UIView          *mKeepFromView;

@property (nonatomic, retain) PickerSuperView *mPickerSuperView;

@property (nonatomic, retain) UIButton        *doneInKeyboardButton;

@end

@implementation RequestCallViewController
@synthesize textInputService,textInputName,textInputPhone,textInputEmail,textInputCallTime,textInputSubmit,scrollView,mKeepFromView,mPickerSuperView,doneInKeyboardButton,mTextField,serviceData,callTimeData,serviceString,nameString,phoneString,emailString,callTimeString;
//页面出现前，添加监听键盘事件
- (void) viewDidAppear:(BOOL)paramAnimated{
    [super viewDidAppear:paramAnimated];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(handleKeyboardWillShow:)
                   name:UIKeyboardWillShowNotification //键盘将出现事件监听
                 object:nil];
    
    [center addObserver:self selector:@selector(handleKeyboardWillHide:)
                   name:UIKeyboardWillHideNotification //键盘将隐藏事件监听
                 object:nil];

}
- (void) viewDidDisappear:(BOOL)paramAnimated {
    [super viewDidDisappear:paramAnimated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)dealloc
{
    [serviceData          release];
    [callTimeData         release];
    
    [serviceString        release];
    [nameString           release];
    [phoneString          release];
    [emailString          release];
    [callTimeString       release];
    
    [textInputService     release];
    [textInputName        release];
    [textInputPhone       release];
    [textInputEmail       release];
    [textInputCallTime    release];
    [textInputSubmit      release];
    
    [scrollView           release];
    [mKeepFromView        release];
    [mPickerSuperView     release];
    [doneInKeyboardButton release];
    [mTextField           release];
    [super dealloc];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = RTSSLocalizedString(@"Support_Title_RequestCall", nil);
    self.view.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    [self layoutRequestView];
    [self keywordboardShow];
    self.doneInKeyboardButton.hidden = YES;
}

- (void)layoutRequestView
{
    CGRect mScrollViewRect = CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-64);
    mScrollViewContentSize = CGSizeMake(PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-64+1);
    pickerViewUpRect       = CGRectMake(0, PHONE_UISCREEN_HEIGHT-260, PHONE_UISCREEN_WIDTH, 260);
    pickerViewDownRect     = CGRectMake(0, PHONE_UISCREEN_HEIGHT, PHONE_UISCREEN_WIDTH, 260);
    CGRect mPickerViewRect = CGRectMake(0, 44, PHONE_UISCREEN_WIDTH, 216);
    CGRect mTextInputServiceRect  = CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 70);
    CGRect mTextInputNameRect     = CGRectMake(0, 70, PHONE_UISCREEN_WIDTH, 70);
    CGRect mTextInputPhoneRect    = CGRectMake(0, 140, PHONE_UISCREEN_WIDTH, 70);
    CGRect mTextInputEmailRect    = CGRectMake(0, 210, PHONE_UISCREEN_WIDTH, 70);
    CGRect mTextInputCalltimeRect = CGRectMake(0, 280, PHONE_UISCREEN_WIDTH, 70);
    CGRect mTextInputSubmitRect   = CGRectMake(0, 350, PHONE_UISCREEN_WIDTH, 70);

    if (PHONE_UISCREEN_IPHONE6) {
        pickerViewUpRect   = CGRectMake(0, PHONE_UISCREEN_HEIGHT-260, PHONE_UISCREEN_WIDTH, 260);
        pickerViewDownRect = CGRectMake(0, PHONE_UISCREEN_HEIGHT, PHONE_UISCREEN_WIDTH, 260);
        mPickerViewRect    = CGRectMake(0, 44, PHONE_UISCREEN_WIDTH, 216);
    }
    
    
    
    self.scrollView = [[[UIScrollView alloc] initWithFrame:mScrollViewRect]autorelease];
    self.scrollView.contentSize = mScrollViewContentSize;
    self.scrollView.delegate    = self;
    [self.view addSubview:self.scrollView];
    
    
    self.serviceData  = @[@"Mobilephone&Homephone",@"Tablets",@"Router&Dongles",@"Subscriptions&Services",@"Connection",@"Buying&Paying"];
    self.callTimeData = @[@"00:00-8:00",@"8:00-12:00",@"12:00-14:00",@"14:00-18:00",@"18:00-24:00"];
    
    self.serviceString  = self.serviceData[0];
    self.callTimeString = self.callTimeData[0];
    
    self.textInputService = [[[TextInputView alloc] initWithFrame:mTextInputServiceRect
                                                      Type:TextInputTypePicker
                                                    target:self
                                                     Color:[RTSSAppStyle currentAppStyle].viewControllerBgColor
                                               placeholder:RTSSLocalizedString(@"Support_RequestCall_Service", nil)
                                            ReturnKeyType:UIReturnKeyNext]autorelease];
    self.textInputService.textField.text = self.serviceData[0];
    self.textInputService.textField.tag  = 10001;
    [self.scrollView addSubview:self.textInputService];
    
    self.textInputName = [[[TextInputView alloc] initWithFrame:mTextInputNameRect
                                                   Type:TextInputTypeInput
                                                 target:self
                                                  Color:[RTSSAppStyle currentAppStyle].viewControllerBgColor
                                            placeholder:RTSSLocalizedString(@"Support_RequestCall_Name", nil)
                                          ReturnKeyType:UIReturnKeyNext]autorelease];
    self.textInputName.textField.tag = 10002;
    [self.scrollView addSubview:self.textInputName];
    
    self.textInputPhone = [[[TextInputView alloc] initWithFrame:mTextInputPhoneRect
                                                    Type:TextInputTypeInput
                                                  target:self
                                                   Color:[RTSSAppStyle currentAppStyle].viewControllerBgColor
                                             placeholder:RTSSLocalizedString(@"Support_RequestCall_PhoneNo", nil)
                                           ReturnKeyType:UIReturnKeyNext]autorelease];
    self.textInputPhone.textField.keyboardType = UIKeyboardTypeNumberPad;
//    self.textInputPhone.textField.returnKeyType = UIReturnKeyNext;
    self.textInputPhone.textField.tag = 10003;
    [self.scrollView addSubview:self.textInputPhone];
    
    
    
    
    
    self.textInputEmail = [[[TextInputView alloc] initWithFrame:mTextInputEmailRect
                                                    Type:TextInputTypeInput
                                                  target:self
                                                   Color:[RTSSAppStyle currentAppStyle].viewControllerBgColor
                                            placeholder:RTSSLocalizedString(@"Support_Button_Title_Email", nil)
                                           ReturnKeyType:UIReturnKeyDone]autorelease];
    self.textInputEmail.textField.tag = 10004;
    [self.scrollView addSubview:self.textInputEmail];
    
    self.textInputCallTime = [[[TextInputView alloc] initWithFrame:mTextInputCalltimeRect
                                                       Type:TextInputTypePicker
                                                     target:self
                                                      Color:[RTSSAppStyle currentAppStyle].viewControllerBgColor
                                                placeholder:RTSSLocalizedString(@"Support_RequestCall_CallTime", nil)
                                              ReturnKeyType:UIReturnKeyDone]autorelease];
    self.textInputCallTime.textField.text = self.callTimeData[0];
    self.textInputCallTime.textField.tag  = 10005;
    [self.scrollView addSubview:textInputCallTime];
    
    self.textInputSubmit = [[[TextInputView alloc] initWithFrame:mTextInputSubmitRect
                                                     Type:TextInputTypeButton
                                                   target:self
                                                    Color:[RTSSAppStyle currentAppStyle].navigationBarColor placeholder:RTSSLocalizedString(@"Support_RequestCall_Submit", nil)
                                                 ReturnKeyType:UIReturnKeyDefault]autorelease];
    [self.scrollView addSubview:self.textInputSubmit];

    
    self.mKeepFromView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT)]autorelease];
    self.mKeepFromView.backgroundColor = [UIColor clearColor];
    self.mKeepFromView.hidden          = YES;
    [self.view addSubview:self.mKeepFromView];

    
    self.mPickerSuperView = [[[PickerSuperView alloc] initWithFrame:pickerViewDownRect target:self]autorelease];
    [self.view addSubview:self.mPickerSuperView];
    

    
}

// 点击TextField
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.doneInKeyboardButton.hidden = YES;
    if (textField.tag == 10001) {
        // 弹出Service选择器
        self.pickerSelectorType   = 1;
        [self.mPickerSuperView pickerReloadAllComponents:self.serviceData];
        self.mKeepFromView.hidden = NO;
        [self pickerSuperViewUp:CGPointMake(0, 0)];
        return NO;
    }
    else if (textField.tag == 10002) {
        // Name
        self.mTextField = textField;
        [self scrollViewContentOffset:CGPointMake(0.0, 0.0)];
        return YES ;
    }
    else if (textField.tag == 10003) {
        // Phone
        self.mTextField = textField;
        if (PHONE_UISCREEN_IPHONE4 || PHONE_UISCREEN_IPHONE5) {
            [self scrollViewContentOffset:CGPointMake(0.0, 70.0)];
        }
        self.doneInKeyboardButton.hidden = NO;
        return YES;
    }
    else if (textField.tag == 10004) {
        // Email
        self.mTextField = textField;
        if (PHONE_UISCREEN_IPHONE4 || PHONE_UISCREEN_IPHONE5) {
            [self scrollViewContentOffset:CGPointMake(0.0, 140.0)];
        } else if (PHONE_UISCREEN_IPHONE6) {
            [self scrollViewContentOffset:CGPointMake(0.0, 70.0)];
        }
        return YES;
    }
    else if (textField.tag == 10005) {
        // 弹出日期选择器
//        [self.mTextField resignFirstResponder];
        self.pickerSelectorType = 2;
        [self.mPickerSuperView pickerReloadAllComponents:self.callTimeData];
        self.mKeepFromView.hidden = NO;
        if (PHONE_UISCREEN_IPHONE4 || PHONE_UISCREEN_IPHONE5) {
            [self pickerSuperViewUp:CGPointMake(0, 140)];
        }else if (PHONE_UISCREEN_IPHONE6) {
            [self pickerSuperViewUp:CGPointMake(0, 70)];
        }else if (PHONE_UISCREEN_IPHONE6PLUS) {
            [self pickerSuperViewUp:CGPointMake(0, 0)];
        }
        return NO;
    }
    return YES;
}



// Submit按钮
- (void)submitButtonClick:(UIButton *)button
{
    NSLog(@"发送");
    [self.doneInKeyboardButton removeFromSuperview];
    [self pickerSuperViewDown:self.mTextField];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:self.serviceString forKey:@"service"];
    [dic setObject:self.nameString forKey:@"name"];
    [dic setObject:self.phoneString forKey:@"phoneNo"];
    [dic setObject:self.emailString forKey:@"email"];
    [dic setObject:self.callTimeString forKey:@"callTime"];
    NSLog(@"dic == %@",dic);
    [self.navigationController popViewControllerAnimated:YES];
}

// 点击空白view处
- (void)tap:(UITapGestureRecognizer *)tap
{
    [self pickerSuperViewDown:self.mTextField];
    self.doneInKeyboardButton.hidden = YES;
}

// 输入时
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    NSString *tempText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    switch (textField.tag) {
        case 10002:
            self.nameString  = tempText;
            break;
        case 10003:
            self.phoneString = tempText;
            break;
        case 10004:
            self.emailString = tempText;
            break;
        default:
            break;
    }
    if (self.nameString.length && self.phoneString.length == 11 && self.emailString.length) {
        self.textInputSubmit.sendButton.enabled = YES;
    }else {
        self.textInputSubmit.sendButton.enabled = NO;
    }
//    self.textInputSubmit.sendButton1.enabled = YES;

    return YES;
}


// return
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    switch (textField.tag) {
        case 10002:
            [textField resignFirstResponder];
            [self.textInputPhone.textField becomeFirstResponder];
            break;
        case 10003:
            [textField resignFirstResponder];
            [self.textInputEmail.textField becomeFirstResponder];
            break;
        case 10004:
            [textField resignFirstResponder];
//            [self pickerSuperViewDown:textField];
            break;
        default:
            break;
    }
    return NO;
}

// scroll滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //当滑动scroll或tableview时触发
//    [self pickerSuperViewDown:self.mTextField];
//    [self.textField resignFirstResponder];
}

// Cancel
-(void)toolBarCanelClick:(id)sender{
    self.pickerSelectorType   = 0;
    self.mKeepFromView.hidden = YES;
    [self pickerSuperViewDown:nil];

}

// Done
-(void)toolBarDoneClick:(id)sender{
    self.mKeepFromView.hidden = YES;
    NSInteger row = [self.mPickerSuperView.pickerView selectedRowInComponent:0];
    switch (self.pickerSelectorType) {
        case 1:
//            if (self.tempString) {
//                self.serviceString = self.tempString;
                self.textInputService.textField.text = [self.serviceData objectAtIndex:row];
                self.serviceString = self.textInputService.textField.text;
//                self.tempString = nil;
//            }
//            [self.textInputName.textField becomeFirstResponder];
            break;
        case 2:
//            if (self.tempString) {
//                self.callTimeString = self.tempString;
                self.textInputCallTime.textField.text = [self.callTimeData objectAtIndex:row];
                self.callTimeString = self.textInputCallTime.textField.text;

//                self.tempString = nil;
//            }
            break;
            
        default:
            break;
    }
    [self pickerSuperViewDown:nil];
}


- (void)pickerSuperViewDown:(UITextField *)textField
{
    if (textField) {
        [textField resignFirstResponder];
    }
    [UIView animateWithDuration:.5 animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
        self.mPickerSuperView.frame   = pickerViewDownRect;
    }];
}

- (void)pickerSuperViewUp:(CGPoint)point
{
    if (self.mTextField) {
        [self.mTextField resignFirstResponder];
        self.mTextField = nil;
    }
    [UIView animateWithDuration:.5 animations:^{
        self.scrollView.contentOffset = point;
        self.mPickerSuperView.frame   = pickerViewUpRect;
    }];
}

- (void)scrollViewContentOffset:(CGPoint)point
{
    [UIView animateWithDuration:.5 animations:^{
        self.scrollView.contentOffset = point;
    }];
}


- (void) handleKeyboardWillShow:(NSNotification *)paramNotification{


    NSDictionary *userInfo = [paramNotification userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.scrollView.contentSize = CGSizeMake(0, PHONE_UISCREEN_HEIGHT-64+kbSize.height);
    if (PHONE_UISCREEN_IPHONE6) {
        self.scrollView.contentSize = CGSizeMake(0, PHONE_UISCREEN_HEIGHT-64+70);
    }
    
}

- (void) handleKeyboardWillHide:(NSNotification *)paramNotification{

    self.doneInKeyboardButton.hidden = YES;
    self.scrollView.contentSize = mScrollViewContentSize;
}

//键盘显示
- (void)keywordboardShow{
    if (self.doneInKeyboardButton == nil){
        //初始化完成按钮
        self.doneInKeyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //获取主屏高度
        self.doneInKeyboardButton.frame = CGRectMake(0, PHONE_UISCREEN_HEIGHT - 53, 106, 53);
        //在按钮被禁用时，图像会被画的颜色深一些
        self.doneInKeyboardButton.adjustsImageWhenHighlighted = NO;
        //根据按钮不同状态设图片
        [self.doneInKeyboardButton setTitle:@"Next" forState:UIControlStateNormal];
        [self.doneInKeyboardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.doneInKeyboardButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    }
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    if (self.doneInKeyboardButton.superview == nil){
        //完成按钮添加到window
        [tempWindow addSubview:self.doneInKeyboardButton];
    }
}
//点击完成按键
-(void)finishAction{
    //隐藏完成按钮
    self.doneInKeyboardButton.hidden = YES;
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];//关闭键盘
    [self.textInputEmail.textField becomeFirstResponder];

}

- (void)backBarButtonAction:(UIButton*)barButtonItem{
    AlertController *alert = [[AlertController alloc]initWithTitle:nil message:NSLocalizedString(@"Support_Email_RequestCall_Alert", nil) delegate:self tag:0 cancelButtonTitle:NSLocalizedString(@"UIAlertView_Cancel_String", nil) otherButtonTitles:NSLocalizedString(@"UIAlertView_Confirm_String", nil),nil];
    [alert showInViewController:self];
    [alert release];
}

#pragma mark --AlertDelegate
-(void)alertController:(AlertController *)alertController didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        //用户取消
        
    }else if(buttonIndex == 1){
        //用户确认退出
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    return;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
