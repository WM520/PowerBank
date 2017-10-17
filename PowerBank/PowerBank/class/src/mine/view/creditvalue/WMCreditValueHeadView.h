//
//  WMCreditValueHeadView.h
//  PowerBank
//
//  Created by wangmiao on 2017/7/18.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WMUserModel;

@protocol WMCreditValueHeadViewDelegate <NSObject>

- (void)goToCreditController;

@end

@interface WMCreditValueHeadView : UIView

@property (nonatomic, weak) id<WMCreditValueHeadViewDelegate> delegate;
@property (nonatomic, strong) WMUserModel * model;

@end
