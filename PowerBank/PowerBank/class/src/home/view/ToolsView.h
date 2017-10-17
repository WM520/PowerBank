//
//  ToolsView.h
//  PowerBank
//
//  Created by wangmiao on 2017/7/3.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ToolsViewDelegate <NSObject>

- (void)goToScanView;
//- (void)findNearbyPower;
- (void)openShare:(UIButton *)btn;
- (void)location;
- (void)hide:(UIButton *)btn;
@end


@interface ToolsView : UIView

@property (nonatomic, weak) id<ToolsViewDelegate> delegate;
@property (strong, nonatomic, readonly) UIButton *scanButton;
@property (strong, nonatomic, readonly) UIButton * shareButton;
@property (strong, nonatomic, readonly) UIButton * hiddenButton;

@end
