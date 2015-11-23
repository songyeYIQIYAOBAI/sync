//
//  PersonCenterViewController.m
//  RTSS
//
//  Created by 宋野 on 14-11-6.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "PersonCenterTableView.h"
#import "ChangePasswordViewController.h"
#import "RechargeViewController.h"
#import "AboutViewController.h"
#import "TransactionFootPrintViewController.h"
#import "AppDelegate.h"
#import "SinglePickerController.h"

#import "FileUtils.h"
#import "UserDefaults.h"
#import "ActionSheetController.h"
#import "Subscriber.h"
#import "Session.h"
#import "Settings.h"
#import "Cache.h"
#import "ImageUtils.h"
#import "FindHomeViewController.h"

#import "MManager.h"

@interface PersonCenterViewController ()<PersonCenterTableViewDelegate,ActionSheetControllerDelegate,AlertControllerDelegate,MappActorDelegate,SinglePickerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    PersonCenterItemModel * photoItemModel;
    PersonCenterTableView * personCenterTableView;
    
    SinglePickerController* accountsPicker;
    NSInteger               currentAccountIndex;
}

@property (nonatomic, retain) NSMutableArray * sections;
@property (nonatomic, retain) NSMutableArray * rows;

@property (nonatomic ,retain) NSIndexPath * selectCellIndexPath;
@property (nonatomic, retain) NSData * imageData;

@end

@implementation PersonCenterViewController
@synthesize imageData, sections, rows;

- (void)dealloc{
    [accountsPicker release];
    [personCenterTableView release];
    [sections release];
    [rows release];
    [imageData release];
    
    [super dealloc];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        currentAccountIndex = [self getCustomerSubscribersIdIndex];
        accountsPicker = [[SinglePickerController alloc] init];
        accountsPicker.delegate = self;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [APPLICATION_KEY_WINDOW hideToastActivity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutPersonCenterTableView{
    //添加tableView
    personCenterTableView = [[PersonCenterTableView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT-20-44)];
    personCenterTableView.backgroundColor = [UIColor clearColor];
    personCenterTableView.delegate = self;
    
    PersonCenterTableFootView * personCenterTableFootView = (PersonCenterTableFootView *)personCenterTableView.myTableView.tableFooterView;
    [personCenterTableFootView.logOutBtn addTarget:self action:@selector(logOutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:personCenterTableView];
}

- (void)loadView{
    [super loadView];
    
    [self layoutPersonCenterTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"PersonCenterView_Title", nil);
}


- (void)loadData{
    self.sections = [NSMutableArray arrayWithObjects:@"UserInfo",@"My Plan", nil];
    
    self.rows = [[NSMutableArray alloc] initWithCapacity:0];
    
    {
        NSMutableArray * section = [NSMutableArray array];
        [rows addObject:section];
        
        PersonCenterItemModel * itemModel0 = [[PersonCenterItemModel alloc] init];
        itemModel0.itemExplanation = NSLocalizedString(@"PersonCenterView_Profile_Photo_Label", nil);
//        if([CommonUtils objectIsValid:[Session sharedSession].mCurrentSubscriber.mPortrait]){
//            itemModel0.itemHeadImage = [Session sharedSession].mCurrentSubscriber.mPortrait;
//        }
        itemModel0.itemLeftImage = @"personcenter_cell_headimage.png";
        itemModel0.itemType = PersonCenterTableViewCellTypePhoto;
        [section addObject:itemModel0];
        [itemModel0 release];
        photoItemModel = itemModel0;
        
        PersonCenterItemModel * itemModel1 = [[PersonCenterItemModel alloc] init];
        itemModel1.itemExplanation = NSLocalizedString(@"PersonCenterView_Name_Label", nil);
//        if([CommonUtils objectIsValid:[Session sharedSession].mMyCustomer.mCustomerName]){
//            itemModel1.itemText = [Session sharedSession].mMyCustomer.mCustomerName;
//        }
        itemModel1.itemLeftImage = @"personcenter_cell_name.png";
        itemModel1.itemType = PersonCenterTableViewCellTypeName;
        [section addObject:itemModel1];
        [itemModel1 release];

        PersonCenterItemModel * itemModel2 = [[PersonCenterItemModel alloc] init];
        itemModel2.itemExplanation = NSLocalizedString(@"PersonCenterView_Phone_Number_Label", nil);
        if([CommonUtils objectIsValid:[Session sharedSession].mMyCustomer.mPhoneNumber]){
            itemModel2.itemText = [Session sharedSession].mMyCustomer.mPhoneNumber;
        }
        itemModel2.itemLeftImage = @"personcenter_cell_phone.png";
        itemModel2.itemType = PersonCenterTableViewCellTypePhoneNumber;
        [section addObject:itemModel2];
        [itemModel2 release];
        
        PersonCenterItemModel * itemModel4 = [[PersonCenterItemModel alloc] init];
        itemModel4.itemExplanation = NSLocalizedString(@"PersonCenterView_Change_Password_Label", nil);
        itemModel4.itemText = @"";
        itemModel4.itemLeftImage = @"personcenter_cell_locked.png";
        itemModel4.itemType = PersonCenterTableViewCellTypeChangePassWord;
        [section addObject:itemModel4];
        [itemModel4 release];
    }
    
    {
        NSMutableArray * section = [NSMutableArray array];
        [rows addObject:section];

        PersonCenterItemModel * itemModel = [[PersonCenterItemModel alloc] init];
        itemModel.itemExplanation = NSLocalizedString(@"PersonCenterView_My_Plan_Label", nil);
        itemModel.itemText = @"";
        itemModel.itemLeftImage = @"personcenter_cell_packageserve.png";
        itemModel.itemType = PersonCenterTableViewCellTypeMyPlan;
        [section addObject:itemModel];
        [itemModel release];
        
        itemModel = [[PersonCenterItemModel alloc] init];
        itemModel.itemExplanation = @"My History";
        itemModel.itemText = @"";
        itemModel.itemLeftImage = @"personcenter_cell_myhistory.png";
        itemModel.itemType = PersonCenterTableViewCellTypeMyHistory;
        [section addObject:itemModel];
        [itemModel release];
        
        itemModel = [[PersonCenterItemModel alloc] init];
        itemModel.itemExplanation = @"My Favorites";
        itemModel.itemText = @"";
        itemModel.itemLeftImage = @"personcenter_cell_myfavorites.png";
        itemModel.itemType = PersonCenterTableViewCellTypeMyFavorites;
        [section addObject:itemModel];
        [itemModel release];
        
        itemModel = [[PersonCenterItemModel alloc] init];
        itemModel.itemExplanation = NSLocalizedString(@"PersonCenterView_My_Subscribers_Label", nil);
        itemModel.itemText = [self getCustomerSubscribers].mId;
        itemModel.itemLeftImage = @"personcenter_cell_accounts.png";
        itemModel.itemType = PersonCenterTableViewCellTypeMyAccount;
        [section addObject:itemModel];
        [itemModel release];
    }
    
    [personCenterTableView reloadTableViewSection:self.sections row:self.rows];
}

- (void)finishViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma - ButtonMedthod
- (void)logOutBtnClick:(UIButton *)button{
    AlertController*  alertController = [[AlertController alloc] initWithTitle:nil message:NSLocalizedString(@"PersonCenterView_Logout_Alert_Message", nil) delegate:self tag:PersonCenterViewAlertTagLogout cancelButtonTitle:NSLocalizedString(@"UIAlertView_Cancel_String", nil) otherButtonTitles:NSLocalizedString(@"UIAlertView_Confirm_String", nil),nil];
    [alertController showInViewController:self];
    [alertController release];
}

#pragma mark - PersonCenterTableViewDelegate
- (void)PersonCenterTablewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath indexTag:(NSInteger)indexTag{
    //点击个人中心cell响应事件
    self.selectCellIndexPath = indexPath;
    
    UIViewController* viewController = nil;
    
    if (indexTag == PersonCenterTableViewCellTypePhoto) {
        [self showAcitonSheetWithPhoto];
    }else if (indexTag == PersonCenterTableViewCellTypeChangePassWord){
        viewController = [[ChangePasswordViewController alloc] init];
    }else if (indexTag == PersonCenterTableViewCellTypeMyPlan){
        RechargeViewController * rechargeViewController = [[RechargeViewController alloc] init];
        rechargeViewController.contentType = ContentTypeMyPlan;
        viewController = rechargeViewController;
    }else if(indexTag == PersonCenterTableViewCellTypeAbout){
        viewController = [[AboutViewController alloc] init];
    }else if (indexTag == PersonCenterTableViewCellTypeMyHistory){
        viewController = [[TransactionFootPrintViewController alloc] init];
    }else if (indexTag == PersonCenterTableViewCellTypeMyFavorites){
        viewController = [[FindHomeViewController alloc] initWithFindMode:FindModeByCollection findTag:0];
    }else if(indexTag == PersonCenterTableViewCellTypeVersionUpdate){
        
    }else if(indexTag == PersonCenterTableViewCellTypeMyAccount){
        [self showAccountsPicker];
    }
    
    if(nil != viewController){
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
}

- (void)PersonCenterTablewClickHeadImageButton:(UIButton *)button{
    //点击头像响应事件
    [self showAcitonSheetWithPhoto];
}

- (void)showAccountsPicker
{
    NSMutableArray* pickerArrayData = [NSMutableArray arrayWithCapacity:0];
    for (int i =0 ; i < [[[MManager sharedMManager]getSession].mMyCustomer.mMySubscribers count]; i ++) {
        Subscriber* subsTemp = [[[MManager sharedMManager]getSession].mMyCustomer.mMySubscribers objectAtIndex:i];
        if(![CommonUtils objectIsValid:subsTemp.mId]){
            subsTemp.mId = @"";
        }
        [pickerArrayData addObject:subsTemp.mId];
    }
    accountsPicker.pickerArrayData = pickerArrayData;
    if(NO == [CommonUtils objectIsValid:accountsPicker.pickerArrayData]) return;
    
    [self.view.window addSubview:accountsPicker.view];
    
    [accountsPicker selectRow:currentAccountIndex inComponent:0 animated:NO];
}

- (void)showAcitonSheetWithPhoto{
    if([CommonUtils objectIsValid:[Session sharedSession].mMyUser.mPortrait]){
        ActionSheetController* actionSheet = [[ActionSheetController alloc] initWithTitle:nil delegate:self tag:100 cancelButtonTitle:NSLocalizedString(@"UIAlertView_Cancel_String", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"PersonCenterView_ActionSheet_Take_Photo", nil), NSLocalizedString(@"PersonCenterView_ActionSheet_Choose_Photos", nil), NSLocalizedString(@"PersonCenterView_ActionSheet_Remove_Photo", nil),nil];
        [actionSheet showInViewController:self];
        [actionSheet release];
    }else{
        ActionSheetController* actionSheet = [[ActionSheetController alloc] initWithTitle:nil delegate:self tag:101 cancelButtonTitle:NSLocalizedString(@"UIAlertView_Cancel_String", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"PersonCenterView_ActionSheet_Take_Photo", nil),NSLocalizedString(@"PersonCenterView_ActionSheet_Choose_Photos", nil), nil];
        [actionSheet showInViewController:self];
        [actionSheet release];
    }
}

- (void)showRemovePhotoWithAlert{
    NSString* message = [NSString stringWithFormat:@"%@?",NSLocalizedString(@"PersonCenterView_ActionSheet_Remove_Photo", nil)];
    AlertController* alert = [[AlertController alloc] initWithTitle:nil message:message delegate:self tag:PersonCenterViewAlertTagRemovePhoto cancelButtonTitle:NSLocalizedString(@"UIAlertView_Cancel_String", nil) otherButtonTitles:NSLocalizedString(@"UIAlertView_Confirm_String", nil),nil];
    [alert showInViewController:self];
    [alert release];
}

#pragma mark - ActionSheetControllerDelegate
- (void)actionSheetController:(ActionSheetController *)controller didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    switch (controller.tag) {
        case 100:{
            if (buttonIndex == controller.firstOtherButtonIndex) {
                [self imagePickerSourceType:UIImagePickerControllerSourceTypeCamera];
            }else if (buttonIndex == controller.firstOtherButtonIndex+1){
                [self imagePickerSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            }else if(buttonIndex == controller.firstOtherButtonIndex+2){
                [self showRemovePhotoWithAlert];
            }
            break;
        }
        case 101:{
            if (buttonIndex == controller.firstOtherButtonIndex) {
                [self imagePickerSourceType:UIImagePickerControllerSourceTypeCamera];
            }else if (buttonIndex == controller.firstOtherButtonIndex+1){
                [self imagePickerSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            }
            break;
        }
        default:
            break;
    }

}

- (void)imagePickerSourceType:(UIImagePickerControllerSourceType)type{
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = type;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
    [imagePicker release];
}

#pragma mark - SinglePickerDelegate
- (void)singlePickerWithCancel:(SinglePickerController*)controller
{
    [controller.view removeFromSuperview];
}

- (void)singlePickerWithDone:(SinglePickerController*)controller selectedIndex:(NSInteger)index
{
    if(accountsPicker == controller && index >= 0 && index < [accountsPicker.pickerArrayData count]){
        
        if (currentAccountIndex == index) {
            //如果还是当前的 subscribers 返回
            return;
        }
        currentAccountIndex = index;
        NSString* subscriberID =((Subscriber*)[[[MManager sharedMManager] getSession].mMyCustomer.mMySubscribers objectAtIndex:index]).mId;
        
        [[Settings standardSettings] setCustomerSubscriberId:subscriberID];
        
        [[RTSSNotificationCenter standardRTSSNotificationCenter] postNotificationWithType:RTSSNotificationTypeChangeAccount object:nil userInfo:nil];
        
        [self performSelector:@selector(finishViewController) withObject:nil afterDelay:0.5];
    }
    [controller.view removeFromSuperview];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage * editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [APPLICATION_KEY_WINDOW makeToastActivity];
        
        UIImage * image = [ImageUtils scaleImage:editImage scaleWidth:150.0];
        self.imageData = UIImagePNGRepresentation(image);
        
        //调用接口,上传头像
        [[Session sharedSession].mCurrentSubscriber updatePortrait:self.imageData delegate:self];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - AlertControllerDelegate
- (void)alertController:(AlertController *)alertController didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    switch (alertController.tag) {
        case PersonCenterViewAlertTagLogout:{
            if (alertController.firstOtherButtonIndex == buttonIndex) {
                
                [[Session sharedSession].mMyUser logout:nil];
                [[Settings standardSettings] setAutoLoginSwitch:NO];
                
                [[AppDelegate shareAppDelegate] startRTSSViewControllerType:RTSSViewControllerTypeLogin functionType:BasicViewControllerFunctionTypeLogout];
            }
            break;
        }
        case PersonCenterViewAlertTagRemovePhoto:{
            if(alertController.firstOtherButtonIndex == buttonIndex){
                [APPLICATION_KEY_WINDOW makeToastActivity];
                
                //调用接口,移除头像
                self.imageData = nil;
//                [[Session sharedSession].mMyUser removePortrait:self];
            }
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - MappActorDelegate
- (void)updatePropertyFinished:(NSInteger)status propertyUrl:(NSString*)propertyUrl{
    [APPLICATION_KEY_WINDOW hideToastActivity];
    if (MappActorFinishStatusOK == status) {
        if (self.imageData) {
            [[Cache standardCache] updateImageWithUrl:propertyUrl data:self.imageData];
        }
        [[Settings standardSettings] setUserPortrait:propertyUrl];
        photoItemModel.itemHeadImage = propertyUrl;
        [personCenterTableView.myTableView reloadRowsAtIndexPaths:@[self.selectCellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        //== 通知外部页面更新
        [[RTSSNotificationCenter standardRTSSNotificationCenter] postNotificationWithType:RTSSNotificationTypeUserPortrait object:nil userInfo:nil];
    }else if (MappActorFinishStatusNetwork == status){
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"ErroMessage_Status_Network", nil)];
    }else {
        [APPLICATION_KEY_WINDOW makeToast:NSLocalizedString(@"PersonCenterView_Update_Portrait_Fail_Error", nil)];
    }
}

- (void)logoutFinished:(NSInteger)status{
    [APPLICATION_KEY_WINDOW hideToastActivity];

    if (status == MappActorFinishStatusOK) {

    }
}
#pragma mark --多账户切换

- (Subscriber*)getCustomerSubscribers
{
    
    
    NSString* customerSubscriberId = [[Settings standardSettings] getCustomerSubscriberId];
    
    if([CommonUtils objectIsValid:customerSubscriberId]){
        for (Subscriber* subscriber in [[MManager sharedMManager]getSession].mMyCustomer.mMySubscribers) {
            if([subscriber.mId isEqualToString:customerSubscriberId]){
                NSLog(@"---settting get customerSubscriber ");
                return subscriber;
            }
        }
    }
    if([CommonUtils objectIsValid:[Session sharedSession].mMyCustomer.mMySubscribers]){
        NSLog(@"------->%@",[Session sharedSession].mMyCustomer.mMySubscribers);
        return [[[MManager sharedMManager]getSession].mMyCustomer.mMySubscribers objectAtIndex:0];
    }
    
    return nil;
}

- (NSInteger)getCustomerSubscribersIdIndex
{
    
    NSString* customerSubscriberId = [[Settings standardSettings] getCustomerSubscriberId];
    
    if([CommonUtils objectIsValid:customerSubscriberId]){
        for (int i = 0; i < [[[MManager sharedMManager] getSession].mMyCustomer.mMySubscribers count]; i ++) {
            Subscriber* subs = [[Session sharedSession].mMyCustomer.mMySubscribers objectAtIndex:i];
            if([subs.mId isEqualToString:customerSubscriberId]){
                return i;
            }
        }
    }
    
    if([CommonUtils objectIsValid:[[MManager sharedMManager] getSession].mMyCustomer.mMySubscribers]){
        return 0;
    }
    
    
    return 0;
}


@end
