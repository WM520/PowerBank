//
//  WMCustomCalloutView.h
//  PowerBank
//
//  Created by foreverlove on 2017/8/2.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface WMCustomCalloutView : UIView

@property (nonatomic, strong) UIImage *distanceImage; // 地址
@property (nonatomic, copy) NSString *title; // 地址
@property (nonatomic, copy) NSString *subtitle; // 距离
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIButton *navigationButton; // 导航按钮
@property (nonatomic, strong) NSString * powerCount;
@property (nonatomic, strong) UIImage *powerCountImage;

@property (nonatomic, assign) CLLocationCoordinate2D startCLLocation;
@property (nonatomic, assign) CLLocationCoordinate2D endCLLocation;

@end
