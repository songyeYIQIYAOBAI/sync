//
//  PersonCenterTableView.h
//  RTSS
//
//  Created by 宋野 on 14-11-6.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PortraitImageView.h"

#define USER_HEAD_IMAGEPATH     @"user_head_imagePath"
#define USER_NAME               @"user_name"
#define USER_PHONENUMBER        @"user_phonenumber"
#define USER_CHANGE_PASSWORDS   @"user_change_passwords"
#define USER_MYSERVICES         @"user_myservices"

typedef NS_ENUM(NSInteger, PersonCenterTableViewCellType){
    PersonCenterTableViewCellTypePhoto,
    PersonCenterTableViewCellTypeName,
    PersonCenterTableViewCellTypePhoneNumber,
    PersonCenterTableViewCellTypeChangePassWord,
    PersonCenterTableViewCellTypeMyAccount,
    PersonCenterTableViewCellTypeMyPlan,
    PersonCenterTableViewCellTypeMyProfile,
    PersonCenterTableViewCellTypeAbout,
    PersonCenterTableViewCellTypeMyHistory,
    PersonCenterTableViewCellTypeMyFavorites,
    PersonCenterTableViewCellTypeVersionUpdate,
};


@protocol PersonCenterTableViewDelegate <NSObject>

- (void)PersonCenterTablewDidSelectRowAtIndexPath:(NSIndexPath *)indexPath indexTag:(NSInteger)indexTag;
- (void)PersonCenterTablewClickHeadImageButton:(UIButton *)button;

@end
@interface PersonCenterTableView : UIView<UITableViewDataSource,UITableViewDelegate>{
    
}

@property (nonatomic, readonly)UITableView * myTableView;
@property (nonatomic, retain)NSMutableArray * sectionArray;
@property (nonatomic, retain)NSMutableArray * rowArray;
@property (nonatomic, assign)id<PersonCenterTableViewDelegate> delegate;

- (void)reloadTableViewSection:(NSMutableArray *)sections row:(NSMutableArray *)rows;
@end

@interface PersonCenterTableFootView : UIView

@property (nonatomic ,retain)UIButton * logOutBtn;

@end

@class PersonCenterItemModel;
@interface PersonCenterTableViewCell : UITableViewCell

@property (nonatomic , retain)PortraitImageView * itemHeadImage;
@property (nonatomic , retain)UIImageView * itemLeftImage;
@property (nonatomic , retain)UILabel * itemExplanationLabel;
@property (nonatomic , retain)UILabel * itemTextLabel;
@property (nonatomic , retain)UIImageView * itemRightArrow;
@property (nonatomic , retain)UIImageView * lineImage;
@property (nonatomic, retain)UIImageView*   selectedLineImage;

- (void)changeSubviewsFrame:(CGRect)rect;
- (void)changeFrameIfDoNotHaveRightArrow;

@end


@interface PersonCenterItemModel : NSObject

@property (nonatomic , retain)NSString * itemExplanation;
@property (nonatomic , retain)NSString * itemHeadImage;
@property (nonatomic , retain)NSString * itemLeftImage;
@property (nonatomic , retain)NSString * itemText;

@property (nonatomic , assign)NSInteger itemType;
@property (nonatomic , assign)NSInteger itemIndexTag;

@end





