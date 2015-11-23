//
//  CardInfomationViewController.m
//  RTSS
//
//  Created by 蔡杰 on 14-11-4.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "CardInfomationViewController.h"

#import "UIView+RTSSAddView.h"
#import "UITextField+CheckState.h"


#import "CommonUtils.h"
#import "RTSSAppStyle.h"
#import "TPKeyboardAvoidingScrollView.h"

#import "SinglePickerController.h"




@interface CardInfomationViewController ()<UITextFieldDelegate,SinglePickerDelegate>{
    
    
    //UIView  *containerView;
    
    UITextField *cardTypeTextField;
    
    UITextField *dateTextField;
    
    UITextField *mobileTextField;
    
    
}

@property(retain,nonatomic)SinglePickerController *cardTypePicker;

@property(retain,nonatomic)SinglePickerController *datePicker;

@end

@implementation CardInfomationViewController

-(void)dealloc{
    
    if(_cardTypePicker) [_cardTypePicker release];
    
    if (_datePicker) [_datePicker release];
    
    [super dealloc];
    
}

#pragma mark -- Setter

-(SinglePickerController *)cardTypePicker{
    
    if (!_cardTypePicker) {
        
        _cardTypePicker = [[SinglePickerController alloc]init];
        
        _cardTypePicker.pickerType = SinglePickerTypeGroup;
        
       // _cardTypePicker.pickerArrayData =
        
        _cardTypePicker.delegate = self;
        
    }
    
    
    return _cardTypePicker;
    
}

-(SinglePickerController *)datePicker{
    
    
    
    if (!_datePicker) {
        
        _datePicker = [[SinglePickerController alloc]init];
        
        _datePicker.pickerType = SinglePickerTypeGroup;
        
        _datePicker.delegate = self;
    }
    
    
    return _datePicker;
}

#pragma mark --life

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView{
    
    
    [super loadView];
    
    [self installViews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Card Infomation";
    
   

}

-(void)viewWillDisappear:(BOOL)animated{
    
    [self hideKeyBoard];

    [self loadData];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --InstallSubviews

-(void)installViews{
    
    
    TPKeyboardAvoidingScrollView *scrollView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:self.view.bounds];
    
    [self.view addSubview:scrollView];

    CGFloat height = 80.0f;
    CGFloat edge = 5.0f;
    
    cardTypeTextField = [scrollView addTextFieldWithFrame:CGRectMake(0, edge, PHONE_UISCREEN_WIDTH, height) Name:@"CardType:" TextFieldDelegate:self KeyboardType:UIKeyboardTypeASCIICapable isMoneySymbol:NO];
    [cardTypeTextField clearupInpuView];
     dateTextField = [scrollView addTextFieldWithFrame:CGRectMake(0, edge*2+height, PHONE_UISCREEN_WIDTH, height) Name:@"ExpiryDate:" TextFieldDelegate:self KeyboardType:UIKeyboardTypeASCIICapable isMoneySymbol:NO];
    [dateTextField clearupInpuView];
     mobileTextField = [scrollView addTextFieldWithFrame:CGRectMake(0, edge*3+height*2, PHONE_UISCREEN_WIDTH, height) Name:@"Mobile:" TextFieldDelegate:self KeyboardType:UIKeyboardTypeNumberPad isMoneySymbol:NO];
    
    
    //按钮
    CGFloat buttonBgViewY = edge*3+height*3;
    UIView *buttonBgView = [[UIView alloc]initWithFrame:CGRectMake(0,buttonBgViewY,PHONE_UISCREEN_WIDTH,PHONE_UISCREEN_HEIGHT-buttonBgViewY-64)];
    buttonBgView.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    NSLog(@"buttonY= %@",NSStringFromCGRect(buttonBgView.frame));
    UIButton *submitButton =[RTSSAppStyle getMajorGreenButton:CGRectMake((PHONE_UISCREEN_WIDTH-253)/2,CGRectGetHeight(buttonBgView.frame)/2-45/2, 253, 45) target:self action:@selector(Submit) title:@"ADD"];
    submitButton.backgroundColor = [UIColor grayColor];
    submitButton.layer.cornerRadius = 6.0f;
    submitButton.layer.masksToBounds = YES;
    [buttonBgView addSubview:submitButton];
    [scrollView addSubview:buttonBgView];
    [buttonBgView release];
    [scrollView contentSizeToFit];
    [scrollView release];

}

-(void)loadData{
    
    //卡片
    NSMutableArray *cardArray = [[NSMutableArray alloc]initWithCapacity:2];
    NSArray *card1 =  @[@"Mastercard",@"Visa",@"Amex"];
    NSArray  *card2 = @[@"Credit"];
    [cardArray addObject:card1];  [cardArray addObject:card2];
    self.cardTypePicker.pickerArrayData = cardArray;
    
    [cardArray release];
    
    //日期
    NSMutableArray *monthArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 1; i < 13; i++) {
        [monthArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    NSDateComponents *components = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger year = components.year;
    NSMutableArray *yearArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (NSInteger i = year;i< year +20; i++) {
        [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    self.datePicker.pickerArrayData =@[monthArray,yearArray];
    
}

#pragma mark --Action
-(void)Submit{
    
    NSLog(@"提交信息");
    NSArray *viewControllerArray = [self.navigationController viewControllers];
    if ([viewControllerArray count] > 3) {
        
        UIViewController *pop = [viewControllerArray objectAtIndex:1];
        ;
        
        [self.navigationController popToViewController:pop animated:YES];
    }
}

#pragma mark --touch

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
 }

-(void)hideKeyBoard{
    
    
    [cardTypeTextField giveUpTheKeyboard];
    [dateTextField giveUpTheKeyboard];
    [mobileTextField giveUpTheKeyboard];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if ([textField isEqual:cardTypeTextField]) {
        [self.view.window addSubview:self.cardTypePicker.view];
        
    }
    
    if ([textField isEqual:dateTextField]) {
        
        [self.view.window addSubview:self.datePicker.view];

    }
   
    return YES;
}

#pragma mark --SinglePicker Delegate

-(void)singlePickerWithCancel:(SinglePickerController *)controller{
    
    [controller.view removeFromSuperview];
    [self hideKeyBoard];
}

-(void)singlePickerWithDone:(SinglePickerController *)controller rows:(NSArray *)rows
{
    if (controller == self.cardTypePicker ) {
        NSMutableString *text = [[NSMutableString alloc]initWithCapacity:0];
        for (int i = 0; i < [controller.pickerArrayData count]; i++) {
            NSArray *array = [controller.pickerArrayData objectAtIndex:i];
            
            [text appendString:[array objectAtIndex:[[rows objectAtIndex:i] integerValue]]];
        }
        cardTypeTextField.text = text;
        [text release];
        
     }else if (controller == self.datePicker){
         NSMutableString *text = [[NSMutableString alloc]initWithCapacity:0];
         for (int i = 0; i < [controller.pickerArrayData count]; i++) {
             NSArray *array = [controller.pickerArrayData objectAtIndex:i];
             [text appendString:[array objectAtIndex:[[rows objectAtIndex:i] integerValue]]];
             if (i < [controller.pickerArrayData count]-1) {
                  [text appendString:@"/"];
             }
         }
         dateTextField.text = text;
         [text release];

    }
    [controller.view removeFromSuperview];
    [self hideKeyBoard];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
