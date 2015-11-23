//
//  ScanViewController.m
//  RTSS
//
//  Created by 蔡杰 on 14-10-26.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "ScanViewController.h"
#import "UIView+RTSSAddView.h"

#import "RTSSAppDefine.h"
#import "CommonUtils.h"
#import "RTSSAppStyle.h"

#define kRTSSScanViewWidth  240

@interface ScanViewController ()<UINavigationControllerDelegate>{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    UIImageView *showImageView;//边框
    UIImageView *line;
}

@end

@implementation ScanViewController
@synthesize device,input,output,preview,session;

#pragma mark -- Life
-(void)dealloc{
    [self timerStop];
    
    [successBlock release];
    [preview release];
    [input release];
    [output release];
    [session release];
    [showImageView release];
    [line release];

    [super dealloc];
}

-(void)loadView{
    
    [super loadView];
    [self.view setViewBlackColor];
    
    [self installSubviews];
}

-(void)installSubviews{
    
    showImageView = [[UIImageView alloc] initWithFrame:CGRectMake((PHONE_UISCREEN_WIDTH-kRTSSScanViewWidth)/2, self.view.center.y - kRTSSScanViewWidth/2, kRTSSScanViewWidth, kRTSSScanViewWidth)];
   [self.view addSubview:showImageView];
    
    [self loadQRInterFace];
    line = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(showImageView.frame), CGRectGetMidY(showImageView.frame), kRTSSScanViewWidth, 2)];
    line.backgroundColor = [UIColor greenColor];
    [self.view addSubview:line];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    upOrdown = NO;
    num = 0;
    [self timerStart];
   // timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(upAndDownMoveLine) userInfo:nil repeats:YES];
    UIButton* scanButton = [RTSSAppStyle getMajorGreenButton:CGRectMake((PHONE_UISCREEN_WIDTH-253)/2, PHONE_UISCREEN_HEIGHT-50, 253, 45)
                                                       target:self
                                                       action:@selector(backAction)
                                                        title:NSLocalizedString(@"UIAlertView_Cancel_String", nil)];
    //scanButton.frame = CGRectMake((PHONE_UISCREEN_WIDTH-253)/2, PHONE_UISCREEN_HEIGHT-50, 253, 45);
    scanButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:scanButton];
    if (![self.tips length]>0) {
        self.tips = @"Scan your friend’s barcode to transfer money to their account";
    }
    
    UILabel* labIntroudction = [CommonUtils labelWithFrame:CGRectMake(15, CGRectGetMaxY(showImageView.frame)+20, 290, 50) text:self.tips textColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:13.0f] tag:0];
    labIntroudction.backgroundColor = [UIColor clearColor];
    [self.view addSubview:labIntroudction];
   
}

-(void)viewDidDisappear:(BOOL)animated{
    [self.preview removeFromSuperlayer];

    for(AVCaptureInput *input1 in self.session.inputs) {
        [self.session removeInput:input1];
    }
    
    for(AVCaptureOutput *output1 in self.session.outputs) {
        [self.session removeOutput:output1];
    }
    
    if ([self.session isRunning]){
        [self.session stopRunning];
    }
    
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)upAndDownMoveLine
{
    if (upOrdown == NO) {
        num ++;
        line.frame = CGRectMake(CGRectGetMinX(showImageView.frame), showImageView.frame.origin.y+2*num, kRTSSScanViewWidth, 2);
        if (2*num == kRTSSScanViewWidth) {
            upOrdown = YES;
        }
    }else {
        num --;
        line.frame = CGRectMake(CGRectGetMinX(showImageView.frame), showImageView.frame.origin.y+2*num, kRTSSScanViewWidth, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
}

-(void)backAction
{
    //[timer invalidate];
     __block typeof(self)weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        [weakSelf timerStop];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
#if TARGET_IPHONE_SIMULATOR
    
#elif TARGET_OS_IPHONE
    [self setupCamera];
#endif
}

- (void)setupCamera
{
    // Device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError  *inputError ;
    // Input
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&inputError];

    if (inputError) {
        NSLog(@"inputError = %@",inputError);
    }
    // Output
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    {
        CGSize size = self.view.bounds.size;
        CGRect cropRect = showImageView.frame;
        
        //CGRectMake(20,110,280,280);
        CGFloat p1 = size.height/size.width;
        CGFloat p2 = 1920./1080.;  //使用了1080p的图像输出
        if (p1 < p2) {
            CGFloat fixHeight = self.view.bounds.size.width * 1920. / 1080.;
            CGFloat fixPadding = (fixHeight - size.height)/2;
            self.output.rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,cropRect.origin.x/size.width,cropRect.size.height/fixHeight,cropRect.size.width/size.width);
        } else {
            CGFloat fixWidth = self.view.bounds.size.height * 1080. / 1920.;
            CGFloat fixPadding = (fixWidth - size.width)/2;
            self.output.rectOfInterest = CGRectMake(cropRect.origin.y/size.height,(cropRect.origin.x + fixPadding)/fixWidth,cropRect.size.height/size.height,cropRect.size.width/fixWidth);
        }
    }
    
    // Session
    self.session = [[[AVCaptureSession alloc] init] autorelease];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([self.session canAddInput:self.input]){
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.output]){
        [self.session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    self.output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    self.preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame =CGRectMake(0,0,PHONE_UISCREEN_WIDTH,PHONE_UISCREEN_HEIGHT);
    //CGRectMake(20,110,280,280);
    [self.view.layer insertSublayer:self.preview atIndex:0];
    /** start
     *  它会自动跑起来，把输入设备的东西，提交到输出设备中。
     */
    [self.session startRunning];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    NSString *stringValue;
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        [self.session stopRunning];
         __block typeof(self)weakSelf = self;
        [self dismissViewControllerAnimated:NO completion:^{
             [weakSelf timerStop];
             NSLog(@"````%@",stringValue);
            if (successBlock) {
                successBlock(stringValue);
            }
             
         }];
    }else{
        NSLog(@"error");
    }
}

-(void)setSuccessBlock:(SuccessCompletion)aSuccessBlock{
    [successBlock release];
     successBlock = [aSuccessBlock copy];
}

#pragma mark --
-(void)loadQRInterFace{
   //top
    [self createBlurViewWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, CGRectGetMinY(showImageView.frame))];
    //左
    [self createBlurViewWithFrame:CGRectMake(0, CGRectGetMinY(showImageView.frame), (PHONE_UISCREEN_WIDTH-CGRectGetWidth(showImageView.frame))/2, CGRectGetHeight(showImageView.frame))];
    //下
    [self createBlurViewWithFrame:CGRectMake(0, CGRectGetMaxY(showImageView.frame), PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-CGRectGetMaxY(showImageView.frame))];
    //右
    [self createBlurViewWithFrame:CGRectMake(CGRectGetMaxX(showImageView.frame), CGRectGetMinY(showImageView.frame), PHONE_UISCREEN_WIDTH-CGRectGetMaxX(showImageView.frame), CGRectGetHeight(showImageView.frame))];
}

-(void)createBlurViewWithFrame:(CGRect)fame{
    UIView *tempView = [[UIView alloc]initWithFrame:fame];
    tempView.alpha = 0.3f;
    tempView.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:tempView];
}
#pragma mark --timer
-(void)timerStart{
    [self timerStop];
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(upAndDownMoveLine) userInfo:nil repeats:YES];
}
-(void)timerStop{
    if (timer && [timer isValid]) {
        [timer invalidate];
        timer = nil;
    }
}

@end