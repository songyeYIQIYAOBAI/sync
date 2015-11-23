//
//  TransactionHistoryViewController.m
//  RTSS
//
//  Created by dongjf on 14/10/23.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "TransactionHistoryViewController.h"
#import "TransferHistoryCell.h"
#import "EventItem.h"
#import "Events.h"
#import "User.h"
#import "Session.h"
#import "Cache.h"
#import "DateUtils.h"

#define TABLE_SECTION_HEADER_HEIGHT 20.f

@interface TransactionHistoryViewController () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate> {
    UITableView *historyTableView;
    BOOL needRefresh;
}

@property (nonatomic,retain) NSMutableArray *eventItemsArray;

@end

@implementation TransactionHistoryViewController

@synthesize currentUser;
@synthesize eventItemsArray;

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

#pragma mark init view
- (void)loadView {
    [super loadView];
    [self initViews];
}

- (void)initViews {
    //history table
    CGRect contentRect = CGRectMake(0.f, 0.f, PHONE_UISCREEN_WIDTH, PHONE_UISCREEN_HEIGHT - 64.f);
    historyTableView = [[UITableView alloc] initWithFrame:contentRect style:UITableViewStylePlain];
    historyTableView.backgroundColor = [UIColor clearColor];
    historyTableView.allowsSelection = NO;
    historyTableView.showsHorizontalScrollIndicator = NO;
    historyTableView.showsVerticalScrollIndicator = NO;
    historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    historyTableView.delegate = self;
    historyTableView.dataSource = self;
    [self.view addSubview:historyTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    needRefresh = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    needRefresh = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.title = currentUser.mUserName;   //mUserName属性已废除
    [self reloadViews];
}

- (void)reloadViews {
    if ([CommonUtils objectIsValid:eventItemsArray]) {
        [historyTableView reloadData];
        NSDictionary *dict = [eventItemsArray lastObject];
        if ([CommonUtils objectIsValid:dict]) {
            NSArray *events = [[dict allValues] objectAtIndex:0];
            if ([CommonUtils objectIsValid:events]) {
                NSIndexPath *index = [NSIndexPath indexPathForRow:[events count] - 1 inSection:[eventItemsArray count] - 1];
                [historyTableView scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            }
        }
    }
}

#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [eventItemsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[[eventItemsArray objectAtIndex:section] allValues] objectAtIndex:0] count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return TABLE_SECTION_HEADER_HEIGHT;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventItem *item = [self getEventItemAtIndexPath:indexPath];
    CGFloat cellHeight = [TransferHistoryCell calculateCellHeightByHistoryData:item availableSize:CGSizeMake(CGRectGetWidth(historyTableView.frame), CELL_DEFAULT_HEIGHT)];
    return cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, PHONE_UISCREEN_WIDTH, TABLE_SECTION_HEADER_HEIGHT)];
    headerView.backgroundColor = [UIColor clearColor];
    //date
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 200.f, TABLE_SECTION_HEADER_HEIGHT)];
    dateLabel.center = headerView.center;
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.font = [UIFont systemFontOfSize:14.f];
    dateLabel.textColor = [[RTSSAppStyle currentAppStyle] textSubordinateColor];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.text = [self getEventItemsTitleAtSection:section];
    [headerView addSubview:dateLabel];
    [dateLabel release];
    return [headerView autorelease];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"transferHistoryCell";
    TransferHistoryCell *historyCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (historyCell == nil) {
        historyCell = [[[TransferHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier availableSize:CGSizeMake(CGRectGetWidth(historyTableView.frame), CELL_DEFAULT_HEIGHT)] autorelease];
    }
    EventItem *item = [self getEventItemAtIndexPath:indexPath];
    [self layoutTransferHistoryCell:historyCell transferData:item];
    historyCell.backgroundColor = [UIColor clearColor];
    return historyCell;
}

- (EventItem *)getEventItemAtIndexPath:(NSIndexPath *)indexPath {
    EventItem *item = nil;
    NSDictionary *itemDict = [eventItemsArray objectAtIndex:indexPath.section];
    if ([CommonUtils objectIsValid:itemDict]) {
        NSArray *itemsArr = [[itemDict allValues] objectAtIndex:0];
        if ([CommonUtils objectIsValid:itemsArr]) {
            item = [itemsArr objectAtIndex:indexPath.row];
        }
    }
    return item;
}

- (NSString *)getEventItemsTitleAtSection:(NSInteger)section {
    NSString *eventDate = nil;
    NSDictionary *itemDict = [eventItemsArray objectAtIndex:section];
    if ([CommonUtils objectIsValid:itemDict]) {
        eventDate = [[itemDict allKeys] objectAtIndex:0];
    }
    return eventDate;
}

- (void)layoutTransferHistoryCell:(TransferHistoryCell *)historyCell transferData:(EventItem *)transactionData {
    if (transactionData == nil) {
        return;
    }
    //dircetion
    TransferDirection direction;
    if (transactionData.mType == EventTypeBalanceTransferOut) {
        direction = TransferDirectionFromMe;
    } else if (transactionData.mType == EventTypeBalanceTransferIn) {
        direction = TransferDirectionFromOther;
    }
    
    NSString *desBg = nil;
    CGRect desFrame = CGRectZero;
    CGRect iconFrame = CGRectZero;
    CGFloat desWidth = historyCell.availableSize.width - VIEW_PADDING_X_MIN - VIEW_PADDING_X_MAX - USER_ICON_WIDTH - VIEW_SPACING_X_ICON;
    NSString *userIconSrc = nil;
    switch (direction) {
        case TransferDirectionFromMe:
        {
            //des
            desBg = @"friends_transaction_from_me";
            desFrame = CGRectMake(VIEW_PADDING_X_MAX, VIEW_PADDING_Y_TOP, desWidth, DES_DEFAULT_HEIGHT);
             historyCell.transferDesImageView.frame = desFrame;
             historyCell.transferDesImageView.image = [UIImage imageNamed:desBg];
            
            //icon
            iconFrame = CGRectMake(CGRectGetMaxX(desFrame) + VIEW_SPACING_X_ICON, VIEW_PADDING_Y_TOP, USER_ICON_WIDTH, USER_ICON_HEIGHT);
            historyCell.transferUserIcon.frame = iconFrame;
            Session *session = [Session sharedSession];
            User *mUser = session.mMyUser;
            if (mUser) {
                userIconSrc = mUser.mPortrait;
            }
        }
            break;
        case TransferDirectionFromOther:
        {
            //des
            desBg = @"friends_transaction_from_other";
            desFrame = CGRectMake(VIEW_PADDING_X_MIN + USER_ICON_WIDTH + VIEW_SPACING_X_ICON, VIEW_PADDING_Y_TOP, desWidth, DES_DEFAULT_HEIGHT);
            historyCell.transferDesImageView.frame = desFrame;
            historyCell.transferDesImageView.image = [UIImage imageNamed:desBg];
            
            //icon
            iconFrame = CGRectMake(VIEW_PADDING_X_MIN, VIEW_PADDING_Y_TOP, USER_ICON_WIDTH, USER_ICON_HEIGHT);
            historyCell.transferUserIcon.frame = iconFrame;
            if (currentUser) {
                userIconSrc = currentUser.mPortrait;
            }
        }
            break;
        default:
            break;
    }
    //transferUserIcon
    historyCell.transferUserIcon.portraitImage = [[Cache standardCache] getSmallPortraitImageWithUrl:userIconSrc completion:^ (UIImage *image) {
        if (needRefresh) {
            historyCell.transferUserIcon.portraitImage = image;
        }
    }];
    
    //des content
    CGFloat viewSpaceXL = [historyCell getViewSpacingX:ViewSpaceXLeft direction:direction];
    CGFloat viewSpaceXR = [historyCell getViewSpacingX:ViewSpaceXRight direction:direction];
    
    NSDictionary *parameters = transactionData.mParameters;
    
    //price label
    long long amount = 0;
    if ([CommonUtils objectIsValid:parameters]) {
        //<<<<<amount = [(NSNumber *)[parameters objectForKey:SERVICE_AMOUNT_KEY] longLongValue];
    }
    NSString *price = [NSString stringWithFormat:@"%@%.2f",NSLocalizedString(@"Currency_Unit", nil),[CommonUtils formatMoneyFromPennyToYuan:amount]];
    CGSize priceSize = [CommonUtils calculateTextSize:price constrainedSize:CGSizeMake(CGFLOAT_MAX, PRICE_LABEL_HEIGHT) textFont:[UIFont boldSystemFontOfSize:PRICE_LABEL_FONT_SIZE] lineBreakMode:NSLineBreakByWordWrapping];
    if (priceSize.width > PRICE_LABEL_MAX_WIDTH) {
        priceSize.width = PRICE_LABEL_MAX_WIDTH;
    }
    CGRect priceFrame = CGRectMake(viewSpaceXL, VIEW_PADDING_Y_TOP_IN_DES, priceSize.width, PRICE_LABEL_HEIGHT);
    historyCell.priceLabel.frame = priceFrame;
    historyCell.priceLabel.text = price;
    
    //from label
    NSString *from = NSLocalizedString(@"Transaction_History_From", nil);
    CGSize fromSize = [CommonUtils calculateTextSize:from constrainedSize:CGSizeMake(FROM_TO_LABEL_WIDTH, CGFLOAT_MAX) textFontSize:TEXT_DEFAULT_FONG_SIZE lineBreakMode:NSLineBreakByCharWrapping];
    CGRect fromFrame = CGRectMake(CGRectGetMaxX(historyCell.priceLabel.frame) + VIEW_SPACING_X_PRICE, VIEW_PADDING_Y_TOP_IN_DES, FROM_TO_LABEL_WIDTH, fromSize.height);
    historyCell.fromLabel.frame = fromFrame;
    historyCell.fromLabel.text = from;
    
    CGFloat fromToDesAvaiWidth = CGRectGetWidth(historyCell.transferDesImageView.frame) - CGRectGetMaxX(historyCell.fromLabel.frame) - VIEW_SPACING_X_FROM_TO - viewSpaceXR;
    
    //from descritp
    NSString *fromDes = nil;
    if ([CommonUtils objectIsValid:parameters]) {
        //<<<<<<<<<<<<
        /*
        if (direction == TransferDirectionFromMe) {
            fromDes = [NSString stringWithFormat:@"%@.%@",[[[RTSSAppStyle currentAppStyle] getServiceSourceWithServiceType:[parameters objectForKey:SERVICE_TYPE_KEY]] objectForKey:SERVICE_NAME_KEY],[parameters objectForKey:SERVICE_ID_KEY]];
        } else {
            fromDes = [NSString stringWithFormat:@"%@.%@",[[[RTSSAppStyle currentAppStyle] getServiceSourceWithServiceType:[parameters objectForKey:SERVICE_TYPE_SOURCE_KEY]] objectForKey:SERVICE_NAME_KEY],[parameters objectForKey:SERVICE_ID_SOURCE_KEY]];
        }
         */
    }
    CGSize fromDesSize = [CommonUtils calculateTextSize:fromDes constrainedSize:CGSizeMake(fromToDesAvaiWidth, CGFLOAT_MAX) textFontSize:TEXT_DEFAULT_FONG_SIZE lineBreakMode:NSLineBreakByCharWrapping];
    if (fromDesSize.height <= 0.) {
        fromDesSize.height = FROM_TO_LABEL_HEIGHT;
    }
    CGRect fromDesFrame = CGRectMake(CGRectGetMaxX(historyCell.fromLabel.frame) + VIEW_SPACING_X_FROM_TO,   CGRectGetMinY(historyCell.fromLabel.frame), fromToDesAvaiWidth, fromDesSize.height);
    historyCell.fromDescriptLabel.frame = fromDesFrame;
    historyCell.fromDescriptLabel.text = fromDes;
    
    //to label
    NSString *to = NSLocalizedString(@"Transaction_History_To", nil);
    CGSize toSize = [CommonUtils calculateTextSize:to constrainedSize:CGSizeMake(FROM_TO_LABEL_WIDTH, CGFLOAT_MAX) textFontSize:TEXT_DEFAULT_FONG_SIZE lineBreakMode:NSLineBreakByCharWrapping];
    CGRect toFrame = CGRectMake(CGRectGetMinX(historyCell.fromLabel.frame), CGRectGetMaxY(historyCell.fromDescriptLabel.frame) + VIEW_SPACING_Y_IN_DES, FROM_TO_LABEL_WIDTH, toSize.height);
    historyCell.toLabel.frame = toFrame;
    historyCell.toLabel.text = to;
    
    //to descript
    NSString *toDes = nil;
    if ([CommonUtils objectIsValid:parameters]) {
        //<<<<<<<<<
        /*
        if (direction == TransferDirectionFromMe) {
            toDes = [parameters objectForKey:SERVICE_TARGET_ID_KEY];
        } else {
            toDes = [parameters objectForKey:SERVICE_ID_KEY];
        }
         */
    }
    CGSize toDesSize = [CommonUtils calculateTextSize:toDes constrainedSize:CGSizeMake(fromToDesAvaiWidth, CGFLOAT_MAX) textFontSize:TEXT_DEFAULT_FONG_SIZE lineBreakMode:NSLineBreakByCharWrapping];
    if (toDesSize.height <= 0.) {
        toDesSize.height = FROM_TO_LABEL_HEIGHT;
    }
    CGRect toDesFrame = CGRectMake(CGRectGetMaxX(historyCell.toLabel.frame) + VIEW_SPACING_X_FROM_TO, CGRectGetMinY(historyCell.toLabel.frame), fromToDesAvaiWidth,toDesSize.height);
    historyCell.toDescriptLabel.frame = toDesFrame;
    historyCell.toDescriptLabel.text = toDes;
    
    //reset price label size
    CGFloat fromToHeight = CGRectGetHeight(historyCell.fromDescriptLabel.frame) + VIEW_SPACING_Y_IN_DES + CGRectGetHeight(historyCell.toDescriptLabel.frame);
    priceFrame.size.height = fromToHeight;
    historyCell.priceLabel.frame = priceFrame;
    
    //reset des bg size
    historyCell.transferDesImageView.image = [[UIImage imageNamed:desBg] resizableImageWithCapInsets:UIEdgeInsetsMake(40, 20.f, 10.f, 30.f)];
    CGFloat desContentHeight = CGRectGetMaxY(historyCell.toDescriptLabel.frame) + VIEW_PADDING_Y_BOTTOM_IN_DES;
    CGRect frame = historyCell.transferDesImageView.frame;
    frame.size.height = desContentHeight;
    historyCell.transferDesImageView.frame = frame;
}

#pragma mark scrollview delegate method
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= TABLE_SECTION_HEADER_HEIGHT) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0.f, 0.f, 0.f);
    } else if (scrollView.contentOffset.y >= TABLE_SECTION_HEADER_HEIGHT) {
        scrollView.contentInset = UIEdgeInsetsMake(-TABLE_SECTION_HEADER_HEIGHT, 0.f, 0.f, 0.f);
    }
}

#pragma mark data
- (void)loadData {
    Events *eventsManager = [Events sharedEvents];
    NSDictionary *eventData = [eventsManager events:@[[NSNumber numberWithInteger:EventTypeBalanceTransferIn],[NSNumber numberWithInteger:EventTypeBalanceTransferOut]] about:nil]; //currentUser.mPhoneNumber：User中的mPhoneNumber调整到Custormer中
//    //temp test
//    NSDictionary *eventData = [eventsManager events:@[[NSNumber numberWithInteger:EventTypeBalanceTransferIn],[NSNumber numberWithInteger:EventTypeBalanceTransferOut]] about:@"peerServiceId"];

    if ([CommonUtils objectIsValid:eventData]) {
        NSArray *itemsDateArray = [eventData objectForKey:EVENT_INFO_KEY];
        NSDictionary *itemsDict = [eventData objectForKey:EVENT_DATA_KEY];
        if ([CommonUtils objectIsValid:itemsDateArray] && [CommonUtils objectIsValid:itemsDict]) {
            if (!eventItemsArray) {
                eventItemsArray = [[NSMutableArray alloc] initWithCapacity:0];
            } else {
                [eventItemsArray removeAllObjects];
            }
            NSString *dateFormat = @"yyyyMMdd";
            for (int i = 0; i < [itemsDateArray count]; i ++) {
                NSNumber *date = [itemsDateArray objectAtIndex:i];
                if (date) {
                    long long ts = [date longLongValue];
                    NSString *tempDateStr = [DateUtils getStringDateByDate:[NSDate dateWithTimeIntervalSince1970:ts] dateFormat:dateFormat];
                    NSString *realKeyStr = [DateUtils getStringDateByDate:[NSDate dateWithTimeIntervalSince1970:ts] dateFormat:@"dd/MM/yyyy"];
                    NSArray *items = [itemsDict objectForKey:tempDateStr];
                    if ([CommonUtils objectIsValid:items]) {
                        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:items,realKeyStr, nil];
                        [eventItemsArray addObject:dict];
                        [dict release];
                    }
                }
            }
        }
    }
}

#pragma mark dealloc
- (void)dealloc {
    [historyTableView release];
    [currentUser release];
    [eventItemsArray release];
    eventItemsArray = nil;
    [super dealloc];
}

#pragma mark other
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
