//
//  WMCustomRightAnnotionView.h
//  PowerBank
//
//  Created by baiju on 2017/8/18.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
@class WMCustomWalletCalloutView;
@class WMRequireModel;
/** 发布需求列表 */
@protocol WMCustomRightAnnotionViewDelegate <NSObject>

- (void)receiveOrderAction:(WMRequireModel *) model;

@end

@interface WMCustomRightAnnotionView : MAAnnotationView

@property (nonatomic, readonly) WMCustomWalletCalloutView *walletCalloutView;
@property (nonatomic, strong) WMRequireModel * model;
@property (nonatomic, assign) CLLocationCoordinate2D startCLLocation;
@property (nonatomic, assign) CLLocationCoordinate2D endCLLocation;
@property (strong, nonatomic) CLLocation * nowLocation;
@property (weak, nonatomic) id<WMCustomRightAnnotionViewDelegate> delegate;

@end
