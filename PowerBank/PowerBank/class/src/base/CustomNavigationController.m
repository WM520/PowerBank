//
//  CustomNavigationController.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/3.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "CustomNavigationController.h"

@interface CustomNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation CustomNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationBar setBarTintColor:[UIColor colorWithHexString:@"#42c281"]];
    //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#42c281"]];
    self.interactivePopGestureRecognizer.delegate = self;
    self.delegate = self;
//    UINavigationBar* bar = self.navigationBar;
//    if (bar)
//    {
//        [bar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                     [UIColor whiteColor],NSForegroundColorAttributeName,
//                                     [UIFont boldSystemFontOfSize:20],NSFontAttributeName, nil]];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (navigationController.viewControllers.count == 1)
        self.currentShowVC = Nil;
    else
        self.currentShowVC = viewController;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        return (self.currentShowVC == self.topViewController); //the most important
    }
    return YES;
}




@end
