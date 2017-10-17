//
//  WMSendOrderView.h
//  PowerBank
//
//  Created by foreverlove on 2017/7/21.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WMSendDemandModel;
@class WMOrderModel;

@protocol WMSendOrderViewDelegate <NSObject>

- (void)cancle;
- (void)call;
- (void)addPrice:(NSString *)count;

@end

@interface WMSendOrderView : UIView

@property (nonatomic, weak) id<WMSendOrderViewDelegate> delegate;
@property (nonatomic, assign) BOOL isReceived;
@property (nonatomic, strong) WMSendDemandModel * model;
@property (nonatomic, strong) WMOrderModel * orderModel;
- (void)show;
- (void)hide;
- (void)immediatelyHide;


@end
