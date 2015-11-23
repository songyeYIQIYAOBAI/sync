//
//  InternationalControl.m
//  RTSS
//
//  Created by Liuxs on 15-1-29.
//  Copyright (c) 2015年 shengyp. All rights reserved.
//

#import "InternationalControl.h"

#define USERCONFIG_APP_LANGUAGE_KEY                                     @"USERCONFIG_APP_LANGUAGE"
#define USERCONFIG_APPLE_LANGUAGES_SYSTEM_KEY                           @"AppleLanguages"
#define USERCONFIG_APP_LPROJ_KEY                                        @"lproj"

static InternationalControl *internationalControl = nil;

@interface InternationalControl()
{
    NSUserDefaults *def;
}

@property (nonatomic, retain) NSBundle *bundle;

@end

@implementation InternationalControl
@synthesize bundle;

- (void)dealloc
{
    [bundle release];
    
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        def = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

+ (InternationalControl *)standerControl
{
    @synchronized(self){
        if(nil == internationalControl){
            internationalControl = [[InternationalControl alloc] init];
            [internationalControl initUserLanguage];
        }
    }
    return internationalControl;
}

- (BOOL)setString:(NSString*)text key:(NSString*)key
{
    [def setObject:text forKey:key];
    return [def synchronize];
}

- (id)getObjectForKey:(NSString*)key
{
    return [def objectForKey:key];
}

- (BOOL)setCurrentBundle:(NSString*)language
{
    BOOL result = NO;
    if(nil != language && language.length > 0){
        NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:USERCONFIG_APP_LPROJ_KEY];
        if(nil != path && path.length > 0){
            result = YES;
            self.bundle = [NSBundle bundleWithPath:path];
        }
        NSLog(@"InternationalControl-->BundlePath:%@",path);
    }
    return result;
}

- (NSBundle *)getCurrentBundle
{
    return self.bundle;
}

- (void)initUserLanguage
{
    NSString *language = [self getObjectForKey:USERCONFIG_APP_LANGUAGE_KEY];
    if(nil == language || language.length == 0){
        //获取系统当前语言版本(中文zh-Hans,英文en)
        NSArray* languages = [self getObjectForKey:USERCONFIG_APPLE_LANGUAGES_SYSTEM_KEY];
        if(nil != languages && [languages count] > 0){
            language = [languages objectAtIndex:0];
        }else{
            language = @"en";
        }
        [self setString:language key:USERCONFIG_APP_LANGUAGE_KEY];
    }
    
    [self setCurrentBundle:language];
}

- (NSString *)userLanguage
{
    return [self getObjectForKey:USERCONFIG_APP_LANGUAGE_KEY];
}

- (BOOL)setUserlanguage:(NSString *)language
{
    BOOL result = NO;
    if(nil != language && language.length > 0){
        //1.第一步改变bundle的值
        result = [self setCurrentBundle:language];
        if(result){
            //2.持久化
            result = [self setString:language key:USERCONFIG_APP_LANGUAGE_KEY];
        }
    }
    return result;
}

@end
