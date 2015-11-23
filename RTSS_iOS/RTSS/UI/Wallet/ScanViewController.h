//
//  ScanViewController.h
//  RTSS
//
//  Created by 蔡杰 on 14-10-26.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "BasicViewController.h"

#import <AVFoundation/AVFoundation.h>


typedef void(^SuccessCompletion)(NSString* stringValue);

@interface ScanViewController : BasicViewController<AVCaptureMetadataOutputObjectsDelegate>{
    
    SuccessCompletion successBlock;
}

/**
 *  主要用来获取iphone一些关于相机设备的属性:
 */
@property (retain,nonatomic)AVCaptureDevice * device;

/**
 *  代表输入设备（可以是它的子类），它配置抽象硬件设备的ports
 */
@property (retain,nonatomic)AVCaptureDeviceInput * input;
/**
 *  代表输出数据，管理着输出到一个movie或者图像。
 */
@property (retain,nonatomic)AVCaptureMetadataOutput * output;
/**
 *  AVCaptureSession。 用于组织Device，input和output之间的连接，类似于DShow的filter的连接。如果能够将input和output连接，则在start之后，数据将冲input输入到output。
 */
@property (retain,nonatomic)AVCaptureSession * session;

/**
 *  视频抓屏预览层
 */
@property (retain,nonatomic)AVCaptureVideoPreviewLayer * preview;

@property(nonatomic,copy)NSString *tips;


-(void)setSuccessBlock:(SuccessCompletion)aSuccessBlock;

@end

//----------------技术调研摘要-----------------
/**
 *  CaptureDevice适配AVCaptureInput，通过Session来输入到AVCaptureOutput
    特别注意，这里的关系是可以通过唯一一个Capture Session来同时控制设备的输入和输出。
 
 */

