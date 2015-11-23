//
//  Session.m
//  RTSS
//
//  Created by Lyu Ming on 11/24/14.
//  Copyright (c) 2014 shengyp. All rights reserved.
//

#import "Session.h"
#import "UserDefaults.h"


#define __OFFER_LIVE_TIME__ 24 * 60 * 60

static Session* _instance = nil;

@interface Session () {
    NSMutableDictionary* _productOffers;
    NSMutableDictionary* _offerRegistry;
    
    NSMutableDictionary* _slaProductOffers;
    NSMutableDictionary* _slaOfferRegistry;
    
    NSMutableDictionary* _offerDetails;
    NSMutableDictionary* _detailRegistry;
}

@end

@implementation Session

@synthesize mMyUser;
@synthesize mMyCustomer;

@synthesize mCurrentAccount;
@synthesize mCurrentSubscriber;

@synthesize mToken;
@synthesize mJToken;

@synthesize mTransferables;

+ (Session*)sharedSession {
    @synchronized (self) {
        if (nil == _instance) {
            _instance = [[Session alloc] init];
        }
    }
    
    return _instance;
}

+ (void)destroySession {
    @synchronized (self) {
        [_instance release];
        _instance = nil;
    }
}

- (id)init {
    if (self = [super init]) {
        _productOffers = [[NSMutableDictionary alloc] initWithCapacity:0];
        _offerRegistry = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        _slaProductOffers = [[NSMutableDictionary alloc] initWithCapacity:0];
        _slaOfferRegistry = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        _offerDetails = [[NSMutableDictionary alloc] initWithCapacity:0];
        _detailRegistry = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    
    return self;
}

- (void)setMyUser:(User *)user {
    if (nil == mMyUser) {
        mMyUser = [user retain];
    } else if (nil != mMyUser.mId && YES == [mMyUser.mId isEqualToString:user.mId]) {
        mMyUser.mPassword = user.mPassword;
    } else {
        [mMyUser release];
        mMyUser = [user retain];
    }
}

- (void)dealloc {
    [_productOffers release];
    [_offerRegistry release];
    
    [_slaProductOffers release];
    [_slaOfferRegistry release];
    
    [_offerDetails release];
    [_detailRegistry release];
    
    [mMyUser release];
    [mMyCustomer release];
    
    [mCurrentAccount release];
    [mCurrentSubscriber release];
    
    [mToken release];
    [mJToken release];
    
    [mTransferables release];
    
    [super dealloc];
}

- (void)load {
    @try {
        NSDictionary* sessionInfo = (NSDictionary*)[[UserDefaults standardUserDefaults] getObjectForKey:@"sessionInfo" cipher:YES];
        
        NSString* token = [sessionInfo objectForKey:@"token"];
        if (nil != token) {
            NSLog(@"Session::load:token=%@", token);
            self.mToken = token;
        }
        NSString *jToken = [sessionInfo objectForKey:@"jToken"];
        if (nil != jToken) {
            self.mJToken = jToken;
        }
        
        NSDictionary* userInfo = [sessionInfo objectForKey:@"user"];
        if (nil != userInfo) {
            NSLog(@"Session::load:userInfo=%@", [userInfo description]);

            NSString* userId = [userInfo objectForKey:@"userId"];
            NSString* username = [userInfo objectForKey:@"username"];
            NSString* portrait = [userInfo objectForKey:@"portrait"];
            NSString* phoneNumber = [userInfo objectForKey:@"phoneNumber"];
            NSString* email = [userInfo objectForKey:@"email"];
            long createTime = [[userInfo objectForKey:@"createTime"] longValue];
            
            User* user = [[User alloc] init];
            user.mId = userId;
            user.mName = username;
            user.mPortrait = portrait;
            user.mPhoneNumber = phoneNumber;
            user.mEmail = email;
            
            self.mMyUser = user;
            [user release];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Session::load:exception=%@", [exception description]);
    }
}

- (void)save {
    @try {
        NSDictionary* savedSessionInfo = (NSDictionary*)[[UserDefaults standardUserDefaults] getObjectForKey:@"sessionInfo" cipher:YES];
        NSMutableDictionary* sessionInfo = nil;
        if (nil == savedSessionInfo) {
            sessionInfo = [NSMutableDictionary dictionaryWithCapacity:0];
        } else {
            sessionInfo = [NSMutableDictionary dictionaryWithDictionary:savedSessionInfo];
        }
        
        if (nil != self.mToken) {
            [sessionInfo setObject:self.mToken forKey:@"token"];
        }
        if (nil != self.mJToken) {
            [sessionInfo setObject:self.mJToken forKey:@"jToken"];
        }
        
        if (nil != self.mMyUser) {
            NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithCapacity:0];
            [userInfo setObject:(nil != self.mMyUser.mId ? self.mMyUser.mId : @"") forKey:@"userId"];
            [userInfo setObject:(nil != self.mMyUser.mName ? self.mMyUser.mName : @"") forKey:@"username"];
            [userInfo setObject:(nil != self.mMyUser.mPortrait ? self.mMyUser.mPortrait : @"") forKey:@"portrait"];
            [userInfo setObject:(nil != self.mMyUser.mPhoneNumber ? self.mMyUser.mPhoneNumber : @"") forKey:@"phoneNumber"];
            [userInfo setObject:(nil != self.mMyUser.mEmail ? self.mMyUser.mEmail : @"") forKey:@"email"];
            NSLog(@"Session::save:userInfo=%@", [userInfo description]);
            
            [sessionInfo setObject:userInfo forKey:@"user"];
        }
        
        [[UserDefaults standardUserDefaults] setObject:sessionInfo forKey:@"sessionInfo" cipher:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"Session::save:exception=%@", [exception description]);
    }
}

- (NSArray*)getProductOffers:(NSString*)serviceType forType:(int)type {
    NSArray* productOffers = nil;
    
    @try {
        if (1 == type) {
            if (nil != [_offerRegistry objectForKey:serviceType]) {
                long timestamp = [[_offerRegistry objectForKey:serviceType] longValue];
                
                if (__OFFER_LIVE_TIME__ > (time(NULL) - timestamp)) {
                    productOffers = [_productOffers objectForKey:serviceType];
                }
            }
        } else if (2 == type) {
            if (nil != [_slaOfferRegistry objectForKey:serviceType]) {
                long timestamp = [[_slaOfferRegistry objectForKey:serviceType] longValue];
                
                if (__OFFER_LIVE_TIME__ > (time(NULL) - timestamp)) {
                    productOffers = [_slaProductOffers objectForKey:serviceType];
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Session::getProductOffers:exception=%@", [exception description]);
    }
    
    return productOffers;
}

- (void)setProductOffers:(NSArray*)productOffers withServiceType:(NSString*)serviceType forType:(int)type {
    @try {
        if (1 == type) {
            [_productOffers setObject:productOffers forKey:serviceType];
            [_offerRegistry setObject:[NSNumber numberWithLong:time(NULL)] forKey:serviceType];
        } else if (2 == type) {
            [_slaProductOffers setObject:productOffers forKey:serviceType];
            [_slaOfferRegistry setObject:[NSNumber numberWithLong:time(NULL)] forKey:serviceType];
        }
        
//        [self save];
    }
    @catch (NSException *exception) {
        NSLog(@"Session::setProductOffers:exception=%@", [exception description]);
    }
}

- (NSDictionary*)getProductOfferDetail:(NSString*)offerId {
    NSDictionary* offerDetail = nil;
    
    @try {
        if (nil != [_detailRegistry objectForKey:offerId]) {
            long timestamp = [[_detailRegistry objectForKey:offerId] longValue];
            if (__OFFER_LIVE_TIME__ > time(NULL) - timestamp) {
                offerDetail = [_offerDetails objectForKey:offerId];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Session::getProductOfferDetail:exception=%@", [exception description]);
    }
    
    return offerDetail;
}

- (void)setProductOfferDetail:(NSDictionary*)offerDetail withOfferId:(NSString*)offerId {
    @try {
        [_offerDetails setObject:offerDetail forKey:offerId];
        [_detailRegistry setObject:[NSNumber numberWithLong:time(NULL)] forKey:offerId];
        
//        [self save];
    }
    @catch (NSException *exception) {
        NSLog(@"Session::setProductOfferDetail:exception=%@", [exception description]);
    }
}

@end
