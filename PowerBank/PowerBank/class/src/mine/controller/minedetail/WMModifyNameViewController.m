//
//  WMModifyNameViewController.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/17.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMModifyNameViewController.h"
#define MAX_STARWORDS_LENGTH 20

@interface WMModifyNameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;

@end

@implementation WMModifyNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification" object:self.userNameTF];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods
- (void)initUI
{
    self.title = @"用户名";
    self.view.backgroundColor = ThemeColor;
    _userNameTF.clearButtonMode = UITextFieldViewModeAlways;
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitButton setTitle:@"保存" forState:UIControlStateNormal];
    [commitButton setTitleColor:ThemeBarTextColor forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    commitButton.frame = CGRectMake(0, 0, 40, 20);
    UIBarButtonItem *commitNagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    commitNagetiveSpacer.width = -10;
    UIBarButtonItem *commitBarItem = [[UIBarButtonItem alloc] initWithCustomView:commitButton];
    self.navigationItem.rightBarButtonItems = @[ commitNagetiveSpacer, commitBarItem];
}

- (void)commit
{
    if (_userNameTF.text.length <= 0) {
        NSLog(@"用户名不能为空");
        return;
    }
    [WMRequestHelper modificationUserValue:_userNameTF.text key:@"username" withCompletionHandle:^(BOOL success, id dataDic) {
        if (success) {
            if ([self.delegate respondsToSelector:@selector(userNameModify:)]) {
                [self.delegate userNameModify:_userNameTF.text];
            }
            
        }
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Notification Method
-(void)textFieldEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"])// 简体中文输入
    {
        //获取高亮部分
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > MAX_STARWORDS_LENGTH)
            {
                textField.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
            }
        }
        
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else
    {
        if (toBeString.length > MAX_STARWORDS_LENGTH)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_STARWORDS_LENGTH)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}




@end
