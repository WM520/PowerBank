//
//  WMMainRightViewController.h
//  PowerBank
//
//  Created by wangmiao on 2017/7/24.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "BaseViewController.h"
#import "WMScopeView.h"
#import "WMSendOrderView.h"
#import <MAMapKit/MAMapKit.h>
#import "ZFScanViewController.h"
#import "WMListHeadView.h"
#import "WMReceiveOrderTableViewCell.h"
#import "WMHaveNoOpenShareView.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import "LoginViewController.h"
#import "WMCustomRightAnnotionView.h"

@interface WMMainRightViewController : BaseViewController

@property (nonatomic, strong) WMScopeView * scopeView;
@property (assign, nonatomic) BOOL isScopeView;
@property (assign, nonatomic) BOOL isVisabel;
@property (strong, nonatomic) WMSendOrderView * orderView;
@property (nonatomic, strong) UIButton * openShare; // 开启共享
@property (strong, nonatomic) MAMapView * mapView; // 地图
@property (assign, nonatomic) BOOL isShareSelected; // 是否开启共享
@property (strong, nonatomic) UIButton * currentLocationButton; // 当前位置按钮
@property (strong, nonatomic) UIButton * refreshButton; // 需求刷新按钮
@property (strong, nonatomic) UIButton * receiveOrderScope; // 选择接单范围
@property (strong, nonatomic) UITableView * listTableView; // 接单列表
@property (strong, nonatomic) UIButton * swithMode; // 切换模式按钮
@property (strong, nonatomic) WMHaveNoOpenShareView * haveNoOpenShareView; // 列表模式没有开启共享的view
@property (strong, nonatomic) AMapLocationManager * locationManager; // 定位manager
@property (strong, nonatomic) CLLocation * nowLocation; // 当前location
@property (assign, nonatomic) BOOL isFirstShare;
@property (assign, nonatomic) BOOL isScan;
/** 是否接单 */
@property (assign, nonatomic) BOOL isReceiveOrder;

@property (nonatomic, strong) NSMutableArray * walletAnnotationArray;

- (void)currentLocation;

@end
