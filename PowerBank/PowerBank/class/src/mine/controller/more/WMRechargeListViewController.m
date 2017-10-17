//
//  WMRechargeListViewController.m
//  PowerBank
//
//  Created by baiju on 2017/8/7.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMRechargeListViewController.h"
#import "WMRechargeTableViewCell.h"
#import "WMRechargeModel.h"

static NSString * RechargeCellID = @"recharge";

@interface WMRechargeListViewController ()
<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) UITableView * listView;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation WMRechargeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData
{
    [WMRequestHelper acquiringChargerList:10 page:1 withCompletionHandle:^(BOOL success, id dataDic) {
        if (success) {
            if ([[NSString stringWithFormat:@"%@", [[dataDic objectForKey:@"meta"] objectForKey:@"code"]] isEqualToString:@"200"]) {
                if ([dataDic objectForKey:@"data"]) {
                    NSArray * array = [dataDic objectForKey:@"data"];
                    NSLog(@"%ld", array.count);
                    self.dataArray = [NSMutableArray arrayWithArray:array];
                    NSLog(@"array == %@",array);
                    for (int i = 0; i < array.count; i++) {
                        WMRechargeModel * model = [WMRechargeModel modelWithDictionary:array[i]];
                        [self.dataArray addObject:model];
                    }
                    
                }
                [self.listView reloadData];
            }
        }
    }];
}

- (void) initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"充电记录";
    [self.view addSubview:self.listView];
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMRechargeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:RechargeCellID];
    return cell;
}


#pragma mark -setters or getters
- (UITableView *)listView
{
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        [_listView registerNib:[UINib nibWithNibName:@"WMRechargeTableViewCell" bundle:nil] forCellReuseIdentifier:RechargeCellID];
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listView.dataSource = self;
        _listView.delegate = self;
    }
    return _listView;
}


- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
