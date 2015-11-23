//
//  OrderPreviewViewController.h
//  RTSS
//
//  Created by 加富董 on 14/11/28.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "BasicViewController.h"

@class ProductOffer;
@class Product;

typedef NS_ENUM(NSInteger, PurchaseType) {
    PurchaseTypeProduct,
    PurchaseTypeProductOffer,
};

@interface OrderPreviewViewController : BasicViewController

@property (nonatomic,retain) NSString *serviceId;
@property (nonatomic,assign) PurchaseType purchaseType;
@property (nonatomic,retain) id product;

@end
