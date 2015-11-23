//
//  RSAUtil.m
//  RTSS
//
//  Created by Lyu Ming on 11/6/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//


#import <Security/Security.h>

#import "RSAUtil.h"
#import "GTMBase64.h"


@implementation RSAUtil

+ (NSDictionary*)generateRSAKeyPair {
    NSMutableDictionary* keyPair = [NSMutableDictionary dictionaryWithCapacity:0];
    
    @try {
        SecKeyRef publicKey = NULL;
        SecKeyRef privateKey = NULL;
        
        NSMutableDictionary* keyPairAttr = [NSMutableDictionary dictionaryWithCapacity:0];
        [keyPairAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
        [keyPairAttr setObject:[NSNumber numberWithInt:1024] forKey:(__bridge id)kSecAttrKeySizeInBits];
        
        if (errSecSuccess == SecKeyGeneratePair((__bridge CFDictionaryRef)keyPairAttr, &publicKey, &privateKey)) {
            [keyPair setObject:(__bridge id)publicKey forKey:@"PUBLIC_KEY"];
            CFRelease(publicKey);
            
            [keyPair setObject:(__bridge id)privateKey forKey:@"PRIVATE_KEY"];
            CFRelease(privateKey);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"RSAUtil::generateRSAKeyPair:exception=%@", [exception debugDescription]);
    }
    
    return keyPair;
}

+ (SecKeyRef)extractPublicKey:(NSString *)base64EncodedCertificate {
    SecKeyRef publicKey = NULL;
    
    @try {
        NSData* certificateData = [GTMBase64 decodeString:base64EncodedCertificate];
        if (nil != certificateData) {
            SecCertificateRef certificate = SecCertificateCreateWithData(kCFAllocatorDefault, (CFDataRef)certificateData);
            
            SecTrustRef trust = NULL;
            SecPolicyRef policy = SecPolicyCreateBasicX509();
            if (errSecSuccess == SecTrustCreateWithCertificates(certificate, policy, &trust)) {
                SecTrustResultType evaluateResult = 0;
                SecTrustEvaluate(trust, &evaluateResult);
                
                publicKey = SecTrustCopyPublicKey(trust);
                
                CFRelease(trust);
            }
            
            CFRelease(policy);
            CFRelease(certificate);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"RSAUtil::extractPublicKey:exception=%@", [exception debugDescription]);
    }
    
    return publicKey;
}

+ (NSString*)wrapPublicKey:(SecKeyRef)publicKey {
    NSString* base64EncodedPublicKey = nil;
    
    @try {
        NSLog(@"RSAUtil::wrapPublicKey:publicKey=%@", [(__bridge NSData*)publicKey description]);
        
        char buffer[162] = "\0";
        // SEQ {
            buffer[0] = 0x30; // SEQ 00 1 10000
            buffer[1] = 0x81; // LEN in long-form (1 byte)
            buffer[2] = 0x9F; // LEN=159 bytes
        
            // SEQ {
                buffer[3] = 0x30; // SEQ 00 1 10000
                buffer[4] = 0x0D; // LEN in short-form, LEN=13 bytes
        
                buffer[5] = 0x06; // OBJECT IDENTIFIER 00 0 00006
                buffer[6] = 0x09; // LEN in short-form, LEN=9 bytes
                buffer[7] = 0x2A; // OID=2A 86 48 86 F7 0D 01 01 01
                buffer[8] = 0x86;
                buffer[9] = 0x48;
                buffer[10] = 0x86;
                buffer[11] = 0xF7;
                buffer[12] = 0x0D;
                buffer[13] = 0x01;
                buffer[14] = 0x01;
                buffer[15] = 0x01;
        
                buffer[16] = 0x05; // NULL 00 0 00000
                buffer[17] = 0x00; // LEN in short-form, LEN=0 bytes
            // }
        
            buffer[18] = 0x03; // BIT STRING 00 0 00011
            buffer[19] = 0x81; // LEN in long-form (1 byte)
            buffer[20] = 0x8D; // LEN=141 bytes
            buffer[21] = 0x00; // Padding bits: 0
        
            // SEQ {
                buffer[22] = 0x30; // SEQ 00 1 10000
                buffer[23] = 0x81; // LEN in long-form (1 byte)
                buffer[24] = 0x89; // LEN=137 bytes
        
                buffer[25] = 0x02; // INTEGER 00 0 00010
                buffer[26] = 0x81; // LEN in long-form (1 byte)
                buffer[27] = 0x81; // LEN=129 bytes
                buffer[28] = 0x00;
        
                // Value in public-key, 128 bytes
        
                buffer[157] = 0x02; // INTEGER 00 0 00010
                buffer[158] = 0x03; // LEN in short-form, LEN=3 bytes
                buffer[159] = 0x01;
                buffer[160] = 0x00;
                buffer[161] = 0x01;
            // }
        // }
        
        const char* p = (const char*)publicKey + 24;
        for (int i=128; i>0; i--) {
            buffer[29 + 128 - i] = p[i-1];
        }
        
        base64EncodedPublicKey = [GTMBase64 stringByEncodingData:[NSData dataWithBytes:buffer length:162]];
        NSLog(@"RSAUtil::wrapPublicKey:base64EncodedPublicKey=%@", base64EncodedPublicKey);
    }
    @catch (NSException *exception) {
        NSLog(@"RSAUtil::wrapPublicKey:exception=%@", [exception debugDescription]);
    }
    
    return base64EncodedPublicKey;
}

+ (NSData*)encrypt:(NSData*)plainData key:(SecKeyRef)key {
    NSData* encryptedData = nil;
    
    @try {
        size_t blockSize = SecKeyGetBlockSize(key);
        
        uint8_t* buffer = (uint8_t*)malloc(blockSize);
        memset(buffer, 0x00, blockSize);
        
        size_t pieceSize = blockSize - 11;
        size_t pieceCount = (size_t)ceil([plainData length] * 1.0 / pieceSize);
        
        NSMutableData* resultData = [NSMutableData dataWithCapacity:0];
        for (int i=0; i<pieceCount; i++) {
            NSData* pieceData = [plainData subdataWithRange:NSMakeRange(pieceSize * i, (i == pieceCount - 1) ? [plainData length] - pieceSize * i : pieceSize)];
            
            size_t encryptedPieceSize = blockSize;
            if (errSecSuccess == SecKeyEncrypt(key, kSecPaddingPKCS1, (const uint8_t*)[pieceData bytes], [pieceData length], buffer, &encryptedPieceSize)) {
                NSData* encryptedPieceData = [NSData dataWithBytes:(const void*)buffer length:encryptedPieceSize];
                [resultData appendData:encryptedPieceData];
            }
        }
        free(buffer);
        
        encryptedData = resultData;
    }
    @catch (NSException *exception) {
        NSLog(@"RSAUtil::encrypt:exception=%@", [exception debugDescription]);
    }
    
    return encryptedData;
}

+ (NSData*)decrypt:(NSData*)data key:(SecKeyRef)key {
    NSData* plainData = nil;
    
    @try {
        size_t blockSize = SecKeyGetBlockSize(key);
        
        size_t bufferSize = [data length];
        uint8_t* buffer = (uint8_t*)malloc(bufferSize);
        memset(buffer, 0x00, bufferSize);
        
        OSStatus s = errSecSuccess;
        if (errSecSuccess == (s = SecKeyDecrypt(key, kSecPaddingPKCS1, (const uint8_t*)[data bytes], blockSize, buffer, &bufferSize))) {
            plainData = [NSData dataWithBytes:buffer length:bufferSize];
        }
        free(buffer);
    }
    @catch (NSException *exception) {
        NSLog(@"RSAUtil::decrypt:exception=%@", [exception debugDescription]);
    }
    
    return plainData;
}

@end
