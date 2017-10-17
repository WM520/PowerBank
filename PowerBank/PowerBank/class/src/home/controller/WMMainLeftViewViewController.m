//
//  WMMainLeftViewViewController.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/24.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "WMMainLeftViewViewController.h"
#import "WMCustomAnnotationView.h"
#import "LoginViewController.h"
#import "WMCustomAlert.h"
#import "WMMAPointAnnotation.h"
#import "WMSendDemandModel.h"
#import "WMSendDemandModel.h"
#import "WMRequireModel.h"
#import "WMShareModel.h"
#import "WMSharePointAnnotation.h"
#import "WMShareAnnotationView.h"
#import "WMCabinetModel.h"
#import "WMMACabinetPointAnnotation.h"
#import "WMOrderModel.h"


@interface WMMainLeftViewViewController ()
<MAMapViewDelegate,
WMSendDemandViewDelegate,
WMSendOrderViewDelegate,
AMapLocationManagerDelegate,
AMapSearchDelegate,
WMAddressSelectViewControllerDelegate>

@property (nonatomic, assign) NSInteger sendDemandY;
@property (nonatomic,strong) NSArray *pathPolylines;
@property (nonatomic, assign) CLLocationCoordinate2D nowCoordinate;
@property (strong, nonatomic) AMapSearchAPI * search;
@property (strong, nonatomic) WMSendDemandModel * model;
@property (strong, nonatomic) NSMutableArray * requireArray;
@property (strong, nonatomic) NSMutableArray * shareArray;
@property (strong, nonatomic) NSMutableArray * cabinetArray;
@property (strong, nonatomic) WMMAPointAnnotation * currentAnnotation;
@property (strong, nonatomic) NSMutableArray * shareAnnotationArray;
@property (strong, nonatomic) NSMutableArray * cabinetAnnotationArray;
@property (strong, nonatomic) NSMutableArray * messageArray;

@end

@implementation WMMainLeftViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initData];
    
    [self initUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"goHomeVC" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exit) name:@"exit" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"loginsuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderHasSended) name:@"sended" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderHasReceive) name:@"hasReceive" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderHasCancle) name:@"hasCancle" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isShow) {
        _sendDemandView.hidden = NO;
    }
    if (_sendOrderView) {
        _sendOrderView.hidden = NO;
    }
    if ([AppSettings checkIsLogin]) {
        [self initRequireStatus];
    } else {
        // 未登录隐藏提示框
        _remindBox.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_sendDemandView) {
        _sendDemandView.hidden = YES;
        _isShow = YES;
    }
    
    if (_sendOrderView) {
        _sendOrderView.hidden = YES;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - noti
- (void)exit
{
    if (_sendDemandView) {
        [_sendDemandView hide];
        _sendDemandView = nil;
    }
    if (_sendOrderView) {
        [_sendOrderView hide];
        _sendOrderView = nil;
    }
}

- (void)loginSuccess
{
    [self initRequireStatus];
}

- (void)orderHasSended
{
    // 回到主线程添加UI
    dispatch_async(dispatch_get_main_queue(), ^{
        WMCustomAlert * alert = [[WMCustomAlert alloc] initWithTitle:@"您的订单已被送达，请支付" cancleButtonTitle:@"未送达" commitButtonTitle:@"支付" isCancleImage:0];
        alert.cancleBlock = ^() {
            dispatch_async(dispatch_get_main_queue(), ^{
                // 不管是否支付成功移除订单弹窗
                [_sendOrderView removeFromSuperview];
                _sendOrderView = nil;
                if (!_payView) {
                    WMPayView * payView = [[WMPayView alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT - 270, SCREEN_WIDTH -40, 230)];
                    payView.orderModel = _sendOrderView.orderModel;
                    [payView show];
                    _payView = payView;
                }
            });
        };
        // 不管是否支付成功移除订单弹窗
        alert.commitBlock = ^{
            [_sendOrderView removeFromSuperview];
            /** 订单未送达 */
            [WMRequestHelper shareOrderUnsendWithCompletionHandle:^(BOOL success, id dataDic) {
                if (success) {
                    NSLog(@"未送达");
                }
            }];
            
            _sendOrderView = nil;
        };
        [alert show];
    });
    
}

- (void)orderHasReceive
{
     dispatch_async(dispatch_get_main_queue(), ^{
         [self initRequireStatus];
     });
}

- (void)orderHasCancle
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self cancleAlert];
    });
}

- (void)cancleAlert
{
    WMCustomAlert * alert = [[WMCustomAlert alloc] initWithTitle:[NSString stringWithFormat:@"您的订单已被取消，是否重新寻找充电宝？"] cancleButtonTitle:@"否" commitButtonTitle:@"是" isCancleImage:0];
    kWeakSelf(self);

    alert.cancleBlock = ^{
        [WMRequestHelper deleteUserRequireOrder:weakself.sendOrderView.orderModel.orderID withCompletionHandle:^(BOOL success, id dataDic) {
            NSLog(@"%@", dataDic);
            if (success) {
                [[PhoneNotification sharedInstance] autoHideWithText:@"重新寻找充电宝"];
            }
        }];
        
        [weakself.sendOrderView immediatelyHide];
        weakself.sendOrderView = nil;
    };
    
    [alert show];
}

#pragma mark -WMSendDemandViewDelegate
// 发布用电需求
- (void)sendDemand:(WMSendDemandModel *)model
{
    WMSendOrderView * sendOrderView = [[WMSendOrderView alloc] initWithFrame:CGRectMake(20, 84, SCREEN_WIDTH -40, 150)];
    sendOrderView.delegate = self;
    [sendOrderView show];
    [_sendDemandView hide];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noti2" object:nil];
    _sendOrderView = sendOrderView;
    [WMRequestHelper addUserRequire:[[AppSettings sharedInstance] stringForKey:@"token"] longitude:model.longitude latitude:model.latitude addr:model.addr address:model.address money:model.money date:model.date withCompletionHandle:^(BOOL success, id dataDic) {
        if (success) {
            if ([dataDic objectForKey:@"data"] && [[dataDic objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dic = [dataDic objectForKey:@"data"];
                WMSendDemandModel * model = [[WMSendDemandModel alloc] init];
                model.addr = [dic objectForKey:@"addr"];
                model.address = [dic objectForKey:@"address"];
                model.date = [dic objectForKey:@"date"];
                model.money = [dic objectForKey:@"money"];
                model.latitude = [dic objectForKey:@"latitude"];
                model.longitude = [dic objectForKey:@"longitude"];
                model.orderID = [dic objectForKey:@"id"];
                _model = model;
                _sendOrderView.model = _model;
            }
        }
    }];
}
// 选择地址
- (void)selectCity
{
    NSLog(@"selectCity");
    if (_nowLocation == nil || _search == nil) {
        return;
    }
    AMapPOIAroundSearchRequest * request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:_nowLocation.coordinate.latitude longitude:_nowLocation.coordinate.longitude];
    request.types = @"风景名胜|商务住宅|政府机构及社会团体|交通设施服务|公司企业|道路附属设施|地名地址信息";
    request.sortrule = 0;
    request.requireExtension = YES;
    request.requireSubPOIs      = YES;
    [_search AMapPOIAroundSearch:request];
}

#pragma mark -WMSendOrderViewDelegate
// 取消用电需求
- (void)cancle
{
    
    WMUserModel * userModel = [[AppSettings sharedInstance] loginObject];
    if ([userModel.cancelRequireCountLimit integerValue] > 5) {
        [[PhoneNotification sharedInstance] autoHideWithText:@"您取消订单的次数已到上限"];
        return;
    }
    
//    if([userModel.userCreditNum integerValue] ==  0) {
//        [[PhoneNotification sharedInstance] autoHideWithText:@"您的信用值已经为0，不能再取消订单"];
//        return;
//    }
    
    kWeakSelf(self);
    WMCustomAlert * alert = [[WMCustomAlert alloc] initWithTitle:[NSString stringWithFormat:@"您的订单已被接单，您还有%ld次免费取消次数，确定取消?", 5 -[userModel.cancelRequireCountLimit integerValue]] cancleButtonTitle:@"仍要取消" commitButtonTitle:@"不取消" isCancleImage:0];
    alert.commitBlock = ^() {
        // 是否接单 接单后的取消方式
        if (weakself.sendOrderView.isReceived) {
            [WMRequestHelper deleteUserRequireOrder:weakself.sendOrderView.orderModel.orderID withCompletionHandle:^(BOOL success, id dataDic) {
                NSLog(@"%@", dataDic);
                if (success) {
                    [[PhoneNotification sharedInstance] autoHideWithText:@"成功取消"];
                }
            }];
        } else { // 接单前的取消方式
            [WMRequestHelper deleteOrder:weakself.model.orderID withCompletionHandle:^(BOOL success, id dataDic) {
                NSLog(@"%@", dataDic);
                if (success) {
                    [[PhoneNotification sharedInstance] autoHideWithText:@"成功取消"];
                }
            }];
        }
        [weakself.sendOrderView immediatelyHide];
        weakself.sendOrderView = nil;
    };
    [alert show];
}

- (void)call
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", _sendOrderView.orderModel.userShareModel.userMobilephone]]];
}

- (void)addPrice:(NSString *)count
{
    float  totalCount = [count floatValue] + [_model.money floatValue];
    NSString * money = [NSString stringWithFormat:@"%.2f", totalCount];
    [WMRequestHelper addPrice:_model.orderID longitude:_model.longitude latitude:_model.latitude addr:_model.addr address:_model.address money:money date:_model.date withCompletionHandle:^(BOOL success, id dataDic) {
        if (success) {
            NSLog(@"%@", dataDic);
        }
    }];
}

#pragma mark -MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction
{

}

- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    _nowCoordinate = coordinate;
    if (_sendDemandView) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"noti2" object:nil];
        [_sendDemandView hide];
    }
    
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.imageView.image = [UIImage imageNamed:@"annotationligui"];
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    
    if ([annotation isKindOfClass:[WMMAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.image = [UIImage imageNamed:@"mineToPower"];
        annotationView.backgroundColor = [UIColor redColor];
        annotationView.canShowCallout= NO;       //设置气泡可以弹出，默认为NO
        annotationView.draggable = NO;        //设置标注可以拖动，默认为NO
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    
    if ([annotation isKindOfClass:[WMSharePointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"SharepointReuseIndentifier";
        WMSharePointAnnotation * pointAnnotation = annotation;
        WMShareAnnotationView * annotationView = (WMShareAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[WMShareAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.image = [UIImage imageNamed:@"shareAnnotation"];
        annotationView.model = pointAnnotation.model;
        annotationView.canShowCallout= NO;       //设置气泡可以弹出，默认为NO
        annotationView.draggable = NO;        //设置标注可以拖动，默认为NO
        return annotationView;
    }
    
    if ([annotation isKindOfClass:[WMMACabinetPointAnnotation class]]) {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        WMCustomAnnotationView *annotationView = (WMCustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[WMCustomAnnotationView alloc] initWithAnnotation:annotation
                                                                  reuseIdentifier:reuseIndetifier];
        }
        WMMACabinetPointAnnotation * cabinetAnnotation = annotation;
        annotationView.model = cabinetAnnotation.model;
        annotationView.nowLocation = _nowLocation;
        annotationView.image = [UIImage imageNamed:@"annotationligui"];
        annotationView.canShowCallout               = NO;
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    
    if ([view isKindOfClass:[MAPinAnnotationView class]]) {
        BOOL isLogin = [AppSettings checkIsLogin];
        if (!isLogin) {
            LoginViewController * loginVC = [[LoginViewController alloc] init];
            [self presentViewController:loginVC animated:YES completion:^{
                
            }];
            return;
        }
        _remindBox.hidden = YES;
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        regeo.location                    = [AMapGeoPoint locationWithLatitude:_nowLocation.coordinate.latitude longitude:_nowLocation.coordinate.longitude];
        regeo.requireExtension            = YES;
        [_search AMapReGoecodeSearch:regeo];
        
        if (_sendOrderView == nil) {
            WMSendDemandView * sendDemandView = [[WMSendDemandView alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT - 220, SCREEN_WIDTH - 40, 190)];
            sendDemandView.latitude = [NSString stringWithFormat:@"%f", _nowLocation.coordinate.latitude];
            sendDemandView.longitude = [NSString stringWithFormat:@"%f", _nowLocation.coordinate.longitude];
            sendDemandView.delegate = self;
            _sendDemandY = sendDemandView.centerY;
            [sendDemandView show];
            _sendDemandView = sendDemandView;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"noti1" object:nil];
        } else {
            [[PhoneNotification sharedInstance] autoHideWithText:@"你有正在进行的充电需求"];
        }
//        [view setSelected:NO animated:YES];
    }
    
}
/** 移动地图的回调 */
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction
{
    
}
/** 更新位置的回调 */
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    
}

#pragma mark -AMapLocationManagerDelegate
/** 定位失败 */
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    //定位错误
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
}
/** 成功后的回调 */
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    _nowLocation = location;
    // 获取当前位置
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location                    = [AMapGeoPoint locationWithLatitude:_nowLocation.coordinate.latitude longitude:_nowLocation.coordinate.longitude];
    regeo.requireExtension            = YES;
    [_search AMapReGoecodeSearch:regeo];
    
    [self.mapView removeAnnotation:_currentAnnotation];
    _currentAnnotation = nil;
    //定位结果
    CLLocationCoordinate2D currentLocation;
    currentLocation.latitude = location.coordinate.latitude;
    currentLocation.longitude = location.coordinate.longitude;
    [_mapView setCenterCoordinate:currentLocation animated:YES];
    WMMAPointAnnotation *pointAnnotation = [[WMMAPointAnnotation alloc] init];
    pointAnnotation.isCurrent = YES;
    pointAnnotation.title = @"我要充电";
    pointAnnotation.coordinate = currentLocation;
    _currentAnnotation = pointAnnotation;
    [self.mapView addAnnotation:pointAnnotation];
    // 获得柜机
    [WMRequestHelper getCabinetList:@"10000" longitude:[NSString stringWithFormat:@"%lf", location.coordinate.longitude] latitude:[NSString stringWithFormat:@"%lf", location.coordinate.latitude] filter:nil sort:nil limit:@"100" page:@"1" withCompletionHandle:^(BOOL success, id dataDic) {
        if (success) {
            NSLog(@"%@", dataDic);
            if ([[dataDic objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                NSArray * dataArray = [dataDic objectForKey:@"data"];
                [self.mapView removeAnnotations:self.cabinetAnnotationArray];
                [self.cabinetAnnotationArray removeAllObjects];
                [self.cabinetArray removeAllObjects];
                for (int i = 0; i < dataArray.count; i++) {
                    WMCabinetModel * model = [WMCabinetModel modelWithDictionary:dataArray[i]];
                    [self.cabinetArray addObject:model];
                }
                
                for (int i = 0; i < self.cabinetArray.count; i++) {
                    WMMACabinetPointAnnotation * pointAnnotation = [[WMMACabinetPointAnnotation alloc] init];
                    CLLocationCoordinate2D coor ;
                    WMCabinetModel * model = self.cabinetArray[i];
                    coor.latitude = [model.latitude floatValue];
                    coor.longitude = [model.longitude floatValue];
                    pointAnnotation.coordinate = coor;
                    pointAnnotation.model = model;
                    
                    [self.cabinetAnnotationArray addObject:pointAnnotation];
                    
                }
                [self.mapView addAnnotations:self.cabinetAnnotationArray];
            }
        }
    }];
    // 获得共享的充电宝
    [WMRequestHelper getSharePIOList:@"3000" longitude:[NSString stringWithFormat:@"%lf", location.coordinate.longitude] latitude:[NSString stringWithFormat:@"%lf", location.coordinate.latitude] filter:nil sort:nil limit:@"100" page:@"1" withCompletionHandle:^(BOOL success, id dataDic) {
        if (success) {
            NSLog(@"%@", dataDic);
            if ([[dataDic objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                NSArray * dataArray = [dataDic objectForKey:@"data"];
                [self.mapView removeAnnotations:self.shareAnnotationArray];
                [self.shareAnnotationArray removeAllObjects];
                [self.shareArray removeAllObjects];
                for (int i = 0; i < dataArray.count; i++) {
                    WMShareModel * model = [WMShareModel modelWithDictionary:dataArray[i]];
                    [self.shareArray addObject:model];
                }
                
                for (int i = 0; i < self.shareArray.count; i++) {
                    WMSharePointAnnotation * pointAnnotation = [[WMSharePointAnnotation alloc] init];
                    CLLocationCoordinate2D coor;
                    WMShareModel * model = self.shareArray[i];
                    coor.latitude = [model.latitude floatValue];
                    coor.longitude = [model.longitude floatValue];
                    pointAnnotation.coordinate = coor;
                    pointAnnotation.model = model;
                    [self.shareAnnotationArray addObject:pointAnnotation];
                }
                [self.mapView addAnnotations:self.shareAnnotationArray];
            }
        }
    }];
    // 停止定位
    [self.locationManager stopUpdatingLocation];
}


#pragma mark -AMapSearchDelegate
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0) {
        return;
    }
    _dataArray = [NSMutableArray arrayWithArray:response.pois];
    WMAddressSelectViewController * addressVc = [[WMAddressSelectViewController alloc] init];
    addressVc.addressArray = _dataArray;
    addressVc.nowLocation = _nowLocation;
    addressVc.delegate = self;
    [self presentViewController:addressVc animated:YES completion:^{
        _isShow = true;
        _sendDemandView.hidden = YES;
    }];
    NSLog(@"%@", _dataArray);
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        //解析response获取地址描述，具体解析见 Demo
        if (response.regeocode.formattedAddress.length > 0) {
            if (_sendDemandView) {
                _sendDemandView.addressLabel.text = response.regeocode.formattedAddress;
            } else {
                _nowAddress = response.regeocode.formattedAddress;
            }
        }
    }
}

#pragma mark -WMAddressSelectViewControllerDelegate
// 用户选择地址
- (void)callback:(NSString *)addreeName
{
    _sendDemandView.addressLabel.text = addreeName;
}

#pragma mark -methods
// 定位到当前位置
- (void)currentLocation
{
    NSLog(@"currentLocation");
    [self.locationManager startUpdatingLocation];
}
// 刷新当前位置的充电宝
- (void)refresh
{
    CLLocation *location = _nowLocation;
    [_mapView setCenterCoordinate:_nowLocation.coordinate animated:YES];
    // 获得柜机
    [WMRequestHelper getCabinetList:@"3000" longitude:[NSString stringWithFormat:@"%lf", location.coordinate.longitude] latitude:[NSString stringWithFormat:@"%lf", location.coordinate.latitude] filter:nil sort:nil limit:@"100" page:@"1" withCompletionHandle:^(BOOL success, id dataDic) {
        if (success) {
            NSLog(@"%@", dataDic);
            if ([[dataDic objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                NSArray * dataArray = [dataDic objectForKey:@"data"];
                [self.mapView removeAnnotations:self.cabinetAnnotationArray];
                [self.cabinetAnnotationArray removeAllObjects];
                [self.cabinetArray removeAllObjects];
                for (int i = 0; i < dataArray.count; i++) {
                    WMCabinetModel * model = [WMCabinetModel modelWithDictionary:dataArray[i]];
                    [self.cabinetArray addObject:model];
                }
                
                for (int i = 0; i < self.cabinetArray.count; i++) {
                    WMMACabinetPointAnnotation * pointAnnotation = [[WMMACabinetPointAnnotation alloc] init];
                    CLLocationCoordinate2D coor ;
                    WMCabinetModel * model = self.cabinetArray[i];
                    coor.latitude = [model.latitude floatValue];
                    coor.longitude = [model.longitude floatValue];
                    pointAnnotation.coordinate = coor;
                    pointAnnotation.model = model;
                    [self.cabinetAnnotationArray addObject:pointAnnotation];
                }
                [self.mapView addAnnotations:self.cabinetAnnotationArray];
            }
        }
    }];
    // 获得共享的充电宝
    [WMRequestHelper getSharePIOList:@"3000" longitude:[NSString stringWithFormat:@"%lf", location.coordinate.longitude] latitude:[NSString stringWithFormat:@"%lf", location.coordinate.latitude] filter:nil sort:nil limit:@"100" page:@"1" withCompletionHandle:^(BOOL success, id dataDic) {
        if (success) {
            NSLog(@"%@", dataDic);
            if ([[dataDic objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                NSArray * dataArray = [dataDic objectForKey:@"data"];
                [self.shareArray removeAllObjects];
                [self.mapView removeAnnotations:self.shareAnnotationArray];
                [self.shareAnnotationArray removeAllObjects];
                for (int i = 0; i < dataArray.count; i++) {
                    WMShareModel * model = [WMShareModel modelWithDictionary:dataArray[i]];
                    [self.shareArray addObject:model];
                }
                
                for (int i = 0; i < self.shareArray.count; i++) {
                    WMSharePointAnnotation * pointAnnotation = [[WMSharePointAnnotation alloc] init];
                    CLLocationCoordinate2D coor ;
                    WMShareModel * model = self.shareArray[i];
                    coor.latitude = [model.latitude floatValue];
                    coor.longitude = [model.longitude floatValue];
                    pointAnnotation.coordinate = coor;
                    pointAnnotation.model = model;
                    [self.shareAnnotationArray addObject:pointAnnotation];
                }
                [self.mapView addAnnotations:self.shareAnnotationArray];
            }
        }
    }];
    [self initRequireStatus];
    NSLog(@"refresh");
}

#pragma mark -监听键盘弹起事件
- (void)keyboardWillShow:(NSNotification *)notif
{
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat y = rect.origin.y;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    _sendDemandView.centerY = y - 120;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notif {

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    _sendDemandView.centerY = _sendDemandY;
    [UIView commitAnimations];
}

#pragma mark -init
- (void)initData
{
    _isShow = false;
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    [self.locationManager setAllowsBackgroundLocationUpdates:NO];
    [self.locationManager startUpdatingLocation];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
//    CLLocationCoordinate2D coor ;
//    coor.latitude = 32.159423;
//    coor.longitude = 118.697407;
//    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
//    pointAnnotation.coordinate = coor;
//    [self.mapView addAnnotation:pointAnnotation];
    
//    "id": 10,
//    "longitude": "118.697898",
//    "latitude": "32.157361",
//    "address": "星火路地铁站东(公交站)",
//    "deviceNum": 10
    
#warning 测试柜机数据
//    NSDictionary * dic = @{
//                           @"id": @"10",
//                           @"longitude": @"118.697898",
//                           @"latitude": @"32.157361",
//                           @"address": @"星火路地铁站东(公交站)",
//                           @"deviceNum": @"10"};
//    
//    WMCabinetModel * model = [WMCabinetModel modelWithDictionary:dic];
//    WMMACabinetPointAnnotation * pointAnnotation = [[WMMACabinetPointAnnotation alloc] init];
//    CLLocationCoordinate2D coor ;
//    coor.latitude = [model.latitude floatValue];
//    coor.longitude = [model.longitude floatValue];
//    pointAnnotation.coordinate = coor;
//    pointAnnotation.model = model;
//    [self.mapView addAnnotation:pointAnnotation];
}


- (void)initRequireStatus
{
    [self.messageArray removeAllObjects];
    [WMRequestHelper acquiringInformation:[[AppSettings sharedInstance] stringForKey:@"token"] withCompletionHandle:^(BOOL success, id dataDic) {
        if (success) {
            if ([[dataDic objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dic = [dataDic objectForKey:@"data"];
                WMUserModel * model = [WMUserModel modelWithDictionary:dic];
                [[AppSettings sharedInstance] loginsaveCache:model];
                if ([model.orderNoSendCount integerValue] > 0) {
                    MTANewAdviseInfo * info = [[MTANewAdviseInfo alloc] init];
                    info.desc = @"您有未送达的订单！";
                    [self.messageArray addObject:info];
                }
                
                if (self.messageArray.count == 0) {
                    _remindBox.hidden = YES;
                } else {
                    _remindBox.messageArray = self.messageArray;
                }
                
            }
        }
    }];
    
    if ([AppSettings checkIsLogin]) {
        [WMRequestHelper acquiringRequire:[[AppSettings sharedInstance] stringForKey:@"token"] withCompletionHandle:^(BOOL success, id dataDic) {
            if (success) {
                NSLog(@"%@",dataDic);
                if ([[dataDic objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary * dic = [dataDic objectForKey:@"data"];
                    WMSendDemandModel * model = [[WMSendDemandModel alloc] init];
                    model.addr = [dic objectForKey:@"addr"];
                    model.address = [dic objectForKey:@"address"];
                    model.date = [dic objectForKey:@"getTime"];
                    model.money = [dic objectForKey:@"money"];
                    model.latitude = [dic objectForKey:@"latitude"];
                    model.longitude = [dic objectForKey:@"longitude"];
                    model.orderID = [dic objectForKey:@"id"];
                    model.status = [dic objectForKey:@"status"];
                    _model = model;
                    // 判断是否接单
                    CGFloat height = [[NSString stringWithFormat:@"%@", model.status] isEqualToString:@"1"] == YES ? 150 : 200;
                    
                    if ([[NSString stringWithFormat:@"%@", model.status] isEqualToString:@"2"]) {
                        [WMRequestHelper getUserRequireOrderWithCompletionHandle:^(BOOL success, id dataDic) {
                            if (success) {
                                WMOrderModel * orderModel = [WMOrderModel modelWithDictionary:[dataDic objectForKey:@"data"]];
            
                                if ([orderModel.sendStatus integerValue] == 1 && [orderModel.payStatus integerValue] == 0) {
                                    MTANewAdviseInfo * info = [[MTANewAdviseInfo alloc] init];
                                    info.desc = @"您有未支付的订单！";
                                    [self.messageArray addObject:info];
                                }
                                if (self.messageArray.count == 0) {
                                    _remindBox.hidden = YES;
                                } else {
                                    _remindBox.hidden = NO;
                                    _remindBox.messageArray = self.messageArray;
                                }

                                if (_remindBox.hidden == NO) {
                                    if (!_sendOrderView) {
                                        WMSendOrderView * sendOrderView = [[WMSendOrderView alloc] initWithFrame:CGRectMake(20, 130, SCREEN_WIDTH -40, height)];
                                        sendOrderView.model = model;
                                        sendOrderView.orderModel = orderModel;
                                        sendOrderView.delegate = self;
                                        [sendOrderView show];
                                        _sendOrderView = sendOrderView;
                                    } else {
                                        _sendOrderView.frame = CGRectMake(20, 130, SCREEN_WIDTH -40, height);
                                        _sendOrderView.model = model;
                                        _sendOrderView.orderModel = orderModel;
                                        
                                    }

                                } else {
                                    if (!_sendOrderView) {
                                        WMSendOrderView * sendOrderView = [[WMSendOrderView alloc] initWithFrame:CGRectMake(20, 84, SCREEN_WIDTH -40, height)];
                                        sendOrderView.model = model;
                                        sendOrderView.orderModel = orderModel;
                                        sendOrderView.delegate = self;
                                        [sendOrderView show];
                                        _sendOrderView = sendOrderView;
                                    } else {
                                        _sendOrderView.frame = CGRectMake(20, 84, SCREEN_WIDTH -40, height);
                                        _sendOrderView.model = model;
                                        _sendOrderView.orderModel = orderModel;
                                        
                                    }
                                }
                                
                            }
                        }];
                    } else {
                        if (!_sendOrderView) {
                            WMSendOrderView * sendOrderView = [[WMSendOrderView alloc] initWithFrame:CGRectMake(20, 84, SCREEN_WIDTH -40, height)];
                            sendOrderView.model = model;
                            sendOrderView.delegate = self;
                            [sendOrderView show];
                            _sendOrderView = sendOrderView;
                        } else {
                            _sendOrderView.model = model;
                            _sendOrderView.orderModel = nil;
                            _sendOrderView.frame = CGRectMake(20, 84, SCREEN_WIDTH - 40, 150);
                        }
                    }
                }
            }
        }];
    }
//    [WMRequestHelper getUserRequireOrderWithCompletionHandle:^(BOOL success, id dataDic) {
//        if (success) {
//            if ([[NSString stringWithFormat:@"%@", [[dataDic objectForKey:@"meta"] objectForKey:@"code"]] isEqualToString:@"200"]) {
//                WMOrderModel * orderModel = [WMOrderModel modelWithDictionary:[dataDic objectForKey:@"data"]];
//                if (![orderModel.orderID isEqualToString:@""]) {
//                    if (orderModel.orderID) {
//                        
//                    }
//                }
//            }
//        }
//    }];
//
}

- (void)initUI
{
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.remindBox];
    [self.view addSubview:self.currentLocationButton];
    [self.view addSubview:self.refreshButton];
    
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
#pragma mark - setters or getters
- (HomeRemindBox *)remindBox
{
    if (!_remindBox) {
        _remindBox  = [[HomeRemindBox alloc] initWithFrame:CGRectMake(10, 20, SCREEN_WIDTH - 20 , 35)];
    }
    return _remindBox;
}



- (MAMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        [AMapServices sharedServices].enableHTTPS = YES;
        _mapView.delegate = self;
        _mapView.showsCompass= NO;
        _mapView.showsScale= NO;
        [_mapView setZoomLevel:18 animated:YES];
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

- (NSMutableArray *)requireArray
{
    if (!_requireArray) {
        _requireArray = [NSMutableArray array];
    }
    return _requireArray;
}

- (NSMutableArray *)shareArray
{
    if (!_shareArray) {
        _shareArray = [NSMutableArray array];
    }
    return _shareArray;
}

- (NSMutableArray *)cabinetArray
{
    if (!_cabinetArray) {
        _cabinetArray = [NSMutableArray array];
    }
    return _cabinetArray;
}

- (NSMutableArray *)shareAnnotationArray
{
    if (!_shareAnnotationArray) {
        _shareAnnotationArray = [NSMutableArray array];
    }
    return _shareAnnotationArray;
}

- (NSMutableArray *)cabinetAnnotationArray
{
    if (!_cabinetAnnotationArray) {
        _cabinetAnnotationArray = [NSMutableArray array];
    }
    return _cabinetAnnotationArray;
}

- (NSMutableArray *)messageArray
{
    if (!_messageArray) {
        _messageArray = [NSMutableArray array];
    }
    return _messageArray;
}
    
@end
