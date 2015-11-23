//
//  MyServicesViewController.m
//  RTSS
//
//  Created by 宋野 on 14-11-13.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "MyServicesViewController.h"
#import "Toast+UIView.h"

#import "MyServicesTableView.h"
#import "PlanManageModel.h"
#import "RTSSAppStyle.h"
#import "DropDownItemView.h"
#import "ProductOffer.h"
#import "Subscriber.h"


#define TABLEVIEW_LEFT_INTERAL          14.f

@interface MyServicesViewController ()<MyServicesTableViewDelegate,MappActorDelegate>

@property (nonatomic ,retain)MyServicesTableView * myTableView;

@end

@implementation MyServicesViewController
@synthesize myTableView;

- (void)dealloc{
    [myTableView release];
    [super dealloc];
}

- (void)loadView{
    [super loadView];
    [self layoutContentView];
}

- (void)layoutContentView{
    self.view.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    
    myTableView = [[MyServicesTableView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT - 64)];
    myTableView.delegate = self;
    
    [self.view addSubview:myTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"My services";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData{
    //调取获取数据的接口
    [[Subscriber sharedSubscriber] availableProducts:self];
}

#pragma mark - MyServicesTableViewDelegate

- (void)myServicesTableViewDidSelectRowWithIndexPath:(NSIndexPath *)indexPath Tag:(NSInteger)indx{
    //TODO....
    
}

#pragma mark - MappActorDelegate
//添加数据
- (void)availableProducts:(NSInteger)status message:(NSString*)message
       negotiableProducts:(NSArray*)negotiableProducts noNegotiableProducts:(NSArray*)noNegotiableProducts{
    if (status == MappActorFinishStatusOK) {
        [APPLICATION_KEY_WINDOW hideToastActivity];
        
        NSMutableArray * sections = [NSMutableArray arrayWithObjects:@"My Services", nil];
        NSMutableArray * section = [NSMutableArray array];
        NSMutableArray * rows = [NSMutableArray array];
        
        [section addObjectsFromArray:negotiableProducts];
        [section addObjectsFromArray:noNegotiableProducts];
        [rows addObject:section];
        
        myTableView.sections = sections;
        myTableView.rows = rows;
        [myTableView reloadData];
        
        NSLog(@"MyServices data load success");
    }else if (status == MappActorFinishStatusTimeOut){
        //链接超时
        NSLog(@"MyServices data load fail, MappActor Finish Status TimeOut");
    }else{
        NSLog(@"I don't know the reason");
    }
}


@end
