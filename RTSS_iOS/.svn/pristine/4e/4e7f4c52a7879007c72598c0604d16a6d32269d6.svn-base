//
//  LanguageViewController.m
//  RTSS
//
//  Created by TLGSK on 15-1-19.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "LanguageViewController.h"
#import "InternationalControl.h"

#define LanguageTableViewHeaderHeight       25
#define LanguageTableViewFooterHeight       0.1
#define LanguageTableViewCellHeight         50

@interface LanguageViewController ()

@property (nonatomic, retain) UITableView    *languageTableView;
@property (nonatomic, retain) NSMutableArray *languageData;
@property (nonatomic, retain) NSIndexPath    *oldIndexPath;

@end

@implementation LanguageViewController
@synthesize languageTableView,languageData, oldIndexPath;

- (void)dealloc
{
    [languageTableView release];
    [oldIndexPath release];
    [languageData release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)loadView
{
    [super loadView];
    
    [self layoutLanguageView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.languageData = [NSMutableArray arrayWithCapacity:0];
    [self.languageData addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"en",@"ItemTag",@"English",@"ItemName", nil]];
    [self.languageData addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"zh-Hans",@"ItemTag",@"简体中文",@"ItemName", nil]];
}

- (void)layoutLanguageView
{
    [self.view addSubview:[self addNavigationBarView:RTSSLocalizedString(@"LanguageView_Title", nil) bgColor:[RTSSAppStyle currentAppStyle].viewControllerBgColor separator:YES]];
    
    self.languageTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(navigationBarView.frame), PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-CGRectGetMaxY(navigationBarView.frame)) style:UITableViewStyleGrouped] autorelease];
    self.languageTableView.dataSource = self;
    self.languageTableView.delegate = self;
    self.languageTableView.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    self.languageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.languageTableView];
}

- (UIView *)tableHeader
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, LanguageTableViewHeaderHeight)];
    headerView.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_separator_line.png"]];
    imageView.frame = CGRectMake(0, headerView.bounds.size.height - 2.0, PHONE_UISCREEN_WIDTH, 2.0);
    [headerView addSubview:imageView];
    [imageView release];
    
    return [headerView autorelease];
}

- (UIView *)tableFooter
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, LanguageTableViewFooterHeight)];
    footerView.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    
    return [footerView autorelease];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.languageData count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return LanguageTableViewCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return LanguageTableViewHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return LanguageTableViewFooterHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.bounds.size.width,LanguageTableViewHeaderHeight)];
    
    UIImageView* lineImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_separator_line.png"]];
    lineImage.frame = CGRectMake(0, LanguageTableViewHeaderHeight-2, headerView.bounds.size.width, 2);
    [headerView addSubview:lineImage];
    [lineImage release];
    
    return [headerView autorelease];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"LanguageCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
        cell.textLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView* lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, LanguageTableViewCellHeight-2, tableView.bounds.size.width, 2)];
        lineImageView.image = [UIImage imageNamed:@"common_separator_line.png"];
        [cell.contentView addSubview:lineImageView];
        [lineImageView release];
    }
    
    cell.textLabel.text = [[self.languageData objectAtIndex:indexPath.row] objectForKey:@"ItemName"];
    
    //选中的语言
    if ([[[InternationalControl standerControl] userLanguage] isEqualToString:[[self.languageData objectAtIndex:indexPath.row] objectForKey:@"ItemTag"]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.oldIndexPath = indexPath;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.oldIndexPath.row != indexPath.row) {
        BOOL result = [self setApplicationLanguage:[[self.languageData objectAtIndex:indexPath.row] objectForKey:@"ItemTag"]];
        if(result){
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.oldIndexPath];
            oldCell.accessoryType = UITableViewCellAccessoryNone;
            
            self.oldIndexPath = indexPath;
        }
    }

//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    });
}

- (void)applicationChangeLanguage:(NSNotification*)notification
{
    self.title = RTSSLocalizedString(@"LanguageView_Title", nil);
}

@end
