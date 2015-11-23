//
//  AddServiceRequestViewController.m
//  EasyTT
//
//  Created by 蔡杰 on 14-10-14.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import "AddServiceRequestViewController.h"
#import "AlertController.h"
#import "ServiceRequestTableViewCell.h"
#import "RTSSAppDefine.h"
#import "TPKeyboardAvoidingTableView.h"
#import "FormDescriptor.h"
#import "FormRowDescriptor.h"
#import "FormBaseTableViewCell.h"
#import "Session.h"
#import "Customer.h"
#define SUBMIT_ALERT_TAG     100
#define FINISH_ALERT_TAG     200
@interface AddServiceRequestViewController ()<UITableViewDataSource,UITableViewDelegate,AlertControllerDelegate,MappActorDelegate,FormBaseTableViewCellDelegate>

@property(nonatomic,retain)UITableView *tableView;

@property(nonatomic,retain)FormDescriptor *form; //数据源配置
@property(nonatomic,assign)int mPickTag;
@property(nonatomic,retain)NSArray *mServiceData;
@property(nonatomic,retain)NSArray *mCategoryData;
@property(nonatomic,retain)NSArray *mSubCategoryData;
@property(nonatomic,retain)NSString *subscriberId;
@end

@implementation AddServiceRequestViewController

-(void)dealloc{
    
    [_tableView release];
    [_form release];
    [_mServiceData release];
    [_mCategoryData release];
    [_mSubCategoryData release];
    [_subscriberId release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = NSLocalizedString(@"Add_Service_Request_Title", nil);
    }
    return self;
}

#pragma mark --Set property
-(UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorInset = UIEdgeInsetsZero;
    }
    
    return _tableView;
}

-(FormDescriptor *)form{
    
    if (!_form) {
        
        _form = [[FormDescriptor alloc]init
        ];
    }
    
    return _form;
}

#pragma mark -- Life


-(void)loadView{
    [super loadView];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   

   // [self.tableView setSeparatorColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"common_separator_line"]]];
    //submit
    //self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit setFrame:CGRectMake(20, 10, 280, 40)];

    UIView *buttonBgView = [[UIView alloc]initWithFrame:CGRectMake(0,0,PHONE_UISCREEN_WIDTH,60)];
    buttonBgView.backgroundColor =[RTSSAppStyle currentAppStyle].navigationBarColor;
    NSLog(@"buttonY= %@",NSStringFromCGRect(buttonBgView.frame));
    UIButton *submitButton =[RTSSAppStyle getMajorGreenButton:CGRectMake((PHONE_UISCREEN_WIDTH-253)/2,CGRectGetHeight(buttonBgView.frame)/2-40/2, 253, 40) target:self action:@selector(submitInfo) title:@"Submit"];
    submitButton.backgroundColor = [UIColor grayColor];
    submitButton.layer.cornerRadius = 6.0f;
    submitButton.layer.masksToBounds = YES;
    [buttonBgView addSubview:submitButton];
   self.tableView.tableFooterView = buttonBgView;
    [buttonBgView release];

}
-(void)loadData{
    
    [self loadFrom];
}

#pragma mark --Action
-(void)submitInfo
{
    [self.view endEditing:YES];
    
    FormRowDescriptor *categoryRowDes = self.form.rowDataSoure[1];
    FormRowDescriptor *subCategoryRowDes = self.form.rowDataSoure[2];
    FormRowDescriptor *titleRowDes = self.form.rowDataSoure[3];
    FormRowDescriptor *descriptionRowDes = self.form.rowDataSoure[4];
    if (categoryRowDes.contentText.length == 0 || subCategoryRowDes.contentText.length == 0 || titleRowDes.contentText.length == 0 || descriptionRowDes.contentText.length == 0) {
        // title = nil
        AlertController *alert = [[AlertController alloc]initWithTitle:nil message:NSLocalizedString(@"Add_Service_Request_Service_Request_Complete_The_Information", nil) delegate:self tag:0 cancelButtonTitle:NSLocalizedString(@"UIAlertView_Confirm_String", nil) otherButtonTitles:nil,nil];
        [alert showInViewController:self];
        [alert release];
        
        return;
    }
    
    AlertController *alert = [[AlertController alloc]initWithTitle:nil message:[self.form showString] delegate:self tag:SUBMIT_ALERT_TAG cancelButtonTitle:NSLocalizedString(@"UIAlertView_Cancel_String", nil) otherButtonTitles:NSLocalizedString(@"UIAlertView_Confirm_String", nil),nil];
    [alert showInViewController:self];
    [alert release];
    
    //[AlertController showSimpleAlertWithTitle:nil message:[self.form showString] buttonTitle:@"Sure" inViewController:self];
    
//    AlertController *alert = [[AlertController alloc]initWithTitle:@"Submit successfully" message:[self.form showString] delegate:self tag:0 cancelButtonTitle:@"Sure" otherButtonTitles:nil];
//    [alert showInViewController:self];
//    [alert release];
//    NSLog(@"--%@--",[self.form formValues]);
}

#pragma mark -- pickerDone

-(void)pickerButtonDone:(NSInteger)buttonTag
{
    [self.view endEditing:YES];
}


-(void)singlePickerWithButtonTag:(NSInteger)buttonTag DoneWithselectedIndex:(NSInteger)index isChange:(BOOL)isChange
{
    if (buttonTag == 0) {
        self.subscriberId = self.mServiceData[index];
    }
    if (isChange) {
        [self getInfo:buttonTag+1 pickId:index];
    }
    
}

#pragma mark -- 刷新picker数据
- (void)getInfo:(int)pickTag pickId:(int)pickId
{
    //    NSLog(@"subscriberId == %@",self.subscriberId);
    self.mPickTag = pickTag;
    switch (pickTag) {
        case 1:
            // 调用接口
            [APPLICATION_KEY_WINDOW makeToastActivity];
            [[Session sharedSession].mMyCustomer queryServiceRequestCategoryWithSubscriberId:self.subscriberId andCategoryId:nil andLevel:0 andDelegate:self];
            break;
        case 2:
            //            NSLog(@"%@",[[self.mCategoryData objectAtIndex:pickId] objectForKey:@"categoryId"]);
            [APPLICATION_KEY_WINDOW makeToastActivity];
            [[Session sharedSession].mMyCustomer queryServiceRequestCategoryWithSubscriberId:self.subscriberId andCategoryId:[[self.mCategoryData objectAtIndex:pickId] objectForKey:@"categoryId"] andLevel:0 andDelegate:self];
            break;
        default:
            break;
    }
}

#pragma mark -- picker数据回调
- (void)queryServiceRequestCategoryFinished:(NSInteger)status andInfo:(NSArray *)info
{
    [APPLICATION_KEY_WINDOW hideToastActivity];
    if (status == MappActorFinishStatusOK) {
        if (self.mPickTag == 1) {
            self.mCategoryData = info;
        } else if (self.mPickTag == 2) {
            self.mSubCategoryData = info;
        }
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dic in info) {
            [array addObject:[dic objectForKey:@"categoryName"]];
        }
        FormRowDescriptor *pickerRow = [self.form.rowDataSoure objectAtIndex:self.mPickTag];
        pickerRow.pickerArray = array;
        
        FormBaseTableViewCell *cell = (FormBaseTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.mPickTag inSection:0]];
        [cell update];
        [self getInfo:self.mPickTag+1 pickId:0];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --OverRide
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.form.rowDataSoure.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormRowDescriptor *row = [self.form.rowDataSoure objectAtIndex:indexPath.row];
    
   return [FormBaseTableViewCell formBaseCellFiedHeightByFormRowType:row.rowType];
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormRowDescriptor *row = [self.form.rowDataSoure objectAtIndex:indexPath.row];
    
    NSString *cellClassString = row.cellClassString;
    
    FormBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellClassString];
    
    if (cell == nil) {
        cell = [[NSClassFromString(cellClassString) alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellClassString];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configure];
        [cell setCellBlackViewColor:[RTSSAppStyle currentAppStyle].viewControllerBgColor];
        cell.delegate = self;
    }
    cell.pickerButtonTag = indexPath.row;
    cell.rowDescriptor = row;
    
    return cell;
      
}

#pragma mark --loadForm
-(void)loadFrom{
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    NSArray* subscribers = [Session sharedSession].mMyCustomer.mMySubscribers;
    for (Subscriber *subscriber in subscribers) {
        [array addObject:subscriber.mId];
    }
    
    self.mServiceData = array;
    self.subscriberId = self.mServiceData[0];
    FormRowDescriptor *serviceRow = [[FormRowDescriptor alloc]initWithRowType:FormRowTypeSelect Title:NSLocalizedString(@"Add_Service_Request_Service_Title", nil)];
    serviceRow.pickerArray = self.mServiceData;
    
    FormRowDescriptor *categoryRow = [[FormRowDescriptor alloc]initWithRowType:FormRowTypeSelect Title:NSLocalizedString(@"Add_Service_Request_Category_Title", nil)];
    
    FormRowDescriptor *subCategoryRow = [[FormRowDescriptor alloc]initWithRowType:FormRowTypeSelect Title:NSLocalizedString(@"Add_Service_Request_Sub_Category_Title", nil)];
    
    FormRowDescriptor *titleRow = [[FormRowDescriptor alloc]initWithRowType:FormRowTypeTextField Title:NSLocalizedString(@"Add_Service_Request_Title_Title", nil)];
    
    
    FormRowDescriptor *descriptionRow = [[FormRowDescriptor alloc]initWithRowType:FormRowTypeTextView Title:NSLocalizedString(@"Add_Service_Request_Description_Title", nil)];
    
    [self.form.rowDataSoure addObject:serviceRow];
    [self.form.rowDataSoure addObject:categoryRow];
    [self.form.rowDataSoure addObject:subCategoryRow];
    [self.form.rowDataSoure addObject:titleRow];
    [self.form.rowDataSoure addObject:descriptionRow];
    
    [serviceRow release];
    [categoryRow release];
    [subCategoryRow release];
    [titleRow release];
    [descriptionRow release];
    
    [self getInfo:1 pickId:0];
}
-(void)alertController:(AlertController *)alertController didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (alertController.tag) {
        case SUBMIT_ALERT_TAG:{
            if (buttonIndex == 1) {
                // 提交
                [self createServiceRequestWithRequestInfo];
            }
            break;
        }
        case FINISH_ALERT_TAG:{
            if (buttonIndex == 0) {
                // 提交成功
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark -- 提交数据
- (void)createServiceRequestWithRequestInfo
{
    NSMutableDictionary *requestInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    
    for (FormRowDescriptor *rowDes in self.form.rowDataSoure) {
        if ([rowDes.title isEqualToString:NSLocalizedString(@"Add_Service_Request_Description_Title", nil)]) {
            [requestInfo setObject:rowDes.contentText forKey:@"description"];
        } else if ([rowDes.title isEqualToString:NSLocalizedString(@"Add_Service_Request_Title_Title", nil)]) {
            [requestInfo setObject:rowDes.contentText forKey:@"title"];
        } else if ([rowDes.title isEqualToString:NSLocalizedString(@"Add_Service_Request_Service_Title", nil)]) {
            [requestInfo setObject:rowDes.contentText forKey:@"subscriberId"];
        } else if ([rowDes.title isEqualToString:NSLocalizedString(@"Add_Service_Request_Category_Title", nil)]) {
            [requestInfo setObject:rowDes.contentText forKey:@"categoryId"];
        } else if ([rowDes.title isEqualToString:NSLocalizedString(@"Add_Service_Request_Sub_Category_Title", nil)]) {
            [requestInfo setObject:rowDes.contentText forKey:@"subSubCategoryId"];
        }
        
        [requestInfo setObject:self.subscriberId forKeyedSubscript:@"subCategoryId"];
        [requestInfo setObject:[Session sharedSession].mMyCustomer.mId forKey:@"customerId"];
        [requestInfo setObject:[Session sharedSession].mCurrentAccount.mId forKey:@"accountId"];
    }
    [APPLICATION_KEY_WINDOW makeToastActivity];
    [[Session sharedSession].mMyCustomer createServiceRequestWithRequestInfo:requestInfo andDelegate:self];
}

#pragma mark -- 提交数据回调
- (void)createServiceRequestFinished:(NSInteger)status andInfo:(NSString *)info
{
    [APPLICATION_KEY_WINDOW hideToastActivity];
    if (status == MappActorFinishStatusOK) {
        // 弹框
        AlertController *alert = [[AlertController alloc]initWithTitle:NSLocalizedString(@"Add_Service_Request_Submit_successfully", nil) message:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"Add_Service_Request_Service_Request_ID", nil),info] delegate:self tag:FINISH_ALERT_TAG cancelButtonTitle:NSLocalizedString(@"UIAlertView_Cancel_String", nil) otherButtonTitles:nil,nil];
        [alert showInViewController:self];
        [alert release];
        
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
