//
//  WMHasBankCardViewController.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/18.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMHasBankCardViewController.h"
#import "WMHasCardTableViewCell.h"
#import "BankModel.h"

static NSString * HasCard  = @"HasCard";

@interface WMHasBankCardViewController ()
<UITableViewDataSource,
UITableViewDelegate>
@property (weak, nonatomic)  UITableView *mainTableView;

@end

@implementation WMHasBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI
{
    (void)self.mainTableView;
    self.view.backgroundColor = ThemeColor;
    self.title = @"银行卡";
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMHasCardTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:HasCard];
    cell.bankName.text = _model.bankname;
    cell.lastNumber.text = [_model.number substringFromIndex:_model.number.length- 4];
    return cell;
}
#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 刷新
    NSLog(@"删除银行卡");
    [PromptView autoHideWithText:@"删除银行卡"];
    [WMRequestHelper deleteBankCardWithCardNumber:_model.cardID withCompletionHandle:^(BOOL success, id dataDic) {
        NSLog(@"%@", dataDic);
        NSDictionary * returnDic = [dataDic objectForKey:@"meta"];
        if ([[NSString stringWithFormat:@"%@", [returnDic objectForKey:@"code"]] isEqualToString:@"200"]) {
            if ([self.delegate respondsToSelector:@selector(refreshData)]) {
                [self.delegate refreshData];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
//    [self.navigationController popViewControllerAnimated:YES];
    // [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -lazy
- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 20, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 20) style:UITableViewStylePlain];
        mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        mainTableView.backgroundColor = ThemeColor;
        mainTableView.dataSource = self;
        mainTableView.delegate = self;
        [mainTableView registerNib:[UINib nibWithNibName:@"WMHasCardTableViewCell" bundle:nil] forCellReuseIdentifier:HasCard];
        [self.view addSubview:mainTableView];
        _mainTableView = mainTableView;
    }
    return _mainTableView;
}



@end
