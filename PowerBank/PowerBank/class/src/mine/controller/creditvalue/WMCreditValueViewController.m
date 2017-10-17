//
//  WMCreditValueViewController.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/18.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMCreditValueViewController.h"
#import "WMCreditValueHeadView.h"
#import "WMCreditTableViewCell.h"
#import "WMIntroductionCreditViewController.h"
#import "WMCreditValueModel.h"

static NSString * CreditCellID = @"creditcell";

@interface WMCreditValueViewController ()
<UITableViewDelegate,
UITableViewDataSource,
WMCreditValueHeadViewDelegate>
/** 主体list */
@property (nonatomic, strong) UITableView *mainTableView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/** 头部视图 */
@property (nonatomic, strong) WMCreditValueHeadView * headView;
@property (nonatomic, assign) NSInteger count;

@end

@implementation WMCreditValueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    
    [self configBaseUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - init
- (void)initData
{
    [WMRequestHelper acquiringCreditList:10 page:1 withCompletionHandle:^(BOOL success, id dataDic) {
        if (success) {
            NSArray * array = [dataDic objectForKey:@"data"];
            // model 格式化
            for (int i = 0; i < array.count; i++) {
                WMCreditValueModel * model = [WMCreditValueModel modelWithDictionary:array[i]];
                [self.dataArray addObject:model];
            }
            [self.mainTableView reloadData];
        }
    }];
}

- (void)configBaseUI
{
    _count = 10;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"信用值";
    self.mainTableView.contentInset = UIEdgeInsetsMake(264, 0, 0, 0);
    [self.mainTableView addSubview:self.headView];
    [self.view addSubview:self.mainTableView];
    [self wr_setNavBarBackgroundAlpha: 0];
    _mainTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"black-back.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(callback) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 20, 20);
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    nagetiveSpacer.width = -15;
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer, barItem];
}

#pragma mark - methods
- (void)callback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadMore
{
    _count += 10;
    [_mainTableView.mj_footer endRefreshing];
    [_mainTableView reloadData];
}

- (void)loadData
{
    _count = 10;
    [_mainTableView.mj_header endRefreshing];
    [_mainTableView reloadData];
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMCreditTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CreditCellID];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -WMCreditValueHeadViewDelegate
/** 信用值说明 */
- (void)goToCreditController
{
    WMIntroductionCreditViewController * vc = [[WMIntroductionCreditViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -lazy
- (WMCreditValueHeadView *)headView
{
    if (!_headView) {
        _headView = [[WMCreditValueHeadView alloc] initWithFrame:CGRectMake(0, -290, SCREEN_WIDTH, 290)];
        _headView.delegate = self;
        _headView.model = _model;
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
        _mainTableView.scrollEnabled = YES;
        [_mainTableView registerNib:[UINib nibWithNibName:@"WMCreditTableViewCell" bundle:nil] forCellReuseIdentifier:CreditCellID];
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
