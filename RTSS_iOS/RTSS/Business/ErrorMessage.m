//
//  ErrorMessage.m
//  RTSS
//
//  Created by 蔡杰Alan on 14-12-10.
//  Copyright (c) 2014年 shengyp. All rights reserved.
//

#import "ErrorMessage.h"
#import "AlertController.h"

@interface ErrorMessage ()
@property(retain,nonatomic) NSDictionary *errorMapping;
@end

@implementation ErrorMessage
@synthesize errorMapping;
-(void)dealloc{
    [errorMapping release];
    [super dealloc];
}

+(instancetype)shareErrorMessage{
    
    static ErrorMessage *shareErrorMessage = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        shareErrorMessage = [[ErrorMessage alloc]init];
    });
    return shareErrorMessage;
}

-(instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        if (!self.errorMapping) {
           NSDictionary *dic = @{
                             @(-1):@"Network error",//@"Internal error",
                             @(-2):@"Network error",
                             @(-3):@"OTP Validation fails",
                             @(-4):@"UserId Duplicate",
                             @(-5):@"Network error"
                             };
            
            self.errorMapping = dic;
            
        }
        
    }
    
    return self;
}
-(instancetype)init2{
    
    self = [super init];
    
    if (self) {
        
        if (!self.errorMapping) {
            NSDictionary *dic = @{
                                   @(0):NSLocalizedString(@"ErroMessage_Status_0", nil),
                                   @(50000):NSLocalizedString(@"ErroMessage_Status_50000", nil),
                                   @(50001):NSLocalizedString(@"ErroMessage_Status_50001", nil),
                                   @(50067):NSLocalizedString(@"ErroMessage_Status_50067", nil),
                                   @(51001):NSLocalizedString(@"ErroMessage_Status_51001", nil),
                                   @(51002):NSLocalizedString(@"ErroMessage_Status_51002", nil),
                                   @(55001):NSLocalizedString(@"ErroMessage_Status_55001", nil),
                                   @(55004):NSLocalizedString(@"ErroMessage_Status_55004", nil),
                                   @(55005):NSLocalizedString(@"ErroMessage_Status_55005", nil),
                                   @(55011):NSLocalizedString(@"ErroMessage_Status_55011", nil),
                                   @(50066):NSLocalizedString(@"ErroMessage_Status_50066", nil),
                                   @(57005):NSLocalizedString(@"ErroMessage_Status_57005", nil),
                                   
                                  };
            
            self.errorMapping = dic;
            
        }
        
    }
    
    return self;
}


#pragma mark --Public
-(NSString *)errorMessageWith:(NSInteger)status{
    
    return self.errorMapping[@(status)]?self.errorMapping[@(status)] :NSLocalizedString(@"ErroMessage_Status_50000", nil);
}

-(BOOL)checkStatusIsError:(NSInteger)status AlertTitle:(NSString *)tiltle  inViewController:(UIViewController *)aViewController{
    
    BOOL isError = self.errorMapping[@(status)]? YES:NO;
    if (isError) {
        
        NSString *errorMessage = self.errorMapping[@(status)];
        [AlertController showSimpleAlertWithTitle:tiltle message:errorMessage buttonTitle:NSLocalizedString(@"UIAlertView_Confirm_String", nil) inViewController:aViewController];
    }
    
    return isError;
    
}

@end
