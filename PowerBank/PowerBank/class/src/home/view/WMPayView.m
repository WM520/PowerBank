//
//  WMPayView.m
//  PowerBank
//
//  Created by baiju on 2017/8/7.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMPayView.h"
#import "XBSettingItemModel.h"
#import "XBSettingSectionModel.h"
#import "XBSettingCell.h"
#import "WMOrderModel.h"
#import "WXPayTool.h"
#import <AlipaySDK/AlipaySDK.h>

static NSString * cellID = @"cellID";
@interface WMPayView ()
<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) UITableView * payListView;
@property (nonatomic, strong) UIButton * cancleButton;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) XBSettingItemModel * item1;

@end

@implementation WMPayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    WMUserModel * model = [[AppSettings sharedInstance] loginObject];
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    _cancleButton = [[UIButton alloc] init];
    [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancleButton setBackgroundColor:[UIColor blackColor]];
    [_cancleButton addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview: _cancleButton];
    
    XBSettingItemModel *item1 = [[XBSettingItemModel alloc]init];
    item1.funcName = @"需要支付 ￥15.00";
    _item1 = item1;
    
    XBSettingItemModel *item2 = [[XBSettingItemModel alloc]init];
    item2.funcName = @"余额支付";
    item2.detailText = [NSString stringWithFormat:@"%@￥", model.userBalance];
    item2.img = [UIImage imageNamed:@"BalancePay"];
    item2.executeCode = ^{
        
    };
    
    XBSettingItemModel *item3 = [[XBSettingItemModel alloc]init];
    item3.funcName = @"微信支付";
    item3.img = [UIImage imageNamed:@"WechatPay"];
    item3.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingItemModel *item4 = [[XBSettingItemModel alloc]init];
    item4.funcName = @"支付宝支付";
    item4.img = [UIImage imageNamed:@"Alipay"];
    item4.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    item4.executeCode = ^{
        
    };
    
    
    
    XBSettingSectionModel *section1 = [[XBSettingSectionModel alloc]init];
    section1.sectionHeaderHeight = 18;
    section1.itemArray = @[item1, item2, item3, item4];
    
    [self.dataArray addObject:section1];
    
    _payListView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    _payListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _payListView.scrollEnabled = NO;
    _payListView.delegate = self;
    _payListView.dataSource = self;
    [_payListView registerClass:[XBSettingCell class] forCellReuseIdentifier:cellID];
    [self addSubview:_payListView];
    [self setUpLayout];
}

- (void)setOrderModel:(WMOrderModel *)orderModel
{
    _orderModel = orderModel;
    _item1.funcName = [NSString stringWithFormat:@"需要支付:%@￥", _orderModel.money];
    [_payListView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    XBSettingSectionModel *sectionModel = self.dataArray[section];
    return sectionModel.itemArray.count;
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
    cell.cellwidth = self.width;
    cell.item = itemModel;
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld", indexPath.row);
    
    if(indexPath.row == 1) {
        if ([_orderModel.money integerValue] > [[[AppSettings sharedInstance] loginObject].userBalance integerValue]) {
            [[PhoneNotification sharedInstance] autoHideWithText:@"余额不足"];
            return;
        }
        // 余额支付
        [WMRequestHelper payBalanceWithOrderId:_orderModel.orderID fee:[_orderModel.money intValue] money:_orderModel.money  withCompletionHandle:^(BOOL success, id dataDic) {
            if (success) {
                NSDictionary * metaDic = [dataDic objectForKey:@"meta"];
                if ([[NSString stringWithFormat:@"%@", [metaDic objectForKey:@"code"]] isEqualToString:@"200"]) {
                    [[PhoneNotification sharedInstance] autoHideWithText:@"支付成功"];
                    [self removeFromSuperview];
                }
            }
        }];
    } else if (indexPath.row == 2) { // 微信支付
        [WMRequestHelper payWechatWithBody:nil detail:nil orderId:_orderModel.orderID fee:[_orderModel.money intValue] money:_orderModel.money withCompletionHandle:^(BOOL success, id dataDic) {
            if (success) {
                if ([[NSString stringWithFormat:@"%@", [[dataDic objectForKey:@"meta"] objectForKey:@"code"]] isEqualToString:@"200"]) {
                    [[WXPayTool shareWXPayTool] onlineWXPay:_orderModel.orderID info:[dataDic objectForKey:@"data"] withCompletionBlock:^(WXPayResultType wxpayResultHandle) {
                        NSLog(@"%lu", (unsigned long)wxpayResultHandle);
                        if (wxpayResultHandle == WXPayResultTypeSuccess) {
                            [[PhoneNotification sharedInstance] autoHideWithText:@"支付成功"];
                            [self removeFromSuperview];
                        } else if (wxpayResultHandle == WXPayResultTypeCanceled) {
                            [[PhoneNotification sharedInstance] autoHideWithText:@"用户取消支付"];
                        } else if (wxpayResultHandle == WXPayResultTypeFailed) {
                            [[PhoneNotification sharedInstance] autoHideWithText:@"支付失败"];
                        }
                    }];
                }
            }
        }];
    } else if (indexPath.row == 3) { // 支付宝支付
        [WMRequestHelper payAliPayWithTitle:nil orderId:_orderModel.orderID fee:[_orderModel.money intValue] money:_orderModel.money withCompletionHandle:^(BOOL success, id dataDic) {
            if (success) {
                if ([[NSString stringWithFormat:@"%@", [[dataDic objectForKey:@"meta"] objectForKey:@"code"]] isEqualToString:@"200"]) {
                    //    支付宝返回结果
                    [[AlipaySDK defaultService] payOrder:[dataDic objectForKey:@"data"] fromScheme:@"OOL" callback:^(NSDictionary *resultDic) {
                        NSString *resultStatus = resultDic[@"resultStatus"];
                        if ([resultStatus isEqualToString:@"9000"]) {
                            //支付成功
                            [[PhoneNotification sharedInstance] autoHideWithText:@"支付成功"];
                            [self removeFromSuperview];
                            
                        }else if ([resultStatus isEqualToString:@"6001"]){
                            //支付取消
                            [[PhoneNotification sharedInstance] autoHideWithText:@"支付取消"];
                        }else if ([resultStatus isEqualToString:@"4000"]){
                            //支付失败
                            [[PhoneNotification sharedInstance] autoHideWithText:@"支付失败"];
                        }else{
                            //未知错误
                            [[PhoneNotification sharedInstance] autoHideWithText:@"未知支付"];
                        }

                    }];

                }
            }
        }];
    }
    
}


- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    window.userInteractionEnabled = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [window addSubview:self];
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = .25;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.layer addAnimation:animation forKey:nil];
}

// 移除
- (void)hide {
    [UIView animateWithDuration:.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)cancle
{
    [self hide];
}

// 初始化约束
- (void)setUpLayout
{
    _payListView.sd_layout
    .topEqualToView(self)
    .leftEqualToView(self)
    .rightEqualToView(self)
    .bottomSpaceToView(self, 40);
    
    _cancleButton.sd_layout
    .bottomEqualToView(self)
    .rightEqualToView(self)
    .leftEqualToView(self)
    .heightIs(40);
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
