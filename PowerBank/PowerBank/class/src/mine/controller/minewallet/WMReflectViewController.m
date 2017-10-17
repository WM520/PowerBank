//
//  WMReflectViewController.m
//  PowerBank
//
//  Created by baiju on 2017/8/8.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMReflectViewController.h"
#import "BankModel.h"
#import "WMUserModel.h"
@interface WMReflectViewController ()
<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *cashTF;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
@property (strong, nonatomic) BankModel * model;
@end

@implementation WMReflectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self initData];
}

- (void)initUI
{
    self.title = @"提现";
    _userIconImageView.layer.cornerRadius = 25;
    _userIconImageView.clipsToBounds = YES;
    self.view.backgroundColor = ThemeColor;
    _cashTF.delegate = self;
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageButton setTitle:@"提交" forState:UIControlStateNormal];
    [messageButton setTitleColor:ThemeBarTextColor forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    messageButton.frame = CGRectMake(0, 0, 40, 20);
    UIBarButtonItem *messageNagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    messageNagetiveSpacer.width = -10;
    UIBarButtonItem *messageBarItem = [[UIBarButtonItem alloc] initWithCustomView:messageButton];
    self.navigationItem.rightBarButtonItems = @[ messageNagetiveSpacer, messageBarItem];
}

- (void)initData
{
    [WMRequestHelper acquiringBankCardInformation:[[AppSettings sharedInstance] stringForKey:@"token"] withCompletionHandle:^(BOOL success, id dataDic) {
        
        if ([[NSString stringWithFormat:@"%@", [[dataDic objectForKey:@"meta"] objectForKey:@"code"]] isEqualToString:@"200"] && [[dataDic objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
            BankModel * model = [BankModel modelWithDictionary:[dataDic objectForKey:@"data"][0]];
            _model = model;
            // 提现接口
            self.bankNameLabel.text = model.bankname;
            self.cardNumberLabel.text = [NSString stringWithFormat:@"**** **** **** %@", [model.number substringFromIndex:model.number.length- 4]];
            // 用户头像的展示
            NSString *path_document = NSHomeDirectory();
            NSString *imagePath = [path_document stringByAppendingString:@"/Documents/pic.png"];
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];

            _userIconImageView.image = image;
        }
    }];

}

- (IBAction)allCommit:(id)sender {
    
    NSString * money = [[[AppSettings sharedInstance] loginObject] userBalance];
    _cashTF.text = money;
    
}

- (void)commit
{
    NSLog(@"提交提现");
    
    NSInteger money = [_cashTF.text integerValue];
    if (money > [[[[AppSettings sharedInstance] loginObject] userBalance] integerValue]) {
        [[PhoneNotification sharedInstance] autoHideWithText:@"余额不足"];
        return;
    }
    
    if (money < 10) {
        [[PhoneNotification sharedInstance] autoHideWithText:@"提现金额必须大于10元"];
        return;
    }
    
    // 获取银行的ID
    [WMRequestHelper userCashWithMoney:_cashTF.text bcid:_model.cardID withCompletionHandle:^(BOOL success, id dataDic) {
        if ([[NSString stringWithFormat:@"%@", [[dataDic objectForKey:@"meta"] objectForKey:@"code"]] isEqualToString:@"200"]) {
            [PromptView autoHideWithText:@"提现成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
            [PromptView autoHideWithText:@"提现失败"];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
