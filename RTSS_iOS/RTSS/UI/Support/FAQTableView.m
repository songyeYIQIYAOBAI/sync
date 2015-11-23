//
//  FAQTableView.m
//  RTSS
//
//  Created by Liuxs on 15-1-27.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "FAQTableView.h"
#import "FAQTableViewCell.h"
#import "FAQTableViewCellIndicator.h"
#import "RTSSAppStyle.h"
#import <objc/runtime.h>

#pragma mark - NSArray (FAQTableView)

@interface NSMutableArray (FAQTableView)

- (void)initiateObjectsForCapacity:(NSInteger)numItems;

@end

@implementation NSMutableArray (FAQTableView)

- (void)initiateObjectsForCapacity:(NSInteger)numItems
{
    for (NSInteger index = [self count]; index < numItems; index++) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        [self addObject:array];
    }
}

@end

#pragma mark - FAQTableView

@interface FAQTableView () <UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic, retain) NSMutableArray      *expandedIndexPaths;

@property (nonatomic, retain) NSMutableDictionary *expandableCells;

@property (nonatomic, retain) UIImage             *mLineImage;
@end

@implementation FAQTableView
@synthesize mSearchPlay,mLineImage,expandableCells,expandedIndexPaths,mResultsArr,tempResults;

-(void)dealloc{
    
    [mSearchPlay        release];
    [tempResults        release];
    [mLineImage         release];
    [expandedIndexPaths release];
    [expandableCells    release];
    [mResultsArr        release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    
    if (self) {
        self.expandedIndexPaths = [NSMutableArray arrayWithCapacity:0];
        self.expandableCells    = [NSMutableDictionary dictionaryWithCapacity:0];
        self.mResultsArr        = [NSMutableArray arrayWithCapacity:0];
        self.mLineImage         = [UIImage imageNamed:@"common_separator_line.png"];
    }
    
    return self;
}

- (void)setFAQTableViewDelegate:(id<FAQTableViewDelegate>)FAQTableViewDelegate
{
    self.dataSource = self;
    self.delegate   = self;
    
    [self setSeparatorColor:[UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]];
    
    if (FAQTableViewDelegate)
        _FAQTableViewDelegate = FAQTableViewDelegate;
}

- (void)setSeparatorColor:(UIColor *)separatorColor
{
    [super setSeparatorColor:separatorColor];
    [FAQTableViewCellIndicator setIndicatorColor:separatorColor];
}

#pragma mark - UITableViewDataSource

#pragma mark - Required
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect mLineRect    = CGRectMake(0, 19, PHONE_UISCREEN_WIDTH, 1);
    UIView *mHeaderView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, PHONE_UISCREEN_WIDTH, 15)]autorelease];
    mHeaderView.backgroundColor = [RTSSAppStyle currentAppStyle].navigationBarColor;
    UILabel *mHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, PHONE_UISCREEN_WIDTH-15, 20)];
    if (section == 0) {
        mHeaderLabel.text = @"Hot Topic";
        mHeaderLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorGreenColor;
    }else if (section == 1){
        mHeaderLabel.text = @"All";
        mHeaderLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
    }
    mHeaderLabel.font = [RTSSAppStyle getRTSSFontWithSize:13.0f];
    [mHeaderView addSubview:mHeaderLabel];
    UIImageView *mLineViewDown = [[UIImageView alloc] initWithFrame:mLineRect];
    mLineViewDown.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
//    [mLineViewDown setImage:self.mLineImage];
    [mHeaderView addSubview:mLineViewDown];
    [mHeaderLabel release];
    [mLineViewDown release];
    return mHeaderView;
}


#pragma mark -

- (void)refreshResultsArr:(NSArray *)ResultsArr UISearchDisplayController:(UISearchDisplayController *)SearchDisplay
{
    [self.mResultsArr arrayByAddingObjectsFromArray:ResultsArr];
    
    self.mSearchPlay = SearchDisplay;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([tableView isEqual:self.mSearchPlay.searchResultsTableView]) {
        return [self.mResultsArr count];
    }else{
        return [_FAQTableViewDelegate tableView:tableView numberOfRowsInSection:section] + [[[self expandedIndexPaths] objectAtIndex:section] count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:self.mSearchPlay.searchResultsTableView]) {
        
    }
    if (![self.expandedIndexPaths[indexPath.section] containsObject:indexPath]) {
        
        NSIndexPath *tempIndexPath = [self correspondingIndexPathForRowAtIndexPath:indexPath];
        FAQTableViewCell *cell = (FAQTableViewCell *)[_FAQTableViewDelegate tableView:tableView cellForRowAtIndexPath:tempIndexPath];
        if ([[self.expandableCells allKeys] containsObject:tempIndexPath])
            [cell setIsExpanded:[[self.expandableCells objectForKey:tempIndexPath] boolValue]];
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
        if (cell.isExpandable) {
            
            [self.expandableCells setObject:[NSNumber numberWithBool:[cell isExpanded]]
                                     forKey:indexPath];
            
            UIButton *expandableButton = (UIButton *)cell.accessoryView;
            [expandableButton addTarget:tableView
                                 action:@selector(expandableButtonTouched:event:)
                       forControlEvents:UIControlEventTouchUpInside];
            
            if (cell.isExpanded) {
                
                cell.accessoryView.transform = CGAffineTransformMakeRotation(M_PI);
                
            } else {
                
                if ([cell containsIndicatorView])
                    [cell removeIndicatorView];
                
            }
            
        } else {
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
            [cell removeIndicatorView];
            cell.accessoryView = nil;
            
        }
        cell.selectionStyle      = UITableViewCellSelectionStyleNone;
        return cell;
        
    } else {
        
        NSIndexPath *indexPathForSubrow = [self correspondingIndexPathForSubRowAtIndexPath:indexPath];
        UITableViewCell *cell = [_FAQTableViewDelegate tableView:(FAQTableView *)tableView cellForSubRowAtIndexPath:indexPathForSubrow];

        cell.backgroundView   = nil;
        cell.indentationLevel = 2;
        
        return cell;
        
    }
}

#pragma mark - Optional

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([tableView isEqual:self.mSearchPlay.searchResultsTableView]) {
        return 1;
    }
    if ([_FAQTableViewDelegate respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        
        NSInteger numberOfSections = [_FAQTableViewDelegate numberOfSectionsInTableView:tableView];
        
        if ([self.expandedIndexPaths count] != numberOfSections)
            [self.expandedIndexPaths initiateObjectsForCapacity:numberOfSections];
        
        return numberOfSections;
        
    }
    
    return 1;
}


/*
 *  Uncomment the implementations of the required methods.
 */

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:titleForHeaderInSection:)])
//        return [_SKSTableViewDelegate tableView:tableView titleForHeaderInSection:section];
//
//    return nil;
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:titleForFooterInSection:)])
//        return [_SKSTableViewDelegate tableView:tableView titleForFooterInSection:section];
//
//    return nil;
//}
//
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView canEditRowAtIndexPath:indexPath];
//
//    return NO;
//}
//
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView canMoveRowAtIndexPath:indexPath];
//
//    return NO;
//}
//
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(sectionIndexTitlesForTableView:)])
//        [_SKSTableViewDelegate sectionIndexTitlesForTableView:tableView];
//
//    return nil;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:)])
//        [_SKSTableViewDelegate tableView:tableView sectionForSectionIndexTitle:title atIndex:index];
//
//    return 0;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
//}
//
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
//}

#pragma mark - UITableViewDelegate

#pragma mark - Optional

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d   %d",indexPath.section,indexPath.row);
    if ([_FAQTableViewDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)])
        [_FAQTableViewDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    if ([_FAQTableViewDelegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)])
        [_FAQTableViewDelegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    __block FAQTableViewCell *cell = (FAQTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[FAQTableViewCell class]] && cell.isExpandable) {
        
        cell.isExpanded = !cell.isExpanded;
        
        NSInteger numberOfSubRows = [self numberOfSubRowsAtIndexPath:indexPath];
        
        NSMutableArray *indexPaths = [NSMutableArray array];
        NSInteger row = indexPath.row;
        NSInteger section = indexPath.section;
        
        for (NSInteger index = 1; index <= numberOfSubRows; index++) {
            
            NSIndexPath *expIndexPath = [NSIndexPath indexPathForRow:row+index inSection:section];
            [indexPaths addObject:expIndexPath];
        }
        
        if (cell.isExpanded) {
            
            [self setIsExpanded:YES forCellAtIndexPath:indexPath];
            [self insertExpandedIndexPaths:indexPaths forSection:indexPath.section];
            [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
            
        } else {
            
            [self setIsExpanded:NO forCellAtIndexPath:indexPath];
            [self removeExpandedIndexPaths:indexPaths forSection:indexPath.section];
            [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
            
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            if (cell.isExpanded) {
                
                cell.accessoryView.transform = CGAffineTransformMakeRotation(M_PI);
                
            } else {
                cell.accessoryView.transform = CGAffineTransformMakeRotation(0);
            }
        } completion:^(BOOL finished) {
            
            if (!cell.isExpanded)
                [cell removeIndicatorView];
            
        }];
        
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if ([_FAQTableViewDelegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)])
        [_FAQTableViewDelegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    
    [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}

/*
 *  Uncomment the implementations of the required methods.
 */

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
//}
//
//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)])
//        [_SKSTableViewDelegate tableView:tableView willDisplayHeaderView:view forSection:section];
//}
//
//- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:willDisplayFooterView:forSection:)])
//        [_SKSTableViewDelegate tableView:tableView willDisplayFooterView:view forSection:section];
//}
//
//- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
//}
//
//- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:didEndDisplayingHeaderView:forSection:)])
//        [_SKSTableViewDelegate tableView:tableView didEndDisplayingHeaderView:view forSection:section];
//}
//
//- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:didEndDisplayingFooterView:forSection:)])
//        [_SKSTableViewDelegate tableView:tableView didEndDisplayingFooterView:view forSection:section];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
//
//    return [tableView rowHeight];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)])
//        [_SKSTableViewDelegate tableView:tableView heightForHeaderInSection:section];
//
//    return 0;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)])
//        [_SKSTableViewDelegate tableView:tableView heightForFooterInSection:section];
//
//    return 0;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:estimatedHeightForRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
//
//    return 0;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:estimatedHeightForHeaderInSection:)])
//        [_SKSTableViewDelegate tableView:tableView estimatedHeightForHeaderInSection:section];
//
//    return 0;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:estimatedHeightForFooterInSection:)])
//        [_SKSTableViewDelegate tableView:tableView estimatedHeightForFooterInSection:section];
//
//    return 0;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)])
//        [_SKSTableViewDelegate tableView:tableView viewForHeaderInSection:section];
//
//    return nil;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:viewForFooterInSection:)])
//        [_SKSTableViewDelegate tableView:tableView viewForFooterInSection:section];
//
//    return nil;
//}
//
//- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:shouldHighlightRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView shouldHighlightRowAtIndexPath:indexPath];
//
//    return NO;
//}
//
//- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:didHighlightRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView didHighlightRowAtIndexPath:indexPath];
//}
//
//- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:didUnhighlightRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView didUnhighlightRowAtIndexPath:indexPath];
//}
//
//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView willSelectRowAtIndexPath:indexPath];
//
//    return nil;
//}
//
//- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView willDeselectRowAtIndexPath:indexPath];
//
//    return nil;
//}
//
//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
//}
//
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
//
//    return UITableViewCellEditingStyleNone;
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
//
//    return nil;
//}
//
//- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
//
//    return NO;
//}
//
//- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:willBeginEditingRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
//}
//
//- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView didEndEditingRowAtIndexPath:indexPath];
//}
//
//- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
//
//    return nil;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:indentationLevelForRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
//
//    return 0;
//}
//
//- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:shouldShowMenuForRowAtIndexPath:)])
//        [_SKSTableViewDelegate tableView:tableView shouldShowMenuForRowAtIndexPath:indexPath];
//
//    return NO;
//}
//
//- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:canPerformAction:forRowAtIndexPath:withSender:)])
//        [_SKSTableViewDelegate tableView:tableView canPerformAction:action forRowAtIndexPath:indexPath withSender:sender];
//
//    return NO;
//}
//
//- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
//{
//    if ([_SKSTableViewDelegate respondsToSelector:@selector(tableView:performAction:forRowAtIndexPath:withSender:)])
//        [_SKSTableViewDelegate tableView:tableView performAction:action forRowAtIndexPath:indexPath withSender:sender];
//}

#pragma mark - FAQTableViewUtils

- (IBAction)expandableButtonTouched:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self];
    
    NSIndexPath *indexPath = [self indexPathForRowAtPoint:currentTouchPosition];
    
    if (indexPath)
        [self tableView:self accessoryButtonTappedForRowWithIndexPath:indexPath];
}

- (NSInteger)numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    return [_FAQTableViewDelegate tableView:self numberOfSubRowsAtIndexPath:[self correspondingIndexPathForRowAtIndexPath:indexPath]];
}

- (NSIndexPath *)correspondingIndexPathForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = 0;
    NSInteger row = 0;
    
    while (index < indexPath.row) {
        
        NSIndexPath *tempIndexPath = [self correspondingIndexPathForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:indexPath.section]];
        NSLog(@"indexPath.row == %d",tempIndexPath.row);
        BOOL isExpanded = [[self.expandableCells allKeys] containsObject:tempIndexPath] ? [[self.expandableCells objectForKey:tempIndexPath] boolValue] : NO;
        
        if (isExpanded) {
            
            NSInteger numberOfExpandedRows = [_FAQTableViewDelegate tableView:self numberOfSubRowsAtIndexPath:tempIndexPath];
            
            index += (numberOfExpandedRows + 1);
            
        } else
            index++;
        
        row++;
        
    }
    
    return [NSIndexPath indexPathForRow:row inSection:indexPath.section];
}

- (NSIndexPath *)correspondingIndexPathForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = 0;
    NSInteger row = 0;
    NSInteger subrow = 0;
    
    while (1) {
        
        NSIndexPath *tempIndexPath = [self correspondingIndexPathForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:indexPath.section]];
        BOOL isExpanded = [[self.expandableCells allKeys] containsObject:tempIndexPath] ? [[self.expandableCells objectForKey:tempIndexPath] boolValue] : NO;
        
        if (isExpanded) {
            
            NSInteger numberOfExpandedRows = [_FAQTableViewDelegate tableView:self numberOfSubRowsAtIndexPath:tempIndexPath];
            
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

- (void)setIsExpanded:(BOOL)isExpanded forCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *correspondingIndexPath = [self correspondingIndexPathForRowAtIndexPath:indexPath];
    NSNumber *abc = [NSNumber numberWithBool:isExpanded];
    NSLog(@"%@",abc);
    [self.expandableCells setObject:abc forKey:correspondingIndexPath];
}

- (void)insertExpandedIndexPaths:(NSArray *)indexPaths forSection:(NSInteger)section
{
    NSIndexPath *firstIndexPathToExpand = indexPaths[0];
    NSIndexPath *firstIndexPathExpanded = nil;
    
    if ([self.expandedIndexPaths[section] count] > 0) firstIndexPathExpanded = self.expandedIndexPaths[section][0];
    
    __block NSMutableArray *array = [NSMutableArray array];
    
    if (firstIndexPathExpanded && firstIndexPathToExpand.section == firstIndexPathExpanded.section && firstIndexPathToExpand.row < firstIndexPathExpanded.row) {
        
        [self.expandedIndexPaths[section] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSIndexPath *updated = [NSIndexPath indexPathForRow:([obj row] + [indexPaths count])
                                                      inSection:[obj section]];
            
            [array addObject:updated];
        }];
        
        [array addObjectsFromArray:indexPaths];
        
        self.expandedIndexPaths[section] = array;
        
    } else {
        
        [self.expandedIndexPaths[section] addObjectsFromArray:indexPaths];
        
    }
    
    [self sortExpandedIndexPathsForSection:section];
}


- (void)removeExpandedIndexPaths:(NSArray *)indexPaths forSection:(NSInteger)section
{
    NSUInteger index = [self.expandedIndexPaths[section] indexOfObject:indexPaths[0]];
    
    [self.expandedIndexPaths[section] removeObjectsInArray:indexPaths];
    
    if (index == 0) {
        
        __block NSMutableArray *array = [NSMutableArray array];
        [self.expandedIndexPaths[section] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSIndexPath *updated = [NSIndexPath indexPathForRow:([obj row] - [indexPaths count])
                                                      inSection:[obj section]];
            
            [array addObject:updated];
        }];
        
        self.expandedIndexPaths[section] = array;
        
    }
    
    [self sortExpandedIndexPathsForSection:section];
}

- (void)sortExpandedIndexPathsForSection:(NSInteger)section
{
    [self.expandedIndexPaths[section] sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 section] < [obj2 section])
            return (NSComparisonResult)NSOrderedAscending;
        else if ([obj1 section] > [obj2 section])
            return (NSComparisonResult)NSOrderedDescending;
        else {
            
            if ([obj1 row] < [obj2 row])
                return (NSComparisonResult)NSOrderedAscending;
            else
                return (NSComparisonResult)NSOrderedDescending;
            
        }
    }];
}

@end

#pragma mark - NSIndexPath (FAQTableView)

static void *SubRowObjectKey;

@implementation NSIndexPath (FAQTableView)

@dynamic subRow;

- (NSInteger)subRow
{
    id subRowObj = objc_getAssociatedObject(self, SubRowObjectKey);
    return [subRowObj integerValue];
}

- (void)setSubRow:(NSInteger)subRow
{
    id subRowObj = [NSNumber numberWithInteger:subRow];
    objc_setAssociatedObject(self, SubRowObjectKey, subRowObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSIndexPath *)indexPathForSubRow:(NSInteger)subrow inRow:(NSInteger)row inSection:(NSInteger)section
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    indexPath.subRow = subrow;
    
    return indexPath;
}


@end
