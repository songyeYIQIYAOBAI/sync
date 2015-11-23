//
//  RASUtilTest.m
//  RTSS
//
//  Created by Lyu Ming on 11/6/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "RSAUtil.h"
#import "GTMBase64.h"

@interface RASUtilTest : XCTestCase

@end

@implementation RASUtilTest

static NSString* certificate = @"MIIB1jCCAT+gAwIBAgIJALmkZQm+ZLXcMA0GCSqGSIb3DQEBBQUAMC0xCzAJBgNVBAYTAkdCMQ8wDQYDVQQHEwZMb25kb24xDTALBgNVBAMTBFRlc3QwHhcNMTQxMTA2MTA0MDMyWhcNMTQxMjA2MTA0MDMyWjAtMQswCQYDVQQGEwJHQjEPMA0GA1UEBxMGTG9uZG9uMQ0wCwYDVQQDEwRUZXN0MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCl04N1p1c1y9TBa1/E2XFFj1Fk6z8ifljdP1MFC4L1Un1WFG3fg2V5iVYpIOxCH1OedANPp1q94b9PIKMta7oMWfq0YzOnum6wumh2uz0mSDuhgfa3Hlq9kTanSjT7/PG5opSD9a0h39XeRGzcXXaXssf1vtAwyx5Np08MyPlHvwIDAQABMA0GCSqGSIb3DQEBBQUAA4GBAFi6pJu4n1MZmO1LCdRm0isYFywMiF/Ie7QX4KXUjVAL5FdwEpIFWWYchebEBGAIrvR3XUhVNsfAX+BH496WDdNVcU/rgCfCIl4LAnlJ1dNY3pGmp7Vr66GlO2ALrjbfnLb3I9z2s4Ms2NvYjgRon2/cIBP5wgbFV3bntdSfeiR3";

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    for (int i=0; i<10; i++) {
        sleep(1);
    }
    
    [super tearDown];
}

- (void)testGenerateRSAKeyPair {
    NSDictionary* keyPair = [RSAUtil generateRSAKeyPair];
    NSLog(@"keyPair=%@", [keyPair description]);
}

- (void)testExtractPublicKey {
    SecKeyRef publicKey = [RSAUtil extractPublicKey:certificate];
    NSLog(@"publicKey=%@", [(id)publicKey description]);
}

- (void)testWrapPublicKey {
    NSDictionary* keyPair = [RSAUtil generateRSAKeyPair];
    SecKeyRef publicKey = (__bridge SecKeyRef)[keyPair objectForKey:@"PUBLIC_KEY"];
    [RSAUtil wrapPublicKey:publicKey];
}

- (void)testEncryptAndDecrypt {
    NSDictionary* keyPair = [RSAUtil generateRSAKeyPair];
    SecKeyRef publicKey = (__bridge SecKeyRef)[keyPair objectForKey:@"PUBLIC_KEY"];
    SecKeyRef privateKey = (__bridge SecKeyRef)[keyPair objectForKey:@"PRIVATE_KEY"];
    
    NSString* data = @"中文abc 123\ndef";
    
    const char* buffer = data.UTF8String;
    NSData* plainData = [NSData dataWithBytes:buffer length:strlen(buffer)];
    NSData* encryptedData = [RSAUtil encrypt:plainData key:publicKey];
    NSLog(@"encryptedData=%@", [GTMBase64 stringByEncodingData:encryptedData]);
    
    NSData* decryptedData = [RSAUtil decrypt:encryptedData key:privateKey];
    NSString* checkData = [NSString stringWithUTF8String:[decryptedData bytes]];
    NSLog(@"checkData=%@", checkData);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
