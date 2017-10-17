//
//  WMShareRecordDetailViewController.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/14.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMShareRecordDetailViewController.h"
#import "WMOrderTableViewCell.h"
#import "WMOrderModel.h"
#import "WMPayView.h"

static NSString * shareCell = @"ordercell";

@interface WMShareRecordDetailViewController ()
<UITableViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *orderTableView;
@property (weak, nonatomic) UIButton * orderStatusButton;
@property (weak, nonatomic) IBOutlet UILabel *commitButton;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailAddrLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *needTime;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (assign, nonatomic) NSInteger count;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) WMPayView * payView;


@end

@implementation WMShareRecordDetailViewController

#pragma mark -life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _mainScrollView.userInteractionEnabled = YES;
    _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + 100);
    self.commitButton.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commit)];
    [self.commitButton addGestureRecognizer:tap];
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_payView) {
        [_payView removeFromSuperview];
    }
}

#pragma mark -methods
- (void)initUI
{
    WMUserModel * userModel = [[AppSettings sharedInstance] loginObject];
    self.title = @"共享记录详情";
    _commitButton.layer.cornerRadius = 10;
    _commitButton.clipsToBounds = YES;
    _addrLabel.text = _model.requiremodel.address;
    _detailAddrLabel.text = [_model.requiremodel.addr isEqualToString: @""] ? @"用户没输入详细信息" : _model.requiremodel.addr;
    _priceLabel.text = _model.requiremodel.money;
    _orderIdLabel.text = [NSString stringWithFormat:@"订单号:%@", _model.serialNumber];
    if ([_model.userShareModel.userID isEqualToString:userModel.userID]) {
        // 送
        if ([[NSString stringWithFormat:@"%@", _model.status] isEqualToString:@"0"]) {
            // 失败
            _count = 3;
            _tableViewHeight.constant = 220;
            _contentHeight.constant = 650 > SCREEN_HEIGHT ? 650 : SCREEN_HEIGHT;
        } else if ([[NSString stringWithFormat:@"%@", _model.status] isEqualToString:@"1"]) {
            if ([[NSString stringWithFormat:@"%@", _model.sendStatus] isEqualToString:@"0"]) {
                _count = 2;
                _tableViewHeight.constant = 150;
                _contentHeight.constant = 480 + 30 > SCREEN_HEIGHT ? 510 : SCREEN_HEIGHT;
                _commitButton.hidden = NO;
            } else if ([[NSString stringWithFormat:@"%@", _model.sendStatus] isEqualToString:@"1"]) {
                if ([[NSString stringWithFormat:@"%@", _model.payStatus] isEqualToString:@"0"]) {
                    _count = 3;
                    _tableViewHeight.constant = 220;
                    _contentHeight.constant = 650 > SCREEN_HEIGHT ? 650 : SCREEN_HEIGHT;
                } else if ([[NSString stringWithFormat:@"%@", _model.payStatus] isEqualToString:@"1"]) {
                    _count = 4;
                    _tableViewHeight.constant = 300;
                    _contentHeight.constant =  750 > SCREEN_HEIGHT ? 750 : SCREEN_HEIGHT;
                }
            }
        } else if ([[NSString stringWithFormat:@"%@", _model.status] isEqualToString:@"2"]) {
            _count = 4;
            _tableViewHeight.constant = 300;
            _contentHeight.constant = 750 > SCREEN_HEIGHT ? 750 : SCREEN_HEIGHT;
        }
    } else if ([_model.userRequireModel.userID isEqualToString:userModel.userID]) {
        // 收
        if ([[NSString stringWithFormat:@"%@", _model.status] isEqualToString:@"0"]) {
            // 失败
            _count = 3;
            _tableViewHeight.constant = 220;
            _contentHeight.constant = 650 > SCREEN_HEIGHT ? 650 : SCREEN_HEIGHT;
        } else if ([[NSString stringWithFormat:@"%@", _model.status] isEqualToString:@"1"]) {
            if ([[NSString stringWithFormat:@"%@", _model.sendStatus] isEqualToString:@"0"]) {
                _count = 2;
                _tableViewHeight.constant = 150;
                _contentHeight.constant = 510 > SCREEN_HEIGHT ? 510 : SCREEN_HEIGHT;
                _commitButton.hidden = YES;
            } else if ([[NSString stringWithFormat:@"%@", _model.sendStatus] isEqualToString:@"1"]) {
                if ([[NSString stringWithFormat:@"%@", _model.payStatus] isEqualToString:@"0"]) {
                    _count = 3;
                    _tableViewHeight.constant = 220;
                    _contentHeight.constant = 650 > SCREEN_HEIGHT ? 650 : SCREEN_HEIGHT;
                } else if ([[NSString stringWithFormat:@"%@", _model.payStatus] isEqualToString:@"1"]) {
                    _count = 4;
                    _tableViewHeight.constant = 300;
                    _contentHeight.constant = 750 > SCREEN_HEIGHT ? 750 : SCREEN_HEIGHT;
                }
            }
        } else if ([[NSString stringWithFormat:@"%@", _model.status] isEqualToString:@"2"]) {
            _count = 4;
            _tableViewHeight.constant = 300;
            _contentHeight.constant = 750 > SCREEN_HEIGHT ? 750 : SCREEN_HEIGHT;
        }
    }
    
    _orderTableView.dataSource = self;
    _orderTableView.delegate = self;
    _orderTableView.scrollEnabled = NO;
    _orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_orderTableView registerNib:[UINib nibWithNibName:@"WMOrderTableViewCell" bundle:nil] forCellReuseIdentifier:shareCell];
}


- (void)commit
{
    if ([_model.userShareModel.userID isEqualToString:[[AppSettings sharedInstance] loginObject].userID]) {
        [WMRequestHelper shareOrderSendWithOrderID:_model.orderID WithCompletionHandle:^(BOOL success, id dataDic) {
            NSLog(@"%@", dataDic);
            // 重复送达接口有问题
            if ([[NSString stringWithFormat:@"%@", [[dataDic objectForKey:@"meta"] objectForKey:@"code"]] isEqualToString:@"200"]) {
                [[PhoneNotification sharedInstance] autoHideWithText:@"重新送达成功"];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [[PhoneNotification sharedInstance] autoHideWithText:@"网络异常"];
            }
        }];
    } else {
        WMPayView * payView = [[WMPayView alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT - 270, SCREEN_WIDTH -40, 230)];
        payView.orderModel = _model;
        [payView show];
        _payView = payView;
    }
}



#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:shareCell];
    cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", indexPath.row + 1]];
    if (indexPath.row == 0) {
        cell.descLabel.text = @"发起用电请求";
        cell.dateLabel.text = [_model.createTime substringToIndex:10];
        cell.timeLabel.text = [_model.createTime substringFromIndex:11];
        cell.topLine.hidden = YES;
    } else if (indexPath.row == 1) {
        cell.descLabel.text = @"接受派送";
        cell.dateLabel.text = [_model.createTime substringToIndex:10];
        cell.timeLabel.text = [_model.createTime substringFromIndex:11];
        if (![[NSString stringWithFormat:@"%@", _model.sendStatus] isEqualToString:@"0"]) {
            if ([_model.userShareModel.userID isEqualToString:[[AppSettings sharedInstance] loginObject].userID] && [[NSString stringWithFormat:@"%@", _model.sendStatus] isEqualToString:@"0"]) {
                //            [_commitButton setTitle:@"确认送达" forState:UIControlStateNormal];
                _commitButton.text = @"确认送达";
                _commitButton.hidden = NO;
                cell.underLabel.hidden = YES;
            }
        }
        
    } else if (indexPath.row == 2) {
        if (_count == 3) {
            if ([_model.userShareModel.userID isEqualToString:[[AppSettings sharedInstance] loginObject].userID]){
                // 送
                if ([[NSString stringWithFormat:@"%@", _model.status] isEqualToString:@"0"]) {
                    cell.dateLabel.text = [_model.cancelTime substringToIndex:10];
                    cell.timeLabel.text = [_model.cancelTime substringFromIndex:11];
                    cell.descLabel.text = @"用户取消";
                    cell.underLabel.hidden = YES;
                    cell.descLabel.textColor = [UIColor redColor];
                     _commitButton.hidden = YES;
                } else if ([[NSString stringWithFormat:@"%@", _model.status] isEqualToString:@"1"]) {
                    if ([[NSString stringWithFormat:@"%@", _model.sendStatus] isEqualToString:@"1"]) {
                        cell.dateLabel.text = [_model.sendTime substringToIndex:10];
                        cell.timeLabel.text = [_model.sendTime substringFromIndex:11];
                        cell.descLabel.text = @"等待支付";
                        cell.underLabel.hidden = YES;
                        cell.descLabel.textColor = [UIColor redColor];
//                        [_commitButton setTitle:@"确认送达" forState:UIControlStateNormal];
                        _commitButton.text = @"确认送达";
                         _commitButton.hidden = NO;
                    }
                }
            } else if ([_model.userRequireModel.userID isEqualToString:[[AppSettings sharedInstance] loginObject].userID]) {
                // 收
                if ([[NSString stringWithFormat:@"%@", _model.status] isEqualToString:@"0"]) {
                    cell.dateLabel.text = [_model.cancelTime substringToIndex:10];
                    cell.timeLabel.text = [_model.cancelTime substringFromIndex:11];
                    cell.descLabel.text = @"用户取消";
                    cell.underLabel.hidden = YES;
                    cell.descLabel.textColor = [UIColor redColor];
                    _commitButton.hidden = YES;

                } else if ([[NSString stringWithFormat:@"%@", _model.status] isEqualToString:@"1"]) {
                    if ([[NSString stringWithFormat:@"%@", _model.sendStatus] isEqualToString:@"1"]) {
                        if ([[NSString stringWithFormat:@"%@", _model.payStatus] isEqualToString:@"0"]) {
                            cell.dateLabel.text = [_model.sendTime substringToIndex:10];
                            cell.timeLabel.text = [_model.sendTime substringFromIndex:11];
                            cell.descLabel.text = @"派送成功";
                            cell.descLabel.textColor = [UIColor redColor];
                            cell.underLabel.hidden = YES;
//                            [_commitButton setTitle:@"确认支付" forState:UIControlStateNormal];
                            _commitButton.text = @"确认支付";
                            _commitButton.hidden = NO;
                        }
                    }
                }
            }

            
          
        }
    } else if (indexPath.row == 3) {
        if ([_model.userShareModel.userID isEqualToString:[[AppSettings sharedInstance] loginObject].userID]) {
            cell.descLabel.text = @"派送成功";
        } else {
            cell.descLabel.text = @"支付成功";
        }
        
        cell.underLabel.hidden = YES;
        _commitButton.hidden = YES;
    }
    return cell;
}
#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


@end
