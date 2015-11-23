//
//  DateSelectionViewController.m
//  RTSS
//
//  Created by 蔡杰Alan on 14-11-25.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "DateSelectionViewController.h"
#import "RTSSAppDefine.h"

static CGFloat const kRTSSDatePickerHeight = 216;

@interface DateSelectionViewController ()

@property(nonatomic, retain)UIDatePicker *datePicker;

@end

@implementation DateSelectionViewController

-(void)dealloc{
    [_datePicker release];
    
    [super dealloc];
}

#pragma mark --Setter
-(UIDatePicker *)datePicker{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 44, PHONE_UISCREEN_WIDTH, kRTSSDatePickerHeight)];
        [_datePicker setDate:[NSDate date] animated:YES];
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
        
        //[_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        //[_datePicker setMaximumDate:[NSDate date]];
        //_datePicker.backgroundColor = [UIColor redColor];
    }
    return _datePicker;
}

#pragma mark --Life
- (void)viewDidLoad {
    [super viewDidLoad];
    
   // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
}

-(void)loadView{
    [super loadView];
    
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-260, self.view.bounds.size.width, 260)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    
    // ===
    UINavigationBar* navBar = [[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, contentView.bounds.size.width, 44)] autorelease];
    navBar.translucent = YES;
    navBar.barStyle = UIBarStyleBlackTranslucent;
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [contentView addSubview:navBar];
    
    // ===
    UINavigationItem* navItem = [[[UINavigationItem alloc] initWithTitle:nil] autorelease];
    
    // ===
    UIBarButtonItem* btnDone = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                              target:self
                                                                              action:@selector(barButtonDone:)] autorelease];
    navItem.rightBarButtonItem = btnDone;
    
    // ===
    UIBarButtonItem* btnCancel = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                target:self
                                                                                action:@selector(barButtonCancel:)] autorelease];
    navItem.leftBarButtonItem = btnCancel;
    
    // ===
    [navBar pushNavigationItem:navItem animated:YES];
    
    [contentView addSubview:self.datePicker];
    
    // ===
    [contentView release];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --Public
-(void)dismiss{
    [self.view removeFromSuperview];
    [self willMoveToParentViewController:nil];
    [self removeFromParentViewController];
}

-(void)showFromViewController:(UIViewController *)parentViewController{
    [parentViewController addChildViewController:self];
    [parentViewController.view addSubview:self.view];
    [self didMoveToParentViewController:parentViewController];
}

-(void)setMinDate:(NSDate*)minDate MaxDate:(NSDate*)maxDate{
    if (minDate) {
         self.datePicker.minimumDate = minDate;
    }
    if (maxDate) {
        self.datePicker.maximumDate = maxDate;
    }
}

#pragma mark --Deleagte
-(void)datePickerValueChanged:(id)sender{
    
}

#pragma mark --Action
-(void)barButtonDone:(id)sender{
  //  NSLog(@"date = %@",self.datePicker.date);
    if(_delegate && [_delegate respondsToSelector:@selector(dateSelectionViewController:didSelectDate:)]){
        [_delegate dateSelectionViewController:self didSelectDate:self.datePicker.date];
    }
    [self dismiss];
}

-(void)barButtonCancel:(id)sender{
    [self dismiss];
}

@end
