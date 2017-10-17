//
//  WMPayView.h
//  PowerBank
//
//  Created by baiju on 2017/8/7.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WMOrderModel;

@protocol WMPayViewDelegate <NSObject>

- (void)hideAction;

@end

@interface WMPayView : UIView


@property (nonatomic, weak)id<WMPayViewDelegate> delegate;
@property (nonatomic, strong) WMOrderModel * orderModel;
- (void)show;
- (void)hide;

@end
