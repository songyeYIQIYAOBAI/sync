//
//  PasswordInputView.h
//  RTSS
//
//  Created by 蔡杰 on 14-11-3.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  PasswordInputViewDelegate<NSObject>

@end


@interface PasswordInputView : UIView

@property(assign,nonatomic)id<PasswordInputViewDelegate> delegate;

@property(nonatomic,copy)dispatch_block_t cancelBlock;


-(void)updateNumber:(NSString*)number;

-(void)deleteNumber;

@end
