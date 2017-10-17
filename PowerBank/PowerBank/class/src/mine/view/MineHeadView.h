//
//  MineHeadView.h
//  PowerBank
//
//  Created by wangmiao on 2017/7/4.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMUserModel.h"

@protocol MineHeadViewDelegate <NSObject>

- (void)goToMineDetail;
- (void)goToMineWallet;
- (void)goToAuthenticationController;
- (void)goToCreditController;

@end


@interface MineHeadView : UIView

@property (nonatomic, weak) id<MineHeadViewDelegate> delegate;
@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) WMUserModel * model;

@end
