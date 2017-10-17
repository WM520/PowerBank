//
//  WMRequireAnnotation.h
//  PowerBank
//
//  Created by baiju on 2017/9/5.
//  Copyright © 2017年 wangmiao. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@class WMRequireModel;

@interface WMRequireAnnotation : MAPointAnnotation

@property (nonatomic, strong) WMRequireModel * model;

@end
