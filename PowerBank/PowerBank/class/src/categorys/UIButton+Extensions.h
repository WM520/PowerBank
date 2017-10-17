//
//  UIButton+Extensions.h
//  PowerBank
//
//  Created by wangmiao on 2017/7/4.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extensions)

+ (UIButton *_Nullable)createdbyBackImage:(NSString *_Nullable)backImage
                           title:(NSString *_Nullable)title
                      titleColor:(UIColor *_Nullable)titleColor
                           image:(NSString *_Nullable)image
                       addTarget:(nullable id)target
                          action:(SEL _Nullable )action
                forControlEvents:(UIControlEvents)controlEvents;

@end
