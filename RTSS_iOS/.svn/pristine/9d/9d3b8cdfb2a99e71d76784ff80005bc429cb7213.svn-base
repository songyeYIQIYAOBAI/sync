//
//  TransationBaseTableViewCell+BussinessLogic.h
//  RTSS
//
//  Created by 蔡杰Alan on 15-2-3.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "TransationBaseTableViewCell.h"

#import "ProductResource.h"
#import "PriceRuleItem.h"

#import "ITransferable.h"
#import "ProductOffer.h"



@interface TransationBaseTableViewCell (BussinessLogic)

-(void)transationTableViewCellBind_PiceNegotiationModel:(ProductResource*)model;

-(void)transationTableViewCellBind_PiceNegotiationModel:(ProductResource*)model Rule:(PriceRuleItem*)ruleItem;

-(void)transationTableViewCellBind_TransferModel:(ProductResource*)model;

//-(void)transationTableViewCellBind_TransferFormModel:(ProductResource*)model;

//=====

//议价
-(void)transationTableViewCellBind_PiceNegotiationModelWithTitle:(NSString *)title Array:(NSArray*)productOffers;

//TransferFormModel
-(void)transationTableViewCellBind_TransferFormModel:(id<ITransferable>)model;

//=============宋野============//
-(void)transationTableViewCellBind_TransferItemModel:(id <ITransferable> )item;
//=============宋野============//



@end
