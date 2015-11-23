//
//  FormBaseTableViewCell.h
//  RTSS
//
//  Created by 蔡杰Alan on 15-1-27.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTSSAppStyle.h"
#import "FormRowDescriptor.h"

#define kFormCellTopEdge 10.0f
#define kFormCellLeftEddge  10.0f

#define kFormCellLabelHeight  30.0f

#define kFormCellLabelFont  15.0f

@protocol FormBaseTableViewCellDelegate <NSObject>


-(void)pickerButtonDone:(NSInteger)buttonTag;
-(void)singlePickerWithButtonTag:(NSInteger)buttonTag DoneWithselectedIndex:(NSInteger)index isChange:(BOOL)isChange;

@end

@interface FormBaseTableViewCell : UITableViewCell

@property(nonatomic,retain)UIView *bgView;

/**
 *  内部重写 set方法，并且调用了 [self update]函数;
 */
@property(nonatomic,retain)FormRowDescriptor *rowDescriptor;

//@property(nonatomic,copy)NSString *contentText;//value

//@property(nonatomic,copy)NSString *type;//作为key

@property(assign,nonatomic)id<FormBaseTableViewCellDelegate>delegate;
@property (nonatomic, assign) int pickerButtonTag;


+(CGFloat)formBaseCellFiedHeightByFormRowType:(FormRowType)type;

-(void)addBottomLine;
//=======以下需要子类覆盖=======
/**
 *  信息文本跟新
 */
-(void)update;

/**
 *   安装页面  先调用 [super configure]，内部  初始化bgView;
 */
-(void)configure;
/**
 *  设置背景图颜色
 *
  */
-(void)setCellBlackViewColor:(UIColor*)color;

//文本颜色从父类里取
-(UIColor*)textMajorColor;
-(UIColor*)textSubordinateColor;
-(UIColor*)textFieldBorderColor;
-(UIColor*)textFieldBgColor;
@end
