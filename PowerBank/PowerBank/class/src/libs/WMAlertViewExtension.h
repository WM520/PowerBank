//
//  WMAlertViewExtension.h
//  PowerBank
//
//  Created by baiju on 2017/8/9.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReturnMoney)(NSString * money);

@interface WMAlertViewExtension : UIView

- (instancetype)initWithTitle:(NSString *)title Msg:(NSString *)msg CancelBtnTitle:(NSString *)cancelBtnTtile OKBtnTitle:(NSString *)okBtnTitle Img:(UIImage *)img;
- (void)show;

@property (nonatomic, copy) ReturnMoney returnMoney;

@end
