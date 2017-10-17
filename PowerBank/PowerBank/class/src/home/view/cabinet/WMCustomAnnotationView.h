//
//  WMCustomAnnotationView.h
//  PowerBank
//
//  Created by foreverlove on 2017/8/2.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "WMCustomCalloutView.h"
@class WMCabinetModel;

/** 立柜机 */
@interface WMCustomAnnotationView : MAAnnotationView

@property (nonatomic, readonly) WMCustomCalloutView *calloutView;
@property (nonatomic, strong) WMCabinetModel * model;
@property (strong, nonatomic) CLLocation * nowLocation;

@end
