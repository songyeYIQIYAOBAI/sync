//
//  TemplateClass.h
//  RTSS
//
//  Created by shengyp on 14/10/22.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

// 枚举类型定义
typedef NS_ENUM(NSInteger, TemplateType) {
    TemplateTypeData,
    TemplateTypeUI
};

// 同一张图片不同分辨率的，请用Images.xcassets进行适配，App内部共用的，分辨率不发生变化的，请添加到Images组目录里面

// 添加文件需要在工程文件目录（Finder）下面建立对应的文件夹，并且在添加到应用工程的group中，也要建立对应的group

// 目前，采用非ARC机制，注意对象的释放

// 大括号在类和函数的后面，如下

@interface TemplateClass : UIViewController{
    // 类成员对象的变量名称，请遵循java风格，开头字母小写，后面的单词间隔，单词首字母大写，如,
    NSMutableArray* rowArray;
}

// 类成员对外的对象，但外面不能改变此对象，请这样定义
@property(nonatomic, readonly) NSMutableArray* dataArray;

// 类成员对外的对象，但外面能改变此对象，请这样定义
@property(nonatomic, retain) NSMutableArray* sectionArray;

// 对外的接口定义
- (void)loadData:(NSMutableArray*)array;

@end
