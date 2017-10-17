//
//  UIButton+Extensions.m
//  PowerBank
//
//  Created by wangmiao on 2017/7/4.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import "UIButton+Extensions.h"

@implementation UIButton (Extensions)

+ (UIButton *)createdbyBackImage:(NSString *)backImage
                           title:(NSString *)title
                      titleColor:(UIColor *)titleColor
                           image:(NSString *)image
                       addTarget:(nullable id)target
                          action:(SEL)action
                forControlEvents:(UIControlEvents)controlEvents{
    UIButton * button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:backImage] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    return button;
}

@end
