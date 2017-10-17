//
//  CommonDefine.h
//  PowerBank
//
//  Created by wangmiao on 2017/6/19.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#ifndef CommonDefine_h
#define CommonDefine_h

#endif /* CommonDefine_h */

// ************************************************服务器配置******************************************************
// 开发环境的baseurl
#define PRODUCTION_URL_BASE @""
// 生产环境的baseurl
//#define DEVELOPMENT_URL_BASE @"https://api.ool.vc"
#define DEVELOPMENT_URL_BASE @"http://test.ool.vc"
// ************************************************各种key********************************************************
// 高德地图的key
#define AMAPKEY @"6a937d0608c26a62a71ae1d956c6149a"
// 阿里推送的key
#define ALIPUSHKEY @"24587519"
#define ALIPUSHSECRET @"3b94afbf719623a0c820f4f119d1c51d"
// 微信开发平台的key
#define WXAPPID @"wx12e743044c820675"

//请求返回的msg码
#define Request_Success_Code 200

//请求成功 condition
#define REQUEST_SUCCESS(dic) [dic[KRequest_Msg] integerValue] == Request_Success_Code

// ************************************************功能型**********************************************************
// 屏幕宽高及常用尺寸
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;
#define NavigationBar_HEIGHT 44.0f
#define TabBar_HEIGHT 49.0f
#define StatusBar_HEIGHT 20.0f
#define ToolsBar_HEIGHT 44.0f

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define DominantColor [UIColor whiteColor]

// 带有RGBA的颜色设置
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
#define ThemeColor RGBA(245, 245, 245, 1.0f)
#define ThemeBarTextColor [UIColor colorWithHexString:@"#414141"]


#define Font(F) [UIFont systemFontOfSize:(F)]
// 开发状态的打印
#ifdef DEBUG
#define NSLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define NSLog(...)
#endif
// 字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
#define FormatterString(str) [NSString stringWithFormat:@"%@",str]
// 数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
// 字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
// 是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))
// 创建单例
#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
  \
   static classname *shared##classname = nil; \
  \
  + (classname *)shared##classname \
   { \
      @synchronized(self) \
      { \
          if (shared##classname == nil) \
              { \
                  shared##classname = [self alloc] init]; \
                  } \
          } \
      \
      return shared##classname; \
      } \
  \
  + (id)allocWithZone:(NSZone *)zone \
  { \
      @synchronized(self) \
      { \
          if (shared##classname == nil) \
              { \
                  shared##classname = [super allocWithZone:zone]; \
                 return shared##classname; \
                  } \
          } \
      \
      return nil; \
      } \
  \
  - (id)copyWithZone:(NSZone *)zone \
  { \
      return self;  \
    }
// ************************************************系统型**********************************************************
// 常用的系统常量缩写
#define kApplication [UIApplication sharedApplication]
#define kKeyWindow [UIApplication sharedApplication].keyWindow
#define kAppDelegate [UIApplication sharedApplication].delegate
#define TheAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define kUserDefaults [NSUserDefaults standardUserDefaults]
#define kNotificationCenter [NSNotificationCenter defaultCenter]

// APP版本号
 #define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
// 系统版本号
#define kSystemVersion [[UIDevice currentDevice] systemVersion]
// 获取当前语言
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
// 判断是否为iPhone
#define kISiPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
// 判断是否为iPad
#define kISiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
// ***********************************************文件操作**************************************************************
// 获取沙盒Document路径
#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
// 获取沙盒Cache路径
#define kCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

//------------------手机型号判断----------------------//
#define IS_IPHONE   [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )480) < DBL_EPSILON )
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )568) < DBL_EPSILON )
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )667) < DBL_EPSILON )
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )960) < DBL_EPSILON )

































