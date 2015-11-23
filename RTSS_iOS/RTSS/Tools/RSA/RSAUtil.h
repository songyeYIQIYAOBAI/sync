//
//  RSAUtil.h
//  RTSS
//
//  Created by Lyu Ming on 11/6/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSAUtil : NSObject

+ (NSDictionary*)generateRSAKeyPair;

+ (SecKeyRef)extractPublicKey:(NSString *)base64EncodedCertificate;
+ (NSString*)wrapPublicKey:(SecKeyRef)publicKey;

+ (NSData*)encrypt:(NSData*)plainData key:(SecKeyRef)key;
+ (NSData*)decrypt:(NSData*)data key:(SecKeyRef)key;

@end
