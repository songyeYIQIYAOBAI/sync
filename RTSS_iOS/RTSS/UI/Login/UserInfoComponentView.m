//
//  UserInfoComponentView.m
//  EasyTT
//
//  Created by shengyp on 14-10-10.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import "UserInfoComponentView.h"

#import "CommonUtils.h"
#import "ImageUtils.h"
#import "RTSSAppStyle.h"

@interface TimerButton()

@property(nonatomic, assign) NSInteger           countDown;
@property(nonatomic, retain) NSTimer*            buttonTimer;
@property(nonatomic, retain) NSString*           titleText;
@property(nonatomic, retain) NSString*           resendText;

@end

@implementation TimerButton
@synthesize countDown, buttonTimer, titleText,resendText;

- (void)dealloc
{
    [self stop];
    
    [titleText release];
    [resendText release];
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.countDown = 60;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        [self setTitleColor:[RTSSAppStyle currentAppStyle].textMajorColor forState:UIControlStateNormal];
        [self setTitleColor:[RTSSAppStyle currentAppStyle].textMajorColor forState:UIControlStateHighlighted];
        [self setTitleColor:[RTSSAppStyle currentAppStyle].textMajorColor forState:UIControlStateSelected];
        self.titleLabel.font = [RTSSAppStyle getRTSSFontWithSize:12];
    }
    return self;
}

- (void)start
{
    self.countDown    = 60;
    self.buttonTimer  = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(buttonTimerEmptyProgress:) userInfo:nil repeats:YES];
}

- (void)start:(NSString*)title resend:(NSString*)resendTitle
{
    if(nil != self.buttonTimer && [self.buttonTimer isValid]){
        return;
    }
    
    self.titleText      = title;
    self.resendText     = resendTitle;
    self.countDown      = 60;
    self.buttonTimer    = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(buttonTimerProgress:) userInfo:nil repeats:YES];
}

- (BOOL)isStart{
    if(nil != self.buttonTimer && [self.buttonTimer isValid]){
        return YES;
    }else{
        return NO;
    }
}

- (void)stop
{
    if(nil != self.buttonTimer && [self.buttonTimer isValid]){
        [self.buttonTimer invalidate];
        self.buttonTimer = nil;
    }
}

- (void)stop:(NSString*)resendTitle
{
    [self stop];
    self.resendText = resendTitle;
    [self setTitle:self.resendText forState:UIControlStateNormal];
}

- (void)buttonTimerProgress:(NSTimer*)timer
{
    self.countDown -= 1;
    
    [self setTitle:[NSString stringWithFormat:@"%@(%d)",self.titleText, self.countDown] forState:UIControlStateNormal];
    
    if(0 == self.countDown){
        
        [self stop];
        
        [self setTitle:self.resendText forState:UIControlStateNormal];
    }
}

- (void)buttonTimerEmptyProgress:(NSTimer*)timer
{
    self.countDown -= 1;
    
    if(0 == self.countDown){
        [self stop];
    }
}

@end

@interface UserInfoItemView()

@end

#define InfoItemErrorLabelHeight        25

@implementation UserInfoItemView
@synthesize itemTitleLabel,itemValueLabel,itemErrorLabel,itemTextField,itemButton,itemHelpButton,isSeparate,currentStyle,itemSeparateImage;
@synthesize itemTitleText;
@synthesize expanding;

- (void)dealloc
{
	[itemTextField release];
	[itemButton release];
    [itemHelpButton release];
	
	[spaceLineView release];
	
	[super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
        expanding = NO;
		currentStyle = UserInfoItemViewStyleDefault;
		[self layoutContentView];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame style:(UserInfoItemViewStyle)style
{
	self = [super initWithFrame:frame];
	if (self) {
        expanding = NO;
		currentStyle = style;
		[self layoutContentView];
	}
	return self;
}

- (void)layoutContentView
{
	isSeparate = YES;
    
    UIFont*         titleFont     = [RTSSAppStyle getRTSSFontWithSize:14.0];
    UIFont*         errorFont     = [RTSSAppStyle getRTSSFontWithSize:12.0];
    
    CGFloat         margin        = 20;
    
    if(UserInfoItemViewStyleDefault == self.currentStyle || UserInfoItemViewStyleButton == self.currentStyle){
        
        // ===
        itemTitleLabel = [CommonUtils labelWithFrame:CGRectMake(margin, 0, self.bounds.size.width-2*margin, self.bounds.size.height) text:@"" textColor:[RTSSAppStyle currentAppStyle].textMajorColor textFont:titleFont tag:0];
        itemTitleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:itemTitleLabel];
        
        // ===
        itemValueLabel = [CommonUtils labelWithFrame:CGRectMake(margin, 0, self.bounds.size.width-2*margin, self.bounds.size.height) text:@"" textColor:[RTSSAppStyle currentAppStyle].textSubordinateColor textFont:titleFont tag:0];
        itemValueLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:itemValueLabel];
        
        // ===
        if(UserInfoItemViewStyleButton == self.currentStyle){
            itemValueLabel.frame = CGRectMake(margin, 0, self.bounds.size.width-30-2*margin, self.bounds.size.height);
            
            itemButton = [[UIButton alloc] initWithFrame:self.bounds];
            itemButton.backgroundColor = [UIColor clearColor];
            [self addSubview:itemButton];
        }
    }else if(UserInfoItemViewStyleTextFieldIn == self.currentStyle ||
             UserInfoItemViewStyleTextFieldOut == self.currentStyle ||
             UserInfoItemViewStyleTextFieldInWithButton == self.currentStyle ||
             UserInfoItemViewStyleTextFieldOutWithButton == self.currentStyle){
        
        CGRect textTilteFrame = CGRectZero;
        CGRect textErrorFrame = CGRectZero;
        CGRect textFieldFrame = CGRectZero;
        CGRect textButtonFrame = CGRectZero;
        CGRect textHelpFrame = CGRectZero;
        if(UserInfoItemViewStyleTextFieldIn == self.currentStyle ||
           UserInfoItemViewStyleTextFieldInWithButton == self.currentStyle){
            textFieldFrame = CGRectMake(margin, 0, self.bounds.size.width-2*margin, self.bounds.size.height);
            if(UserInfoItemViewStyleTextFieldInWithButton == self.currentStyle){
                textButtonFrame = self.bounds;
            }
        }else if(UserInfoItemViewStyleTextFieldOut == self.currentStyle ||
                 UserInfoItemViewStyleTextFieldOutWithButton == self.currentStyle){
            textHelpFrame = CGRectMake(margin, 0, 30, 30);
            textTilteFrame = CGRectMake(margin, 0, self.bounds.size.width-2*margin, 30);
            textErrorFrame = CGRectMake(margin, CGRectGetMaxY(textTilteFrame)-5, self.bounds.size.width-2*margin, InfoItemErrorLabelHeight);
            textFieldFrame = CGRectMake(margin, CGRectGetMaxY(textTilteFrame), self.bounds.size.width-2*margin, 34);
            if(UserInfoItemViewStyleTextFieldOutWithButton == self.currentStyle){
                textButtonFrame = CGRectMake(self.bounds.size.width-margin-83, CGRectGetMaxY(textTilteFrame), 83, 34);
                textFieldFrame  = CGRectMake(margin, CGRectGetMaxY(textTilteFrame), CGRectGetMinX(textButtonFrame)-2*margin, 34);
            }
        }
        
        if(!CGRectEqualToRect(CGRectZero, textTilteFrame)){
            itemTitleLabel = [CommonUtils labelWithFrame:textTilteFrame text:@"" textColor:[RTSSAppStyle currentAppStyle].textMajorColor textFont:titleFont tag:0];
            itemTitleLabel.textAlignment = NSTextAlignmentLeft;
            [self addSubview:itemTitleLabel];
        }
        
        if(!CGRectEqualToRect(CGRectZero, textErrorFrame)){
            itemErrorLabel = [CommonUtils labelWithFrame:textErrorFrame text:@"" textColor:[RTSSAppStyle currentAppStyle].userInfoComponentErrorColor textFont:errorFont tag:0];
            itemErrorLabel.backgroundColor = [UIColor clearColor];
            itemErrorLabel.textAlignment = NSTextAlignmentLeft;
            itemErrorLabel.adjustsFontSizeToFitWidth = YES;
            [self addSubview:itemErrorLabel];
        }
        
        if(!CGRectEqualToRect(CGRectZero, textFieldFrame)){
            itemTextField = [[UITextField alloc] initWithFrame:textFieldFrame];
            itemTextField.backgroundColor = [RTSSAppStyle currentAppStyle].textFieldBgColor;
            itemTextField.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
            itemTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            itemTextField.clearButtonMode = UITextFieldViewModeNever;
            itemTextField.font = titleFont;
            [self addSubview:itemTextField];
        }
        
        if(!CGRectEqualToRect(CGRectZero, textButtonFrame)){
            if(UserInfoItemViewStyleTextFieldOutWithButton == self.currentStyle){
                itemButton = [[TimerButton alloc] initWithFrame:textButtonFrame];
                [itemButton setBackgroundImage:[ImageUtils createImageWithColor:[RTSSAppStyle currentAppStyle].buttonMajorColor size:textButtonFrame.size] forState:UIControlStateNormal];
                [self addSubview:itemButton];
            }else{
                itemButton = [[UIButton alloc] initWithFrame:textButtonFrame];
                itemButton.backgroundColor = [UIColor clearColor];
                [self addSubview:itemButton];
            }
        }
        if(!CGRectContainsRect(CGRectZero, textHelpFrame)){
            if(UserInfoItemViewStyleTextFieldOut == self.currentStyle){
                itemHelpButton = [[UIButton alloc] initWithFrame:textHelpFrame];
                
                // ====
                UIView* circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
                circleView.layer.masksToBounds = YES;
                circleView.layer.cornerRadius = circleView.frame.size.height/2.0;
                circleView.backgroundColor = [RTSSAppStyle currentAppStyle].buttonMajorColor;
                UIImage* helpImage = [ImageUtils convertViewToImage:circleView];
                [circleView release];
                
                // ====
                UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textHelpFrame.size.width, textHelpFrame.size.height)];
                textLabel.font = [RTSSAppStyle getRTSSFontWithSize:15.0];
                textLabel.textColor = [RTSSAppStyle currentAppStyle].textMajorColor;
                textLabel.textAlignment = NSTextAlignmentCenter;
                textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
                textLabel.numberOfLines = 1;
                textLabel.text = @"?";
                [itemHelpButton addSubview:textLabel];
                [textLabel release];
                
                [itemHelpButton setImage:helpImage forState:UIControlStateNormal];
                [itemHelpButton setImage:helpImage forState:UIControlStateHighlighted];
                itemHelpButton.hidden = YES;
                [self addSubview:itemHelpButton];
            }
        }
    }

	spaceLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-1, self.bounds.size.width, 1)];
    spaceLineView.backgroundColor = [RTSSAppStyle currentAppStyle].separatorColor;
	spaceLineView.hidden = !isSeparate;
	[self addSubview:spaceLineView];
}

- (void)setSeparate:(BOOL)aSeparate
{
	isSeparate = aSeparate;
	
	spaceLineView.hidden = !isSeparate;
}

- (void)setItemSeparateImage:(UIImage *)separateImage
{
    if(nil != separateImage){
        spaceLineView.frame = CGRectMake(0, self.bounds.size.height-1, self.bounds.size.width, 1);
        spaceLineView.image = separateImage;
    }
}

- (void)setItemTitleText:(NSString*)text
{
    if(nil != text && text.length > 0 && nil != itemHelpButton && NO == itemHelpButton.hidden){
        self.itemTitleLabel.text = text;
        CGSize textSize = [CommonUtils calculateTextSize:text constrainedSize:CGSizeMake(MAXFLOAT, itemTitleLabel.bounds.size.height) textFont:itemTitleLabel.font lineBreakMode:NSLineBreakByWordWrapping];
        CGRect itemHelpButtonFrame = itemHelpButton.frame;
        itemHelpButtonFrame.origin.x += textSize.width;
        itemHelpButton.frame = itemHelpButtonFrame;
    }
}

- (void)refreshItemViewFrame{
    expanding = !expanding;
    
    CGRect itemFrame            = self.frame;
    CGRect textFieldFrame       = self.itemTextField.frame;
    CGRect buttonFrame          = self.itemButton.frame;
    CGRect lineFrame            = spaceLineView.frame;
    if(expanding){
        itemFrame.size.height       += InfoItemErrorLabelHeight;
        textFieldFrame.origin.y     += InfoItemErrorLabelHeight;
        buttonFrame.origin.y        += InfoItemErrorLabelHeight;
        lineFrame.origin.y          += InfoItemErrorLabelHeight;
        
        self.itemErrorLabel.hidden  = NO;
    }else{
        itemFrame.size.height       -= InfoItemErrorLabelHeight;
        textFieldFrame.origin.y     -= InfoItemErrorLabelHeight;
        buttonFrame.origin.y        -= InfoItemErrorLabelHeight;
        lineFrame.origin.y          -= InfoItemErrorLabelHeight;
        
        self.itemErrorLabel.hidden  = YES;
        self.itemErrorLabel.text    = @"";
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame                  = itemFrame;
        self.itemTextField.frame    = textFieldFrame;
        self.itemButton.frame       = buttonFrame;
        spaceLineView.frame         = lineFrame;
    }];
}

@end


@interface UserInfoComponentView()

@property (nonatomic, retain) NSMutableArray*       itemViewArray;

@end

@implementation UserInfoComponentView
@synthesize mdnItemView,pwItemView,userNameItemView,otpItemView,oldPwItemView,lastPwItemView,confirmPwItemView;
@synthesize currentType,itemViewArray;

- (void)dealloc
{
	[mdnItemView release];
	[pwItemView release];
	[userNameItemView release];
    [otpItemView release];
	[oldPwItemView release];
	[lastPwItemView release];
	[confirmPwItemView release];
    
    [itemViewArray release];
	
	[super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		currentType = UserInfoComponentViewTypeLogin;
		[self layoutContentView];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame type:(UserInfoComponentViewType)type
{
	self = [super initWithFrame:frame];
	if (self) {
		currentType = type;
		[self layoutContentView];
	}
	return self;
}

- (NSMutableAttributedString*)getAttributed:(NSString*)text
{
    NSMutableAttributedString* attributedString = [[[NSMutableAttributedString alloc] initWithString:text] autorelease];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[RTSSAppStyle currentAppStyle].textFieldPlaceholderColor range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSFontAttributeName value:[RTSSAppStyle currentAppStyle].textFieldPlaceholderFont range:NSMakeRange(0, attributedString.length)];
    return attributedString;
}

- (void)setLayoutStyle:(UserInfoComponentViewType)type
{
    if(UserInfoComponentViewTypeLogin == type){
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [RTSSAppStyle currentAppStyle].textFieldBorderColor.CGColor;
        self.backgroundColor = [RTSSAppStyle currentAppStyle].userInfoComponentBgColor;
    }else {
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 0;
        self.layer.borderWidth = 0;
        self.layer.borderColor = nil;
        self.backgroundColor = [RTSSAppStyle currentAppStyle].userInfoComponentBgColor;
    }
}

- (void)setTextFieldStyle:(UserInfoItemView*)infoItemView placeholder:(NSMutableAttributedString*)placeholder keyboardType:(UIKeyboardType)keyboardType returnKeyType:(UIReturnKeyType)returnKeyType secureTextEntry:(BOOL)secureTextEntry{
    if(nil != infoItemView && nil != infoItemView.itemTextField){
        infoItemView.itemTextField.backgroundColor = [RTSSAppStyle currentAppStyle].textFieldBgColor;
        infoItemView.itemTextField.layer.cornerRadius = 5;
        infoItemView.itemTextField.layer.borderWidth = 1;
        infoItemView.itemTextField.layer.borderColor = [RTSSAppStyle currentAppStyle].textFieldBorderColor.CGColor;
        infoItemView.itemTextField.leftViewMode = UITextFieldViewModeAlways;
        infoItemView.itemTextField.leftView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)] autorelease];
        infoItemView.itemTextField.attributedPlaceholder = placeholder;
        infoItemView.itemTextField.keyboardType = keyboardType;
        infoItemView.itemTextField.returnKeyType = returnKeyType;
        infoItemView.itemTextField.secureTextEntry = secureTextEntry;
    }
}

- (void)layoutContentView
{
    self.itemViewArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    [self setLayoutStyle:currentType];
    
    CGRect tempFrame = self.frame;
    
	if(currentType == UserInfoComponentViewTypeLogin){
		CGFloat itemWidth = self.bounds.size.width;
		CGFloat itemHeight = self.bounds.size.height/2.0;
		
		// ==
		userNameItemView = [[UserInfoItemView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemHeight)
														style:UserInfoItemViewStyleTextFieldIn];
        userNameItemView.itemTextField.backgroundColor = [UIColor clearColor];
		userNameItemView.itemTextField.keyboardType = UIKeyboardTypeDefault;
		userNameItemView.itemTextField.returnKeyType = UIReturnKeyNext;
		userNameItemView.itemTextField.attributedPlaceholder = [self getAttributed:NSLocalizedString(@"UserInfoView_User_ID_holder", nil)];
		[self addSubview:userNameItemView];
        [self.itemViewArray addObject:userNameItemView];
		
		// ==
		pwItemView = [[UserInfoItemView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(userNameItemView.frame),itemWidth,itemHeight)
													   style:UserInfoItemViewStyleTextFieldIn];
		pwItemView.isSeparate = NO;
        pwItemView.itemTextField.backgroundColor = [UIColor clearColor];
		pwItemView.itemTextField.keyboardType = UIKeyboardTypeDefault;
		pwItemView.itemTextField.returnKeyType = UIReturnKeyDone;
		pwItemView.itemTextField.secureTextEntry = YES;
		pwItemView.itemTextField.attributedPlaceholder = [self getAttributed:NSLocalizedString(@"UserInfoView_User_PW_holder", nil)];
		[self addSubview:pwItemView];
        [self.itemViewArray addObject:pwItemView];
        
    }else if(currentType == UserInfoComponentViewTypeForgotUserID){
        CGFloat itemWidth               = self.bounds.size.width;
        CGFloat itemHeight              = 82;
        
        // ==
        userNameItemView = [[UserInfoItemView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemHeight)
                                                             style:UserInfoItemViewStyleTextFieldOut];
        userNameItemView.itemTitleLabel.text = NSLocalizedString(@"UserInfoView_User_ID_Label", nil);
        [self setTextFieldStyle:userNameItemView placeholder:[self getAttributed:NSLocalizedString(@"UserInfoView_User_ID_Enter_Holder", nil)]
                   keyboardType:UIKeyboardTypeDefault
                  returnKeyType:UIReturnKeyDone
                secureTextEntry:NO];
        [self addSubview:userNameItemView];
        [self.itemViewArray addObject:userNameItemView];
        
        // ==
        tempFrame.size.height = CGRectGetMaxY(userNameItemView.frame);
        
    }else if(currentType == UserInfoComponentViewTypeForgotOTP){
        CGFloat itemWidth               = self.bounds.size.width;
        CGFloat itemHeight              = 82;
        
        // ==
        otpItemView = [[UserInfoItemView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemHeight)
                                                        style:UserInfoItemViewStyleTextFieldOutWithButton];
        otpItemView.itemTitleLabel.text = NSLocalizedString(@"UserInfoView_OTP_Label", nil);
        [self setTextFieldStyle:otpItemView placeholder:[self getAttributed:NSLocalizedString(@"UserInfoView_OTP_Enter_Holder", nil)]keyboardType:UIKeyboardTypeNumberPad returnKeyType:UIReturnKeyNext secureTextEntry:NO];
        [self addSubview:otpItemView];
        [self.itemViewArray addObject:otpItemView];
        
        // ==
        lastPwItemView = [[UserInfoItemView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(otpItemView.frame), itemWidth, itemHeight)
                                                           style:UserInfoItemViewStyleTextFieldOut];
        lastPwItemView.itemHelpButton.hidden = NO;
        lastPwItemView.itemTitleText = NSLocalizedString(@"UserInfoView_New_PW_Label", nil);
        [self setTextFieldStyle:lastPwItemView placeholder:[self getAttributed:NSLocalizedString(@"UserInfoView_New_PW_Enter_Holder", nil)] keyboardType:UIKeyboardTypeDefault returnKeyType:UIReturnKeyNext secureTextEntry:YES];
        [self addSubview:lastPwItemView];
        [self.itemViewArray addObject:lastPwItemView];
        
        // ==
        confirmPwItemView = [[UserInfoItemView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastPwItemView.frame), itemWidth, itemHeight)
                                                              style:UserInfoItemViewStyleTextFieldOut];
        confirmPwItemView.itemTitleLabel.text = NSLocalizedString(@"UserInfoView_Confirm_PW_Label", nil);
        [self setTextFieldStyle:confirmPwItemView placeholder:[self getAttributed:NSLocalizedString(@"UserInfoView_Confirm_PW_Enter_Holder", nil)] keyboardType:UIKeyboardTypeDefault returnKeyType:UIReturnKeyDone secureTextEntry:YES];
        [self addSubview:confirmPwItemView];
        [self.itemViewArray addObject:confirmPwItemView];
        
        // ==
        tempFrame.size.height = CGRectGetMaxY(confirmPwItemView.frame);
        
    }else if(currentType == UserInfoComponentViewTypeModifPw){
		CGFloat itemWidth               = self.bounds.size.width;
        CGFloat itemHeight              = 82;
        
        // ==
        oldPwItemView = [[UserInfoItemView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemHeight)
                                                          style:UserInfoItemViewStyleTextFieldOut];
        oldPwItemView.itemTitleLabel.text = NSLocalizedString(@"UserInfoView_Old_PW_Label", nil);
        [self setTextFieldStyle:oldPwItemView placeholder:[self getAttributed:NSLocalizedString(@"UserInfoView_Old_PW_Enter_Holder", nil)] keyboardType:UIKeyboardTypeDefault returnKeyType:UIReturnKeyNext secureTextEntry:YES];
        [self addSubview:oldPwItemView];
        [self.itemViewArray addObject:oldPwItemView];
        
        // ==
        lastPwItemView = [[UserInfoItemView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(oldPwItemView.frame), itemWidth, itemHeight)
                                                           style:UserInfoItemViewStyleTextFieldOut];
        lastPwItemView.itemHelpButton.hidden = NO;
        lastPwItemView.itemTitleText = NSLocalizedString(@"UserInfoView_New_PW_Label", nil);
        [self setTextFieldStyle:lastPwItemView placeholder:[self getAttributed:NSLocalizedString(@"UserInfoView_New_PW_Enter_Holder", nil)] keyboardType:UIKeyboardTypeDefault returnKeyType:UIReturnKeyNext secureTextEntry:YES];
        [self addSubview:lastPwItemView];
        [self.itemViewArray addObject:lastPwItemView];
        
        // ==
        confirmPwItemView = [[UserInfoItemView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastPwItemView.frame), itemWidth, itemHeight)
                                                              style:UserInfoItemViewStyleTextFieldOut];
        confirmPwItemView.itemTitleLabel.text = NSLocalizedString(@"UserInfoView_Confirm_PW_Label", nil);
        [self setTextFieldStyle:confirmPwItemView placeholder:[self getAttributed:NSLocalizedString(@"UserInfoView_Confirm_PW_Enter_Holder", nil)] keyboardType:UIKeyboardTypeDefault returnKeyType:UIReturnKeyDone secureTextEntry:YES];
        [self addSubview:confirmPwItemView];
        [self.itemViewArray addObject:confirmPwItemView];
        
        // ==
        tempFrame.size.height = CGRectGetMaxY(confirmPwItemView.frame);
        
    }else if(currentType == UserInfoComponentViewTypeRequestOTP){
        CGFloat itemWidth               = self.bounds.size.width;
        CGFloat itemHeight              = 82;
        
        // ==
        userNameItemView = [[UserInfoItemView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemHeight)
                                                             style:UserInfoItemViewStyleTextFieldOut];
        userNameItemView.itemTitleLabel.text = NSLocalizedString(@"UserInfoView_User_ID_Label", nil);
        [self setTextFieldStyle:userNameItemView placeholder:[self getAttributed:NSLocalizedString(@"UserInfoView_Request_OTP_Enter_Holder", nil)] keyboardType:UIKeyboardTypeDefault returnKeyType:UIReturnKeyNext secureTextEntry:NO];
        [self addSubview:userNameItemView];
        [self.itemViewArray addObject:userNameItemView];
        
        // ==
        mdnItemView = [[UserInfoItemView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(userNameItemView.frame), itemWidth, itemHeight)
                                                        style:UserInfoItemViewStyleTextFieldOut];
        mdnItemView.itemTitleLabel.text = NSLocalizedString(@"UserInfoView_MDN_Label", nil);
        [self setTextFieldStyle:mdnItemView placeholder:[self getAttributed:NSLocalizedString(@"UserInfoView_MDN_Enter_Holder", nil)] keyboardType:UIKeyboardTypeNumberPad returnKeyType:UIReturnKeyDone secureTextEntry:NO];
        [self addSubview:mdnItemView];
        [self.itemViewArray addObject:mdnItemView];
        
        UILabel* leftLabel = [CommonUtils labelWithFrame:CGRectMake(0, 0, 35, itemHeight-3) text:NSLocalizedString(@"UserInfoView_MDN_Country_Code", nil) textColor:[RTSSAppStyle currentAppStyle].textMajorColor textFont:[UIFont systemFontOfSize:14.0] tag:0];
        mdnItemView.itemTextField.leftViewMode = UITextFieldViewModeAlways;
        mdnItemView.itemTextField.leftView = leftLabel;
        
        // ==
        tempFrame.size.height = CGRectGetMaxY(mdnItemView.frame);
        
    }else if(currentType == UserInfoComponentViewTypeActivation){
        CGFloat itemWidth               = self.bounds.size.width;
        CGFloat itemHeight              = 82;
        
        // ==
        otpItemView = [[UserInfoItemView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemHeight)
                                                        style:UserInfoItemViewStyleTextFieldOutWithButton];
        otpItemView.itemTitleLabel.text = NSLocalizedString(@"UserInfoView_OTP_Label", nil);
        [self setTextFieldStyle:otpItemView placeholder:[self getAttributed:NSLocalizedString(@"UserInfoView_OTP_Enter_Holder", nil)] keyboardType:UIKeyboardTypeNumberPad returnKeyType:UIReturnKeyNext secureTextEntry:NO];
        [self addSubview:otpItemView];
        [self.itemViewArray addObject:otpItemView];
        
        // ==
        userNameItemView = [[UserInfoItemView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(otpItemView.frame), itemWidth, itemHeight)
                                                             style:UserInfoItemViewStyleTextFieldOutWithButton];
        userNameItemView.itemTitleLabel.text = NSLocalizedString(@"UserInfoView_New_User_ID_Label", nil);
        [self setTextFieldStyle:userNameItemView placeholder:[self getAttributed:NSLocalizedString(@"UserInfoView_New_User_ID_Enter_Holder", nil)] keyboardType:UIKeyboardTypeDefault returnKeyType:UIReturnKeyNext secureTextEntry:NO];
        [self addSubview:userNameItemView];
        [self.itemViewArray addObject:userNameItemView];
        
        // ==
        lastPwItemView = [[UserInfoItemView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(userNameItemView.frame), itemWidth, itemHeight)
                                                           style:UserInfoItemViewStyleTextFieldOut];
        lastPwItemView.itemHelpButton.hidden = NO;
        lastPwItemView.itemTitleText = NSLocalizedString(@"UserInfoView_New_PW_Label", nil);
        [self setTextFieldStyle:lastPwItemView placeholder:[self getAttributed:NSLocalizedString(@"UserInfoView_New_PW_Enter_Holder", nil)] keyboardType:UIKeyboardTypeDefault returnKeyType:UIReturnKeyNext secureTextEntry:YES];
        [self addSubview:lastPwItemView];
        [self.itemViewArray addObject:lastPwItemView];
        
        // ==
        confirmPwItemView = [[UserInfoItemView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastPwItemView.frame), itemWidth, itemHeight)
                                                              style:UserInfoItemViewStyleTextFieldOut];
        confirmPwItemView.itemTitleLabel.text = NSLocalizedString(@"UserInfoView_Confirm_PW_Label", nil);
        [self setTextFieldStyle:confirmPwItemView placeholder:[self getAttributed:NSLocalizedString(@"UserInfoView_Confirm_PW_Enter_Holder", nil)] keyboardType:UIKeyboardTypeDefault returnKeyType:UIReturnKeyDone secureTextEntry:YES];
        [self addSubview:confirmPwItemView];
        [self.itemViewArray addObject:confirmPwItemView];
        
        // ==
        tempFrame.size.height = CGRectGetMaxY(confirmPwItemView.frame);
        
    }
    
    self.frame = tempFrame;
}

- (void)refreshInfoComponentView:(UserInfoItemView*)itemView completion:(void (^)(BOOL finished))completion{
    
    for (UserInfoItemView* view in self.itemViewArray) {
        if(view == itemView && NO == view.expanding){
            [view refreshItemViewFrame];
        }else if(view != itemView && YES == view.expanding){
            [view refreshItemViewFrame];
        }
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect currentFrame  = self.frame;
        
        for (int i = 0; i < [self.itemViewArray count]; i ++) {
            UserInfoItemView* itemView = [self.itemViewArray objectAtIndex:i];
            CGRect itemFrameTemp = itemView.frame;
            if(i > 0){
                UserInfoItemView* prevView = [self.itemViewArray objectAtIndex:i-1];
                itemFrameTemp.origin.y = CGRectGetMaxY(prevView.frame);
            }
            itemView.frame = itemFrameTemp;
            
            if(i == [self.itemViewArray count]-1){
                currentFrame.size.height = CGRectGetMaxY(itemView.frame);
                self.frame = currentFrame;
            }
        }
    } completion:^(BOOL finished) {
        if(completion){
            completion(finished);
        }
    }];
}

- (BOOL)showUserInfoComponentKeyboard{
    BOOL result = YES;
    if([mdnItemView.itemTextField isFirstResponder]){
        [mdnItemView.itemTextField becomeFirstResponder];
    }else if([pwItemView.itemTextField isFirstResponder]){
        [pwItemView.itemTextField becomeFirstResponder];
    }else if([oldPwItemView.itemTextField isFirstResponder]){
        [oldPwItemView.itemTextField becomeFirstResponder];
    }else if([lastPwItemView.itemTextField isFirstResponder]){
        [lastPwItemView.itemTextField becomeFirstResponder];
    }else if([confirmPwItemView.itemTextField isFirstResponder]){
        [confirmPwItemView.itemTextField becomeFirstResponder];
    }else if(userNameItemView.itemTextField.isFirstResponder){
        [userNameItemView.itemTextField becomeFirstResponder];
    }else if(otpItemView.itemTextField.isFirstResponder){
        [otpItemView.itemTextField becomeFirstResponder];
    }else {
        result = NO;
    }
    return result;
}

- (BOOL)dismissUserInfoComponentKeyboard{
    BOOL result = YES;
    if([mdnItemView.itemTextField isFirstResponder]){
        [mdnItemView.itemTextField resignFirstResponder];
    }else if([pwItemView.itemTextField isFirstResponder]){
        [pwItemView.itemTextField resignFirstResponder];
    }else if([oldPwItemView.itemTextField isFirstResponder]){
        [oldPwItemView.itemTextField resignFirstResponder];
    }else if([lastPwItemView.itemTextField isFirstResponder]){
        [lastPwItemView.itemTextField resignFirstResponder];
    }else if([confirmPwItemView.itemTextField isFirstResponder]){
        [confirmPwItemView.itemTextField resignFirstResponder];
    }else if(userNameItemView.itemTextField.isFirstResponder){
        [userNameItemView.itemTextField resignFirstResponder];
    }else if(otpItemView.itemTextField.isFirstResponder){
        [otpItemView.itemTextField resignFirstResponder];
    }else{
        result = NO;
    }
    return result;
}

@end
