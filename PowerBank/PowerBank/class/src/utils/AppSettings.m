//
//  AppSettings.m
//  FSFTownFinancial
//
//  Created by yujiuyin on 14-7-23.
//  Copyright (c) 2014年 yujiuyin. All rights reserved.
//

#import "AppSettings.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "WMUserModel.h"
#import "WMAliyunTokenModel.h"

@implementation AppSettings

static AppSettings *sharedAppSettings = nil;

+ (AppSettings *)sharedInstance
{
    @synchronized(self){
        if(sharedAppSettings == nil){
            sharedAppSettings = [self new];
        }
    }
    return sharedAppSettings;
}

- (id)init
{
    if (self = [super init]) {
        userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}


#pragma mark - 设置
- (void)setInteger:(NSInteger)value forKey:(NSString *)keyName
{
    [userDefaults setInteger:value forKey:keyName];
    [userDefaults synchronize];
}
- (void)setFloat:(float)value forKey:(NSString *)keyName
{
    [userDefaults setFloat:value forKey:keyName];
    [userDefaults synchronize];
}
- (void)setDouble:(double)value forKey:(NSString *)keyName
{
    [userDefaults setDouble:value forKey:keyName];
    [userDefaults synchronize];
}
- (void)setBool:(BOOL)value forKey:(NSString *)keyName
{
    [userDefaults setBool:value forKey:keyName];
    [userDefaults synchronize];
}
- (void)setString:(NSString *)value forKey:(NSString *)keyName
{
    [userDefaults setObject:value forKey:keyName];
    [userDefaults synchronize];
}
- (void)setURL:(NSURL *)value forKey:(NSString *)keyName
{
    [userDefaults setURL:value forKey:keyName];
    [userDefaults synchronize];
}
- (void)setDate:(NSDate*)value forkey:(NSString *)keyName{
    [userDefaults setObject:value forKey:keyName];
    [userDefaults synchronize];
}

- (NSString *)stringForKey:(NSString *)keyName
{
    NSString *defValue = nil;
    if (![userDefaults objectForKey:keyName]){
        
    }
    else{
        defValue = [userDefaults stringForKey:keyName];
    }
    return defValue;
}
- (NSInteger)integerForKey:(NSString *)keyName
{
    NSInteger defValue = 0;
    if (![userDefaults objectForKey:keyName]) {
        // TODO 添加其它默认参数

    }
    else{
        defValue = [userDefaults integerForKey:keyName];
    }
    return defValue;
}
- (float)floatForKey:(NSString *)keyName
{
    float defValue = 0.0f;
    // 在没有值的情况下设置默认值
    if (![userDefaults objectForKey:keyName]){
//        if ([keyName isEqualToString:FLOATKEY_ReaderBodyFontSize]){
//            defValue = kWebContentSize2;
//        }
        // TODO 添加其它默认参数
        
    }
    else{
        defValue = [userDefaults floatForKey:keyName];
    }
    return defValue;
}

- (double)doubleForKey:(NSString *)keyName
{
    double defValue = 0.0;
    if (![userDefaults objectForKey:keyName]){
        // TODO 添加其它默认参数
        
        
    }
    else{
        defValue = [userDefaults doubleForKey:keyName];
    }
    return defValue;
}
- (BOOL)boolForKey:(NSString *)keyName
{
    BOOL defValue = NO;
    if(![userDefaults objectForKey:keyName]){
        
    }
    else{
        defValue = [userDefaults boolForKey:keyName];
    }
    return defValue;
}

- (NSURL *)urlForKey:(NSString *)keyName
{
    NSURL *defValue = nil;
    
    if (![userDefaults objectForKey:keyName]) {
        // TODO 添加其它默认参数
        
        
    }
    else{
        defValue = [userDefaults URLForKey:keyName];
    }
    return defValue;
}

- (NSDate*)dateForKey:(NSString *)keyName{
    NSDate *defValue = nil;
    if (![userDefaults objectForKey:keyName]) {
        // TODO 添加其它默认参数
    }
    else{
        defValue = [userDefaults objectForKey:keyName];
    }
    return defValue;
}

-(NSString *)loadPath{
    NSLog(@"%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/data.login"]);
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/data.login"];
}

-(NSString *)loadAliKeyPath{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/data.alikey"];
}

/** 移除userdefaults里面的东西 */
- (void)removeObjectForKey:(NSString *)defaultName
{
    [userDefaults removeObjectForKey:defaultName];
}

/** 获取loginobject */
- (WMUserModel *)loginObject
{
    NSMutableData *data=[[NSMutableData alloc] initWithContentsOfFile:[self loadPath]];
    NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    WMUserModel *model = [unarchiver decodeObjectForKey:@"usermodel"];
    [unarchiver finishDecoding];
    
    if (model == nil) {
        model = [[WMUserModel alloc]init];
    }
    return model;
}

/** 保存loginobject */
- (void)loginsaveCache:(WMUserModel *)model
{
    NSMutableData *data=[[NSMutableData alloc] init];
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:model forKey:@"usermodel"];
    [archiver finishEncoding];
    [data writeToFile:[self loadPath] atomically:YES];
}

/** 保存alikeyobject */
- (void)aliKeySaveCache:(WMAliyunTokenModel *)model
{
    NSMutableData *data=[[NSMutableData alloc] init];
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:model forKey:@"AliyunTokenModel"];
    [archiver finishEncoding];
    [data writeToFile:[self loadAliKeyPath] atomically:YES];
}


/** 获取alikeyobject */
- (WMAliyunTokenModel *)alikeyObject
{
    NSMutableData *data=[[NSMutableData alloc] initWithContentsOfFile:[self loadAliKeyPath]];
    NSKeyedUnarchiver *unarchiver=[[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    WMAliyunTokenModel *model = [unarchiver decodeObjectForKey:@"AliyunTokenModel"];
    [unarchiver finishDecoding];
    
    if (model == nil) {
        model = [[WMAliyunTokenModel alloc]init];
    }
    return model;
}

- (BOOL)isCameraAuthority{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
        
        NSLog(@"相机权限受限");
        
        return NO;
        
    }
    return YES;
}

+ (BOOL)checkIsLogin
{
    NSString *login_key = @"login";
    NSString *isLogin = [[AppSettings sharedInstance] stringForKey:login_key];
    
    if (isLogin) {
        return YES;
    }
    return NO;
}


+ (BOOL)checkIsCertification
{
    NSString *isCertification = [[AppSettings sharedInstance] stringForKey:@"isCertification"];
    if (isCertification) {
        return YES;
    }
    return NO;
}

@end
