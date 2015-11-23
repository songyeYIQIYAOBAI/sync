//
//  FormRowDescriptor.h
//  RTSS
//
//  Created by 蔡杰Alan on 15-1-28.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef   NS_ENUM(NSInteger, FormRowType){
    
    FormRowTypeSelect,
    FormRowTypeTextField,
    FormRowTypeTextView
};

@interface FormRowDescriptor : NSObject
/**
 *  标题
 */
@property(nonatomic,copy)NSString *title;
/**
 *  tag  作为key
 */
@property(nonatomic,copy)NSString *tag;

/**
 *  文本内容
 */
@property(nonatomic,copy)NSString *contentText;

//FormRowTypeSelect  需要赋值
@property(nonatomic,retain)NSArray *pickerArray;
/**
 *  cell  类型
 */
@property(nonatomic,assign)FormRowType rowType;

/**
 *  动态生成  cell类
 */
@property(nonatomic,readonly)NSString *cellClassString;



-(instancetype)initWithRowType:(FormRowType)type Title:(NSString*)title;
@end
