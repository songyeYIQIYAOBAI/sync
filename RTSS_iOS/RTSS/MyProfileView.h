//
//  MyProfileView.h
//  RTSS
//
//  Created by 宋野 on 14-11-21.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyProfileModelItem;
@class ContainLabelAndButton;
@class ContainLabelAndTextFieldAndButtonView;
@interface MyProfileView : UIView
@property (nonatomic ,readonly)UIButton * saveButton;
@property (nonatomic ,readonly)ContainLabelAndTextFieldAndButtonView * emailID;
@property (nonatomic ,readonly)ContainLabelAndTextFieldAndButtonView * phoneNumber;
@property (nonatomic ,readonly)ContainLabelAndTextFieldAndButtonView * anniversaryDate;
@property (nonatomic ,readonly)ContainLabelAndButton * payment;
@property (nonatomic ,readonly)ContainLabelAndButton * communication;
@property (nonatomic ,readonly)ContainLabelAndButton * language;

- (void)addViewWithModel:(MyProfileModelItem *)model;

@end

@interface ContainTwoLabelsView : UIView
@property (nonatomic ,readonly)UILabel * informationLabel;
@property (nonatomic ,readonly)UILabel * informationTextLabel;

- (void)updateViewsWithInformationString:(NSString *)information text:(NSString *)text;

@end

@interface ContainLabelAndTextFieldAndButtonView : UIView
@property (nonatomic ,readonly)UILabel * informationLabel;
@property (nonatomic ,readonly)UITextField * textField;
@property (nonatomic ,readonly)UIImageView * imageView;
@property (nonatomic ,readonly)UIButton * actionBtn;

- (void)updateViewsWithInformationString:(NSString *)information text:(NSString *)text actionBtnImage:(NSString *)image;

@end

@interface ContainLabelAndButton : UIView

@property (nonatomic ,readonly)UILabel * informationLabel;
@property (nonatomic ,readonly)UIImageView * imageView;
@property (nonatomic ,readonly)UIButton * actionBtn;

- (void)updateViewsWithInformationString:(NSString *)information actionBtnImage:(NSString *)image;

@end

@interface MyProfileModelItem : NSObject
@property (nonatomic ,retain)NSString * itemName;
@property (nonatomic ,retain)NSString * itemBillingAdress;
@property (nonatomic ,retain)NSString * itemEmailID;//可编辑
@property (nonatomic ,retain)NSString * itemPayment;//可选择
@property (nonatomic ,retain)NSString * itemPhoneNumber;//可编辑
@property (nonatomic ,retain)NSString * itemAnniversaryDate;//可编辑
@property (nonatomic ,retain)NSString * itemBirthDate;//可编辑
@property (nonatomic ,retain)NSString * itemCommunication;//可选择
@property (nonatomic ,retain)NSString * itemLanguage;//可选择



@end