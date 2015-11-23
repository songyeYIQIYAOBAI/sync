//
//  SOAViewController.m
//  RTSS
//
//  Created by 蔡杰Alan on 14-11-25.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "SOAViewController.h"
#import "UIView+RTSSAddView.h"
#import "RTSSAppDefine.h"
#import "UITextField+CheckState.h"
#import "RTSSAppStyle.h"
#import "CommonUtils.h"
#import "DateUtils.h"
#import "AlertController.h"
#import "DateSelectionViewController.h"
#import "DateUtils.h"
#import "DownLoadPDFViewController.h"


#define kDateFormatString @"dd/MM/yyyy"

@interface SOAViewController ()<UITextFieldDelegate,DateSelctionDelegate>{
    
    UILabel *accountidLabel;
    UITextField *dateFromTextField;
    UITextField *dateToTextField;
    BOOL flag;//区分哪一个UITextFild
    
}

@end

@implementation SOAViewController

-(void)dealloc{
    
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"SOA";
    //默认数据显示
    dateFromTextField.text = [DateUtils getStringDateByDate:[DateUtils dateBySubtractingMonths:1 by:[NSDate date]] dateFormat:kDateFormatString];
    dateToTextField.text = [DateUtils getStringDateByDate:[NSDate date] dateFormat:kDateFormatString];
    [self loadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadView{
    
    [super loadView];
    [self.view setViewBlackColor];
    
    accountidLabel = [self.view addLabelWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 50) Title:@"Account Id:"];
   
    
    CGFloat y = CGRectGetMaxY(accountidLabel.frame)+30;
    CGFloat height =90.0f;
    
    dateFromTextField = [self.view addTextFieldWithFrame:CGRectMake(0, y, PHONE_UISCREEN_WIDTH, height) Name:@"From :" TextFieldDelegate:self KeyboardType:UIKeyboardTypeDefault isMoneySymbol:NO];
   // dateFromTextField.userInteractionEnabled = NO;
    dateFromTextField.font = [UIFont systemFontOfSize:15.0f];
    dateFromTextField.inputView = nil;
    dateFromTextField.tag = 1000;
    [dateFromTextField addRightViewWithFrame:CGRectMake(5, 0, 40, 30) BlackImage:nil Target:self Action:@selector(fromDate)];
    [self.view addBottomLineWithY:y+height-2];
    
    y = y+20;
    dateToTextField = [self.view addTextFieldWithFrame:CGRectMake(0, y+height, PHONE_UISCREEN_WIDTH, height) Name:@"To :" TextFieldDelegate:self KeyboardType:UIKeyboardTypeDefault isMoneySymbol:NO];
    dateToTextField.inputView = nil;
    //dateToTextField.userInteractionEnabled = NO;
     dateToTextField.tag = 1001;
    dateFromTextField.textAlignment = NSTextAlignmentNatural;
     dateToTextField.font = [UIFont systemFontOfSize:15.0f];
    [dateToTextField addRightViewWithFrame:CGRectMake(5, 0, 40, 30) BlackImage:nil Target:self Action:@selector(toDate)];
    [self.view addBottomLineWithY:y+height*2-2];
    
    //button
    UIButton *topupButton = [CommonUtils buttonWithType:UIButtonTypeCustom frame:CGRectMake((PHONE_UISCREEN_WIDTH-253)/2, y+height*2+30, 253, 45) title:@"Download and View PDF" colorNormal:[RTSSAppStyle currentAppStyle].commonGreenButtonNormalColor colorHighlighted:[RTSSAppStyle currentAppStyle].commonGreenButtonHighlightColor colorSelected:nil addTarget:self action:@selector(downLoadPDF) tag:0];
    topupButton.layer.cornerRadius = 6.0f;
    topupButton.layer.masksToBounds = YES;
    
    [self.view addSubview:topupButton];
    
}

-(void)loadData{
    
     accountidLabel.text = @"001000013868";
}

#pragma mark --Action
-(void)fromDate{
    
    flag = YES;
    [self showDatePicker];
}
-(void)toDate{
    flag = NO;
    [self showDatePicker];
}
-(void)showDatePicker{

    DateSelectionViewController *dateSelction =   [[DateSelectionViewController alloc]init];
    dateSelction.delegate = self;
    [dateSelction setMinDate:[DateUtils dateBySubtractingMonths:6 by:[NSDate date]] MaxDate:[NSDate date]];
    [dateSelction showFromViewController:self];
    [dateSelction release];
    
}

-(void)downLoadPDF{
    
 BOOL resutlt = [self compareFromDateString:dateFromTextField.text ToDateString:dateToTextField.text];
    
    if (resutlt) {
        //符合条件 加载PDF
        DownLoadPDFViewController *PDFLoad = [[DownLoadPDFViewController alloc]init];
        PDFLoad.pdfUrlString = @"www.baidu.com";
        [self.navigationController pushViewController:PDFLoad animated:YES];
        [PDFLoad release];
    }
}

#pragma mark --UItextField

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
    flag = textField.tag -1000;
    [self showDatePicker];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSLog(@"结束编辑");
}
#pragma mark --DateSelctionDelegate
-(void)dateSelectionViewController:(DateSelectionViewController *)vc didSelectDate:(NSDate *)aDate{
    NSString *dateString = [DateUtils getStringDateByDate:aDate dateFormat:kDateFormatString];
    if (flag) {
        dateToTextField.text = dateString;
    }else{
        dateFromTextField.text = dateString;
    }
    
}


-(BOOL)compareFromDateString:(NSString*)from  ToDateString:(NSString*)to{
    
    NSDate *fromDate = [DateUtils dateByDateString:from UseFormatString:kDateFormatString];
    NSDate *toDate = [DateUtils dateByDateString:to UseFormatString:kDateFormatString];
    
    NSComparisonResult result = [DateUtils compareFromDate:fromDate toDate:toDate isAll:YES];
    NSLog(@"from =%@ fromdate = %@-- to =%@ todate=%@-",from,fromDate,to,toDate);
    switch (result) {
        case NSOrderedDescending:{
            NSLog(@"降序");//降序
            break;
        }
        case NSOrderedAscending:{
            //升序
            NSLog(@"sheng序");
            return YES;
            break;
        }
        case NSOrderedSame:{
            //相同
              NSLog(@"相同序");
            break;
        }
        default:
            break;
    }
    
    NSString *tips = @"FromDate must be less than ToDate";
    [AlertController showSimpleAlertWithTitle:nil message:tips buttonTitle:@"Sure" inViewController:self];
    return NO;
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
