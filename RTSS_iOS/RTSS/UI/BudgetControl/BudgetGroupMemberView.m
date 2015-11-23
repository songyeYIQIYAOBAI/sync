//
//  BudgetGroupMemberView.m
//  RTSS
//
//  Created by 加富董 on 15/1/27.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "BudgetGroupMemberView.h"
#import "CommonUtils.h"
#import "PortraitImageView.h"
#import "RTSSAppStyle.h"
#import "Cache.h"
#import "Subscriber.h"

#define MEMBER_VIEW_PADDING_X 20.0
#define MEMBER_VIEW_PADDING_Y 18.0
#define MEMBER_VIEW_SPACE_Y 8

#define MEMBER_CELL_WIDTH 55.0
#define MEMBER_CELL_HEIGHT 75.0
#define MEMBER_CELL_SPACE_Y 5.0
#define MEMBER_DELETE_WIDTH 30.0
#define MEMBER_DELETE_HEIGHT 30.0
#define MEMBER_PORTRAIT_WIDTH 52.0
#define MEMBER_PORTRAIT_HEIGHT 52.0
#define MEMBER_NAME_FONT_SIZE 14.0
#define MEMBER_NAME_HEIGHT 16.0

typedef NS_ENUM(NSInteger, MemberCellType) {
    MemberCellTypeNormal = 1,
    MemberCellTypeAdd,
    MemberCellTypeDelete,
};

@interface MemberCellView () {
    
}

@property (nonatomic, retain) UIButton *deleteButton;
@property (nonatomic, retain) PortraitImageView *portraitImageView;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, assign) NSInteger viewIndex;
@property (nonatomic, assign) MemberCellType cellType;

@end

@implementation MemberCellView

@synthesize deleteButton;
@synthesize portraitImageView;
@synthesize nameLabel;
@synthesize viewIndex;
@synthesize cellType;

#pragma mark dealloc
- (void)dealloc {
    [portraitImageView release];
    [super dealloc];
}

#pragma mark init view
- (id)initWithFrame:(CGRect)frame viewIndex:(NSInteger)index {
    if (self = [super initWithFrame:frame]) {
        self.viewIndex = index;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    //portrait
    CGRect portraitRect = CGRectMake((MEMBER_CELL_WIDTH - MEMBER_PORTRAIT_WIDTH) / 2.0, 0.0, MEMBER_PORTRAIT_WIDTH, MEMBER_PORTRAIT_HEIGHT);
    portraitImageView = [[PortraitImageView alloc] initWithFrame:portraitRect image:nil borderColor:[[RTSSAppStyle currentAppStyle] portraitBorderColor] borderWidth:1.0];
    portraitImageView.contentMode = UIViewContentModeCenter;
    portraitImageView.actionButton.tag = viewIndex;
    [self addSubview:portraitImageView];
    
    //delete button
    CGRect deleteRect = CGRectMake(0.0, 0.0, MEMBER_DELETE_WIDTH, MEMBER_DELETE_HEIGHT);
    deleteButton = [CommonUtils buttonWithType:UIButtonTypeCustom frame:deleteRect title:nil imageNormal:nil imageHighlighted:nil imageSelected:nil addTarget:self action:nil tag:viewIndex];
    deleteButton.hidden = YES;
    deleteButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 10.0, 10.0);
    [self addSubview:deleteButton];
    
    //name
    CGRect nameRect = CGRectMake(0.0, CGRectGetMaxY(portraitImageView.frame) + MEMBER_CELL_SPACE_Y, MEMBER_CELL_WIDTH, MEMBER_NAME_HEIGHT);
    nameLabel = [CommonUtils labelWithFrame:nameRect text:nil textColor:[[RTSSAppStyle currentAppStyle] textSubordinateColor] textFont:[UIFont systemFontOfSize:MEMBER_NAME_FONT_SIZE] tag:0];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    nameLabel.numberOfLines = 1;
    [self addSubview:nameLabel];
}

@end

@interface BudgetGroupMemberView () {
    
}

@property (nonatomic, retain) NSMutableArray *membersDataArray;
@property (nonatomic, retain) NSMutableArray *membersFrameArray;
@property (nonatomic, retain) NSMutableArray *membersViewArray;
@property (nonatomic, assign) id <BudgetGroupMemberViewDelegate> delegate;
@property (nonatomic, assign) BOOL canEdit;
@property (nonatomic, assign) NSInteger columnCount;
@property (nonatomic, assign) BOOL isEditing;


@end

@implementation BudgetGroupMemberView

@synthesize delegate;
@synthesize canEdit;
@synthesize membersDataArray;
@synthesize membersFrameArray;
@synthesize membersViewArray;
@synthesize columnCount;
@synthesize isEditing;

#pragma mark dealloc 
- (void)dealloc {
    [membersDataArray release];
    [membersFrameArray release];
    [membersViewArray release];
    [super dealloc];
}

#pragma mark init
- (id)initWithFrame:(CGRect)frame canEdit:(BOOL)edit columnCount:(NSInteger)colCount delegate:(id <BudgetGroupMemberViewDelegate>)del {
    if (self = [super initWithFrame:frame]) {
        self.canEdit = edit;
        self.delegate = del;
        self.columnCount = colCount;
        self.isEditing = NO;
        [self addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark load and initialize
- (CGSize)loadContentWithData:(NSMutableArray *)dataArray {
    CGSize contentSize = CGSizeZero;
    if ([CommonUtils objectIsValid:dataArray]) {
        [self initArrays];
        self.membersDataArray = dataArray;
        contentSize = [self createMembers];
    }
    return contentSize;
}

- (CGSize)createMembers {
    CGFloat viewSpaceX = [self getMemberSpaceX];
    int index = 0;
    for (index = 0; index < [membersDataArray count]; index ++) {
        Subscriber *member = [membersDataArray objectAtIndex:index];
        CGRect viewTempRect = [self calculateCellFrameAtIndex:index cellSpceX:viewSpaceX];
        NSValue *rectValue = [NSValue valueWithCGRect:viewTempRect];
        MemberCellView *memberCell = [[MemberCellView alloc] initWithFrame:viewTempRect viewIndex:index];
        [self initializeMemberCell:memberCell ByData:member type:MemberCellTypeNormal editable:canEdit];
        
        [membersViewArray addObject:memberCell];
        [self addSubview:memberCell];
        [memberCell release];
        
        [membersFrameArray addObject:rectValue];
    }
    
    if (canEdit) {
        CGRect addRect = [self calculateCellFrameAtIndex:index cellSpceX:viewSpaceX];
        NSValue *addRectValue = [NSValue valueWithCGRect:addRect];
        MemberCellView *addCell = [[MemberCellView alloc] initWithFrame:addRect viewIndex:index];
        [self initializeMemberCell:addCell ByData:nil type:MemberCellTypeAdd editable:canEdit];
        
        [membersViewArray addObject:addCell];
        [self addSubview:addCell];
        [addCell release];
        
        [membersFrameArray addObject:addRectValue];

        if ([membersDataArray count] > 1) {
            index += 1;
            CGRect deleteRect = [self calculateCellFrameAtIndex:index cellSpceX:viewSpaceX];
            NSValue *deleteRectValue = [NSValue valueWithCGRect:deleteRect];
            MemberCellView *deleteCell = [[MemberCellView alloc] initWithFrame:deleteRect viewIndex:index];
            [self initializeMemberCell:deleteCell ByData:nil type:MemberCellTypeDelete editable:canEdit];
            
            [membersViewArray addObject:deleteCell];
            [self addSubview:deleteCell];
            [deleteCell release];
            
            [membersFrameArray addObject:deleteRectValue];
        }
    }
    
    //calculate final size
    NSInteger memberCount = [membersDataArray count];
    if (canEdit) {
        memberCount += 1;
        if (memberCount > 1) {
            memberCount += 1;
        }
    }
    CGSize contentSize = [self calculateContentSizeWithMemberViewsCount:memberCount];
    CGRect contentFrame = self.frame;
    contentFrame.size = contentSize;
    self.frame = contentFrame;
    return contentSize;
}

- (void)initializeMemberCell:(MemberCellView *)cell ByData:(Subscriber *)memberData type:(MemberCellType)cellType editable:(BOOL)editable {
    cell.deleteButton.hidden = YES;
    cell.cellType = cellType;
    if (editable) {
        switch (cellType) {
            case MemberCellTypeNormal:
            {
                //delete
                [cell.deleteButton setImage:[UIImage imageNamed:@"budget_group_delete_member_red"] forState:UIControlStateNormal];
                [cell.deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                //portrait
//                cell.portraitImageView.portraitImage = [[Cache standardCache] getSmallPortraitImageWithUrl:memberData.mPortrait placeHolderImageName:@"friends_default_icon" completion:^ (UIImage *image) {
//                    if (image) {
//                        cell.portraitImageView.portraitImage = image;
//                    }
//                }];
                [cell.portraitImageView.actionButton addTarget:self action:@selector(portraitImageViewClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                //name
               // cell.nameLabel.text = memberData.mSubscriberName;
                
            }
                break;
            case MemberCellTypeAdd:
            {
                cell.portraitImageView.image = [UIImage imageNamed:@"budget_group_manage_add"];
                [cell.portraitImageView.actionButton addTarget:self action:@selector(addMembersAction:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
                
            case MemberCellTypeDelete:
            {
                cell.portraitImageView.image = [UIImage imageNamed:@"budget_group_manage_delete"];
                [cell.portraitImageView.actionButton addTarget:self action:@selector(removeMembersAction:) forControlEvents:UIControlEventTouchUpInside];
                cell.portraitImageView.actionButton.selected = NO;
                
            }
                break;
                
            default:
                break;
        }
    } else {
        //portrait
//        cell.portraitImageView.portraitImage = [[Cache standardCache] getSmallPortraitImageWithUrl:memberData.mPortrait placeHolderImageName:@"friends_default_icon" completion:^ (UIImage *image) {
//            if (image) {
//                cell.portraitImageView.image = image;
//            }
//        }];
        [cell.portraitImageView.actionButton addTarget:self action:@selector(portraitImageViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        //name
        //cell.nameLabel.text = memberData.mSubscriberName;
    }
}

- (void)initArrays {
    //frame
    if (!membersFrameArray) {
        membersFrameArray = [[NSMutableArray alloc] initWithCapacity:0];
    } else {
        [membersFrameArray removeAllObjects];
    }
    
    //view
    if (!membersViewArray) {
        membersViewArray = [[NSMutableArray alloc] initWithCapacity:0];
    } else {
        [membersViewArray removeAllObjects];
    }
}

#pragma mark calculate method
- (CGRect)calculateCellFrameAtIndex:(int)index cellSpceX:(CGFloat)viewSpaceX {
    return CGRectMake(MEMBER_VIEW_PADDING_X + (MEMBER_CELL_WIDTH + viewSpaceX) * (index % columnCount), MEMBER_VIEW_PADDING_Y + (MEMBER_CELL_HEIGHT + MEMBER_VIEW_SPACE_Y) * (index / columnCount), MEMBER_CELL_WIDTH, MEMBER_CELL_HEIGHT);
}

- (CGSize)calculateContentSizeWithMemberViewsCount:(NSInteger)memberCount {
    NSInteger rowCount = memberCount % columnCount > 0 ? memberCount / columnCount + 1 : memberCount / columnCount;
    CGFloat viewHeight = MEMBER_VIEW_PADDING_Y * 2 + MEMBER_CELL_HEIGHT * rowCount + MEMBER_CELL_SPACE_Y * (rowCount - 1);
    return CGSizeMake(CGRectGetWidth(self.frame), viewHeight);
}

- (CGFloat)getMemberSpaceX {
    return (CGRectGetWidth(self.frame) - MEMBER_VIEW_PADDING_X * 2 - MEMBER_CELL_WIDTH * columnCount) * 1.0 / (columnCount > 1 ? columnCount - 1 : columnCount);
}

#pragma mark button clicked
- (void)touch:(UIControl *)controlView {
    if (isEditing) {
        isEditing = NO;
        [self changeEditingStatus];
    }
}

- (void)deleteButtonClicked:(UIButton *)deleteButton {
    NSInteger index = deleteButton.tag;
    if (delegate && [delegate respondsToSelector:@selector(budgetGroupMemberView:didDeleteMemberAtIndex:)]) {
        [delegate budgetGroupMemberView:self didDeleteMemberAtIndex:index];
    }
}

- (void)portraitImageViewClicked:(UIButton *)portraitButton {
    NSInteger index = portraitButton.tag;
    if (delegate && [delegate respondsToSelector:@selector(budgetGroupMemberView:didSelectMemberAtIndex:)]) {
        [delegate budgetGroupMemberView:self didSelectMemberAtIndex:index];
    }
}

- (void)addMembersAction:(UIButton *)addButton {
    if (delegate && [delegate respondsToSelector:@selector(budgetGroupMemberViewDidClickedAddButton:)]) {
        [delegate budgetGroupMemberViewDidClickedAddButton:self];
    }
}

- (void)removeMembersAction:(UIButton *)removeButton {
    removeButton.selected = !removeButton.selected;
    isEditing = removeButton.selected;
    [self changeEditingStatus];
    NSLog(@"view===budget remove button clicked %@",removeButton.selected ? @"editing" : @"normal");
}

#pragma mark refresh method
- (void)changeEditingStatus {
    for (int i = 1; i < [membersViewArray count]; i ++) {
        MemberCellView *memberCell = [membersViewArray objectAtIndex:i];
        if (i < [membersViewArray count] - 2) {
            memberCell.deleteButton.hidden = !isEditing;
        } else if (i == [membersViewArray count] - 1){
            if (memberCell.cellType == MemberCellTypeDelete) {
                memberCell.portraitImageView.actionButton.selected = isEditing;
            }
        }
    }
}

#pragma mark edit method
- (CGSize)deleteMembersFromMembersViewAtIndex:(NSInteger)deleteIndex {
    CGSize finalSize = self.frame.size;
    @try {
        if (deleteIndex > 0 && deleteIndex < [membersDataArray count]) {
            //data
            [membersDataArray removeObjectAtIndex:deleteIndex];
            
            //如果data只剩下the owner 需要移除最后一个delete view
            BOOL needRemoveDeleteView = [membersDataArray count] == 1 ? YES : NO;
            
            //frame
            [membersFrameArray removeLastObject];
            
            //view
            MemberCellView *deleteView = [membersViewArray objectAtIndex:deleteIndex];
            [membersViewArray removeObjectAtIndex:deleteIndex];
            [deleteView removeFromSuperview];
            
            //member delete view
            MemberCellView *lastView = [membersViewArray lastObject];
            BOOL isDeleteView = lastView.cellType == MemberCellTypeDelete ? YES : NO;
            if (needRemoveDeleteView && isDeleteView) {
                [lastView removeFromSuperview];
                [membersFrameArray removeLastObject];
                [membersViewArray removeLastObject];
            }
            
            //reset frames and tags
            for (int i = 0; i < [membersViewArray count]; i ++) {
                MemberCellView *memberCell = [membersViewArray objectAtIndex:i];
                NSLog(@"frame former == %@",NSStringFromCGRect(memberCell.frame));
                memberCell.frame = [[membersFrameArray objectAtIndex:i] CGRectValue];
                NSLog(@"frame latter == %@",NSStringFromCGRect(memberCell.frame));
                memberCell.deleteButton.tag = i;
                memberCell.portraitImageView.tag = i;
            }
            
            //reset members view content size
            finalSize = [self calculateContentSizeWithMemberViewsCount:[membersViewArray count]];
            CGRect contentFrame = self.frame;
            contentFrame.size = finalSize;
            self.frame = contentFrame;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"deleteMembersFromMembersViewAtIndex throw exception == %@",exception);
    }
    return finalSize;
}

- (CGSize)addMembersIntoMembersView:(NSMutableArray *)members {
    CGSize finalSize = self.frame.size;
    @try {
        isEditing = NO;
        [self changeEditingStatus];
        
        if ([CommonUtils objectIsValid:members]) {
            //only the owner currently
            BOOL onlyOwner = [membersDataArray count] == 1 ? YES : NO;
            
            //create and insert
            NSInteger offsetIndex = onlyOwner ? 1 : 2;
            NSInteger fromIndex = [membersViewArray count] - offsetIndex;
            CGFloat viewSpaceX = [self getMemberSpaceX];
            int index = fromIndex;
            for (index = fromIndex; index < [members count] + fromIndex; index ++) {
                Subscriber *member = [members objectAtIndex:index - fromIndex];
                if (member) {
                    //insert data
                    [membersDataArray addObject:member];
                    
                    CGRect cellRect = [self calculateCellFrameAtIndex:index cellSpceX:viewSpaceX];
                    NSValue *cellRectValue = [NSValue valueWithCGRect:cellRect];
                    MemberCellView *memberCell = [[MemberCellView alloc] initWithFrame:cellRect viewIndex:index];
                    [self initializeMemberCell:memberCell ByData:member type:MemberCellTypeNormal editable:canEdit];
                    
                    [membersViewArray insertObject:memberCell atIndex:index];
                    [self addSubview:memberCell];
                    [memberCell release];
                    
                    [membersFrameArray insertObject:cellRectValue atIndex:index];
                }
            }
            
            //deal with member add view
            MemberCellView *addView = [membersViewArray objectAtIndex:index];
            if (addView && addView.cellType == MemberCellTypeAdd) {
                //remove former rect
                CGRect addRect = [self calculateCellFrameAtIndex:index cellSpceX:viewSpaceX];
                NSValue *addRectValue = [NSValue valueWithCGRect:addRect];
                addView.frame = addRect;
                
                [membersFrameArray insertObject:addRectValue atIndex:index];
            }
            
            //deal with member delete view
            MemberCellView *lastView = [membersViewArray lastObject];
            index += 1;
            CGRect deleteRect = [self calculateCellFrameAtIndex:index cellSpceX:viewSpaceX];
            NSValue *deleteRectValue = [NSValue valueWithCGRect:deleteRect];
            if (onlyOwner && lastView.cellType == MemberCellTypeAdd) {
                //create member delete view
                MemberCellView *deleteCell = [[MemberCellView alloc] initWithFrame:deleteRect viewIndex:index];
                [self initializeMemberCell:deleteCell ByData:nil type:MemberCellTypeDelete editable:canEdit];
                
                [membersViewArray insertObject:deleteCell atIndex:index];
                [self addSubview:deleteCell];
                [deleteCell release];
            } else {
                lastView.frame = deleteRect;
            }
            [membersFrameArray insertObject:deleteRectValue atIndex:index];
            
            //reset members view content size
            finalSize = [self calculateContentSizeWithMemberViewsCount:[membersViewArray count]];
            CGRect contentFrame = self.frame;
            contentFrame.size = finalSize;
            self.frame = contentFrame;
        }
    }
    @catch (NSException *exception) {
        
    }
    return finalSize;
}

@end
