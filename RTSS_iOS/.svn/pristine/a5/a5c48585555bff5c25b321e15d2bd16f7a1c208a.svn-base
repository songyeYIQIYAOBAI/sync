//
//  FindDetailVC.m
//  SJB2
//
//  Created by shengyp on 14-6-7.
//  Copyright (c) 2014年 ailk. All rights reserved.
//

#import "FindDetailViewController.h"
#import "Toast+UIView.h"

#import "CommonUtils.h"

@interface FindDetailViewController ()

@end

@implementation FindDetailViewController
@synthesize findItem;

- (void)dealloc
{
	[findItem release];
	
	[findDetailWebView release];
	
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutModeTypeContent
{
	switch (self.findItem.itemType) {
		case FindItemModeTypeBrowser:
		case FindItemModeTypeWatch:
		case FindItemModeTypeListen:{
			findDetailWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-20-44)];
			findDetailWebView.delegate = self;
			findDetailWebView.scalesPageToFit = YES;
			[self.view addSubview:findDetailWebView];
			break;
		}
		case FindItemModeTypeDownload:{

			break;
		}
		default:
			break;
	}
}

- (void)loadingModeTypeContent
{
	NSLog(@"---->targetUrl:%@<-----",self.findItem.itemTargetUrl);
	
	if ([CommonUtils objectIsValid:self.findItem.itemTargetUrl]) {
		switch (self.findItem.itemType) {
			case FindItemModeTypeBrowser:
			case FindItemModeTypeWatch:
			case FindItemModeTypeListen:{
				NSString* targetUrlEncoding = [self.findItem.itemTargetUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
				NSLog(@"---->targetUrlEncoding:%@<-----",targetUrlEncoding);
				NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:targetUrlEncoding]];
				[findDetailWebView loadRequest:request];
				break;
			}
			case FindItemModeTypeDownload:{
				if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self.findItem.itemTargetUrl]]){
					[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.findItem.itemTargetUrl]];
				}
				break;
			}
			default:
				break;
		}
	}
}

-(void)loadView
{
	[super loadView];

	[self layoutModeTypeContent];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.findItem.itemName;
	[self loadingModeTypeContent];
}

#pragma mark ACTION
- (void)backBarButtonAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[APPLICATION_KEY_WINDOW makeToastActivity];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[APPLICATION_KEY_WINDOW hideToastActivity];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[APPLICATION_KEY_WINDOW hideToastActivity];
}

@end
