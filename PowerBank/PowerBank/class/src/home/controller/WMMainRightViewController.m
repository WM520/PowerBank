//
//  WMMainRightViewController.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/24.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMMainRightViewController.h"
#import "WMMAPointAnnotation.h"
#import "WMReceiveOrderView.h"
#import "WMSettingsView.h"
#import "WMRequireModel.h"
#import "WMCustomRightAnnotionView.h"
#import "WMRequireAnnotation.h"
#import "WMShareOrderModel.h"
#import "WMUserModel.h"
#import "WMOrderModel.h"

static NSString * ReceiverCellID = @"receivercell";

@interface WMMainRightViewController ()
<MAMapViewDelegate,
WMScopeViewDelegate,
WMListHeadViewDeleagte,
UITableViewDelegate,
UITableViewDataSource,
WMHaveNoOpenShareViewDelegate,
AMapLocationManagerDelegate,
WMReceiveOrderTableViewCellDelegate,
WMCustomRightAnnotionViewDelegate>

@property (nonatomic, strong) WMReceiveOrderView * receiveOrderView;
@property (nonatomic, strong) WMSettingsView * settingsView;
@property (nonatomic, strong) NSMutableArray * annotationsArray;
@property (nonatomic, strong) WMShareOrderModel * model;
@property (nonatomic, copy) NSString * deviceID;
@property (nonatomic, copy)NSString * distance;
@property (nonatomic, copy) WMOrderModel * orderModel;

@end

@implementation WMMainRightViewController

#pragma mark -lifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    // 初始化界面
    [self initUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openShareAction:) name:@"share" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideSettingsView) name:@"settingsViewHidden" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeShareAction) name:@"closeshare" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exit) name:@"exit" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isScopeView && _isVisabel == 1) {
        _scopeView.hidden = NO;
    }
    
    if ([AppSettings checkIsLogin]) {
        [WMRequestHelper getUserShareWithCompletionHandle:^(BOOL success, id dataDic) {
            if (success) {
                if ([[NSString stringWithFormat:@"%@", [[dataDic objectForKey:@"meta"] objectForKey:@"code"]] isEqualToString:@"200"]) {
                    NSDictionary * dicData = [dataDic objectForKey:@"data"];
                    if ([dicData isKindOfClass:[NSDictionary class]]) {
                        if ([[NSString stringWithFormat:@"%@", [dicData objectForKey:@"status"]] isEqualToString:@"1"]) {
                            WMShareOrderModel * model = [WMShareOrderModel modelWithDictionary:dicData];
                            _model = model;
                            // 存在共享充电宝
                            [[NSNotificationCenter defaultCenter]  postNotificationName:@"haveshareorder" object:nil];
                        }
                    }
                    
                    if ([dicData isKindOfClass:[NSDictionary class]]) {
                        if ([[NSString stringWithFormat:@"%@", [dicData objectForKey:@"status"]] isEqualToString:@"2"]) {
                            [WMRequestHelper getUserShareOrderWithCompletionHandle:^(BOOL success, id dataDic) {
                                NSLog(@"%@", dataDic);
                                if (success) {
                                    if ([[NSString stringWithFormat:@"%@", [[dataDic objectForKey:@"meta"] objectForKey:@"code"]] isEqualToString:@"200"] && [[dataDic objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                                        if (!_receiveOrderView) {
                                            WMOrderModel * model = [WMOrderModel modelWithDictionary:[dataDic objectForKey:@"data"]];
                                            _orderModel = model;
                                            NSLog(@"%@", model);
                                            WMReceiveOrderView * receivedOrderView = [[NSBundle mainBundle] loadNibNamed:@"WMReceiveOrderView" owner:self options:nil].firstObject;
                                            receivedOrderView.model = model;
                                            // 核心动画
                                            CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
                                            animation.duration = .25;
                                            NSMutableArray *values = [NSMutableArray array];
                                            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)]];
                                            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.0)]];
                                            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
                                            animation.values = values;
                                            [receivedOrderView.layer addAnimation:animation forKey:nil];
                                            kWeakSelf(self);
                                            receivedOrderView.cancleBlock = ^{
                                                _isReceiveOrder = NO;
                                                [weakself cancleOrder];
                                                [UIView animateWithDuration:.25 animations:^{
                                                    weakself.receiveOrderView.alpha = 0;
                                                } completion:^(BOOL finished) {
                                                    [weakself.receiveOrderView removeFromSuperview];
                                                }];
                                            };
                                            receivedOrderView.commitBlock = ^{
                                                [weakself orderSended];
                                                [UIView animateWithDuration:.25 animations:^{
                                                    weakself.receiveOrderView.alpha = 0;
                                                } completion:^(BOOL finished) {
                                                    [weakself.receiveOrderView removeFromSuperview];
                                                }];
                                            };
                                            
                                            receivedOrderView.frame = CGRectMake(20, 60, SCREEN_WIDTH - 40, 220);
                                            [self.view addSubview:receivedOrderView];
                                            _isReceiveOrder = YES;
                                            _receiveOrderView = receivedOrderView;
                                        }
                                    }
                                }
                            }];
                            
                        }
                    }
                }
                else if([[NSString stringWithFormat:@"%@", [[dataDic objectForKey:@"meta"] objectForKey:@"code"]] isEqualToString:@"401"]) {
                    [[PhoneNotification sharedInstance] autoHideWithText:@"重新登录"];
                }
            }
        }];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_isScopeView) {
        _scopeView.hidden = YES;
    }
}

#pragma mark -init
- (void)initData
{
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    [self.locationManager setAllowsBackgroundLocationUpdates:NO];
    [self.locationManager startUpdatingLocation];
    _isFirstShare = NO;
    _isScan = NO;
}

- (void)initUI
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    _isScopeView = false;
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.currentLocationButton];
    [self.view addSubview:self.refreshButton];
    [self.view addSubview:self.swithMode];
    
    _swithMode.frame = CGRectMake(SCREEN_WIDTH - 50, 20, 40, 40);
    _refreshButton.sd_layout
    .leftSpaceToView(self.view, 10)
    .bottomSpaceToView(self.view, 130)
    .widthIs(40)
    .heightIs(40);
    
    _currentLocationButton.sd_layout
    .leftSpaceToView(self.view, 10)
    .widthIs(40)
    .heightIs(40)
    .bottomSpaceToView(self.view, 80);
    
}

#pragma mark - methods
- (void)cancleOrder
{
    WMUserModel * userModel = [[AppSettings sharedInstance] loginObject];
    if ([userModel.cancelShareCountLimit integerValue] > 5) {
        [[PhoneNotification sharedInstance] autoHideWithText:@"您取消订单的次数已到上限"];
        return;
    }
    [WMRequestHelper deleteUserShareOrder:_receiveOrderView.model.orderID withCompletionHandle:^(BOOL success, id dataDic) {
        NSLog(@"%@", dataDic);
        if ([[NSString stringWithFormat:@"%@", [[dataDic objectForKey:@"meta"] objectForKey:@"code"]] isEqualToString:@"200"]) {
            [[PhoneNotification sharedInstance] autoHideWithText:@"订单取消成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"orderCancle" object:nil];
        } else {
            [[PhoneNotification sharedInstance] autoHideWithText:@"订单取消失败"];
        }
    }];
}

// 确认送达
- (void)orderSended
{
    [WMRequestHelper shareOrderSendWithOrderID:_orderModel.orderID WithCompletionHandle:^(BOOL success, id dataDic) {
        if ([[NSString stringWithFormat:@"%@", [[dataDic objectForKey:@"meta"] objectForKey:@"code"]] isEqualToString:@"200"]) {
            [[PhoneNotification sharedInstance] autoHideWithText:@"等待客户付款"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"orderEnded" object:nil];
            [_receiveOrderView removeFromSuperview];
            _receiveOrderView = nil;
        } else {
            [[PhoneNotification sharedInstance] autoHideWithText:@"网络异常"];
        }
    }];
}

- (void)currentLocation
{
    NSLog(@"currentLocation");
     [self.locationManager startUpdatingLocation];
}

- (void)refresh
{
    NSLog(@"refresh");
    [WMRequestHelper getPIOList:_distance longitude:[NSString stringWithFormat:@"%lf", _nowLocation.coordinate.longitude] latitude:[NSString stringWithFormat:@"%lf", _nowLocation.coordinate.latitude] filter:nil sort:nil limit:@"100" page:@"1" withCompletionHandle:^(BOOL success, id dataDic) {
        if (success) {
            NSLog(@"%@", dataDic);
            if ([[dataDic objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                NSArray * dataArray = [dataDic objectForKey:@"data"];
                [self.mapView removeAnnotations:self.annotationsArray];
                [self.walletAnnotationArray removeAllObjects];
                [self.annotationsArray removeAllObjects];
                for (int i = 0; i < dataArray.count; i++) {
                    WMRequireModel * model = [WMRequireModel modelWithDictionary:dataArray[i]];
                    [self.walletAnnotationArray addObject:model];
                }
                
                for (int i = 0; i < self.walletAnnotationArray.count; i++) {
                    WMRequireAnnotation * pointAnnotation = [[WMRequireAnnotation alloc] init];
                    CLLocationCoordinate2D coor ;
                    WMRequireModel * model = self.walletAnnotationArray[i];
                    coor.latitude = [model.latitude floatValue];
                    coor.longitude = [model.longitude floatValue];
                    pointAnnotation.coordinate = coor;
                    pointAnnotation.model = model;
                    
                    [self.annotationsArray addObject:pointAnnotation];
                }
                [self.mapView addAnnotations:self.annotationsArray];
            }
        }
    }];

}

- (void)swithModeAction
{
    _swithMode.selected = !_swithMode.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addressMode" object:nil];
    _swithMode.hidden = YES;
    if (self.isShareSelected) {
        WMListHeadView * listHeadView = [[WMListHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        listHeadView.delegate = self;
        self.listTableView.tableHeaderView = listHeadView;
        [self.listTableView reloadData];
        _mapView.hidden = YES;
        [self.view insertSubview:self.listTableView atIndex:3];
    } else {
        WMHaveNoOpenShareView * haveNoOpenShareView = [[WMHaveNoOpenShareView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 41)];
        haveNoOpenShareView.delegate = self;
        [self.view insertSubview:haveNoOpenShareView atIndex:3];
        _haveNoOpenShareView = haveNoOpenShareView;
        _mapView.hidden = YES;
    }

}

#pragma mark - notifocation methods
- (void)openShareAction:(NSNotification *)noti
{
    NSLog(@"%@", noti.object);
    if (_isReceiveOrder) {
        return;
    }
    
    if (!_scopeView) {
        WMScopeView * scopeView = [[WMScopeView alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT - 240, SCREEN_WIDTH -20, 200)];
        scopeView.type = ScopeTypeNoScan;
        scopeView.delegate = self;
        _scopeView = scopeView;
        [_scopeView show];
    }
}


- (void)closeShareAction
{
    [self.mapView removeAnnotations:self.annotationsArray];
    [self.walletAnnotationArray removeAllObjects];
    self.annotationsArray = nil;
    self.deviceID = nil;
    self.scopeView = nil;
    
    if (_model) {
        // 正常流程接单后关闭共享的操作，取消共享
        [WMRequestHelper getUserShare:_model.orderID WithCompletionHandle:^(BOOL success, id dataDic) {
            NSLog(@"%@", dataDic);
            if ([[NSString stringWithFormat:@"%@", [[dataDic objectForKey:@"meta"] objectForKey:@"code"]] isEqualToString:@"200"]) {
                [[PhoneNotification sharedInstance] autoHideWithText:@"共享取消成功"];
            }
        }];
    } else { // 接单状态的关闭共享操作,取消订单
//        [[PhoneNotification sharedInstance] autoHideWithText:@"你有正在进行的订单"];
    }
}

- (void)openWithDeviceId:(NSString *)deviceId distance:(NSString *)distance
{
    [WMRequestHelper addUserShare:[NSString stringWithFormat:@"%f", _nowLocation.coordinate.longitude] latitude:[NSString stringWithFormat:@"%f", _nowLocation.coordinate.latitude] addr:@"红色恋人" address:@"白色地址" quantity:@"100" device:deviceId WithCompletionHandle:^(BOOL success, id dataDic) {
        if(success) {
            NSDictionary * metaDic = [dataDic objectForKey:@"meta"];
            if ([[NSString stringWithFormat:@"%@", [metaDic objectForKey:@"code"]] isEqualToString:@"200"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"opensuccess" object:nil];
                WMShareOrderModel * model = [WMShareOrderModel modelWithDictionary:[dataDic objectForKey:@"data"]];
                _model = model;
                if (_swithMode.hidden) {
                    WMListHeadView * listHeadView = [[WMListHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
                    listHeadView.delegate = self;
                    self.listTableView.tableHeaderView = listHeadView;
                    _mapView.hidden = YES;
                    [self.view insertSubview:self.listTableView atIndex:3];
                    [_haveNoOpenShareView removeFromSuperview];
                } else {
                    [WMRequestHelper getPIOList:distance longitude:[NSString stringWithFormat:@"%lf", _nowLocation.coordinate.longitude] latitude:[NSString stringWithFormat:@"%lf", _nowLocation.coordinate.latitude] filter:nil sort:nil limit:@"100" page:@"1" withCompletionHandle:^(BOOL success, id dataDic) {
                        if (success) {
                            NSLog(@"%@", dataDic);
                            if ([[dataDic objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                                NSArray * dataArray = [dataDic objectForKey:@"data"];
                                for (int i = 0; i < dataArray.count; i++) {
                                    WMRequireModel * model = [WMRequireModel modelWithDictionary:dataArray[i]];
                                    [self.walletAnnotationArray addObject:model];
                                }
                                
                                for (int i = 0; i < self.walletAnnotationArray.count; i++) {
                                    WMRequireAnnotation * pointAnnotation = [[WMRequireAnnotation alloc] init];
                                    CLLocationCoordinate2D coor ;
                                    WMRequireModel * model = self.walletAnnotationArray[i];
                                    coor.latitude = [model.latitude floatValue];
                                    coor.longitude = [model.longitude floatValue];
                                    pointAnnotation.coordinate = coor;
                                    pointAnnotation.model = model;
                                    
                                    [self.annotationsArray addObject:pointAnnotation];
                                }
                                [self.mapView addAnnotations:self.annotationsArray];
                            }
                        }
                    }];
                }
            } else {
                if ([[NSString stringWithFormat:@"%@", [metaDic objectForKey:@"code"]] isEqualToString:@"9100"]) {
                    [[PhoneNotification sharedInstance] autoHideWithText:@"您有正在进行的共享订单"];
                } else if ([[NSString stringWithFormat:@"%@", [metaDic objectForKey:@"code"]] isEqualToString:@"402"]){
                    self.deviceID = nil;
                    [[PhoneNotification sharedInstance] autoHideWithText:@"NO FREE TIMES"];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"openfailed" object:nil];
            }
        }
    }];
}

- (void)hideSettingsView
{
    _settingsView = nil;
}

- (void)exit
{
    if (_scopeView) {
        [_scopeView hide];
    }
    if (_receiveOrderView) {
        [_receiveOrderView removeFromSuperview];
    }
}
#pragma mark -WMListHeadViewDeleagte
- (void)comprehensiveSortAction
{
    if (_settingsView) {
        [_settingsView removeFromSuperview];
        _settingsView = nil;
    }
    // 删除原有的model
    [self.walletAnnotationArray removeAllObjects];
    
    [WMRequestHelper getPIOList:@"3000" longitude:[NSString stringWithFormat:@"%lf", _nowLocation.coordinate.longitude] latitude:[NSString stringWithFormat:@"%lf", _nowLocation.coordinate.latitude] filter:nil sort:nil limit:@"100" page:@"1" withCompletionHandle:^(BOOL success, id dataDic) {
        if (success) {
            NSLog(@"%@", dataDic);
            if ([[dataDic objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                NSArray * dataArray = [dataDic objectForKey:@"data"];
                for (int i = 0; i < dataArray.count; i++) {
                    WMRequireModel * model = [WMRequireModel modelWithDictionary:dataArray[i]];
                    [self.walletAnnotationArray addObject:model];
                }
            }
        }
    }];

    
}
- (void)moneySortSortAction
{
    if (_settingsView) {
        [_settingsView removeFromSuperview];
        _settingsView = nil;
    }
    
    // 删除原有的model
    [self.walletAnnotationArray removeAllObjects];
    
    [WMRequestHelper getPIOList:@"3000" longitude:[NSString stringWithFormat:@"%lf", _nowLocation.coordinate.longitude] latitude:[NSString stringWithFormat:@"%lf", _nowLocation.coordinate.latitude] filter:nil sort:nil limit:@"100" page:@"1" withCompletionHandle:^(BOOL success, id dataDic) {
        if (success) {
            NSLog(@"%@", dataDic);
            if ([[dataDic objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                NSArray * dataArray = [dataDic objectForKey:@"data"];
                for (int i = 0; i < dataArray.count; i++) {
                    WMRequireModel * model = [WMRequireModel modelWithDictionary:dataArray[i]];
                    [self.walletAnnotationArray addObject:model];
                }
            }
        }
    }];

    
}
- (void)distanceSortSortAction
{
    if (_settingsView) {
        [_settingsView removeFromSuperview];
        _settingsView = nil;
    }
    
    // 删除原有的model
    [self.walletAnnotationArray removeAllObjects];
    
    [WMRequestHelper getPIOList:@"3000" longitude:[NSString stringWithFormat:@"%lf", _nowLocation.coordinate.longitude] latitude:[NSString stringWithFormat:@"%lf", _nowLocation.coordinate.latitude] filter:nil sort:nil limit:@"100" page:@"1" withCompletionHandle:^(BOOL success, id dataDic) {
        if (success) {
            NSLog(@"%@", dataDic);
            if ([[dataDic objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                NSArray * dataArray = [dataDic objectForKey:@"data"];
                for (int i = 0; i < dataArray.count; i++) {
                    WMRequireModel * model = [WMRequireModel modelWithDictionary:dataArray[i]];
                    [self.walletAnnotationArray addObject:model];
                }
            }
        }
    }];

}
- (void)swithAddressModeAction
{
    if (_settingsView) {
        [_settingsView removeFromSuperview];
        _settingsView = nil;
    }
    [_listTableView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mapMode" object:nil];
    _swithMode.hidden = NO;
    _mapView.hidden = NO;
}

- (void)settingsAction
{
    if (!_settingsView) {
        WMSettingsView * view = [[WMSettingsView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44)];
        kWeakSelf(self);
        view.block = ^(CGFloat distance){
            NSLog(@"获取接口");
            // 删除原有的model
            [weakself.walletAnnotationArray removeAllObjects];
            
            [WMRequestHelper getPIOList:[NSString stringWithFormat:@"%.0f", distance] longitude:[NSString stringWithFormat:@"%lf", _nowLocation.coordinate.longitude] latitude:[NSString stringWithFormat:@"%lf", _nowLocation.coordinate.latitude] filter:nil sort:nil limit:@"100" page:@"1" withCompletionHandle:^(BOOL success, id dataDic) {
                if (success) {
                    NSLog(@"%@", dataDic);
                    if ([[dataDic objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                        NSArray * dataArray = [dataDic objectForKey:@"data"];
                        for (int i = 0; i < dataArray.count; i++) {
                            WMRequireModel * model = [WMRequireModel modelWithDictionary:dataArray[i]];
                            [weakself.walletAnnotationArray addObject:model];
                        }
                    }
                }
            }];
            [weakself hideSettingsView];
        };
        [self.view addSubview:view];
        CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animation.duration = .25;
        NSMutableArray *values = [NSMutableArray array];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        animation.values = values;
        [view.layer addAnimation:animation forKey:nil];
        _settingsView = view;
    } else {
        [_settingsView hide];
    }
}


#pragma mark -WMHaveNoOpenShareViewDelegate
- (void)swithToAddress
{
    [_haveNoOpenShareView removeFromSuperview];
    _swithMode.hidden = NO;
    _mapView.hidden = NO;
}


#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}


#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.walletAnnotationArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMReceiveOrderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ReceiverCellID];
    cell.delegate = self;
    cell.nowLocation = _nowLocation;
    cell.model = self.walletAnnotationArray[indexPath.row];
    return cell;
}

#pragma mark -MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (_scopeView) {
        if (!_isFirstShare) {
            [_scopeView hide];
            _scopeView = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"closeShare" object:nil];
        }
    }
}

#pragma mark -AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    //定位错误
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    if (!_nowLocation) {
        _nowLocation = location;
        //定位结果
        CLLocationCoordinate2D currentLocation;
        currentLocation.latitude = location.coordinate.latitude;
        currentLocation.longitude = location.coordinate.longitude;
        _mapView.centerCoordinate = currentLocation;
        
        WMMAPointAnnotation *pointAnnotation = [[WMMAPointAnnotation alloc] init];
        pointAnnotation.isCurrent = YES;
        pointAnnotation.coordinate = currentLocation;
        [self.mapView addAnnotation:pointAnnotation];
    }
    
    CLLocationCoordinate2D currentLocation;
    currentLocation.latitude = location.coordinate.latitude;
    currentLocation.longitude = location.coordinate.longitude;
    _mapView.centerCoordinate = currentLocation;
    
    // 停止定位
    [self.locationManager stopUpdatingLocation];
}


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        
        return nil;
    }
    
    
    if ([annotation isKindOfClass:[WMMAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.image = [UIImage imageNamed:@"currentLocation-1"];
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.draggable = NO;        //设置标注可以拖动，默认为NO
        return annotationView;
    }
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        WMCustomRightAnnotionView *annotationView = (WMCustomRightAnnotionView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[WMCustomRightAnnotionView alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:reuseIndetifier];
        }
        annotationView.delegate = self;
        WMRequireAnnotation * requireAnnotation = annotation;
        annotationView.image = [UIImage imageNamed:@"rightAnnomation"];
        annotationView.startCLLocation = _nowLocation.coordinate;
        annotationView.nowLocation = _nowLocation;
        annotationView.canShowCallout               = NO;
        annotationView.model = requireAnnotation.model;
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}
#pragma mark - WMReceiveOrderTableViewCellDelegate
- (void)receiveOrder:(WMReceiveOrderTableViewCell *)cell
{
    WMUserModel * usermodel = [[AppSettings sharedInstance] loginObject];
    NSString * urid = cell.model.requireID;
    NSString * uruid = cell.model.uid;
    NSString * usid = _model.orderID;
    NSString * usuid = usermodel.userID;
    NSString * device = _model.device;
    NSString * quantity = _model.quantity;
    NSString * money = cell.model.money;
    [WMRequestHelper receiptList:urid usid:usid uruid:uruid usuid:usuid device:device quantity:quantity money:money withCompletionHandle:^(BOOL success, id dataDic) {
        if ([[[dataDic objectForKey:@"meta"] objectForKey:@"msg"] isEqualToString:@"OK"]) {
            NSLog(@"%@", [dataDic objectForKey:@"meta"]);
            [WMRequestHelper getUserShareWithCompletionHandle:^(BOOL success, id dataDic) {
                if (success) {
                    if ([[NSString stringWithFormat:@"%@", [[dataDic objectForKey:@"meta"] objectForKey:@"code"]] isEqualToString:@"200"]) {
                        NSDictionary * dicData = [dataDic objectForKey:@"data"];
                        if ([dicData isKindOfClass:[NSDictionary class]]) {
                            if ([[NSString stringWithFormat:@"%@", [dicData objectForKey:@"status"]] isEqualToString:@"2"]) {
                                [WMRequestHelper getUserShareOrderWithCompletionHandle:^(BOOL success, id dataDic) {
                                    NSLog(@"%@", dataDic);
                                    if (success) {
                                        WMOrderModel * model = [WMOrderModel modelWithDictionary:[dataDic objectForKey:@"data"]];
                                        NSLog(@"%@", model);
                                        _orderModel = model;
                                        WMReceiveOrderView * receivedOrderView = [[NSBundle mainBundle] loadNibNamed:@"WMReceiveOrderView" owner:self options:nil].firstObject;
                                        receivedOrderView.model = model;
                                        // 核心动画
                                        CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
                                        animation.duration = .25;
                                        NSMutableArray *values = [NSMutableArray array];
                                        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)]];
                                        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.0)]];
                                        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
                                        animation.values = values;
                                        [receivedOrderView.layer addAnimation:animation forKey:nil];
                                        kWeakSelf(self);
                                        receivedOrderView.cancleBlock = ^{
                                            _isReceiveOrder = NO;
                                            [weakself cancleOrder];
                                            [UIView animateWithDuration:.25 animations:^{
                                                weakself.receiveOrderView.alpha = 0;
                                            } completion:^(BOOL finished) {
                                                [weakself.receiveOrderView removeFromSuperview];
                                            }];
                                        };
                                        receivedOrderView.commitBlock = ^{
                                            [weakself orderSended];
                                            [UIView animateWithDuration:.25 animations:^{
                                                weakself.receiveOrderView.alpha = 0;
                                            } completion:^(BOOL finished) {
                                                [weakself.receiveOrderView removeFromSuperview];
                                            }];
                                        };
                                        receivedOrderView.frame = CGRectMake(20, 60, SCREEN_WIDTH - 40, 220);
                                        [self.view addSubview:receivedOrderView];
                                        _isReceiveOrder = YES;
                                        _receiveOrderView = receivedOrderView;
                                    }
                                }];
                                
                            }
                        }
                    }
                    else if([[NSString stringWithFormat:@"%@", [[dataDic objectForKey:@"meta"] objectForKey:@"code"]] isEqualToString:@"401"]) {
                        [[PhoneNotification sharedInstance] autoHideWithText:@"重新登录"];
                    }
                }
            }];
            
        }
    }];
}

#pragma mark - WMCustomRightAnnotionViewDelegate
- (void)receiveOrderAction:(WMRequireModel *)model
{
    WMUserModel * usermodel = [[AppSettings sharedInstance] loginObject];
    NSString * urid = model.requireID;
    NSString * uruid = model.uid;
    NSString * usid = _model.orderID;
    NSString * usuid = usermodel.userID;
    NSString * device = _model.device;
    NSString * quantity = _model.quantity;
    NSString * money = model.money;
    [WMRequestHelper receiptList:urid usid:usid uruid:uruid usuid:usuid device:device quantity:quantity money:money withCompletionHandle:^(BOOL success, id dataDic) {
        if ([[[dataDic objectForKey:@"meta"] objectForKey:@"msg"] isEqualToString:@"OK"]) {
            NSLog(@"%@", [dataDic objectForKey:@"meta"]);
            [WMRequestHelper getUserShareWithCompletionHandle:^(BOOL success, id dataDic) {
                if (success) {
                    if ([[NSString stringWithFormat:@"%@", [[dataDic objectForKey:@"meta"] objectForKey:@"code"]] isEqualToString:@"200"]) {
                        NSDictionary * dicData = [dataDic objectForKey:@"data"];
                        if ([dicData isKindOfClass:[NSDictionary class]]) {
                            if ([[NSString stringWithFormat:@"%@", [dicData objectForKey:@"status"]] isEqualToString:@"2"]) {
                                [WMRequestHelper getUserShareOrderWithCompletionHandle:^(BOOL success, id dataDic) {
                                    NSLog(@"%@", dataDic);
                                    if (success) {
                                        WMOrderModel * model = [WMOrderModel modelWithDictionary:[dataDic objectForKey:@"data"]];
                                        NSLog(@"%@", model);
                                        _orderModel = model;
                                        WMReceiveOrderView * receivedOrderView = [[NSBundle mainBundle] loadNibNamed:@"WMReceiveOrderView" owner:self options:nil].firstObject;
                                        receivedOrderView.model = model;
                                        // 核心动画
                                        CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
                                        animation.duration = .25;
                                        NSMutableArray *values = [NSMutableArray array];
                                        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)]];
                                        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.0)]];
                                        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
                                        animation.values = values;
                                        [receivedOrderView.layer addAnimation:animation forKey:nil];
                                        kWeakSelf(self);
                                        receivedOrderView.cancleBlock = ^{
                                            _isReceiveOrder = NO;
                                            [weakself cancleOrder];
                                            [UIView animateWithDuration:.25 animations:^{
                                                weakself.receiveOrderView.alpha = 0;
                                            } completion:^(BOOL finished) {
                                                [weakself.receiveOrderView removeFromSuperview];
                                            }];
                                        };
                                        receivedOrderView.commitBlock = ^{
                                            [weakself orderSended];
                                            [UIView animateWithDuration:.25 animations:^{
                                                weakself.receiveOrderView.alpha = 0;
                                            } completion:^(BOOL finished) {
                                                [weakself.receiveOrderView removeFromSuperview];
                                            }];
                                        };
                                        receivedOrderView.frame = CGRectMake(20, 60, SCREEN_WIDTH - 40, 220);
                                        [self.view addSubview:receivedOrderView];
                                        _isReceiveOrder = YES;
                                        _receiveOrderView = receivedOrderView;
                                    }
                                }];
                                
                            }
                        }
                    }
                    else if([[NSString stringWithFormat:@"%@", [[dataDic objectForKey:@"meta"] objectForKey:@"code"]] isEqualToString:@"401"]) {
                        [[PhoneNotification sharedInstance] autoHideWithText:@"重新登录"];
                    }
                }
            }];

        }
    }];
}

#pragma mark -WMScopeViewDelegate
- (void)commit:(NSString *)distance
{
    if (!_deviceID) {
//        [[PhoneNotification sharedInstance] autoHideWithText:@"请先扫描要共享的充电宝"];
        [[PhoneNotification sharedInstance] autoHideWithText:@"未扫描充电宝" image:@"prompting" backGroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        return;
    }
    _isFirstShare = YES;
    self.isShareSelected = YES;
    _distance = distance;
    [self openWithDeviceId:_deviceID distance:distance];
    [_scopeView hide];
    _scopeView = nil;
}

- (void)goToScan
{
    _scopeView.hidden = YES;
    kWeakSelf(self);
    ZFScanViewController * zfScanVC = [[ZFScanViewController alloc] init];
    zfScanVC.returnScanBarCodeValue = ^(NSString * barCodeString){
        //扫描完成后，在此进行后续操作
        weakself.scopeView.hidden = NO;
        NSLog(@"扫描结果======%@",barCodeString);
        NSArray * strings = [barCodeString componentsSeparatedByString:@"?"];
        NSArray * strings1 = [strings[1] componentsSeparatedByString:@"&"];
        NSArray * uuids = [strings1[0] componentsSeparatedByString:@"="];
        //        NSArray * macs = [strings1[1] componentsSeparatedByString:@"="];
        NSString * uuid = [uuids objectAtIndex:1];
        //        NSString * mac = [macs objectAtIndex:1];
        NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:uuid options:0];
        NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", decodedString);
        _deviceID = decodedString;
    };
    [self.navigationController pushViewController:zfScanVC animated:YES];
}

#pragma mark -setters or getters


- (MAMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        [AMapServices sharedServices].enableHTTPS = YES;
        _mapView.delegate = self;
        _mapView.showsCompass= NO;
        _mapView.showsScale= NO;
        [_mapView setZoomLevel:17 animated:YES];
        _mapView.showsScale = YES;
    }
    return _mapView;
}

- (UIButton *)refreshButton
{
    if (!_refreshButton) {
        _refreshButton = [[UIButton alloc] init];
        [_refreshButton addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
        [_refreshButton setBackgroundImage:[UIImage imageNamed:@"refreash"] forState:UIControlStateNormal];
    }
    return _refreshButton;
}

- (UIButton *)currentLocationButton
{
    if (!_currentLocationButton) {
        _currentLocationButton = [[UIButton alloc] init];
        [_currentLocationButton addTarget:self action:@selector(currentLocation) forControlEvents:UIControlEventTouchUpInside];
        [_currentLocationButton setBackgroundImage:[UIImage imageNamed:@"currentLocation"] forState:UIControlStateNormal];
    }
    return _currentLocationButton;
}

- (UITableView *)listTableView
{
    if (!_listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.height) style:UITableViewStylePlain];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        [_listTableView registerNib:[UINib nibWithNibName:@"WMReceiveOrderTableViewCell" bundle:nil] forCellReuseIdentifier:ReceiverCellID];
        [_listTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _listTableView;
}

- (UIButton *)swithMode
{
    if (!_swithMode) {
        _swithMode = [[UIButton alloc] init];
        [_swithMode setBackgroundImage:[UIImage imageNamed:@"listMode"] forState:UIControlStateNormal];
        [_swithMode addTarget:self action:@selector(swithModeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _swithMode;
}

- (NSMutableArray *)walletAnnotationArray
{
    if (!_walletAnnotationArray) {
        _walletAnnotationArray = [NSMutableArray array];
    }
    return _walletAnnotationArray;
}

- (NSMutableArray *)annotationsArray
{
    if (!_annotationsArray) {
        _annotationsArray = [NSMutableArray array];
    }
    return _annotationsArray;
}

@end
