//
//  DownLoadPDFViewController.m
//  RTSS
//
//  Created by 蔡杰Alan on 14-11-27.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "DownLoadPDFViewController.h"
#import "Toast+UIView.h"
#import "RTSSAppDefine.h"
#import "AlertController.h"
#import "RTSSAppStyle.h"

static NSTimeInterval const kRTSSTimeout = 60;

@interface DownLoadPDFViewController ()<UIWebViewDelegate,AlertControllerDelegate>{
    UIWebView *webPDF;
}

@end

@implementation DownLoadPDFViewController

-(void)dealloc{
    [webPDF release];
    [super dealloc];
}
-(void)loadView{
    [super loadView];
    webPDF = [[UIWebView alloc]initWithFrame:self.view.bounds];
    webPDF.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    webPDF.delegate = self;
    [self.view addSubview:webPDF];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"PDF";
    [self loadPDFUrlString:self.pdfUrlString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --Private
-(void)loadPDFUrlString:(NSString*)urlString{
    
    NSURL *pdfUrl = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:pdfUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:kRTSSTimeout];
    [webPDF loadRequest:request];
    
}
#pragma mark --UIWebDelegate

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    [APPLICATION_KEY_WINDOW makeToastActivity];
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
     [APPLICATION_KEY_WINDOW hideToastActivity];
    
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [APPLICATION_KEY_WINDOW hideToastActivity];
    
    NSString *tips = @"Load the timeout.";
    AlertController *alert = [[AlertController alloc]initWithTitle:nil message:tips delegate:self tag:0 cancelButtonTitle:@"Sure" otherButtonTitles:nil];
    [alert showInViewController:self];
    
}
#pragma mark --AlertDelgate
-(void)alertController:(AlertController *)alertController didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    [self.navigationController popViewControllerAnimated:YES];
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
