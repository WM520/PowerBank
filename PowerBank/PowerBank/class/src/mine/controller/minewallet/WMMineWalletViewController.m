//
//  WMMineWalletViewController.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/17.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMMineWalletViewController.h"
#import "WMWalletDetailViewController.h"
#import "WMMineWalletHeadView.h"
#import "XBSettingItemModel.h"
#import "XBSettingSectionModel.h"
#import "XBSettingCell.h"
#import "WMAddBankCardViewController.h"
#import "WMReflectViewController.h"
#import "WMAddBankView.h"
#import "WMWithDrawView.h"
#import "WMHasBankCardViewController.h"
#import "BankModel.h"
#import "WMUserModel.h"
#import "WMRealNameAuthenticationViewController.h"
static NSString *cellID = @"WalletCell";

@interface WMMineWalletViewController ()
<UITableViewDelegate,
UITableViewDataSource,
WMHasBankCardViewControllerDelegate>

@property (nonatomic, strong) WMMineWalletHeadView * headView;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) XBSettingItemModel * item1;
@property (nonatomic, strong) WMAddBankView * bankView;
@property (nonatomic, strong) WMWithDrawView * withDrawView;
@property (nonatomic, assign) BOOL isAddCard;


@end

@implementation WMMineWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNav];
    [self configBaseUI];
    [self setUpData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setUpData
{
    XBSettingItemModel *item1 = [[XBSettingItemModel alloc]init];
    item1.funcName = @"银行卡";
    item1.detailText = @"添加银行卡";
    item1.executeCode = ^{
        
    };
    item1.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    _item1 = item1;
    XBSettingSectionModel *section1 = [[XBSettingSectionModel alloc]init];
    section1.sectionHeaderHeight = 18;
    section1.itemArray = @[item1];
    [self.dataArray addObject:section1];
}

- (void)setTitle:(NSString *)title
{
    UILabel *titleLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.text             = title;
    titleLabel.font             = [UIFont boldSystemFontOfSize:20.f];
    titleLabel.textAlignment    = NSTextAlignmentCenter;
    titleLabel.textColor        = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
}

- (void)initNav
{
    self.title = @"我的钱包";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"black-back.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(callback) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 20, 20);
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nagetiveSpacer.width = -15;
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer, barItem];
    
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageButton setTitle:@"明细" forState:UIControlStateNormal];
    [messageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(goToOrderDetail) forControlEvents:UIControlEventTouchUpInside];
    messageButton.frame = CGRectMake(0, 0, 40, 20);
    UIBarButtonItem *messageNagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    messageNagetiveSpacer.width = -10;
    UIBarButtonItem *messageBarItem = [[UIBarButtonItem alloc] initWithCustomView:messageButton];
    self.navigationItem.rightBarButtonItems = @[ messageNagetiveSpacer, messageBarItem];
}

- (void)configBaseUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.mainTableView.contentInset = UIEdgeInsetsMake(264, 0, 0, 0);
    [self.mainTableView addSubview:self.headView];
    kWeakSelf(self);

    [self.view addSubview:self.mainTableView];
    [self wr_setNavBarBackgroundAlpha: 0];
    
    WMAddBankView * bankView = [[NSBundle mainBundle] loadNibNamed:@"WMAddBankView" owner:self options:nil].lastObject;
    bankView.block = ^{
        WMUserModel * model = [[AppSettings sharedInstance] loginObject];
        if ([[NSString stringWithFormat:@"%@", model.userIdentifyStatus] isEqualToString:@"0"]) {
            WMRealNameAuthenticationViewController * vc = [[WMRealNameAuthenticationViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            WMAddBankCardViewController * vc = [[WMAddBankCardViewController alloc] init];
            vc.block = ^{
                [weakself loadData];
            };
            [weakself.navigationController pushViewController:vc animated:YES];
        }
    };
    bankView.frame = CGRectMake(0, 270, self.view.frame.size.width, SCREEN_HEIGHT - 270);
    [self.view addSubview:bankView];
    _bankView = bankView;
    [self loadData];
}

// 刷新页面
- (void)loadData
{
    kWeakSelf(self);
    [WMRequestHelper acquiringBankCardInformation:[[AppSettings sharedInstance] stringForKey:@"token"] withCompletionHandle:^(BOOL success, id dataDic) {
        NSLog(@"%@", dataDic);
        if (success) {
            NSArray * array = [dataDic objectForKey:@"data"];
            if (array.count > 0) {
                [_bankView removeFromSuperview];
                NSDictionary * dic = [[dataDic objectForKey:@"data"] objectAtIndex:0];
                if (!_withDrawView) {
                    BankModel * model = [BankModel modelWithDictionary:dic];
                    WMWithDrawView * withDrawView = [[NSBundle mainBundle] loadNibNamed:@"WMWithDrawView" owner:self options:nil].lastObject;
                    withDrawView.frame = CGRectMake(0, 270, self.view.frame.size.width, SCREEN_HEIGHT - 270);
                    withDrawView.model = model;
                    withDrawView.block = ^{
                        WMReflectViewController * reflectVC = [[WMReflectViewController alloc] init];
                        [weakself.navigationController pushViewController:reflectVC animated:YES];
                    };
                    withDrawView.goToBankBlock = ^{
                        WMHasBankCardViewController * vc = [[WMHasBankCardViewController alloc] init];
                        vc.delegate = weakself;
                        vc.model = model;
                        [weakself.navigationController pushViewController:vc animated:YES];
                    };
                    [self.view addSubview: withDrawView];
                    _withDrawView = withDrawView;
                }
            } else {
                [_withDrawView removeFromSuperview];
                [self.view addSubview:_bankView];
            }
        }
    }];

}

- (void)refreshData
{
    [self loadData];
}

// 明细
- (void)goToOrderDetail
{
    WMWalletDetailViewController * vc = [[WMWalletDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    XBSettingSectionModel *sectionModel = self.dataArray[indexPath.section];
    XBSettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    if (!cell) {
        cell = [[XBSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.item = itemModel;
    
    return cell;
}
#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XBSettingSectionModel *sectionModel = self.dataArray[indexPath.section];
    XBSettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    if (itemModel.executeCode) {
        itemModel.executeCode();
    }
}

#pragma mark -protected
- (void)callback
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -lazy
- (WMMineWalletHeadView *)headView
{
    if (!_headView) {
        _headView = [[WMMineWalletHeadView alloc] initWithFrame:CGRectMake(0, -290, SCREEN_WIDTH, 290)];
        _headView.userModel = _userModel;
    }
    return _headView;
}

- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.scrollEnabled = NO;
         [_mainTableView registerClass:[XBSettingCell class] forCellReuseIdentifier:cellID];
    }
    return _mainTableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
