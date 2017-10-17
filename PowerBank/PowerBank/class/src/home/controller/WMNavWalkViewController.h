//
//  WMNavWalkViewController.h
//  PowerBank
//
//  Created by baiju on 2017/8/3.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "BaseViewController.h"
#import <AMapNaviKit/AMapNaviKit.h>

@interface WMNavWalkViewController : BaseViewController

@property (nonatomic, assign) CLLocationCoordinate2D currentUL;//导航起始位置，即用户当前的位置

@property (nonatomic, assign) CLLocationCoordinate2D coor;//导航终点位置

@end
