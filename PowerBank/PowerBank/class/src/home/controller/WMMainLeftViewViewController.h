//
//  WMMainLeftViewViewController.h
//  PowerBank
//
//  Created by wangmiao on 2017/7/24.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "BaseViewController.h"
#import "HomeRemindBox.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>
#import "ZFScanViewController.h"
#import "WMSendDemandView.h"
#import "WMSendOrderView.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "WMAddressSelectViewController.h"
#import "WMPayView.h"

typedef void(^LOCATION)();

@interface WMMainLeftViewViewController : BaseViewController

- (void)currentLocation;
@property (strong, nonatomic) HomeRemindBox * remindBox;
@property (strong, nonatomic) AMapLocationManager * locationManager;
@property (strong, nonatomic) MAMapView * mapView;
@property (strong, nonatomic) WMSendDemandView * sendDemandView;
@property (strong, nonatomic) UIButton * currentLocationButton;
@property (strong, nonatomic) UIButton * refreshButton;
@property (strong, nonatomic) WMSendOrderView * sendOrderView;
@property (strong, nonatomic) CLLocation * nowLocation;
@property (strong, nonatomic) NSMutableArray * dataArray;
@property (assign, nonatomic) BOOL isShow;
@property (strong, nonatomic) WMPayView * payView;
@property (copy, nonatomic) LOCATION block;
@property (copy, nonatomic) NSString * nowAddress;

@end
