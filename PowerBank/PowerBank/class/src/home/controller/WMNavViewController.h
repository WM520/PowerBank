//
//  WMNavViewController.h
//  PowerBank
//
//  Created by foreverlove on 2017/8/2.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "BaseViewController.h"
#import <AMapNaviKit/AMapNaviKit.h>

@interface WMNavViewController : BaseViewController

@property (nonatomic, strong) AMapNaviDriveManager *driveManager;

@property (nonatomic, strong) AMapNaviDriveView *driveView;

@property (nonatomic, assign) CLLocationCoordinate2D currentUL;//导航起始位置，即用户当前的位置

@property (nonatomic, assign) CLLocationCoordinate2D coor;//导航终点位置


@end
