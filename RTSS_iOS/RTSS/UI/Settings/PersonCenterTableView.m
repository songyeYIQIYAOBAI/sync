//
//  PersonCenterTableView.m
//  RTSS
//
//  Created by 宋野 on 14-11-6.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "PersonCenterTableView.h"

#import "CommonUtils.h"
#import "UserDefaults.h"
#import "FileUtils.h"
#import "RTSSAppStyle.h"
#import "RTSSAppDefine.h"
#import "Cache.h"

#define TABLEVIEW_HEADVIEW_HEIGHT           25.0
#define TABLEVIEW_FOOTVIEW_HEIGHT           0.1
#define TABLEVIEW_PHOTO_CELL_HEIGHT         70.0
#define TABLEVIEW_DEFAULT_CELL_HEIGHT       50.0

@implementation PersonCenterTableView

@synthesize myTableView,sectionArray,rowArray;

-(void)dealloc{
    
    [myTableView release];
    [sectionArray release];
    [rowArray release];
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        [self layoutTableView];
    }
    
    return self;
}

- (void)layoutTableView{
    myTableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStyleGrouped];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.showsHorizontalScrollIndicator = NO;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self addSubview:myTableView];
    
    //tableFootView
    PersonCenterTableFootView * personCenterTableFootView = [[PersonCenterTableFootView alloc] initWithFrame:CGRectMake(0, 0, myTableView.bounds.size.width, 90)];
    personCenterTableFootView.backgroundColor = [UIColor clearColor];
    myTableView.tableFooterView = personCenterTableFootView;
    [personCenterTableFootView release];
}

- (void)reloadTableViewSection:(NSMutableArray *)sections row:(NSMutableArray *)rows{
    self.sectionArray = sections;
    self.rowArray = rows;
    
    [myTableView reloadData];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonCenterItemModel * itemModel = [[self.rowArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    if (itemModel.itemType == PersonCenterTableViewCellTypePhoto) {
        return TABLEVIEW_PHOTO_CELL_HEIGHT;
    }
    
    return TABLEVIEW_DEFAULT_CELL_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.rowArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"PersonCenterCellIdentifier";
    
    PersonCenterTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [[[PersonCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.clipsToBounds = YES;
    }
    
    if (indexPath.section == 0 && (indexPath.row == 1 || indexPath.row == 2)){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = NO;
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.userInteractionEnabled = YES;
    }
    
    cell.frame = (indexPath.section == 0 && indexPath.row == 0)?CGRectMake(0, 0, tableView.frame.size.width, TABLEVIEW_PHOTO_CELL_HEIGHT):CGRectMake(0, 0, tableView.frame.size.width, TABLEVIEW_DEFAULT_CELL_HEIGHT);
    [cell changeSubviewsFrame:cell.frame];
    
    PersonCenterItemModel * itemModel = [[self.rowArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [self setModel:itemModel withCell:cell];
    
    return cell;
}

- (void)setModel:(PersonCenterItemModel *)itemModel withCell:(PersonCenterTableViewCell *)cell{
    
    cell.itemHeadImage.hidden = YES;
    cell.itemRightArrow.hidden = NO;
    cell.itemTextLabel.hidden = NO;
    //头像
    if (itemModel.itemType == PersonCenterTableViewCellTypePhoto) {
        cell.itemHeadImage.hidden = NO;
        cell.itemRightArrow.hidden = NO;
        cell.itemTextLabel.hidden = YES;
        cell.itemHeadImage.portraitImage = [[Cache standardCache] getSmallPortraitImageWithUrl:itemModel.itemHeadImage completion:^(UIImage *image) {
            cell.itemHeadImage.portraitImage = image;
        }];
        [cell.itemHeadImage.actionButton addTarget:self action:@selector(changeHeadImage:) forControlEvents:UIControlEventTouchUpInside];
    }else if(itemModel.itemType == PersonCenterTableViewCellTypePhoneNumber || itemModel.itemType == PersonCenterTableViewCellTypeName){
    //电话和名字
        cell.itemRightArrow.hidden = YES;
        [cell changeFrameIfDoNotHaveRightArrow];
    }
    
    //
    cell.itemExplanationLabel.text = itemModel.itemExplanation;
    cell.itemLeftImage.image = [UIImage imageNamed:itemModel.itemLeftImage];
    cell.itemTextLabel.text = itemModel.itemText;
    cell.tag = itemModel.itemType;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return TABLEVIEW_HEADVIEW_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return TABLEVIEW_FOOTVIEW_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //tableHeadView
    UIView * tableHeadView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, TABLEVIEW_HEADVIEW_HEIGHT)] autorelease];
    tableHeadView.backgroundColor = [UIColor clearColor];
    
    //tableHeadView线
    UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, tableHeadView.frame.size.height-0.5, self.frame.size.width, 0.5)];
    line.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    [tableHeadView addSubview:line];
    [line release];
    
    return tableHeadView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(PersonCenterTablewDidSelectRowAtIndexPath: indexTag:)]) {
        PersonCenterItemModel * itemModel = [[self.rowArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [self.delegate PersonCenterTablewDidSelectRowAtIndexPath:indexPath indexTag:itemModel.itemType];
    }
}

#pragma - HeadImageAction
- (void)changeHeadImage:(UIButton *)button{
    //点击头像事件
    if (self.delegate && [self.delegate respondsToSelector:@selector(PersonCenterTablewClickHeadImageButton:)]) {
        [self.delegate PersonCenterTablewClickHeadImageButton:button];
    }
}

@end

#define LOGOUTBTN_LEFT_INTERVAL                 20.0
#define LOGOUTBTN_HEIGHT                        45.0

@implementation PersonCenterTableFootView
@synthesize logOutBtn;

-(void)dealloc{
    [logOutBtn release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initViews];
    }
    
    return self;
}

- (void)initViews{
    CGRect logOutFrame = CGRectMake(LOGOUTBTN_LEFT_INTERVAL, (self.bounds.size.height - LOGOUTBTN_HEIGHT)/2.0, self.bounds.size.width-2*LOGOUTBTN_LEFT_INTERVAL, LOGOUTBTN_HEIGHT);
    self.logOutBtn = [RTSSAppStyle getMajorGreenButton:logOutFrame target:nil action:nil title:NSLocalizedString(@"PersonCenterView_Logout_Button", nil)];
    [self addSubview:self.logOutBtn];
}

@end


#define LEFT_IMAGE_WIDTH            50.0
#define LEFT_LABEL_WIDTH            130.0
#define RIGHT_ARROW                 10.0
#define RIGHT_LABEL_WIDTH           (PHONE_UISCREEN_IPHONE6 ? 200 : 150)
#define HEADIMAGE_ROW_HEIGHT        70.0
#define HEADIMAGE_WIDTH             50.0

@implementation PersonCenterTableViewCell
@synthesize itemExplanationLabel,itemHeadImage,itemLeftImage,itemTextLabel,itemRightArrow,lineImage, selectedLineImage;


-(void)dealloc{
    [itemLeftImage release];
    [itemExplanationLabel release];
    [itemTextLabel release];
    [itemRightArrow release];
    [itemHeadImage release];
    [lineImage release];
    [selectedLineImage release];
    
    [super dealloc];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [RTSSAppStyle currentAppStyle].cellUnSelectedColor;
        [self initViews];
    }
    
    return self;
}

- (void)initViews{
        
    //左边图片
    UIImageView* leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, LEFT_IMAGE_WIDTH, self.frame.size.height)];
    leftImage.backgroundColor = [UIColor clearColor];
    leftImage.contentMode = UIViewContentModeCenter;
    self.itemLeftImage = leftImage;
    [self addSubview:leftImage];
    [leftImage release];
    
    //左边文字说明
    UILabel* explanationLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.itemLeftImage.frame.origin.x+self.itemLeftImage.frame.size.width, 0, LEFT_LABEL_WIDTH, self.frame.size.height)];
    explanationLabel.backgroundColor = [UIColor clearColor];
    explanationLabel.font = [RTSSAppStyle getRTSSFontWithSize:15];
    explanationLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    explanationLabel.textAlignment = NSTextAlignmentLeft;
    explanationLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.itemExplanationLabel = explanationLabel;
    [self addSubview:explanationLabel];
    [explanationLabel release];

    //右边箭头
    UIImageView* rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-RIGHT_ARROW-10, 0, RIGHT_ARROW, self.frame.size.height)];
    rightArrow.image = [UIImage imageNamed:@"common_next_arrow2"];
    rightArrow.backgroundColor = [UIColor clearColor];
    rightArrow.contentMode = UIViewContentModeCenter;
    self.itemRightArrow = rightArrow;
    [self addSubview:rightArrow];
    [rightArrow release];
    
    //添加右边文字label
    UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.itemRightArrow.frame.origin.x - RIGHT_LABEL_WIDTH - 20, 0, RIGHT_LABEL_WIDTH, self.frame.size.height)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = [RTSSAppStyle getRTSSFontWithSize:14];
    textLabel.numberOfLines = 2;
    textLabel.textAlignment = NSTextAlignmentRight;
    textLabel.textColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
    self.itemTextLabel = textLabel;
    [self addSubview:textLabel];
    [textLabel release];
    
    //添加头像ImageView
    CGFloat x = self.itemRightArrow.frame.origin.x - 10 - HEADIMAGE_WIDTH;
    CGFloat y = 10;
    PortraitImageView* headImage = [[PortraitImageView alloc] initWithFrame:CGRectMake(x, y, HEADIMAGE_WIDTH, HEADIMAGE_WIDTH) image:nil borderColor:[RTSSAppStyle currentAppStyle].portraitBorderColor borderWidth:1.0];
    headImage.userInteractionEnabled = NO;
    self.itemHeadImage = headImage;
    [self addSubview:headImage];
    [headImage release];

    //添加下面的线
    UIImageView* line = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
    line.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    self.lineImage = line;
    [self addSubview:line];
    [line release];
    
    //Cell的selectBackgroundView
    UIView* selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    selectedBackgroundView.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    self.selectedBackgroundView = selectedBackgroundView;
    [selectedBackgroundView release];
    
    UIImageView* line_a = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 0.5, self.bounds.size.width, 0.5)];
    line_a.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
    self.selectedLineImage = line_a;
    [self.selectedBackgroundView addSubview:self.selectedLineImage];
    [line_a release];
}

- (void)changeSubviewsFrame:(CGRect)rect{
    self.itemLeftImage.frame = CGRectMake(0, 0, LEFT_IMAGE_WIDTH, rect.size.height);
    self.itemExplanationLabel.frame = CGRectMake(self.itemLeftImage.frame.origin.x+self.itemLeftImage.frame.size.width, 0, LEFT_LABEL_WIDTH, rect.size.height);
    self.itemRightArrow.frame = CGRectMake(self.frame.size.width-RIGHT_ARROW-10, 0, RIGHT_ARROW, rect.size.height);
    self.itemTextLabel.frame = CGRectMake(self.itemRightArrow.frame.origin.x - RIGHT_LABEL_WIDTH - 10, 0, RIGHT_LABEL_WIDTH, rect.size.height);
    self.itemHeadImage.frame = CGRectMake(self.itemRightArrow.frame.origin.x - 10 - HEADIMAGE_WIDTH, self.itemHeadImage.frame.origin.y, HEADIMAGE_WIDTH, HEADIMAGE_WIDTH);
     self.lineImage.frame = CGRectMake(0, rect.size.height - 0.5, rect.size.width, 0.5);
    self.selectedLineImage.frame = CGRectMake(0, rect.size.height - 0.5, rect.size.width, 0.5);
}

- (void)changeFrameIfDoNotHaveRightArrow{
    self.itemTextLabel.frame = CGRectMake(self.itemRightArrow.frame.origin.x+self.itemRightArrow.frame.size.width-self.itemTextLabel.frame.size.width, self.itemTextLabel.frame.origin.y, self.itemTextLabel.frame.size.width, self.itemTextLabel.frame.size.height);
    self.itemRightArrow.hidden = YES;
}

@end

@implementation PersonCenterItemModel
@synthesize itemExplanation,itemText,itemType,itemHeadImage,itemLeftImage;

-(void)dealloc{
    [itemExplanation release];
    [itemHeadImage release];
    [itemLeftImage release];
    [itemText release];
    
    [super dealloc];
}


- (instancetype)init{
    self = [super init];
    
    if (self) {
        self.itemExplanation = nil;
        self.itemText = nil;
        self.itemHeadImage = nil;
        self.itemLeftImage = @"";
        self.itemType = -1;
        self.itemIndexTag = -1;
    }
    return self;
}

@end
