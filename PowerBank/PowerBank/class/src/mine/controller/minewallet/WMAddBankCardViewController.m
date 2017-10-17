//
//  WMAddBankCardViewController.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/17.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMAddBankCardViewController.h"
#import "WMAddBankTableViewCell.h"
#import "WMHasBankCardViewController.h"
#import <ActionSheetStringPicker.h>
#import "BankModel.h"

static NSString * ADDCELLID = @"ADDCELLID";
@interface WMAddBankCardViewController ()
<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *customerNameTF;
@property (weak, nonatomic)  UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UITextField *customerBankCardTF;
@property (weak, nonatomic) IBOutlet UITextField *customerBankCardAddress;
@property (strong, nonatomic) NSArray * bankArray;
@property (weak, nonatomic) IBOutlet UIButton *selectBankButton;
@property (nonatomic,assign) NSInteger selectedIndex;
@end

@implementation WMAddBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bankArray = @[@"中国银行", @"中国工商银行", @"交通银行", @"中国农业银行", @"中国招商银行"];
    self.selectedIndex = 0;
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)selectBankAction:(id)sender {
    
    [ActionSheetStringPicker showPickerWithTitle:@"选择银行" rows:self.bankArray initialSelection:self.selectedIndex target:self successAction:@selector(animalWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
}

- (void)initUI
{
    self.title = @"添加银行卡";
    _customerNameTF.delegate = self;
    _customerBankCardTF.delegate = self;
    _customerBankCardAddress.delegate = self;
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
    // (void)self.mainTableView;
}

- (void)commit
{
    NSLog(@"提交");
    
    
    [WMRequestHelper addBankCardWithUsername:_customerNameTF.text bankname:self.selectBankButton.titleLabel.text depositname:_customerBankCardAddress.text number:_customerBankCardTF.text withCompletionHandle:^(BOOL success, id dataDic) {
        NSDictionary * returnDic = [dataDic objectForKey:@"meta"];
        if ([[NSString stringWithFormat:@"%@", [returnDic objectForKey:@"code"]] isEqualToString:@"200"]) {
            if (self.block) {
                self.block();
                [PromptView autoHideWithText:@"添加银行卡成功"];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    

}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason
{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _customerNameTF) {
        [textField resignFirstResponder];
        [_customerBankCardTF becomeFirstResponder];
    } else if (textField == _customerBankCardTF) {
        [textField resignFirstResponder];
        [_customerBankCardAddress becomeFirstResponder];
    } else if (textField == _customerBankCardAddress) {
        [textField resignFirstResponder];
    }
    return YES;
}

//#pragma mark -UITableViewDataSource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 2;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return 1;
//    } else if (section == 1) {
//        return 3;
//    }
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString * identifier = [NSString stringWithFormat:@"%ld%ld", indexPath.section, indexPath.row];
//    WMAddBankTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil) {
//        cell = [[WMAddBankTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    return cell;
//}
//#pragma mark -UITableViewDelegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 1) {
//        if (indexPath.row == 1) {
//            [ActionSheetStringPicker showPickerWithTitle:@"选择银行" rows:self.bankArray initialSelection:self.selectedIndex target:self successAction:@selector(animalWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:tableView];
//        }
//    }
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
//        label.text = @"    请绑定本人的银行卡,目前仅支持绑定一张卡。";
//        label.font = [UIFont systemFontOfSize:14];
//        label.textColor = [UIColor colorWithHexString:@"#414141"];
//        [view addSubview:label];
//        return view;
//    }
//    return nil;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return 20;
//    }
//    return 0;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return 30;
//    }
//    return 0;
//}

- (void)animalWasSelected:(NSNumber *)selectedIndex element:(id)element {
    self.selectedIndex = [selectedIndex intValue];
    NSString * bankName = _bankArray[_selectedIndex];
    NSLog(@"self.selectedIndex= %ld", (long)self.selectedIndex);
    [self.selectBankButton setTitle:bankName forState:UIControlStateNormal];
    if ([_customerBankCardTF isFirstResponder]) {
        [_customerBankCardTF resignFirstResponder];
        [_customerBankCardAddress becomeFirstResponder];
    }
    
}
- (void)actionPickerCancelled:(id)sender {
    NSLog(@"user was cancelled");
}
#pragma mark -lazy
//- (UITableView *)mainTableView
//{
//    if (!_mainTableView) {
//        UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
//        mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        mainTableView.backgroundColor = ThemeColor;
//        mainTableView.dataSource = self;
//        mainTableView.delegate = self;
//        [mainTableView registerClass:[WMAddBankTableViewCell class] forCellReuseIdentifier:ADDCELLID];
//        [self.view addSubview:mainTableView];
//        _mainTableView = mainTableView;
//    }
//    return _mainTableView;
//}


@end
