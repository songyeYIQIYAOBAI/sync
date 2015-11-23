//
//  TemplateClass.m
//  RTSS
//
//  Created by shengyp on 14/10/22.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "TemplateClass.h"

@interface TemplateClass (){
    // 私有类成员对象
    NSMutableArray* privateArray;
}

@end

@implementation TemplateClass
// 特性的设置，需要跟.h文件配对，不要使用别名
@synthesize dataArray,sectionArray;

- (void)dealloc
{
    // 对象的释放
    [rowArray release];
    [dataArray release];
    [sectionArray release];
    [privateArray release];
    
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 请用如下的标签#pragma mark表示逻辑区域，方便查找

#pragma mark loadView
-(void)loadView{
    [super loadView];
}

#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
}

#pragma mark loadData
- (void)loadData{
    // 加载数据
}

- (void)loadData:(NSMutableArray *)array{
    
}

@end
