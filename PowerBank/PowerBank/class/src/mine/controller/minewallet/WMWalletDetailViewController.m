//
//  WMWalletDetailViewController.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/17.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMWalletDetailViewController.h"
#import "WMMineWalletTableViewCell.h"
#import "WMTradeModel.h"

static NSString * cellId = @"walletcell";

@interface WMWalletDetailViewController ()
<UITableViewDelegate,
UITableViewDataSource>
@property (weak, nonatomic)  UITableView *orderTableView;
@property (assign, nonatomic) NSInteger page;
@property (nonatomic, strong) NSMutableArray * dataTradeArray;

@end

@implementation WMWalletDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI
{
    self.title = @"明细";
    _page = 1;
    (void)self.orderTableView;
    _orderTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    _orderTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)initData
{
    [WMRequestHelper userTransactListWithList:@"10" page:[NSString stringWithFormat:@"%ld", _page] withCompletionHandle:^(BOOL success, id dataDic) {
        if (success) {
            if ([[NSString stringWithFormat:@"%@", [[dataDic objectForKey:@"meta"] objectForKey:@"code"]] isEqualToString:@"200"] && [[dataDic objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                NSArray * dataArray = [dataDic objectForKey:@"data"];
                for (int i = 0; i < dataArray.count; i++) {
                    WMTradeModel * model = [WMTradeModel modelWithDictionary:dataArray[i]];
                    [self.dataTradeArray addObject:model];
                }
            }
        }
    }];
}

- (void)loadData
{
    _page = 1;
    [WMRequestHelper userTransactListWithList:@"10" page:[NSString stringWithFormat:@"%ld", _page] withCompletionHandle:^(BOOL success, id dataDic) {
        if (success) {
            if ([[NSString stringWithFormat:@"%@", [[dataDic objectForKey:@"meta"] objectForKey:@"code"]] isEqualToString:@"200"] && [[dataDic objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                NSArray * dataArray = [dataDic objectForKey:@"data"];
                [_orderTableView.mj_header endRefreshing];
                [self.dataTradeArray removeAllObjects];
                for (int i = 0; i < dataArray.count; i++) {
                    WMTradeModel * model = [WMTradeModel modelWithDictionary:dataArray[i]];
                    [self.dataTradeArray addObject:model];
                }
                [_orderTableView reloadData];
            }
        } else {
            [[PhoneNotification sharedInstance] autoHideWithText:@"网络异常"];
            [_orderTableView.mj_header endRefreshing];
        }
    }];
    
    
}

- (void)loadMoreData
{
    _page ++;
    [WMRequestHelper userTransactListWithList:@"10" page:[NSString stringWithFormat:@"%ld", _page] withCompletionHandle:^(BOOL success, id dataDic) {
        if (success) {
            if ([[NSString stringWithFormat:@"%@", [[dataDic objectForKey:@"meta"] objectForKey:@"code"]] isEqualToString:@"200"] && [[dataDic objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                NSArray * dataArray = [dataDic objectForKey:@"data"];
                [_orderTableView.mj_footer endRefreshing];
                for (int i = 0; i < dataArray.count; i++) {
                    WMTradeModel * model = [WMTradeModel modelWithDictionary:dataArray[i]];
                    [self.dataTradeArray addObject:model];
                }
                [_orderTableView reloadData];
            }
        } else {
            [[PhoneNotification sharedInstance] autoHideWithText:@"网络异常"];
            [_orderTableView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataTradeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMMineWalletTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    return cell;
}



#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableView *)orderTableView
{
    if (!_orderTableView) {
        UITableView *orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        orderTableView.backgroundColor = ThemeColor;
        [orderTableView registerNib:[UINib nibWithNibName:@"WMMineWalletTableViewCell" bundle:nil] forCellReuseIdentifier:cellId];
        orderTableView.dataSource = self;
        orderTableView.delegate = self;
        [self.view addSubview:orderTableView];
        _orderTableView = orderTableView;
    }
    return _orderTableView;
}

- (NSMutableArray *)dataTradeArray
{
    if (!_dataTradeArray) {
        _dataTradeArray = [NSMutableArray array];
    }
    return _dataTradeArray;
}


@end
