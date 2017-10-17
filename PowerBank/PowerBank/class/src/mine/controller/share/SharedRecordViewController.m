//
//  SharedRecordViewController.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/11.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "SharedRecordViewController.h"
#import "SharedRecordTableViewCell.h"
#import "WMShareRecordDetailViewController.h"
#import "WMOrderModel.h"
#import "WMUserModel.h"
#import "WMShareListModel.h"

static NSString *cellId = @"sharerecordcell";

@interface SharedRecordViewController ()
<UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, weak) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray * tempArray;
@property (nonatomic, assign) int page;
@end

@implementation SharedRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _page = 1;
    // 初始化数据
    [self loadData];
    // 初始化UI
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -config
- (void)loadData
{
    _page = 1;
    WMUserModel * userModel = [[AppSettings sharedInstance] loginObject];
    [WMRequestHelper acquiringUserOrderListWithLimit:10 page:_page withCompletionHandle:^(BOOL success, id dataDic) {
        if (success) {
            if ([[dataDic objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                [self.tempArray removeAllObjects];
                [self.dataArray removeAllObjects];
                [self.mainTableView.mj_header endRefreshing];
                NSMutableArray * tempArray = [NSMutableArray array];
                NSArray * dataArray = [dataDic objectForKey:@"data"];
                for (int i = 0; i < dataArray.count; i++) {
                    WMOrderModel * model = [WMOrderModel modelWithDictionary:dataArray[i]];
                    [tempArray addObject:model];
                    [self.tempArray addObject:model];
                }
                
                for (int i = 0; i < tempArray.count; i++) {
                    WMShareListModel * model = [[WMShareListModel alloc] init];
                    WMOrderModel * orderModel = tempArray[i];
                    /** 收货人和需求人 */
                    if ([orderModel.userShareModel.userID isEqualToString:userModel.userID]) {
                        model.status = @"送";
                        if ([[NSString stringWithFormat:@"%@", orderModel.status] isEqualToString:@"0"]) {
                            model.payStatus = @"失败";
                        } else if ([[NSString stringWithFormat:@"%@", orderModel.status] isEqualToString:@"1"]) {
                            if ([[NSString stringWithFormat:@"%@", orderModel.sendStatus] isEqualToString:@"0"]) {
                                model.payStatus = @"未送达";
                            } else if([[NSString stringWithFormat:@"%@", orderModel.sendStatus] isEqualToString:@"1"]) {
                                if ([[NSString stringWithFormat:@"%@", orderModel.sendStatus] isEqualToString:@"1"]) {
                                    model.payStatus = @"未支付";
                                } 
                            }
                        } else if ([[NSString stringWithFormat:@"%@", orderModel.status] isEqualToString:@"2"]) {
                            model.payStatus = @"完成";
                        }
                        
                    } else if ([orderModel.userRequireModel.userID isEqualToString:userModel.userID]) {
                        model.status = @"收";
                        if ([[NSString stringWithFormat:@"%@", orderModel.status] isEqualToString:@"0"]) {
                            model.payStatus = @"失败";
                        } else if ([[NSString stringWithFormat:@"%@", orderModel.status] isEqualToString:@"1"]) {
                            if ([[NSString stringWithFormat:@"%@", orderModel.sendStatus] isEqualToString:@"0"]) {
                                model.payStatus = @"未送达";
                            } else if ([[NSString stringWithFormat:@"%@", orderModel.sendStatus] isEqualToString:@"1"]) {
                                if ([[NSString stringWithFormat:@"%@", orderModel.payStatus] isEqualToString:@"0"]) {
                                    model.payStatus = @"未支付";
                                }
                            }
                        } else if ([[NSString stringWithFormat:@"%@", orderModel.status] isEqualToString:@"2"]) {
                            model.payStatus = @"完成";
                        }
                    }
                    model.address = orderModel.requiremodel.address;
                    model.timeString = orderModel.requiremodel.createTime;
                    [self.dataArray addObject:model];
                }
                [self.mainTableView reloadData];
            }else {
                [self.mainTableView.mj_header endRefreshing];
            }
        } else {
            [self.mainTableView.mj_header endRefreshing];
        }
    }];
}

- (void)loadMoreData
{
    _page++;
    WMUserModel * userModel = [[AppSettings sharedInstance] loginObject];
    [WMRequestHelper acquiringUserOrderListWithLimit:10 page:_page withCompletionHandle:^(BOOL success, id dataDic) {
        if (success) {
            if ([[dataDic objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                [self.mainTableView.mj_footer endRefreshing];
                NSMutableArray * tempArray = [NSMutableArray array];
                NSArray * dataArray = [dataDic objectForKey:@"data"];
                for (int i = 0; i < dataArray.count; i++) {
                    WMOrderModel * model = [WMOrderModel modelWithDictionary:dataArray[i]];
                    [tempArray addObject:model];
                    [self.tempArray addObject:model];
                }
                
                for (int i = 0; i < tempArray.count; i++) {
                    WMShareListModel * model = [[WMShareListModel alloc] init];
                    WMOrderModel * orderModel = tempArray[i];
                    /** 收货人和需求人 */
                    if ([orderModel.userShareModel.userID isEqualToString:userModel.userID]) {
                        model.status = @"送";
                        if ([[NSString stringWithFormat:@"%@", orderModel.status] isEqualToString:@"0"]) {
                            model.payStatus = @"失败";
                        } else if ([[NSString stringWithFormat:@"%@", orderModel.status] isEqualToString:@"1"]) {
                            if ([[NSString stringWithFormat:@"%@", orderModel.sendStatus] isEqualToString:@"0"]) {
                                model.payStatus = @"未送达";
                            } else if([[NSString stringWithFormat:@"%@", orderModel.sendStatus] isEqualToString:@"1"]) {
                                if ([[NSString stringWithFormat:@"%@", orderModel.sendStatus] isEqualToString:@"1"]) {
                                    model.payStatus = @"未支付";
                                }
                            }
                        } else if ([[NSString stringWithFormat:@"%@", orderModel.status] isEqualToString:@"2"]) {
                            model.payStatus = @"完成";
                        }
                        
                    } else if ([orderModel.userRequireModel.userID isEqualToString:userModel.userID]) {
                        model.status = @"收";
                        if ([[NSString stringWithFormat:@"%@", orderModel.status] isEqualToString:@"0"]) {
                            model.payStatus = @"失败";
                        } else if ([[NSString stringWithFormat:@"%@", orderModel.status] isEqualToString:@"1"]) {
                            if ([[NSString stringWithFormat:@"%@", orderModel.sendStatus] isEqualToString:@"0"]) {
                                model.payStatus = @"未送达";
                            } else if ([[NSString stringWithFormat:@"%@", orderModel.sendStatus] isEqualToString:@"1"]) {
                                if ([[NSString stringWithFormat:@"%@", orderModel.payStatus] isEqualToString:@"0"]) {
                                    model.payStatus = @"未支付";
                                }
                            }
                        } else if ([[NSString stringWithFormat:@"%@", orderModel.status] isEqualToString:@"2"]) {
                            model.payStatus = @"完成";
                        }
                    }
                    model.address = orderModel.requiremodel.address;
                    model.timeString = orderModel.requiremodel.createTime;
                    [self.dataArray addObject:model];
                    
                }
                [self.mainTableView reloadData];
            }
        } else {
            [[PhoneNotification sharedInstance] autoHideWithText:@"没有更多数据"];
            [self.mainTableView.mj_footer endRefreshing];
        }
    }];
    
}

- (void)initUI
{
    (void)self.mainTableView;
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.title = @"共享记录";
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SharedRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.model = self.dataArray[indexPath.row];
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
    WMShareRecordDetailViewController * vc = [[WMShareRecordDetailViewController alloc] init];
    vc.model = self.tempArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -lazy
- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        UITableView *mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        mainTableView.backgroundColor = ThemeColor;
        [mainTableView registerNib:[UINib nibWithNibName:@"SharedRecordTableViewCell" bundle:nil] forCellReuseIdentifier:cellId];
        mainTableView.dataSource = self;
        mainTableView.delegate = self;
        [self.view addSubview:mainTableView];
        _mainTableView = mainTableView;
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

- (NSMutableArray *)tempArray
{
    if (!_tempArray) {
        _tempArray = [NSMutableArray array];
    }
    return _tempArray;
}

@end
