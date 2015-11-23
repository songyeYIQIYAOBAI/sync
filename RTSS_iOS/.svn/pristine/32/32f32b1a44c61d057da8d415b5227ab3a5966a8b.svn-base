//
//  DNDTableView.m
//  RTSS
//
//  Created by 宋野 on 15-1-30.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "DNDTableView.h"
#import "RTSSAppStyle.h"
#import "RTSSAppDefine.h"
#import "CommonUtils.h"
#import <objc/runtime.h>

#define LEFT_INTERVAL               10.0
#define TOP_INTERVAL                10.0

#define TITLE_LABEL_WIDTH           260.0
#define TITLE_LABEL_HEIGHT          10.0
#define IMAGE_BUTTON_WIDTH          20.0


#pragma mark DNDTableViewCellSubViewCell

@interface DNDTableViewCellSubViewCell (){
    UILabel * titleLabel;
    UIImageView * line;
}

@end
@implementation DNDTableViewCellSubViewCell

- (void)dealloc{
    [line release];
    [super dealloc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 44);
        self.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
        self.showSelected = NO;
        [self initVies];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    if (_title != title) {
        _title = title;
        titleLabel.text = title;
        [self updateFrame];
    }
}

- (void)setShowSelected:(BOOL)showSelected{
    _showSelected = showSelected;
    _button.selected = showSelected;

}


- (void)initVies{
    //title
    CGRect frame = CGRectMake(LEFT_INTERVAL, TOP_INTERVAL, TITLE_LABEL_WIDTH, self.frame.size.height - 2 * TOP_INTERVAL - 2);
    titleLabel = [CommonUtils labelWithFrame:frame text:@"" textColor:[RTSSAppStyle currentAppStyle].textMajorColor textFont:[UIFont systemFontOfSize:14] tag:100];
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    titleLabel.textAlignment = NSTextAlignmentLeft;
//    titleLabel.backgroundColor = [UIColor redColor];
    [self addSubview:titleLabel];
    
    //imageBtn
    frame = CGRectMake(self.bounds.size.width - IMAGE_BUTTON_WIDTH - LEFT_INTERVAL, (self.frame.size.height - IMAGE_BUTTON_WIDTH) / 2.0, IMAGE_BUTTON_WIDTH, IMAGE_BUTTON_WIDTH);
    _button = [CommonUtils buttonWithType:UIButtonTypeCustom frame:frame title:nil bgImageNormal:[UIImage imageNamed:@"common_checked_d"] bgImageHighlighted:nil bgImageSelected:[UIImage imageNamed:@"common_checked_a"] addTarget:nil action:nil tag:101];
    [self addSubview:_button];
    
    //line
    CGFloat y = CGRectGetMaxY(titleLabel.frame);
    line = [[UIImageView alloc] initWithFrame:CGRectMake(0, y + TOP_INTERVAL, self.bounds.size.width, 2)];
    line.image = [UIImage imageNamed:@"common_separator_line"];
    [self addSubview:line];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, CGRectGetMaxY(line.frame));
}

- (void)updateFrame{
    UIFont *tfont = [UIFont systemFontOfSize:14.0];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    CGSize sizeText = [_title boundingRectWithSize:CGSizeMake(TITLE_LABEL_WIDTH, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    if (sizeText.height > (self.frame.size.height - 2 * TOP_INTERVAL -2)) {
        titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, TITLE_LABEL_WIDTH, sizeText.height);
        CGFloat y = CGRectGetMaxY(titleLabel.frame);
        line.frame = CGRectMake(0, y + TOP_INTERVAL, self.bounds.size.width, 2);
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, CGRectGetMaxY(line.frame));
    }else{
        titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, TITLE_LABEL_WIDTH, titleLabel.frame.size.height);
    }

}

+ (CGFloat)cellHeight:(DNDSubModel *)model{
    //size
    DNDTableViewCellSubViewCell * cell = [[[DNDTableViewCellSubViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell.title = model.title;
    
    NSLog(@" subCell height  :  %f",cell.frame.size.height);
    return cell.frame.size.height;
}

@end

#pragma mark DNDTableViewCell

@interface DNDTableViewCell (){
    UILabel * titleLabel;
    UIImageView * line;
}
@end

@implementation DNDTableViewCell

- (void)dealloc{
    [line release];
    [super dealloc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.frame = CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 44);
        self.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
        [self initViews];
    }
    
    return self;
}

- (void)setTitle:(NSString *)title{
    if (_title != title) {
        _title = title;
        titleLabel.text = title;
        [self updateFrame];
    }
}


- (void)initViews{
    //title
    CGRect frame = CGRectMake(LEFT_INTERVAL, TOP_INTERVAL, TITLE_LABEL_WIDTH, self.frame.size.height - 2 * TOP_INTERVAL - 2);
    titleLabel = [CommonUtils labelWithFrame:frame text:@"" textColor:[RTSSAppStyle currentAppStyle].textMajorColor textFont:[UIFont systemFontOfSize:14] tag:100];
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:titleLabel];
    
    //imageBtn
    frame = CGRectMake(self.bounds.size.width - IMAGE_BUTTON_WIDTH - LEFT_INTERVAL, (self.frame.size.height - IMAGE_BUTTON_WIDTH) / 2.0, IMAGE_BUTTON_WIDTH, IMAGE_BUTTON_WIDTH);
    _expandButton = [CommonUtils buttonWithType:UIButtonTypeCustom frame:frame title:nil bgImageNormal:[UIImage imageNamed:@"common_arrow_down"] bgImageHighlighted:nil bgImageSelected:nil addTarget:nil action:nil tag:101];
    [self addSubview:_expandButton];
    
    //line
    CGFloat y = CGRectGetMaxY(titleLabel.frame);
    line = [[UIImageView alloc] initWithFrame:CGRectMake(0, y + TOP_INTERVAL, self.bounds.size.width, 2)];
    line.image = [UIImage imageNamed:@"common_separator_line"];
    [self addSubview:line];
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, CGRectGetMaxY(line.frame));
}

- (void)updateFrame{
    UIFont *tfont = [UIFont systemFontOfSize:14.0];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    CGSize sizeText = [_title boundingRectWithSize:CGSizeMake(TITLE_LABEL_WIDTH, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    if (sizeText.height > (self.frame.size.height - 2 * TOP_INTERVAL - 2)) {
        titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, TITLE_LABEL_WIDTH, sizeText.height);
        CGFloat y = CGRectGetMaxY(titleLabel.frame);
        line.frame = CGRectMake(0, y + TOP_INTERVAL, self.bounds.size.width, 2);
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, CGRectGetMaxY(line.frame));
        _expandButton.frame = CGRectMake(_expandButton.frame.origin.x, (self.frame.size.height -  IMAGE_BUTTON_WIDTH) / 2.0, IMAGE_BUTTON_WIDTH, IMAGE_BUTTON_WIDTH);
    }else{
        titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, TITLE_LABEL_WIDTH, titleLabel.frame.size.height);
    }

    
    NSLog(@"DNDTableViewCell height : %f",self.frame.size.height);
}

+ (CGFloat)cellHeight:(DNDModel *)model{
    //size
    DNDTableViewCell * cell = [[[DNDTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    cell.title = model.title;
    
    NSLog(@"height  :  %f",cell.frame.size.height);
    return cell.frame.size.height;
}


@end

@interface NSMutableArray (DNDTableView)

- (void)initiateObjectsForCapacity:(NSInteger)numItems;

@end

@implementation NSMutableArray (DNDTableView)

- (void)initiateObjectsForCapacity:(NSInteger)numItems{
    for (int i = [self count]; i < numItems; i++) {
        NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:0];
        [self addObject:array];
        [array release];
    }
}

@end


#pragma mark DNDTableView
@interface DNDTableView ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray * expandedIndexPaths;
    NSMutableDictionary * expandedCells;
    //
    NSMutableArray * insertInsertPaths;
    NSIndexPath * currentClickIndexPath;
}

@end

@implementation DNDTableView

- (void)dealloc{
    [expandedIndexPaths release];
    [expandedCells release];
    [insertInsertPaths release];
    [currentClickIndexPath release];
    [super dealloc];
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        expandedIndexPaths = [[NSMutableArray alloc] initWithCapacity:0];
        expandedCells = [[NSMutableDictionary alloc] initWithCapacity:0];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setDNDTableViewDelegate:(id<DNDTableViewDelegate>)DNDTableViewDelegate{
    self.dataSource = self;
    self.delegate   = self;
    if (_DNDTableViewDelegate != DNDTableViewDelegate) {
        _DNDTableViewDelegate = DNDTableViewDelegate;
    }
}

#pragma ExpandButtonClick

- (void)expandButtonClick:(id)sender event:(id)event{
    NSSet * touches = [event allTouches];
    UITouch * touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self];
    
    NSIndexPath * indexPath = [self indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath) {
        if ([_DNDTableViewDelegate respondsToSelector:@selector(expandButtonClicked:event:)]) {
            [_DNDTableViewDelegate expandButtonClicked:sender event:event];
        }
        
        [self.delegate tableView:self didSelectRowAtIndexPath:indexPath];
    }
    
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (insertInsertPaths && [insertInsertPaths containsObject:indexPath]) {
        NSIndexPath * correspondIndexPath = [self correspondingIndexPathForSubRowAtIndexPath:indexPath];
        NSLog(@"section:%d   row:%d",indexPath.section,indexPath.row);
        NSLog(@"section:%d   row:%d    subrow:%d",correspondIndexPath.section,correspondIndexPath.row,correspondIndexPath.subRow);
        return [_DNDTableViewDelegate tableView:tableView heightForSubRowAtIndexPath:correspondIndexPath];
    }else{
        NSIndexPath * correspondIndexPath = nil;
        NSIndexPath * compareIndexPath = nil;
        if (insertInsertPaths && [insertInsertPaths count] > 0) {
            compareIndexPath = [insertInsertPaths firstObject];
        }else{
            compareIndexPath = indexPath;
        }
        if (indexPath.row < compareIndexPath.row) {
            correspondIndexPath = indexPath;
        }else if (indexPath.row > compareIndexPath.row && indexPath.row >= (compareIndexPath.row + insertInsertPaths.count)){
            correspondIndexPath = [NSIndexPath indexPathForRow:(indexPath.row - insertInsertPaths.count) inSection:indexPath.section];
        }else{
            correspondIndexPath = indexPath;
        }
        NSLog(@"% f",[_DNDTableViewDelegate tableView:tableView heightForRowAtIndexPath:correspondIndexPath]);
        
        return [_DNDTableViewDelegate tableView:tableView heightForRowAtIndexPath:correspondIndexPath];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_DNDTableViewDelegate && [_DNDTableViewDelegate respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        NSInteger numberOfSections = [_DNDTableViewDelegate numberOfSectionsInTableView:tableView];

        if ([expandedIndexPaths count] != numberOfSections) {
            [expandedIndexPaths initiateObjectsForCapacity:numberOfSections];
        }
        return numberOfSections;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_DNDTableViewDelegate && [_DNDTableViewDelegate respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        NSLog(@"%d",[_DNDTableViewDelegate tableView:tableView numberOfRowsInSection:section] + [[expandedIndexPaths objectAtIndex:section] count]);
        return [_DNDTableViewDelegate tableView:tableView numberOfRowsInSection:section] + [[expandedIndexPaths objectAtIndex:section] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![expandedIndexPaths[indexPath.section] containsObject:indexPath]) {
        
        NSIndexPath *tempIndexPath = [self correspondingIndexPathForRowAtIndexPath:indexPath];
        DNDTableViewCell *cell = (DNDTableViewCell *)[_DNDTableViewDelegate tableView:tableView cellForRowAtIndexPath:tempIndexPath];
        if ([[expandedCells allKeys] containsObject:tempIndexPath])
            [cell setIsExpand:[[expandedCells objectForKey:tempIndexPath] boolValue]];
        
        
        if (cell.isExpandable) {
            
            [expandedCells setObject:[NSNumber numberWithBool:[cell isExpand]]
                                     forKey:indexPath];
            
            
            [cell.expandButton addTarget:self
                                 action:@selector(expandButtonClick:event:)
                       forControlEvents:UIControlEventTouchUpInside];
            
            if (cell.isExpand) {
                
                cell.accessoryView.transform = CGAffineTransformMakeRotation(M_PI);
                
            } else {
                
            }
            
        } else {
            
        }
        return cell;
        
    } else {
        
        NSIndexPath *indexPathForSubrow = [self correspondingIndexPathForSubRowAtIndexPath:indexPath];
        DNDTableViewCell *cell = (DNDTableViewCell *)[_DNDTableViewDelegate tableView:(DNDTableView *)tableView cellForSubRowAtIndexPath:indexPathForSubrow];
            
        return cell;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%d   %d",indexPath.section, indexPath.row);
    if ([_DNDTableViewDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [_DNDTableViewDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    
    if ([_DNDTableViewDelegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]) {
        [_DNDTableViewDelegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DNDTableViewCell * cell = (DNDTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[DNDTableViewCell class]] && cell.isExpandable) {
        //==
        cell.isExpand = !cell.isExpand;
        
        //==
        NSInteger numOfSubRows = [self numberOfSubRowsAtIndexPath:indexPath];
        
        NSMutableArray * indexPaths = [[NSMutableArray alloc] initWithCapacity:0];
        NSInteger row = indexPath.row;
        NSInteger section = indexPath.section;
        
        for (NSInteger index = 1; index <= numOfSubRows; index++) {
            NSIndexPath * expandIndexPath =  [NSIndexPath indexPathForRow:row+index inSection:section];
            [indexPaths addObject:expandIndexPath];
        }
        NSLog(@"currentClickIndexPath : %@  currentClickIndexPath.section : %d       currentClickIndexPath.row : %d",currentClickIndexPath,currentClickIndexPath.section, currentClickIndexPath.row);
        if (currentClickIndexPath && currentClickIndexPath.section == indexPath.section && currentClickIndexPath.row == indexPath.row) {
            if (!cell.isExpand) {
                currentClickIndexPath = nil;
                [insertInsertPaths removeAllObjects];
                [self setIsExpanded:NO forCellAtIndexPath:indexPath];
                [self removeExpandedIndexPaths:indexPaths forSection:section];
                [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
                [UIView animateWithDuration:0.2 animations:^{
                    cell.expandButton.transform = CGAffineTransformMakeRotation(0);
                }];
                
                return;
            }
        }
        
        //==判断是否转换indexPath
        NSIndexPath *  changeIndexPath = nil;
        if(currentClickIndexPath && currentClickIndexPath.section == indexPath.section && currentClickIndexPath.row != indexPath.row){
            
            if (indexPath.row > currentClickIndexPath.row) {
                changeIndexPath = [NSIndexPath indexPathForRow:indexPath.row - insertInsertPaths.count inSection:indexPath.section];

            }
            
            //移除插入的cell
            NSArray * lastInsertIndexPaths = [[NSArray alloc] initWithArray:insertInsertPaths];
            [insertInsertPaths removeAllObjects];
            [self setIsExpanded:NO forCellAtIndexPath:currentClickIndexPath];
            [self removeExpandedIndexPaths:lastInsertIndexPaths forSection:currentClickIndexPath.section];
            [tableView deleteRowsAtIndexPaths:lastInsertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
            [lastInsertIndexPaths release];
            
            //cellButton
            DNDTableViewCell * lastShowCell = (DNDTableViewCell *)[tableView cellForRowAtIndexPath:currentClickIndexPath];
            [UIView animateWithDuration:0.2 animations:^{
                lastShowCell.expandButton.transform = CGAffineTransformMakeRotation(0);
            }];
            lastShowCell.isExpand = NO;
            currentClickIndexPath = nil;
        }
        
        if (changeIndexPath) {
            numOfSubRows = [self numberOfSubRowsAtIndexPath:changeIndexPath];
            
            [indexPaths removeAllObjects];
            row = changeIndexPath.row;
            section = changeIndexPath.section;
            
            for (NSInteger index = 1; index <= numOfSubRows; index++) {
                NSIndexPath * expandIndexPath =  [NSIndexPath indexPathForRow:row+index inSection:section];
                [indexPaths addObject:expandIndexPath];
            }
        }
        NSLog(@"currentClickIndexPath : %@     cell.isExpand  :  %d",currentClickIndexPath,cell.isExpand);
        if (!currentClickIndexPath && cell.isExpand) {
            //展开当前cell
            insertInsertPaths = [[NSMutableArray alloc] initWithArray:indexPaths];
            currentClickIndexPath = [[NSIndexPath indexPathForRow:changeIndexPath ? changeIndexPath.row : indexPath.row inSection:changeIndexPath ? changeIndexPath.section : indexPath.section] retain];
            NSLog(@"currentClickIndexPath : %@  currentClickIndexPath.section : %d       currentClickIndexPath.row : %d",currentClickIndexPath,currentClickIndexPath.section, currentClickIndexPath.row);
            [self setIsExpanded:YES forCellAtIndexPath:changeIndexPath ? changeIndexPath : indexPath];
            [self insertExpandedIndexPaths:indexPaths forSection:section];
            [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            if (cell.isExpand) {
                cell.expandButton.transform = CGAffineTransformMakeRotation(M_PI);
            }else{
                cell.expandButton.transform = CGAffineTransformMakeRotation(0);
            }
        }];
        
        [indexPaths release];
    }else if ([cell isKindOfClass:[DNDTableViewCellSubViewCell class]]){
        NSIndexPath * subIndexPath = [self correspondingIndexPathForSubRowAtIndexPath:indexPath];
        NSLog(@"subIndexPath.section : %d   subIndexPath.row : %d    subIndexPath.subRow : %d",subIndexPath.section,subIndexPath.row,subIndexPath.subRow);
        
        if (_DNDTableViewDelegate && [_DNDTableViewDelegate respondsToSelector:@selector(tableView:didSelectSubRowAtIndexPath:)]) {
            [_DNDTableViewDelegate tableView:tableView didSelectSubRowAtIndexPath:subIndexPath];
        }
    }
}

#pragma mark - PrivateMedth

- (NSInteger)numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    return [_DNDTableViewDelegate tableView:self numberOfSubRowsAtIndexPath:[self correspondingIndexPathForRowAtIndexPath:indexPath]];
}

- (NSIndexPath *)correspondingIndexPathForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = 0;
    NSInteger row = 0;
    while (index < indexPath.row) {
        
        NSIndexPath *tempIndexPath = [self correspondingIndexPathForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:indexPath.section]];
        NSLog(@"indexPath.row == %d",tempIndexPath.row);
        BOOL isExpanded = [[expandedCells allKeys] containsObject:tempIndexPath] ? [[expandedCells objectForKey:tempIndexPath] boolValue] : NO;
        
        if (isExpanded) {
            
            NSInteger numberOfExpandedRows = [_DNDTableViewDelegate tableView:self numberOfSubRowsAtIndexPath:tempIndexPath];
            
            index += (numberOfExpandedRows + 1);
            
        } else
            index++;
        
        row++;
        
    }
    return [NSIndexPath indexPathForRow:row inSection:indexPath.section];
}

- (NSIndexPath *)correspondingIndexPathForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = 0;
    NSInteger row = 0;
    NSInteger subrow = 0;
    while (1) {
        
        NSIndexPath *tempIndexPath = [self correspondingIndexPathForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:indexPath.section]];
        BOOL isExpanded = [[expandedCells allKeys] containsObject:tempIndexPath] ? [[expandedCells objectForKey:tempIndexPath] boolValue] : NO;
        
        if (isExpanded) {
            
            NSInteger numberOfExpandedRows = [_DNDTableViewDelegate tableView:self numberOfSubRowsAtIndexPath:tempIndexPath];
            
            if ((indexPath.row - index) <= numberOfExpandedRows) {
                subrow = indexPath.row - index;
                break;
            }
            
            index += (numberOfExpandedRows + 1);
            
        } else
            index++;
        
        row++;
    }
    
    return [NSIndexPath indexPathForSubRow:subrow inRow:row inSection:indexPath.section];
}

- (void)setIsExpanded:(BOOL)isExpanded forCellAtIndexPath:(NSIndexPath *)indexPath{
    NSIndexPath *correspondingIndexPath = [self correspondingIndexPathForRowAtIndexPath:indexPath];
    NSNumber *abc = [NSNumber numberWithBool:isExpanded];
    NSLog(@"=============%@",abc);
    [expandedCells setObject:abc forKey:correspondingIndexPath];
}

- (void)insertExpandedIndexPaths:(NSArray *)indexPaths forSection:(NSInteger)section{
    NSIndexPath * firstIndexPathToExpand = [indexPaths objectAtIndex:0];
    NSIndexPath * firstIndexPathExpanded = nil;
    if ([expandedIndexPaths[section] count] > 0) {
        firstIndexPathExpanded = [[expandedIndexPaths objectAtIndex:section] objectAtIndex:0];
    }
    
    if (firstIndexPathExpanded && firstIndexPathToExpand.section == firstIndexPathExpanded.section && firstIndexPathToExpand.row < firstIndexPathExpanded.row) {
        NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:0];

        [[expandedIndexPaths objectAtIndex:section] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSIndexPath * updated = [NSIndexPath indexPathForRow:([obj row] + [indexPaths count]) inSection:section];;
            [array addObject:updated];
        }];
        
        [array addObjectsFromArray:indexPaths];
        expandedIndexPaths[section] = array;
        [array release];
    }else{
        [expandedIndexPaths[section] addObjectsFromArray:indexPaths];
    }
    
    [self sortExpandedIndexPathsForSection:section];
}

- (void)removeExpandedIndexPaths:(NSArray *)indexPaths forSection:(NSInteger)section{
    NSUInteger index = [expandedIndexPaths[section] indexOfObject:indexPaths[0]];
    
    [expandedIndexPaths[section] removeObjectsInArray:indexPaths];
    
    if (index == 0) {
        
        __block NSMutableArray *array = [NSMutableArray array];
        [expandedIndexPaths[section] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSIndexPath *updated = [NSIndexPath indexPathForRow:([obj row] - [indexPaths count])
                                                      inSection:[obj section]];
            
            [array addObject:updated];
        }];
        
        expandedIndexPaths[section] = array;
        
    }
    
    [self sortExpandedIndexPathsForSection:section];
}

- (void)sortExpandedIndexPathsForSection:(NSInteger)section{
    [expandedIndexPaths[section] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 section] < [obj2 section]) {
            return NSOrderedAscending;
        }else if ([obj1 section] > [obj2 section]){
            return NSOrderedDescending;
        }else{
            if ([obj1 row] < [obj2 row]) {
                return NSOrderedAscending;
            }else{
                return NSOrderedDescending;
            }
        }
    }];
}
@end

static void * SubRowObjectKey;

@implementation NSIndexPath (DNDTableView)
@dynamic subRow;

- (void)dealloc{
    SubRowObjectKey = nil;
    [super dealloc];
}

- (NSInteger)subRow{
    id subRowObj = objc_getAssociatedObject(self, SubRowObjectKey);
    
    return [subRowObj integerValue];
}

- (void)setSubRow:(NSInteger)subRow{
    id subRowObj = [NSNumber numberWithInteger:subRow];
    objc_setAssociatedObject(self, SubRowObjectKey, subRowObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSIndexPath *)indexPathForSubRow:(NSInteger)subrow inRow:(NSInteger)row inSection:(NSInteger)section{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    indexPath.subRow = subrow;
    
    return indexPath;
}

@end


#pragma mark DNDModel
@implementation DNDModel
@synthesize title,subModes;

- (void)dealloc{
    [title release];
    [subModes release];
    [super dealloc];
}
@end

#pragma mark DNDSubModel

@implementation DNDSubModel
@synthesize title,selected;

- (void)dealloc{
    [title release];
    [super dealloc];
}

@end
