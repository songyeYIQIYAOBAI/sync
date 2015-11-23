//
//  SinglePickerViewController.m
//  RTSS
//
//  Created by shengyp on 14/11/3.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "SinglePickerController.h"

@interface SinglePickerController (){
    UIPickerView*           pickerView;
}

@end

@implementation SinglePickerController
@synthesize delegate,pickerType,pickerTitle,pickerArrayData;

- (void)dealloc{
    [pickerView release];
    [pickerTitle release];
    [pickerArrayData release];
    
    [super dealloc];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.pickerType     = SinglePickerTypeDefault;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutPickerView{
    UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-260, self.view.bounds.size.width, 260)];
    contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:contentView];
    
    // ===
    UINavigationBar* navBar = [[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, contentView.bounds.size.width, 44)] autorelease];
    navBar.translucent = YES;
    navBar.barStyle = UIBarStyleBlackTranslucent;
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [contentView addSubview:navBar];
    
    // ===
    UINavigationItem* navItem = [[[UINavigationItem alloc] initWithTitle:self.pickerTitle] autorelease];
    
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
    
    // ===
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, contentView.bounds.size.width, 216)];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    pickerView.showsSelectionIndicator = YES;
    [contentView addSubview:pickerView];
    
    [contentView release];
}

- (void)loadView{
    [super loadView];
    
    [self layoutPickerView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{
    if(self.pickerType == SinglePickerTypeGroup){
        [pickerView selectRow:row inComponent:component animated:animated];
    }else{
        [pickerView selectRow:row inComponent:0 animated:animated];
    }
}

#pragma mark Action
- (void)barButtonDone:(UIBarButtonItem*)barButtonItem{
    if(self.pickerType == SinglePickerTypeGroup){
        if(nil != delegate && [delegate respondsToSelector:@selector(singlePickerWithDone:rows:)]){
            NSMutableArray* rows = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i < [self.pickerArrayData count]; i ++) {
                [rows addObject:[NSNumber numberWithInteger:[pickerView selectedRowInComponent:i]]];
            }
            [delegate singlePickerWithDone:self rows:rows];
        }
    }else{
        if(nil != delegate && [delegate respondsToSelector:@selector(singlePickerWithDone:selectedIndex:)]){
            [delegate singlePickerWithDone:self selectedIndex:[pickerView selectedRowInComponent:0]];
        }
    }
}

- (void)barButtonCancel:(UIBarButtonItem*)barButtonItem{
    if(nil != delegate && [delegate respondsToSelector:@selector(singlePickerWithCancel:)]){
        [delegate singlePickerWithCancel:self];
    }
}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if(self.pickerType == SinglePickerTypeGroup){
        return [self.pickerArrayData count];
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(self.pickerType == SinglePickerTypeGroup){
        return [[self.pickerArrayData objectAtIndex:component] count];
    }
    return [self.pickerArrayData count];
}

#pragma mark UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString* pickerRowTitle = @"null";
    
    switch (self.pickerType) {
        case SinglePickerTypePercent:{
            pickerRowTitle = [NSString stringWithFormat:@"%d %%",[[self.pickerArrayData objectAtIndex:row] integerValue]];
            break;
        }
        case SinglePickerTypeSpeed:{
            pickerRowTitle = [NSString stringWithFormat:@"%d Mbps",[[self.pickerArrayData objectAtIndex:row] integerValue]];
            break;
        }
        case SinglePickerTypeTimeHour:{
            pickerRowTitle = [NSString stringWithFormat:@"%d Hour",[[self.pickerArrayData objectAtIndex:row] integerValue]];
            break;
        }
        case SinglePickerTypeGroup:{
            pickerRowTitle = [[self.pickerArrayData objectAtIndex:component] objectAtIndex:row];
            break;
        }
        default:{
            pickerRowTitle = [self.pickerArrayData objectAtIndex:row];
            break;
        }
    }
    
    return pickerRowTitle;
}

@end
