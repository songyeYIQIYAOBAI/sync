//
//  MyProfileView.m
//  RTSS
//
//  Created by 宋野 on 14-11-21.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "MyProfileView.h"
#import "RTSSAppStyle.h"
#import "CommonUtils.h"

#define VIEW_HEIGHT                         50.0
#define LABEL_LEFT_INTERVAL                 10.0
#define LABEL_WIDTH                         40.0
#define LABEL_HEIGHT                        20.0
#define IMAGEVIEW_WIDTH                     30.0
#define IMAGEVIEW_HEIGHT                    30.0
#define FONT_SIZE                           15.0

typedef NS_ENUM(NSInteger, RectChangeType){
    RectChangeTypeX,
    RectChangeTypeY,
    RectChangeTypeWidh,
    RectChangeTypeHeight,
};


@interface MyProfileView (){
    ContainTwoLabelsView * nameItem;
    ContainTwoLabelsView * billingAddressItem;
    ContainTwoLabelsView * birthDate;
}

@end


@implementation MyProfileView
@synthesize saveButton,emailID,phoneNumber,payment,anniversaryDate,communication,language;

- (void)dealloc{
    [nameItem release];
    [billingAddressItem release];
    [birthDate release];
    [emailID release];
    [phoneNumber release];
    [anniversaryDate release];
    [communication release];
    [payment release];
    [language release];
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews{
    self.backgroundColor = [UIColor clearColor];

    CGFloat itemWith    = self.bounds.size.width;
    CGFloat itemHeight  = VIEW_HEIGHT;
    
    //name
    nameItem = [[ContainTwoLabelsView alloc] initWithFrame:CGRectMake(0, 0, itemWith, itemHeight)];
    [self addSubview:nameItem];

    //billing address
    billingAddressItem = [[ContainTwoLabelsView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nameItem.frame), itemWith, itemHeight)];
    [self addSubview:billingAddressItem];
    
    //birth date
    birthDate = [[ContainTwoLabelsView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(billingAddressItem.frame), itemWith, itemHeight)];
    [self addSubview:birthDate];
    
    //emailID
    emailID = [[ContainLabelAndTextFieldAndButtonView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(birthDate.frame), itemWith, itemHeight)];
    [self addSubview:emailID];
    
    //phoneNumber
    phoneNumber = [[ContainLabelAndTextFieldAndButtonView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(emailID.frame), itemWith, itemHeight)];
    [self addSubview:phoneNumber];
    
    //anniversaryDate
    anniversaryDate = [[ContainLabelAndTextFieldAndButtonView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(phoneNumber.frame), itemWith, itemHeight)];
    [self addSubview:anniversaryDate];
    
    //communication
    communication = [[ContainLabelAndButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(anniversaryDate.frame), itemWith, itemHeight)];
    [self addSubview:communication];
    
    //payment
    payment = [[ContainLabelAndButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(communication.frame), itemWith, itemHeight)];
    [self addSubview:payment];
    
    //language
    language = [[ContainLabelAndButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(payment.frame), itemWith, itemHeight)];
    [self addSubview:language];
    
    //=====
    CGRect buttonFrame = CGRectMake((self.bounds.size.width-253)/2, CGRectGetMaxY(language.frame)+10, 253, 45);
    saveButton = [RTSSAppStyle getMajorGreenButton:buttonFrame
                                            target:nil
                                            action:nil
                                             title:@"Save"];
    [self addSubview:saveButton];
}

- (void)addViewWithModel:(MyProfileModelItem *)model{
   
    
    //name
    [nameItem updateViewsWithInformationString:@"Name:" text:model.itemName];
    
    //billing address
    [billingAddressItem updateViewsWithInformationString:@"Billing address:" text:model.itemBillingAdress];
    billingAddressItem.frame = [self getRectWithRect:billingAddressItem.frame changedValue:CGRectGetMaxY(nameItem.frame) type:RectChangeTypeY];
    
    //birth date
    [birthDate updateViewsWithInformationString:@"Birth date:" text:model.itemBirthDate];
    birthDate.frame = [self getRectWithRect:birthDate.frame changedValue:CGRectGetMaxY(billingAddressItem.frame) type:RectChangeTypeY];
    
    //emailID
    [emailID updateViewsWithInformationString:@"Email id:" text:model.itemEmailID actionBtnImage:@"personcenter_cell_packageserve"];
    emailID.frame = [self getRectWithRect:emailID.frame changedValue:CGRectGetMaxY(birthDate.frame) type:RectChangeTypeY];
    
    //phoneNumber
    [phoneNumber updateViewsWithInformationString:@"Phone number:" text:model.itemPhoneNumber actionBtnImage:@"personcenter_cell_packageserve"];
    phoneNumber.frame = [self getRectWithRect:phoneNumber.frame changedValue:CGRectGetMaxY(emailID.frame) type:RectChangeTypeY];
    
    //anniversaryDate
    [anniversaryDate updateViewsWithInformationString:@"Anniversary date:" text:model.itemAnniversaryDate actionBtnImage:@"personcenter_cell_packageserve"];
    anniversaryDate.frame = [self getRectWithRect:anniversaryDate.frame changedValue:CGRectGetMaxY(phoneNumber.frame) type:RectChangeTypeY];

    //communication
    [communication updateViewsWithInformationString:@"Preferred mode of communication" actionBtnImage:@"personcenter_cell_packageserve"];
    communication.frame = [self getRectWithRect:communication.frame changedValue:CGRectGetMaxY(anniversaryDate.frame) type:RectChangeTypeY];
    
    //payment
    [payment updateViewsWithInformationString:model.itemPayment actionBtnImage:@"personcenter_cell_packageserve"];
    payment.frame = [self getRectWithRect:payment.frame changedValue:CGRectGetMaxY(communication.frame) type:RectChangeTypeY];
    
    //language
    [language updateViewsWithInformationString:@"Preferred language" actionBtnImage:@"personcenter_cell_packageserve"];
    language.frame = [self getRectWithRect:language.frame changedValue:CGRectGetMaxY(payment.frame) type:RectChangeTypeY];

    //=====
    saveButton.frame = [self getRectWithRect:saveButton.frame changedValue:CGRectGetMaxY(language.frame)+10 type:RectChangeTypeY];
    
    self.frame = CGRectMake(0, 0, self.frame.size.width, CGRectGetMaxY(saveButton.frame));
}

- (CGRect)getRectWithRect:(CGRect)rect changedValue:(float)value type:(RectChangeType)type{
    CGRect frame;
    switch (type) {
        case RectChangeTypeX:
            frame = CGRectMake(value, rect.origin.y, rect.size.width, rect.size.height);
            break;
        case RectChangeTypeY:
            frame = CGRectMake(rect.origin.x, value, rect.size.width, rect.size.height);
            break;
        case RectChangeTypeWidh:
            frame = CGRectMake(rect.origin.x, rect.origin.y, value, rect.size.height);
            break;
        case RectChangeTypeHeight:
            frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, value);
            break;
    }
    return frame;
}

@end


@implementation ContainTwoLabelsView
@synthesize informationLabel,informationTextLabel;

- (void)dealloc{
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
        [self initViews];
    }
    return self;
}

- (void)initViews{
    informationLabel = [CommonUtils labelWithFrame:CGRectMake(LABEL_LEFT_INTERVAL, (self.bounds.size.height - LABEL_HEIGHT)/2.0, LABEL_WIDTH, LABEL_WIDTH) text:@"" textColor:[RTSSAppStyle currentAppStyle].textMajorColor textFont:[UIFont systemFontOfSize:FONT_SIZE] tag:0];
    informationLabel.backgroundColor = [UIColor clearColor];
    informationLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:informationLabel];
    
    informationTextLabel = [CommonUtils labelWithFrame:CGRectMake(CGRectGetMaxX(informationLabel.frame)+LABEL_LEFT_INTERVAL, (self.bounds.size.height - LABEL_HEIGHT)/2.0, LABEL_WIDTH, LABEL_HEIGHT) text:@"" textColor:[RTSSAppStyle currentAppStyle].textSubordinateColor textFont:[UIFont systemFontOfSize:FONT_SIZE] tag:0];
    informationTextLabel.backgroundColor = [UIColor clearColor];
    informationTextLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:informationTextLabel];
}


- (void)updateViewsWithInformationString:(NSString *)information text:(NSString *)text{

    //计算size
    CGSize size = CGSizeMake(300, MAXFLOAT);
    //informationLabel
    UIFont * font = [UIFont systemFontOfSize:FONT_SIZE];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize  actualsize = [information boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    informationLabel.frame = CGRectMake(informationLabel.frame.origin.x, informationLabel.frame.origin.y, actualsize.width, actualsize.height);
    informationLabel.text = information;
    
    //informationText
    size = CGSizeMake(self.bounds.size.width - actualsize.width - LABEL_LEFT_INTERVAL*3, MAXFLOAT);
    actualsize = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:dic context:nil].size;
    informationTextLabel.frame = CGRectMake(informationLabel.frame.origin.x + informationLabel.frame.size.width + LABEL_LEFT_INTERVAL, informationTextLabel.frame.origin.y,actualsize.width, actualsize.height);
    informationTextLabel.text = text;
    
    CGFloat height = informationTextLabel.frame.origin.y + informationTextLabel.frame.size.height + (self.bounds.size.height - LABEL_HEIGHT)/2.0;
    
    //lineImage
    UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, height > VIEW_HEIGHT ? height-2 : VIEW_HEIGHT-2, self.bounds.size.width, 2)];
    line.image = [UIImage imageNamed:@"common_separator_line"];
    [self addSubview:line];
    [line release];

    // ==
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height > VIEW_HEIGHT ? height : VIEW_HEIGHT);
}


@end

@implementation ContainLabelAndTextFieldAndButtonView
@synthesize informationLabel,textField,imageView,actionBtn;

- (void)dealloc{
    [textField release];
    [imageView release];
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
        self.userInteractionEnabled = YES;
        [self initViews];
    }
    return self;
}

- (void)initViews{
    // ==
    informationLabel = [CommonUtils labelWithFrame:CGRectMake(LABEL_LEFT_INTERVAL, (self.bounds.size.height - LABEL_HEIGHT)/2.0, LABEL_WIDTH, LABEL_HEIGHT) text:@"" textColor:[RTSSAppStyle currentAppStyle].textMajorColor textFont:[UIFont systemFontOfSize:FONT_SIZE] tag:0];
    informationLabel.backgroundColor = [UIColor clearColor];
    informationLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:informationLabel];
    
    // ==
    textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(informationLabel.frame)+10, (self.bounds.size.height - LABEL_HEIGHT)/2.0,self.bounds.size.width - informationLabel.frame.size.width - LABEL_LEFT_INTERVAL * 4 - IMAGEVIEW_WIDTH, IMAGEVIEW_HEIGHT)];
    textField.backgroundColor = [UIColor clearColor];
    textField.font = [UIFont systemFontOfSize:FONT_SIZE];
    textField.textColor = [RTSSAppStyle currentAppStyle].textSubordinateColor;
    textField.textAlignment = NSTextAlignmentLeft;
    [self addSubview:textField];
    
    // ==
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width - IMAGEVIEW_WIDTH - LABEL_LEFT_INTERVAL, (self.bounds.size.height - IMAGEVIEW_HEIGHT)/2.0, IMAGEVIEW_WIDTH, IMAGEVIEW_HEIGHT)];
    imageView.image = [UIImage imageNamed:nil];
    [self addSubview:imageView];
    
    // ==
    actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = self.bounds;
    [self addSubview:actionBtn];
}

- (void)updateViewsWithInformationString:(NSString *)information text:(NSString *)text actionBtnImage:(NSString *)image{
    //计算size
    CGSize size = CGSizeMake(300, MAXFLOAT);
    
    //informationLabel
    UIFont * font = [UIFont systemFontOfSize:FONT_SIZE];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    CGSize  actualsize = [information boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:dic context:nil].size;
    informationLabel.frame = CGRectMake(informationLabel.frame.origin.x, informationLabel.frame.origin.y, actualsize.width, actualsize.height);
    informationLabel.text = information;

    //textField
    size = CGSizeMake(self.bounds.size.width - actualsize.width - LABEL_LEFT_INTERVAL*2, MAXFLOAT);
    actualsize = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:dic context:nil].size;
    textField.frame = CGRectMake(informationLabel.frame.origin.x + informationLabel.frame.size.width + LABEL_LEFT_INTERVAL, textField.frame.origin.y, size.width, actualsize.height);
    textField.text = text;

    //imageView
    imageView.image = [UIImage imageNamed:image];
    
    //lineImage
    UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-2, self.bounds.size.width, 2)];
    line.image = [UIImage imageNamed:@"common_separator_line"];
    [self addSubview:line];
    [line release];
}

@end

@implementation ContainLabelAndButton
@synthesize informationLabel,imageView,actionBtn;

- (void)dealloc{
    [imageView release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [RTSSAppStyle currentAppStyle].viewControllerBgColor;
        self.userInteractionEnabled = YES;
        [self initViews];
    }
    return self;
}

- (void)initViews{
    // ==
    informationLabel = [CommonUtils labelWithFrame:CGRectMake(LABEL_LEFT_INTERVAL, (self.bounds.size.height - LABEL_HEIGHT)/2.0, self.bounds.size.width - IMAGEVIEW_WIDTH - 3 * LABEL_LEFT_INTERVAL, LABEL_HEIGHT) text:@"" textColor:[RTSSAppStyle currentAppStyle].textMajorColor textFont:[UIFont systemFontOfSize:FONT_SIZE] tag:0];
    informationLabel.backgroundColor = [UIColor clearColor];
    informationLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:informationLabel];
    
    // ==
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width - IMAGEVIEW_WIDTH - LABEL_LEFT_INTERVAL, (self.bounds.size.height - IMAGEVIEW_HEIGHT)/2.0, IMAGEVIEW_WIDTH, IMAGEVIEW_HEIGHT)];
    [self addSubview:imageView];
    
    // ==
    actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = self.bounds;
    [self addSubview:actionBtn];
    
    // ==
    UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 2, self.bounds.size.width, 2)];
    line.image = [UIImage imageNamed:@"common_separator_line"];
    [self addSubview:line];
    [line release];
}

- (void)updateViewsWithInformationString:(NSString *)information actionBtnImage:(NSString *)image{
    informationLabel.text = information;
    imageView.image = [UIImage imageNamed:image];
}


@end

@implementation MyProfileModelItem
@synthesize itemName,itemBillingAdress,itemEmailID,itemPayment,itemAnniversaryDate,itemBirthDate,itemPhoneNumber,itemCommunication,itemLanguage;

- (void)dealloc{
    [itemName release];
    [itemBillingAdress release];
    [itemEmailID release];
    [itemPayment release];
    [itemAnniversaryDate release];
    [itemBirthDate release];
    [itemPhoneNumber release];
    [itemCommunication release];
    [itemLanguage release];
    
    [super dealloc];
}

@end