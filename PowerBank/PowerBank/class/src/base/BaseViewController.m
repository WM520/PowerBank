//
//  BaseViewController.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/1.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNav];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNav
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(callback) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 20, 20);
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nagetiveSpacer.width = -15;
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer, barItem];
}

- (void)callback
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
