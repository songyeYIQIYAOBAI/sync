//
//  FindCommentCellFrame.h
//  RTSS
//
//  Created by Jaffer on 15/4/2.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FindItemCommentModel.h"

@interface FindCommentCellFrame : NSObject

@property (nonatomic, assign, readonly) CGRect commentFromIconRect;
@property (nonatomic, assign, readonly) CGRect commentFromNickRect;
@property (nonatomic, assign, readonly) CGRect commentDateRect;
@property (nonatomic, assign, readonly) CGRect commentContentRect;
@property (nonatomic, assign, readonly) CGRect commentSepRect;
@property (nonatomic, assign, readonly) CGFloat cellHeight;
@property (nonatomic, readonly) FindItemCommentModel *commentModel;

- (instancetype)initWithAvailalbeWidth:(CGFloat)width;

- (void)calculateViewFramesByCommentData:(FindItemCommentModel *)comment;

@end
