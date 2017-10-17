//
//  LoginViewController.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/3.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "LoginViewController.h"
#import "WMLoginAgreementViewController.h"
#import "WMUserModel.h"
#import "WMAliyunTokenModel.h"

@interface LoginViewController ()
<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *loginBG;
@property (weak, nonatomic) IBOutlet UITextField *phonTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *userAgreement;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic , assign)NSInteger time;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
/** 保存获取验证码 */
@property (nonatomic, copy) NSString * codeString;
@property (assign, nonatomic) NSInteger viewCenterY;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLayout;

@end

@implementation LoginViewController

#pragma mark -life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化界面
    [self configUI];
    _viewCenterY = self.view.centerY;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -protect Methods

- (void)configUI {
    _loginButton.clipsToBounds = YES;
    _loginButton.layer.cornerRadius = 10;
    /** 图片模糊效果 */
//    UIToolbar *toolbar = [[UIToolbar alloc] init];
//    toolbar.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    toolbar.barStyle = UIBarStyleBlack;
//    toolbar.alpha = 1;
//    [self.loginBG addSubview:toolbar];
    _leftLayout.constant = (SCREEN_WIDTH - 133 - 107) /2;
    _phonTextField.delegate = self;
    _verificationCodeField.delegate = self;
    [_phonTextField setValue:RGB(182, 183, 184) forKeyPath:@"_placeholderLabel.textColor"];
    [_verificationCodeField setValue:RGB(182, 183, 184) forKeyPath:@"_placeholderLabel.textColor"];
}
- (IBAction)getMessageCode:(id)sender {
    _getCodeButton.userInteractionEnabled = NO;
    self.timer.fireDate = [NSDate distantPast];
    // 获取验证码
    [WMRequestHelper acquiringMessageCode:_phonTextField.text type:@"0" withCompletionHandle:^(BOOL success, id dataDic) {
        if ([[NSString stringWithFormat:@"%@", [[dataDic objectForKey:@"meta"] objectForKey:@"code"]] isEqualToString:@"200"]) {
            [[PhoneNotification sharedInstance] autoHideWithText:@"发送验证码成功"];
        } else if ([[NSString stringWithFormat:@"%@", [[dataDic objectForKey:@"meta"] objectForKey:@"code"]] isEqualToString:@"500"]) {
            [[PhoneNotification sharedInstance] autoHideWithText:@"服务器异常"];
        }
    }];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)login:(id)sender {
    
    if (_phonTextField.text.length == 0) {
        [[PhoneNotification sharedInstance] autoHideWithText:@"手机号不能为空"];
        return;
    }
    
    if (_verificationCodeField.text.length == 0) {
        [[PhoneNotification sharedInstance] autoHideWithText:@"验证码不能为空"];
        return;
    }
    
    NSString *login_key = @"login";
    NSLog(@"%@",[[AppSettings sharedInstance] stringForKey:@"DeviceId"]);
    if (self.phonTextField.text.length != 11) {
        [[PhoneNotification sharedInstance] autoHideWithText:@"手机号输入有误" image:@"prompting" backGroundColor:RGB(114, 114, 114)];
        return;
    }
    
    [WMRequestHelper loginRequestWithPhone:self.phonTextField.text validateCodeStr:_verificationCodeField.text platform:@"iOS" deviceId:[[AppSettings sharedInstance] stringForKey:@"DeviceId"] withCompletionHandle:^(BOOL success, id dataDic) {
        if (success) {
            NSDictionary * meta = [dataDic objectForKey:@"meta"];
            
            if ([[NSString stringWithFormat:@"%@", [meta objectForKey:@"code"]] isEqualToString:@"9103"]) {
                [[PhoneNotification sharedInstance] autoHideWithText:@"验证码输入错误"];
            } else if ([[NSString stringWithFormat:@"%@", [meta objectForKey:@"code"]] isEqualToString:@"200"]) {
                [[PhoneNotification sharedInstance] autoHideWithText:@"登录成功"];
                [[AppSettings sharedInstance] setString:@"login" forKey:login_key];
                NSString * token = [dataDic objectForKey:@"data"];
                if (token.length > 0) {
                    [[AppSettings sharedInstance] setString:[dataDic objectForKey:@"data"] forKey:@"token"];
                }
                
                [WMRequestHelper acquiringInformation:[[AppSettings sharedInstance] stringForKey:@"token"] withCompletionHandle:^(BOOL success, id dataDic) {
                    if (success) {
                        if ([[dataDic objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                            NSDictionary * dic = [dataDic objectForKey:@"data"];
                            WMUserModel * model = [WMUserModel modelWithDictionary:dic];
                            [[AppSettings sharedInstance] loginsaveCache:model];
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"loginsuccess" object:nil];
                            [self initOOS];
                        }
                        
                    }
                }];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
            
        } else {
            NSLog(@"%@", dataDic);
        }
    }];
}
- (IBAction)userAgreementH5:(id)sender {
    WMLoginAgreementViewController * vc = [[WMLoginAgreementViewController alloc] init];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_verificationCodeField resignFirstResponder];
    [_phonTextField resignFirstResponder];
}

- (void)initOOS
{
    [WMRequestHelper acquiringAliyunToken:Login_Token withCompletionHandle:^(BOOL success, id dataDic) {
        if (success) {
            if ([[NSString stringWithFormat:@"%@", [[dataDic objectForKey:@"meta"] objectForKey:@"code"]] isEqualToString:@"200"]) {
                WMAliyunTokenModel * model = [WMAliyunTokenModel modelWithDictionary:[dataDic objectForKey:@"data"]];
                [[AppSettings sharedInstance] aliKeySaveCache:model];
            }
        }
    }];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSInteger phoneoffset = 0;
    NSInteger veroffset =0;
    if (SCREEN_WIDTH == 320) {
        veroffset = -150;
        phoneoffset = - 150;
    } else if (SCREEN_WIDTH == 375) {
        veroffset = -80;
        phoneoffset = - 50;
    } else if (SCREEN_WIDTH == 414) {
        veroffset = -30;
        phoneoffset = -30;
    }
    if (textField == _verificationCodeField) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        self.view.frame = CGRectMake(0, veroffset,self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    } else if (textField == _phonTextField) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        self.view.frame = CGRectMake(0, phoneoffset,self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    self.view.frame = CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _phonTextField) {
        NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length > 11 && range.length!=1){
            textField.text = [toBeString substringToIndex:11];
            return NO;
        }
    }
    if (textField == _verificationCodeField) {
        NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toBeString.length > 6 && range.length!=1){
            textField.text = [toBeString substringToIndex:6];
            return NO;
        }
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)timeUp
{
    _time = _time - 1;
    [_getCodeButton setTitle:[NSString stringWithFormat:@"%ld秒后重发",(long)_time] forState:UIControlStateNormal];
    if (_time <= 0) {
        //结束计时
        _timer.fireDate = [NSDate distantFuture];
        _getCodeButton.userInteractionEnabled = YES;
        [_getCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
        self.time = 60;
    }

}

#pragma mark - Getter&&Setter
- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeUp) userInfo:nil repeats:YES];
        _time = 60;
    }
    return _timer;
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}



@end
