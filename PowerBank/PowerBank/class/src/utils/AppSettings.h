//
//  AppSettings.h
//  FSFTownFinancial
//
//  Created by yujiuyin on 14-7-23.
//  Copyright (c) 2014年 yujiuyin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WMUserModel;
@class WMAliyunTokenModel;

#define USERNAME_KEY @"userloginname"
#define USERPWD_LEY @"userpwd"

#define GOTOHOMEPAGE    @"gotohomepage"
#define STRINGKEY_DEVICE_ID @"key0412"              //设备号

@interface AppSettings : NSObject
{
    NSUserDefaults* userDefaults;
}

+ (AppSettings *)sharedInstance;


- (void)setInteger:(NSInteger)value forKey:(NSString *)keyName;
- (void)setFloat:(float)value forKey:(NSString *)keyName;
- (void)setDouble:(double)value forKey:(NSString *)keyName;
- (void)setBool:(BOOL)value forKey:(NSString *)keyName;
- (void)setString:(NSString *)value forKey:(NSString *)keyName;
- (void)setURL:(NSURL *)value forKey:(NSString *)keyName;
- (void)setDate:(NSDate*)value forkey:(NSString *)keyName;

- (NSString *)stringForKey:(NSString *)keyName;
- (NSInteger)integerForKey:(NSString *)keyName;
- (float)floatForKey:(NSString *)keyName;
- (double)doubleForKey:(NSString *)keyName;
- (BOOL)boolForKey:(NSString *)keyName;
- (NSURL *)urlForKey:(NSString *)keyName;
- (NSDate*)dateForKey:(NSString *)keyName;
- (void)removeObjectForKey:(NSString *)defaultName;
// 个人数据
- (WMUserModel *)loginObject;
// 个人信息保存到本地
-(void)loginsaveCache:(WMUserModel *)model;
/** 保存alikeyobject */
- (void)aliKeySaveCache:(WMAliyunTokenModel *)model;
/** 获取alikeyobject */
- (WMAliyunTokenModel *)alikeyObject;

//照相机权限判断
- (BOOL)isCameraAuthority;
+ (BOOL)checkIsLogin;
+ (BOOL)checkIsCertification;
@end
