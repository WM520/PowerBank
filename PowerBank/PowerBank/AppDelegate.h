//
//  AppDelegate.h
//  PowerBank
//
//  Created by wangmiao on 2017/6/2.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#define theApp ((AppDelegate *)[[UIApplication sharedApplication] delegate])
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong)NSMutableArray *images;
@property (nonatomic, strong) AFNetworkReachabilityManager *manager;

@end

