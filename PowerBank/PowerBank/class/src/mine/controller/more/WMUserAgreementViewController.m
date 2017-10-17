//
//  WMUserAgreementViewController.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/14.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMUserAgreementViewController.h"

@interface WMUserAgreementViewController ()
@property (weak, nonatomic) IBOutlet UITextView *UserAgreementTextView;

@end

@implementation WMUserAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"用户协议";
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.UserAgreementTextView.scrollEnabled = YES;
    self.UserAgreementTextView.editable = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
