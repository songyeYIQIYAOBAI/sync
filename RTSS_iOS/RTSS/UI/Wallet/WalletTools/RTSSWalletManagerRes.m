//
//  RTSSWalletManagerRes.m
//  EasyTT
//
//  Created by 蔡杰 on 14-10-23.
//  Copyright (c) 2014年 lvming. All rights reserved.
//

#import "RTSSWalletManagerRes.h"

@implementation RTSSWalletManagerRes

+(UIImage *)obtainComponentImageWithWalletType:(WalletType)aType{
    
    NSString *imageName;
    switch (aType) {
        case WalletType_Scan:
        {
            imageName = @"wallet_scan";
            break;
        }
            case WalletType_PaymentCode:
        {
             imageName = @"wallet_payment_code";
            break;
        }
            case WalletType_BalanceTransfer:
        {
            imageName = @"wallet_balance_transfer";
            break;
        }
            case WalletType_ServiceTopUp:
        {
            imageName = @"wallet_service_topup";

            break;
        }
            case WalletType_AccountTopUp:
        {
            imageName = @"wallet_account_topup";
           
            break;
        }
        case WalletType_Mybills:
        {
            imageName = @"wallet_MyBills";
            
            break;
        }
        case WalletType_MyCards:
        {
            imageName = @"wallet_bank_card";
            
            break;
        }
        case WalletType_InstallmentPlan:
        {
            imageName = @"wallet_InstallmentPlan";
            
            break;
        }
        default:
            break;
    }
    
    return [UIImage imageNamed:imageName];
}

+(NSString *)obtainComponentTitleWithWalletType:(WalletType)aType{
    
    
    NSString *title = nil;
    switch (aType) {
        case WalletType_Scan:
        {
            title = @"Scan";
            break;
        }
        case WalletType_PaymentCode:
        {
            title = @"Payment Code";
            break;
        }
        case WalletType_BalanceTransfer:
        {
            title = @"Balance Transfer";
            break;
        }
        case WalletType_ServiceTopUp:
        {
            title = @"Service Top Up";
            break;
        }
        case WalletType_AccountTopUp:
        {
            title = @"Account Top Up";
            break;
        }
        case WalletType_Mybills:
        {
            title = @"My bills";
            
            break;
        }
        case WalletType_MyCards:
        {
            title = @"My Cards";
            
            break;
        }
        case WalletType_InstallmentPlan:
        {
            title = @"Installment Plan";
            
            break;
        }
        default:
            break;
    }

    return [NSString stringWithFormat:@"%@",title];
}


+(NSString *)obtainClassNameWithType:(WalletType)aType{
    
    
    NSString *title = nil;
    switch (aType) {
        case WalletType_Scan:
        {
            title = @"Scan";
            break;
        }
        case WalletType_PaymentCode:
        {
            title = @"PayCode";
            break;
        }
        case WalletType_BalanceTransfer:
        {
            title = @"BalanceTransfer";
            break;
        }
        case WalletType_ServiceTopUp:
        {
            title = @"ServiceTopup";
            break;
        }
        case WalletType_AccountTopUp:
        {
            title = @"AcountTopup";
            break;
        }
        case WalletType_Mybills:
        {
            title = @"MyBills";
            
            break;
        }
        case WalletType_MyCards:
        {
            title = @"BankCardManage";
            
            break;
        }
        case WalletType_InstallmentPlan:
        {
            title = @"InstallmentPlan";
            
            break;
        }

        default:
            break;
    }
    
   // NSLog(@"title==%@",title);
    return [NSString stringWithFormat:@"%@ViewController",title];
}


@end
