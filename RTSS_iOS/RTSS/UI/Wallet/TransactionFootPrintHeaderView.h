//
//  TransactionFootPrintHeaderView.h
//  RTSS
//
//  Created by 蔡杰 on 14-10-29.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    TransactionFootPrintHeaderViewButtonTypeRight,
    TransactionFootPrintHeaderViewButtonTypeBook,
    TransactionFootPrintHeaderViewButtonTypeMessage,
    TransactionFootPrintHeaderViewButtonTypePhoto,
}TransactionFootPrintHeaderViewButtonType;


typedef NS_ENUM(NSInteger, ButtonItemViewType) {
    ButtonItemViewTypeDefaule,
    ButtonItemViewTypeGreen,
    ButtonItemViewTypeBlue,
    ButtonItemViewTypeOrangle,
    ButtonItemViewTypeClear,
};

typedef NS_ENUM(NSInteger, ButtonItemViewButtonType) {
    ButtonItemViewButtonTypeButton,
    ButtonItemViewButtonTypeImageView,
};

@interface TransactionFootPrintHeaderViewButtonItem : NSObject
@property (nonatomic ,retain)NSString * bgImage;
@property (nonatomic ,retain)NSString * selectBgImage;
@property (nonatomic ,assign)NSInteger tag;

@end

@interface ButtonItemView : UIView
@property (nonatomic ,readonly)UIButton * button;
@property (nonatomic ,retain)NSString * imageString;
@property (nonatomic ,assign)ButtonItemViewType type;
@property (nonatomic ,assign)ButtonItemViewButtonType buttonType;
@property (nonatomic ,assign)BOOL selected;

+ (instancetype)buttonItemViewWithFrame:(CGRect)frame interval:(CGFloat)interval Image:(NSString *)imageString backGroundType:(ButtonItemViewType)type buttonType:(ButtonItemViewButtonType)buttonType Tag:(NSInteger)tag;

@end


@protocol TransactionFootPrintHeaderDataSource <NSObject>

- (NSInteger)numberOfPerformButtons;

- (TransactionFootPrintHeaderViewButtonItem *)itemOfIndex:(NSInteger)index;

@end

@protocol TransactionFootPrintHeaderDelegate  <NSObject>

- (void)updateUserMothDate:(NSDate*)aDate;
- (void)buttonViewsClickButtonIndex:(NSInteger)index indexTag:(NSInteger)tag;

@end

@interface TransactionFootPrintHeaderView : UIView

@property(assign,nonatomic)id<TransactionFootPrintHeaderDelegate>headerDelagate;
@property(assign,nonatomic)id<TransactionFootPrintHeaderDataSource>headDataSource;

//更新view
- (void)updateSubViews;

-(void)setUserName:(NSString *)name Avatar:(UIImage*)aUrlString;

/**
 *  每次界面进入跟新
 */
-(void)updateCurrentDate;

/**
 *  切换 income 和 expenditure 数据
 *
 */
-(void)updateUserIncome:(CGFloat)aIncome  expenditure:(CGFloat)aExpenditure;

@end
