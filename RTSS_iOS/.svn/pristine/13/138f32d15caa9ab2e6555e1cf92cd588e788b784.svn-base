//
//  PayViewController.m
//  RTSS
//
//  Created by 蔡杰Alan on 14-12-5.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "PayViewController.h"

static BOOL AUTO_FINISH=YES;

@interface PayViewController ()<UIWebViewDelegate,NSURLConnectionDelegate,AlertControllerDelegate>{
    UIWebView *paymentWebView;
    BOOL authenticated;
    NSURLRequest *failedRequest;
    
    NSString* _returnURL;
}

- (NSString*)getReturnURL:(NSString*)requestURL;
- (NSString*)getPayResult:(NSURL*)responseURL;

@end

@implementation PayViewController

@synthesize payUrlString;
@synthesize payAction;
@synthesize payFor;
@synthesize delegate;

-(void)dealloc {
    [paymentWebView release];
    paymentWebView = nil;
    [payUrlString release];
    payUrlString = nil;
    [_returnURL release];
    [payAction release];
    payAction = nil;
    [payFor release];
    payFor = nil;
    [super dealloc];
}

-(void)loadView{
  [super loadView];
  //加载
  paymentWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
  paymentWebView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
  paymentWebView.delegate = self;
  paymentWebView.scalesPageToFit = YES;
  [self.view addSubview:paymentWebView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Pay_Title", nil);
 
    [self loadUrlString:self.payUrlString];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [APPLICATION_KEY_WINDOW hideToastActivity];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark --Private
-(void)loadUrlString:(NSString*)urlString{
    NSLog(@"PayViewController::loadUrlString:loadurl=%@", urlString);
    _returnURL = [[self getReturnURL:urlString] retain];
    
    NSString *handlerUrl = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    handlerUrl = [handlerUrl stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    NSURL *payUrl = [NSURL URLWithString:handlerUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:payUrl];
    [paymentWebView loadRequest:request];
    
}
#pragma mark --UIWebDelegate

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    NSLog(@"webViewDidStartLoad");
    [APPLICATION_KEY_WINDOW makeToastActivity];
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [APPLICATION_KEY_WINDOW hideToastActivity];
    NSLog(@"webViewDidFinishLoad");
    authenticated = NO;
    
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [APPLICATION_KEY_WINDOW hideToastActivity];
    NSLog(@"error==%@",error);
    authenticated = NO;

}

- (NSString*)getReturnURL:(NSString*)requestURL {
    NSString* returnURL = nil;
    
    @try {
        NSArray* components = [requestURL componentsSeparatedByString:@"="];
        if (nil != components) {
            NSString* codedRequestMessage = [components objectAtIndex:1];
            
            NSString* requestMessage = [codedRequestMessage stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            if (NULL != requestMessage) {
                NSArray* messagePieces = [requestMessage componentsSeparatedByString:@"|"];
                
                if (nil != messagePieces) {
                    for (NSString* messagePiece in messagePieces) {
                        if (YES == [messagePiece hasPrefix:@"http"]) {
                            returnURL = messagePiece;
                            NSLog(@"PayViewController:getReturnURL:returnURL=%@", returnURL);
                            
                            break;
                        }
                    }
                }
            }
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"PayViewController:getReturnURL:exception=%@", [exception description]);
    }
    
    return returnURL;
}

- (NSString*)getPayResult:(NSURL*)responseURL {
    NSString* payResult = nil;
    
    @try {
        
        NSString* queryString = [responseURL query];
        NSLog(@"PayViewController:getPayResult:queryString=%@", queryString);
        
        NSString* codedPayResult = nil;
        if (nil != queryString) {
            NSArray* parameters = [queryString componentsSeparatedByString:@"&"];
            for (NSString* parameter in parameters) {
                if (YES == [parameter hasPrefix:@"response="]) {
                    codedPayResult = [[parameter componentsSeparatedByString:@"="] objectAtIndex:1];
                    break;
                }
            }
        }
        
        payResult = [codedPayResult stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    }
    @catch (NSException *exception) {
        NSLog(@"PayViewController:getPayResult:exception=%@", [exception description]);
    }
    
    return payResult;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    BOOL result = YES;
    
    NSLog(@"shouldStartLoadWithRequest:url=%@", request.URL.absoluteString);
    
    if (YES == AUTO_FINISH && nil != _returnURL && YES == [request.URL.absoluteString hasPrefix:_returnURL]) {
        NSLog(@"should be pay result");
        
        NSString* payResult = [self getPayResult:request.URL];
        NSLog(@"shouldStartLoadWithRequest:payResult=%@", payResult);
        
        if (nil != payResult) {
            @try {
                NSArray* components = [payResult componentsSeparatedByString:@"|"];
                NSLog(@"shouldStartLoadWithRequest:components=%@", [components description]);
                
                NSString* status = [components objectAtIndex:0];
                NSString* clientId = [components objectAtIndex:1];
                NSString* merchantId = [components objectAtIndex:2];
                NSString* customerId = [components objectAtIndex:3];
                NSString* transactionRefNum = [components objectAtIndex:4];
                NSString* errorCode = [components objectAtIndex:5];
                NSString* txnAmount = [components objectAtIndex:6];
                NSString* shortMsg = [components objectAtIndex:7];
                NSString* responseMsg = [components objectAtIndex:8];
                NSString* checkSum = [components objectAtIndex:9];
                
                NSMutableDictionary* resultDict = [NSMutableDictionary dictionaryWithCapacity:0];
                [resultDict setObject:(nil != payAction ? payAction : @"") forKey:@"Action"];
                [resultDict setObject:(nil != payFor ? payFor : @"") forKey:@"PaymentFor"];
                [resultDict setObject:status forKey:@"Status"];
                [resultDict setObject:clientId forKey:@"ClientId"];
                [resultDict setObject:merchantId forKey:@"MerchantId"];
                [resultDict setObject:customerId forKey:@"CustomerId"];
                [resultDict setObject:transactionRefNum forKey:@"TransactionRefNum"];
                [resultDict setObject:txnAmount forKey:@"TxnAmount"];
                [resultDict setObject:errorCode forKey:@"ErrorCode"];
                [resultDict setObject:shortMsg forKey:@"ShortMsg"];
                [resultDict setObject:responseMsg forKey:@"ResponseMsg"];
                [resultDict setObject:checkSum forKey:@"CheckSum"];
                
                if (nil != delegate && [delegate respondsToSelector:@selector(paymentActionBackWithPaymentStatus:andParameters:)]) {
                    [delegate paymentActionBackWithPaymentStatus:[@"000" isEqualToString:status] andParameters:resultDict];
                }
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            @catch (NSException *exception) {
                NSLog(@"shouldStartLoadWithRequest:exception=%@", [exception description]);
            }
        }
        
    } else {
        //判断是不是https
        NSString* scheme = [[request URL] scheme];
        if ([scheme isEqualToString:@"https"]) {
            //如果是https:的话，那么就用NSURLConnection来重发请求。从而在请求的过程当中吧要请求的URL做信任处理。
            result = authenticated;
            if (!authenticated) {
                failedRequest = request;
                NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                [connection start];
                [connection release];
            }
        }
    }
    
    return result;
}

#pragma mark nsurlconnection delegate
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    }
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    authenticated = YES;
    [connection cancel];
    [paymentWebView loadRequest:failedRequest];
}

#pragma mark--OverRide 父类
- (void)backBarButtonAction:(UIButton*)barButtonItem{
    AlertController *alert = [[AlertController alloc]initWithTitle:nil message:NSLocalizedString(@"Pay_Quit_Alert", nil) delegate:self tag:0 cancelButtonTitle:NSLocalizedString(@"UIAlertView_Cancel_String", nil) otherButtonTitles:NSLocalizedString(@"UIAlertView_Confirm_String", nil),nil];
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
            if (delegate && [delegate respondsToSelector:@selector(paymentActionBackWithPaymentStatus:)]) {
                //temp 暂定status是yes
                [delegate paymentActionBackWithPaymentStatus:YES];
            }
        }
        return;
}

+ (void)showPayResult:(NSDictionary*)payResult inController:(UIViewController*)controller delegate:(id)delegate {
    
    NSString* action = [payResult objectForKey:@"Action"];
    NSString* paymentFor = [payResult objectForKey:@"PaymentFor"];
    NSString* status = [payResult objectForKey:@"Status"];
    NSString* transactionRefNum = [payResult objectForKey:@"TransactionRefNum"];
    NSString* txnAmount = [payResult objectForKey:@"TxnAmount"];
    NSString* errorCode = [payResult objectForKey:@"Errorcode"];
    NSString* responseMsg = [payResult objectForKey:@"ResponseMsg"];
    
    NSString* message = nil;
    if (YES == [status isEqualToString:@"000"]) {
        message = [NSString stringWithFormat:NSLocalizedString(@"Successful_Payment_Result", nil),
                                NSLocalizedString(@"Payment_Result_Successful", @"Payment Successful"),
                                action,
                                paymentFor,
                                transactionRefNum,
                                txnAmount];
    } else {
        message = [NSString stringWithFormat:NSLocalizedString(@"Failed_Payment_Result", nil),
                                NSLocalizedString(@"Payment_Result_Failed", @"Payment Failed"),
                                action,
                                paymentFor,
                                transactionRefNum,
                                txnAmount,
                                responseMsg,
                                errorCode];
    }
    
    AlertController *alert = [[AlertController alloc]initWithTitle:NSLocalizedString(@"Pay_Result_Title", @"Transaction Summary") message:message delegate:delegate tag:0 cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"UIAlertView_Confirm_String", nil),nil];
    alert.messageTextAlignment = NSTextAlignmentLeft;
    [alert showInViewController:controller];
    [alert release];
}

@end
