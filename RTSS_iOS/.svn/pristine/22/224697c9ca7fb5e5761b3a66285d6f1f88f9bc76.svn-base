//
//  FAQViewController.m
//  RTSS
//
//  Created by Liuxs on 15-1-16.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "FAQViewController.h"
#import "RTSSAppStyle.h"
#import "FAQTableView.h"
#import "FAQTableViewCell.h"
#import "InternationalControl.h"
#import "RTSSAppDefine.h"
@interface FAQViewController ()

@property (nonatomic, retain) NSArray *contents;

@end

@implementation FAQViewController
@synthesize mResultsArr,tempResults,mTableView,mSearch,mSearchPlay,contents;

-(void)dealloc
{
    [mTableView  release];
    [mSearch     release];
    [mSearchPlay release];
    [tempResults release];
    [contents    release];
    [mResultsArr release];
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    [self layoutTableView];
    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backBarButtonAction:)]autorelease];
    [self.navigationController.navigationBar addGestureRecognizer:tap];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = RTSSLocalizedString(@"Support_Title_FAQ", nil);
    
    self.tempResults = [NSMutableArray arrayWithCapacity:0];
}



    

- (void)backBarButtonAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)layoutTableView
{
    CGRect mBackButtonRect = CGRectMake(288, 9, 19, 19);
    CGRect mTableViewRect  = CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-60);
    if(PHONE_UISCREEN_IPHONE5){
        
    }else if(PHONE_UISCREEN_IPHONE6){
        mBackButtonRect   = CGRectMake(338, 11, 22, 22);
    }
    
    UIButton *mBackButton = [CommonUtils buttonWithType:UIButtonTypeCustom
                                                  frame:mBackButtonRect
                                                  title:nil
                                            imageNormal:[UIImage imageNamed:@"Support_FAQBack.png"]
                                       imageHighlighted:[UIImage imageNamed:@"Support_FAQBack.png"]
                                          imageSelected:nil
                                              addTarget:self
                                                 action:@selector(backBarButtonAction:)
                                                    tag:0];
    [mBackButton setTitleColor:[RTSSAppStyle currentAppStyle].textSubordinateColor forState:UIControlStateNormal];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:mBackButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
    self.contents = @[@[@[@"How does he want us to help?"],@[@"Did you try a particular help topic."]],@[
                    @[@"Device", @"Row0_Subrow1", @"Row0_Subrow2", @"Row0_Subrow3"],
                    @[@"Subscriptions & Service", @"Mobile", @"Broadband", @"MBB"]]];

    self.mTableView = [[[FAQTableView alloc] initWithFrame:mTableViewRect] autorelease];
    self.mTableView.FAQTableViewDelegate = self;
    self.mTableView.backgroundColor      = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    self.mTableView.separatorStyle       = UITableViewCellSeparatorStyleNone;//去掉分割线
    // 搜索框
//    self.mTableView.tableHeaderView      = [self headerView];
    [self.view addSubview:self.mTableView];
}

- (UIView *)headerView
{
    self.mSearch = [[[UISearchBar alloc] initWithFrame:CGRectMake(0,10,PHONE_UISCREEN_WIDTH,40)] autorelease];
    self.mSearch.delegate          = self;
    self.mSearch.showsCancelButton = NO;
    self.mSearch.searchBarStyle    = UISearchBarStyleProminent;
    self.mSearch.keyboardType      = UIKeyboardTypeDefault;
    self.mSearch.barTintColor      = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    self.mSearch.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;

    self.mSearchPlay = [[[UISearchDisplayController alloc] initWithSearchBar:self.mSearch contentsController:self] autorelease];
    self.mSearchPlay.searchBar.barStyle      = UISearchBarStyleMinimal;
    self.mSearchPlay.delegate                = self;
    self.mSearchPlay.searchResultsDataSource = self;
    self.mSearchPlay.searchResultsDelegate   = self;
    //收索框背景颜色＊＊＊＊＊＊＊
    self.mSearchPlay.searchBar.barTintColor  = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    ;

    for (UIView *subView in self.mSearchPlay.searchBar.subviews)
    {
        for (UIView *secondLevelSubview in subView.subviews){
            if ([secondLevelSubview isKindOfClass:[UITextField class]])
            {
                UITextField *searchBarTextField    = (UITextField *)secondLevelSubview;
                //set font color here
                searchBarTextField.textColor       = [RTSSAppStyle currentAppStyle].textMajorColor;
                searchBarTextField.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
                
                break;
            }
        }
    }

    [self.mSearchPlay setActive:NO animated:YES];
    self.mSearchPlay.searchResultsTableView.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    //    [self setExtraCellLineHidden:mSearchPlay.searchResultsTableView];
    
    return self.mSearchPlay.searchBar;
}

//自定义搜索取消button title
-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    [self.mSearch setShowsCancelButton:YES animated:NO];
    UIView *topView = controller.searchBar.subviews[0];
    
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            UIButton *cancelButton = (UIButton*)subView;
            [cancelButton setTitle:RTSSLocalizedString(@"UIAlertView_Cancel_String",nil) forState:UIControlStateNormal];  //@"取消"
//            cancelButton.titleLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
            [cancelButton setTitleColor:[RTSSAppStyle currentAppStyle].textMajorColor forState:UIControlStateNormal];
        }
    }
}
// 开始搜索
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}
// 取消搜索
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.mSearchPlay.searchResultsTableView]) {
        return 1;
    }
    return [self.contents count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.mSearchPlay.searchResultsTableView]) {
        return [self.mResultsArr count];
    }
    return [self.contents[section] count];
}

- (NSInteger)tableView:(FAQTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.contents[indexPath.section][indexPath.row] count] - 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FAQTableViewCell";
    
    FAQTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
        cell = [[[FAQTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    
    if([tableView isEqual:self.mSearchPlay.searchResultsTableView]) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去掉分割线
        cell.textLabel.text      = [self.mResultsArr objectAtIndex:indexPath.row];
    }else {
        cell.textLabel.text   = self.contents[indexPath.section][indexPath.row][0];
        if ([self.contents[indexPath.section][indexPath.row] count]>1)
            cell.isExpandable = YES;
        else
            cell.isExpandable = NO;
    }
    cell.textLabel.textColor   = [RTSSAppStyle currentAppStyle].textMajorColor;
    cell.textLabel.font        = [RTSSAppStyle getRTSSFontWithSize:13.0f];
    cell.backgroundColor       = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    cell.selectionStyle        = UITableViewCellSelectionStyleNone;
    
    UIImageView *mLineViewDown = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-1, PHONE_UISCREEN_WIDTH, 1)];
    mLineViewDown.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
//    mLineViewDown.image = [UIImage imageNamed:@"common_separator_line.png"];
    [cell addSubview:mLineViewDown];
    [mLineViewDown release];

    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    
    UITableViewCell *cell     = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    
    cell.textLabel.text       = [NSString stringWithFormat:@"%@", self.contents[indexPath.section][indexPath.row][indexPath.subRow]];
    cell.textLabel.textColor  = [RTSSAppStyle currentAppStyle].textMajorColor;
    cell.textLabel.font       = [RTSSAppStyle getRTSSFontWithSize:13.0f];
    cell.backgroundColor      = [RTSSAppStyle currentAppStyle].navigationBarColor;
    cell.selectionStyle       = UITableViewCellSelectionStyleNone;
    cell.accessoryType        = UITableViewCellAccessoryNone;
    UIImageView *mLineViewDown = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-1, PHONE_UISCREEN_WIDTH, 1)];
    mLineViewDown.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
//    mLineViewDown.image = [UIImage imageNamed:@"common_separator_line.png"];
    [cell addSubview:mLineViewDown];
    [mLineViewDown release];
    return cell;
}

///*
#pragma mark -
#pragma mark UISearchDisplayControllerDelegate
//text是输入的文本,scope是搜索范围
- (void)searchText:(NSString*)text andWithScope:(NSString*)scope
{
    NSArray *abc;
    //CONTAINS是字符串比较操作符，
    NSPredicate *result = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",text];
    for (int a = 0; a<2; a++) {
        for (int b = 0; b<[self.contents[a] count]; b++) {
            for (int c = 0; c<[self.contents[a][b] count]; c++) {
                abc = [self.contents[a][b] filteredArrayUsingPredicate:result];
                for (int d = 0; d<[abc count]; d++) {
                    [self.tempResults addObject:[abc objectAtIndex:d]];
                }
                
            }
        }
        
    }
    self.mResultsArr = [self arrayWithMemberIsOnly:self.tempResults];
    [self.tempResults removeAllObjects];
    [self.mTableView refreshResultsArr:self.mResultsArr UISearchDisplayController:self.mSearchPlay];

}
- (NSMutableArray *)arrayWithMemberIsOnly:(NSArray *)array
{
    NSMutableArray *categoryArray = [NSMutableArray arrayWithCapacity:0];
    for (unsigned i = 0; i < [array count]; i++) {
        @autoreleasepool {
            if ([categoryArray containsObject:[array objectAtIndex:i]] == NO) {
                [categoryArray addObject:[array objectAtIndex:i]];
            }
        }
    }
    return categoryArray;
}
- (BOOL) searchDisplayController:(UISearchDisplayController*)controller shouldReloadTableForSearchString:(NSString*)searchString
{
    // searchString是输入的文本
    //返回结果数据读取搜索范围在选择范围
    NSArray *searScope = [self.mSearchPlay.searchBar scopeButtonTitles];//数组范围
    [self searchText:searchString andWithScope:[searScope objectAtIndex:[self.mSearchPlay.searchBar selectedScopeButtonIndex]]];
    return YES;
}

- (BOOL) searchDisplayController:(UISearchDisplayController*)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    NSString *inputText = self.mSearchPlay.searchBar.text;//搜索输入的文本
    NSArray *searScope  = [self.mSearchPlay.searchBar scopeButtonTitles];//索索范围
    [self searchText:inputText andWithScope:[searScope objectAtIndex:searchOption]];
    return YES;
}

-(void)changeLanguage
{
    self.title =  RTSSLocalizedString(@"Support_Title_FAQ", nil);
    [self searchDisplayControllerWillBeginSearch:self.mSearchPlay];
}


//*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
