//
//  WMInputSerialNumberViewController.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/24.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMInputSerialNumberViewController.h"

@interface WMInputSerialNumberViewController ()
@property (weak, nonatomic) IBOutlet UITextField *numberTF;

@end

@implementation WMInputSerialNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];

}

- (void)initUI
{
    self.title = @"输入设备编号";
    self.view.backgroundColor = ThemeColor;
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageButton setTitle:@"提交" forState:UIControlStateNormal];
    [messageButton setTitleColor:ThemeBarTextColor forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    messageButton.frame = CGRectMake(0, 0, 40, 20);
    UIBarButtonItem *messageNagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    messageNagetiveSpacer.width = -10;
    UIBarButtonItem *messageBarItem = [[UIBarButtonItem alloc] initWithCustomView:messageButton];
    self.navigationItem.rightBarButtonItems = @[ messageNagetiveSpacer, messageBarItem];
    
    CGRect frame = _numberTF.frame;//f表示你的textField的frame
    frame.size.width = 15;//设置左边距的大小
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    _numberTF.leftViewMode = UITextFieldViewModeAlways;//设置左边距显示的时机，这个表示一直显示
    _numberTF.leftView = leftview;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)commit
{
    NSLog(@"提交充电宝编号");
    
//    [[PhoneNotification sharedInstance] autoHideWithText:@"设备号输入有误\n请核查后重新输入" image:@"question"];
    [[PhoneNotification sharedInstance] autoHideWithText:@"设备号输入有误\n请核查后重新输入" image:@"prompting" backGroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [self.numberTF resignFirstResponder];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
