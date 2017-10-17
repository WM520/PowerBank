//
//  WMCustomWalletCalloutView.h
//  PowerBank
//
//  Created by baiju on 2017/8/18.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReceiveOrder)();

@protocol WMCustomWalletCalloutViewDelegate <NSObject>

- (void)receiveOrder;

@end

@interface WMCustomWalletCalloutView : UIView

@property (nonatomic, strong) UIImage *distanceImage; // 地址
@property (nonatomic, copy) NSString *title; // 地址
@property (nonatomic, copy) NSString *subtitle; // 距离
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIButton *navigationButton; // 导航按钮
@property (nonatomic, strong) NSString * powerCount;
@property (nonatomic, strong) UIImage *powerCountImage;
@property (nonatomic, strong) UIImage * moneyImage;
@property (nonatomic, strong) NSString * moneyCount;

@property (nonatomic, weak) id<WMCustomWalletCalloutViewDelegate> delegate;
@property (nonatomic, copy) ReceiveOrder block;

@end
