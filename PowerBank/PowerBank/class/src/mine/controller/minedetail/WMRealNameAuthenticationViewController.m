//
//  WMRealNameAuthenticationViewController.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/18.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMRealNameAuthenticationViewController.h"

@interface WMRealNameAuthenticationViewController ()
<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *userIDCard;

@end

@implementation WMRealNameAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_userNameTF becomeFirstResponder];
    [_userIDCard becomeFirstResponder];
}

#pragma mark -methods
- (void)initUI
{
    self.view.backgroundColor = ThemeColor;
    self.title = @"实名认证";
    // 是否已经认证过
    if (_isCertification) {
        _userIDCard.enabled = NO;
        _userNameTF.enabled = NO;
        _userNameTF.text = @"汪淼";
        _userIDCard.text = @"320723199205155312";
    } else {
        _userNameTF.delegate = self;
        _userIDCard.delegate = self;
        UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [commitButton setTitle:@"提交" forState:UIControlStateNormal];
        [commitButton setTitleColor:ThemeBarTextColor forState:UIControlStateNormal];
        [commitButton addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
        commitButton.frame = CGRectMake(0, 0, 40, 20);
        UIBarButtonItem *commitNagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        commitNagetiveSpacer.width = -10;
        UIBarButtonItem *commitBarItem = [[UIBarButtonItem alloc] initWithCustomView:commitButton];
        self.navigationItem.rightBarButtonItems = @[commitNagetiveSpacer, commitBarItem];
    }
}

- (void)commit
{
    NSString *isCertification = @"isCertification";
    
    [[AppSettings sharedInstance] setString:@"isCertification" forKey:isCertification];
    [WMRequestHelper userIdentifyWithName:_userNameTF.text number:_userIDCard.text withCompletionHandle:^(BOOL success, id dataDic) {
        if (success) {
            if ([[NSString stringWithFormat:@"%@", [[dataDic objectForKey:@"meta"] objectForKey:@"code"]] isEqualToString:@"200"]) {
                self.block();
                NSLog(@"dataDic == %@",dataDic);
                [[PhoneNotification sharedInstance] autoHideWithText:@"认证成功"];
            } else {
                [[PhoneNotification sharedInstance] autoHideWithText:@"认证失败"];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];

    
//
    NSLog(@"提交");
}

#pragma mark -UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _userNameTF) {
        [_userNameTF resignFirstResponder];
        [_userIDCard becomeFirstResponder];
    }
    
    if(textField == _userIDCard) {
        [_userIDCard resignFirstResponder];
    }
    
    return YES;
}


@end
