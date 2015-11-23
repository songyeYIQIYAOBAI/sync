//
//  LivechatViewController.m
//  RTSS
//
//  Created by Liuxs on 15-1-19.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "LivechatViewController.h"
#import "ImageUtils.h"
#import "InternationalControl.h"
@interface LivechatViewController ()

@end

@implementation LivechatViewController


- (void)loadView
{
    [super loadView];
    [self layoutLivechatView];
}
-(void)changeLanguage
{
    self.title = RTSSLocalizedString(@"Support_Button_Title_liveChat", nil);

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = RTSSLocalizedString(@"Support_Button_Title_liveChat", nil);
    
}

- (void)layoutLivechatView
{
    CGRect mLivechatImageViewRect = CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-60);
    
    if(PHONE_UISCREEN_IPHONE5){
        mLivechatImageViewRect = CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-60);
    }else if(PHONE_UISCREEN_IPHONE6){
        mLivechatImageViewRect = CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-60);
    }
    UIImage *mLivechatImage = [ImageUtils imageNamed:@"Static_Support_chat" ofType:@"png"];
    UIImageView *mLivechatImageView = [[UIImageView alloc] initWithFrame:mLivechatImageViewRect];
    [mLivechatImageView setImage:mLivechatImage];
    [self.view addSubview:mLivechatImageView];
    [mLivechatImageView release];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
