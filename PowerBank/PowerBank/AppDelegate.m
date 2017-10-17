//
//  AppDelegate.m
//  PowerBank
//
//  Created by wangmiao on 2017/6/2.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "AppDelegate.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AFNetworking.h>
#import "LoginViewController.h"
#import "MainViewController.h"
#import "CustomNavigationController.h"
#import "WRNavigationBar.h"
#import "HcdGuideView.h"
#import <CloudPushSDK/CloudPushSDK.h>
#import <AlipaySDK/AlipaySDK.h>
#import <UserNotifications/UserNotifications.h>
#import <WXApi.h>
#import "WMUserModel.h"

@interface AppDelegate ()
{
    // iOS 10通知中心
    UNUserNotificationCenter *_notificationCenter;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 初始化key
    [self initAllKey];
    // 开启网络监听
    [self judgeNet];
    // 初始化rootView
    [self customRootViewController];
    
    //引导页
    [self showGuideView];
    /** 网络测试 */
//    AFNTools * manager = [AFNTools sharedManager];
//    [manager requestWithMethod:GET WithPath:@"Fans/GetHotLive?page=1" WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
//        NSLog(@"%@",dic);
//        
//    } WithFailurBlock:^(NSError *error) {
//        
//    }];
    // 初始化阿里云推送
    [self registerAPNS:application];
    [self initCloudPush];
    [self registerMessageReceive];
    [CloudPushSDK sendNotificationAck:launchOptions];
#warning 打开调试日志,上线建议关闭
    [CloudPushSDK turnOnDebug];
    // 初始化wechat pay
    [self initPay];
    
    return YES;
}

- (void)initPay
{
    BOOL wex = [WXApi registerApp:WXAPPID];
    NSLog(@"%d", wex);
}


- (void)initAllKey
{
    [AMapServices sharedServices].apiKey = AMAPKEY;
}

- (void)customRootViewController
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"loginsuccess" object:nil];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    MainViewController *vc = [[MainViewController alloc] init];
    CustomNavigationController * rootNav = [[CustomNavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = rootNav;
    [UIColor wr_setDefaultNavBarBarTintColor:[UIColor colorWithHexString:@"#f7f7f7"]];
    [UIColor wr_setDefaultNavBarTitleColor:[UIColor colorWithHexString:@"414141"]];
    [UIColor wr_setDefaultNavBarShadowImageHidden:YES];
    // 写入空的token
//    [[AppSettings sharedInstance] setString:@"" forKey:@"token"];
    UINavigationBar* bar = rootNav.navigationBar;
    if (bar)
    {
        [bar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                     [UIColor whiteColor],NSForegroundColorAttributeName,
                                     [UIFont boldSystemFontOfSize:20],NSFontAttributeName, nil]];
    }
    [self.window makeKeyAndVisible];
}

- (void)showGuideView{
    NSString *version_key = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    NSString *version = [[AppSettings sharedInstance] stringForKey:version_key];
    if (!version) {
        _images = [NSMutableArray new];
        [_images addObject:[UIImage imageNamed:@"GuideImage_1"]];
        [_images addObject:[UIImage imageNamed:@"GuideImage_2"]];
        [_images addObject:[UIImage imageNamed:@"GuideImage_3"]];
        [_images addObject:[UIImage imageNamed:@"GuideImage_4"]];
        // 立即进入的按钮
        [[HcdGuideViewManager sharedInstance] showGuideViewWithImages:_images
                                                       andButtonTitle:@""
                                                  andButtonTitleColor:[UIColor whiteColor]
                                                     andButtonBGColor:[UIColor clearColor]
                                                 andButtonBorderColor:[UIColor whiteColor]];
        
        [[AppSettings sharedInstance] setString:version_key forKey:version_key];
    }
}

- (void)judgeNet
{
    self.manager = [AFNetworkReachabilityManager manager];
//    __weak typeof(self) weakSelf = self;
    [self.manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable: {
                //                [weakSelf loadMessage:@"网络不可用"];
                [PromptView autoHideWithText:@"网络不可用"];
                NSLog(@"网络不可用");
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                //                [weakSelf loadMessage:@"Wifi已开启"];
                [PromptView autoHideWithText:@"Wifi已开启"];
                NSLog(@"Wifi已开启");
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                //                [weakSelf loadMessage:@"你现在使用的流量"];
                [PromptView autoHideWithText:@"你现在使用的流量"];
                NSLog(@"你现在使用的流量");
                break;
            }
                
            case AFNetworkReachabilityStatusUnknown: {
                //                [weakSelf loadMessage:@"你现在使用的未知网络"];
                [PromptView autoHideWithText:@"你现在使用的未知网络"];
                NSLog(@"你现在使用的未知网络");
                break;
            }
                
            default:
                break;
        }
    }];
    [self.manager startMonitoring];
}

- (void)loginSuccess
{
    id dd = [self getPresentViewController];
    WMUserModel * model = [[AppSettings sharedInstance] loginObject];
    [CloudPushSDK bindAccount:model.userMobilephone withCallback:^(CloudPushCallbackResult *res) {
        
    }];
    if ([dd isKindOfClass:[CustomNavigationController class]]){
        UINavigationController *naviVc = (UINavigationController *)dd;
        id visibleVc = naviVc.visibleViewController;
        UIViewController * vc = (UIViewController *)visibleVc;
        [vc.navigationController popToRootViewControllerAnimated:NO];
        [self refreshHomeVC];
    }

}

- (void)refreshHomeVC{

    [[NSNotificationCenter defaultCenter] postNotificationName:@"goHomeVC" object:nil];
}


- (UIViewController *)getPresentViewController{
    id appRootVC = self.window.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentingViewController) {
        topVC = topVC.presentingViewController;
    }
    return topVC;
}


#pragma mark - 推送相关

/** 初始化推送SDK */
- (void)initCloudPush {
    
    // SDK初始化
    [CloudPushSDK asyncInit:ALIPUSHKEY appSecret:ALIPUSHSECRET callback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Push SDK init success, deviceId: %@.", [CloudPushSDK getDeviceId]);
            [[AppSettings sharedInstance] setString:[CloudPushSDK getDeviceId] forKey:@"DeviceId"];
        } else {
            NSLog(@"Push SDK init failed, error: %@", res.error);
        }
    }];
}

/**
 *	注册推送通道打开监听
 */
- (void)listenerOnChannelOpened {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onChannelOpened:)
                                                 name:@"CCPDidChannelConnectedSuccess"
                                               object:nil];
}
/**
 *	推送通道打开回调
 *
 */
- (void)onChannelOpened:(NSNotification *)notification {
    NSLog(@"推送通道打开成功");
}

/**
 *	向APNs注册，获取deviceToken用于推送
 *
 *	@param 	application
 */
- (void)registerAPNS:(UIApplication *)application {
    float systemVersionNum = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersionNum >= 10.0) {
        // iOS 10 notifications
        _notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
        // 创建category，并注册到通知中心
        [self createCustomNotificationCategory];
        _notificationCenter.delegate = self;
        // 请求推送权限
        [_notificationCenter requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // granted
                NSLog(@"User authored notification.");
                // 向APNs注册，获取deviceToken
                dispatch_async(dispatch_get_main_queue(), ^{
                    [application registerForRemoteNotifications];
                });
            } else {
                // not granted
                NSLog(@"User denied notification.");
            }
        }];
    } else if (systemVersionNum >= 8.0) {
        // iOS 8 Notifications
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:
          (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                           categories:nil]];
        [application registerForRemoteNotifications];
#pragma clang diagnostic pop
    } else {
        // iOS < 8 Notifications
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
#pragma clang diagnostic pop
    }
}

- (void)createCustomNotificationCategory {
    // 自定义`action1`和`action2`
    UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"action1" title:@"test1" options: UNNotificationActionOptionNone];
    UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:@"action2" title:@"test2" options: UNNotificationActionOptionNone];
    // 创建id为`test_category`的category，并注册两个action到category
    // UNNotificationCategoryOptionCustomDismissAction表明可以触发通知的dismiss回调
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"test_category" actions:@[action1, action2] intentIdentifiers:@[] options:
                                        UNNotificationCategoryOptionCustomDismissAction];
    // 注册category到通知中心
    [_notificationCenter setNotificationCategories:[NSSet setWithObjects:category, nil]];
}



/** 苹果推送注册成功回调，将苹果返回的deviceToken上传到CloudPush服务器 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [CloudPushSDK registerDevice:deviceToken withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Register deviceToken success.");
        } else {
            NSLog(@"Register deviceToken failed, error: %@", res.error);
        }
    }];
}
/*
 *  苹果推送注册失败回调
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);
}

/**
*    注册推送消息到来监听
*/
- (void)registerMessageReceive {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onMessageReceived:)
                                                 name:@"CCPDidReceiveMessageNotification"
                                               object:nil];
}
/** 处理推送来得消息 */
- (void)onMessageReceived:(NSNotification *)notification {
    CCPSysMessage *message = [notification object];
    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
    NSLog(@"Receive message title: %@, content: %@.", title, body);
    if ([title isEqualToString:@"order"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sended" object:nil];
    }
    
    if ([title isEqualToString:@"require"]) {
        if ([body isEqualToString:@"update"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [PromptView autoHideWithText:@"您的需求已被接单"];
                sleep(1);
            });
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hasReceive" object:nil];
        } else if ([body isEqualToString:@"cancel"]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [PromptView autoHideWithText:@"您的需求订单已被取消"];
                sleep(1);
            });
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hasCancle" object:nil];
        }
        
    }
    
}

/*
 *  App处于启动状态时，通知打开回调
 */
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
    NSLog(@"Receive one notification.");
    // 取得APNS通知内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    // 内容
    NSString *content = [aps valueForKey:@"alert"];
    // badge数量
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
    // 播放声音
    NSString *sound = [aps valueForKey:@"sound"];
    // 取得Extras字段内容
    NSString *Extras = [userInfo valueForKey:@"Extras"]; //服务端中Extras字段，key是自己定义的
    NSLog(@"content = [%@], badge = [%ld], sound = [%@], Extras = [%@]", content, (long)badge, sound, Extras);
    // iOS badge 清0
    application.applicationIconBadgeNumber = 0;
    // 通知打开回执上报
    // [CloudPushSDK handleReceiveRemoteNotification:userInfo];(Deprecated from v1.8.1)
    [CloudPushSDK sendNotificationAck:userInfo];
}



#pragma mark - lifestyle
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}



@end
