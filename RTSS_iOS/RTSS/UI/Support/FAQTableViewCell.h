//
//  FAQTableViewCell.h
//  RTSS
//
//  Created by Liuxs on 15-1-27.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

/**
 *  FAQTableViewCell is a custom table view cell class extended from UITableViewCell class. This class is used to represent the
 *  expandable rows of the FAQTableView object.
 */
#import <UIKit/UIKit.h>

@interface FAQTableViewCell : UITableViewCell
/**
 * The boolean value showing the receiver is expandable or not. The default value of this property is NO.
 */
@property (nonatomic, assign) BOOL isExpandable;

/**
 * The boolean value showing the receiver is expanded or not. The default value of this property is NO.
 */
@property (nonatomic, assign) BOOL isExpanded;

/**
 * Adds an indicator view into the receiver when the relevant cell is expanded.
 */
- (void)addIndicatorView;

/**
 * Removes the indicator view from the receiver when the relevant cell is collapsed.
 */
- (void)removeIndicatorView;

/**
 * Returns a boolean value showing if the receiver contains an indicator view or not.
 *
 *  @return The boolean value for the indicator view.
 */
- (BOOL)containsIndicatorView;

@end
