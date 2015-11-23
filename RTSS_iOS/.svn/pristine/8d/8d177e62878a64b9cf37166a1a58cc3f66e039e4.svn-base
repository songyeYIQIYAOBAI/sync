//
//  BalanceTextFieldDeleagte.m
//  RTSS
//
//  Created by 蔡杰Alan on 14-12-8.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "BalanceTextFieldDeleagte.h"
#import "UITextField+CheckState.h"
#import "AlertController.h"

#define RadixPointNum  2  //小数点位置
#define RadixPointFrontNumber 8
@implementation BalanceTextFieldDeleagte
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    BOOL  isHasRadixPoint  = YES;   //小数点判断符号
    //判断文本是否存在小数点
    NSString *existText = textField.text;
    if ([existText rangeOfString:@"."].location == NSNotFound) {
        isHasRadixPoint = NO;
    }
    if([string isEqualToString:@""])  return YES;  //删除键  返回YES
    
    unichar newChar = [string characterAtIndex:0];
    if ((newChar >= '0' &&  newChar <='9') || newChar =='.') {
        //点   防止输入多个.
        if (newChar == '.') {
            if (isHasRadixPoint)  return NO; //文本存在.
            return YES;
        }
        
        //数字
        if (!isHasRadixPoint){//没有点
            
            //判断-第一个字母是否为0
            if([textField.text length]==1){
                NSString *string_0 = textField.text;
                unichar newChar_0 = [string_0 characterAtIndex:0];
                if (newChar_0 == '0') {//首字母如果为0  下一位必须是点
                    return NO;
                }
            }
            NSInteger strLength = textField.text.length - range.length + string.length;
            return (strLength <= RadixPointFrontNumber);//小数点目前限制的位数RadixPointFrontNumber
        }
        
        NSRange ran = [existText rangeOfString:@"."];//小数点位置
        int radixPointCount = range.location - ran.location;
        if (radixPointCount <= RadixPointNum){//只允许输入RadixPointNum位小数
             return YES;
        }else {
            return NO;
        }
    }
    return NO;
}
@end
