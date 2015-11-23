//
//  ErrorMessage.h
//  RTSS
//
//  Created by 蔡杰Alan on 14-12-10.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorMessage : NSObject

+(instancetype)shareErrorMessage;

/**
 *  根据status 生成对应的错误字符串
 *
 *  @param status 状态值  具体参照MappActor 类的枚举定义
 *
 *  @return status 范围[...-1,-2,0]   status==0 返回NSString = ni;   非0 返回字符串参考内部字典映射
 */
-(NSString*)errorMessageWith:(NSInteger)status;
/**
 *  校验status ,并且弹出最简单的提示框
 *
 *  @param status          状态值
 *  @param tiltle          Alert  title
 *  @param aViewController  Alert 显示的ViewController
 *
 *  @return  YES  status！=0 有错误     NO  status == 0  正确
 */
-(BOOL)checkStatusIsError:(NSInteger)status AlertTitle:(NSString*)tiltle inViewController:(UIViewController*)aViewController;

@end
