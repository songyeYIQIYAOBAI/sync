//
//  ChoicePayModeViewController.m
//  RTSS
//
//  Created by 蔡杰 on 14-11-3.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "ChoicePayModeViewController.h"

#import "UIView+RTSSAddView.h"
#import "RTSSAppDefine.h"
#import "CommonUtils.h"
#import "PassWordViewViewController.h"
#import "RTSSPopPasswordView.h"
#import "RTSSAppStyle.h"

#define kRTSSEdge 10
#define kRTSSTextWidth 200
#define kRTSSTextHeight  15

@protocol HeaderDelegate <NSObject>

-(void)cancelThePayment;

@end

@interface HeaderView : UIView


@end

@interface HeaderView (){
    
    UILabel *userInfoLabel;
    
}

@property(nonatomic,assign)id<HeaderDelegate> delegate;

//-(void)
@end

@implementation HeaderView

-(void)dealloc{
    
    
    
    [super dealloc];
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self installSubviews];
        
    }
    
    return self;
    
}

-(void)installSubviews{
    
    //button
    UIButton *cancle = [UIButton buttonWithType:UIButtonTypeCustom];
    cancle.frame = CGRectMake(kRTSSEdge, kRTSSEdge, 20, 20);
    cancle.backgroundColor = [UIColor blueColor];
    [cancle addTarget:self action:@selector(cancelPay) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancle];
    
    //固定的提示信息
    UILabel *tipsLabel = [CommonUtils labelWithFrame:CGRectMake(CGRectGetMaxX(cancle.frame)+kRTSSEdge, kRTSSEdge, kRTSSTextWidth, kRTSSTextHeight) text:@"Select Payment Mode" textColor:[UIColor blackColor] textFont:[UIFont systemFontOfSize:20.0f] tag:0];
    [self addSubview:tipsLabel];
    
    userInfoLabel = [CommonUtils labelWithFrame:CGRectMake(CGRectGetMaxX(cancle.frame), CGRectGetMaxY(tipsLabel.frame)+kRTSSEdge*2, kRTSSTextWidth, kRTSSTextHeight) text:@"VVM VOLTE €200" textColor:[UIColor darkGrayColor] textFont:[UIFont systemFontOfSize:20.0f] tag:0];
    [self addSubview:userInfoLabel];
    
    //底线
    UIImageView *line = [[UIImageView alloc]init];
    line.frame = CGRectMake(0,self.bounds.size.height-1, self.bounds.size.width, 1);
    [line setBackgroundColor:[UIColor colorWithRed:132.0/255 green:139.0/255 blue:143.0/255 alpha:1.0]];
    [self addSubview:line];
    [line release];
}

-(void)cancelPay{
    
    if (_delegate && [_delegate respondsToSelector:@selector(cancelThePayment)]) {
        [_delegate cancelThePayment];
    }

}

@end




@interface ChoicePayModeViewController ()<UITableViewDelegate,UITableViewDataSource,HeaderDelegate>{
    
    UITableView *tableView;
    
}

@end

@implementation ChoicePayModeViewController

#pragma mark  --life
-(void)dealloc{
    
    //[headerView release];
    [tableView release];
    [super dealloc];
}

-(void)loadView{
    
    [super loadView];
    [self.view setViewBlackColor];
    [self intallTableViews];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Choice Pay Mode";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- InstallViews

-(void)intallTableViews{
    
    CGFloat edge = 15.0f;
    CGFloat tableHeight = 120;
    [self.view setViewBlackColor];
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, tableHeight) style:UITableViewStylePlain];
    [tableView setViewBlackColor];
   tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    tableView.bounces = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    
    [self.view addSubview:tableView];
    UIButton *nextButton = [CommonUtils buttonWithType:UIButtonTypeCustom frame:CGRectMake((PHONE_UISCREEN_WIDTH-253)/2, CGRectGetMaxY(tableView.frame)+edge*2, 253, 54)title:@"Top Up" colorNormal:[RTSSAppStyle currentAppStyle].commonGreenButtonNormalColor colorHighlighted:[RTSSAppStyle currentAppStyle].commonGreenButtonHighlightColor colorSelected:nil addTarget:self action:@selector(next) tag:0];
    
    nextButton.layer.cornerRadius = 6.0f;
    nextButton.layer.masksToBounds = YES;
    [self.view addSubview:nextButton];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(UITableViewCell*)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"加载");
     static NSString *CelIdentify = @"CellIdentify";
    UITableViewCell *cell  = [aTableView dequeueReusableCellWithIdentifier:CelIdentify];
    
    if (nil == cell) {
        
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CelIdentify]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *cellBgimageView = [[UIImageView alloc]init];
        [cellBgimageView setViewBlackColor];
        cell.backgroundView = cellBgimageView;
        NSLog(@"herge3");
        //
    }
    
    
    cell.textLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"CMB Credit Card(1073)";
        }
            break;
        case 1:{
             cell.textLabel.text = @"Pay with Another Card";
            break;
        }
            
        default:
            break;
    }
    [cell.contentView addBottomLine];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
    }
    
    if (indexPath.row == 1) {

    }
}


#pragma mark --Action

-(void)next{
    
    RTSSPopPasswordView *popPasswordView = [[RTSSPopPasswordView alloc]init];
    [popPasswordView show];
    [popPasswordView release];
  }

#pragma mark --HeaderDelegate
-(void)cancelThePayment{
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
