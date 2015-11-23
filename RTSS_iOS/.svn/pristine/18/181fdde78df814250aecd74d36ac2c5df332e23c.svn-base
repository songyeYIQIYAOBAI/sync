//
//  AboutViewController.m
//  RTSS
//
//  Created by shengyp on 14/10/23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "AboutViewController.h"
#import "AboutView.h"

@interface AboutViewController (){
    AboutView * mAboutView;
}

@end

@implementation AboutViewController

- (void)dealloc{
    [mAboutView release];
    
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden  = NO;
}

- (void)loadView{
    [super loadView];
    
    mAboutView = [[AboutView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-20-44)];
    mAboutView.versionLabel.text = [NSString stringWithFormat:NSLocalizedString(@"AboutView_App_Version_Text", nil),APPLICATION_VERSION_TEXT];
    mAboutView.companyNameLabel.text = NSLocalizedString(@"AboutView_CompanyName_Text", nil);
    [self.view addSubview:mAboutView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"AboutView_Title", nil);
}

- (void)loadData{
    
}

@end
