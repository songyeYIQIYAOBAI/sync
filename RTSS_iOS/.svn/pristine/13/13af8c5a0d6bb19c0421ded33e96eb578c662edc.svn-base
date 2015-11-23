//
//  MessageBoxViewController.m
//  RTSS
//
//  Created by dongjf on 14/10/23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "MessageBoxViewController.h"
#import "CommonUtils.h"
#import "MessageCell.h"
#import "MessageDetailViewController.h"
#import "RTSSAppStyle.h"
#import "AlertController.h"
#import "Toast+UIView.h"
#import "DateUtils.h"
#import "SinglePickerController.h"

#import "Messages.h"
#import "MessageItem.h"


#define HEADERINSECTION_HEIGHT    40
#define ARROW_IMAGE_SIZE          25
#define SELECT_DELETE             100
#define ALL_DELETE                200
@interface MessageBoxViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,AlertControllerDelegate,MappActorDelegate,SinglePickerDelegate,MappActorDelegate> {
    UITableView *messageTableView;
    NSInteger selectedIndex;
    BOOL isEditing;
    UIButton *mFiltrateButton;

}
@property (nonatomic, retain) SinglePickerController *mSingPicker;
@property (nonatomic, assign) NSInteger mSelectedIndex;
@property (nonatomic, retain) NSMutableArray *pickerArrayData;

@property (nonatomic,retain) NSMutableDictionary *deleteDic;
@end

@implementation MessageBoxViewController

@synthesize messagesArray,deleteDic,pickerArrayData;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark init views
- (void)layoutMessageTableView
{
    self.deleteDic = [NSMutableDictionary dictionaryWithCapacity:0];
    if(messageTableView){
        [messageTableView removeFromSuperview];
        messageTableView = nil;
    }
    CGRect frame = CGRectMake(0.f, 0.f, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT - 20.f - 44.f);
    messageTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    messageTableView.backgroundColor = [UIColor clearColor];
    messageTableView.delegate = self;
    messageTableView.dataSource = self;
    messageTableView.sectionHeaderHeight = HEADERINSECTION_HEIGHT;
    messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    messageTableView.showsHorizontalScrollIndicator = NO;
    messageTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:messageTableView];
}

- (void)initNavigationBar {
    if (self.navigationItem.rightBarButtonItem == nil) {
        CGRect buttonRect = CGRectMake(0.f, 0.f, 32.f, 32.f);
//        CGRect button2Rect = CGRectMake(0.f, 0.f, 40.f, 32.f);
        UIButton *trashButton = [CommonUtils buttonWithType:UIButtonTypeCustom frame:buttonRect title:nil bgImageNormal:[UIImage imageNamed:@"message_trash_a"] bgImageHighlighted:[UIImage imageNamed:@"message_trash_d"] bgImageSelected:nil addTarget:self action:@selector(deleteMessage:) tag:0];
//        UIButton *editButton = [CommonUtils buttonWithType:UIButtonTypeCustom frame:button2Rect title:@"编辑" bgImageNormal:nil bgImageHighlighted:nil bgImageSelected:@"Static_Support_ expandableImage.png" addTarget:self action:@selector(editMessage:) tag:1];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:trashButton];
        UIBarButtonItem *editItem  = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(editMessage:)];
        editItem.tag = SELECT_DELETE;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightItem,editItem, nil];
        [rightItem release];
        [editItem release];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void) loadView {
    [super loadView];
    [self layoutMessageTableView];
    [self initNavigationBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Message_Box_Title", nil);
    selectedIndex = -1;
    [messageTableView reloadData];
}


#pragma mark tableview delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *mHeaderInSection = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, HEADERINSECTION_HEIGHT)];
    mHeaderInSection.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    UILabel *mFiltrateLabel = [CommonUtils labelWithFrame:CGRectMake(10, HEADERINSECTION_HEIGHT/4, 0, HEADERINSECTION_HEIGHT/2) text:[self.pickerArrayData objectAtIndex:self.mSelectedIndex] textColor:[RTSSAppStyle currentAppStyle].textMajorColor textFont:[RTSSAppStyle getRTSSFontWithSize:16] tag:0];
    [mFiltrateLabel sizeToFit];
    [mHeaderInSection addSubview:mFiltrateLabel];
    
    mFiltrateButton = [CommonUtils buttonWithType:UIButtonTypeCustom frame:CGRectMake(PHONE_UISCREEN_WIDTH-ARROW_IMAGE_SIZE-10, (HEADERINSECTION_HEIGHT-ARROW_IMAGE_SIZE)/2, ARROW_IMAGE_SIZE, ARROW_IMAGE_SIZE) title:nil bgImageNormal:[UIImage imageNamed:@"common_arrow_down.png"] bgImageHighlighted:nil bgImageSelected:nil addTarget:self action:@selector(filtrate:) tag:0];
    [mHeaderInSection addSubview:mFiltrateButton];
    
    UIImageView *mLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, HEADERINSECTION_HEIGHT-1, PHONE_UISCREEN_WIDTH, 1)];
    mLineImageView.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [mHeaderInSection addSubview:mLineImageView];
    [mLineImageView release];
    return [mHeaderInSection autorelease];
}

- (void)filtrate:(UIButton *)button
{
    NSLog(@"筛选");
    [self.view.window addSubview:self.mSingPicker.view];
    [self.mSingPicker selectRow:self.mSelectedIndex inComponent:0 animated:NO];
    [button setBackgroundImage:[UIImage imageNamed:@"common_arrow_up.png"] forState:UIControlStateNormal];
}

-(SinglePickerController *)mSingPicker{
    
    if (!_mSingPicker) {
        
        _mSingPicker = [[SinglePickerController alloc]init];
        _mSingPicker.pickerType = SinglePickerTypeDefault;
        _mSingPicker.delegate = self;
        //数据加载
        _mSingPicker.pickerArrayData = self.pickerArrayData;
    }
    
    return _mSingPicker;
    
}



// 单列
- (void)singlePickerWithDone:(SinglePickerController*)controller selectedIndex:(NSInteger)index
{
    NSLog(@"确定--开始筛选");
    [mFiltrateButton setBackgroundImage:[UIImage imageNamed:@"common_arrow_down.png"] forState:UIControlStateNormal];
    [controller.view removeFromSuperview];
    if (self.mSelectedIndex == index) {
        return;
    }
    self.mSelectedIndex = index;
    [self.messagesArray removeAllObjects];
    if (index == 0) {
        [self.messagesArray addObjectsFromArray:[[Messages sharedMessages] messagesWithDelegate:self]];
        
    }else {
        [self.messagesArray addObjectsFromArray:[[Messages sharedMessages] getMessageItemByFromName:self.pickerArrayData[index]]];
        
    }
    
    [messageTableView reloadData];
}

// cancel
- (void)singlePickerWithCancel:(SinglePickerController*)controller
{
    NSLog(@"取消");
    [mFiltrateButton setBackgroundImage:[UIImage imageNamed:@"common_arrow_down.png"] forState:UIControlStateNormal];
    [controller.view removeFromSuperview];
}

#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return [messagesArray count] > 0 ? 1 : 0;
    if (self.mSelectedIndex == 0) {
        NSLog(@"%d",[self.messagesArray count]);
        return [messagesArray count] > 0 ? 1 : 0;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [messagesArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MESSAGE_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"messageCellId";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier availableSize:CGSizeMake(CGRectGetWidth(messageTableView.frame), MESSAGE_CELL_HEIGHT)] autorelease];
        
        UIView *selectedView = [[UIView alloc] initWithFrame:cell.frame];
        selectedView.backgroundColor = [[RTSSAppStyle currentAppStyle] navigationBarColor];
        cell.selectedBackgroundView = selectedView;
        [selectedView release];
        
        UIView *unselectedView = [[UIView alloc] initWithFrame:cell.frame];
        unselectedView.backgroundColor = [[RTSSAppStyle currentAppStyle] viewControllerBgColor];
        cell.backgroundView = unselectedView;
        [unselectedView release];
    }

    MessageItem *messageData = [self.messagesArray objectAtIndex:indexPath.row];
    if (messageData) {
        [cell layoutSubviewsByMessageData:messageData showSeperateLine:YES];
    }
    cell.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isEditing) {
        if ([self.deleteDic objectForKey:indexPath]) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self.deleteDic removeObjectForKey:indexPath];
            return;
        }
        [self.deleteDic setObject:[self.messagesArray objectAtIndex:indexPath.row] forKey:indexPath];
        return;
    }
    MessageItem *messageData = [self.messagesArray objectAtIndex:indexPath.row];
    
    //标记已经阅读
    if (messageData.mHasRead == NO) {
        messageData.mHasRead = YES;
        [[Messages sharedMessages] updateItem:messageData];
    }
    [tableView reloadData];
    
    MessageDetailViewController *detailVC = [[MessageDetailViewController alloc] init];
    detailVC.messageData = messageData;
    [self.navigationController pushViewController:detailVC animated:YES];
    [detailVC release];
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isEditing) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.deleteDic removeObjectForKey:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除数据
        BOOL result = [self synchronizeDeleteMessage:[self.messagesArray objectAtIndex:indexPath.row]];
        if (result) {
            [messageTableView beginUpdates];

            if ([self.messagesArray count] == 0 && self.mSelectedIndex == 0) {
                self.navigationItem.rightBarButtonItems = nil;
                [messageTableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
            } else {
                [messageTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
            }
            [messageTableView endUpdates];
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isEditing) {
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleDelete;
}


#pragma mark init data
- (void) loadData {
    messagesArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.pickerArrayData = [NSMutableArray arrayWithCapacity:0];
    self.mSelectedIndex = 0;
    
    [APPLICATION_KEY_WINDOW makeToastActivity];
    NSArray *array = [[Messages sharedMessages] messagesWithDelegate:self];
    [self createPickerArrayData];
    if ([array count] > 0) {
        [APPLICATION_KEY_WINDOW hideToastActivity];
        [self.messagesArray addObjectsFromArray:array];
//        [self sortMessagesByDescendOrder];
        [messageTableView reloadData];
    }
}

#pragma mark getPickerDataArray
- (void)createPickerArrayData
{
    [self.pickerArrayData removeAllObjects];
    NSArray *array = [[Messages sharedMessages] getFromNamesAndFromCodesFromDB];
    if ([array count] > 0) {
        for (NSDictionary *from in array) {
            NSLog(@"%@",from);
            [self.pickerArrayData addObject:[from objectForKey:@"MESSAGE_FROMNAME"]];
        }
    }
    
    [self.pickerArrayData insertObject:@"All" atIndex:0];
}


#pragma mark mappactor delegate
- (void)queryNotificationFinished:(NSInteger)status andInfo:(NSArray *)info
{
    [APPLICATION_KEY_WINDOW hideToastActivity];
    if (status == MappActorFinishStatusOK && [info count] > 0 && info) {
        [self.messagesArray addObjectsFromArray:info];
        [self createPickerArrayData];
        //重新排序
//        [self sortMessagesByDescendOrder];
        [messageTableView reloadData];
        
    } else {
        
    }
}


- (void)sortMessagesByDescendOrder {
    NSComparator comparator = ^NSComparisonResult(MessageItem *message1,MessageItem *message2) {
        if (message1.mTimeStamp > message2.mTimeStamp) {
            return NSOrderedDescending;
        } else if (message1.mTimeStamp < message2.mTimeStamp) {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
    };
    [messagesArray sortUsingComparator:comparator];
}

#pragma mark button clicked
- (void)deleteMessage:(UIBarButtonItem *)enditItem {
    
    if (isEditing) {
        NSLog(@"多选删除");
        AlertController *alert = [[AlertController alloc] initWithTitle:nil message:@"是否删除所选条目" delegate:self tag:SELECT_DELETE cancelButtonTitle:NSLocalizedString(@"UIAlertView_Cancel_String", nil)  otherButtonTitles:NSLocalizedString(@"UIAlertView_Confirm_String", nil),nil];
        [alert showInViewController:self];
        [alert release];
        return;
    }
    
    //点击此按钮提示是否清空所有消息，点击确定执行删除操作
    if ([self.messagesArray count] == 0) {
        return;
    }
    AlertController *alert = [[AlertController alloc] initWithTitle:nil message:NSLocalizedString(@"Message_Box_Delete_Message", nil) delegate:self tag:ALL_DELETE cancelButtonTitle:NSLocalizedString(@"UIAlertView_Cancel_String", nil)  otherButtonTitles:NSLocalizedString(@"UIAlertView_Confirm_String", nil),nil];
    [alert showInViewController:self];
    [alert release];
}



#pragma mark AlertControllerDelegate method
- (void)alertController:(AlertController *)alertController didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (alertController.tag == SELECT_DELETE) {
        NSLog(@"删除所选条目");
        if (buttonIndex == alertController.firstOtherButtonIndex) {
            isEditing = NO;
            for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
                if (item.tag == SELECT_DELETE) {
                    item.title = @"编辑";
                }
            }
            [messageTableView setEditing:NO animated:YES];
            if ([self.deleteDic allKeys].count > 0) {
                if ([self synchronizeDeleteSelectMessages:[deleteDic allValues]]) {
                    [messageTableView setEditing:NO animated:YES];
                    [messageTableView beginUpdates];
                    
                    if (self.mSelectedIndex == 0 && self.messagesArray.count == 0) {
                        self.navigationItem.rightBarButtonItems = nil;
                        [messageTableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
                    } else {
                        [messageTableView deleteRowsAtIndexPaths:[NSArray arrayWithArray:[self.deleteDic allKeys]] withRowAnimation:UITableViewRowAnimationTop];
                    }
                    
                    [messageTableView endUpdates];
                    [self.deleteDic removeAllObjects];
                    
                }
            }
        }
    }else if (alertController.tag == ALL_DELETE) {
        if (buttonIndex == alertController.firstOtherButtonIndex) {
            //确认删除
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i < [self.messagesArray count]; i++) {
                // 保存所删除cell的indexpath，用于删除动画
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [array addObject:indexPath];
            }
            if (self.mSelectedIndex != 0) {
                
                if ([self synchronizeDeleteSelectMessages:self.messagesArray]) {
                    [messageTableView setEditing:NO animated:YES];
                    [messageTableView beginUpdates];
                    [messageTableView deleteRowsAtIndexPaths:[NSArray arrayWithArray:array] withRowAnimation:UITableViewRowAnimationTop];
                    [messageTableView endUpdates];
                    
                }
                return;
            }
            if ([self synchronizeDeleteAllMessages]) {
                [messageTableView setEditing:NO animated:YES];
                self.navigationItem.rightBarButtonItems = nil;
                [messageTableView beginUpdates];
                [messageTableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
                
                [messageTableView endUpdates];
            }
        }

    }
}

#pragma mark delete message
// 删除一条
- (BOOL)synchronizeDeleteMessage:(MessageItem *)message {
    BOOL deleteResust = [[Messages sharedMessages] removeItem:message];
    if (deleteResust) {
        [self.messagesArray removeObject:message];
    }
    return deleteResust;
}

// 删除全部
- (BOOL)synchronizeDeleteAllMessages {
    BOOL deleteResult = [[Messages sharedMessages] removeAllMessages];
    if (deleteResult) {
        [messagesArray removeAllObjects];
    }
    
    return deleteResult;
}

// 删除所选部分
- (BOOL)synchronizeDeleteSelectMessages:(NSArray *)messages {
    if ([messages count] == 0) {
        return NO;
    }
    BOOL deleteResult = [[Messages sharedMessages] removeItems:messages];
    if (deleteResult) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:messages];
        for (MessageItem *item in array) {
            [self.messagesArray removeObject:item];
            
        }
    }
    return deleteResult;
}

/*
#pragma mark calculate cell height
- (void)layoutMessageCellSubviews:(MessageCell *)cell messageData:(MessageModel *)messageData showSeperateLine:(BOOL)show {
    if (!messageData || !cell) {
        return;
    }
    cell.messageModel = messageData;
    
    //category label
    BOOL haveRead = messageData.haveRead;
    if (haveRead) {
        cell.messageCategoryLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    } else {
        cell.messageCategoryLabel.textColor = [RTSSAppStyle currentAppStyle].messageNeverReadTextColor;
    }
    cell.messageCategoryLabel.text = messageData.messageCategory;
    
    //date label
    cell.messageDateLabel.text = [DateUtils getStringDateByDate:[NSDate dateWithTimeIntervalSince1970:messageData.messageTimestamp]];
    
    //content label
    cell.messageContentLabel.text = messageData.messageContent;
    CGFloat availableWidth = cell.cellAvailableSize.width - VIEW_PADDING_LEFT_X - VIEW_PADDING_RIGHT_X - ARROW_IMAGE_WIDTH + 5.f;
    CGSize textSize = CGSizeZero;
    textSize = [CommonUtils calculateTextSize:messageData.messageContent constrainedSize:CGSizeMake(CGFLOAT_MAX, CONTENT_LABEL_SINGLE_HEIGHT) textFont:[UIFont systemFontOfSize:12.0] lineBreakMode:NSLineBreakByWordWrapping];
    CGRect textFrame = cell.messageContentLabel.frame;
    if (textSize.width > availableWidth) {
        textFrame.size.height = CONTENT_LABEL_DOUBLE_HEIGHT;
        cell.messageContentLabel.frame = textFrame;
    } else {
        textFrame.size.height = CONTENT_LABEL_SINGLE_HEIGHT;
        cell.messageContentLabel.frame = textFrame;
    }
    
    //seperate
    cell.seperatorLineImageView.hidden = show ? NO : YES;
}
*/





#pragma mark button clicked
- (void)editMessage:(UIBarButtonItem *)enitItem
{
    isEditing = !isEditing;
    if (isEditing) {
        enitItem.title = @"取消";
        [messageTableView setEditing:YES animated:YES];

    }else {
        enitItem.title = @"编辑";
        [self.deleteDic removeAllObjects];
        [messageTableView setEditing:NO animated:YES];

    }
}
                                       

                                       



#pragma mark dealloc
- (void)dealloc {
    [deleteDic release];
    [messagesArray release];
    [messageTableView release];
    [_mSingPicker release];
    [pickerArrayData release];
    [super dealloc];
}

#pragma mark others
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
